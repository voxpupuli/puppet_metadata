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

    def self.has_acceptance_tests?
      ENV['PUPPET_METADATA_FORCE_ACCEPTANCE'] || Dir[File.join('spec', 'acceptance', '**', '*_spec.rb')].any?
    end

    private

    def beaker_setfiles(use_fqdn, pidfile_workaround)
      setfiles = []
      return setfiles unless GithubActions.has_acceptance_tests?

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
        ruby = PuppetMetadata::AIO::PUPPET_RUBY_VERSIONS[puppet]
        next unless ruby

        {
          puppet: puppet,
          ruby: ruby,
        }
      end.compact
    end

    def github_action_test_matrix(use_fqdn: false, pidfile_workaround: false)
      return [] unless GithubActions.has_acceptance_tests?

      metadata.operatingsystems.each_with_object([]) do |(os, releases), matrix_include|
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
    end
  end
end
