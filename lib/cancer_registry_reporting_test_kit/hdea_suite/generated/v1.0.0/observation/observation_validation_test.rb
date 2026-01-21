# frozen_string_literal: true

require_relative '../../../../validation_test'

module CancerRegistryReportingTestKit
  module HDEAV100
    class ObservationValidationTest < Inferno::Test
      include CancerRegistryReportingTestKit::ValidationTest

      id :ccrr_v200_observation_validation_test
      title 'Base Observation profile conformance'
      description %(
        This test verifies that Observation instances
        found in the Vital Signs sections of the provided reports conform to the
        [Base Observation profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-vital-signs|6.1.0).
      )
      

      def resource_type
        'Observation'
      end

      def scratch_resources
        scratch[:observation_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/core/StructureDefinition/us-core-vital-signs',
                                '6.1.0',
                                skip_if_empty: true)
      end
    end
  end
end
