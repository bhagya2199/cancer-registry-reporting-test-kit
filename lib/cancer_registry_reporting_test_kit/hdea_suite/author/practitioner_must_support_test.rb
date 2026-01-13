# frozen_string_literal: true

require_relative '../../must_support_test'
require_relative '../../hdea_generator/group_metadata'

module CancerRegistryReportingTestKit
  module HDEAV100
    class PractitionerMustSupportTest < Inferno::Test
      include CancerRegistryReportingTestKit::MustSupportTest

      title 'All must support elements are provided in the Practitioner resources returned'
      description %(
        US Core Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Core Server Capability
        Statement. This test will look through the Practitioner resources
        found previously for the following must support elements:

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
        @metadata ||= HdeaGenerator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'practitioner_metadata.yml'),
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
        omit if resources_by_type['Practitioner'].empty?
        perform_must_support_test(resources_by_type['Practitioner'])
      end
    end
  end
end
