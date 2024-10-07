# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'puppet_metadata'
  s.version     = '4.5.0'
  s.authors     = ['Vox Pupuli', 'Ewoud Kohl van Wijngaarden']
  s.email       = ['voxpupuli@groups.io']
  s.homepage    = 'https://github.com/voxpupuli/puppet_metadata'
  s.summary     = 'Data structures for the Puppet Metadata'
  s.description = 'A package that provides abstractions for the Puppet Metadata'
  s.licenses    = 'Apache-2.0'

  s.required_ruby_version = Gem::Requirement.new('>= 2.7', '< 4')

  s.executables = ['metadata2gha', 'setfiles']
  s.files = Dir['lib/**/*.rb']
  s.extra_rdoc_files = ['README.md']
  s.rdoc_options << '--main' << 'README.md'

  s.add_runtime_dependency 'metadata-json-lint', '>= 2.0', '< 5'
  s.add_runtime_dependency 'semantic_puppet', '~> 1.0'

  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'rdoc', '~> 6.0'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'rspec-its', '~> 1.0'
  s.add_development_dependency 'voxpupuli-rubocop', '~> 2.8.0'
  s.add_development_dependency 'yard', '~> 0.9'
end
