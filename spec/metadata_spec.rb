require 'spec_helper'
require 'puppet_metadata'

describe PuppetMetadata::Metadata do
  context 'instance' do
    subject { described_class.new(JSON.parse(JSON.dump(metadata))) }

    context 'invalid metadata' do
      let(:metadata) { {} }

      it { expect { subject }.to raise_error(/Invalid metadata: The file did not contain a required property/) }
    end

    context 'minimal metadata' do
      let(:metadata) do
        {
          author: 'federation',
          license: 'MIT',
          name: 'federation-voyager',
          version: '1.0.0',
          dependencies: [],
          summary: 'USS Voyager',
          source: 'https://example.com/federation/voyager',
        }
      end

      it { is_expected.not_to be_nil }
      its(:name) { is_expected.to eq('federation-voyager') }
      its(:version) { is_expected.to eq('1.0.0') }
      its(:operatingsystems) { is_expected.to eq({}) }
      it { expect(subject.os_release_supported?('any', 'version')).to be(true) }
      it { expect(subject.eol_operatingsystems).to eq({}) }
    end
  end
end
