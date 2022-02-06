require 'spec_helper'

describe PuppetMetadata::OperatingSystem do
  describe 'latest_release' do
    it 'returns nil for an unknown os' do
      expect(described_class.latest_release('DoesNotExist')).to be_nil
    end

    it 'returns 9 for CentOS' do
      expect(described_class.latest_release('CentOS')).to eq('9')
    end

    it 'returns 20.04 for Ubuntu' do
      expect(described_class.latest_release('Ubuntu')).to eq('20.04')
    end
  end
end
