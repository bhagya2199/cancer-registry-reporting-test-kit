# frozen_string_literal: true

require_relative '../../../../validation_test'

module CancerRegistryReportingTestKit
  module HDEAV100
    class PatientValidationTest < Inferno::Test
      include CancerRegistryReportingTestKit::ValidationTest

      id :ccrr_v200_patient_validation_test
      title 'CCRR Patient Profile conformance'
      description %(
        This test verifies that Patient instances
        referenced in the `patient` elements of the provided reports conform to the
        [CCRR Patient Profile v2.0.0](http://build.fhir.org/ig/HL7/fhir-central-cancer-registry-reporting-ig/StructureDefinition-central-cancer-registry-reporting-patient.html).
      )
      
      def resource_type
        'Patient'
      end

      def scratch_resources
        scratch[:patient_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient',
                                '5.0.1',
                                skip_if_empty: true)
      end
    end
  end
end
