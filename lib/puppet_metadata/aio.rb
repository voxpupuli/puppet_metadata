module PuppetMetadata
  class AIO
    COMPATIBLE = {
      'AlmaLinux' => 'RedHat',
      'Amazon' => 'RedHat',
      'CentOS' => 'RedHat',
      'OracleLinux' => 'RedHat',
      'Rocky' => 'RedHat',
      'Scientific' => 'RedHat',
    }.freeze

    BUILDS = {
      # RPM-based
      'RedHat' => {
        '8' => [8],
        '9' => [8],
      },
      'Fedora' => {
        '36' => [8],
        '40' => [8],
      },
      'SLES' => {
        '15' => [8],
      },
      # deb-based
      'Debian' => {
        '11' => [8],
        '12' => [8],
      },
      'Ubuntu' => {
        '20.04' => [8],
        '22.04' => [8],
        '24.04' => [8],
      },
    }.freeze

    PUPPET_RUBY_VERSIONS = {
      8 => '3.2',
    }.freeze

    class << self
      def find_base_os(os)
        COMPATIBLE.fetch(os, os)
      end

      def has_aio_build?(os, release, puppet_version)
        BUILDS.dig(find_base_os(os), release)&.include?(puppet_version)
      end
    end
  end
end
