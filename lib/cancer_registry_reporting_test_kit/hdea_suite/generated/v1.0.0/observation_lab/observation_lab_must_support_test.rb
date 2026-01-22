# frozen_string_literal: true

require_relative '../../../../must_support_test'
require_relative '../../../../hdea_generator/group_metadata'

module CancerRegistryReportingTestKit
  module HDEAV100
    class ObservationLabMustSupportTest < Inferno::Test
      include CancerRegistryReportingTestKit::MustSupportTest

      title 'US Core Laboratory Result Observation profile must support element coverage'
      description %(
        This test looks across all instances
        associated with the [US Core Laboratory Result Observation profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab|6.1.0)
        found in the provided report Bundles and verifies that they
        contain populated examples of the following must support elements
        defined in the profile:

        * Observation.category
        * Observation.category:Laboratory
        * Observation.code
        * Observation.dataAbsentReason
        * Observation.effectiveDateTime
        * Observation.status
        * Observation.subject
        * Observation.valueCodeableConcept
        * Observation.valueQuantity
        * Observation.valueString
      )

      id :ccrr_v200_observation_lab_must_support_test

      def resource_type
        'Observation'
      end

      def self.metadata
        @metadata ||= HdeaGenerator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:observation_lab_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
