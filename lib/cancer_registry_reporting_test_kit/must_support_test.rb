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
      base_resources = Array.wrap(scratch_resources[:all])

      if respond_to?(:scratch) && scratch.is_a?(Hash) && scratch.key?(:ccrr_content_bundle_resources)
        grouped_resources =
          scratch.values.select { |group| group.is_a?(Hash) }.map { |group| Array.wrap(group[:all]) }.flatten

        (base_resources + grouped_resources).uniq
      else
        base_resources
      end
    end

    def perform_must_support_test(resources)
      typed_resources =
        Array.wrap(resources).select do |resource|
          resource.respond_to?(:resourceType) && resource.resourceType == resource_type
        end

      skip_if typed_resources.blank?, "No #{resource_type} resources were found"

      missing_elements(typed_resources)
      missing_slices(typed_resources)
      missing_extensions(typed_resources)

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
        missing_slices.map { |slice_definition| slice_definition[:slice_id] } +
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
      Array(metadata.must_supports&.dig(:extensions))
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
      elements = Array(metadata.must_supports&.dig(:elements))

      if exclude_uscdi_only_test?
        elements.reject { |element| element[:uscdi_only] }
      else
        elements
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

    def must_support_slices
      slices = Array(metadata.must_supports&.dig(:slices))

      if exclude_uscdi_only_test?
        slices.reject { |slice| slice[:uscdi_only] }
      else
        slices
      end
    end

    def missing_slices(resources = [])
      @missing_slices ||=
        must_support_slices.select do |slice|
          resources.none? do |resource|
            path = slice[:path] # .delete_suffix('[x]')
            find_slice(resource, path, slice[:discriminator]).present?
          end
        end
    end

    def find_slice(resource, path, discriminator)
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
          values_array = Array(discriminator[:values])
          next false if values_array.blank?

          values = values_array.map { |value| value.merge(path: value[:path].split('.')) }
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
            klass = safe_const_get(FHIR, discriminator[:code])
            next false if klass.nil?

            if element.is_a?(FHIR::Bundle::Entry)
              element.resource.is_a?(klass)
            else
              element.is_a?(klass)
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
              Array(discriminator[:values]).any? { |value| value[:system] == coding.system && value[:code] == coding.code }
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
        Array(discriminator[:values]).any? { |value| coding.system.to_s.include?(value[:system].to_s) }
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

    def resolve_reference_from_scratch(reference)
      return nil if reference.blank?

      parts = reference.to_s.split('/')
      return nil if parts.length < 2

      resource_type = parts[-2]
      resource_id   = parts[-1]

      direct_match = Array.wrap(all_scratch_resources).find do |res|
        res&.resourceType.to_s == resource_type && res&.id.to_s == resource_id
      end

      return direct_match if direct_match

      Array.wrap(all_scratch_resources).each do |res|
        next unless res&.resourceType.to_s == 'Bundle'

        bundle_match = Array.wrap(res.entry).map(&:resource).find do |entry_resource|
          entry_resource&.resourceType.to_s == resource_type && entry_resource&.id.to_s == resource_id
        end

        return bundle_match if bundle_match
      end

      nil
    end
  end
end
