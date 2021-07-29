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
        known_bad_combinations: known_bad_combinations(beaker_setfiles(beaker_use_fqdn, beaker_pidfile_workaround), puppet_major_versions),
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

    def known_bad_combinations(beaker_setfiles, puppet_major_versions)
      supporder_versions = {
        'CentOS 5'     => 5..7,
        'CentOS 6'     => 5..7,
        'CentOS 7'     => 5..7,
        'CentOS 8'     => 5..7,
        'Debian 7'     => [5],
        'Debian 8'     => 5..7,
        'Debian 9'     => 5..7,
        'Debian 10'    => 5..7,
        'Ubuntu 14.04' => 5..6,
        'Ubuntu 16.04' => 5..7,
        'Ubuntu 18.04' => 5..7,
        'Ubuntu 20.04' => 6..7,
      }

      known_bad = []
      beaker_setfiles.each do |setfile|
        puppet_major_versions.each do |puppet|
          if !supporder_versions[setfile[:name]] || !supporder_versions[setfile[:name]].include?(puppet[:value])
            known_bad << {
              setfile: setfile,
              puppet: puppet,
            }
          end
        end
      end
      known_bad
    end
  end
end
