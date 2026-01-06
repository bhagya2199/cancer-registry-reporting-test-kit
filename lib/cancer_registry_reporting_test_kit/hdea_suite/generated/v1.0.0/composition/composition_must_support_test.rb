# frozen_string_literal: true

require_relative '../../../../must_support_test'
require_relative '../../../../hdea_generator/group_metadata'

module CancerRegistryReportingTestKit
  module HDEAV100
    class CompositionMustSupportTest < Inferno::Test
      include CancerRegistryReportingTestKit::MustSupportTest

      title 'Central Cancer Registry Reporting Composition profile must support element coverage'
      description %(
        This test looks across all instances
        associated with the [Central Cancer Registry Reporting Composition profile](http://hl7.org/fhir/us/central-cancer-registry-reporting/StructureDefinition/ccrr-composition|2.0.0-ballot)
        found in the provided report Bundles and verifies that they
        contain populated examples of the following must support elements
        defined in the profile:

        * Composition.author
        * Composition.date
        * Composition.encounter
        * Composition.identifier
        * Composition.section
        * Composition.section:sliceEncounterSection
        * Composition.section:sliceEncounterSection.code
        * Composition.section:sliceEncounterSection.entry
        * Composition.section:sliceEncounterSection.text
        * Composition.section:sliceTNMStaging
        * Composition.section:sliceTNMStaging.code
        * Composition.section:sliceTNMStaging.entry
        * Composition.section:sliceTNMStaging.text
        * Composition.section:sliceMedicationsAdministeredSection
        * Composition.section:sliceMedicationsAdministeredSection.code
        * Composition.section:sliceMedicationsAdministeredSection.entry
        * Composition.section:sliceMedicationsAdministeredSection.text
        * Composition.section:sliceMedicationsSection
        * Composition.section:sliceMedicationsSection.code
        * Composition.section:sliceMedicationsSection.entry
        * Composition.section:sliceMedicationsSection.text
        * Composition.section:sliceNotesSection
        * Composition.section:sliceNotesSection.code
        * Composition.section:sliceNotesSection.entry
        * Composition.section:sliceNotesSection.text
        * Composition.section:sliceODHSection
        * Composition.section:sliceODHSection.code
        * Composition.section:sliceODHSection.entry
        * Composition.section:sliceODHSection.text
        * Composition.section:slicePlanOfTreatmentSection
        * Composition.section:slicePlanOfTreatmentSection.code
        * Composition.section:slicePlanOfTreatmentSection.entry
        * Composition.section:slicePlanOfTreatmentSection.text
        * Composition.section:slicePrimaryCancerCondition
        * Composition.section:slicePrimaryCancerCondition.code
        * Composition.section:slicePrimaryCancerCondition.entry
        * Composition.section:slicePrimaryCancerCondition.text
        * Composition.section:sliceProblemSection
        * Composition.section:sliceProblemSection.code
        * Composition.section:sliceProblemSection.entry
        * Composition.section:sliceProblemSection.text
        * Composition.section:sliceProceduresSection
        * Composition.section:sliceProceduresSection.code
        * Composition.section:sliceProceduresSection.entry
        * Composition.section:sliceProceduresSection.text
        * Composition.section:sliceRadioTherapyCourseSummary
        * Composition.section:sliceRadioTherapyCourseSummary.code
        * Composition.section:sliceRadioTherapyCourseSummary.entry
        * Composition.section:sliceRadioTherapyCourseSummary.text
        * Composition.section:sliceResultsSection
        * Composition.section:sliceResultsSection.code
        * Composition.section:sliceResultsSection.entry
        * Composition.section:sliceResultsSection.text
        * Composition.section:sliceSecondaryCancerCondition
        * Composition.section:sliceSecondaryCancerCondition.code
        * Composition.section:sliceSecondaryCancerCondition.entry
        * Composition.section:sliceSecondaryCancerCondition.text
        * Composition.section:sliceSocialHistorySection
        * Composition.section:sliceSocialHistorySection.code
        * Composition.section:sliceSocialHistorySection.entry
        * Composition.section:sliceSocialHistorySection.text
        * Composition.section:sliceVitalSignsSection
        * Composition.section:sliceVitalSignsSection.code
        * Composition.section:sliceVitalSignsSection.entry
        * Composition.section:sliceVitalSignsSection.text
        * Composition.status
        * Composition.subject
        * Composition.title
        * Composition.type.coding.code
      )

      id :ccrr_v200_composition_must_support_test

      def resource_type
        'Composition'
      end

      def self.metadata
        @metadata ||= HdeaGenerator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:composition_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
