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
      opts.on('--noop', 'Show what would be changed without modifying metadata.json') do
        options[:noop] = true
      end
    end
  end

  def run
    changes_made = false

    if @options[:add_missing] && @options[:remove_eol]
      # Run both operations in sequence
      changes_made |= add_missing
      changes_made |= remove_eol
    elsif @options[:add_missing]
      changes_made = add_missing
    elsif @options[:remove_eol]
      changes_made = remove_eol
    else
      list_versions
      return
    end

    PuppetMetadata.write(filename, metadata) if changes_made && !@options[:noop]
  end

  private

  # rubocop:disable Naming/PredicateMethod
  def add_missing
    added = metadata.add_supported_operatingsystems(@options[:at], @options[:os])

    return false unless added.any?

    prefix = @options[:noop] ? '[NOOP] Would add support:' : 'Added support:'
    puts prefix
    added.each do |os, releases|
      puts "#{os} => #{releases.join(', ')}"
    end

    true
  end

  def remove_eol
    removed = metadata.remove_eol_operatingsystems(@options[:at], @options[:os])

    return false unless removed.any?

    prefix = @options[:noop] ? '[NOOP] Would remove EOL operating systems:' : 'Removed EOL operating systems:'
    puts prefix
    removed.each do |os, releases|
      puts "#{os} => #{releases.join(', ')}"
    end

    # Check for OSes that now have empty version lists
    metadata.operatingsystems.each do |os, versions|
      warn "Warning: #{os} has no supported versions after removing EOL releases. Consider removing it from metadata.json or adding newer versions." if versions.is_a?(Array) && versions.empty?
    end

    true
  end
  # rubocop:enable Naming/PredicateMethod

  def list_versions
    # Collect all OS data
    supported_oses = {}
    eol_oses = {}

    oses = @options[:os] ? [@options[:os]] : metadata.operatingsystems.keys.sort

    oses.each do |os|
      current = metadata.operatingsystems[os]

      if current.nil? || current.empty?
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
      puts "#{metadata.name} supports these non-EOL operating system versions:"
      supported_oses.each do |os, versions|
        puts "  #{os}: #{versions}"
      end
      puts ''
    end

    # Display EOL OSes
    return unless eol_oses.any?

    puts "#{metadata.name} supports these EOL operating system versions:"
    eol_oses.each do |os, versions|
      puts "  #{os}: #{versions}"
    end
    puts ''
  end
end
