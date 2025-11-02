# puppet_metadata

[![License](https://img.shields.io/github/license/voxpupuli/puppet_metadata.svg)](https://github.com/voxpupuli/puppet_metadata/blob/master/LICENSE)
[![Test](https://github.com/voxpupuli/puppet_metadata/actions/workflows/test.yml/badge.svg)](https://github.com/voxpupuli/puppet_metadata/actions/workflows/test.yml)
[![codecov](https://codecov.io/gh/voxpupuli/puppet_metadata/branch/master/graph/badge.svg?token=Mypkl78hvK)](https://codecov.io/gh/voxpupuli/puppet_metadata)
[![Release](https://github.com/voxpupuli/puppet_metadata/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/puppet_metadata/actions/workflows/release.yml)
[![RubyGem Version](https://img.shields.io/gem/v/puppet_metadata.svg)](https://rubygems.org/gems/puppet_metadata)
[![RubyGem Downloads](https://img.shields.io/gem/dt/puppet_metadata.svg)](https://rubygems.org/gems/puppet_metadata)
[![Donated by Ewoud Kohl van Wijngaarden](https://img.shields.io/badge/donated%20by-Ewoud%20Kohl%20van%20Wijngaarden-fb7047.svg)](#transfer-notice)

The gem intends to provide an abstraction over Puppet's metadata.json file. Its API allow easy iteration over its illogical data structures.

* [New CLI interface in 6.0.0](#new-cli-interface-in-6.0.0)
* [Generating Github Actions outputs](#generating-github-actions-outputs)
* [Work with the API](#work-with-the-api)
    * [List all supported operating systems](#list-all-supported-operating-systems)
    * [List supported major puppet versions](#list-supported-major-puppet-versions)
    * [Check if an operating systems is supported](#check-if-an-operating-systems-is-supported)
    * [Get all versions for an Operating System that are not EoL](#get-all-versions-for-an-operating-system-that-are-not-eol)
    * [Get all versions for an Operating System that are not EoL after a certain date](#get-all-versions-for-an-operating-system-that-are-not-eol-after-a-certain-date)
* [List supported setfiles](list-supported-setfiles)
* [Transfer Notice](#transfer-notice)
* [License](#license)
* [Release information](#release-information)

## New CLI interface in 6.0.0

Version 6.0.0 introduces a new CLI interface, in `bin/puppet-metadata`.
It provides a new way of handling default CLI options, like the path to the metadata.json.

```
$ bundle exec bin/puppet-metadata --help
Usage: puppet-metadata [options] <action> [options]
        --filename METADATA          Metadata filename

ACTIONS
  eol                 Show which operating systems are end of life
  add_supported_os    Add supported operating systems to metadata.json

See 'puppet-metadata ACTION --help' for more information on a specific action.
```

`--filename ` is optional.
If ommitted, a metadata.json in the current directory will be parsed.

Each action is implemented as a file in `lib/puppet_metadata/command/*rb` and automatically loaded via `lib/puppet_metadata/command.rb`.

## List EoL OS releases in metadata.json

We can list all releases from metadata.json, that reached their EoL date:

```
$ bundle exec bin/puppet-metadata eol
Found EOL operating systems
Fedora 40
Ubuntu 20.04
```

You can also provide a date as YYYY-MM-DD to check for releases that are EoL at a specific date:

```
$ bundle exec bin/puppet-metadata eol --help
Usage: puppet-metadata eol [options]
        --at DATE                    The date to use
```

## Add supported OS releases to metadata.json

You can read the metadata.json, get all OSes, and afterwards add all releases that aren't EoL:
(as mentioned above, `--filename` is optional)

```
bundle exec bin/puppet-metadata --filename "$file" list_supported_os
```

Available parameters:

```
$ bundle exec bin/puppet-metadata add_supported_os --help
Usage: puppet-metadata add_supported_os [options]
        --at DATE                    The date to use
        --os operatingsystem         Only honour the specific operating system
```

## Generating Github Actions outputs

To get outputs [usable in Github Actions](https://docs.github.com/en/free-pro-team@latest/actions/reference/workflow-commands-for-github-actions), there is the `metadata2gha` command available. This generates based on metadata.json, such as [Beaker](https://github.com/voxpupuli/beaker) setfiles, Puppet major versions and a Puppet unit test matrix.

```console
$ metadata2gha
puppet_major_versions=[{"name":"Puppet 8","value":8,"collection":"puppet8"},{"name":"Puppet 7","value":7,"collection":"puppet7"}]
puppet_unit_test_matrix=[{"puppet":8,"ruby":"3.2"},{"puppet":7,"ruby":"2.7"}]
puppet_beaker_test_matrix=[{"name":"Puppet 8 - Debian 12","env":{"BEAKER_PUPPET_COLLECTION":"puppet8","BEAKER_SETFILE":"debian12-64{hostname=debian12-64-puppet8}"}},{"name":"Puppet 7 - Debian 12","env":{"BEAKER_PUPPET_COLLECTION":"puppet7","BEAKER_SETFILE":"debian12-64{hostname=debian12-64-puppet7}"}}]
```

Puppet major versions formatted for readability:
```json
[
  {
    "name": "Puppet 8",
    "value": 8,
    "collection": "puppet8"
  },
  {
    "name": "Puppet 7",
    "value": 7,
    "collection": "puppet7"
  }
]
```

Puppet unit test matrix formatted for readability:
```json
[
  {
    "puppet": 8,
    "ruby": "3.2"
  },
  {
    "puppet": 7,
    "ruby": "2.7"
  }
]
```

Beaker test matrix formatted for readability
```json
[
  {
    "name": "Puppet 8 - Debian 12",
    "env": {
      "BEAKER_PUPPET_COLLECTION": "puppet8",
      "BEAKER_SETFILE": "debian12-64{hostname=debian12-64-puppet8}"
    }
  },
  {
    "name": "Puppet 7 - Debian 12",
    "env": {
      "BEAKER_PUPPET_COLLECTION": "puppet7",
      "BEAKER_SETFILE": "debian12-64{hostname=debian12-64-puppet7}"
    }
  }
]
```

If you need custom hostname or multiple hosts in your integration tests this could be achived by using the --beaker-hosts option

Option argument is 'HOSTNAME:ROLES;HOSTNAME:..;..' where
- hosts are separated by ';'
- host number and roles are separated by ':'
- Roles follow beaker-hostgenerator syntax
If you don't need any extra roles use '1;2;..'

```console
$ metadata2gha --beaker-hosts 'foo:primary.ma;bar:secondary.a'
```

This results in the following JSON data
```json
[
  {
    "name": "Puppet 7 - Debian 12",
    "env": {
      "BEAKER_PUPPET_COLLECTION": "puppet7",
      "BEAKER_SETFILE": "debian12-64primary.ma{hostname=foo-puppet7}-debian12-64secondary.a{hostname=bar-puppet7}"
    }
  }
]
```

If you need to Expand the matrix ie by product versions it could be achived by using the --beaker-facter option

Option argument is 'FACT:LABEL:VALUE,VALUE,..' where
- Fact, label and values are separated by ':'
- Values are separated by ','

```console
$ metadata2gha --beaker-facter 'mongodb_repo_version:MongoDB:4.4,5.0,6.0,7.0'
```

This results in the following JSON data
```json
[
  {
    "name": "Puppet 7 - Debian 12 - MongoDB 4.4",
    "env": {
        "BEAKER_PUPPET_COLLECTION": "puppet7",
        "BEAKER_SETFILE": "debian12-64{hostname=debian12-64-puppet7}",
        "BEAKER_FACTER_mongodb_repo_version": "4.4"
    }
  },
  {
    "name": "Puppet 7 - Debian 12 - MongoDB 5.0",
    "env": {
      "BEAKER_PUPPET_COLLECTION": "puppet7",
      "BEAKER_SETFILE": "debian12-64{hostname=debian12-64-puppet7}",
      "BEAKER_FACTER_mongodb_repo_version": "5.0"
    }
  },
  {
    "name": "Puppet 7 - Debian 12 - MongoDB 6.0",
    "env": {
      "BEAKER_PUPPET_COLLECTION": "puppet7",
      "BEAKER_SETFILE": "debian12-64{hostname=debian12-64-puppet7}",
      "BEAKER_FACTER_mongodb_repo_version": "6.0"
    }
  },
  {
    "name": "Puppet 7 - Debian 12 - MongoDB 7.0",
    "env": {
      "BEAKER_PUPPET_COLLECTION": "puppet7",
      "BEAKER_SETFILE": "debian12-64{hostname=debian12-64-puppet7}",
      "BEAKER_FACTER_mongodb_repo_version": "7.0"
    }
  }
]
```

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

### Get all versions for an Operating System that are not EoL

```
[1] pry(main)> require 'puppet_metadata'
=> true
[2] pry(main)> PuppetMetadata::OperatingSystem.supported_releases('RedHat')
=> ["8", "9", "10"]
[3] pry(main)> PuppetMetadata::OperatingSystem.supported_releases('windows')
=> []
[4] pry(main)>
```

**For Operating systems without any known releases, an empty array is returned.**

### Get all versions for an Operating System that are not EoL after a certain date

```
[1] pry(main)> require 'puppet_metadata'
=> true
[2] pry(main)> PuppetMetadata::OperatingSystem.supported_releases('CentOS', Date.parse('2025-04-15'))
=> ["9", "10"]
[3] pry(main)>
```

CentOS 8 and older aren't listed.
8 is EoL since 2024-05-31.

## List supported setfiles

When running beaker on the CLI, you can specify a specific setfile. `puppet_metadata` provides `bin/setfiles` to list all setfiles:

```
$ bundle exec setfiles
Skipping EOL operating system Debian 10
Skipping EOL operating system Ubuntu 18.04
BEAKER_SETFILE="centos9-64{hostname=centos9-64-puppet8.example.com}"
BEAKER_SETFILE="centos9-64{hostname=centos9-64-puppet7.example.com}"
BEAKER_SETFILE="debian11-64{hostname=debian11-64-puppet8.example.com}"
BEAKER_SETFILE="debian11-64{hostname=debian11-64-puppet7.example.com}"
BEAKER_SETFILE="ubuntu2004-64{hostname=ubuntu2004-64-puppet8.example.com}"
BEAKER_SETFILE="ubuntu2004-64{hostname=ubuntu2004-64-puppet7.example.com}"
```

As an argument you can provide a path to a metadata.json. If none provided, it assumes that there's a metadata.json in the same directory where you run the command.
To make copy and paste easier, each setfile string is prefixed so it can directly be used as environment variable.

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
