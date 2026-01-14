# frozen_string_literal: true

require_relative '../../../../validation_test'

module CancerRegistryReportingTestKit
  module HDEAV100
    class MedicationRequestValidationTest < Inferno::Test
      include CancerRegistryReportingTestKit::ValidationTest

      id :ccrr_v200_medication_request_validation_test
      title 'Cancer-Related Medication Request profile conformance'
      description %(
        This test verifies that MedicationRequest instances
        found in the Plan of Treatment sections of the provided reports conform to the
        [Cancer-Related Medication Request profile](http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-cancer-related-medication-request|3.0.0).
      )
      

      def resource_type
        'MedicationRequest'
      end

      def scratch_resources
        scratch[:medication_request_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-cancer-related-medication-request',
                                '4.0.0',
                                skip_if_empty: true)
      end
    end
  end
end
