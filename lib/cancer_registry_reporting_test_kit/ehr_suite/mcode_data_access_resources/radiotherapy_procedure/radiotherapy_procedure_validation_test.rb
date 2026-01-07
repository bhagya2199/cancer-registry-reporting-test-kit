require_relative '../../../validation_test'

module CancerRegistryReportingTestKit
  class RadiotherapyProcedureValidationTest < Inferno::Test
    include CancerRegistryReportingTestKit::ValidationTest

    id :ccrr_radiotherapy_procedure_validation_test
    title 'Procedure resources returned during previous tests conform to the Radiotherapy Course Summary Profile profile'
    description "
        This test verifies resources returned from the first search conform to
        the [Radiotherapy Course Summary Profile](http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-course-summary).
        Systems must demonstrate at least one valid example in order to pass this test.

        It verifies the presence of mandatory elements and that elements with
        required bindings contain appropriate values. CodeableConcept element
        bindings will fail if none of their codings have a code/system belonging
        to the bound ValueSet. Quantity, Coding, and code element bindings will
        fail if their code/system are not found in the valueset."

    verifies_requirements 'hl7.fhir.us.mcode_3.0.0@85'

    def resource_type
      'Procedure'
    end

    def scratch_resources
      scratch[:radiotherapy_procedure_resources] ||= {}
    end

    run do
      perform_validation_test(scratch_resources[:all] || [],
                              'http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-course-summary',
                              '4.0.0',
                              skip_if_empty: true)
    end
  end
end
