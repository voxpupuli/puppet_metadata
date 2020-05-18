require 'spec_helper'

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

    context 'full metadata' do
      let(:at) { Date.new(2020, 5, 18) } # Needed for EOL testing
      let(:metadata) do
        {
          author: 'federation',
          license: 'MIT',
          name: 'federation-voyager',
          version: '1.0.0',
          summary: 'USS Voyager',
          source: 'https://example.com/federation/voyager',
          dependencies: [
            {
              name: "puppetlabs/concat",
              version_requirement: ">= 1.0.0 < 7.0.0",
            },
            {
              name: 'puppetlabs/stdlib',
              version_requirement: '>= 4.25.0 < 7.0.0',
            },
          ],
          requirements: [
            {
              name: 'puppet',
              version_requirement: '>= 5.5.8 < 7.0.0',
            },
          ],
          operatingsystem_support: [
            {
              operatingsystem: 'ArchLinux',
            },
            {
              operatingsystem: 'CentOS',
              operatingsystemrelease: ['7', '8'],
            },
            {
              operatingsystem: 'Debian',
              operatingsystemrelease: ['9', '10'],
            },
            {
              operatingsystem: 'RedHat',
              operatingsystemrelease: ['7', '8'],
            },
            {
              operatingsystem: 'Ubuntu',
              operatingsystemrelease: ['14.04', '16.04', '18.04', '20.04'],
            },
          ],
        }
      end

      it { is_expected.not_to be_nil }
      its(:name) { is_expected.to eq('federation-voyager') }
      its(:version) { is_expected.to eq('1.0.0') }
      its(:operatingsystems) do
        expected = {
          'ArchLinux' => nil,
          'CentOS' => ['7', '8'],
          'Debian' => ['9', '10'],
          'RedHat' => ['7', '8'],
          'Ubuntu' => ['14.04', '16.04', '18.04', '20.04'],
        }
        is_expected.to eq(expected)
      end
      it { expect(subject.os_release_supported?('any', 'version')).to be(false) }
      it { expect(subject.os_release_supported?('ArchLinux', nil)).to be(true) }
      it { expect(subject.os_release_supported?('ArchLinux', '3')).to be(true) }
      it { expect(subject.os_release_supported?('Debian', '8')).to be(false) }
      it { expect(subject.os_release_supported?('Debian', '9')).to be(true) }
      it { expect(subject.os_release_supported?('Debian', 9)).to be(false) }
      it { expect(subject.os_release_supported?('Debian', '10')).to be(true) }

      it { expect(subject.eol_operatingsystems(at)).to eq({'Ubuntu' => ['14.04']}) }

      it { expect(subject.requirements).to eq({'puppet' => SemanticPuppet::VersionRange.parse('>= 5.5.8 < 7.0.0')}) }
      it { expect(subject.requirements['puppet']).not_to include(SemanticPuppet::Version.parse('5.5.7')) }
      it { expect(subject.requirements['puppet']).to include(SemanticPuppet::Version.parse('5.5.10')) }
      it { expect(subject.requirements['puppet']).to include(SemanticPuppet::Version.parse('6.0.10')) }
      it { expect(subject.requirements['puppet']).not_to include(SemanticPuppet::Version.parse('7.0.10')) }
    end
  end
end
