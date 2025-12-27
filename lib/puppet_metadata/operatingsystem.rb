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

    # Load EOL dates from the JSON data file
    # The EOL dates are maintained in data/eol_dates.json and can be updated
    # automatically using the bin/update_eol_dates script
    # @see .eol_date
    EOL_DATES = JSON.parse(
      File.read(File.expand_path('../../data/eol_dates.json', __dir__)),
    ).freeze

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
      # @param [Date] at The date to check the EOL time. Today is used when nil.
      # @return [Array] All Operating System versions that aren't EoL
      def supported_releases(operatingsystem, at = nil)
        releases = EOL_DATES[operatingsystem]

        # return an empty array if one OS has zero dates
        # Happens for esoteric distros like windows, where we currently don't have any data in EOL_DATES
        return [] unless releases

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
