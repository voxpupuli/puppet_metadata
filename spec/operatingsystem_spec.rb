# frozen_string_literal: true

require 'spec_helper'

describe PuppetMetadata::OperatingSystem do
  # Mock EOL dates for stable tests
  let(:mock_eol_dates) do
    {
      'CentOS' => {
        '10' => '2030-01-01',
        '9' => '2027-05-31',
        '8' => '2024-05-31',
        '7' => '2024-06-30',
      },
      'Ubuntu' => {
        '24.10' => '2026-07-10',
        '24.04' => '2029-04-25',
        '22.04' => '2027-04-01',
        '20.04' => '2024-05-31',
      },
      'Debian' => {
        '13' => '2028-08-09',
        '12' => '2026-06-10',
        '11' => '2024-08-14',
      },
      'Rocky' => {
        '10' => '2035-05-31',
        '9' => '2032-05-31',
        '8' => '2029-05-31',
      },
      'AlmaLinux' => {
        '10' => '2035-05-31',
        '9' => '2032-05-31',
        '8' => '2029-03-01',
      },
    }
  end

  before do
    stub_const('PuppetMetadata::OperatingSystem::EOL_DATES', mock_eol_dates)
  end

  describe 'latest_release' do
    it 'returns nil for an unknown os' do
      expect(described_class.latest_release('DoesNotExist')).to be_nil
    end

    it 'returns 10 for CentOS' do
      expect(described_class.latest_release('CentOS')).to eq('10')
    end

    it 'returns 24.10 for Ubuntu' do
      expect(described_class.latest_release('Ubuntu')).to eq('24.10')
    end
  end

  describe 'supported_releases' do
    context 'with CentOS' do
      let(:os) { 'CentOS' }

      it 'returns 9 & 10' do
        expect(described_class.supported_releases(os)).to contain_exactly('9', '10')
      end

      it 'the last entry matches latest_release' do
        expect(described_class.supported_releases(os).last).to eq(described_class.latest_release(os))
      end
    end

    context 'with CentOS and a date in the past' do
      let(:os) { 'CentOS' }
      let(:date) { Date.parse('2025-04-15') }

      it 'returns 9 and 10' do
        expect(described_class.supported_releases(os, date)).to match_array(%w[9 10])
      end

      it 'the last entry matches latest_release' do
        expect(described_class.supported_releases(os).last).to eq(described_class.latest_release(os))
      end
    end

    context 'with Ubuntu' do
      let(:os) { 'Ubuntu' }

      it 'returns 22.04, 24.04, and 24.10' do
        expect(described_class.supported_releases(os)).to contain_exactly('22.04', '24.04', '24.10')
      end

      it 'the last entry matches latest_release' do
        expect(described_class.supported_releases(os).last).to eq(described_class.latest_release(os))
      end
    end

    context 'with Debian' do
      let(:os) { 'Debian' }

      it 'returns 12 and 13' do
        expect(described_class.supported_releases(os)).to contain_exactly('12', '13')
      end

      it 'the last entry matches latest_release' do
        expect(described_class.supported_releases(os).last).to eq(described_class.latest_release(os))
      end
    end

    context 'with Rocky' do
      let(:os) { 'Rocky' }

      it 'returns 8, 9 and 10' do
        expect(described_class.supported_releases(os)).to match_array(%w[8 9 10])
      end

      it 'the last entry matches latest_release' do
        expect(described_class.supported_releases(os).last).to eq(described_class.latest_release(os))
      end
    end

    context 'with AlmaLinux' do
      let(:os) { 'AlmaLinux' }

      it 'returns 8, 9 and 10' do
        expect(described_class.supported_releases(os)).to match_array(%w[8 9 10])
      end

      it 'the last entry matches latest_release' do
        expect(described_class.supported_releases(os).last).to eq(described_class.latest_release(os))
      end
    end

    context 'with Solaris' do
      let(:os) { 'Solaris' }

      it 'returns []' do
        expect(described_class.supported_releases(os)).to be_empty
      end

      it 'the last entry matches latest_release' do
        expect(described_class.supported_releases(os).last).to eq(described_class.latest_release(os))
      end
    end
  end
end
