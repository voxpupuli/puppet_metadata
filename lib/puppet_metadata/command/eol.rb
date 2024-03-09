# frozen_string_literal: true

# Show which operating systems are end of life
class EolCommand < PuppetMetadata::BaseCommand
  def self.parser(options)
    OptionParser.new do |opts|
      opts.set_program_name 'Show which operating systems are end of life'
      opts.on('--at DATE', Date, 'The date to use') do |value|
        options[:at] = value
      end
    end
  end

  def run
    eol = metadata.eol_operatingsystems(@options[:at])

    if eol.any?
      width = eol.each_key.map(&:length).max

      puts 'Found EOL operating systems'
      eol.each do |os, versions|
        puts "#{os.ljust(width)} #{versions.join(', ')}"
      end
    else
      puts 'All operating systems up to date'
    end
  end
end
