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

      # DAR URL (for extensions). For Observation.value[x], US Core Vital Signs uses dataAbsentReason element,
      # not the primitive _value[x] pattern.
      DAR_EXTENSION_URL = 'http://hl7.org/fhir/StructureDefinition/data-absent-reason'.freeze

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
        resources = all_scratch_resources

        perform_must_support_test(resources)

        # Vital Signs DAR fallback:
        # If Observation.value[x] is missing, Observation.dataAbsentReason must be present.
        resources.each do |obs|
          next unless obs.is_a?(FHIR::Observation)

          unless observation_has_any_value?(obs)
            assert has_data_absent_reason_codeable_concept?(obs.dataAbsentReason),
                  'Observation.value[x] is missing, so Observation.dataAbsentReason must be present for Vital Signs.'
          end

          # If any component.value[x] is missing, that component must carry component.dataAbsentReason
          Array(obs.component).each do |comp|
            next if component_has_any_value?(comp)

            assert has_data_absent_reason_codeable_concept?(comp.dataAbsentReason),
                  'Observation.component.value[x] is missing, so Observation.component.dataAbsentReason must be present for Vital Signs.'
          end
        end
      end

      private
      def observation_has_any_value?(observation)
        return true if observation.valueQuantity&.value.present?
        return true if observation.valueCodeableConcept&.coding&.any?
        return true if observation.valueString.present?
        return true if observation.valueBoolean.in?([true, false])
        return true if observation.valueInteger.present?
        return true if observation.valueRange.present?
        return true if observation.valueRatio.present?
        return true if observation.valueSampledData.present?
        return true if observation.valueTime.present?
        return true if observation.valueDateTime.present?
        return true if observation.valuePeriod.present?

        false
      end

      def component_has_any_value?(component)
        return true if component.valueQuantity&.value.present?
        return true if component.valueCodeableConcept&.coding&.any?
        return true if component.valueString.present?
        return true if component.valueBoolean.in?([true, false])
        return true if component.valueInteger.present?
        return true if component.valueRange.present?
        return true if component.valueRatio.present?
        return true if component.valueSampledData.present?
        return true if component.valueTime.present?
        return true if component.valueDateTime.present?
        return true if component.valuePeriod.present?

        false
      end

      def has_data_absent_reason_codeable_concept?(cc)
        cc&.coding&.any?(&:code).present? || cc&.text.present?
      end

    end
  end
end
