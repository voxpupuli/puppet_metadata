require 'spec_helper'

describe PuppetMetadata::Beaker do
  describe 'os_release_to_setfile' do
    [
      ['CentOS', '7', ['centos7-64', 'CentOS 7']],
      ['CentOS', '8', ['centos8-64', 'CentOS 8']],
      ['CentOS', '9', ['centos9-64', 'CentOS 9']],
      ['Fedora', '31', ['fedora31-64', 'Fedora 31']],
      ['Fedora', '32', ['fedora32-64', 'Fedora 32']],
      ['Debian', '9', ['debian9-64', 'Debian 9']],
      ['Debian', '10', ['debian10-64', 'Debian 10']],
      ['Ubuntu', '18.04', ['ubuntu1804-64', 'Ubuntu 18.04']],
      ['Ubuntu', '20.04', ['ubuntu2004-64', 'Ubuntu 20.04']],
      ['Ubuntu', '22.04', ['ubuntu2204-64', 'Ubuntu 22.04']],
    ].each do |os, release, expected|
      it { expect(described_class.os_release_to_setfile(os, release)).to eq(expected) }
    end

    it { expect(described_class.os_release_to_setfile('SLES', '11')).to be_nil }

    describe 'pidfile_workaround' do
      describe 'true' do
        [
          ['CentOS', '6', ['centos6-64', 'CentOS 6']],
          ['CentOS', '7', ['centos7-64{image=centos:7.6.1810}', 'CentOS 7']],
          ['CentOS', '8', nil],
          ['CentOS', '9', ['centos9-64', 'CentOS 9']],
          ['Ubuntu', '16.04', ['ubuntu1604-64{image=ubuntu:xenial-20191212}', 'Ubuntu 16.04']],
          ['Ubuntu', '18.04', ['ubuntu1804-64', 'Ubuntu 18.04']],
        ].each do |os, release, expected|
          it { expect(described_class.os_release_to_setfile(os, release, pidfile_workaround: true)).to eq(expected) }
        end

        describe 'use_fqdn' do
          it { expect(described_class.os_release_to_setfile('CentOS', '7', pidfile_workaround: true, use_fqdn: true)).to eq(['centos7-64{hostname=centos7-64.example.com,image=centos:7.6.1810}', 'CentOS 7']) }
        end
      end

      describe 'as an array' do
        it { expect(described_class.os_release_to_setfile('CentOS', '8', pidfile_workaround: [])).to eq(['centos8-64', 'CentOS 8']) }
        it { expect(described_class.os_release_to_setfile('CentOS', '8', pidfile_workaround: ['Debian'])).to eq(['centos8-64', 'CentOS 8']) }
        it { expect(described_class.os_release_to_setfile('CentOS', '8', pidfile_workaround: ['CentOS'])).to be_nil }
      end
    end
  end
end
