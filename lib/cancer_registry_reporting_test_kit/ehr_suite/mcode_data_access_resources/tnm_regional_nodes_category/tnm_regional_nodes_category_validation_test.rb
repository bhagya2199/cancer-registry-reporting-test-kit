# frozen_string_literal: true

require_relative '../../../validation_test'

module CancerRegistryReportingTestKit
  class TNMRegionalNodesCategoryValidationTest < Inferno::Test
    include CancerRegistryReportingTestKit::ValidationTest

    id :ccrr_tnm_regional_nodes_category_validation_test
    title 'Observation resources returned during previous tests conform to the mCODE TNM Regional Nodes Category profile'
    description %(
        This test verifies resources returned from the first search conform to
        the [mCODE TNM Regional Nodes Category Profile](https://hl7.org/fhir/us/mcode/STU3/StructureDefinition-mcode-tnm-regional-nodes-category.html).
        Systems must demonstrate at least one valid example in order to pass this test.

        It verifies the presence of mandatory elements and that elements with
        required bindings contain appropriate values. CodeableConcept element
        bindings will fail if none of their codings have a code/system belonging
        to the bound ValueSet. Quantity, Coding, and code element bindings will
        fail if their code/system are not found in the valueset.

      )

    def resource_type
      'Observation'
    end

    def scratch_resources
      scratch[:tnm_regional_nodes_category_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [],
                              'http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-tnm-regional-nodes-category',
                              '4.0.0',
                              skip_if_empty: true)
    end
  end
end
