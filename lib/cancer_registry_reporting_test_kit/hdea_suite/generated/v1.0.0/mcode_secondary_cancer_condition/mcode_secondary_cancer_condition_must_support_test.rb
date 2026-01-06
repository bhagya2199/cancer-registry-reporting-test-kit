# frozen_string_literal: true

require_relative '../../../../must_support_test'
require_relative '../../../../hdea_generator/group_metadata'

module CancerRegistryReportingTestKit
  module HDEAV100
    class McodeSecondaryCancerConditionMustSupportTest < Inferno::Test
      include CancerRegistryReportingTestKit::MustSupportTest

      title 'Secondary Cancer Condition profile must support element coverage'
      description %(
        This test looks across all instances
        associated with the [Secondary Cancer Condition profile](http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-secondary-cancer-condition|4.0.0)
        found in the provided report Bundles and verifies that they
        contain populated examples of the following must support elements
        defined in the profile:

        * Condition.abatementDateTime
        * Condition.bodySite
        * Condition.bodySite.extension:lateralityQualifier
        * Condition.bodySite.extension:locationQualifier
        * Condition.category
        * Condition.category:sdoh
        * Condition.category:us-core
        * Condition.clinicalStatus
        * Condition.code
        * Condition.extension:assertedDate
        * Condition.extension:histologyMorphologyBehavior
        * Condition.extension:relatedPrimaryCancerCondition
        * Condition.onsetDateTime
        * Condition.recordedDate
        * Condition.subject
        * Condition.verificationStatus
      )

      id :ccrr_v200_mcode_secondary_cancer_condition_must_support_test

      def resource_type
        'Condition'
      end

      def self.metadata
        @metadata ||= HdeaGenerator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:mcode_secondary_cancer_condition_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
