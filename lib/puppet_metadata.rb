require 'json'
require_relative 'puppet_metadata/operatingsystem'

module PuppetMetadata
  def self.parse(data)
    Metadata.new(JSON.parse(data))
  end

  def self.read(path)
    parse(File.read(path))
  end

  class InvalidMetadataException < Exception
    attr_reader :errors

    def initialize(errors)
      messages = errors.map { |error| error[:message] }
      super("Invalid metadata: #{messages.join(', ')}")
      @errors = errors
    end
  end

  class Metadata
    attr_reader :metadata

    def initialize(metadata, validate = true)
      if validate
        require 'metadata_json_lint'
        schema_errors = MetadataJsonLint::Schema.new.validate(metadata)
        raise InvalidMetadataException.new(schema_errors) if schema_errors.any?
      end

      @metadata = metadata
    end

    def name
      metadata['name']
    end

    def version
      metadata['version']
    end

    def license
      metadata['license']
    end

    def operatingsystems
      @operatingsystems ||= begin
        return {} if metadata['operatingsystem_support'].nil?

        supported = metadata['operatingsystem_support'].map do |os|
          next unless os['operatingsystem']
          [os['operatingsystem'], os['operatingsystemrelease']]
        end

        Hash[supported.compact]
      end
    end

    def os_release_supported?(operatingsystem, release)
      # If no OS is present, everything is supported. An example of this is
      # modules with only functions.
      return true if operatingsystems.empty?

      # if the key present, nil indicates all releases are supported
      return false unless operatingsystems.key?(operatingsystem)

      releases = operatingsystems[operatingsystem]
      releases.nil? || releases.include?(release)
    end

    def eol_operatingsystems(at = nil)
      at ||= Date.today

      unsupported = operatingsystems.map do |os, rels|
        next unless rels
        eol = rels.select { |rel| OperatingSystem.eol?(os, rel, at) }
        [os, eol] if eol.any?
      end

      Hash[unsupported.compact]
    end
  end
end
