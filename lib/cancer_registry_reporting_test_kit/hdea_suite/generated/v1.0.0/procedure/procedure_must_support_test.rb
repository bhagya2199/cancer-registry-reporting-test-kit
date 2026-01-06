# frozen_string_literal: true

require_relative '../../../../must_support_test'
require_relative '../../../../hdea_generator/group_metadata'

module CancerRegistryReportingTestKit
  module HDEAV100
    class ProcedureMustSupportTest < Inferno::Test
      include CancerRegistryReportingTestKit::MustSupportTest

      title 'US Core Procedure profile must support element coverage'
      description %(
        This test looks across all instances
        associated with the [US Core Procedure profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-procedure|5.0.1)
        found in the provided report Bundles and verifies that they
        contain populated examples of the following must support elements
        defined in the profile:

        * Procedure.code
        * Procedure.performed[x]
        * Procedure.status
        * Procedure.subject
      )

      id :ccrr_v200_procedure_must_support_test

      def resource_type
        'Procedure'
      end

      def self.metadata
        @metadata ||= HdeaGenerator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:procedure_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
