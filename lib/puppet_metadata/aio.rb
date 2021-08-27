module PuppetMetadata
  class AIO 
    COMPATIBLE = {
      'AlmaLinux'   => 'RedHat',
      'Amazon'      => 'RedHat',
      'CentOS'      => 'RedHat',
      'OracleLinux' => 'RedHat',
      'Rocky'       => 'RedHat',
      'Scientific'  => 'RedHat',
    }

    BUILDS = { 
      # RPM-based
      'RedHat' => {
        '5' => 5..7,
        '6' => 5..7,
        '7' => 5..7,
        '8' => 6..7,
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
      },
      'SLES' => {
        '11' => [7],
        '12' => [7],
        '15' => [7],
      },
      # deb-based
      'Debian' => {
        '7' => [5],
        '8' => 5..6,
        '9' => 5..7,
        '10' => 5..7,
        '11' => 6..7,
      },
      'Ubuntu' => {
        '14.04' => 5..6,
        '16.04' => 5..7,
        '18.04' => 5..7,
        '20.04' => 6..7,
      },
    }

    def self.find_base_os(os)
      COMPATIBLE.fetch(os, os)
    end

    def self.has_aio_build?(os, release, puppet_version)
      BUILDS.dig(find_base_os(os), release)&.include?(puppet_version)
    end
  end
end
