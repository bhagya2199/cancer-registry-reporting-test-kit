# frozen_string_literal: true

require_relative '../validation_test'
require_relative '../hdea_generator/naming'
require_relative '../bundle_parse'

module CancerRegistryReportingTestKit
  module HDEAV200
    class CcrrContentBundleParseAndValidationTest < Inferno::Test
      include CancerRegistryReportingTestKit::ValidationTest
      include CancerRegistryReportingTestKit::HDEABundleParse

      id :ccrr_v200_ccrr_content_bundle_parse_and_validation_test
      title 'Central Cancer Registry Content Bundle profile conformance'
      description %(
        This test confirms that the tester provided one or more Bundles in the **Cancer Reports** input.
        It also validates that the Bundle(s) conform to the CCRR Content Bundle profile.
        Entry resources are validated by subsequent resource-specific tests.
      )

      def add_ms_resources_to_scratch(reports_list)
        reports_list.each_with_index do |bundle, index|
          parsed_bundle = parse_bundle(FHIR.from_contents(bundle.to_json), index).first
          next unless parsed_bundle.present?

          report_hash = url_keys_to_group_keys(parsed_bundle)
          report_hash.each do |group, resources|
            next unless resources.present?

            scratch[group] ||= {}
            scratch[group][:all] ||= []
            scratch[group][:all].concat(resources)
          end
        end
      end

      def url_keys_to_group_keys(report_hash)
        report_hash.transform_keys { |key| :"#{HdeaGenerator::Naming.snake_case_for_url(key)}" }
      end

      def resource_type
        'Bundle'
      end

      def scratch_resources
        scratch[:ccrr_content_bundle_resources] ||= {}
      end

      run do
        # "reports" is the Inferno input that contains one or more Bundles (JSON strings)
        add_ms_resources_to_scratch(JSON.parse("[#{reports}]").flatten.compact)

        messages = find_validation_errors(scratch_resources[:all] || [],
                                          'http://hl7.org/fhir/us/central-cancer-registry-reporting/StructureDefinition/ccrr-content-bundle',
                                          '2.0.0-ballot',
                                          skip_if_empty: true) || []

        # filter errors related to entry resources - these are handled elsewhere
        messages.reject! { |message| /Bundle\.entry\[\d+\]\.resource/.match(message[:message]) }

        errors_found = messages.any? { |message| message[:type] == 'error' }

        assert !errors_found, 'Resource(s) do not conform to the profile http://hl7.org/fhir/us/central-cancer-registry-reporting/StructureDefinition/ccrr-content-bundle|2.0.0-ballot'
      end
    end
  end
end
