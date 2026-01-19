# frozen_string_literal: true

require_relative '../../../../validation_test'

module CancerRegistryReportingTestKit
  module HDEAV100
    class CarePlanValidationTest < Inferno::Test
      include CancerRegistryReportingTestKit::ValidationTest

      id :ccrr_v200_care_plan_validation_test
      title 'US Core CarePlan profile conformance'
      description %(
        This test verifies that CarePlan instances
        found in the Plan of Treatment sections of the provided reports conform to the
        [US Core CarePlan profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-careplan|5.0.1).
      )
      

      def resource_type
        'CarePlan'
      end

      def scratch_resources
        scratch[:care_plan_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/core/StructureDefinition/us-core-careplan',
                                '6.1.0',
                                skip_if_empty: true)
      end
    end
  end
end
