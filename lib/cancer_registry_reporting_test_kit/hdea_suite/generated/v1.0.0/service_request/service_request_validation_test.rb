# frozen_string_literal: true

require_relative '../../../../validation_test'

module CancerRegistryReportingTestKit
  module HDEAV100
    class ServiceRequestValidationTest < Inferno::Test
      include CancerRegistryReportingTestKit::ValidationTest

      id :ccrr_v200_service_request_validation_test
      title 'Base ServiceRequest profile conformance'
      description %(
        This test verifies that ServiceRequest instances
        found in the Plan of Treatment sections of the provided reports conform to the
        [Base ServiceRequest profile](http://hl7.org/fhir/StructureDefinition/ServiceRequest|4.0.1).
      )
      

      def resource_type
        'ServiceRequest'
      end

      def scratch_resources
        scratch[:service_request_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/core/StructureDefinition/us-core-servicerequest',
                                '6.1.0',
                                skip_if_empty: true)
      end
    end
  end
end
