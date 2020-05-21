require 'json'

module PuppetMetadata
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

    def requirements
      @requirements ||= build_version_requirement_hash(metadata['requirements'])
    end

    def satisfies_requirement?(name, version)
      matches?(requirements[name], version)
    end

    def dependencies
      @dependencies ||= build_version_requirement_hash(metadata['dependencies'])
    end

    def satisfies_dependency?(name, version)
      matches?(dependencies[name], version)
    end

    def beaker_setfiles(use_fqdn: false, pidfile_workaround: false)
      operatingsystems.each do |os, releases|
        next unless PuppetMetadata::Beaker.os_supported?(os)
        releases&.each do |release|
          setfile = PuppetMetadata::Beaker.os_release_to_setfile(os, release, use_fqdn: use_fqdn, pidfile_workaround: pidfile_workaround)
          yield setfile if setfile
        end
      end
    end

    private

    def build_version_requirement_hash(array)
      return {} if array.nil?

      require 'semantic_puppet'

      reqs = array.map do |requirement|
        next unless requirement['name']
        version_requirement = requirement['version_requirement'] || '>= 0'
        [requirement['name'], SemanticPuppet::VersionRange.parse(version_requirement)]
      end

      Hash[reqs.compact]
    end

    def matches?(required_version, provided_version)
      return false unless required_version

      provided_version = SemanticPuppet::Version.parse(provided_version) if provided_version.is_a?(String)
      required_version.include?(provided_version)
    end
  end
end
