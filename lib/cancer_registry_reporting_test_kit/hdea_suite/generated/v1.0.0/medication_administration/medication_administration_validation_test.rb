# frozen_string_literal: true

require_relative '../../../../validation_test'

module CancerRegistryReportingTestKit
  module HDEAV100
    class MedicationAdministrationValidationTest < Inferno::Test
      include CancerRegistryReportingTestKit::ValidationTest

      id :ccrr_v200_medication_administration_validation_test
      title 'Cancer-Related Medication Administration profile conformance'
      description %(
        This test verifies that MedicationAdministration instances
        found in the Medications and Medications Administered sections of the provided reports conform to the
        [Cancer-Related Medication Administration profile](http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-cancer-related-medication-administration|3.0.0).
      )
      

      def resource_type
        'MedicationAdministration'
      end

      def scratch_resources
        scratch[:medication_administration_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-cancer-related-medication-administration',
                                '4.0.0',
                                skip_if_empty: true)
      end
    end
  end
end
