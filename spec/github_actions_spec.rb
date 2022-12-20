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
      minimum_major_puppet_version: minimum_major_puppet_version
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
          operatingsystem: 'CentOS',
          operatingsystemrelease: ['7', '8', '9'],
        },
        {
          operatingsystem: 'Debian',
          operatingsystemrelease: ['9', '10'],
        },
      ],
    }
  end

  describe 'outputs' do
    let(:beaker_pidfile_workaround) { false }
    let(:beaker_use_fqdn) { false }

    subject { super().outputs }

    it { is_expected.to be_an_instance_of(Hash) }
    it { expect(subject.keys).to contain_exactly(:puppet_major_versions, :puppet_unit_test_matrix, :github_action_test_matrix) }

    describe 'puppet_major_versions' do
      subject { super()[:puppet_major_versions] }

      it { is_expected.to be_an_instance_of(Array) }
      it 'is expected to contain major versions 3, 4, 5, 6, 7 and 8' do
        is_expected.to contain_exactly(
          {collection: "puppet8", name: "Puppet 8", value: 8},
          {collection: "puppet7", name: "Puppet 7", value: 7},
          {collection: "puppet6", name: "Puppet 6", value: 6},
          {collection: "puppet5", name: "Puppet 5", value: 5},
          {collection: "puppet4", name: "Puppet 4", value: 4},
          {collection: "puppet3", name: "Puppet 3", value: 3},
        )
      end

      context 'when minimum_major_puppet_version is set to 6' do
        let(:minimum_major_puppet_version) { '6' }

        it 'is expected to contain major versions 6, 7 and 8' do
          is_expected.to contain_exactly(
            {collection: "puppet8", name: "Puppet 8", value: 8},
            {collection: "puppet7", name: "Puppet 7", value: 7},
            {collection: "puppet6", name: "Puppet 6", value: 6},
          )
        end
      end
    end

    describe 'puppet_unit_test_matrix' do
      subject { super()[:puppet_unit_test_matrix] }

      it { is_expected.to be_an_instance_of(Array) }
      it 'is expected to contain major versions 4, 5, 6 and 7' do
        is_expected.to contain_exactly(
          {puppet: 7, ruby: "2.7"},
          {puppet: 6, ruby: "2.5"},
          {puppet: 5, ruby: "2.4"},
          {puppet: 4, ruby: "2.1"},
        )
      end

      context 'when minimum_major_puppet_version is set to 6' do
        let(:minimum_major_puppet_version) { '6' }

        it 'is expected to contain major versions 6 and 7' do
          is_expected.to contain_exactly(
            {puppet: 7, ruby: "2.7"},
            {puppet: 6, ruby: "2.5"},
          )
        end
      end
    end

    describe 'github_action_test_matrix' do
      subject { super()[:github_action_test_matrix] }

      it { is_expected.to be_an_instance_of(Array) }
      it 'is expected to contain supported os / puppet version combinations' do
        is_expected.to contain_exactly(
          {setfile: {name: "CentOS 7", value: "centos7-64"}, puppet: {collection: "puppet5", name: "Puppet 5", value: 5}},
          {setfile: {name: "CentOS 7", value: "centos7-64"}, puppet: {collection: "puppet6", name: "Puppet 6", value: 6}},
          {setfile: {name: "CentOS 7", value: "centos7-64"}, puppet: {collection: "puppet7", name: "Puppet 7", value: 7}},
          {setfile: {name: "CentOS 8", value: "centos8-64"}, puppet: {collection: "puppet5", name: "Puppet 5", value: 5}},
          {setfile: {name: "CentOS 8", value: "centos8-64"}, puppet: {collection: "puppet6", name: "Puppet 6", value: 6}},
          {setfile: {name: "CentOS 8", value: "centos8-64"}, puppet: {collection: "puppet7", name: "Puppet 7", value: 7}},
          {setfile: {name: "CentOS 9", value: "centos9-64"}, puppet: {collection: "puppet6", name: "Puppet 6", value: 6}},
          {setfile: {name: "CentOS 9", value: "centos9-64"}, puppet: {collection: "puppet7", name: "Puppet 7", value: 7}},
          {setfile: {name: "Debian 9", value: "debian9-64"}, puppet: {collection: "puppet5", name: "Puppet 5", value: 5}},
          {setfile: {name: "Debian 9", value: "debian9-64"}, puppet: {collection: "puppet6", name: "Puppet 6", value: 6}},
          {setfile: {name: "Debian 9", value: "debian9-64"}, puppet: {collection: "puppet7", name: "Puppet 7", value: 7}},
          {setfile: {name: "Debian 10", value: "debian10-64"}, puppet: {collection: "puppet5", name: "Puppet 5", value: 5}},
          {setfile: {name: "Debian 10", value: "debian10-64"}, puppet: {collection: "puppet6", name: "Puppet 6", value: 6}},
          {setfile: {name: "Debian 10", value: "debian10-64"}, puppet: {collection: "puppet7", name: "Puppet 7", value: 7}},
        )
      end

      context 'when minimum_major_puppet_version is set to 6' do
        let(:minimum_major_puppet_version) { '6' }

        it 'is expected to contain supported os / puppet version combinations excluding puppet 5' do
          is_expected.to contain_exactly(
            {setfile: {name: "CentOS 7", value: "centos7-64"}, puppet: {collection: "puppet6", name: "Puppet 6", value: 6}},
            {setfile: {name: "CentOS 7", value: "centos7-64"}, puppet: {collection: "puppet7", name: "Puppet 7", value: 7}},
            {setfile: {name: "CentOS 8", value: "centos8-64"}, puppet: {collection: "puppet6", name: "Puppet 6", value: 6}},
            {setfile: {name: "CentOS 8", value: "centos8-64"}, puppet: {collection: "puppet7", name: "Puppet 7", value: 7}},
            {setfile: {name: "CentOS 9", value: "centos9-64"}, puppet: {collection: "puppet6", name: "Puppet 6", value: 6}},
            {setfile: {name: "CentOS 9", value: "centos9-64"}, puppet: {collection: "puppet7", name: "Puppet 7", value: 7}},
            {setfile: {name: "Debian 9", value: "debian9-64"}, puppet: {collection: "puppet6", name: "Puppet 6", value: 6}},
            {setfile: {name: "Debian 9", value: "debian9-64"}, puppet: {collection: "puppet7", name: "Puppet 7", value: 7}},
            {setfile: {name: "Debian 10", value: "debian10-64"}, puppet: {collection: "puppet6", name: "Puppet 6", value: 6}},
            {setfile: {name: "Debian 10", value: "debian10-64"}, puppet: {collection: "puppet7", name: "Puppet 7", value: 7}},
          )
        end
      end

      context 'when beaker_pidfile_workaround is true' do
        let(:beaker_pidfile_workaround) { true }

        it 'is expected to contain supported os / puppet version combinations with image option' do
          is_expected.to contain_exactly(
            {setfile: {name: "CentOS 7", value: "centos7-64{image=centos:7.6.1810}"}, puppet: {name: "Puppet 7", value: 7, collection: "puppet7"}},
            {setfile: {name: "CentOS 7", value: "centos7-64{image=centos:7.6.1810}"}, puppet: {name: "Puppet 6", value: 6, collection: "puppet6"}},
            {setfile: {name: "CentOS 7", value: "centos7-64{image=centos:7.6.1810}"}, puppet: {name: "Puppet 5", value: 5, collection: "puppet5"}},
            {setfile: {name: "CentOS 9", value: "centos9-64"}, puppet: {collection: "puppet6", name: "Puppet 6", value: 6}},
            {setfile: {name: "CentOS 9", value: "centos9-64"}, puppet: {collection: "puppet7", name: "Puppet 7", value: 7}},
            {setfile: {name: "Debian 9", value: "debian9-64"}, puppet: {name: "Puppet 7", value: 7, collection: "puppet7"}},
            {setfile: {name: "Debian 9", value: "debian9-64"}, puppet: {name: "Puppet 6", value: 6, collection: "puppet6"}},
            {setfile: {name: "Debian 9", value: "debian9-64"}, puppet: {name: "Puppet 5", value: 5, collection: "puppet5"}},
            {setfile: {name: "Debian 10", value: "debian10-64"}, puppet: {name: "Puppet 7", value: 7, collection: "puppet7"}},
            {setfile: {name: "Debian 10", value: "debian10-64"}, puppet: {name: "Puppet 6", value: 6, collection: "puppet6"}},
            {setfile: {name: "Debian 10", value: "debian10-64"}, puppet: {name: "Puppet 5", value: 5, collection: "puppet5"}}
          )
        end
      end

      context 'when beaker_use_fqdn is true' do
        let(:beaker_use_fqdn) { true }

        it 'is expected to contain supported os / puppet version combinations with hostname option' do
          is_expected.to contain_exactly(
            {setfile: {name: "CentOS 7", value: "centos7-64{hostname=centos7-64-puppet7.example.com}"}, puppet: {name: "Puppet 7", value: 7, collection: "puppet7"}},
            {setfile: {name: "CentOS 7", value: "centos7-64{hostname=centos7-64-puppet6.example.com}"}, puppet: {name: "Puppet 6", value: 6, collection: "puppet6"}},
            {setfile: {name: "CentOS 7", value: "centos7-64{hostname=centos7-64-puppet5.example.com}"}, puppet: {name: "Puppet 5", value: 5, collection: "puppet5"}},
            {setfile: {name: "CentOS 8", value: "centos8-64{hostname=centos8-64-puppet7.example.com}"}, puppet: {name: "Puppet 7", value: 7, collection: "puppet7"}},
            {setfile: {name: "CentOS 8", value: "centos8-64{hostname=centos8-64-puppet6.example.com}"}, puppet: {name: "Puppet 6", value: 6, collection: "puppet6"}},
            {setfile: {name: "CentOS 8", value: "centos8-64{hostname=centos8-64-puppet5.example.com}"}, puppet: {name: "Puppet 5", value: 5, collection: "puppet5"}},
            {setfile: {name: "CentOS 9", value: "centos9-64{hostname=centos9-64-puppet7.example.com}"}, puppet: {name: "Puppet 7", value: 7, collection: "puppet7"}},
            {setfile: {name: "CentOS 9", value: "centos9-64{hostname=centos9-64-puppet6.example.com}"}, puppet: {name: "Puppet 6", value: 6, collection: "puppet6"}},
            {setfile: {name: "Debian 9", value: "debian9-64{hostname=debian9-64-puppet7.example.com}"}, puppet: {name: "Puppet 7", value: 7, collection: "puppet7"}},
            {setfile: {name: "Debian 9", value: "debian9-64{hostname=debian9-64-puppet6.example.com}"}, puppet: {name: "Puppet 6", value: 6, collection: "puppet6"}},
            {setfile: {name: "Debian 9", value: "debian9-64{hostname=debian9-64-puppet5.example.com}"}, puppet: {name: "Puppet 5", value: 5, collection: "puppet5"}},
            {setfile: {name: "Debian 10", value: "debian10-64{hostname=debian10-64-puppet7.example.com}"}, puppet: {name: "Puppet 7", value: 7, collection: "puppet7"}},
            {setfile: {name: "Debian 10", value: "debian10-64{hostname=debian10-64-puppet6.example.com}"}, puppet: {name: "Puppet 6", value: 6, collection: "puppet6"}},
            {setfile: {name: "Debian 10", value: "debian10-64{hostname=debian10-64-puppet5.example.com}"}, puppet: {name: "Puppet 5", value: 5, collection: "puppet5"}}
          )
        end
      end
    end
  end
end
