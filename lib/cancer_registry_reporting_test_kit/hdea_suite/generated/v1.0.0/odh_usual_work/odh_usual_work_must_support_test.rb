# frozen_string_literal: true

require_relative '../../../../must_support_test'
require_relative '../../../../hdea_generator/group_metadata'

module CancerRegistryReportingTestKit
  module HDEAV100
    class OdhUsualWorkMustSupportTest < Inferno::Test
      include CancerRegistryReportingTestKit::MustSupportTest

      title 'Usual Work profile must support element coverage'
      description %(
        This test looks across all instances
        associated with the [Usual Work profile](http://hl7.org/fhir/us/odh/StructureDefinition/odh-UsualWork|1.1.0)
        found in the provided report Bundles and verifies that they
        contain populated examples of the following must support elements
        defined in the profile:

        * Observation.component:odh-UsualIndustry.value[x].coding
        * Observation.component:odh-UsualIndustry.value[x].coding:industryCDCCensus2010
        * Observation.component:odh-UsualIndustry.value[x].coding:industryONETSOCDetailODH
        * Observation.value[x]:valueCodeableConcept
        * Observation.value[x]:valueCodeableConcept.coding
        * Observation.value[x]:valueCodeableConcept.coding:occupationCDCCensus2010
        * Observation.value[x]:valueCodeableConcept.coding:occupationONETSOCDetailODH

        Note: MS slices were identified by only the codesystem, not the specific codes used, due to the large number of codes included in the codesystem.
      )

      id :ccrr_v100_odh_usual_work_must_support_test

      def resource_type
        'Observation'
      end

      def self.metadata
        @metadata ||= HdeaGenerator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:odh_usual_work_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
