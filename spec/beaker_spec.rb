# frozen_string_literal: true

require 'spec_helper'

describe PuppetMetadata::Beaker do
  describe 'os_release_to_setfile' do
    [
      ['CentOS', '7', ['centos7-64', 'CentOS 7']],
      ['CentOS', '8', ['centos8-64', 'CentOS 8']],
      ['CentOS', '9', ['centos9-64', 'CentOS 9']],
      ['Fedora', '36', ['fedora36-64', 'Fedora 36']],
      ['Fedora', '40', ['fedora40-64', 'Fedora 40']],
      ['Debian', '9', ['debian9-64', 'Debian 9']],
      ['Debian', '10', ['debian10-64', 'Debian 10']],
      ['Ubuntu', '18.04', ['ubuntu1804-64', 'Ubuntu 18.04']],
      ['Ubuntu', '20.04', ['ubuntu2004-64', 'Ubuntu 20.04']],
      ['Ubuntu', '22.04', ['ubuntu2204-64', 'Ubuntu 22.04']],
    ].each do |os, release, expected|
      it { expect(described_class.os_release_to_setfile(os, release)).to eq(expected) }
    end

    it { expect(described_class.os_release_to_setfile('SLES', '11')).to be_nil }

    context 'with pidfile_workaround' do
      describe 'true' do
        [
          ['CentOS', '6', ['centos6-64', 'CentOS 6']],
          ['CentOS', '7', ['centos7-64{image=centos:7.6.1810}', 'CentOS 7']],
          ['CentOS', '8', nil],
          ['CentOS', '9', ['centos9-64', 'CentOS 9']],
          ['Ubuntu', '18.04', ['ubuntu1804-64', 'Ubuntu 18.04']],
        ].each do |os, release, expected|
          it { expect(described_class.os_release_to_setfile(os, release, pidfile_workaround: true)).to eq(expected) }
        end

        describe 'domain' do
          it {
            expect(described_class.os_release_to_setfile('CentOS', '7', pidfile_workaround: true,
                                                                        domain: 'example.com')).to eq(['centos7-64{hostname=centos7-64.example.com,image=centos:7.6.1810}', 'CentOS 7'])
          }
        end
      end

      describe 'as an array' do
        it {
          expect(described_class.os_release_to_setfile('CentOS', '8',
                                                       pidfile_workaround: [])).to eq(['centos8-64', 'CentOS 8'])
        }

        it {
          expect(described_class.os_release_to_setfile('CentOS', '8',
                                                       pidfile_workaround: ['Debian'])).to eq(['centos8-64',
                                                                                               'CentOS 8',])
        }

        it { expect(described_class.os_release_to_setfile('CentOS', '8', pidfile_workaround: ['CentOS'])).to be_nil }
      end
    end

    context 'with domain' do
      it {
        expect(described_class.os_release_to_setfile('CentOS', '7', domain: 'mydomain.org')).to eq(['centos7-64{hostname=centos7-64.mydomain.org}', 'CentOS 7'])
      }
    end

    context 'with puppet_version' do
      [
        ['CentOS', '7', 'none', ['centos7-64', 'CentOS 7']],
        ['CentOS', '7', 'puppet7', ['centos7-64{hostname=centos7-64-puppet7}', 'CentOS 7']],
      ].each do |os, release, puppet_version, expected|
        it { expect(described_class.os_release_to_setfile(os, release, puppet_version: puppet_version)).to eq(expected) }
      end
    end

    context 'with hosts and no roles' do
      [
        ['Debian', '12', { 'foo' => nil }, ['debian12-64{hostname=foo}', 'Debian 12']],
        ['Debian', '12', { 'foo' => nil, 'bar' => nil }, ['debian12-64.ma{hostname=foo}-debian12-64.a{hostname=bar}', 'Debian 12']],
      ].each do |os, release, hosts, expected|
        it { expect(described_class.os_release_to_setfile(os, release, hosts: hosts)).to eq(expected) }
      end
    end

    context 'with hosts and roles' do
      [
        ['Debian', '12', { 'foo' => 'myrole.ma' }, ['debian12-64myrole.ma{hostname=foo}', 'Debian 12']],
        ['Debian', '12', { 'foo' => 'myrole,primary.ma' }, ['debian12-64myrole,primary.ma{hostname=foo}', 'Debian 12']],
        ['Debian', '12', { 'foo' => 'myrole,primary.ma', 'bar' => 'myrole,secondary.a' },
         ['debian12-64myrole,primary.ma{hostname=foo}-debian12-64myrole,secondary.a{hostname=bar}', 'Debian 12'],],
      ].each do |os, release, hosts, expected|
        it { expect(described_class.os_release_to_setfile(os, release, hosts: hosts)).to eq(expected) }
      end
    end

    context 'with hosts, roles and domain' do
      [
        ['Debian', '12', 'mydomain.org', { 'foo' => 'myrole,primary.ma', 'bar' => 'myrole,secondary.a' },
         ['debian12-64myrole,primary.ma{hostname=foo.mydomain.org}-debian12-64myrole,secondary.a{hostname=bar.mydomain.org}', 'Debian 12'],],
      ].each do |os, release, domain, hosts, expected|
        it { expect(described_class.os_release_to_setfile(os, release, domain: domain, hosts: hosts)).to eq(expected) }
      end
    end

    context 'with hosts, roles, domain and puppet_version' do
      [
        ['Debian', '12', 'mydomain.org', 'puppet7', { 'foo' => 'myrole,primary.ma', 'bar' => 'myrole,secondary.a' },
         ['debian12-64myrole,primary.ma{hostname=foo-puppet7.mydomain.org}-debian12-64myrole,secondary.a{hostname=bar-puppet7.mydomain.org}', 'Debian 12'],],
      ].each do |os, release, domain, puppet_version, hosts, expected|
        it { expect(described_class.os_release_to_setfile(os, release, domain: domain, puppet_version: puppet_version, hosts: hosts)).to eq(expected) }
      end
    end
  end
end
