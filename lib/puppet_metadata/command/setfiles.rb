# frozen_string_literal: true

# Show the various setfiles supported by the metadata
class SetfilesCommand < PuppetMetadata::BaseCommand
  def self.parser(_options)
    OptionParser.new do |opts|
      opts.set_program_name 'Show the various setfiles supported by the metadata'
    end
  end

  def run
    options = {
      domain: 'example.com',
      minimum_major_puppet_version: nil,
      beaker_fact: nil,
      beaker_hosts: nil,
    }

    metadata.github_actions(options).outputs[:puppet_beaker_test_matrix].each do |os|
      puts "BEAKER_SETFILE=\"#{os[:env]['BEAKER_SETFILE']}\""
    end
  end
end
