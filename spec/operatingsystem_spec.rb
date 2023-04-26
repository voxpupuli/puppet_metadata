require 'spec_helper'

describe PuppetMetadata::OperatingSystem do
  describe 'latest_release' do
    it 'returns nil for an unknown os' do
      expect(described_class.latest_release('DoesNotExist')).to be_nil
    end

    it 'returns 9 for CentOS' do
      expect(described_class.latest_release('CentOS')).to eq('9')
    end

    it 'returns 22.04 for Ubuntu' do
      expect(described_class.latest_release('Ubuntu')).to eq('22.04')
    end
  end
  describe 'supported_releases' do
    context 'with CentOS' do
      let(:os) { 'CentOS' }

      it 'returns 7, 8 and 9' do
        expect(described_class.supported_releases(os)).to match_array(['7', '8', '9'])
      end

      it 'the last entry matches latest_release' do
        expect(described_class.supported_releases(os).last).to eq(described_class.latest_release(os))
      end
    end

    context 'with Ubuntu' do
      let(:os) { 'Ubuntu' }

      it 'returns 20.04 and 22.04' do
        expect(described_class.supported_releases(os)).to match_array(['20.04', '22.04'])
      end

      it 'the last entry matches latest_release' do
        expect(described_class.supported_releases(os).last).to eq(described_class.latest_release(os))
      end
    end

    context 'with Debian' do
      let(:os) { 'Debian' }

      it 'returns 10 and 11' do
        expect(described_class.supported_releases(os)).to match_array(['10', '11'])
      end

      it 'the last entry matches latest_release' do
        expect(described_class.supported_releases(os).last).to eq(described_class.latest_release(os))
      end
    end

    context 'with Rocky' do
      let(:os) { 'Rocky' }

      it 'returns 8 and 9' do
        expect(described_class.supported_releases(os)).to match_array(['8', '9'])
      end

      it 'the last entry matches latest_release' do
        expect(described_class.supported_releases(os).last).to eq(described_class.latest_release(os))
      end
    end

    context 'with AlmaLinux' do
      let(:os) { 'AlmaLinux' }

      it 'returns 8 and 9' do
        expect(described_class.supported_releases(os)).to match_array(['8', '9'])
      end

      it 'the last entry matches latest_release' do
        expect(described_class.supported_releases(os).last).to eq(described_class.latest_release(os))
      end
    end
  end
end
