require 'spec_helper'

describe PuppetMetadata::GithubActions do
  subject { described_class.new(PuppetMetadata::Metadata.new(JSON.parse(JSON.dump(metadata))), options) }

  let(:beaker_pidfile_workaround) { false }
  let(:beaker_use_fqdn) { false }
  let(:minimum_major_puppet_version) { nil }
  let(:options) do
    {
      beaker_use_fqdn: beaker_use_fqdn,
      beaker_pidfile_workaround: beaker_pidfile_workaround,
      minimum_major_puppet_version: minimum_major_puppet_version,
    }
  end
  let(:metadata) do
    {
      author: 'federation',
      license: 'MIT',
      name: 'federation-voyager',
      version: '1.0.0',
      dependencies: [],
      summary: 'USS Voyager',
      source: 'https://example.com/federation/voyager',
      requirements: [
        {
          name: 'puppet',
          version_requirement: '>= 3.0.0 < 9.0.0',
        },
      ],
      operatingsystem_support: [
        {
          operatingsystem: 'Archlinux',
        },
        {
          operatingsystem: 'CentOS',
          operatingsystemrelease: %w[7 8 9],
        },
        {
          operatingsystem: 'Debian',
          operatingsystemrelease: %w[9 10 12],
        },
        {
          operatingsystem: 'Fedora',
          operatingsystemrelease: %w[36 38 40],
        },
      ],
    }
  end

  # rubocop:disable Layout/LineLength,RSpec/ExampleLength
  describe 'outputs' do
    subject { super().outputs }

    let(:beaker_pidfile_workaround) { false }
    let(:beaker_use_fqdn) { false }

    it { is_expected.to be_an_instance_of(Hash) }
    it { expect(subject.keys).to contain_exactly(:puppet_major_versions, :puppet_unit_test_matrix, :puppet_beaker_test_matrix, :github_action_test_matrix) }

    describe 'puppet_major_versions' do
      subject { super()[:puppet_major_versions] }

      it { is_expected.to be_an_instance_of(Array) }

      it 'is expected to contain major versions 3, 4, 5, 6, 7 and 8' do
        expect(subject).to contain_exactly(
          { collection: 'puppet8', name: 'Puppet 8', value: 8 },
          { collection: 'puppet7', name: 'Puppet 7', value: 7 },
          { collection: 'puppet6', name: 'Puppet 6', value: 6 },
          { collection: 'puppet5', name: 'Puppet 5', value: 5 },
          { collection: 'puppet4', name: 'Puppet 4', value: 4 },
          { collection: 'puppet3', name: 'Puppet 3', value: 3 },
        )
      end

      context 'when minimum_major_puppet_version is set to 6' do
        let(:minimum_major_puppet_version) { '6' }

        it 'is expected to contain major versions 6, 7 and 8' do
          expect(subject).to contain_exactly(
            { collection: 'puppet8', name: 'Puppet 8', value: 8 },
            { collection: 'puppet7', name: 'Puppet 7', value: 7 },
            { collection: 'puppet6', name: 'Puppet 6', value: 6 },
          )
        end
      end
    end

    describe 'puppet_unit_test_matrix' do
      subject { super()[:puppet_unit_test_matrix] }

      it { is_expected.to be_an_instance_of(Array) }

      it 'is expected to contain major versions 4, 5, 6 and 7' do
        expect(subject).to contain_exactly(
          { puppet: 8, ruby: '3.2' },
          { puppet: 7, ruby: '2.7' },
          { puppet: 6, ruby: '2.5' },
          { puppet: 5, ruby: '2.4' },
          { puppet: 4, ruby: '2.1' },
        )
      end

      context 'when minimum_major_puppet_version is set to 6' do
        let(:minimum_major_puppet_version) { '6' }

        it 'is expected to contain major versions 6,7 and 8' do
          expect(subject).to contain_exactly(
            { puppet: 8, ruby: '3.2' },
            { puppet: 7, ruby: '2.7' },
            { puppet: 6, ruby: '2.5' },
          )
        end
      end
    end

    describe 'puppet_beaker_test_matrix' do
      subject { super()[:puppet_beaker_test_matrix] }

      it { is_expected.to be_an_instance_of(Array) }

      it 'is expected to contain supported os / puppet version combinations' do
        expect(subject).to contain_exactly(
          { name: 'Distro Puppet - Archlinux rolling', env: { 'BEAKER_PUPPET_COLLECTION' => 'none', 'BEAKER_SETFILE' => 'archlinuxrolling-64' } },
          { name: 'Puppet 5 - CentOS 7', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet5', 'BEAKER_SETFILE' => 'centos7-64' } },
          { name: 'Puppet 6 - CentOS 7', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet6', 'BEAKER_SETFILE' => 'centos7-64' } },
          { name: 'Puppet 7 - CentOS 7', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet7', 'BEAKER_SETFILE' => 'centos7-64' } },
          { name: 'Puppet 8 - CentOS 7', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet8', 'BEAKER_SETFILE' => 'centos7-64' } },
          { name: 'Puppet 5 - CentOS 8', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet5', 'BEAKER_SETFILE' => 'centos8-64' } },
          { name: 'Puppet 6 - CentOS 8', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet6', 'BEAKER_SETFILE' => 'centos8-64' } },
          { name: 'Puppet 7 - CentOS 8', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet7', 'BEAKER_SETFILE' => 'centos8-64' } },
          { name: 'Puppet 8 - CentOS 8', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet8', 'BEAKER_SETFILE' => 'centos8-64' } },
          { name: 'Puppet 6 - CentOS 9', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet6', 'BEAKER_SETFILE' => 'centos9-64' } },
          { name: 'Puppet 7 - CentOS 9', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet7', 'BEAKER_SETFILE' => 'centos9-64' } },
          { name: 'Puppet 8 - CentOS 9', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet8', 'BEAKER_SETFILE' => 'centos9-64' } },
          { name: 'Puppet 5 - Debian 9', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet5', 'BEAKER_SETFILE' => 'debian9-64' } },
          { name: 'Puppet 6 - Debian 9', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet6', 'BEAKER_SETFILE' => 'debian9-64' } },
          { name: 'Puppet 7 - Debian 9', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet7', 'BEAKER_SETFILE' => 'debian9-64' } },
          { name: 'Puppet 5 - Debian 10', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet5', 'BEAKER_SETFILE' => 'debian10-64' } },
          { name: 'Puppet 6 - Debian 10', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet6', 'BEAKER_SETFILE' => 'debian10-64' } },
          { name: 'Puppet 7 - Debian 10', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet7', 'BEAKER_SETFILE' => 'debian10-64' } },
          { name: 'Puppet 8 - Debian 10', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet8', 'BEAKER_SETFILE' => 'debian10-64' } },
          { name: 'Puppet 7 - Debian 12', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet7', 'BEAKER_SETFILE' => 'debian12-64' } },
          { name: 'Puppet 8 - Debian 12', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet8', 'BEAKER_SETFILE' => 'debian12-64' } },
          { name: 'Puppet 7 - Fedora 36', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet7', 'BEAKER_SETFILE' => 'fedora36-64' } },
          { name: 'Puppet 8 - Fedora 36', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet8', 'BEAKER_SETFILE' => 'fedora36-64' } },
          { name: 'Distro Puppet - Fedora 38', env: { 'BEAKER_PUPPET_COLLECTION' => 'none', 'BEAKER_SETFILE' => 'fedora38-64' } },
          { name: 'Distro Puppet - Fedora 40', env: { 'BEAKER_PUPPET_COLLECTION' => 'none', 'BEAKER_SETFILE' => 'fedora40-64' } },
        )
      end

      context 'with beaker_facter option' do
        let(:options) { super().merge(beaker_facter: ['pulpcore_version', 'Pulp', %w[2 3]]) }

        it 'is expected to contain supported os / puppet version / fact combinations' do
          expect(subject).to include(
            { name: 'Distro Puppet - Archlinux rolling - Pulp 2', env: { 'BEAKER_PUPPET_COLLECTION' => 'none', 'BEAKER_SETFILE' => 'archlinuxrolling-64', 'BEAKER_FACTER_pulpcore_version' => '2' } },
            { name: 'Distro Puppet - Archlinux rolling - Pulp 3', env: { 'BEAKER_PUPPET_COLLECTION' => 'none', 'BEAKER_SETFILE' => 'archlinuxrolling-64', 'BEAKER_FACTER_pulpcore_version' => '3' } },
          )
        end
      end
    end

    describe 'github_action_test_matrix' do
      subject { super()[:github_action_test_matrix] }

      it { is_expected.to be_an_instance_of(Array) }

      it 'is expected to contain supported os / puppet version combinations' do
        expect(subject).to contain_exactly(
          { name: 'Distro Puppet - Archlinux rolling', setfile: { name: 'Archlinux rolling', value: 'archlinuxrolling-64' }, puppet: { collection: 'none', name: 'Distro Puppet', value: nil } },
          { name: 'Puppet 5 - CentOS 7', setfile: { name: 'CentOS 7', value: 'centos7-64' }, puppet: { collection: 'puppet5', name: 'Puppet 5', value: 5 } },
          { name: 'Puppet 6 - CentOS 7', setfile: { name: 'CentOS 7', value: 'centos7-64' }, puppet: { collection: 'puppet6', name: 'Puppet 6', value: 6 } },
          { name: 'Puppet 7 - CentOS 7', setfile: { name: 'CentOS 7', value: 'centos7-64' }, puppet: { collection: 'puppet7', name: 'Puppet 7', value: 7 } },
          { name: 'Puppet 8 - CentOS 7', setfile: { name: 'CentOS 7', value: 'centos7-64' }, puppet: { collection: 'puppet8', name: 'Puppet 8', value: 8 } },
          { name: 'Puppet 5 - CentOS 8', setfile: { name: 'CentOS 8', value: 'centos8-64' }, puppet: { collection: 'puppet5', name: 'Puppet 5', value: 5 } },
          { name: 'Puppet 6 - CentOS 8', setfile: { name: 'CentOS 8', value: 'centos8-64' }, puppet: { collection: 'puppet6', name: 'Puppet 6', value: 6 } },
          { name: 'Puppet 7 - CentOS 8', setfile: { name: 'CentOS 8', value: 'centos8-64' }, puppet: { collection: 'puppet7', name: 'Puppet 7', value: 7 } },
          { name: 'Puppet 8 - CentOS 8', setfile: { name: 'CentOS 8', value: 'centos8-64' }, puppet: { collection: 'puppet8', name: 'Puppet 8', value: 8 } },
          { name: 'Puppet 6 - CentOS 9', setfile: { name: 'CentOS 9', value: 'centos9-64' }, puppet: { collection: 'puppet6', name: 'Puppet 6', value: 6 } },
          { name: 'Puppet 7 - CentOS 9', setfile: { name: 'CentOS 9', value: 'centos9-64' }, puppet: { collection: 'puppet7', name: 'Puppet 7', value: 7 } },
          { name: 'Puppet 8 - CentOS 9', setfile: { name: 'CentOS 9', value: 'centos9-64' }, puppet: { collection: 'puppet8', name: 'Puppet 8', value: 8 } },
          { name: 'Puppet 5 - Debian 9', setfile: { name: 'Debian 9', value: 'debian9-64' }, puppet: { collection: 'puppet5', name: 'Puppet 5', value: 5 } },
          { name: 'Puppet 6 - Debian 9', setfile: { name: 'Debian 9', value: 'debian9-64' }, puppet: { collection: 'puppet6', name: 'Puppet 6', value: 6 } },
          { name: 'Puppet 7 - Debian 9', setfile: { name: 'Debian 9', value: 'debian9-64' }, puppet: { collection: 'puppet7', name: 'Puppet 7', value: 7 } },
          { name: 'Puppet 5 - Debian 10', setfile: { name: 'Debian 10', value: 'debian10-64' }, puppet: { collection: 'puppet5', name: 'Puppet 5', value: 5 } },
          { name: 'Puppet 6 - Debian 10', setfile: { name: 'Debian 10', value: 'debian10-64' }, puppet: { collection: 'puppet6', name: 'Puppet 6', value: 6 } },
          { name: 'Puppet 7 - Debian 10', setfile: { name: 'Debian 10', value: 'debian10-64' }, puppet: { collection: 'puppet7', name: 'Puppet 7', value: 7 } },
          { name: 'Puppet 8 - Debian 10', setfile: { name: 'Debian 10', value: 'debian10-64' }, puppet: { collection: 'puppet8', name: 'Puppet 8', value: 8 } },
          { name: 'Puppet 7 - Debian 12', setfile: { name: 'Debian 12', value: 'debian12-64' }, puppet: { collection: 'puppet7', name: 'Puppet 7', value: 7 } },
          { name: 'Puppet 8 - Debian 12', setfile: { name: 'Debian 12', value: 'debian12-64' }, puppet: { collection: 'puppet8', name: 'Puppet 8', value: 8 } },
          { name: 'Puppet 7 - Fedora 36', setfile: { name: 'Fedora 36', value: 'fedora36-64' }, puppet: { collection: 'puppet7', name: 'Puppet 7', value: 7 } },
          { name: 'Puppet 8 - Fedora 36', setfile: { name: 'Fedora 36', value: 'fedora36-64' }, puppet: { collection: 'puppet8', name: 'Puppet 8', value: 8 } },
          { name: 'Distro Puppet - Fedora 38', setfile: { name: 'Fedora 38', value: 'fedora38-64' }, puppet: { collection: 'none', name: 'Distro Puppet', value: 7 } },
          { name: 'Distro Puppet - Fedora 40', setfile: { name: 'Fedora 40', value: 'fedora40-64' }, puppet: { collection: 'none', name: 'Distro Puppet', value: 8 } },
        )
      end

      context 'when minimum_major_puppet_version is set to 6' do
        let(:minimum_major_puppet_version) { '6' }

        it 'is expected to contain supported os / puppet version combinations excluding puppet 5' do
          expect(subject).to contain_exactly(
            { name: 'Distro Puppet - Archlinux rolling', setfile: { name: 'Archlinux rolling', value: 'archlinuxrolling-64' }, puppet: { collection: 'none', name: 'Distro Puppet', value: nil } },
            { name: 'Puppet 6 - CentOS 7', setfile: { name: 'CentOS 7', value: 'centos7-64' }, puppet: { collection: 'puppet6', name: 'Puppet 6', value: 6 } },
            { name: 'Puppet 7 - CentOS 7', setfile: { name: 'CentOS 7', value: 'centos7-64' }, puppet: { collection: 'puppet7', name: 'Puppet 7', value: 7 } },
            { name: 'Puppet 8 - CentOS 7', setfile: { name: 'CentOS 7', value: 'centos7-64' }, puppet: { collection: 'puppet8', name: 'Puppet 8', value: 8 } },
            { name: 'Puppet 6 - CentOS 8', setfile: { name: 'CentOS 8', value: 'centos8-64' }, puppet: { collection: 'puppet6', name: 'Puppet 6', value: 6 } },
            { name: 'Puppet 7 - CentOS 8', setfile: { name: 'CentOS 8', value: 'centos8-64' }, puppet: { collection: 'puppet7', name: 'Puppet 7', value: 7 } },
            { name: 'Puppet 8 - CentOS 8', setfile: { name: 'CentOS 8', value: 'centos8-64' }, puppet: { collection: 'puppet8', name: 'Puppet 8', value: 8 } },
            { name: 'Puppet 6 - CentOS 9', setfile: { name: 'CentOS 9', value: 'centos9-64' }, puppet: { collection: 'puppet6', name: 'Puppet 6', value: 6 } },
            { name: 'Puppet 7 - CentOS 9', setfile: { name: 'CentOS 9', value: 'centos9-64' }, puppet: { collection: 'puppet7', name: 'Puppet 7', value: 7 } },
            { name: 'Puppet 8 - CentOS 9', setfile: { name: 'CentOS 9', value: 'centos9-64' }, puppet: { collection: 'puppet8', name: 'Puppet 8', value: 8 } },
            { name: 'Puppet 6 - Debian 9', setfile: { name: 'Debian 9', value: 'debian9-64' }, puppet: { collection: 'puppet6', name: 'Puppet 6', value: 6 } },
            { name: 'Puppet 7 - Debian 9', setfile: { name: 'Debian 9', value: 'debian9-64' }, puppet: { collection: 'puppet7', name: 'Puppet 7', value: 7 } },
            { name: 'Puppet 6 - Debian 10', setfile: { name: 'Debian 10', value: 'debian10-64' }, puppet: { collection: 'puppet6', name: 'Puppet 6', value: 6 } },
            { name: 'Puppet 7 - Debian 10', setfile: { name: 'Debian 10', value: 'debian10-64' }, puppet: { collection: 'puppet7', name: 'Puppet 7', value: 7 } },
            { name: 'Puppet 8 - Debian 10', setfile: { name: 'Debian 10', value: 'debian10-64' }, puppet: { collection: 'puppet8', name: 'Puppet 8', value: 8 } },
            { name: 'Puppet 7 - Debian 12', setfile: { name: 'Debian 12', value: 'debian12-64' }, puppet: { collection: 'puppet7', name: 'Puppet 7', value: 7 } },
            { name: 'Puppet 8 - Debian 12', setfile: { name: 'Debian 12', value: 'debian12-64' }, puppet: { collection: 'puppet8', name: 'Puppet 8', value: 8 } },
            { name: 'Puppet 7 - Fedora 36', setfile: { name: 'Fedora 36', value: 'fedora36-64' }, puppet: { collection: 'puppet7', name: 'Puppet 7', value: 7 } },
            { name: 'Puppet 8 - Fedora 36', setfile: { name: 'Fedora 36', value: 'fedora36-64' }, puppet: { collection: 'puppet8', name: 'Puppet 8', value: 8 } },
            { name: 'Distro Puppet - Fedora 38', setfile: { name: 'Fedora 38', value: 'fedora38-64' }, puppet: { collection: 'none', name: 'Distro Puppet', value: 7 } },
            { name: 'Distro Puppet - Fedora 40', setfile: { name: 'Fedora 40', value: 'fedora40-64' }, puppet: { collection: 'none', name: 'Distro Puppet', value: 8 } },
          )
        end
      end

      context 'when beaker_pidfile_workaround is true' do
        let(:beaker_pidfile_workaround) { true }

        it 'is expected to contain supported os / puppet version combinations with image option' do
          expect(subject).to contain_exactly(
            { name: 'Distro Puppet - Archlinux rolling', setfile: { name: 'Archlinux rolling', value: 'archlinuxrolling-64' }, puppet: { collection: 'none', name: 'Distro Puppet', value: nil } },
            { name: 'Puppet 8 - CentOS 7', setfile: { name: 'CentOS 7', value: 'centos7-64{image=centos:7.6.1810}' }, puppet: { name: 'Puppet 8', value: 8, collection: 'puppet8' } },
            { name: 'Puppet 7 - CentOS 7', setfile: { name: 'CentOS 7', value: 'centos7-64{image=centos:7.6.1810}' }, puppet: { name: 'Puppet 7', value: 7, collection: 'puppet7' } },
            { name: 'Puppet 6 - CentOS 7', setfile: { name: 'CentOS 7', value: 'centos7-64{image=centos:7.6.1810}' }, puppet: { name: 'Puppet 6', value: 6, collection: 'puppet6' } },
            { name: 'Puppet 5 - CentOS 7', setfile: { name: 'CentOS 7', value: 'centos7-64{image=centos:7.6.1810}' }, puppet: { name: 'Puppet 5', value: 5, collection: 'puppet5' } },
            { name: 'Puppet 6 - CentOS 9', setfile: { name: 'CentOS 9', value: 'centos9-64' }, puppet: { collection: 'puppet6', name: 'Puppet 6', value: 6 } },
            { name: 'Puppet 7 - CentOS 9', setfile: { name: 'CentOS 9', value: 'centos9-64' }, puppet: { collection: 'puppet7', name: 'Puppet 7', value: 7 } },
            { name: 'Puppet 8 - CentOS 9', setfile: { name: 'CentOS 9', value: 'centos9-64' }, puppet: { collection: 'puppet8', name: 'Puppet 8', value: 8 } },
            { name: 'Puppet 7 - Debian 9', setfile: { name: 'Debian 9', value: 'debian9-64' }, puppet: { name: 'Puppet 7', value: 7, collection: 'puppet7' } },
            { name: 'Puppet 6 - Debian 9', setfile: { name: 'Debian 9', value: 'debian9-64' }, puppet: { name: 'Puppet 6', value: 6, collection: 'puppet6' } },
            { name: 'Puppet 5 - Debian 9', setfile: { name: 'Debian 9', value: 'debian9-64' }, puppet: { name: 'Puppet 5', value: 5, collection: 'puppet5' } },
            { name: 'Puppet 8 - Debian 10', setfile: { name: 'Debian 10', value: 'debian10-64' }, puppet: { name: 'Puppet 8', value: 8, collection: 'puppet8' } },
            { name: 'Puppet 7 - Debian 10', setfile: { name: 'Debian 10', value: 'debian10-64' }, puppet: { name: 'Puppet 7', value: 7, collection: 'puppet7' } },
            { name: 'Puppet 6 - Debian 10', setfile: { name: 'Debian 10', value: 'debian10-64' }, puppet: { name: 'Puppet 6', value: 6, collection: 'puppet6' } },
            { name: 'Puppet 5 - Debian 10', setfile: { name: 'Debian 10', value: 'debian10-64' }, puppet: { name: 'Puppet 5', value: 5, collection: 'puppet5' } },
            { name: 'Puppet 7 - Debian 12', setfile: { name: 'Debian 12', value: 'debian12-64' }, puppet: { name: 'Puppet 7', value: 7, collection: 'puppet7' } },
            { name: 'Puppet 8 - Debian 12', setfile: { name: 'Debian 12', value: 'debian12-64' }, puppet: { name: 'Puppet 8', value: 8, collection: 'puppet8' } },
            { name: 'Puppet 7 - Fedora 36', setfile: { name: 'Fedora 36', value: 'fedora36-64' }, puppet: { collection: 'puppet7', name: 'Puppet 7', value: 7 } },
            { name: 'Puppet 8 - Fedora 36', setfile: { name: 'Fedora 36', value: 'fedora36-64' }, puppet: { collection: 'puppet8', name: 'Puppet 8', value: 8 } },
            { name: 'Distro Puppet - Fedora 38', setfile: { name: 'Fedora 38', value: 'fedora38-64' }, puppet: { collection: 'none', name: 'Distro Puppet', value: 7 } },
            { name: 'Distro Puppet - Fedora 40', setfile: { name: 'Fedora 40', value: 'fedora40-64' }, puppet: { collection: 'none', name: 'Distro Puppet', value: 8 } },
          )
        end
      end

      context 'when beaker_use_fqdn is true' do
        let(:beaker_use_fqdn) { true }

        it 'is expected to contain supported os / puppet version combinations with hostname option' do
          expect(subject).to contain_exactly(
            { name: 'Distro Puppet - Archlinux rolling', setfile: { name: 'Archlinux rolling', value: 'archlinuxrolling-64{hostname=archlinuxrolling-64-none.example.com}' }, puppet: { collection: 'none', name: 'Distro Puppet', value: nil } },
            { name: 'Puppet 8 - CentOS 7', setfile: { name: 'CentOS 7', value: 'centos7-64{hostname=centos7-64-puppet8.example.com}' }, puppet: { name: 'Puppet 8', value: 8, collection: 'puppet8' } },
            { name: 'Puppet 7 - CentOS 7', setfile: { name: 'CentOS 7', value: 'centos7-64{hostname=centos7-64-puppet7.example.com}' }, puppet: { name: 'Puppet 7', value: 7, collection: 'puppet7' } },
            { name: 'Puppet 6 - CentOS 7', setfile: { name: 'CentOS 7', value: 'centos7-64{hostname=centos7-64-puppet6.example.com}' }, puppet: { name: 'Puppet 6', value: 6, collection: 'puppet6' } },
            { name: 'Puppet 5 - CentOS 7', setfile: { name: 'CentOS 7', value: 'centos7-64{hostname=centos7-64-puppet5.example.com}' }, puppet: { name: 'Puppet 5', value: 5, collection: 'puppet5' } },
            { name: 'Puppet 8 - CentOS 8', setfile: { name: 'CentOS 8', value: 'centos8-64{hostname=centos8-64-puppet8.example.com}' }, puppet: { name: 'Puppet 8', value: 8, collection: 'puppet8' } },
            { name: 'Puppet 7 - CentOS 8', setfile: { name: 'CentOS 8', value: 'centos8-64{hostname=centos8-64-puppet7.example.com}' }, puppet: { name: 'Puppet 7', value: 7, collection: 'puppet7' } },
            { name: 'Puppet 6 - CentOS 8', setfile: { name: 'CentOS 8', value: 'centos8-64{hostname=centos8-64-puppet6.example.com}' }, puppet: { name: 'Puppet 6', value: 6, collection: 'puppet6' } },
            { name: 'Puppet 5 - CentOS 8', setfile: { name: 'CentOS 8', value: 'centos8-64{hostname=centos8-64-puppet5.example.com}' }, puppet: { name: 'Puppet 5', value: 5, collection: 'puppet5' } },
            { name: 'Puppet 8 - CentOS 9', setfile: { name: 'CentOS 9', value: 'centos9-64{hostname=centos9-64-puppet8.example.com}' }, puppet: { name: 'Puppet 8', value: 8, collection: 'puppet8' } },
            { name: 'Puppet 7 - CentOS 9', setfile: { name: 'CentOS 9', value: 'centos9-64{hostname=centos9-64-puppet7.example.com}' }, puppet: { name: 'Puppet 7', value: 7, collection: 'puppet7' } },
            { name: 'Puppet 6 - CentOS 9', setfile: { name: 'CentOS 9', value: 'centos9-64{hostname=centos9-64-puppet6.example.com}' }, puppet: { name: 'Puppet 6', value: 6, collection: 'puppet6' } },
            { name: 'Puppet 7 - Debian 9', setfile: { name: 'Debian 9', value: 'debian9-64{hostname=debian9-64-puppet7.example.com}' }, puppet: { name: 'Puppet 7', value: 7, collection: 'puppet7' } },
            { name: 'Puppet 6 - Debian 9', setfile: { name: 'Debian 9', value: 'debian9-64{hostname=debian9-64-puppet6.example.com}' }, puppet: { name: 'Puppet 6', value: 6, collection: 'puppet6' } },
            { name: 'Puppet 5 - Debian 9', setfile: { name: 'Debian 9', value: 'debian9-64{hostname=debian9-64-puppet5.example.com}' }, puppet: { name: 'Puppet 5', value: 5, collection: 'puppet5' } },
            { name: 'Puppet 8 - Debian 10', setfile: { name: 'Debian 10', value: 'debian10-64{hostname=debian10-64-puppet8.example.com}' }, puppet: { name: 'Puppet 8', value: 8, collection: 'puppet8' } },
            { name: 'Puppet 7 - Debian 10', setfile: { name: 'Debian 10', value: 'debian10-64{hostname=debian10-64-puppet7.example.com}' }, puppet: { name: 'Puppet 7', value: 7, collection: 'puppet7' } },
            { name: 'Puppet 6 - Debian 10', setfile: { name: 'Debian 10', value: 'debian10-64{hostname=debian10-64-puppet6.example.com}' }, puppet: { name: 'Puppet 6', value: 6, collection: 'puppet6' } },
            { name: 'Puppet 5 - Debian 10', setfile: { name: 'Debian 10', value: 'debian10-64{hostname=debian10-64-puppet5.example.com}' }, puppet: { name: 'Puppet 5', value: 5, collection: 'puppet5' } },
            { name: 'Puppet 7 - Debian 12', setfile: { name: 'Debian 12', value: 'debian12-64{hostname=debian12-64-puppet7.example.com}' }, puppet: { name: 'Puppet 7', value: 7, collection: 'puppet7' } },
            { name: 'Puppet 8 - Debian 12', setfile: { name: 'Debian 12', value: 'debian12-64{hostname=debian12-64-puppet8.example.com}' }, puppet: { name: 'Puppet 8', value: 8, collection: 'puppet8' } },
            { name: 'Puppet 7 - Fedora 36', setfile: { name: 'Fedora 36', value: 'fedora36-64{hostname=fedora36-64-puppet7.example.com}' }, puppet: { collection: 'puppet7', name: 'Puppet 7', value: 7 } },
            { name: 'Puppet 8 - Fedora 36', setfile: { name: 'Fedora 36', value: 'fedora36-64{hostname=fedora36-64-puppet8.example.com}' }, puppet: { collection: 'puppet8', name: 'Puppet 8', value: 8 } },
            { name: 'Distro Puppet - Fedora 38', setfile: { name: 'Fedora 38', value: 'fedora38-64{hostname=fedora38-64-none.example.com}' }, puppet: { collection: 'none', name: 'Distro Puppet', value: 7 } },
            { name: 'Distro Puppet - Fedora 40', setfile: { name: 'Fedora 40', value: 'fedora40-64{hostname=fedora40-64-none.example.com}' }, puppet: { collection: 'none', name: 'Distro Puppet', value: 8 } },
          )
        end
      end
    end
  end
  # rubocop:enable Layout/LineLength,RSpec/ExampleLength
end
