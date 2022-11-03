module PuppetMetadata
  class GithubActions
    attr_reader :metadata

    # @param [PuppetMetadata::Metadata] metadata
    def initialize(metadata)
      @metadata = metadata
    end

    # @return [Hash[Symbol, Any]] The outputs for Github Actions
    def outputs(beaker_use_fqdn: false, beaker_pidfile_workaround: false, minimum_major_puppet_version: nil)
      {
        beaker_setfiles: beaker_setfiles(beaker_use_fqdn, beaker_pidfile_workaround),
        puppet_major_versions: puppet_major_versions(minimum_major_puppet_version),
        puppet_unit_test_matrix: puppet_unit_test_matrix(minimum_major_puppet_version),
        github_action_test_matrix: github_action_test_matrix(use_fqdn: beaker_use_fqdn, pidfile_workaround: beaker_pidfile_workaround, minimum_major_puppet_version: minimum_major_puppet_version),
      }
    end

    private

    def beaker_setfiles(use_fqdn, pidfile_workaround)
      setfiles = []
      metadata.beaker_setfiles(use_fqdn: use_fqdn, pidfile_workaround: pidfile_workaround) do |setfile, name|
        setfiles << {
          name: name,
          value: setfile,
        }
      end
      setfiles
    end

    def puppet_major_versions(minimum_major_puppet_version)
      metadata.puppet_major_versions.sort.reverse.map do |version|
        next if minimum_major_puppet_version && Gem::Version.new(minimum_major_puppet_version) > Gem::Version.new(version)

        {
          name: "Puppet #{version}",
          value: version,
          collection: "puppet#{version}",
        }
      end.compact
    end

    def puppet_unit_test_matrix(minimum_major_puppet_version)
      metadata.puppet_major_versions.sort.reverse.map do |puppet|
        ruby = PuppetMetadata::AIO::PUPPET_RUBY_VERSIONS[puppet]
        next unless ruby
        next if minimum_major_puppet_version && Gem::Version.new(minimum_major_puppet_version) > Gem::Version.new(puppet)

        {
          puppet: puppet,
          ruby: ruby,
        }
      end.compact
    end

    def beaker_os_releases(minimum_major_puppet_version)
      majors = puppet_major_versions(minimum_major_puppet_version)

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

    def github_action_test_matrix(use_fqdn: false, pidfile_workaround: false, minimum_major_puppet_version: nil)
      matrix_include = []

      beaker_os_releases(minimum_major_puppet_version) do |os, release, puppet_version|
        setfile = PuppetMetadata::Beaker.os_release_to_setfile(os, release, use_fqdn: use_fqdn, pidfile_workaround: pidfile_workaround)
        next unless setfile
        next if minimum_major_puppet_version && Gem::Version.new(minimum_major_puppet_version) > Gem::Version.new(puppet_version[:value])

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
  end
end
