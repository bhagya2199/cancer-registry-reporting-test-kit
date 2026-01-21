# frozen_string_literal: true

require_relative '../../../../validation_test'

module CancerRegistryReportingTestKit
  module HDEAV100
    class ProcedureValidationTest < Inferno::Test
      include CancerRegistryReportingTestKit::ValidationTest

      id :ccrr_v200_procedure_validation_test
      title 'US Core Procedure profile conformance'
      description %(
        This test verifies that Procedure instances
        found in the Procedures sections of the provided reports conform to the
        [US Core Procedure profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-procedure|5.0.1).
      )
      

      def resource_type
        'Procedure'
      end

      def scratch_resources
        scratch[:procedure_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/core/StructureDefinition/us-core-procedure',
                                '6.1.0',
                                skip_if_empty: true)
      end
    end
  end
end
