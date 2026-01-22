# frozen_string_literal: true

require_relative '../../../../must_support_test'
require_relative '../../../../hdea_generator/group_metadata'

module CancerRegistryReportingTestKit
  module HDEAV100
    class OrganizationMustSupportTest < Inferno::Test
      include CancerRegistryReportingTestKit::MustSupportTest

      title 'US Core Organization profile must support element coverage'
      description %(
        This test looks across all instances
        associated with the [US Core Organization profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-organization|6.1.0)
        found in the provided report Bundles and verifies that they
        contain populated examples of the following must support elements
        defined in the profile:

        * Organization.active
        * Organization.address
        * Organization.address.city
        * Organization.address.country
        * Organization.address.line
        * Organization.address.postalCode
        * Organization.address.state
        * Organization.identifier
        * Organization.identifier.system
        * Organization.identifier.value
        * Organization.identifier:NPI
        * Organization.name
        * Organization.telecom
        * Organization.telecom.system
        * Organization.telecom.value
      )

      id :ccrr_v100_organization_must_support_test

      def resource_type
        'Organization'
      end

      def self.metadata
        @metadata ||= HdeaGenerator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:organization_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
