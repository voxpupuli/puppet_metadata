require 'spec_helper'

describe PuppetMetadata::GithubActions do
  subject { described_class.new(PuppetMetadata::Metadata.new(JSON.parse(JSON.dump(metadata))), options) }

  let(:at) { Date.new(2020, 1, 1) }
  let(:beaker_pidfile_workaround) { false }
  let(:minimum_major_puppet_version) { nil }
  let(:options) do
    {
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
    subject { super().outputs(at) }

    let(:beaker_pidfile_workaround) { false }

    it { is_expected.to be_an_instance_of(Hash) }
    it { expect(subject.keys).to contain_exactly(:puppet_major_versions, :puppet_unit_test_matrix, :puppet_beaker_test_matrix) }

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
          { name: 'Puppet 5 - CentOS 7', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet5', 'BEAKER_SETFILE' => 'centos7-64{hostname=centos7-64-puppet5}' } },
          { name: 'Puppet 6 - CentOS 7', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet6', 'BEAKER_SETFILE' => 'centos7-64{hostname=centos7-64-puppet6}' } },
          { name: 'Puppet 7 - CentOS 7', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet7', 'BEAKER_SETFILE' => 'centos7-64{hostname=centos7-64-puppet7}' } },
          { name: 'Puppet 8 - CentOS 7', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet8', 'BEAKER_SETFILE' => 'centos7-64{hostname=centos7-64-puppet8}' } },
          { name: 'Puppet 5 - CentOS 8', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet5', 'BEAKER_SETFILE' => 'centos8-64{hostname=centos8-64-puppet5}' } },
          { name: 'Puppet 6 - CentOS 8', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet6', 'BEAKER_SETFILE' => 'centos8-64{hostname=centos8-64-puppet6}' } },
          { name: 'Puppet 7 - CentOS 8', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet7', 'BEAKER_SETFILE' => 'centos8-64{hostname=centos8-64-puppet7}' } },
          { name: 'Puppet 8 - CentOS 8', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet8', 'BEAKER_SETFILE' => 'centos8-64{hostname=centos8-64-puppet8}' } },
          { name: 'Puppet 6 - CentOS 9', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet6', 'BEAKER_SETFILE' => 'centos9-64{hostname=centos9-64-puppet6}' } },
          { name: 'Puppet 7 - CentOS 9', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet7', 'BEAKER_SETFILE' => 'centos9-64{hostname=centos9-64-puppet7}' } },
          { name: 'Puppet 8 - CentOS 9', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet8', 'BEAKER_SETFILE' => 'centos9-64{hostname=centos9-64-puppet8}' } },
          { name: 'Puppet 5 - Debian 9', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet5', 'BEAKER_SETFILE' => 'debian9-64{hostname=debian9-64-puppet5}' } },
          { name: 'Puppet 6 - Debian 9', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet6', 'BEAKER_SETFILE' => 'debian9-64{hostname=debian9-64-puppet6}' } },
          { name: 'Puppet 7 - Debian 9', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet7', 'BEAKER_SETFILE' => 'debian9-64{hostname=debian9-64-puppet7}' } },
          { name: 'Puppet 5 - Debian 10', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet5', 'BEAKER_SETFILE' => 'debian10-64{hostname=debian10-64-puppet5}' } },
          { name: 'Puppet 6 - Debian 10', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet6', 'BEAKER_SETFILE' => 'debian10-64{hostname=debian10-64-puppet6}' } },
          { name: 'Puppet 7 - Debian 10', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet7', 'BEAKER_SETFILE' => 'debian10-64{hostname=debian10-64-puppet7}' } },
          { name: 'Puppet 8 - Debian 10', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet8', 'BEAKER_SETFILE' => 'debian10-64{hostname=debian10-64-puppet8}' } },
          { name: 'Puppet 7 - Debian 12', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet7', 'BEAKER_SETFILE' => 'debian12-64{hostname=debian12-64-puppet7}' } },
          { name: 'Puppet 8 - Debian 12', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet8', 'BEAKER_SETFILE' => 'debian12-64{hostname=debian12-64-puppet8}' } },
          { name: 'Puppet 7 - Fedora 36', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet7', 'BEAKER_SETFILE' => 'fedora36-64{hostname=fedora36-64-puppet7}' } },
          { name: 'Puppet 8 - Fedora 36', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet8', 'BEAKER_SETFILE' => 'fedora36-64{hostname=fedora36-64-puppet8}' } },
          { name: 'Distro Puppet - Fedora 38', env: { 'BEAKER_PUPPET_COLLECTION' => 'none', 'BEAKER_SETFILE' => 'fedora38-64' } },
          { name: 'Puppet 7 - Fedora 40', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet7', 'BEAKER_SETFILE' => 'fedora40-64{hostname=fedora40-64-puppet7}' } },
          { name: 'Puppet 8 - Fedora 40', env: { 'BEAKER_PUPPET_COLLECTION' => 'puppet8', 'BEAKER_SETFILE' => 'fedora40-64{hostname=fedora40-64-puppet8}' } },
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

      context 'with option beaker_hosts set to one node with custom roles' do
        let(:options) { super().merge(beaker_hosts: { 'foo' => 'myrole,primary.ma' }) }

        it 'is expected to contain supported os / puppet version / custom hostname / custom roles' do
          expect(subject).to include(
            { name: 'Distro Puppet - Archlinux rolling', env: { 'BEAKER_PUPPET_COLLECTION' => 'none', 'BEAKER_SETFILE' => 'archlinuxrolling-64myrole,primary.ma{hostname=foo}' } },
          )
        end
      end

      context 'with option beaker_hosts set to two node without custom roles' do
        let(:options) { super().merge(beaker_hosts: { 'foo' => nil, 'bar' => nil }) }

        it 'is expected to contain supported os / puppet version / custom hostnames / required roles for multihost' do
          expect(subject).to include(
            { name: 'Distro Puppet - Archlinux rolling', env: { 'BEAKER_PUPPET_COLLECTION' => 'none', 'BEAKER_SETFILE' => 'archlinuxrolling-64.ma{hostname=foo}-archlinuxrolling-64.a{hostname=bar}' } },
          )
        end
      end

      context 'with option beaker_hosts set to two node with custom roles' do
        let(:options) { super().merge(beaker_hosts: { 'foo' => 'primary.ma', 'bar' => 'secondary.a' }) }

        it 'is expected to contain supported os / puppet version / custom hostnames / custom roles' do
          expect(subject).to include(
            { name: 'Distro Puppet - Archlinux rolling', env: { 'BEAKER_PUPPET_COLLECTION' => 'none', 'BEAKER_SETFILE' => 'archlinuxrolling-64primary.ma{hostname=foo}-archlinuxrolling-64secondary.a{hostname=bar}' } },
          )
        end
      end

      context 'when domain is set' do
        let(:options) { super().merge(domain: 'example.com') }

        it 'is expected to contain supported os / puppet version combinations with hostname option' do
          expect(subject).to include(
            { name: 'Distro Puppet - Archlinux rolling', env: { 'BEAKER_PUPPET_COLLECTION' => 'none', 'BEAKER_SETFILE' => 'archlinuxrolling-64{hostname=archlinuxrolling-64.example.com}' } },
          )
        end
      end
    end
  end
  # rubocop:enable Layout/LineLength,RSpec/ExampleLength
end
