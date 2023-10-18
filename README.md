# puppet_metadata

[![License](https://img.shields.io/github/license/voxpupuli/puppet_metadata.svg)](https://github.com/voxpupuli/puppet_metadata/blob/master/LICENSE)
[![Test](https://github.com/voxpupuli/puppet_metadata/actions/workflows/test.yml/badge.svg)](https://github.com/voxpupuli/puppet_metadata/actions/workflows/test.yml)
[![codecov](https://codecov.io/gh/voxpupuli/puppet_metadata/branch/master/graph/badge.svg?token=Mypkl78hvK)](https://codecov.io/gh/voxpupuli/puppet_metadata)
[![Release](https://github.com/voxpupuli/puppet_metadata/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/puppet_metadata/actions/workflows/release.yml)
[![RubyGem Version](https://img.shields.io/gem/v/puppet_metadata.svg)](https://rubygems.org/gems/puppet_metadata)
[![RubyGem Downloads](https://img.shields.io/gem/dt/puppet_metadata.svg)](https://rubygems.org/gems/puppet_metadata)
[![Donated by Ewoud Kohl van Wijngaarden](https://img.shields.io/badge/donated%20by-Ewoud%20Kohl%20van%20Wijngaarden-fb7047.svg)](#transfer-notice)

The gem intends to provide an abstraction over Puppet's metadata.json file. Its API allow easy iteration over its illogical data structures.

## Generating Github Actions outputs

To get outputs [usable in Github Actions](https://docs.github.com/en/free-pro-team@latest/actions/reference/workflow-commands-for-github-actions), there is the `metadata2gha` command available. This generates based on metadata.json, such as [Beaker](https://github.com/voxpupuli/beaker) setfiles, Puppet major versions and a Puppet unit test matrix.

```console
$ metadata2gha
puppet_major_versions=[{"name":"Puppet 7","value":7,"collection":"puppet7"},{"name":"Puppet 6","value":6,"collection":"puppet6"}]
puppet_unit_test_matrix=[{"puppet":7,"ruby":"2.7"},{"puppet":6,"ruby":"2.5"}]
github_action_test_matrix=[{"setfile":{"name":"Debian 11","value":"debian11-64"},"puppet":{"name":"Puppet 7","value":7,"collection":"puppet7"}},{"setfile":{"name":"Debian 11","value":"debian11-64"},"puppet":{"name":"Puppet 6","value":6,"collection":"puppet6"}}]
```

Puppet major versions formatted for readability:
```json
[
  {
    "name": "Puppet 7",
    "value": 7,
    "collection": "puppet7"
  },
  {
    "name": "Puppet 6",
    "value": 6,
    "collection": "puppet6"
  }
]
```

Puppet unit test matrix formatted for readability:
```json
[
  {
    "puppet": 7,
    "ruby": "2.7"
  },
  {
    "puppet": 6,
    "ruby": "2.5"
  }
]
```

GitHub Action test matrix formatted for readability
```json
[
  {
    "setfile": {
      "name": "Debian 11",
      "value": "debian11-64"
    },
    "puppet": {
      "name": "Puppet 7",
      "value": 7,
      "collection": "puppet7"
    }
  },
  {
    "setfile": {
      "name": "Debian 11",
      "value": "debian11-64"
    },
    "puppet": {
      "name": "Puppet 6",
      "value": 6,
      "collection": "puppet6"
    }
  }
]
```

It is also possible to specify the path to metadata.json and customize the setfiles. For example, to ensure the setfiles use FQDNs and apply the [systemd PIDFile workaround under docker](https://github.com/docker/for-linux/issues/835). This either means either using an older image (CentOS 7, Ubuntu 16.04) or skipping (CentOS 8).

```console
$ metadata2gha --use-fqdn --pidfile-workaround true /path/to/metadata.json
```

This results in the following JSON data
```json
[
  {
    "name": "CentOS 7",
    "value": "centos7-64{hostname=centos7-64.example.com,image=centos:7.6.1810}"
  },
  {
    "name": "Debian 10",
    "value": "debian10-64{hostname=debian10-64.example.com}"
  },
  {
    "name": "Ubuntu 18.04",
    "value": "ubuntu1804-64{hostname=ubuntu1804-64.example.com}"
  }
]
```

It is also possible to specify a comma separated list of operating systems as used in `metadata.json` (`CentOS,Ubuntu`).

## Work with the API

The API can be initialised like this:

```ruby
require 'puppet_metadata'
metadata = PuppetMetadata.read('/path/to/a/metadata.json')
```

The metadata object has several different methods that we can call

### List all supported operating systems

```
[9] pry(main)> metadata.operatingsystems
=> {"Archlinux"=>nil, "Gentoo"=>nil, "Fedora"=>["32", "33"], "CentOS"=>["7", "8"], "RedHat"=>["7", "8"], "Ubuntu"=>["18.04"], "Debian"=>["9", "10"], "VirtuozzoLinux"=>["7"]}
[10] pry(main)>
```

### List supported major puppet versions

```
[10] pry(main)> metadata.puppet_major_versions
=> [6, 7]
[11] pry(main)>
```

### Check if an operating systems is supported

```
[6] pry(main)> metadata.os_release_supported?('Archlinux', nil)
=> true
[7] pry(main)>
```

## Transfer Notice

This plugin was originally authored by [Ewoud Kohl van Wijngaarden](https://github.com/ekohl).
The maintainer preferred that [Vox Pupuli](https://voxpupuli.org/) take ownership of the module for future improvement and maintenance.
Existing pull requests and issues were transferred, please fork and continue to contribute [here](https://github.com/voxpupuli/puppet_metadata).

## License

This gem is licensed under the Apache-2 license.

## Release information

To make a new release, please do:
* Update the version in the puppet_metadata.gemspec file
* Install gems with `bundle install --with release --path .vendor`
* generate the changelog with `bundle exec rake changelog`
* Create a PR with it
* After it got merged, push a tag. A github workflow will do the actual release
