require_relative 'radiotherapy_procedure/radiotherapy_procedure_must_support_test'
require_relative 'radiotherapy_procedure/radiotherapy_procedure_search_test'
require_relative 'radiotherapy_procedure/radiotherapy_procedure_validation_test'

module CancerRegistryReportingTestKit
  class RadiotherapyProcedureGroup < Inferno::TestGroup
    title 'mCODE Radiotherapy Course Summary'
    description %(
      # Background
      The mCODE Radiotherapy Course Summary group verifies that the system under test is
      able to provide correct responses for Radiotherapy Procedure queries. These queries
      must return resources conforming to the [mCODE Radiotherapy Course Summary Profile](https://hl7.org/fhir/us/mcode/STU3/StructureDefinition-mcode-radiotherapy-course-summary.html)
      as specified in the mCODE v3.0.0 Implementation Guide.

      # Testing Methodology
      ## Searching
      This test sequence will first perform each required search associated
      with this resource. This sequence will perform searches with the
      following parameters:

      * patient + code

      Note that US Core requires support for the patient search parameter
      for the [Procedure resource](https://hl7.org/fhir/us/core/STU6.1/StructureDefinition-us-core-procedure.html#quick-start).
      Since mCODE requires support for the code parameter for [Radiotherapy treatment searches](https://hl7.org/fhir/us/mcode/STU3/conformance-general.html#support-querying-mcode-conforming-resources),
      the patient + code combination is required by these tests.

      ### Search Parameters
      The first search uses values from the **Patient IDs** input plus
      a fixed value of `http://snomed.info/sct|1217123003` for the code
      as specified in the [mCODE Radiotherapy Course Summary Profile](https://hl7.org/fhir/us/mcode/STU3/StructureDefinition-mcode-radiotherapy-course-summary.html).
      Any subsequent searches will look for its parameter values
      from the results of the first search. For example, the `identifier`
      search in the patient sequence is performed by looking for an existing
      `Patient.identifier` from any of the resources returned in the first
      search. If a value cannot be found this way, the search is skipped.
      This search test also searches by date.  When a single date is inputted,
      the test will return any results that occurred on that date or contain
      that date within the resource's date period.

      ### Search Validation
      Inferno will retrieve up to the first 20 bundle pages of the reply for
      Procedure resources and save them for subsequent tests. Each of
      these resources is then checked to see if it matches the searched
      parameters in accordance with [FHIR search
      guidelines](https://www.hl7.org/fhir/search.html). The test will fail,
      for example, if a Patient search for `gender=male` returns a `female`
      patient.


      ## Must Support
      Each profile contains elements marked as 'must support'. This test
      sequence expects to see each of these elements at least once. If at
      least one cannot be found, the test will fail. The test will look
      through the Procedure resources found in the first test for these
      elements.

      ## Profile Validation
      Each resource returned from the first search is expected to conform to
      the [mCODE Radiotherapy Course Summary Profile](http://hl7.org/fhir/us/mcode/STU3/StructureDefinition/mcode-radiotherapy-course-summary).
      Each element is checked against
      teminology binding and cardinality requirements.

      Elements with a required binding are validated against their bound
      ValueSet. If the code/system in the element is not part of the ValueSet,
      then the test will fail.

    )

    id :ccrr_ehr_radiotherapy_procedure
    run_as_group

    def self.metadata
      @metadata ||= HdeaGenerator::GroupMetadata.new(
        YAML.load_file(File.join(__dir__, 'radiotherapy_procedure', 'metadata.yml'), aliases: true)
      )
    end

    test from: :ccrr_radiotherapy_procedure_search_test
    test from: :ccrr_radiotherapy_procedure_validation_test
    test from: :ccrr_radiotherapy_procedure_must_support_test
  end
end
