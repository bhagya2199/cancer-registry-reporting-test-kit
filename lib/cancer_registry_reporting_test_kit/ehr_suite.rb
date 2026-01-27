# frozen_string_literal: true

require_relative 'ehr_suite/ehr_data_access_group'
module CancerRegistryReportingTestKit
  class EHRSuite < Inferno::TestSuite
    id :ccrr_ehr
    title 'Cancer Registry Reporting Electronic Health Record (EHR) Test Suite'
    short_title 'EHR Cancer Registry Reporting'
    description File.read(File.join(__dir__, 'docs', 'ehr_suite_description.md'))
    links [
      {
        label: 'Report Issue',
        url: 'https://github.com/inferno-framework/cancer-registry-reporting-test-kit/issues/'
      },
      {
        label: 'Open Source',
        url: 'https://github.com/inferno-framework/cancer-registry-reporting-test-kit/'
      },
      {
        label: 'Download',
        url: 'https://github.com/inferno-framework/cancer-registry-reporting-test-kit/releases'
      },
      {
        label: 'Implementation Guide',
        url: 'https://hl7.org/fhir/us/central-cancer-registry-reporting/STU1/'
      }
    ]

    GENERAL_MESSAGE_FILTERS = [
      %r{Sub-extension url 'introspect' is not defined by the Extension http://fhir-registry\.smarthealthit\.org/StructureDefinition/oauth-uris},
      %r{Sub-extension url 'revoke' is not defined by the Extension http://fhir-registry\.smarthealthit\.org/StructureDefinition/oauth-uris},
      /Observation\.effective\.ofType\(Period\): .*vs-1:/, # Invalid invariant in FHIR v4.0.1
      /Observation\.effective\.ofType\(Period\): .*us-core-1:/, # Invalid invariant in US Core v6.1.0
      /Provenance.agent\[\d*\]: Constraint failed: provenance-1/, # Invalid invariant in US Core v5.0.1
      %r{Unknown Code System 'http://hl7.org/fhir/us/core/CodeSystem/us-core-tags'}, # Validator has an issue
      # with this US Core 5 code system in US Core 6 resource
      %r{URL value 'http://hl7.org/fhir/us/core/CodeSystem/us-core-tags' does not resolve}, # Validator has an issue with
      # this US Core 5 code system in US Core 6 resource
      /\A\S+: \S+: URL value '.*' does not resolve/,
      %r{Observation.component\[\d+\].value.ofType\(Quantity\): The code provided \(http://unitsofmeasure.org#L/min\) was not found in the value set
      'Vital Signs Units'} # Known issue with the Pulse Oximetry Profile
    ].freeze

    VERSION_SPECIFIC_MESSAGE_FILTERS = [].freeze

    VALIDATION_MESSAGE_FILTERS = GENERAL_MESSAGE_FILTERS + VERSION_SPECIFIC_MESSAGE_FILTERS

    def self.metadata
      @metadata ||= YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true)[:groups].map do |raw_metadata|
        HdeaGenerator::GroupMetadata.new(raw_metadata)
      end
    end

    fhir_resource_validator do
      igs 'hl7.fhir.us.central-cancer-registry-reporting#2.0.0-ballot',
          'hl7.fhir.us.core#6.1.0'
      message_filters = VALIDATION_MESSAGE_FILTERS

      exclude_message do |message|
        message_filters.any? { |filter| filter.match? message.message }
      end

      perform_additional_validation do |resource, _profile_url|
        USCoreTestKit::ProvenanceValidator.validate(resource) if resource.instance_of?(FHIR::Provenance)
      end
    end

    group from: :ccrr_ehr_data_access
  end
end
