# frozen_string_literal: true

require 'spec_helper'

describe PuppetMetadata::OperatingSystem do
  describe '.ubuntu_lts_version?' do
    it 'returns true for even-year .04 releases' do
      expect(described_class.ubuntu_lts_version?('22.04')).to be(true)
      expect(described_class.ubuntu_lts_version?('24.04')).to be(true)
    end

    it 'returns false for odd-year .04 releases' do
      expect(described_class.ubuntu_lts_version?('25.04')).to be(false)
    end

    it 'returns false for non-.04 releases' do
      expect(described_class.ubuntu_lts_version?('24.10')).to be(false)
      expect(described_class.ubuntu_lts_version?('23.10')).to be(false)
    end
  end

  describe 'latest_release' do
    it 'returns nil for an unknown os' do
      expect(described_class.latest_release('DoesNotExist')).to be_nil
    end

    it 'returns 10 for CentOS' do
      expect(described_class.latest_release('CentOS')).to eq('10')
    end

    it 'returns 24.04 for Ubuntu' do
      expect(described_class.latest_release('Ubuntu')).to eq('24.04')
    end

    it 'returns 2023 for Amazon' do
      expect(described_class.latest_release('Amazon')).to eq('2023')
    end

    it 'returns 15 for SLES' do
      expect(described_class.latest_release('SLES')).to eq('15')
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

      it 'returns 20.04, 22.04 and 24.04' do
        expect(described_class.supported_releases(os)).to contain_exactly('22.04', '24.04')
      end

      it 'the last entry matches latest_release' do
        expect(described_class.supported_releases(os).last).to eq(described_class.latest_release(os))
      end
    end

    context 'with Debian' do
      let(:os) { 'Debian' }

      it 'returns 11, 12 and 13' do
        expect(described_class.supported_releases(os)).to contain_exactly('11', '12', '13')
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

    context 'with SLES' do
      let(:os) { 'SLES' }
      let(:date) { Date.parse('2025-01-01') }

      it 'returns only major versions' do
        expect(described_class.supported_releases(os, date)).to contain_exactly('15')
      end
    end
  end
end
