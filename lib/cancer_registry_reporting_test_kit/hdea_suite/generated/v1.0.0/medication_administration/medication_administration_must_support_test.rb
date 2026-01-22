# frozen_string_literal: true

require_relative '../../../../must_support_test'
require_relative '../../../../hdea_generator/group_metadata'

module CancerRegistryReportingTestKit
  module HDEAV100
    class MedicationAdministrationMustSupportTest < Inferno::Test
      include CancerRegistryReportingTestKit::MustSupportTest

      title 'Cancer-Related Medication Administration profile must support element coverage'
      description %(
        This test looks across all instances
        associated with the [Cancer-Related Medication Administration profile](http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-cancer-related-medication-administration|4.0.0)
        found in the provided report Bundles and verifies that they
        contain populated examples of the following must support elements
        defined in the profile:

        * MedicationAdministration.effective[x]
        * MedicationAdministration.extension:treatmentIntent
        * MedicationAdministration.medication[x]
        * MedicationAdministration.reasonCode
        * MedicationAdministration.reasonReference
        * MedicationAdministration.status
        * MedicationAdministration.statusReason
        * MedicationAdministration.subject
      )

      id :ccrr_v200_medication_administration_must_support_test

      def resource_type
        'MedicationAdministration'
      end

      def self.metadata
        @metadata ||= HdeaGenerator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:medication_administration_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
