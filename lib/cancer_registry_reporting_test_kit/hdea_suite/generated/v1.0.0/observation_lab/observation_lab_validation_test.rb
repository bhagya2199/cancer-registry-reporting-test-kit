# frozen_string_literal: true

require_relative '../../../../validation_test'

module CancerRegistryReportingTestKit
  module HDEAV100
    class ObservationLabValidationTest < Inferno::Test
      include CancerRegistryReportingTestKit::ValidationTest

      id :ccrr_v200_observation_lab_validation_test
      title 'US Core Laboratory Result Observation profile conformance'
      description %(
        This test verifies that Observation instances
        found in the Results sections of the provided reports conform to the
        [US Core Laboratory Result Observation profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab|5.0.1).
      )
      

      def resource_type
        'Observation'
      end

      def scratch_resources
        scratch[:observation_lab_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab',
                                '5.0.1',
                                skip_if_empty: true)
      end
    end
  end
end
