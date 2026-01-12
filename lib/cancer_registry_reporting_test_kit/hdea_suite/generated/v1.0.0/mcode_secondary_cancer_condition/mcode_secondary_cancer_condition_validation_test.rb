# frozen_string_literal: true

require_relative '../../../../validation_test'

module CancerRegistryReportingTestKit
  module HDEAV100
    class McodeSecondaryCancerConditionValidationTest < Inferno::Test
      include CancerRegistryReportingTestKit::ValidationTest

      id :ccrr_v200_mcode_secondary_cancer_condition_validation_test
      title 'Secondary Cancer Condition profile conformance'
      description %(
        This test verifies that Condition instances
        found in the Secondary Cancer Condition sections of the provided reports conform to the
        [Secondary Cancer Condition profile](http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-secondary-cancer-condition|4.0.0).
      )
      

      def resource_type
        'Condition'
      end

      def scratch_resources
        scratch[:mcode_secondary_cancer_condition_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-secondary-cancer-condition',
                                '3.0.0',
                                skip_if_empty: true)
      end
    end
  end
end
