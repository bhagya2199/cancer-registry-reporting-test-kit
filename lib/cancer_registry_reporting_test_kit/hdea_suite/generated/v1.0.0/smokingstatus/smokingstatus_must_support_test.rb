# frozen_string_literal: true

require_relative '../../../../must_support_test'
require_relative '../../../../hdea_generator/group_metadata'

module CancerRegistryReportingTestKit
  module HDEAV100
    class SmokingstatusMustSupportTest < Inferno::Test
      include CancerRegistryReportingTestKit::MustSupportTest

      title 'US Core Smoking Status Observation profile must support element coverage'
      description %(
        This test looks across all instances
        associated with the [US Core Smoking Status Observation profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-smokingstatus|5.0.1)
        found in the provided report Bundles and verifies that they
        contain populated examples of the following must support elements
        defined in the profile:

        * Observation.category
        * Observation.category:SocialHistory
        * Observation.code
        * Observation.effective[x]:effectiveDateTime
        * Observation.status
        * Observation.subject
        * Observation.value[x]:valueCodeableConcept
      )

      id :ccrr_v200_smokingstatus_must_support_test

      def resource_type
        'Observation'
      end

      def self.metadata
        @metadata ||= HdeaGenerator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:smokingstatus_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
