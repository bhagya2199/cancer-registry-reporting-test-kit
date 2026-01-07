# frozen_string_literal: true

require_relative '../../../../validation_test'

module CancerRegistryReportingTestKit
  module HDEAV100
    class OdhUsualWorkValidationTest < Inferno::Test
      include CancerRegistryReportingTestKit::ValidationTest

      id :ccrr_v100_odh_usual_work_validation_test
      title 'Usual Work profile conformance'
      description %(
        This test verifies that Observation instances
        found in the Occupational Data sections of the provided reports conform to the
        [Usual Work profile](http://hl7.org/fhir/us/odh/StructureDefinition/odh-UsualWork|1.1.0).
      )
      

      def resource_type
        'Observation'
      end

      def scratch_resources
        scratch[:odh_usual_work_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/odh/StructureDefinition/odh-UsualWork',
                                '1.1.0',
                                skip_if_empty: true)
      end
    end
  end
end
