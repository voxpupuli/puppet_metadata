require 'rspec/core/rake_task'
require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop) do |task|
  # These make the rubocop experience maybe slightly less terrible
  task.options = ['--display-cop-names', '--display-style-guide', '--extra-details']

  # Use Rubocop's Github Actions formatter if possible
  task.formatters << 'github' if ENV['GITHUB_ACTIONS'] == 'true'
end
RSpec::Core::RakeTask.new(:spec)

task :default => :spec

begin
  require 'rubygems'
  require 'github_changelog_generator/task'
rescue LoadError # rubocop:disable Lint/HandleExceptions
else
  GitHubChangelogGenerator::RakeTask.new :changelog do |config|
    config.exclude_labels = %w[duplicate question invalid wontfix wont-fix skip-changelog]
    config.user = 'voxpupuli'
    config.project = 'puppet_metadata'
    gem_version = Gem::Specification.load("#{config.project}.gemspec").version
    config.future_release = gem_version
  end
end
