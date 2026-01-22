# frozen_string_literal: true

require_relative '../../../../must_support_test'
require_relative '../../../../hdea_generator/group_metadata'

module CancerRegistryReportingTestKit
  module HDEAV100
    class DiagnosticReportNoteMustSupportTest < Inferno::Test
      include CancerRegistryReportingTestKit::MustSupportTest

      title 'US Core DiagnosticReport Profile for Report and Note Exchange profile must support element coverage'
      description %(
        This test looks across all instances
        associated with the [US Core DiagnosticReport Profile for Report and Note Exchange profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-note|6.1.0)
        found in the provided report Bundles and verifies that they
        contain populated examples of the following must support elements
        defined in the profile:

        * DiagnosticReport.category
        * DiagnosticReport.category:us-core
        * DiagnosticReport.code
        * DiagnosticReport.effectiveDateTime
        * DiagnosticReport.encounter
        * DiagnosticReport.issued
        * DiagnosticReport.media
        * DiagnosticReport.media.link
        * DiagnosticReport.performer
        * DiagnosticReport.presentedForm
        * DiagnosticReport.result
        * DiagnosticReport.status
        * DiagnosticReport.subject
      )

      id :ccrr_v200_diagnostic_report_note_must_support_test

      def resource_type
        'DiagnosticReport'
      end

      def self.metadata
        @metadata ||= HdeaGenerator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:diagnostic_report_note_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
