# frozen_string_literal: true

require_relative 'generated/v1.0.0/ccrr_content_bundle/ccrr_content_bundle_must_support_test'
require_relative 'ccrr_content_bundle_parse_and_validation_test'
require_relative 'generated/v1.0.0/composition/composition_validation_test'
require_relative 'generated/v1.0.0/composition/composition_must_support_test'

require_relative 'author/author_validation_test'
require_relative 'generated/v1.0.0/allergy_intolerance/allergy_intolerance_validation_test'
require_relative 'generated/v1.0.0/care_plan/care_plan_validation_test'
require_relative 'generated/v1.0.0/central_cancer_registry_primary_cancer_condition/central_cancer_registry_primary_cancer_condition_validation_test'
require_relative 'generated/v1.0.0/condition/condition_validation_test'
require_relative 'generated/v1.0.0/diagnostic_report_lab/diagnostic_report_lab_validation_test'
require_relative 'generated/v1.0.0/diagnostic_report_note/diagnostic_report_note_validation_test'
require_relative 'generated/v1.0.0/document_reference/document_reference_validation_test'
require_relative 'generated/v1.0.0/encounter/encounter_validation_test'
require_relative 'generated/v1.0.0/mcode_radiotherapy_course_summary/mcode_radiotherapy_course_summary_validation_test'
require_relative 'generated/v1.0.0/mcode_secondary_cancer_condition/mcode_secondary_cancer_condition_validation_test'
require_relative 'generated/v1.0.0/mcode_tnm_stage_group/mcode_tnm_stage_group_validation_test'
require_relative 'generated/v1.0.0/medication/medication_validation_test'
require_relative 'generated/v1.0.0/medication_administration/medication_administration_validation_test'
require_relative 'generated/v1.0.0/medication_request/medication_request_validation_test'
require_relative 'generated/v1.0.0/medication_statement/medication_statement_validation_test'
require_relative 'generated/v1.0.0/observation/observation_validation_test'
require_relative 'generated/v1.0.0/observation_lab/observation_lab_validation_test'
require_relative 'generated/v1.0.0/odh_usual_work/odh_usual_work_validation_test'
require_relative 'generated/v1.0.0/patient/patient_validation_test'
require_relative 'generated/v1.0.0/procedure/procedure_validation_test'
require_relative 'generated/v1.0.0/service_request/service_request_validation_test'
require_relative 'generated/v1.0.0/smokingstatus/smokingstatus_validation_test'

require_relative 'author/organization_must_support_test'
require_relative 'author/practitioner_must_support_test'
require_relative 'author/practitioner_role_must_support_test'
require_relative 'generated/v1.0.0/allergy_intolerance/allergy_intolerance_must_support_test'
require_relative 'generated/v1.0.0/care_plan/care_plan_must_support_test'
require_relative 'generated/v1.0.0/central_cancer_registry_primary_cancer_condition/central_cancer_registry_primary_cancer_condition_must_support_test' # rubocop:disable Layout/LineLength
require_relative 'generated/v1.0.0/condition/condition_must_support_test'
require_relative 'generated/v1.0.0/diagnostic_report_lab/diagnostic_report_lab_must_support_test'
require_relative 'generated/v1.0.0/diagnostic_report_note/diagnostic_report_note_must_support_test'
require_relative 'generated/v1.0.0/document_reference/document_reference_must_support_test'
require_relative 'generated/v1.0.0/encounter/encounter_must_support_test'
require_relative 'generated/v1.0.0/mcode_radiotherapy_course_summary/mcode_radiotherapy_course_summary_must_support_test'
require_relative 'generated/v1.0.0/mcode_secondary_cancer_condition/mcode_secondary_cancer_condition_must_support_test'
require_relative 'generated/v1.0.0/mcode_tnm_stage_group/mcode_tnm_stage_group_must_support_test'
require_relative 'generated/v1.0.0/medication/medication_must_support_test'
require_relative 'generated/v1.0.0/medication_administration/medication_administration_must_support_test'
require_relative 'generated/v1.0.0/medication_request/medication_request_must_support_test'
require_relative 'generated/v1.0.0/medication_statement/medication_statement_must_support_test'
require_relative 'generated/v1.0.0/observation/observation_must_support_test'
require_relative 'generated/v1.0.0/observation_lab/observation_lab_must_support_test'
require_relative 'generated/v1.0.0/odh_usual_work/odh_usual_work_must_support_test'
require_relative 'generated/v1.0.0/patient/patient_must_support_test'
require_relative 'generated/v1.0.0/procedure/procedure_must_support_test'
require_relative 'generated/v1.0.0/service_request/service_request_must_support_test'
require_relative 'generated/v1.0.0/smokingstatus/smokingstatus_must_support_test'

module CancerRegistryReportingTestKit
  class ReportValidationTestsGroup < Inferno::TestGroup
    title 'Cancer Registry Report Content'
    short_description 'Verify report generation requirements are met.'
    description %(
      # Background

      These tests verify that the system under test can generate conformant and complete cancer reports
      following the requirements in the [Central Cancer Registry Reporting Content Bundle profile](https://hl7.org/fhir/us/central-cancer-registry-reporting/STU1/StructureDefinition-ccrr-content-bundle.html).
      The tester will provide a list of Bundles generated by the system under test in the **Cancer Reports** input.
      Inferno will verify the conformance of each report and that the set of reports contains examples
      of all sections and each element that the Bundle profile and referenced profiles indicate must be supported.

      # Testing Methodology
      The provided Bundles are parsed and the individual resources within them are separated out
      and assigned a target profile based on the section within the Composition in which they appear.
      Bundles without Composition instances in the first entry will cause the tests to fail and
      will not be analyzed.

      ## Profile Validation
      Each resource extracted from the bundles is expected to conform to
      its target profile. Each element in each resource is checked against
      teminology binding and cardinality requirements by the HL7 FHIR validator.

      ## Must Support
      Must Support tests in this group check that each element of the target profile marked
      as "must support" is observed at least once across instances assigned to that profile.
      If one or more elements are not observed, the test will fail.
    )

    verifies_requirements 'hl7.fhir.us.central-cancer-registry-reporting_1.0.0@68',
                          'hl7.fhir.us.central-cancer-registry-reporting_1.0.0@102'

    id :ccrr_report_resources
    run_as_group

    group do
      title 'Report'
      test from: :ccrr_v100_ccrr_content_bundle_parse_and_validation_test
      test from: :ccrr_v100_ccrr_content_bundle_must_support_test
      test from: :ccrr_v100_composition_validation_test
      test from: :ccrr_v100_composition_must_support_test
    end

    group do
      title 'Referenced Patient'
      test from: :ccrr_v200_patient_validation_test
      test from: :ccrr_v200_patient_must_support_test
    end

    group do
      title 'Referenced Encounter'
      test from: :ccrr_v100_encounter_validation_test
      test from: :ccrr_v100_encounter_must_support_test
    end

    group do
      title 'Referenced Author'
      test from: :ccrr_v100_author_validation_test
      test from: :ccrr_v100_organization_must_support_test
      test from: :ccrr_v100_practitioner_must_support_test
      test from: :ccrr_v100_practitioner_role_must_support_test
    end

    group do
      title 'Primary Cancer Condition Section'
      test from: :ccrr_v100_central_cancer_registry_primary_cancer_condition_validation_test
      test from: :ccrr_v100_central_cancer_registry_primary_cancer_condition_must_support_test
    end

    group do
      title 'Secondary Cancer Condition Section'
      test from: :ccrr_v100_mcode_secondary_cancer_condition_validation_test
      test from: :ccrr_v100_mcode_secondary_cancer_condition_must_support_test
    end

    group do
      title 'Cancer Stage Group Section'
      test from: :ccrr_v100_mcode_tnm_stage_group_validation_test
      test from: :ccrr_v100_mcode_tnm_stage_group_must_support_test
    end

    group do
      title 'Radiotherapy Course Summary Section'
      test from: :ccrr_v100_mcode_radiotherapy_course_summary_validation_test
      test from: :ccrr_v100_mcode_radiotherapy_course_summary_must_support_test
    end

    group do
      title 'Problems Section'
      test from: :ccrr_v100_condition_validation_test
      test from: :ccrr_v100_condition_must_support_test
    end

    group do
      title 'Allergies Section'
      test from: :ccrr_v100_allergy_intolerance_validation_test
      test from: :ccrr_v100_allergy_intolerance_must_support_test
    end

    group do
      title 'Medications Administered and Medications Sections'
      test from: :ccrr_v100_medication_administration_validation_test
      test from: :ccrr_v100_medication_administration_must_support_test
      test from: :ccrr_v100_medication_statement_validation_test
      test from: :ccrr_v100_medication_statement_must_support_test
      test from: :ccrr_v100_medication_validation_test
      test from: :ccrr_v100_medication_must_support_test
    end

    group do
      title 'Occupational Data Section'
      test from: :ccrr_v100_odh_usual_work_validation_test
      test from: :ccrr_v100_odh_usual_work_must_support_test
    end

    group do
      title 'Results Section'
      test from: :ccrr_v100_observation_lab_validation_test
      test from: :ccrr_v100_observation_lab_must_support_test
      test from: :ccrr_v100_diagnostic_report_lab_validation_test
      test from: :ccrr_v100_diagnostic_report_lab_must_support_test
    end

    group do
      title 'Notes Section'
      test from: :ccrr_v100_document_reference_validation_test
      test from: :ccrr_v100_document_reference_must_support_test
      test from: :ccrr_v100_diagnostic_report_note_validation_test
      test from: :ccrr_v100_diagnostic_report_note_must_support_test
    end

    group do
      title 'Plan of Treatment Section'
      test from: :ccrr_v100_medication_request_validation_test
      test from: :ccrr_v100_medication_request_must_support_test
      test from: :ccrr_v100_service_request_validation_test
      test from: :ccrr_v100_service_request_must_support_test
      test from: :ccrr_v100_care_plan_validation_test
      test from: :ccrr_v100_care_plan_must_support_test
      test from: :ccrr_v100_procedure_validation_test
      test from: :ccrr_v100_procedure_must_support_test
    end

    group do
      title 'Vital Signs Section'
      test from: :ccrr_v100_observation_validation_test
      test from: :ccrr_v100_observation_must_support_test
    end
    group do
      title 'Social History Section'
      test from: :ccrr_v100_smokingstatus_validation_test
      test from: :ccrr_v100_smokingstatus_must_support_test
    end
  end
end
