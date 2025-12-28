# frozen_string_literal: true

module PuppetMetadata
  # The base command. All actual commands should inherit from this.
  class BaseCommand
    def initialize(arguments, options)
      @arguments = arguments
      @options = options
    end

    def filename
      @filename ||= @options.fetch(:filename, 'metadata.json')
    end

    def metadata
      @metadata ||= PuppetMetadata.read(filename)
    rescue StandardError => e
      warn "Failed to read #{filename}: #{e}"
      exit 2
    end

    def self.commands
      PuppetMetadata::Command.load_commands

      subclasses.to_h { |subclass| [subclass.command, subclass] }
    end

    def self.command
      name.gsub(/Command$/, '')
          .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
          .gsub(/([a-z\d])([A-Z])/, '\1_\2')
          .tr('_', '-')
          .downcase
    end

    # Return a parser. The program name should be overridden with a description
    # @param [Hash] _options
    #   The data to store the options into
    # @return [OptionParser]
    #   The parser for the command
    def self.parser(_options)
      raise NotImplementedError
    end

    # Actual implementation of the command
    def run
      raise NotImplementedError
    end
  end
end
