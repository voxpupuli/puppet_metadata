module PuppetMetadata
  # A class to provide abstractions for integration with beaker
  #
  # @see https://rubygems.org/gems/beaker
  # @see https://rubygems.org/gems/beaker-hostgenerator
  class Beaker
    class << self
      # modifies the operating system name to suit beaker-hostgenerator
      # @param [String] os
      # @return [String] the modified OS name
      def adjusted_os(os)
        case os
        when 'OracleLinux'
          'oracle'
        else
          os.downcase
        end
      end

      # Convert an Operating System name with a release to a Beaker setfile
      #
      # @param [String] os
      #   The Operating System string as metadata.json knows it, which in turn is
      #   based on Facter's operatingsystem fact.
      # @param [String] release The OS release
      # @param [Optional[String]] domain
      #   Enforce a domain to be appended to the hostname, making it an FQDN
      # @param [Optional[String]] puppet_version
      #   The desired puppet version. Will be appended to the hostname
      # @param [Optional[Hash]] hosts
      #   Key: hostname, Value: roles (roles string as defined by beaker-hostgenerator )
      #   Override the automatically generated hostname and optionally add roles
      #   If more than one entry this will generate multiple hosts in the setfile
      #   The domain may still be set via the `domain` param.
      #
      # @return [nil] If no setfile is available
      # @return [Array<(String, String)>] The beaker setfile description with a readable name
      def os_release_to_setfile(os, release, domain: nil, puppet_version: nil, hosts: nil)
        return unless os_supported?(os)

        aos = adjusted_os(os)
        name = "#{aos}#{release.tr('.', '')}-64"
        human_name = "#{os} #{release}"

        hosts_settings = []
        if hosts
          hosts.each do |hostname, roles|
            hosts_settings << {
              'name' => if roles
                          name + roles
                        elsif hosts.size > 1
                          hosts_settings.empty? ? "#{name}.ma" : "#{name}.a"
                        else
                          name
                        end,
              'hostname' => ((puppet_version.nil? || puppet_version == 'none') ? hostname : "#{hostname}-#{puppet_version}") + (domain ? ".#{domain}" : ''),
            }
          end
        else
          hosts_settings << {
            'name' => name,
            'hostname' => if puppet_version && puppet_version != 'none'
                            "#{name}-#{puppet_version}" + (domain ? ".#{domain}" : '')
                          elsif domain
                            name + (domain ? ".#{domain}" : '')
                          else
                            ''
                          end,
          }
        end

        options = {}

        setfile_parts = []
        hosts_settings.each do |host_settings|
          options[:hostname] = host_settings['hostname'] unless host_settings['hostname'].empty?
          setfile_parts << build_setfile(host_settings['name'], options)
        end

        [setfile_parts.join('-'), human_name]
      end

      # Return whether a Beaker setfile can be generated for the given OS
      # @param [String] os The operating system
      def os_supported?(os)
        %w[Archlinux CentOS Fedora Debian Ubuntu Rocky AlmaLinux OracleLinux].include?(os)
      end

      private

      def build_setfile(name, options)
        "#{name}#{"{#{options.map { |key, value| "#{key}=#{value}" }.join(',')}}" if options.any?}"
      end
    end
  end
end
