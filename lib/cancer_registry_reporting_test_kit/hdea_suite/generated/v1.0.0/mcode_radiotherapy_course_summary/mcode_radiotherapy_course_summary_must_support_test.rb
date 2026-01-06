# frozen_string_literal: true

require_relative '../../../../must_support_test'
require_relative '../../../../hdea_generator/group_metadata'

module CancerRegistryReportingTestKit
  module HDEAV100
    class McodeRadiotherapyCourseSummaryMustSupportTest < Inferno::Test
      include CancerRegistryReportingTestKit::MustSupportTest

      title 'Radiotherapy Course Summary profile must support element coverage'
      description %(
        This test looks across all instances
        associated with the [Radiotherapy Course Summary profile](http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-course-summary|4.0.0)
        found in the provided report Bundles and verifies that they
        contain populated examples of the following must support elements
        defined in the profile:

        * Procedure.bodySite
        * Procedure.code.coding.code
        * Procedure.extension:actualNumberOfSessions
        * Procedure.extension:doseDeliveredToVolume
        * Procedure.extension:modalityAndTechnique
        * Procedure.extension:terminationReason
        * Procedure.extension:treatmentIntent
        * Procedure.performed[x]
        * Procedure.reasonCode
        * Procedure.reasonReference
        * Procedure.status
        * Procedure.subject
      )

      id :ccrr_v200_mcode_radiotherapy_course_summary_must_support_test

      def resource_type
        'Procedure'
      end

      def self.metadata
        @metadata ||= HdeaGenerator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:mcode_radiotherapy_course_summary_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
