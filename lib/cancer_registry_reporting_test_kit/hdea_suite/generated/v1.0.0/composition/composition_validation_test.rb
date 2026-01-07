# frozen_string_literal: true

require_relative '../../../../validation_test'

module CancerRegistryReportingTestKit
  module HDEAV100
    class CompositionValidationTest < Inferno::Test
      include CancerRegistryReportingTestKit::ValidationTest

      id :ccrr_v200_composition_validation_test
      title 'Central Cancer Registry Reporting Composition profile conformance'
      description %(
        This test verifies that Composition instances
         of the provided reports conform to the
        [Central Cancer Registry Reporting Composition profile](http://hl7.org/fhir/us/central-cancer-registry-reporting/StructureDefinition/ccrr-composition|2.0.0-ballot).
      )
      

      def resource_type
        'Composition'
      end

      def scratch_resources
        scratch[:composition_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/central-cancer-registry-reporting/StructureDefinition/ccrr-composition',
                                '1.0.0',
                                skip_if_empty: true)
      end
    end
  end
end
