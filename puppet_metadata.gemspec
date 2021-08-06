# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = 'puppet_metadata'
  s.version     = '0.4.0'
  s.authors     = ['Vox Pupuli', 'Ewoud Kohl van Wijngaarden']
  s.email       = ['voxpupuli@groups.io']
  s.homepage    = 'http://github.com/voxpupuli/puppet_metadata'
  s.summary     = 'Data structures for the Puppet Metadata'
  s.description = 'A package that provides abstractions for the Puppet Metadata'
  s.licenses    = 'Apache-2.0'

  s.executables << 'metadata2gha'
  s.files = Dir['lib/**/*.rb']
  s.extra_rdoc_files = ['README.md']
  s.rdoc_options << '--main' << 'README.md'

  s.add_runtime_dependency 'metadata-json-lint', '>= 2.0', '< 4'
  s.add_runtime_dependency 'semantic_puppet', '~> 1.0'

  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'rspec-its', '~> 1.0'
  s.add_development_dependency 'rdoc', '~> 6.0'
  s.add_development_dependency 'yard', '~> 0.9'
end
