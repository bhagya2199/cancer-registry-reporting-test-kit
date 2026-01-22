# frozen_string_literal: true

require_relative '../../../../validation_test'

module CancerRegistryReportingTestKit
  module HDEAV100
    class DocumentReferenceValidationTest < Inferno::Test
      include CancerRegistryReportingTestKit::ValidationTest

      id :ccrr_v100_document_reference_validation_test
      title 'US Core DocumentReference profile conformance'
      description %(
        This test verifies that DocumentReference instances
        found in the Notes sections of the provided reports conform to the
        [US Core DocumentReference profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-documentreference|6.1.0).
      )
      

      def resource_type
        'DocumentReference'
      end

      def scratch_resources
        scratch[:document_reference_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/core/StructureDefinition/us-core-documentreference',
                                '6.1.0',
                                skip_if_empty: true)
      end
    end
  end
end
