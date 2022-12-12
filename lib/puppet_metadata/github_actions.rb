module PuppetMetadata
  class GithubActions
    attr_reader :metadata
    attr_reader :options

    # @param [PuppetMetadata::Metadata] metadata
    # @param [Hash] options
    def initialize(metadata, options)
      @metadata = metadata
      @options  = options
    end

    # @return [Hash[Symbol, Any]] The outputs for Github Actions
    def outputs
      {
        beaker_setfiles: beaker_setfiles,
        puppet_major_versions: puppet_major_versions,
        puppet_unit_test_matrix: puppet_unit_test_matrix,
        github_action_test_matrix: github_action_test_matrix,
      }
    end

    private


    def beaker_setfiles
      setfiles = []
      metadata.beaker_setfiles(use_fqdn: options[:beaker_use_fqdn], pidfile_workaround: options[:beaker_pidfile_workaround], domain: options[:domain]) do |setfile, name|
        setfiles << {
          name: name,
          value: setfile,
        }
      end
      setfiles
    end

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

      metadata.operatingsystems.each do |os, releases|
        case os
        when 'Archlinux', 'Gentoo'
          yield [os, 'rolling', majors.max_by { |v| v[:value] }]
        else
          releases&.each do |release|
            majors.each do |puppet_version|
              if AIO.has_aio_build?(os, release, puppet_version[:value])
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
        setfile = PuppetMetadata::Beaker.os_release_to_setfile(
          os, release, use_fqdn: options[:beaker_use_fqdn], pidfile_workaround: options[:beaker_pidfile_workaround], domain: options[:domain], puppet_version: puppet_version[:collection]
        )
        next unless setfile
        next if puppet_version_below_minimum?(puppet_version[:value])

        matrix_include << {
          setfile: {
            name: setfile[1],
            value: setfile[0],
          },
          puppet: puppet_version
        }
      end

      matrix_include
    end

    def puppet_version_below_minimum?(version)
      return false unless options[:minimum_major_puppet_version]

      Gem::Version.new(version) < Gem::Version.new(options[:minimum_major_puppet_version])
    end
  end
end
