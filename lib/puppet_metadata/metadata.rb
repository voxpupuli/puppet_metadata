require 'json'

module PuppetMetadata
  # An exception indicating the metadata is invalid
  #
  # @attr_reader [Array[Hash[Symbol, String]]] errors
  #   The errors in the metadata
  class InvalidMetadataException < Exception
    attr_reader :errors

    # Returns a new instance of InvalidMetadataException
    # @param [Array[Hash[Symbol, String]]] errors
    #   The errors in the metadata
    def initialize(errors)
      messages = errors.map { |error| error[:message] }
      super("Invalid metadata: #{messages.join(', ')}")
      @errors = errors
    end
  end

  # An abstraction over Puppet metadata
  class Metadata
    attr_reader :metadata

    # @param [Hash[String, Any]] metadata
    #   The metadata as a data structure
    # @param [Boolean] validate
    #   Whether to validate the metadata using metadata-json-lint
    # @raise [PuppetMetadata::InvalidMetadataException]
    #   When the provided metadata is invalid according to metadata.json-lint
    # @see PuppetMetadata.parse
    # @see PuppetMetadata.read
    # @see https://rubygems.org/gems/metadata-json-lint
    def initialize(metadata, validate = true)
      if validate
        require 'metadata_json_lint'
        schema_errors = MetadataJsonLint::Schema.new.validate(metadata)
        raise InvalidMetadataException.new(schema_errors) if schema_errors.any?
      end

      @metadata = metadata
    end

    # The name
    # @return [String] The name
    def name
      metadata['name']
    end

    # The version
    # @return [String]
    def version
      metadata['version']
    end

    # The license
    # @return [String] The license
    def license
      metadata['license']
    end

    # @return [Hash[String, Array[String]]]
    #   The supported operating system and its major releases
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

    # Returns whether an operating system's release is supported
    #
    # @param [String] operatingsystem The operating system
    # @param [String] release The major release of the OS
    # @return [Boolean] Whether an operating system's release is supported
    def os_release_supported?(operatingsystem, release)
      # If no OS is present, everything is supported. An example of this is
      # modules with only functions.
      return true if operatingsystems.empty?

      # if the key present, nil indicates all releases are supported
      return false unless operatingsystems.key?(operatingsystem)

      releases = operatingsystems[operatingsystem]
      releases.nil? || releases.include?(release)
    end

    # @param [Date] at The date to check the EOL time. Today is used when nil.
    # @return [Hash[String, Array[String]]]
    def eol_operatingsystems(at = nil)
      at ||= Date.today

      unsupported = operatingsystems.map do |os, rels|
        next unless rels
        eol = rels.select { |rel| OperatingSystem.eol?(os, rel, at) }
        [os, eol] if eol.any?
      end

      Hash[unsupported.compact]
    end

    # A hash representation of the requirements
    #
    # Every element in the original array is converted. The name is used as a
    # key while version_requirement is used as a value. No value indicates any
    # version is accepted.
    #
    # @see #satisfies_requirement?
    # @return [Hash[String, SemanticPuppet::VersionRange]]
    #   The requirements of the module
    #
    # @example
    #   metadata = Metadata.new(data)
    #   metadata.requirements.each do |requirement, version_requirement|
    #     if version_requirement
    #       puts "#{metadata.name} requires #{requirement} #{version_requirement}"
    #     else
    #       puts "#{metadata.name} requires any #{requirement}"
    #     end
    #   end
    def requirements
      @requirements ||= build_version_requirement_hash(metadata['requirements'])
    end

    # @param [String] name The name of the requirement
    # @param [String] version The version of the requirement
    # @see #requirements
    def satisfies_requirement?(name, version)
      matches?(requirements[name], version)
    end

    # @return [Array[Integer]] Supported major Puppet versions
    # @see #requirements
    def puppet_major_versions
      requirement = requirements['puppet']
      raise Exception, 'No Puppet requirement found' unless requirement

      # Current latest major is 7. It is highly recommended that modules
      # actually specify exact bounds, but this prevents an infinite loop.
      end_major = requirement.end == SemanticPuppet::Version::MAX ? 7 : requirement.end.major

      (requirement.begin.major..end_major).select do |major|
        requirement.include?(SemanticPuppet::Version.new(major, 0, 0)) || requirement.include?(SemanticPuppet::Version.new(major, 99, 99))
      end
    end

    # A hash representation of the dependencies
    #
    # Every element in the original array is converted. The name is used as a
    # key while version_requirement is used as a value. No value indicates any
    # version is accepted.
    #
    # @see #satisfies_dependency?
    # @return [Hash[String, SemanticPuppet::VersionRange]]
    #   The dependencies of the module
    #
    # @example
    #   metadata = Metadata.new(data)
    #   metadata.dependencies.each do |os, releases|
    #     if releases
    #       releases.each do |release|
    #         puts "#{metadata.name} supports #{os} #{release}"
    #       end
    #     else
    #       puts "#{metadata.name} supports all #{os} releases"
    #     end
    #   end
    def dependencies
      @dependencies ||= build_version_requirement_hash(metadata['dependencies'])
    end

    # @param [String] name The name of the dependency
    # @param [String] version The version of the dependency
    # @see #dependencies
    def satisfies_dependency?(name, version)
      matches?(dependencies[name], version)
    end

    # @return [PuppetMetadata::GithubActions] A GithubActions instance
    def github_actions
      PuppetMetadata::GithubActions.new(self)
    end

    # @param [Boolean] use_fqdn
    #   Whether to set the hostname to a fully qualified domain name (deprecated, use domain)
    # @param [Boolean] pidfile_workaround
    #   Whether to apply the Docker pidfile workaround
    # @param [String] domain
    #   Enforce a domain to be appended to the hostname, making it an FQDN
    # @yieldparam [String] setfile
    #   The supported setfile configurations
    # @see PuppetMetadata::Beaker#os_release_to_setfile
    def beaker_setfiles(use_fqdn: false, pidfile_workaround: false, domain: nil)
      operatingsystems.each do |os, releases|
        next unless PuppetMetadata::Beaker.os_supported?(os)
        releases&.each do |release|
          setfile = PuppetMetadata::Beaker.os_release_to_setfile(os, release, use_fqdn: use_fqdn, pidfile_workaround: pidfile_workaround, domain: domain)
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
