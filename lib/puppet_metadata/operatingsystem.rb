# frozen_string_literal: true

require 'date'
require 'json'

module PuppetMetadata
  # An abstraction layer over operating systems. Mostly to determine End Of
  # Life dates.
  #
  # @see https://endoflife.software/operating-systems
  class OperatingSystem
    # please add new OSes sorted alphabetically

    # The EOL dates are maintained in data/eol_dates.json and can be updated
    # automatically using the bin/update_eol_dates script.
    #
    # Lazy load the JSON data to minimize disk I/O and JSON parsing.
    EOL_DATES_FILE = File.expand_path('../../data/eol_dates.json', __dir__).freeze

    def self.const_missing(name)
      return super unless name == :EOL_DATES

      dates = JSON.parse(File.read(EOL_DATES_FILE)).freeze
      const_set(:EOL_DATES, dates)
    end

    def self.reset_eol_dates_cache!
      remove_const(:EOL_DATES) if const_defined?(:EOL_DATES, false)
      nil
    end

    class << self
      def ubuntu_lts_version?(release)
        # Ubuntu LTS releases are even-year April releases (e.g. 22.04, 24.04).
        match = release.match(/^([0-9]+)\.04$/)
        return false unless match

        year = match[1].to_i
        year.even?
      end

      def sles_major_version?(release)
        release.match?(/^\d+$/)
      end

      # Return the EOL date for the given operating system release
      # @param [String] operatingsystem
      #   The operating system
      # @param [String] release
      #   The major version of the operating system
      # @return [optional, Date]
      #   The EOL date for the given operating system release. Nil is returned
      #   when the either when the OS, the release or the EOL date is unknown
      def eol_date(operatingsystem, release)
        releases = OperatingSystem::EOL_DATES[operatingsystem]
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
        releases = OperatingSystem::EOL_DATES[operatingsystem]
        return unless releases

        keys = releases.keys
        keys = keys.select { |release| ubuntu_lts_version?(release) } if operatingsystem == 'Ubuntu'
        keys = keys.select { |release| sles_major_version?(release) } if operatingsystem == 'SLES'
        keys.max_by { |release| Gem::Version.new(release) }
      end

      # Return an array of all Operating System versions that aren't EoL
      # @param [String] operatingsystem The operating system
      # @param [Date] at The date to check the EOL time. Today is used when nil.
      # @return [Array] All Operating System versions that aren't EoL
      def supported_releases(operatingsystem, at = nil)
        releases = OperatingSystem::EOL_DATES[operatingsystem]

        # return an empty array if one OS has zero dates
        # Happens for esoteric distros like windows, where we currently don't have any data in EOL_DATES
        return [] unless releases

        releases = releases.select { |release, _eol_date| ubuntu_lts_version?(release) } if operatingsystem == 'Ubuntu'
        releases = releases.select { |release, _eol_date| sles_major_version?(release) } if operatingsystem == 'SLES'

        at ||= Date.today
        releases.select { |_release, eol_date| !eol_date || Date.parse(eol_date) > at }.keys
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
