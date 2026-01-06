# frozen_string_literal: true

require_relative '../../must_support_test'
require_relative '../../hdea_generator/group_metadata'

module CancerRegistryReportingTestKit
  module HDEAV100
    class PractitionerRoleMustSupportTest < Inferno::Test
      include CancerRegistryReportingTestKit::MustSupportTest

      title 'All must support elements are provided in the Practitioner Role resources returned'
      description %(
        US Core Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Core Server Capability
        Statement. This test will look through the PractitionerRole resources
        found previously for the following must support elements:

        * PractitionerRole.code
        * PractitionerRole.endpoint
        * PractitionerRole.location
        * PractitionerRole.organization
        * PractitionerRole.practitioner
        * PractitionerRole.specialty
        * PractitionerRole.telecom
        * PractitionerRole.telecom.system
        * PractitionerRole.telecom.value
      )

      id :ccrr_v100_practitioner_role_must_support_test

      def resource_type
        'PractitionerRole'
      end

      def self.metadata
        @metadata ||= HdeaGenerator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'practitioner_role_metadata.yml'),
                                                                      aliases: true))
      end

      def scratch_resources
        scratch[:author_resources] ||= {}
      end

      AUTHOR_PROFILES = {
        'PractitionerRole' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitionerrole',
        'Practitioner' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitioner',
        'Organization' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-organization'
      }.freeze

      run do
        resources_by_type = {
          'PractitionerRole' => [],
          'Practitioner' => [],
          'Organization' => []
        }

        scratch_resources[:all]&.each do |author|
          resources_by_type[author.resourceType] << author
        end

        skip if resources_by_type['Practitioner'].empty? && resources_by_type['PractitionerRole'].empty? && resources_by_type['Organization'].empty?
        omit if resources_by_type['PractitionerRole'].empty?
        perform_must_support_test(resources_by_type['PractitionerRole'])
      end
    end
  end
end
