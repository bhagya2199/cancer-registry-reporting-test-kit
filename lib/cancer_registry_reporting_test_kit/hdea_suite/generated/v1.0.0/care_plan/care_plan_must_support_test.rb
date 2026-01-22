# frozen_string_literal: true

require_relative '../../../../must_support_test'
require_relative '../../../../hdea_generator/group_metadata'

module CancerRegistryReportingTestKit
  module HDEAV100
    class CarePlanMustSupportTest < Inferno::Test
      include CancerRegistryReportingTestKit::MustSupportTest

      title 'US Core CarePlan profile must support element coverage'
      description %(
        This test looks across all instances
        associated with the [US Core CarePlan profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-careplan|6.1.0)
        found in the provided report Bundles and verifies that they
        contain populated examples of the following must support elements
        defined in the profile:

        * CarePlan.category
        * CarePlan.category:AssessPlan
        * CarePlan.intent
        * CarePlan.status
        * CarePlan.subject
        * CarePlan.text
        * CarePlan.text.div
        * CarePlan.text.status
      )

      id :ccrr_v200_care_plan_must_support_test

      def resource_type
        'CarePlan'
      end

      def self.metadata
        @metadata ||= HdeaGenerator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:care_plan_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
