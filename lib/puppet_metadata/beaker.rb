module PuppetMetadata
  # A class to provide abstractions for integration with beaker
  #
  # @see https://rubygems.org/gems/beaker
  # @see https://rubygems.org/gems/beaker-hostgenerator
  class Beaker
    # These images have an older systemd, which they work with
    # PIDFile parameter
    PIDFILE_COMPATIBLE_IMAGES = {
      'CentOS' => {
        '7' => 'centos:7.6.1810',
      },
      'Ubuntu' => {
        '16.04' => 'ubuntu:xenial-20191212',
      },
    }.freeze

    # There is no CentOS 8 image that works with PIDFile in systemd
    # unit files
    PIDFILE_INCOMPATIBLE = {
      'CentOS' => ['8'],
    }.freeze
    class << self
      # Convert an Operating System name with a release to a Beaker setfile
      #
      # @param [String] os
      #   The Operating System string as metadata.json knows it, which in turn is
      #   based on Facter's operatingsystem fact.
      # @param [String] release The OS release
      # @param [Boolean] use_fqdn
      #   Whether or not to use a FQDN, ensuring a domain
      # @param [Boolean, Array[String]] pidfile_workaround
      #   Whether or not to apply the systemd PIDFile workaround. This is only
      #   needed when the daemon uses PIDFile in its service file and using
      #   Docker as a Beaker hypervisor. This is to work around Docker's
      #   limitations.
      #   When a boolean, it's applied on applicable operating systems. On arrays
      #   it's applied only when os is included in the provided array.
      #
      # @return [nil] If no setfile is available
      # @return [Array<(String, String)>] The beaker setfile description with a readable name
      def os_release_to_setfile(os, release, use_fqdn: false, pidfile_workaround: false)
        return unless os_supported?(os)

        name = "#{os.downcase}#{release.tr('.', '')}-64"

        options = {}
        options[:hostname] = "#{name}.example.com" if use_fqdn

        # Docker messes up cgroups and some systemd versions can't deal with
        # that when PIDFile is used.
        if pidfile_workaround?(pidfile_workaround, os)
          return if PIDFILE_INCOMPATIBLE[os]&.include?(release)

          if (image = PIDFILE_COMPATIBLE_IMAGES.dig(os, release))
            options[:image] = image
          end
        end

        human_name = "#{os} #{release}"

        [build_setfile(name, options), human_name]
      end

      # Return whether a Beaker setfile can be generated for the given OS
      # @param [String] os The operating system
      def os_supported?(os)
        ['CentOS', 'Fedora', 'Debian', 'Ubuntu'].include?(os)
      end

      private

      def pidfile_workaround?(pidfile_workaround, os)
        pidfile_workaround && (!pidfile_workaround.is_a?(Array) || pidfile_workaround.include?(os))
      end

      def build_setfile(name, options)
        "#{name}#{options.any? ? "{#{options.map { |key, value| "#{key}=#{value}" }.join(',')}}" : ''}"
      end
    end
  end
end
