# frozen_string_literal: true

# check for all operating systems, then add all supported versions
class ListMissingOSCommand < PuppetMetadata::BaseCommand
  def self.parser(options)
    OptionParser.new do |opts|
      opts.set_program_name 'For each OS, list releases that are not EoL and missing'
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

    if added.any?

      puts 'missing in metadata.json'
      added.each do |os, releases|
        puts "#{os} => #{releases.join(', ')}"
      end
    else
      puts 'no OS releases missing'
    end
  end
end
