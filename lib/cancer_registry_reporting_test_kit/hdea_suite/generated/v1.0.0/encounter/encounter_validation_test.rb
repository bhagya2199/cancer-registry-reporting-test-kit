# frozen_string_literal: true

require_relative '../../../../validation_test'

module CancerRegistryReportingTestKit
  module HDEAV100
    class EncounterValidationTest < Inferno::Test
      include CancerRegistryReportingTestKit::ValidationTest

      id :ccrr_v200_encounter_validation_test
      title 'US Core Encounter profile conformance'
      description %(
        This test verifies that Encounter instances
        referenced in the `encounter` elements of the provided reports conform to the
        [US Core Encounter Profile v6.1.0](http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter).
      )
      

      def resource_type
        'Encounter'
      end

      def scratch_resources
        scratch[:encounter_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter',
                                '6.1.0',
                                skip_if_empty: true)
      end
    end
  end
end
