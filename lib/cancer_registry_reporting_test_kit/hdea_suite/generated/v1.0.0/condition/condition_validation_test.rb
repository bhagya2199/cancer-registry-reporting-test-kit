# frozen_string_literal: true

require_relative '../../../../validation_test'

module CancerRegistryReportingTestKit
  module HDEAV100
    class ConditionValidationTest < Inferno::Test
      include CancerRegistryReportingTestKit::ValidationTest

      id :ccrr_v200_condition_validation_test
      title 'US Core Condition profile conformance'
      description %(
        This test verifies that Condition instances
        found in the Problems sections of the provided reports conform to the
        [US Core Condition profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition|6.1.0).
      )
      

      def resource_type
        'Condition'
      end

      def scratch_resources
        scratch[:condition_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition-problems-health-concerns',
                                '6.1.0',
                                skip_if_empty: true)
      end
    end
  end
end
