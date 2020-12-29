require 'spec_helper'

describe PuppetMetadata::GithubActions do
  subject { described_class.new(PuppetMetadata::Metadata.new(JSON.parse(JSON.dump(metadata)))) }
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
          operatingsystemrelease: ['7', '8'],
        },
        {
          operatingsystem: 'Debian',
          operatingsystemrelease: ['9', '10'],
        },
      ],
    }
  end

  describe 'outputs' do
    subject { super().outputs }

    it { is_expected.to be_an_instance_of(Hash) }
    it { expect(subject.keys).to contain_exactly(:beaker_setfiles, :beaker_setfile_names, :beaker_setfile_values, :puppet_major_versions, :puppet_major_version_numbers, :puppet_unit_test_matrix) }

    describe 'beaker_setfiles' do
      subject { super()[:beaker_setfiles] }

      it { is_expected.to be_an_instance_of(Array) }
      it 'is expected to contain CentOS 7 and 8 + Debian 9 and 10' do
        is_expected.to contain_exactly(
          {name: "CentOS 7", value: "centos7-64"},
          {name: "CentOS 8", value: "centos8-64"},
          {name: "Debian 9", value: "debian9-64"},
          {name: "Debian 10", value: "debian10-64"},
        )
      end
    end

    describe 'beaker_setfile_names' do
      subject { super()[:beaker_setfile_names] }

      it { is_expected.to be_an_instance_of(Array) }
      it 'is expected to contain CentOS 7 and 8 + Debian 9 and 10' do
        is_expected.to contain_exactly("CentOS 7", "CentOS 8", "Debian 9", "Debian 10")
      end
    end

    describe 'beaker_setfile_values' do
      subject { super()[:beaker_setfile_values] }

      it { is_expected.to be_an_instance_of(Hash) }
      it 'is expected to contain CentOS 7 and 8 + Debian 9 and 10' do
        is_expected.to eq({
          "CentOS 7" => "centos7-64",
          "CentOS 8" => "centos8-64",
          "Debian 9" => "debian9-64",
          "Debian 10" => "debian10-64",
        })
      end
    end

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
    end

    describe 'puppet_major_version_numbers' do
      subject { super()[:puppet_major_version_numbers] }

      it { is_expected.to be_an_instance_of(Array) }
      it 'is expected to contain major versions 3, 4, 5, 6, 7 and 8' do
        is_expected.to eq([8, 7, 6, 5, 4, 3])
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
    end
  end
end
