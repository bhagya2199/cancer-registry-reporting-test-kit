# frozen_string_literal: true

require_relative '../../../../validation_test'

module CancerRegistryReportingTestKit
  module HDEAV100
    class OrganizationValidationTest < Inferno::Test
      include CancerRegistryReportingTestKit::ValidationTest

      id :ccrr_v100_organization_validation_test
      title 'US Core Organization profile conformance'
      description %(
        This test verifies that Organization instances
        referenced in the `author` elements of the provided reports conform to the
        [US Core Organization profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-organization|6.1.0).
      )
      

      def resource_type
        'Organization'
      end

      def scratch_resources
        scratch[:organization_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/core/StructureDefinition/us-core-organization',
                                '6.1.0',
                                skip_if_empty: true)
      end
    end
  end
end
