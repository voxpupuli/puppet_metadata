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
        '5' => 5..7,
        '6' => 5..7,
        '7' => 5..8,
        '8' => 5..8,
        '9' => 6..8,
      },
      'Fedora' => {
        '26' => [5],
        '27' => 5..6,
        '28' => 5..6,
        '29' => 5..6,
        '30' => 5..7,
        '31' => 5..7,
        '32' => 6..7,
        '34' => 6..7,
        '36' => 7..8,
      },
      'SLES' => {
        '11' => [7],
        '12' => 7..8,
        '15' => 7..8,
      },
      # deb-based
      'Debian' => {
        '7' => [5],
        '8' => 5..6,
        '9' => 5..7,
        '10' => 5..8,
        '11' => 6..8,
      },
      'Ubuntu' => {
        '14.04' => 5..6,
        '16.04' => 5..7,
        '18.04' => 5..8,
        '20.04' => 6..8,
        '22.04' => 6..8,
      },
    }.freeze

    PUPPET_RUBY_VERSIONS = {
      4 => '2.1',
      5 => '2.4',
      6 => '2.5',
      7 => '2.7',
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
