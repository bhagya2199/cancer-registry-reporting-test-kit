# frozen_string_literal: true

require_relative '../../../../must_support_test'
require_relative '../../../../hdea_generator/group_metadata'

module CancerRegistryReportingTestKit
  module HDEAV100
    class ObservationMustSupportTest < Inferno::Test
      include CancerRegistryReportingTestKit::MustSupportTest

      title 'Base Observation profile must support element coverage'
      description %(
        This test looks across all instances
        associated with the [Base Observation profile](http://hl7.org/fhir/StructureDefinition/Observation|4.0.1)
        found in the provided report Bundles and verifies that they
        contain populated examples of the following must support elements
        defined in the profile:


      )

      id :ccrr_v200_observation_must_support_test

      def resource_type
        'Observation'
      end

      def self.metadata
        @metadata ||= HdeaGenerator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:observation_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
