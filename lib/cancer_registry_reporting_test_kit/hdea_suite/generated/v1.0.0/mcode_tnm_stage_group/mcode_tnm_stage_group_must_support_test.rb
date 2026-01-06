# frozen_string_literal: true

require_relative '../../../../must_support_test'
require_relative '../../../../hdea_generator/group_metadata'

module CancerRegistryReportingTestKit
  module HDEAV100
    class McodeTnmStageGroupMustSupportTest < Inferno::Test
      include CancerRegistryReportingTestKit::MustSupportTest

      title 'TNM Stage Group profile must support element coverage'
      description %(
        This test looks across all instances
        associated with the [TNM Stage Group profile](http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-tnm-stage-group|4.0.0)
        found in the provided report Bundles and verifies that they
        contain populated examples of the following must support elements
        defined in the profile:

        * Observation.code
        * Observation.effective[x]
        * Observation.focus
        * Observation.hasMember
        * Observation.method
        * Observation.status
        * Observation.subject
        * Observation.value[x]
      )

      id :ccrr_v200_mcode_tnm_stage_group_must_support_test

      def resource_type
        'Observation'
      end

      def self.metadata
        @metadata ||= HdeaGenerator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:mcode_tnm_stage_group_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
