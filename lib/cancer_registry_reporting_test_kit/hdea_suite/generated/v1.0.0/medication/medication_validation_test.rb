# frozen_string_literal: true

require_relative '../../../../validation_test'

module CancerRegistryReportingTestKit
  module HDEAV100
    class MedicationValidationTest < Inferno::Test
      include CancerRegistryReportingTestKit::ValidationTest

      id :ccrr_v200_medication_validation_test
      title 'US Core Medication profile conformance'
      description %(
        This test verifies that Medication instances
        found in the Medications and Medications Administered sections of the provided reports conform to the
        [US Core Medication profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-medication|6.1.0).
      )
      

      def resource_type
        'Medication'
      end

      def scratch_resources
        scratch[:medication_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/core/StructureDefinition/us-core-medication',
                                '6.1.0',
                                skip_if_empty: false)
      end
    end
  end
end
