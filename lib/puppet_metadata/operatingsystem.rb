# frozen_string_literal: true

require 'date'

module PuppetMetadata
  # An abstraction layer over operating systems. Mostly to determine End Of
  # Life dates.
  #
  # @see https://endoflife.software/operating-systems
  class OperatingSystem
    # please add new OSes sorted alphabetically

    # The EOL dates for the various operating systems
    # @see .eol_date
    EOL_DATES = {
      # https://wiki.almalinux.org/release-notes/
      'AlmaLinux' => {
        '9' => '2032-05-31',
        '8' => '2029-05-31',
      },
      # https://endoflife.software/operating-systems/linux/centos
      'CentOS' => {
        '9' => nil, # EOL Date is not yet announced.
        '8' => '2024-05-31',
        '7' => '2024-06-30',
        '6' => '2020-11-30',
        '5' => '2017-03-31',
        '4' => '2012-02-29',
        '3' => '2010-10-30',
      },
      # https://wiki.debian.org/DebianReleases
      'Debian' => {
        # TODO: EOL is standard support, not the extended life cycle
        '12' => nil, # '~2026',
        '11' => '2024-08-14',
        '10' => '2022-09-10',
        '9' => '2020-07-06',
        '8' => '2018-06-17',
        '7' => '2016-04-26',
        '6' => '2015-05-31',
        '5' => '2012-02-06',
        '4' => '2010-02-15',
        '3.1' => '2008-03-31',
        '3.0' => '2006-06-30',
        '2.2' => '2003-06-30',
        '2.1' => '2000-09-30',
      },
      # https://endoflife.date/oraclelinux
      'OracleLinux' => {
        '9' => '2032-06-30',
        '8' => '2029-07-01',
        '7' => '2024-12-31',
      },
      # https://docs.fedoraproject.org/en-US/releases/eol/
      'Fedora' => {
        '41' => nil,
        '40' => nil,
        '39' => nil,
        '38' => '2024-05-21',
        '37' => '2023-12-05',
        '36' => '2023-05-16',
        '35' => '2022-12-13',
        '34' => '2022-06-07',
        '33' => '2021-11-30',
        '32' => '2021-05-25',
        '31' => '2020-11-24',
        '30' => '2020-05-26',
        '29' => '2019-11-26',
        '28' => '2019-05-28',
        '27' => '2018-11-30',
        '26' => '2018-05-29',
        '25' => '2017-12-12',
        '24' => '2017-08-08',
        '23' => '2016-12-20',
        '22' => '2016-07-19',
        '21' => '2015-12-01',
        '20' => '2015-06-23',
        '19' => '2015-01-06',
        '18' => '2014-01-14',
        '17' => '2013-07-30',
        '16' => '2013-02-12',
        '15' => '2012-06-26',
        '14' => '2011-12-08',
        '13' => '2011-06-24',
        '12' => '2010-12-02',
        '11' => '2010-06-25',
        '10' => '2009-12-18',
        '9' => '2009-07-10',
        '8' => '2009-01-07',
        '7' => '2008-06-13',
        '6' => '2007-12-07',
        '5' => '2007-07-02',
        '4' => '2006-08-07',
        '3' => '2006-01-16',
        '2' => '2005-04-11',
        '1' => '2004-09-20',
      },
      # https://endoflife.software/operating-systems/unix-like-bsd/freebsd
      'FreeBSD' => {
        '13' => '2026-01-31',
        '12' => '2024-06-30',
        '11' => '2021-09-30',
        '10' => '2018-10-31',
        '9' => '2016-12-31',
        '8' => '2015-08-01',
        '7' => '2013-02-28',
        '6' => '2010-11-30',
        '5' => '2008-05-31',
        '4' => '2007-01-31',
      },
      # https://endoflife.software/operating-systems/linux/red-hat-enterprise-linux-rhel
      'RedHat' => {
        # TODO: EOL is standard support, not the extended life cycle
        '8' => '2029-05-31',
        '7' => '2024-06-30',
        '6' => '2020-11-30',
        '5' => '2017-03-31',
        '4' => '2012-02-29',
        '3' => '2010-10-31',
      },
      # https://wiki.rockylinux.org/rocky/version/
      'Rocky' => {
        '9' => '2032-05-31',
        '8' => '2029-05-31',
      },
      # https://endoflife.software/operating-systems/linux/ubuntu
      'Ubuntu' => {
        '24.04' => '2029-04-30',
        '22.04' => '2027-04-15',
        '21.10' => '2022-07-15',
        '20.10' => '2021-07-15',
        '20.04' => '2025-04-15',
        '19.10' => '2020-07-15',
        '19.04' => '2020-01-15',
        '18.10' => '2019-07-15',
        '18.04' => '2023-05-31',
        '17.10' => '2018-07-15',
        '17.04' => '2018-01-15',
        '16.10' => '2017-07-20',
        '16.04' => '2021-04-15',
        '15.10' => '2016-07-28',
        '15.04' => '2016-02-04',
        '14.10' => '2015-07-23',
        '14.04' => '2019-04-15',
        '13.10' => '2014-07-17',
        '13.04' => '2014-01-27',
        '12.04' => '2017-04-28',
        '11.10' => '2013-05-09',
        '11.04' => '2012-10-28',
        '10.10' => '2012-04-10',
        '10.04' => '2015-04-30',
        '9.10' => '2011-04-30',
        '9.04' => '2010-10-23',
        '8.10' => '2010-04-30',
        '8.04' => '2013-05-09',
        '7.10' => '2009-04-18',
        '7.04' => '2008-10-19',
        '6.10' => '2008-04-26',
        '6.06' => '2011-06-01',
        '5.10' => '2007-04-13',
        '5.04' => '2006-10-31',
        '4.10' => '2006-04-30',
      },
    }.freeze

    class << self
      # Return the EOL date for the given operating system release
      # @param [String] operatingsystem
      #   The operating system
      # @param [String] release
      #   The major version of the operating system
      # @return [optional, Date]
      #   The EOL date for the given operating system release. Nil is returned
      #   when the either when the OS, the release or the EOL date is unknown
      def eol_date(operatingsystem, release)
        releases = EOL_DATES[operatingsystem]
        return unless releases

        date = releases[release]
        return unless date

        Date.parse(date)
      end

      # Return whether the given operating system release is EOL at the given
      # date
      #
      # @param [String] operatingsystem
      #   The operating system
      # @param [String] release
      #   The major version of the operating system
      # @return [Boolean]
      #   The EOL date for the given operating system release. Nil is returned
      #   when the either when the OS, the release or the EOL date is unknown
      def eol?(operatingsystem, release, at = nil)
        date = eol_date(operatingsystem, release)
        date && date < (at || Date.today)
      end

      # Return the latest known release for a given operating system
      # @param [String] operatingsystem The operating system
      # @return [optional, String]
      #   The latest major release for the given operating system, if any is
      #   known
      def latest_release(operatingsystem)
        releases = EOL_DATES[operatingsystem]
        releases&.keys&.max_by { |release| Gem::Version.new(release) }
      end

      # Return an array of all Operating System versions that aren't EoL
      # @param [String] operatingsystem The operating system
      # @return [Array] All Operating System versions that aren't EoL today
      def supported_releases(operatingsystem)
        releases = EOL_DATES[operatingsystem]
        today = Date.today
        releases.select { |_release, eol_date| !eol_date || Date.parse(eol_date) > today }.keys
                .sort_by { |release| Gem::Version.new(release) }
      end

      # Return the Puppet major version in an OS release, if any
      #
      # Only tracks releases without an AIO build, since that's preferred.
      #
      # @param [String] operatingsystem
      #   The operating system name
      # @param [String] release
      #   The operating system release version
      #
      # @return [Optional[Integer]] The Puppet major version, if any
      def os_release_puppet_version(operatingsystem, release)
        case operatingsystem
        when 'Fedora'
          case release
          when '39', '40'
            8
          when '37', '38'
            7
          end
        end
      end
    end
  end
end
