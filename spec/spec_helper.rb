# frozen_string_literal: true

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
