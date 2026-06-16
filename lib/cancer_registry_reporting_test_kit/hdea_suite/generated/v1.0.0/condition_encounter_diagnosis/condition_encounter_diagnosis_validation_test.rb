require_relative '../../../../validation_test'

module CancerRegistryReportingTestKit
  module HDEAV100
    class ConditionEncounterDiagnosisValidationTest < Inferno::Test
      include CancerRegistryReportingTestKit::ValidationTest

      id :ccrr_v200_condition_encounter_diagnosis_validation_test
      title 'US Core Condition Encounter Diagnosis profile conformance'
      description %(
        This test verifies that Condition instances
        found in the provided report Bundles conform to the
        [US Core Condition Encounter Diagnosis profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition-encounter-diagnosis|6.1.0).
      )

      def resource_type
        'Condition'
      end

      def scratch_resources
        scratch[:condition_encounter_diagnosis_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition-encounter-diagnosis',
                                '6.1.0',
                                skip_if_empty: true)
      end
    end
  end
end
