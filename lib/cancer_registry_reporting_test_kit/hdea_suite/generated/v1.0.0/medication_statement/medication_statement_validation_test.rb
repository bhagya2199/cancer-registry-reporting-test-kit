# frozen_string_literal: true

require_relative '../../../../validation_test'

module CancerRegistryReportingTestKit
  module HDEAV100
    class MedicationStatementValidationTest < Inferno::Test
      include CancerRegistryReportingTestKit::ValidationTest

      id :ccrr_v200_medication_statement_validation_test
      title 'Base MedicationStatement profile conformance'
      description %(
        This test verifies that MedicationStatement instances
        found in the Medications and Medications Administered sections of the provided reports conform to the
        [Base MedicationStatement profile](http://hl7.org/fhir/StructureDefinition/MedicationStatement|4.0.1).
      )
      

      def resource_type
        'MedicationStatement'
      end

      def scratch_resources
        scratch[:medication_statement_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/StructureDefinition/MedicationStatement',
                                '4.0.1',
                                skip_if_empty: true)
      end
    end
  end
end
