# frozen_string_literal: true

# check for all operating systems, then add all supported versions
class AddSupportedOSCommand < PuppetMetadata::BaseCommand
  def self.parser(options)
    OptionParser.new do |opts|
      opts.set_program_name 'Add supported operating systems to metadata.json'
      opts.on('--at DATE', Date, 'The date to use') do |value|
        options[:at] = value
      end
    end
  end

  def run
    added = metadata.add_supported_operatingsystems

    return unless added.any?

    PuppetMetadata.write(filename, metadata)
    puts 'Added support:'
    added.each do |os, releases|
      puts "#{os} => #{releases.join(', ')}"
    end
  end
end
