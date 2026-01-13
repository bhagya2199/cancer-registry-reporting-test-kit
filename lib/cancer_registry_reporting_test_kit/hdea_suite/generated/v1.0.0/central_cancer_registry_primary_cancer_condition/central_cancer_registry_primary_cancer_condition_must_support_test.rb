# frozen_string_literal: true

require_relative '../../../../must_support_test'
require_relative '../../../../hdea_generator/group_metadata'

module CancerRegistryReportingTestKit
  module HDEAV200
    class CentralCancerRegistryPrimaryCancerConditionMustSupportTest < Inferno::Test
      include CancerRegistryReportingTestKit::MustSupportTest

      title 'Central Cancer Registry Reporting Primary Cancer Condition profile must support element coverage'
      description %(
        This test looks across all instances associated with the
        [Central Cancer Registry Reporting Primary Cancer Condition profile]
        (http://hl7.org/fhir/us/central-cancer-registry-reporting/StructureDefinition/central-cancer-registry-primary-cancer-condition|2.0.0-ballot)
        found in the provided report Bundles and verifies that they contain populated examples of
        must support elements defined in the profile.

        Conditional rule for data-absent-reason:
        - If Condition.bodySite has lateralityQualifier or locationQualifier, data-absent-reason is not required.
        - If both qualifiers are absent, Condition.bodySite.extension:data-absent-reason must be present.
      )

      id :ccrr_v200_central_cancer_registry_primary_cancer_condition_must_support_test

      def resource_type
        'Condition'
      end

      def self.metadata
        @metadata ||= HdeaGenerator::GroupMetadata.new(
          YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true)
        )
      end

      def scratch_resources
        scratch[:central_cancer_registry_primary_cancer_condition_resources] ||= {}
      end

      run do
        # Standard MS checks from metadata.yml (does NOT include data-absent-reason)
        perform_must_support_test(all_scratch_resources)

        # Conditional MS logic for bodySite data-absent-reason
        conditions = all_scratch_resources || []
        skip_if conditions.empty?, 'No Primary Cancer Condition resources were found'

        conditions.each do |condition|
          next if bodiesite_has_any_qualifier?(condition)

          assert bodiesite_has_data_absent_reason?(condition),
                 'Could not find Condition.bodySite.extension:data-absent-reason in the provided Condition resource ' \
                 'when bodySite lateralityQualifier and locationQualifier are absent'
        end
      end

      private

      def bodiesite_has_extension?(condition, url)
        Array(condition&.bodySite).any? do |bs|
          Array(bs&.extension).any? { |ext| ext&.url == url }
        end
      end

      def bodiesite_has_any_qualifier?(condition)
        bodiesite_has_extension?(condition, 'http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-body-location-qualifier') ||
          bodiesite_has_extension?(condition, 'http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-laterality-qualifier')
      end
    end
  end
end