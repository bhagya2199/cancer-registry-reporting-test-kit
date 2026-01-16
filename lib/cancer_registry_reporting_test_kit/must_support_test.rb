# frozen_string_literal: true

require_relative 'fhir_resource_navigation'
require_relative 'bundle_parse'

module CancerRegistryReportingTestKit
  module MustSupportTest
    extend Forwardable
    include FHIRResourceNavigation
    include HDEABundleParse

    def_delegators 'self.class', :metadata

    def all_scratch_resources
      scratch_resources[:all]
    end

    def perform_must_support_test(resources)
      skip_if resources.blank?, "No #{resource_type} resources were found"

      missing_elements(resources)
      missing_slices(resources)
      missing_extensions(resources)

      handle_must_support_choices if metadata.must_supports[:choices].present?

      skip_if (missing_elements + missing_slices + missing_extensions).present?, 
        "Could not find #{missing_must_support_strings.join(', ')} in the #{resources.length} " \
        "provided #{resource_type} resource(s)"
    end

    def handle_must_support_choices
      missing_elements.delete_if do |element|
        choices = metadata.must_supports[:choices].find { |choice| choice[:paths]&.include?(element[:path]) }
        is_any_choice_supported?(choices)
      end

      missing_extensions.delete_if do |extension|
        choices = metadata.must_supports[:choices].find { |choice| choice[:extension_ids]&.include?(extension[:id]) }
        is_any_choice_supported?(choices)
      end

      missing_slices.delete_if do |slice|
        choices = metadata.must_supports[:choices].find { |choice| choice[:slice_names]&.include?(slice[:name]) }
        is_any_choice_supported?(choices)
      end
    end

    def is_any_choice_supported?(choices)
      choices.present? &&
        (
          choices[:paths]&.any? { |path| missing_elements.none? { |element| element[:path] == path } } ||
          choices[:extension_ids]&.any? do |extension_id|
            missing_extensions.none? do |extension|
              extension[:id] == extension_id
            end
          end ||
          choices[:slice_names]&.any? { |slice_name| missing_slices.none? { |slice| slice[:name] == slice_name } }
        )
    end

    def missing_must_support_strings
      missing_elements.map { |element_definition| missing_element_string(element_definition) } +
        missing_slices.map { |slice_definition| sym_key(slice_definition, :slice_id) } +
        missing_extensions.map { |extension_definition| extension_definition[:id] }
    end

    def missing_element_string(element_definition)
      if element_definition[:fixed_value].present?
        "#{element_definition[:path]}:#{element_definition[:fixed_value]}"
      else
        element_definition[:path]
      end
    end

    def exclude_uscdi_only_test?
      config.options[:exclude_uscdi_only_test] == true
    end

    def must_support_extensions
      if exclude_uscdi_only_test?
        metadata.must_supports[:extensions].reject { |extension| extension[:uscdi_only] }
      else
        metadata.must_supports[:extensions]
      end
    end

    def missing_extensions(resources = [])
      @missing_extensions ||=
        must_support_extensions.select do |extension_definition|
          resources.none? do |resource|
            path = extension_definition[:path]

            if path == 'extension'
              resource.extension.any? { |extension| extension.url == extension_definition[:url] }
            else
              extension = find_a_value_at(resource, path) do |el|
                el.url == extension_definition[:url]
              end

              extension.present?
            end
          end
        end
    end

    def must_support_elements
      if exclude_uscdi_only_test?
        metadata.must_supports[:elements].reject { |element| element[:uscdi_only] }
      else
        metadata.must_supports[:elements]
      end
    end

    def missing_elements(resources = [])
      @missing_elements ||= find_missing_elements(resources, must_support_elements)
      @missing_elements
    end

    def find_missing_elements(resources, must_support_elements)
      must_support_elements.select do |element_definition|
        resources.none? do |resource|
          path = element_definition[:path]
          ms_extension_urls = must_support_extensions.select { |ex| ex[:path] == "#{path}.extension" }
            .map { |ex| ex[:url] }

          value_found = find_a_value_at(resource, path) do |value|
            if value.instance_of?(CancerRegistryReportingTestKit::PrimitiveType) && ms_extension_urls.present?
              urls = value.extension&.map(&:url)
              has_ms_extension = (urls & ms_extension_urls).present?
            end

            unless has_ms_extension
              value = value.value if value.instance_of?(CancerRegistryReportingTestKit::PrimitiveType)
              value_without_extensions =
                value.respond_to?(:to_hash) ? value.to_hash.except('extension') : value
            end

            (has_ms_extension || value_without_extensions.present? || value_without_extensions == false) &&
              (element_definition[:fixed_value].blank? || value == element_definition[:fixed_value])
          end
          # Note that false.present? => false, which is why we need to add this extra check
          value_found.present? || value_found == false
        end
      end
    end

    def normalize_hashish(obj)
      return obj if obj.is_a?(Hash)
      return obj unless obj.is_a?(Array)

      # array-of-pairs: [[:a,1], [:b,2]]
      if obj.all? { |e| e.is_a?(Array) && e.length == 2 }
        return obj.to_h
      end

      # flat: [:a,1,:b,2]
      if obj.length.even?
        pairs = obj.each_slice(2).to_a
        return pairs.to_h
      end

      obj
    end

    def sym_key(hash, key)
      return nil unless hash.is_a?(Hash)
      hash[key] || hash[key.to_s]
    end

    def symbolize_keys(hash)
      return hash unless hash.is_a?(Hash)
      hash.transform_keys { |k| k.is_a?(String) ? k.to_sym : k }
    end

    def must_support_slices
      slices = metadata.must_supports[:slices] || []

      slices = slices.map do |s|
        s = normalize_hashish(s)
        symbolize_keys(s)
      end

      if exclude_uscdi_only_test?
        slices.reject { |slice| sym_key(slice, :uscdi_only) }
      else
        slices
      end
    end

    def missing_slices(resources = [])
      @missing_slices ||=
        must_support_slices.select do |slice|
          slice = normalize_hashish(slice)
          slice = symbolize_keys(slice)

          resources.none? do |resource|
            path = sym_key(slice, :path)
            discriminator = sym_key(slice, :discriminator)
            discriminator = symbolize_keys(normalize_hashish(discriminator))

            find_slice(resource, path, discriminator).present?
          end
        end
    end

    def find_slice(resource, path, discriminator)
      discriminator = normalize_hashish(discriminator)
      find_a_value_at(resource, path) do |element|
        case discriminator[:type]
        when 'patternCodeableConcept'
          coding_path = discriminator[:path].present? ? "#{discriminator[:path]}.coding" : 'coding'
          find_a_value_at(element, coding_path) do |coding|
            coding.code == discriminator[:code] && coding.system == discriminator[:system]
          end
        when 'patternCoding'
          coding_path = discriminator[:path].present? ? discriminator[:path] : ''
          find_a_value_at(element, coding_path) do |coding|
            coding.code == discriminator[:code] && coding.system == discriminator[:system]
          end
        when 'patternIdentifier'
          find_a_value_at(element, discriminator[:path]) { |identifier| identifier.system == discriminator[:system] }
        when 'value'
          values = discriminator[:values].map { |value| value.merge(path: value[:path].split('.')) }
          find_slice_by_values(element, values)
        when 'type'
          case discriminator[:code]
          when 'Date'
            begin
              Date.parse(element)
            rescue ArgumentError
              false
            end
          when 'DateTime'
            begin
              DateTime.parse(element)
            rescue ArgumentError
              false
            end
          when 'String'
            element.is_a? String
          else
            if element.is_a? FHIR::Bundle::Entry
              element.resource.is_a? FHIR.const_get(discriminator[:code])
            else
              element.is_a? FHIR.const_get(discriminator[:code])
            end
          end
        when 'requiredBinding'
          coding_path = discriminator[:path].present? ? "#{discriminator[:path]}.coding" : 'coding'

          ## SPECIAL CASE ##
          # only checking ODH MS slices for codesystem, not codes, given large number of codes
          if metadata.profile_url == 'http://hl7.org/fhir/us/odh/StructureDefinition/odh-UsualWork'
            get_slice_by_codesystem(element, discriminator)
          else
            find_a_value_at(element, coding_path) do |coding|
              discriminator[:values].any? { |value| value[:system] == coding.system && value[:code] == coding.code }
            end
          end
        when 'profile'
          ref = element.respond_to?(:reference) ? element.reference.to_s : nil
          next false if ref.blank?

          resolved = resolve_reference_from_scratch(ref)
          next false if resolved.nil?

          profiles = Array(resolved.meta&.profile).map(&:to_s)
          allowed  = Array(discriminator[:values]).map(&:to_s)

          allowed.any? { |p| profiles.any? { |rp| rp.start_with?(p) } }
        end
      end
    end

    ## special case ##

    def get_slice_by_codesystem(element, discriminator)
      find_a_value_at(element, '') do |coding|
        discriminator[:values].any? { |value| coding.system.include? value[:system] }
      end
    end

    ## end special case ##

    def find_slice_by_values(element, value_definitions)
      path_prefixes = value_definitions.map { |value_definition| value_definition[:path].first }.uniq
      Array.wrap(element).find do |el|
        path_prefixes.all? do |path_prefix|
          value_definitions_for_path =
            value_definitions
              .select { |value_definition| value_definition[:path].first == path_prefix }
              .each { |value_definition| value_definition[:path].shift }

          find_a_value_at(el, path_prefix) do |el_found|
            child_element_value_definitions, current_element_value_definitions =
              value_definitions_for_path.partition { |value_definition| value_definition[:path].present? }

            current_element_values_match =
              current_element_value_definitions
                .all? { |value_definition| value_definition[:value].to_s == el_found.to_s }

            child_element_values_match =
              if child_element_value_definitions.present?
                find_slice_by_values(el_found, child_element_value_definitions)
              else
                true
              end

            current_element_values_match && child_element_values_match
          end
        end
      end
    end

    def collect_fhir_models(obj, acc = [])
      case obj
      when FHIR::Model
        acc << obj
      when FHIR::Bundle::Entry
        acc << obj.resource
      when Array
        obj.each { |v| collect_fhir_models(v, acc) }
      when Hash
        obj.each_value { |v| collect_fhir_models(v, acc) }
      end
      acc
    end

    def resolve_reference_from_scratch(reference)
      return nil if reference.blank?

      ref_type, ref_id =
        if reference.include?('://')
          parts = reference.split('/')
          [parts[-2], parts[-1]]
        else
          reference.split('/', 2)
        end

      pool = []
      pool.concat(all_scratch_resources) if respond_to?(:all_scratch_resources)
      pool.concat(collect_fhir_models(scratch))

      pool.map { |r| r.is_a?(FHIR::Bundle::Entry) ? r.resource : r }
          .find { |r| r.respond_to?(:resourceType) && r.respond_to?(:id) && r.resourceType.to_s == ref_type.to_s && r.id.to_s == ref_id.to_s }
    end
  end
end
