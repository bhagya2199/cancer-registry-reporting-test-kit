# frozen_string_literal: true

module CancerRegistryReportingTestKit
  class HdeaGenerator
    module Naming
      USCORE_ALLERGY_INTOLERANCE = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-allergyintolerance'
      USCORE_CARE_PLAN = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-careplan'
      USCORE_CARE_TEAM = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-careteam'
      USCORE_CONDITION = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition'
      USCORE_CONDITION_ENCOUNTER_DIAGNOSIS =
        'http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition-encounter-diagnosis'
      USCORE_IMPLANTABLE_DEVICE = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-implantable-device'
      USCORE_DIAGNOSTIC_REPORT_NOTE = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-note'
      USCORE_DIAGNOSTIC_REPORT_LAB = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-lab'
      USCORE_DOCUMENT_REFERENCE = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-documentreference'
      USCORE_ENCOUNTER = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter'
      USCORE_GOAL = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-goal'
      USCORE_IMMUNIZATION = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-immunization'
      USCORE_LOCATION = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-location'
      USCORE_MEDICATION = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-medication'
      MCODE_MEDICATION_REQUEST = 'http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-cancer-related-medication-request'
      USCORE_SMOKINGSTATUS = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-smokingstatus'
      USCORE_PEDIATRIC_WEIGHT_FOR_HEIGHT = 'http://hl7.org/fhir/us/core/StructureDefinition/pediatric-weight-for-height'
      USCORE_OBSERVATION_LAB = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab'
      USCORE_PEDIATRIC_BMI_FOR_AGE = 'http://hl7.org/fhir/us/core/StructureDefinition/pediatric-bmi-for-age'
      USCORE_PULSE_OXIMETRY = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-pulse-oximetry'
      USCORE_HEAD_CIRCUMFERENCE = 'http://hl7.org/fhir/us/core/StructureDefinition/head-occipital-frontal-circumference-percentile'
      USCORE_ORGANIZATION = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-organization'
      USCORE_PATIENT = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient'
      USCORE_PRACTITIONER = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitioner'
      USCORE_PRACTITIONER_ROLE = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitionerrole'
      USCORE_PROCEDURE = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-procedure'
      USCORE_PROVENANCE = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-provenance'
      BASE_SERVICE_REQUEST = 'http://hl7.org/fhir/StructureDefinition/ServiceRequest'
      BASE_MEDICATION_STATEMENT = 'http://hl7.org/fhir/StructureDefinition/MedicationStatement'

      US_PATHOLOGY_DIAGNOSTIC_REPORT =
        'http://hl7.org/fhir/us/cancer-reporting/StructureDefinition/us-pathology-diagnostic-report'

      ## FOR HDEA
      CCRR_COMPOSITION = 'http://hl7.org/fhir/us/central-cancer-registry-reporting/StructureDefinition/ccrr-composition'
      CCRR_CONTENT_BUNDLE = 'http://hl7.org/fhir/us/central-cancer-registry-reporting/StructureDefinition/ccrr-content-bundle'
      CCRR_PRIMARY_CONDITION = 'http://hl7.org/fhir/us/central-cancer-registry-reporting/StructureDefinition/central-cancer-registry-primary-cancer-condition'
      MCODE_SECONDARY_CANCER_CONDITION = 'http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-secondary-cancer-condition'
      MCODE_TNM_STAGE_GROUP = 'http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-tnm-stage-group'
      MCODE_RADIOTHERAPY_COURSE_SUMMARY = 'http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-course-summary'
      ODH_USUAL_WORK = 'http://hl7.org/fhir/us/odh/StructureDefinition/odh-UsualWork'
      BASE_OBSERVATION = 'http://hl7.org/fhir/StructureDefinition/Observation'
      MCODE_MEDICATION_ADMINISTRATION = 'http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-cancer-related-medication-administration'
      AUTHOR = ['http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitionerrole',
                'http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitioner', 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-organization'].freeze

      ## Unused Profiles
      CCRR_CANCER_ENCOUNTER = 'http://hl7.org/fhir/us/central-cancer-registry-reporting/StructureDefinition/cancer-encounter'
      CCRR_CANCER_PATIENT = 'http://hl7.org/fhir/us/central-cancer-registry-reporting/StructureDefinition/cancer-patient'
      CCRR_PUBLIC_HEALTH_PATIENT = 'http://hl7.org/fhir/us/central-cancer-registry-reporting/StructureDefinition/us-ph-patient'
      CCRR_REPORTING_BUNDLE = 'http://hl7.org/fhir/us/central-cancer-registry-reporting/StructureDefinition/ccrr-reporting-bundle'
      CCRR_MESSAGE_HEADER = 'http://hl7.org/fhir/us/central-cancer-registry-reporting/StructureDefinition/central-cancer-registry-reporting-messageheader'
      CCRR_PLAN_DEFINITION = 'http://hl7.org/fhir/us/central-cancer-registry-reporting/StructureDefinition/ccrr-plandefinition'

      IG_LINKS = {
        'v3.1.1' => 'http://hl7.org/fhir/us/core/STU3.1.1',
        'v4.0.0' => 'http://hl7.org/fhir/us/core/STU4',
        'v5.0.1' => 'http://hl7.org/fhir/us/core/STU5.0.1',
        'v6.1.0' => 'http://hl7.org/fhir/us/core/STU6.1',
        'v7.0.0' => 'http://hl7.org/fhir/us/core/STU7'
      }.freeze

      PROFILE_URL_TO_SECTION_NAME_MAP = {
        USCORE_PATIENT => '`patient` element',
        USCORE_ENCOUNTER => '`encounter` element',
        USCORE_PRACTITIONER => '`author` element',
        USCORE_PRACTITIONER_ROLE => '`author` element',
        USCORE_ORGANIZATION => '`author` element',
        CCRR_PRIMARY_CONDITION => 'Primary Cancer Condition section',
        MCODE_SECONDARY_CANCER_CONDITION => 'Secondary Cancer Condition section',
        MCODE_TNM_STAGE_GROUP => 'Cancer Stage Group section',
        MCODE_RADIOTHERAPY_COURSE_SUMMARY => 'Radiotherapy Course Summary section',
        USCORE_CONDITION => 'Problems section',
        USCORE_CONDITION_ENCOUNTER_DIAGNOSIS => 'Encounter Diagnosis section',
        USCORE_ALLERGY_INTOLERANCE => 'Allergies section',
        MCODE_MEDICATION_ADMINISTRATION => 'Medications and Medications Administered sections',
        USCORE_MEDICATION => 'Medications and Medications Administered sections',
        BASE_MEDICATION_STATEMENT => 'Medications and Medications Administered sections',
        ODH_USUAL_WORK => 'Occupational Data section',
        USCORE_OBSERVATION_LAB => 'Results section',
        USCORE_DIAGNOSTIC_REPORT_LAB => 'Results section',
        USCORE_DIAGNOSTIC_REPORT_NOTE => 'Notes section',
        USCORE_DOCUMENT_REFERENCE => 'Notes section',
        MCODE_MEDICATION_REQUEST => 'Plan of Treatment section',
        BASE_SERVICE_REQUEST => 'Plan of Treatment section',
        USCORE_CARE_PLAN => 'Plan of Treatment section',
        USCORE_PROCEDURE => 'Procedures section',
        BASE_OBSERVATION => 'Vital Signs section',
        USCORE_SMOKINGSTATUS => 'Social History section'
      }

    PROFILE_TO_RESOURCE_KEY_MAP = {
      USCORE_ALLERGY_INTOLERANCE => :allergy_intolerance_resources,
      USCORE_CARE_PLAN => :care_plan_resources,
      CCRR_PRIMARY_CONDITION => :central_cancer_registry_primary_cancer_condition_resources,
      USCORE_DOCUMENT_REFERENCE => :document_reference_resources,
      USCORE_ENCOUNTER => :encounter_resources,
      MCODE_RADIOTHERAPY_COURSE_SUMMARY => :mcode_radiotherapy_course_summary_resources,
      MCODE_SECONDARY_CANCER_CONDITION => :mcode_secondary_cancer_condition_resources,
      MCODE_TNM_STAGE_GROUP => :mcode_tnm_stage_group_resources,
      MCODE_MEDICATION_ADMINISTRATION => :medication_administration_resources,
      USCORE_MEDICATION => :medication_resources,
      ODH_USUAL_WORK => :odh_usual_work_resources,
      USCORE_ORGANIZATION => :organization_resources,
      USCORE_PATIENT => :patient_resources,
      USCORE_PRACTITIONER_ROLE => :practitioner_role_resources,
      USCORE_PRACTITIONER => :practitioner_resources,
      USCORE_PROCEDURE => :procedure_resources,
      USCORE_SMOKINGSTATUS => :smokingstatus_resources,
      BASE_SERVICE_REQUEST => :service_request_resources,
      USCORE_CONDITION => :condition_resources,
      USCORE_CONDITION_ENCOUNTER_DIAGNOSIS => :condition_encounter_diagnosis_resources,
      BASE_MEDICATION_STATEMENT => :medication_statement_resources,
      USCORE_OBSERVATION_LAB => :observation_lab_resources,
      USCORE_DIAGNOSTIC_REPORT_NOTE => :diagnostic_report_note_resources,
      USCORE_DIAGNOSTIC_REPORT_LAB => :diagnostic_report_lab_resources,
      US_PATHOLOGY_DIAGNOSTIC_REPORT => :us_pathology_diagnostic_report_resources,
      CCRR_COMPOSITION => :composition_resources,
      MCODE_MEDICATION_REQUEST => :medication_request_resources,
      BASE_OBSERVATION => :observation_resources,
      CCRR_CONTENT_BUNDLE => :ccrr_content_bundle_resources
    }.freeze

      class << self
        def section_for_profile_url(profile_url)
          PROFILE_URL_TO_SECTION_NAME_MAP[profile_url]
        end
        
        def resources_with_multiple_profiles
          # ['Condition', 'DiagnosticReport', 'Observation']
          %w[Patient Encounter Bundle Observation DiagnosticReport Condition Procedure]
        end

        def resource_has_multiple_profiles?(resource)
          resources_with_multiple_profiles.include? resource
        end

        def snake_case_for_profile(group_metadata)
          resource = group_metadata.resource
          return resource.underscore unless resource_has_multiple_profiles?(resource)

          if group_metadata.profile_url == USCORE_HEAD_CIRCUMFERENCE
            return group_metadata.reformatted_version == 'v311' ? 'head_circumference' : 'head_circumference_percentile'
          end

          group_metadata.name
            .delete_prefix('us_core_')
            .gsub('diagnosticreport', 'diagnostic_report')
            .underscore
        end

        ## HDEA QUICK PATCH
        def snake_case_for_url(url)
          # special case for author
          return 'author_resources' if url.is_a?(Array)

          PROFILE_TO_RESOURCE_KEY_MAP[url]
        end

        def upper_camel_case_for_profile(group_metadata)
          snake_case_for_profile(group_metadata).camelize
        end

        def ig_link(version)
          IG_LINKS[version]
        end
      end
    end
  end
end
