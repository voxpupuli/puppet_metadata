# Changelog

## 0.3.0 - 2020-11-17
### Added
- Add a metadata2gha script. This allows generating Github Action matrices on the fly based on metadata.json which makes changing supported Puppet versions easier.

## 0.2.0 - 2020-11-05
### Breaking
- Include a human name in `os_release_to_setfile`. This changes the return type from a string to an array

### Changed
- Support an array for `pidfile_workaround`. This allows filtering on an OS if needed. Booleans are still supported.
- Skip CentOS 8 in Beaker if PIDFile is needed. There is no docker image where it works so it's best to skip it.

## 0.1.0 - 2020-10-18
### Added
- Initial version
