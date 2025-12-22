# frozen_string_literal: true

require_relative '../../../../must_support_test'
require_relative '../../../../hdea_generator/group_metadata'

module CancerRegistryReportingTestKit
  module HDEAV100
    class PatientMustSupportTest < Inferno::Test
      include CancerRegistryReportingTestKit::MustSupportTest

      title 'CCRR Patient Profile must support element coverage'
      description %(
        This test looks across all instances
        associated with the [CCRR Patient Profile v2.0.0](http://build.fhir.org/ig/HL7/fhir-central-cancer-registry-reporting-ig/StructureDefinition-central-cancer-registry-reporting-patient.html)
        found in the provided report Bundles and verifies that they
        contain populated examples of the following must support elements
        defined in the profile:

        * Patient.address
        * Patient.address.city
        * Patient.address.line
        * Patient.address.period
        * Patient.address.postalCode
        * Patient.address.state
        * Patient.birthDate
        * Patient.communication
        * Patient.communication.language
        * Patient.gender
        * Patient.extension:race
        * Patient.extension:ethnicity
        * Patient.extension:race.extension:ombCategory
        * Patient.extension:ethnicity.extension:ombCategory
        * Patient.identifier
        * Patient.identifier.system
        * Patient.identifier.value
        * Patient.name
        * Patient.name.family
        * Patient.name.given
        * Patient.telecom.system
        * Patient.telecom.use
        * Patient.telecom.value
      )

      id :ccrr_v200_patient_must_support_test

      def resource_type
        'Patient'
      end

      def self.metadata
        @metadata ||= HdeaGenerator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:patient_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
