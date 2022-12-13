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
      it { expect { subject.puppet_major_versions }.to raise_error(/No Puppet requirement found/) }
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
              name: 'puppetlabs/concat',
              version_requirement: '>= 1.0.0 < 7.0.0',
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
              operatingsystemrelease: ['7', '8', '9'],
            },
            {
              operatingsystem: 'Debian',
              operatingsystemrelease: ['9', '10'],
            },
            {
              operatingsystem: 'RedHat',
              operatingsystemrelease: ['7', '8', '9'],
            },
            {
              operatingsystem: 'Ubuntu',
              operatingsystemrelease: ['14.04', '16.04', '18.04', '20.04', '22.04'],
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
          'CentOS' => ['7', '8', '9'],
          'Debian' => ['9', '10'],
          'RedHat' => ['7', '8', '9'],
          'Ubuntu' => ['14.04', '16.04', '18.04', '20.04', '22.04'],
        }
        is_expected.to eq(expected)
      end

      describe 'os_release_supported?' do
        it { expect(subject.os_release_supported?('any', 'version')).to be(false) }
        it { expect(subject.os_release_supported?('ArchLinux', nil)).to be(true) }
        it { expect(subject.os_release_supported?('ArchLinux', '3')).to be(true) }
        it { expect(subject.os_release_supported?('Debian', '8')).to be(false) }
        it { expect(subject.os_release_supported?('Debian', '9')).to be(true) }
        it { expect(subject.os_release_supported?('Debian', 9)).to be(false) }
        it { expect(subject.os_release_supported?('Debian', '10')).to be(true) }
      end

      describe 'eol_operatingsystems' do
        it { expect(subject.eol_operatingsystems(at)).to eq({'Ubuntu' => ['14.04']}) }
      end

      describe 'requirements' do
        it { expect(subject.requirements).to eq({'puppet' => SemanticPuppet::VersionRange.parse('>= 5.5.8 < 7.0.0')}) }
      end

      describe 'satisfies_requirement' do
        it { expect(subject.satisfies_requirement?('doesnotexist', '1.0.0')).to be(false) }
        it { expect(subject.satisfies_requirement?('puppet', '5.5.7')).to be(false) }
        it { expect(subject.satisfies_requirement?('puppet', '5.5.8')).to be(true) }
        it { expect(subject.satisfies_requirement?('puppet', '6.0.0')).to be(true) }
        it { expect(subject.satisfies_requirement?('puppet', '7.0.0')).to be(false) }
      end

      describe '#puppet_major_versions' do
        it { expect(subject.puppet_major_versions).to eq([5, 6]) }

        context 'with no lower bound' do
          let(:metadata) do
            super().merge(requirements: [
              {
                name: 'puppet',
                version_requirement: '< 7.0.0',
              },
            ])
          end

          it { expect(subject.puppet_major_versions).to eq([0, 1, 2, 3, 4, 5, 6]) }
        end

        context 'with no upper bound' do
          let(:metadata) do
            super().merge(requirements: [
              {
                name: 'puppet',
                version_requirement: '>= 5.5.8',
              },
            ])
          end

          it { expect(subject.puppet_major_versions).to eq([5, 6, 7]) }
        end
      end

      describe '#dependencies' do
        it do
          expected = {
            'puppetlabs/concat' => SemanticPuppet::VersionRange.parse('>= 1.0.0 < 7.0.0'),
            'puppetlabs/stdlib' => SemanticPuppet::VersionRange.parse('>= 4.25.0 < 7.0.0'),
          }
          expect(subject.dependencies).to eq(expected)
        end
      end

      describe 'satisfies_dependency?' do
        it 'with does/notexist 0.1.0' do
          expect(subject.satisfies_dependency?('does/notexist', '0.1.0')).to be(false)
        end

        it 'with puppetlabs/concat 0.1.0' do
          expect(subject.satisfies_dependency?('puppetlabs/concat', '0.1.0')).to be(false)
        end

        it 'with puppetlabs/concat 3.14.0' do
          expect(subject.satisfies_dependency?('puppetlabs/concat', '3.14.0')).to be(true)
        end

        it 'with puppetlabs/concat 7.0.0' do
          expect(subject.satisfies_dependency?('puppetlabs/concat', '7.0.0')).to be(false)
        end
      end
    end
  end
end
