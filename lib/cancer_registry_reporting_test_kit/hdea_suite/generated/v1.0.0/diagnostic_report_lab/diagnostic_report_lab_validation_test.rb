# frozen_string_literal: true

require_relative '../../../../validation_test'

module CancerRegistryReportingTestKit
  module HDEAV100
    class DiagnosticReportLabValidationTest < Inferno::Test
      include CancerRegistryReportingTestKit::ValidationTest

      id :ccrr_v200_diagnostic_report_lab_validation_test
      title 'US Core DiagnosticReport Profile for Laboratory Results Reporting profile conformance'
      description %(
        This test verifies that DiagnosticReport instances
        found in the Results sections of the provided reports conform to the
        [US Core DiagnosticReport Profile for Laboratory Results Reporting profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-lab|5.0.1).
      )
      

      def resource_type
        'DiagnosticReport'
      end

      def scratch_resources
        scratch[:diagnostic_report_lab_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-lab',
                                '5.0.1',
                                skip_if_empty: true)
      end
    end
  end
end
