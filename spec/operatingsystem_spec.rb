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
    it 'returns 7, 8 and 9 for CentOS' do
      expect(described_class.supported_releases('CentOS')).to match_array(['7', '8', '9'])
    end
    it 'returns 18.04, 20.04, 21.10 and 22.04 for Ubuntu' do
      expect(described_class.supported_releases('Ubuntu')).to match_array(['18.04', '20.04', '21.10', '22.04'])
    end
    it 'returns 10 and 11 for Debian' do
      expect(described_class.supported_releases('Debian')).to match_array(['10', '11'])
    end
    it 'returns 8 and 9 for Rocky' do
      expect(described_class.supported_releases('Rocky')).to match_array(['8', '9'])
    end
    it 'returns 8 and 9 for AlmaLinux' do
      expect(described_class.supported_releases('AlmaLinux')).to match_array(['8', '9'])
    end
  end
end
