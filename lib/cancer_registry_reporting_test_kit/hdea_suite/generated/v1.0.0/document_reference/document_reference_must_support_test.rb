# frozen_string_literal: true

require_relative '../../../../must_support_test'
require_relative '../../../../hdea_generator/group_metadata'

module CancerRegistryReportingTestKit
  module HDEAV100
    class DocumentReferenceMustSupportTest < Inferno::Test
      include CancerRegistryReportingTestKit::MustSupportTest

      title 'US Core DocumentReference profile must support element coverage'
      description %(
        This test looks across all instances
        associated with the [US Core DocumentReference profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-documentreference|6.1.0)
        found in the provided report Bundles and verifies that they
        contain populated examples of the following must support elements
        defined in the profile:

        * DocumentReference.author
        * DocumentReference.category
        * DocumentReference.category:us-core
        * DocumentReference.content
        * DocumentReference.content.attachment
        * DocumentReference.content.attachment.contentType
        * DocumentReference.content.attachment.data
        * DocumentReference.content.attachment.url
        * DocumentReference.content.format
        * DocumentReference.context
        * DocumentReference.context.encounter
        * DocumentReference.context.period
        * DocumentReference.date
        * DocumentReference.identifier
        * DocumentReference.status
        * DocumentReference.subject
        * DocumentReference.type
      )

      id :ccrr_v100_document_reference_must_support_test

      def resource_type
        'DocumentReference'
      end

      def self.metadata
        @metadata ||= HdeaGenerator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:document_reference_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
