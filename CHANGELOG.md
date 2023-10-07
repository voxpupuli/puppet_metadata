# Changelog

## [3.3.0](https://github.com/voxpupuli/puppet_metadata/tree/3.3.0) (2023-10-07)

[Full Changelog](https://github.com/voxpupuli/puppet_metadata/compare/3.2.0...3.3.0)

**Implemented enhancements:**

- Add a name to the GHA beaker test matrix [\#35](https://github.com/voxpupuli/puppet_metadata/pull/35) ([ekohl](https://github.com/ekohl))

**Merged pull requests:**

- Update metadata-json-lint requirement from \>= 2.0, \< 4 to \>= 2.0, \< 5 [\#101](https://github.com/voxpupuli/puppet_metadata/pull/101) ([dependabot[bot]](https://github.com/apps/dependabot))

## [3.2.0](https://github.com/voxpupuli/puppet_metadata/tree/3.2.0) (2023-08-11)

[Full Changelog](https://github.com/voxpupuli/puppet_metadata/compare/3.1.0...3.2.0)

**Implemented enhancements:**

- Implement OracleLinux support [\#98](https://github.com/voxpupuli/puppet_metadata/pull/98) ([bastelfreak](https://github.com/bastelfreak))

## [3.1.0](https://github.com/voxpupuli/puppet_metadata/tree/3.1.0) (2023-07-24)

[Full Changelog](https://github.com/voxpupuli/puppet_metadata/compare/2.1.1...3.1.0)

**Implemented enhancements:**

- Use the none collection on some distros [\#91](https://github.com/voxpupuli/puppet_metadata/pull/91) ([ekohl](https://github.com/ekohl))

**Merged pull requests:**

- Implement rubocop [\#50](https://github.com/voxpupuli/puppet_metadata/pull/50) ([bastelfreak](https://github.com/bastelfreak))

## [2.1.1](https://github.com/voxpupuli/puppet_metadata/tree/2.1.1) (2023-04-29)

[Full Changelog](https://github.com/voxpupuli/puppet_metadata/compare/3.0.0...2.1.1)

## [3.0.0](https://github.com/voxpupuli/puppet_metadata/tree/3.0.0) (2023-04-29)

[Full Changelog](https://github.com/voxpupuli/puppet_metadata/compare/2.1.0...3.0.0)

**Breaking changes:**

- Drop EoL Ruby 2.4/2.5/2.6 [\#81](https://github.com/voxpupuli/puppet_metadata/pull/81) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- GCG: Add faraday-retry dep [\#86](https://github.com/voxpupuli/puppet_metadata/pull/86) ([bastelfreak](https://github.com/bastelfreak))
- Fedora: Fix typo in supported puppet versions [\#83](https://github.com/voxpupuli/puppet_metadata/pull/83) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- add dummy CI job we can depend on [\#85](https://github.com/voxpupuli/puppet_metadata/pull/85) ([bastelfreak](https://github.com/bastelfreak))
- CI: Dont install libyaml-dev [\#84](https://github.com/voxpupuli/puppet_metadata/pull/84) ([bastelfreak](https://github.com/bastelfreak))
- CI: Build gems with strictness and verbosity [\#82](https://github.com/voxpupuli/puppet_metadata/pull/82) ([bastelfreak](https://github.com/bastelfreak))

## [2.1.0](https://github.com/voxpupuli/puppet_metadata/tree/2.1.0) (2023-04-26)

[Full Changelog](https://github.com/voxpupuli/puppet_metadata/compare/2.0.0...2.1.0)

**Implemented enhancements:**

- Puppet 8: Run unit tests on Ruby 3.2 [\#75](https://github.com/voxpupuli/puppet_metadata/pull/75) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- Ubuntu 18.04: Fix EoL date: 2023-04-15-\>2023-05-31 [\#77](https://github.com/voxpupuli/puppet_metadata/pull/77) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- rspec: print full diff for hashes [\#78](https://github.com/voxpupuli/puppet_metadata/pull/78) ([bastelfreak](https://github.com/bastelfreak))
- dependabot: check for github actions and gems & CI: Run on merges to master [\#74](https://github.com/voxpupuli/puppet_metadata/pull/74) ([bastelfreak](https://github.com/bastelfreak))
- Update the README to reflect current command output [\#73](https://github.com/voxpupuli/puppet_metadata/pull/73) ([ekohl](https://github.com/ekohl))

## [2.0.0](https://github.com/voxpupuli/puppet_metadata/tree/2.0.0) (2022-12-20)

[Full Changelog](https://github.com/voxpupuli/puppet_metadata/compare/1.10.0...2.0.0)

**Breaking changes:**

- Enable AlmaLinux Acceptance testing [\#70](https://github.com/voxpupuli/puppet_metadata/pull/70) ([bastelfreak](https://github.com/bastelfreak))
- Enable Rocky Acceptance testing [\#69](https://github.com/voxpupuli/puppet_metadata/pull/69) ([bastelfreak](https://github.com/bastelfreak))
- Drop unused beaker\_setfiles output [\#66](https://github.com/voxpupuli/puppet_metadata/pull/66) ([bastelfreak](https://github.com/bastelfreak))

## [1.10.0](https://github.com/voxpupuli/puppet_metadata/tree/1.10.0) (2022-12-20)

[Full Changelog](https://github.com/voxpupuli/puppet_metadata/compare/1.9.0...1.10.0)

**Implemented enhancements:**

- beaker: append puppet version to hostname [\#65](https://github.com/voxpupuli/puppet_metadata/pull/65) ([bastelfreak](https://github.com/bastelfreak))
- Implement --domain option [\#63](https://github.com/voxpupuli/puppet_metadata/pull/63) ([bastelfreak](https://github.com/bastelfreak))
- Add --minimum-major-puppet-version option [\#59](https://github.com/voxpupuli/puppet_metadata/pull/59) ([alexjfisher](https://github.com/alexjfisher))

**Fixed bugs:**

- Beaker jobs: correct generated setfiles [\#64](https://github.com/voxpupuli/puppet_metadata/pull/64) ([bastelfreak](https://github.com/bastelfreak))

## [1.9.0](https://github.com/voxpupuli/puppet_metadata/tree/1.9.0) (2022-12-05)

[Full Changelog](https://github.com/voxpupuli/puppet_metadata/compare/1.8.0...1.9.0)

**Implemented enhancements:**

- write to GITHUB\_OUTPUT instead of using set-output [\#60](https://github.com/voxpupuli/puppet_metadata/pull/60) ([evgeni](https://github.com/evgeni))

## [1.8.0](https://github.com/voxpupuli/puppet_metadata/tree/1.8.0) (2022-08-05)

[Full Changelog](https://github.com/voxpupuli/puppet_metadata/compare/1.7.0...1.8.0)

**Implemented enhancements:**

- Add Ubuntu 22.04 metadata [\#55](https://github.com/voxpupuli/puppet_metadata/pull/55) ([smortex](https://github.com/smortex))

## [1.7.0](https://github.com/voxpupuli/puppet_metadata/tree/1.7.0) (2022-06-25)

[Full Changelog](https://github.com/voxpupuli/puppet_metadata/compare/1.6.0...1.7.0)

**Implemented enhancements:**

- Enable Ruby 3.1 in CI [\#49](https://github.com/voxpupuli/puppet_metadata/pull/49) ([bastelfreak](https://github.com/bastelfreak))
- Add AlmaLinux and Rocky [\#48](https://github.com/voxpupuli/puppet_metadata/pull/48) ([bastelfreak](https://github.com/bastelfreak))
- Add expected EOL dates for current FreeBSD releases [\#45](https://github.com/voxpupuli/puppet_metadata/pull/45) ([smortex](https://github.com/smortex))

**Fixed bugs:**

- README.md: Fix internal link to other section [\#53](https://github.com/voxpupuli/puppet_metadata/pull/53) ([bastelfreak](https://github.com/bastelfreak))
- Apply fixes to supported\_releases [\#51](https://github.com/voxpupuli/puppet_metadata/pull/51) ([ekohl](https://github.com/ekohl))
- supported\_releases: treat OSes with `nil` as EoL date as non-EoL [\#46](https://github.com/voxpupuli/puppet_metadata/pull/46) ([bastelfreak](https://github.com/bastelfreak))

## [1.6.0](https://github.com/voxpupuli/puppet_metadata/tree/1.6.0) (2022-06-22)

[Full Changelog](https://github.com/voxpupuli/puppet_metadata/compare/1.5.0...1.6.0)

**Implemented enhancements:**

- add latest freebsd releases [\#43](https://github.com/voxpupuli/puppet_metadata/pull/43) ([Flipez](https://github.com/Flipez))

## [1.5.0](https://github.com/voxpupuli/puppet_metadata/tree/1.5.0) (2022-06-22)

[Full Changelog](https://github.com/voxpupuli/puppet_metadata/compare/1.4.0...1.5.0)

**Implemented enhancements:**

- Add supported\_releases to get all non-EoL OS versions [\#41](https://github.com/voxpupuli/puppet_metadata/pull/41) ([bastelfreak](https://github.com/bastelfreak))
- Add support for Ubuntu 22.04 [\#39](https://github.com/voxpupuli/puppet_metadata/pull/39) ([smortex](https://github.com/smortex))

## [1.4.0](https://github.com/voxpupuli/puppet_metadata/tree/1.4.0) (2022-02-15)

[Full Changelog](https://github.com/voxpupuli/puppet_metadata/compare/1.3.0...1.4.0)

**Implemented enhancements:**

- Add Arch Linux support [\#37](https://github.com/voxpupuli/puppet_metadata/pull/37) ([ekohl](https://github.com/ekohl))

## [1.3.0](https://github.com/voxpupuli/puppet_metadata/tree/1.3.0) (2022-02-07)

[Full Changelog](https://github.com/voxpupuli/puppet_metadata/compare/1.2.0...1.3.0)

**Implemented enhancements:**

- Add CentOS 9 [\#36](https://github.com/voxpupuli/puppet_metadata/pull/36) ([kajinamit](https://github.com/kajinamit))

## [1.2.0](https://github.com/voxpupuli/puppet_metadata/tree/1.2.0) (2021-10-23)

[Full Changelog](https://github.com/voxpupuli/puppet_metadata/compare/1.1.1...1.2.0)

**Fixed bugs:**

- Fix AIO packages for Debian 8 [\#28](https://github.com/voxpupuli/puppet_metadata/pull/28) ([smortex](https://github.com/smortex))

**Merged pull requests:**

- Ruby refactoring [\#30](https://github.com/voxpupuli/puppet_metadata/pull/30) ([MrGoumX](https://github.com/MrGoumX))

## [1.1.1](https://github.com/voxpupuli/puppet_metadata/tree/1.1.1) (2021-08-21)

[Full Changelog](https://github.com/voxpupuli/puppet_metadata/compare/1.1.0...1.1.1)

**Fixed bugs:**

- Respect fqdn/pidfile options while generating actions matrix [\#26](https://github.com/voxpupuli/puppet_metadata/pull/26) ([root-expert](https://github.com/root-expert))

## [1.1.0](https://github.com/voxpupuli/puppet_metadata/tree/1.1.0) (2021-08-17)

[Full Changelog](https://github.com/voxpupuli/puppet_metadata/compare/1.0.0...1.1.0)

**Implemented enhancements:**

- Get ready for Debian 11 [\#24](https://github.com/voxpupuli/puppet_metadata/pull/24) ([smortex](https://github.com/smortex))

## [1.0.0](https://github.com/voxpupuli/puppet_metadata/tree/1.0.0) (2021-08-11)

[Full Changelog](https://github.com/voxpupuli/puppet_metadata/compare/0.4.0...1.0.0)

**Implemented enhancements:**

- Track known-good os and puppet combinations [\#21](https://github.com/voxpupuli/puppet_metadata/pull/21) ([smortex](https://github.com/smortex))

## [0.4.0](https://github.com/voxpupuli/puppet_metadata/tree/0.4.0) (2021-08-06)

[Full Changelog](https://github.com/voxpupuli/puppet_metadata/compare/0.3.0...0.4.0)

**Implemented enhancements:**

- metadata-json-lint: Allow 3.x [\#18](https://github.com/voxpupuli/puppet_metadata/pull/18) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- Fix broken GHA release job [\#20](https://github.com/voxpupuli/puppet_metadata/pull/20) ([bastelfreak](https://github.com/bastelfreak))
- Handle modules without a Puppet version upper bound [\#14](https://github.com/voxpupuli/puppet_metadata/pull/14) ([ekohl](https://github.com/ekohl))

**Merged pull requests:**

- Update README.md with badges; publish gem to GHA/rubygems; add missing license [\#17](https://github.com/voxpupuli/puppet_metadata/pull/17) ([bastelfreak](https://github.com/bastelfreak))

## [0.3.0](https://github.com/voxpupuli/puppet_metadata/tree/0.3.0) (2020-11-17)
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


\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
