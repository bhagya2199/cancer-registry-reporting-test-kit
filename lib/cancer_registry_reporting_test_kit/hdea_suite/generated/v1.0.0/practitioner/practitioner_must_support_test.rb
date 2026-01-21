# frozen_string_literal: true

require_relative '../../../../must_support_test'
require_relative '../../../../hdea_generator/group_metadata'

module CancerRegistryReportingTestKit
  module HDEAV100
    class PractitionerMustSupportTest < Inferno::Test
      include CancerRegistryReportingTestKit::MustSupportTest

      title 'US Core Practitioner profile must support element coverage'
      description %(
        This test looks across all instances
        associated with the [US Core Practitioner profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitioner|6.1.0)
        found in the provided report Bundles and verifies that they
        contain populated examples of the following must support elements
        defined in the profile:

        * Practitioner.address
        * Practitioner.address.city
        * Practitioner.address.country
        * Practitioner.address.line
        * Practitioner.address.postalCode
        * Practitioner.address.state
        * Practitioner.identifier
        * Practitioner.identifier.system
        * Practitioner.identifier.value
        * Practitioner.identifier:NPI
        * Practitioner.name
        * Practitioner.name.family
        * Practitioner.telecom
        * Practitioner.telecom.system
        * Practitioner.telecom.value
      )

      id :ccrr_v200_practitioner_must_support_test

      def resource_type
        'Practitioner'
      end

      def self.metadata
        @metadata ||= HdeaGenerator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:practitioner_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
