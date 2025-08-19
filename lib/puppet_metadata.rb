# frozen_string_literal: true

# A module that provides abstractions around Puppet's metadata format.
module PuppetMetadata
  autoload :AIO, 'puppet_metadata/aio'
  autoload :BaseCommand, 'puppet_metadata/base_command'
  autoload :Beaker, 'puppet_metadata/beaker'
  autoload :Command, 'puppet_metadata/command'
  autoload :GithubActions, 'puppet_metadata/github_actions'
  autoload :Metadata, 'puppet_metadata/metadata'
  autoload :OperatingSystem, 'puppet_metadata/operatingsystem'

  # Parse a JSON encoded metadata string
  # @param data A JSON encoded metadata string
  # @return [PuppetMetadata::Metadata] A Metadata object
  def self.parse(data)
    Metadata.new(JSON.parse(data))
  end

  # Read and parse a path containing metadata
  # @param path The path metadata.json
  # @return [PuppetMetadata::Metadata] A Metadata object
  def self.read(path)
    parse(File.read(path))
  end

  # Write metadata back to disk
  # @param path The path metadata.json
  # @param [PuppetMetadata::Metadata] A Metadata object
  def self.write(path, metadata)
    File.write(path, "#{JSON.pretty_generate(metadata.metadata)}\n")
  end
end
