# frozen_string_literal: true

require_relative '../../../../validation_test'

module CancerRegistryReportingTestKit
  module HDEAV100
    class CentralCancerRegistryPrimaryCancerConditionValidationTest < Inferno::Test
      include CancerRegistryReportingTestKit::ValidationTest

      id :ccrr_v200_central_cancer_registry_primary_cancer_condition_validation_test
      title 'Central Cancer Registry Reporting Primary Cancer Condition profile conformance'
      description %(
        This test verifies that Condition instances
        found in the Primary Cancer Condition sections of the provided reports conform to the
        [Central Cancer Registry Reporting Primary Cancer Condition profile](http://hl7.org/fhir/us/central-cancer-registry-reporting/StructureDefinition/central-cancer-registry-primary-cancer-condition|2.0.0-ballot).
      )
      

      def resource_type
        'Condition'
      end

      def scratch_resources
        scratch[:central_cancer_registry_primary_cancer_condition_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/central-cancer-registry-reporting/StructureDefinition/central-cancer-registry-primary-cancer-condition',
                                '2.0.0-ballot',
                                skip_if_empty: true)
      end
    end
  end
end
