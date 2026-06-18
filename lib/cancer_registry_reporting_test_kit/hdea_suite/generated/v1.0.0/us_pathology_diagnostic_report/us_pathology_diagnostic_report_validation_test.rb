require_relative '../../../../validation_test'

module CancerRegistryReportingTestKit
  module HDEAV100
    class UsPathologyDiagnosticReportValidationTest < Inferno::Test
      include CancerRegistryReportingTestKit::ValidationTest

      id :ccrr_v200_us_pathology_diagnostic_report_validation_test
      title 'US Pathology Diagnostic Report profile conformance'
      description %(
        This test verifies that DiagnosticReport instances
        found in the provided report Bundles conform to the
        [US Pathology Diagnostic Report profile](http://hl7.org/fhir/us/cancer-reporting/StructureDefinition/us-pathology-diagnostic-report|2.0.0).
      )

      def resource_type
        'DiagnosticReport'
      end

      def scratch_resources
        scratch[:us_pathology_diagnostic_report_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/cancer-reporting/StructureDefinition/us-pathology-diagnostic-report',
                                '2.0.0',
                                skip_if_empty: true)
      end
    end
  end
end
