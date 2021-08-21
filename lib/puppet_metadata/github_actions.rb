module PuppetMetadata
  class GithubActions
    attr_reader :metadata

    # @param [PuppetMetadata::Metadata] metadata
    def initialize(metadata)
      @metadata = metadata
    end

    # @return [Hash[Symbol, Any]] The outputs for Github Actions
    def outputs(beaker_use_fqdn: false, beaker_pidfile_workaround: false)
      {
        beaker_setfiles: beaker_setfiles(beaker_use_fqdn, beaker_pidfile_workaround),
        puppet_major_versions: puppet_major_versions,
        puppet_unit_test_matrix: puppet_unit_test_matrix,
        github_action_test_matrix: github_action_test_matrix(use_fqdn: beaker_use_fqdn, pidfile_workaround: beaker_pidfile_workaround),
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

    def puppet_major_versions
      metadata.puppet_major_versions.sort.reverse.map do |version|
        {
          name: "Puppet #{version}",
          value: version,
          collection: "puppet#{version}",
        }
      end
    end

    def puppet_unit_test_matrix
      metadata.puppet_major_versions.sort.reverse.map do |puppet|
        ruby = puppet_ruby_version(puppet)
        next unless ruby

        {
          puppet: puppet,
          ruby: ruby,
        }
      end.compact
    end

    def puppet_ruby_version(puppet_version)
      case puppet_version
      when 4
        '2.1'
      when 5
        '2.4'
      when 6
        '2.5'
      when 7
        '2.7'
      end
    end


    def github_action_test_matrix(use_fqdn: false, pidfile_workaround: false)
      matrix_include = []

      metadata.operatingsystems.each do |os, releases|
        releases&.each do |release|
          puppet_major_versions.each do |puppet_version|
            next unless AIO.has_aio_build?(os, release, puppet_version[:value])

            setfile = PuppetMetadata::Beaker.os_release_to_setfile(os, release, use_fqdn: use_fqdn, pidfile_workaround: pidfile_workaround)
            next unless setfile

            matrix_include << {
              setfile: {
                name: setfile[1],
                value: setfile[0],
              },
              puppet: puppet_version
            }
          end
        end
      end

      matrix_include
    end
  end
end
