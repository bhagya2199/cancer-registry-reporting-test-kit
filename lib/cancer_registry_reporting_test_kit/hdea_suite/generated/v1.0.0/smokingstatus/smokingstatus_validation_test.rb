# frozen_string_literal: true

require_relative '../../../../validation_test'

module CancerRegistryReportingTestKit
  module HDEAV100
    class SmokingstatusValidationTest < Inferno::Test
      include CancerRegistryReportingTestKit::ValidationTest

      id :ccrr_v200_smokingstatus_validation_test
      title 'US Core Smoking Status Observation profile conformance'
      description %(
        This test verifies that Observation instances
        found in the Social History sections of the provided reports conform to the
        [US Core Smoking Status Observation profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-smokingstatus|5.0.1).
      )
      

      def resource_type
        'Observation'
      end

      def scratch_resources
        scratch[:smokingstatus_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/core/StructureDefinition/us-core-smokingstatus',
                                '6.1.0',
                                skip_if_empty: true)
      end
    end
  end
end
