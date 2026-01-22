# frozen_string_literal: true

require_relative '../../../../validation_test'

module CancerRegistryReportingTestKit
  module HDEAV100
    class McodeRadiotherapyCourseSummaryValidationTest < Inferno::Test
      include CancerRegistryReportingTestKit::ValidationTest

      id :ccrr_v200_mcode_radiotherapy_course_summary_validation_test
      title 'Radiotherapy Course Summary profile conformance'
      description %(
        This test verifies that Procedure instances
        found in the Radiotherapy Course Summary sections of the provided reports conform to the
        [Radiotherapy Course Summary profile](http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-course-summary|4.0.0).
      )
      

      def resource_type
        'Procedure'
      end

      def scratch_resources
        scratch[:mcode_radiotherapy_course_summary_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-course-summary',
                                '4.0.0',
                                skip_if_empty: true)
      end
    end
  end
end
