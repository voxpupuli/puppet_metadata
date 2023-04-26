begin
  require 'simplecov'
  require 'simplecov-console'
  require 'codecov'
rescue LoadError
else
  SimpleCov.start do
    track_files 'lib/**/*.rb'

    add_filter '/spec'

    enable_coverage :branch

    # do not track vendored files
    add_filter '/vendor'
    add_filter '/.vendor'
  end

  SimpleCov.formatters = [
    SimpleCov::Formatter::Console,
    SimpleCov::Formatter::Codecov,
  ]
end

require 'rspec/core'
require 'rspec/its'
require 'puppet_metadata'

# copied from https://stackoverflow.com/a/74965697
# tell rspec to not shorten the diff between what it expects and what it got
RSpec.configure do |rspec|
  rspec.expect_with :rspec do |c|
    c.max_formatted_output_length = nil
  end
end
