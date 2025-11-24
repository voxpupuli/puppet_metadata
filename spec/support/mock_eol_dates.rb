# frozen_string_literal: true

require 'json'

module PuppetMetadata
  module SpecSupport
    module MockEolDates
      def self.slice_versions(all_dates, os_name, versions)
        os_dates = all_dates.fetch(os_name, {})
        versions.each_with_object({}) do |version, acc|
          next unless os_dates.key?(version)

          acc[version] = os_dates[version]
        end
      end

      # Use the repo's canonical data file as the source of truth for EOL values,
      # but slice to a small, stable subset of OSes/versions used by unit tests.
      DEFAULT = begin
        data_file = File.expand_path('../../data/eol_dates.json', __dir__)
        all_dates = JSON.parse(File.read(data_file))

        {
          'AlmaLinux' => slice_versions(all_dates, 'AlmaLinux', %w[8 9 10]),
          'Amazon' => slice_versions(all_dates, 'Amazon', ['2018.03', '2.0', '2023']),
          'CentOS' => slice_versions(all_dates, 'CentOS', %w[7 8 9 10]),
          'Debian' => slice_versions(all_dates, 'Debian', %w[11 12 13]),
          'RedHat' => slice_versions(all_dates, 'RedHat', %w[7 8 9 10]),
          'Rocky' => slice_versions(all_dates, 'Rocky', %w[8 9 10]),
          'SLES' => slice_versions(all_dates, 'SLES', %w[11 12 12.5 15 15.5 15.6 15.7]),
          'Ubuntu' => slice_versions(all_dates, 'Ubuntu', %w[20.04 22.04 24.04 24.10 25.04 25.10]),
        }.freeze
      end

      def self.deep_dup(hash)
        JSON.parse(JSON.dump(hash))
      end
    end
  end
end

RSpec.shared_context 'with mock eol dates' do
  let(:mock_eol_dates) do
    PuppetMetadata::SpecSupport::MockEolDates.deep_dup(PuppetMetadata::SpecSupport::MockEolDates::DEFAULT)
  end

  before do
    stub_const('PuppetMetadata::OperatingSystem::EOL_DATES', mock_eol_dates)
  end
end
