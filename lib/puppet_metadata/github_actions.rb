module PuppetMetadata
  class GithubActions
    attr_reader :metadata, :options

    # @param [PuppetMetadata::Metadata] metadata
    # @param [Hash] options
    def initialize(metadata, options)
      @metadata = metadata
      @options  = options
    end

    # @return [Hash[Symbol, Any]] The outputs for Github Actions
    def outputs
      {
        puppet_major_versions: puppet_major_versions,
        puppet_unit_test_matrix: puppet_unit_test_matrix,
        github_action_test_matrix: github_action_test_matrix,
      }
    end

    private

    def puppet_major_versions
      metadata.puppet_major_versions.sort.reverse.map do |version|
        next if puppet_version_below_minimum?(version)

        {
          name: "Puppet #{version}",
          value: version,
          collection: "puppet#{version}",
        }
      end.compact
    end

    def puppet_unit_test_matrix
      metadata.puppet_major_versions.sort.reverse.map do |puppet|
        ruby = PuppetMetadata::AIO::PUPPET_RUBY_VERSIONS[puppet]
        next unless ruby
        next if puppet_version_below_minimum?(puppet)

        {
          puppet: puppet,
          ruby: ruby,
        }
      end.compact
    end

    def beaker_os_releases
      majors = puppet_major_versions

      distro_puppet_version = {
        name: 'Distro Puppet',
        value: nil, # We don't know the version and since it's rolling, it can be anything
        collection: 'none',
      }

      metadata.operatingsystems.each do |os, releases|
        case os
        when 'Archlinux', 'Gentoo'
          yield [os, 'rolling', distro_puppet_version]
        else
          releases&.each do |release|
            majors.each do |puppet_version|
              if AIO.has_aio_build?(os, release, puppet_version[:value]) # rubocop:disable Style/IfUnlessModifier
                yield [os, release, puppet_version]
              end
            end
          end
        end
      end
    end

    def github_action_test_matrix
      matrix_include = []

      beaker_os_releases do |os, release, puppet_version|
        next if puppet_version_below_minimum?(puppet_version[:value])

        setfile = os_release_to_beaker_setfile(os, release, puppet_version[:collection])
        next unless setfile

        matrix_include << {
          name: "#{puppet_version[:name]} - #{setfile[1]}",
          setfile: {
            name: setfile[1],
            value: setfile[0],
          },
          puppet: puppet_version,
        }
      end

      matrix_include
    end

    def puppet_version_below_minimum?(version)
      return false unless version && options[:minimum_major_puppet_version]

      Gem::Version.new(version) < Gem::Version.new(options[:minimum_major_puppet_version])
    end

    def os_release_to_beaker_setfile(os, release, puppet_collection)
      PuppetMetadata::Beaker.os_release_to_setfile(
        os,
        release,
        use_fqdn: options[:beaker_use_fqdn],
        pidfile_workaround: options[:beaker_pidfile_workaround],
        domain: options[:domain],
        puppet_version: puppet_collection,
      )
    end
  end
end
