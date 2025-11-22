# frozen_string_literal: true

# Manage operating system versions in metadata.json
class OsVersionsCommand < PuppetMetadata::BaseCommand
  def self.parser(options)
    OptionParser.new do |opts|
      opts.set_program_name 'Manage operating system versions in metadata.json'
      opts.on('--at DATE', Date, 'The date to use for EOL checks') do |value|
        options[:at] = value
      end
      opts.on('--os OPERATINGSYSTEM', 'Only process the specific operating system') do |value|
        options[:os] = value
      end
      opts.on('--add-missing', 'Add missing supported OS versions to metadata.json') do
        options[:add_missing] = true
      end
      opts.on('--remove-eol', 'Remove EOL OS versions from metadata.json') do
        options[:remove_eol] = true
      end
    end
  end

  def run
    if @options[:add_missing] && @options[:remove_eol]
      # Run both operations in sequence
      add_missing_versions
      remove_eol_versions
    elsif @options[:add_missing]
      add_missing_versions
    elsif @options[:remove_eol]
      remove_eol_versions
    else
      list_versions
    end
  end

  private

  def add_missing_versions
    added = metadata.add_supported_operatingsystems(@options[:at], @options[:os])

    return unless added.any?

    PuppetMetadata.write(filename, metadata)
    puts 'Added support:'
    added.each do |os, releases|
      puts "#{os} => #{releases.join(', ')}"
    end
  end

  def remove_eol_versions
    removed = metadata.remove_eol_operatingsystems(@options[:at], @options[:os])

    return unless removed.any?

    PuppetMetadata.write(filename, metadata)
    puts 'Removed EOL operating systems:'
    removed.each do |os, releases|
      puts "#{os} => #{releases.join(', ')}"
    end
  end

  def list_versions
    require 'puppet_metadata/operatingsystem'

    # Collect all OS data
    supported_oses = {}
    eol_oses = {}

    oses = @options[:os] ? [@options[:os]] : metadata.operatingsystems.keys.sort

    oses.each do |os|
      current = metadata.operatingsystems[os]
      next if current.nil?

      if current.empty?
        supported_oses[os] = '(supports all versions)'
      else
        eol = current.select { |rel| PuppetMetadata::OperatingSystem.eol?(os, rel, @options[:at]) }
        non_eol = current - eol

        supported_oses[os] = non_eol.join(', ') if non_eol.any?
        eol_oses[os] = eol.join(', ') if eol.any?
      end
    end

    # Display supported OSes
    if supported_oses.any?
      puts 'Supported:'
      supported_oses.each do |os, versions|
        puts "  #{os}: #{versions}"
      end
      puts ''
    end

    # Display EOL OSes
    return unless eol_oses.any?

    puts 'EOL:'
    eol_oses.each do |os, versions|
      puts "  #{os}: #{versions}"
    end
    puts ''
  end
end
