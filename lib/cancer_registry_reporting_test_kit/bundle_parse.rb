# frozen_string_literal: true

require_relative 'fhir_resource_navigation'
require_relative 'hdea_generator/naming'

module CancerRegistryReportingTestKit
  module HDEABundleParse
    extend Forwardable
    include FHIRResourceNavigation

    # Much of this is extremely custom fit to HDEA.
    # HDEA Custom Components:
    # - CODE_TO_URL_MAP, CODE_TO_MULTIPLE_ENTRY_RESOURCE_MAP, FIELD_TO_URL_MAP are nongenerated mappings specific to HDEA.
    # - The `profile_from_resource_type()` method similarly assumes decisions between profiles are made via code. This is NOT what the IG suggests (instead verify by profile)
    # - The `parse_bundle()` method assumes the bundle is a content bundle for hdea and thus starts with a composition resource. It also immediately yields unresolved references as an info message
    # - The `look_for_references_in_resource()` method was designed to be flexible but with HDEA CCRR as the grounds for inspiration. It has not been tested on other bundles that include a composition.
    # - Assumes references are of the form `ResourceType/ID`

    def unresolved_references
      @unresolved_references ||= []
    end

    def clear_unresolved_references
      @unresolved_references = []
    end

    CODE_TO_URL_MAP = {
      '363346000' => 'http://hl7.org/fhir/us/central-cancer-registry-reporting/StructureDefinition/central-cancer-registry-primary-cancer-condition',
      '128462008' => 'http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-secondary-cancer-condition',
      '21908-9' => 'http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-tnm-stage-group',
      '1217123003' => 'http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-course-summary',
      '11450-4' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition',
      '46241-6' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition-encounter-diagnosis',
      '48765-2' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-allergyintolerance',
      '74165-2' => 'http://hl7.org/fhir/us/odh/StructureDefinition/odh-UsualWork',
      '47519-4' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-procedure',
      '8716-3' => 'http://hl7.org/fhir/StructureDefinition/Observation',
      '29762-2' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-smokingstatus'
    }.freeze

    CODE_TO_MULTIPLE_ENTRY_RESOURCE_MAP = {
      '29549-3' => {
        'MedicationAdministration' => 'http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-cancer-related-medication-administration', 'Medication' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-medication'
      },
      '10160-0' => {
        'MedicationAdministration' => 'http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-cancer-related-medication-administration', 'MedicationStatement' => 'http://hl7.org/fhir/StructureDefinition/MedicationStatement', 'Medication' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-medication'
      },
      '30954-2' => { 'Observation' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab',
                     'DiagnosticReport' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-lab' },
      '28650-0' => { 'DocumentReference' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-documentreference',
                     'DiagnosticReport' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-note' },
      '18776-5' => {
        'MedicationRequest' => 'http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-cancer-related-medication-request', 'Medication' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-medication', 'ServiceRequest' => 'http://hl7.org/fhir/StructureDefinition/ServiceRequest', 'CarePlan' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-careplan'
      }
    }.freeze

    FIELD_TO_URL_MAP = {
      'subject' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient',
      'encounter' => 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter',
      'author' => ['http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitionerrole',
                   'http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitioner', 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-organization']
    }.freeze

    # Method for translating received bundle into a hash of resources.  Use for MS and Validation testing
    def parse_bundle(bundle, index)
      first_resource = bundle.entry.first.resource
      if first_resource.is_a?(FHIR::Composition)
        parsed_bundle = look_for_references_in_resource(first_resource, bundle)
        parsed_bundle['http://hl7.org/fhir/us/central-cancer-registry-reporting/StructureDefinition/ccrr-content-bundle'] ||= []
        parsed_bundle['http://hl7.org/fhir/us/central-cancer-registry-reporting/StructureDefinition/ccrr-content-bundle'].push(bundle)
        parsed_bundle['http://hl7.org/fhir/us/central-cancer-registry-reporting/StructureDefinition/ccrr-composition'] ||= []
        parsed_bundle['http://hl7.org/fhir/us/central-cancer-registry-reporting/StructureDefinition/ccrr-composition'].push(first_resource)
        unless unresolved_references.empty?
          warning "The following references did not resolve, the resources either do not exist in the bundle or are mislabeled: #{unresolved_references}"
        end
        current_bundle_unresolved_references = unresolved_references
        clear_unresolved_references
        [parsed_bundle, current_bundle_unresolved_references]
      else
        add_message('error', "Unable to parse bundle #{index + 1}: " \
                             "the first entry must be a Composition but got #{first_resource.resourceType}.")
        [nil, nil]
      end
    end

    # Helpers
    def look_for_references_in_resource(resource, bundle)
      resource_hash = {}
      resource.to_hash.each_key do |key|
        value = resource&.send(key.to_sym)
        if value.is_a?(FHIR::Reference)
          resource_hash[FIELD_TO_URL_MAP[key]] ||= []
          referenced_resource = find_resource_in_bundle(value.reference, bundle)
          unresolved_references << value.reference unless referenced_resource
          if !resource_hash[FIELD_TO_URL_MAP[key]].include?(referenced_resource) && referenced_resource
            resource_hash[FIELD_TO_URL_MAP[key]] << referenced_resource
          end
        elsif value.is_a?(Array) && value.all? { |elmt| elmt.is_a?(FHIR::Composition::Section) }
          resource_hash.merge!(parse_sections(value, bundle))
        elsif value.is_a?(Array) && value.all? { |elmt| elmt.is_a?(FHIR::Reference) }
          resource_hash[FIELD_TO_URL_MAP[key]] ||= []
          value.each do |val|
            referenced_resource = find_resource_in_bundle(val.reference, bundle)
            unresolved_references << val.reference unless referenced_resource
            if !resource_hash[FIELD_TO_URL_MAP[key]].include?(referenced_resource) && referenced_resource
              resource_hash[FIELD_TO_URL_MAP[key]] << referenced_resource
            end
          end
        elsif value.is_a?(FHIR::Model)
          resource_hash.merge!(look_for_references_in_resource(value, bundle))
        elsif value.is_a?(Array) && value.all? { |elmt| elmt.is_a?(FHIR::Model) }
          value.each { |val| resource_hash.merge!(look_for_references_in_resource(val, bundle)) }
        end
      end
      resource_hash.reject { |_k, v| v.nil? || v&.empty? }
    end

    def parse_sections(sections, bundle)
      sections.each_with_object({}) do |sec, hash|
        code = sec.code.coding.first.code
        if multiple_reference_types?(code)
          sec.entry.each do |ref|
            referenced_resource = find_resource_in_bundle(ref.reference, bundle)
            if referenced_resource
              profile_url = profile_url_from_meta(referenced_resource) ||
                            profile_from_resource_type(code, referenced_resource.resourceType)

              hash[profile_url] ||= []
              unless hash[profile_url].include?(referenced_resource)
                hash[profile_url] << referenced_resource
              end
            else
              unresolved_references << ref.reference
            end
          end
        else
          sec.entry.each do |ref|
            referenced_resource = find_resource_in_bundle(ref.reference, bundle)
            unresolved_references << ref.reference unless referenced_resource
            next unless referenced_resource

            resource_key = profile_url_from_meta(referenced_resource) || CODE_TO_URL_MAP[code]
            hash[resource_key] ||= []
            hash[resource_key] << referenced_resource unless hash[resource_key].include?(referenced_resource)
          end
        end
      end
    end

    def multiple_reference_types?(code)
      CODE_TO_MULTIPLE_ENTRY_RESOURCE_MAP.keys.include?(code)
    end

    def profile_from_resource_type(code, resource_type)
      CODE_TO_MULTIPLE_ENTRY_RESOURCE_MAP[code][resource_type]
    end

    def profile_url_from_meta(resource)
      profiles = Array(resource&.meta&.profile)
      supported = CancerRegistryReportingTestKit::HdeaGenerator::Naming::PROFILE_TO_RESOURCE_KEY_MAP.keys

      candidates = profiles.filter_map do |profile_url|
        base_url = profile_url.to_s.split('|').first
        base_url if supported.include?(base_url)
      end

      candidates.find { |url| !url.start_with?('http://hl7.org/fhir/StructureDefinition/') } || candidates.first
    end

    ## TODO: we may have to be more comprehensive with checks for references - TBD
    def find_resource_in_bundle(reference, bundle)
      bundle.entry.find do |res|
        res.resource.id == reference.split('/').last && res.resource.resourceType == reference.split('/').first
      end&.resource
    end
  end
end
