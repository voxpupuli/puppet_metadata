# puppet_metadata

The gem intends to provide an abstraction over Puppet's metadata.json file. Its API allow easy iteration over its illogical data structures.

## Generating Github Actions outputs

To get outputs [usable in Github Actions](https://docs.github.com/en/free-pro-team@latest/actions/reference/workflow-commands-for-github-actions), there is the `metadata2gha` command available. This generates based on metadata.json, such as [Beaker](https://github.com/voxpupuli/beaker) setfiles, Puppet major versions and a Puppet unit test matrix.

```console
$ metadata2gha-beaker
::set-output name=beaker_setfiles::[{"name":"CentOS 7","value":"centos7-64"},{"name":"CentOS 8","value":"centos8-64"},{"name":"Debian 10","value":"debian10-64"},{"name":"Ubuntu 18.04","value":"ubuntu1804-64"}]
::set-output name=puppet_major_versions::[{"name":"Puppet 6","value":6,"collection":"puppet6"},{"name":"Puppet 5","value":5,"collection":"puppet5"}]
::set-output name=puppet_unit_test_matrix::[{"puppet":6,"ruby":"2.5"},{"puppet":5,"ruby":"2.4"}]
```

Beaker setfiles formatted for readability:
```json
[
  {
    "name": "CentOS 7",
    "value": "centos7-64"
  },
  {
    "name": "CentOS 8",
    "value": "centos8-64"
  },
  {
    "name": "Debian 10",
    "value": "debian10-64"
  },
  {
    "name": "Ubuntu 18.04",
    "value": "ubuntu1804-64"
  }
]
```

Puppet major versions formatted for readability:
```json
[
  {
    "name": "Puppet 6",
    "value": 6,
    "collection": "puppet6"
  },
  {
    "name": "Puppet 5",
    "value": 5,
    "collection": "puppet5"
  }
]
```

Puppet unit test matrix formatted for readability:
```json
[
  {
    "puppet": 6,
    "ruby": "2.5"
  },
  {
    "puppet": 5,
    "ruby": "2.4"
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
