require_relative '../../../../must_support_test'
require_relative '../../../../hdea_generator/group_metadata'

module CancerRegistryReportingTestKit
  module HDEAV100
    class UsPathologyDiagnosticReportMustSupportTest < Inferno::Test
      include CancerRegistryReportingTestKit::MustSupportTest

      title 'US Pathology Diagnostic Report profile must support element coverage'
      description %(
        This test looks across all instances
        associated with the [US Pathology Diagnostic Report profile](http://hl7.org/fhir/us/cancer-reporting/StructureDefinition/us-pathology-diagnostic-report|2.0.0)
        found in the provided report Bundles and verifies that they
        contain populated examples of the must support elements
        defined in the profile.
      )

      id :ccrr_v200_us_pathology_diagnostic_report_must_support_test

      def resource_type
        'DiagnosticReport'
      end

      def self.metadata
        @metadata ||= HdeaGenerator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:us_pathology_diagnostic_report_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
