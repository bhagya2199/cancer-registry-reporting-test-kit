# frozen_string_literal: true

require_relative '../../../validation_test'

module CancerRegistryReportingTestKit
  class SecondaryCancerConditionValidationTest < Inferno::Test
    include CancerRegistryReportingTestKit::ValidationTest

    id :ccrr_secondary_cancer_condition_validation_test
    title 'Condition resources returned during previous tests conform to the mCODE Secondary Cancer Condition Profile'
    description %(
        This test verifies resources returned from the first search conform to
        the [mCODE Secondary Cancer Condition Profile](http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-secondary-cancer-condition).
        Systems must demonstrate at least one valid example in order to pass this test.

        It verifies the presence of mandatory elements and that elements with
        required bindings contain appropriate values. CodeableConcept element
        bindings will fail if none of their codings have a code/system belonging
        to the bound ValueSet. Quantity, Coding, and code element bindings will
        fail if their code/system are not found in the valueset.

      )

    def resource_type
      'Condition'
    end

    def scratch_resources
      scratch[:secondary_condition_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [],
                              'http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-secondary-cancer-condition',
                              '4.0.0',
                              skip_if_empty: true)
    end
  end
end
