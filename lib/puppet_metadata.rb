module PuppetMetadata
  autoload :Metadata, 'puppet_metadata/metadata'
  autoload :OperatingSystem, 'puppet_metadata/operatingsystem'

  def self.parse(data)
    Metadata.new(JSON.parse(data))
  end

  def self.read(path)
    parse(File.read(path))
  end
end
