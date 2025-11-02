# frozen_string_literal: true

# check for all operating systems, then add all supported versions
class AddSupportedOSCommand < PuppetMetadata::BaseCommand
  def self.parser(options)
    OptionParser.new do |opts|
      opts.set_program_name 'Add supported operating systems to metadata.json'
      opts.on('--at DATE', Date, 'The date to use') do |value|
        options[:at] = value
      end
      opts.on('--os operatingsystem', nil, 'Only honour the specific operating system') do |value|
        options[:os] = value
      end
    end
  end

  def run
    added = metadata.add_supported_operatingsystems(@options[:at], @options[:os])

    return unless added.any?

    PuppetMetadata.write(filename, metadata)
    puts 'Added support:'
    added.each do |os, releases|
      puts "#{os} => #{releases.join(', ')}"
    end
  end
end
