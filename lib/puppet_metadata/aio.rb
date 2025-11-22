module PuppetMetadata
  class AIO
    COMPATIBLE = {
      'AlmaLinux' => 'RedHat',
      'CentOS' => 'RedHat',
      'OracleLinux' => 'RedHat',
      'Rocky' => 'RedHat',
      'Scientific' => 'RedHat',
    }.freeze

    PUPPET_BUILDS = {
      # RPM-based
      'RedHat' => {
        '7' => 7..8,
        '8' => 7..8,
        '9' => 7..8,
      },
      'Fedora' => {
        '36' => 7..8,
        '40' => 7..8,
      },
      'SLES' => {
        '11' => [7],
        '12' => 7..8,
        '15' => 7..8,
      },
      # deb-based
      'Debian' => {
        '11' => 7..8,
        '12' => 7..8,
      },
      'Ubuntu' => {
        '20.04' => 7..8,
        '22.04' => 7..8,
        '24.04' => 7..8,
      },
    }.freeze

    OPENVOX_BUILDS = PUPPET_BUILDS.merge({
                                           # RPM-based
                                           'Amazon' => {
                                             '2023' => [8],
                                           },
                                           'RedHat' => {
                                             '7' => 7..8,
                                             '8' => 7..8,
                                             '9' => 7..8,
                                             '10' => 7..8,
                                           },
                                           'Debian' => {
                                             '11' => 7..8,
                                             '12' => 7..8,
                                             '13' => [8],
                                           },
                                         }).freeze

    PUPPET_RUBY_VERSIONS = {
      7 => '2.7',
      8 => '3.2',
    }.freeze

    OPENVOX_RUBY_VERSIONS = PUPPET_RUBY_VERSIONS

    class << self
      def find_base_os(os)
        COMPATIBLE.fetch(os, os)
      end

      def has_aio_build?(os, release, puppet_version, requirement)
        builds = (requirement == 'openvox') ? OPENVOX_BUILDS : PUPPET_BUILDS
        builds.dig(find_base_os(os), release)&.include?(puppet_version)
      end
    end
  end
end
