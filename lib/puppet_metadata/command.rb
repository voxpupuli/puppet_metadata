# frozen_string_literal: true

module PuppetMetadata
  # A collection of commands implemented in the CLI.
  #
  # @see PuppetMetadata::BaseCommand
  module Command
    def self.load_commands
      return if @loaded

      Dir.glob(File.join(__dir__, 'command', '*.rb')) do |path|
        require_relative File.join('command', File.basename(path, '.rb'))
      end

      @loaded = true
    end
  end
end
