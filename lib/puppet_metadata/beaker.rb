module PuppetMetadata
  class Beaker
    def self.os_release_to_setfile(os, release, use_fqdn: false, pidfile_workaround: false)
      return unless os_supported?(os)

      name = "#{os.downcase}#{release.tr('.', '')}-64"

      options = {}
      options[:hostname] = "#{name}.example.com" if use_fqdn
      # Docker messes up cgroups and modern systemd can't deal with that when
      # PIDFile is used.
      if pidfile_workaround
        case os
        when 'CentOS'
          options[:image] = 'centos:7.6.1810' if release == '7'
        when 'Ubuntu'
          options[:image] = 'ubuntu:xenial-20191212' if release == '16.04'
        end
      end

      setfile = name
      setfile += "{#{options.map { |key, value| "#{key}=#{value}" }.join(',')}}" if options.any?
      setfile
    end

    def self.os_supported?(os)
      ['CentOS', 'Fedora', 'Debian', 'Ubuntu'].include?(os)
    end
  end
end
