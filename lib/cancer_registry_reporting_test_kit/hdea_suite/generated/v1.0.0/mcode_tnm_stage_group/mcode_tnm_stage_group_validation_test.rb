# frozen_string_literal: true

require_relative '../../../../validation_test'

module CancerRegistryReportingTestKit
  module HDEAV100
    class McodeTnmStageGroupValidationTest < Inferno::Test
      include CancerRegistryReportingTestKit::ValidationTest

      id :ccrr_v200_mcode_tnm_stage_group_validation_test
      title 'TNM Stage Group profile conformance'
      description %(
        This test verifies that Observation instances
        found in the Cancer Stage Group sections of the provided reports conform to the
        [TNM Stage Group profile](http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-tnm-stage-group|3.0.0).
      )
      

      def resource_type
        'Observation'
      end

      def scratch_resources
        scratch[:mcode_tnm_stage_group_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-tnm-stage-group',
                                '3.0.0',
                                skip_if_empty: true)
      end
    end
  end
end
