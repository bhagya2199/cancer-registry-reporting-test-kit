# frozen_string_literal: true

require_relative '../../../../must_support_test'
require_relative '../../../../hdea_generator/group_metadata'

module CancerRegistryReportingTestKit
  module HDEAV100
    class MedicationRequestMustSupportTest < Inferno::Test
      include CancerRegistryReportingTestKit::MustSupportTest

      title 'Cancer-Related Medication Request profile must support element coverage'
      description %(
        This test looks across all instances
        associated with the [Cancer-Related Medication Request profile](http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-cancer-related-medication-request|3.0.0)
        found in the provided report Bundles and verifies that they
        contain populated examples of the following must support elements
        defined in the profile:

        * MedicationRequest.authoredOn
        * MedicationRequest.category
        * MedicationRequest.category:us-core
        * MedicationRequest.dosageInstruction
        * MedicationRequest.dosageInstruction.text
        * MedicationRequest.encounter
        * MedicationRequest.extension:treatmentIntent
        * MedicationRequest.intent
        * MedicationRequest.medication[x]
        * MedicationRequest.reasonCode
        * MedicationRequest.reasonReference
        * MedicationRequest.reportedBoolean
        * MedicationRequest.reportedReference
        * MedicationRequest.requester
        * MedicationRequest.status
        * MedicationRequest.statusReason
        * MedicationRequest.subject
      )

      id :ccrr_v200_medication_request_must_support_test

      def resource_type
        'MedicationRequest'
      end

      def self.metadata
        @metadata ||= HdeaGenerator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:medication_request_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
