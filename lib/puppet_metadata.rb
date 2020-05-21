# A module that provides abstractions around Puppet's metadata format.
module PuppetMetadata
  autoload :Beaker, 'puppet_metadata/beaker'
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
end
