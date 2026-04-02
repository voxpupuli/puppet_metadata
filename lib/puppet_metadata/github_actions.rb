module PuppetMetadata
  class GithubActions
    attr_reader :metadata, :options

    # @param [PuppetMetadata::Metadata] metadata
    # @param [Hash] options
    def initialize(metadata, options)
      @metadata = metadata
      @options  = options
    end

    # @param [Date] at
    #   The date when to generate the outputs. This affects the acceptance test
    #   matrix, which excludes EOL operating systems. Its primary purpose is
    #   reliable (unit) tests which don't break over time.
    # @return [Hash[Symbol, Any]] The outputs for Github Actions
    def outputs(at = nil)
      {
        puppet_unit_test_matrix: puppet_unit_test_matrix,
        puppet_beaker_test_matrix: puppet_beaker_test_matrix(at),
      }
    end

    private

    def beaker_major_versions
      metadata.requirements_with_major_versions.flat_map do |requirement, versions|
        versions.sort.reverse.filter_map do |version|
          next if requirement_name_version_below_minimum?(version)

          label = (requirement == 'openvox') ? 'OpenVox' : requirement.capitalize

          {
            name: "#{label} #{version}",
            value: version,
            collection: "#{requirement}#{version}",
            requirement: requirement,
          }
        end
      end
    end

    def puppet_unit_test_matrix
      majors = metadata.requirements_with_major_versions.first[1]
      majors.sort.reverse.map do |puppet|
        ruby = PuppetMetadata::AIO::PUPPET_RUBY_VERSIONS[puppet]
        next unless ruby
        next if requirement_name_version_below_minimum?(puppet)

        {
          puppet: puppet,
          ruby: ruby,
        }
      end.compact
    end

    def beaker_os_releases(at = nil)
      majors = beaker_major_versions
      # for staging, we don't want to have one job per major openvox/puppet version
      # we just want to pull a specific, unreleased, package from a webserver
      # and we only do this for AIO builds, because we don't have other packages
      collection = options[:collection]
      collection = nil if collection&.empty?
      if collection == 'staging'
        latest = majors.first.dup
        latest[:collection] = 'staging'
        metadata.operatingsystems.each do |os, releases|
          # iterates on all releases for one OS
          # `&` in case the OS has no releases in metadata.json
          releases&.each do |release|
            next if PuppetMetadata::OperatingSystem.eol?(os, release, at)

            yield [os, release, latest] if AIO.has_aio_build?(os, release, latest[:value], latest[:requirement])
          end
        end
      else
        distro_puppet_version = {
          name: 'Distro Puppet',
          value: nil, # We don't know the version and since it's rolling, it can be anything
          collection: 'none',
          requirement: 'puppet',
        }
        metadata.operatingsystems.each do |os, releases|
          case os
          when 'Archlinux', 'Gentoo'
            # we filter out the rolling distributions because we don't know which openvox/puppet version we get and we want a specific collection
            next if collection

            # both currently only ship puppet, not openvox yet
            yield [os, 'rolling', distro_puppet_version]
          else
            releases&.each do |release|
              if PuppetMetadata::OperatingSystem.eol?(os, release, at)
                message = "Skipping EOL operating system #{os} #{release}"

                if ENV.key?('GITHUB_ACTIONS')
                  # TODO: determine file and position within the file
                  puts "::warning file=metadata.json::#{message}"
                else
                  warn message
                end

                next
              end

              majors.each do |puppet_version|
                # if a collection is set, it's not 'staging'
                # we then want to filter out all results that don't match our provided collection
                next if collection && puppet_version[:collection] != collection

                if AIO.has_aio_build?(os, release, puppet_version[:value], puppet_version[:requirement])
                  yield [os, release, puppet_version]
                elsif PuppetMetadata::OperatingSystem.os_release_puppet_version(os, release) == puppet_version[:value]
                  yield [os, release, distro_puppet_version.merge(value: puppet_version[:value])]
                end
              end
            end
          end
        end
      end
    end

    def puppet_beaker_test_matrix(at)
      matrix_include = []

      beaker_os_releases(at) do |os, release, implementation|
        next if requirement_name_version_below_minimum?(implementation[:value])

        setfile = os_release_to_beaker_setfile(os, release, implementation[:collection])
        next unless setfile

        name = "#{implementation[:name]} - #{setfile[1]}"
        env = {
          'BEAKER_PUPPET_COLLECTION' => implementation[:collection],
          'BEAKER_SETFILE' => setfile[0],
        }

        if options[:beaker_facter]
          fact, label, values = options[:beaker_facter]
          values.each do |value|
            matrix_include << {
              name: "#{name} - #{label || fact} #{value}",
              env: env.merge("BEAKER_FACTER_#{fact}" => value),
            }
          end
        else
          matrix_include << {
            name: name,
            env: env,
          }
        end
      end

      matrix_include
    end

    def requirement_name_version_below_minimum?(version)
      return false unless version && options[:minimum_major_puppet_version]

      Gem::Version.new(version) < Gem::Version.new(options[:minimum_major_puppet_version])
    end

    def os_release_to_beaker_setfile(os, release, puppet_collection)
      PuppetMetadata::Beaker.os_release_to_setfile(
        os,
        release,
        domain: options[:domain],
        puppet_version: puppet_collection,
        hosts: options[:beaker_hosts],
      )
    end
  end
end
