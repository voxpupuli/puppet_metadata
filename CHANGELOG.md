# Changelog

## [4.3.0](https://github.com/voxpupuli/puppet_metadata/tree/4.3.0) (2024-09-13)

[Full Changelog](https://github.com/voxpupuli/puppet_metadata/compare/4.2.0...4.3.0)

**Implemented enhancements:**

- Add support for Ubuntu 24.04 [\#145](https://github.com/voxpupuli/puppet_metadata/pull/145) ([root-expert](https://github.com/root-expert))

## [4.2.0](https://github.com/voxpupuli/puppet_metadata/tree/4.2.0) (2024-07-05)

[Full Changelog](https://github.com/voxpupuli/puppet_metadata/compare/4.1.0...4.2.0)

**Implemented enhancements:**

- Add script to display supported setfiles [\#142](https://github.com/voxpupuli/puppet_metadata/pull/142) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- Fix tests: Mark CentOS 7 as not supported [\#143](https://github.com/voxpupuli/puppet_metadata/pull/143) ([bastelfreak](https://github.com/bastelfreak))

## [4.1.0](https://github.com/voxpupuli/puppet_metadata/tree/4.1.0) (2024-06-28)

[Full Changelog](https://github.com/voxpupuli/puppet_metadata/compare/4.0.0...4.1.0)

**Implemented enhancements:**

- Update fedora versions, remove CentOS 8 from spec test [\#138](https://github.com/voxpupuli/puppet_metadata/pull/138) ([daberkow](https://github.com/daberkow))
- Debian 10: Add EoL date [\#137](https://github.com/voxpupuli/puppet_metadata/pull/137) ([bastelfreak](https://github.com/bastelfreak))
- Debian 12: Cleanup legacy non-AIO code [\#136](https://github.com/voxpupuli/puppet_metadata/pull/136) ([bastelfreak](https://github.com/bastelfreak))
- Rocky: Update EoL dates [\#135](https://github.com/voxpupuli/puppet_metadata/pull/135) ([bastelfreak](https://github.com/bastelfreak))
- AlmaLinux: Update EoL dates [\#134](https://github.com/voxpupuli/puppet_metadata/pull/134) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- Update voxpupuli-rubocop requirement from ~\> 2.7.0 to ~\> 2.8.0 [\#139](https://github.com/voxpupuli/puppet_metadata/pull/139) ([dependabot[bot]](https://github.com/apps/dependabot))
- Update voxpupuli-rubocop requirement from ~\> 2.6.0 to ~\> 2.7.0 [\#133](https://github.com/voxpupuli/puppet_metadata/pull/133) ([dependabot[bot]](https://github.com/apps/dependabot))

## [4.0.0](https://github.com/voxpupuli/puppet_metadata/tree/4.0.0) (2024-05-08)

[Full Changelog](https://github.com/voxpupuli/puppet_metadata/compare/3.7.1...4.0.0)

**Breaking changes:**

- Drop deprecated use\_fqdn option and github\_action\_test\_matrix output [\#130](https://github.com/voxpupuli/puppet_metadata/pull/130) ([ekohl](https://github.com/ekohl))
- Skip EOL operating systems in GHA acceptance tests [\#129](https://github.com/voxpupuli/puppet_metadata/pull/129) ([ekohl](https://github.com/ekohl))

**Implemented enhancements:**

- Add Ruby 3.3 to CI [\#128](https://github.com/voxpupuli/puppet_metadata/pull/128) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- OracleLinux: Correct EoL Date 2024-07-01-\>2024-12-31 [\#131](https://github.com/voxpupuli/puppet_metadata/pull/131) ([bastelfreak](https://github.com/bastelfreak))

## [3.7.1](https://github.com/voxpupuli/puppet_metadata/tree/3.7.1) (2024-04-25)

[Full Changelog](https://github.com/voxpupuli/puppet_metadata/compare/3.7.0...3.7.1)

**Fixed bugs:**

- Fix bug in metadata2gha options parsing [\#126](https://github.com/voxpupuli/puppet_metadata/pull/126) ([h-haaks](https://github.com/h-haaks))

## [3.7.0](https://github.com/voxpupuli/puppet_metadata/tree/3.7.0) (2024-04-25)

[Full Changelog](https://github.com/voxpupuli/puppet_metadata/compare/3.6.0...3.7.0)

**Implemented enhancements:**

- Add option to generate setfile with multiple hosts and roles [\#124](https://github.com/voxpupuli/puppet_metadata/pull/124) ([h-haaks](https://github.com/h-haaks))

**Merged pull requests:**

- Update voxpupuli-rubocop requirement from ~\> 2.5.0 to ~\> 2.6.0 [\#123](https://github.com/voxpupuli/puppet_metadata/pull/123) ([dependabot[bot]](https://github.com/apps/dependabot))

## [3.6.0](https://github.com/voxpupuli/puppet_metadata/tree/3.6.0) (2024-03-07)

[Full Changelog](https://github.com/voxpupuli/puppet_metadata/compare/3.5.0...3.6.0)

**Implemented enhancements:**

- add Debian 12 AIO builds for 7 and 8 [\#117](https://github.com/voxpupuli/puppet_metadata/pull/117) ([evgeni](https://github.com/evgeni))

**Fixed bugs:**

- mark Oracle/Alma/Rocky as pidfile incompatible [\#112](https://github.com/voxpupuli/puppet_metadata/pull/112) ([evgeni](https://github.com/evgeni))

**Merged pull requests:**

- Update voxpupuli-rubocop requirement from ~\> 2.4.0 to ~\> 2.5.0 [\#118](https://github.com/voxpupuli/puppet_metadata/pull/118) ([dependabot[bot]](https://github.com/apps/dependabot))
- Update voxpupuli-rubocop requirement from ~\> 2.0.0 to ~\> 2.4.0 [\#116](https://github.com/voxpupuli/puppet_metadata/pull/116) ([dependabot[bot]](https://github.com/apps/dependabot))
- Document API in README.md [\#34](https://github.com/voxpupuli/puppet_metadata/pull/34) ([bastelfreak](https://github.com/bastelfreak))

## [3.5.0](https://github.com/voxpupuli/puppet_metadata/tree/3.5.0) (2023-10-18)

[Full Changelog](https://github.com/voxpupuli/puppet_metadata/compare/3.4.0...3.5.0)

**Implemented enhancements:**

- Add support for Fedora Distro Puppet testing [\#104](https://github.com/voxpupuli/puppet_metadata/pull/104) ([ekohl](https://github.com/ekohl))
- Add Debian 12 [\#102](https://github.com/voxpupuli/puppet_metadata/pull/102) ([evgeni](https://github.com/evgeni))

## [3.4.0](https://github.com/voxpupuli/puppet_metadata/tree/3.4.0) (2023-10-11)

[Full Changelog](https://github.com/voxpupuli/puppet_metadata/compare/3.3.0...3.4.0)

**Implemented enhancements:**

- Support BEAKER\_FACTER\_\* env vars in beaker testing [\#108](https://github.com/voxpupuli/puppet_metadata/pull/108) ([ekohl](https://github.com/ekohl))

## [3.3.0](https://github.com/voxpupuli/puppet_metadata/tree/3.3.0) (2023-10-08)

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
