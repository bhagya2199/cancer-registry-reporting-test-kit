# frozen_string_literal: true

module CancerRegistryReportingTestKit
  module ValidationTest
    DAR_CODE_SYSTEM_URL = 'http://terminology.hl7.org/CodeSystem/data-absent-reason'
    DAR_EXTENSION_URL = 'http://hl7.org/fhir/StructureDefinition/data-absent-reason'

    def perform_validation_test(arg1, arg2, arg3, arg4 = nil, resource_type_name: nil, skip_if_empty: true)
      if arg4
        actual_resource_type = arg1
        resources = arg2
        profile_url = arg3
        profile_version = arg4
      else
        actual_resource_type = resource_type_name || resource_type
        resources = arg1
        profile_url = arg2
        profile_version = arg3
      end

      find_validation_errors(resources, profile_url, profile_version, resource_type_name: actual_resource_type, skip_if_empty: skip_if_empty)
      errors_found = messages.any? { |message| message[:type] == 'error' }

      profile_with_version = "#{profile_url}|#{profile_version}"
      assert !errors_found, "Resource does not conform to the profile #{profile_with_version}"
    end

    def find_validation_errors(arg1, arg2, arg3, arg4 = nil, resource_type_name: nil, skip_if_empty: true)
      if arg4
        actual_resource_type = arg1
        resources = arg2
        profile_url = arg3
        profile_version = arg4
      else
        actual_resource_type = resource_type_name || resource_type
        resources = arg1
        profile_url = arg2
        profile_version = arg3
      end

      skip_if skip_if_empty && resources.blank?,
              "No #{actual_resource_type} resources conforming to the #{profile_url} profile were returned"

      omit_if resources.blank?,
              "No #{actual_resource_type} resources provided so the #{profile_url} profile does not apply"

      profile_with_version = "#{profile_url}|#{profile_version}"
      resources.each do |resource|
        resource_is_valid?(resource: resource, profile_url: profile_with_version)
      end
    end


    def check_for_dar(resource)
      unless scratch[:dar_code_found]
        resource.each_element do |element, _meta, _path|
          next unless element.is_a?(FHIR::Coding)

          check_for_dar_code(element)
        end
      end

      return if scratch[:dar_extension_found]

      check_for_dar_extension(resource)
    end

    def check_for_dar_code(coding)
      return unless coding.code == 'unknown' && coding.system == DAR_CODE_SYSTEM_URL

      scratch[:dar_code_found] = true
      output dar_code_found: 'true'
    end

    def check_for_dar_extension(resource)
      return unless resource.source_contents&.include? DAR_EXTENSION_URL

      scratch[:dar_extension_found] = true
      output dar_extension_found: 'true'
    end
  end
end
