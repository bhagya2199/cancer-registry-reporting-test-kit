# frozen_string_literal: true

require_relative '../../../../validation_test'

module CancerRegistryReportingTestKit
  module HDEAV100
    class PatientValidationTest < Inferno::Test
      include CancerRegistryReportingTestKit::ValidationTest

      id :ccrr_v200_patient_validation_test
      title 'US Core Patient Profile conformance'
      description %(
        This test verifies that Patient instances
        referenced in the `patient` elements of the provided reports conform to the
        [US Core Patient Profile v6.1.0](http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient).
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
                                '6.1.0',
                                skip_if_empty: true)
      end
    end
  end
end
