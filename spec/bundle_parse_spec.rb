# frozen_string_literal: true

require_relative 'fixtures/dummy_ms_test'
RSpec.describe CancerRegistryReportingTestKit::MustSupportTest, :runnable do
  before(:all) do
    SUITE_ID = 'ccrr_v100_report_generation'
    suite = Inferno::Repositories::TestSuites.new.find(SUITE_ID)
    suite.test.repository.insert(CancerRegistryReportingTestKit::HDEAV100::DummyMustSupportTest)
    suite.groups.first.test(from: :ccrr_v100_dummy_must_support_test)
  end

  let(:suite_id) { SUITE_ID }
  let(:test_scratch) { {} }
  let(:two_reports_second_no_composition) do
    File.read(File.join(__dir__, 'fixtures', 'two_reports_second_no_composition.txt'))
  end
  let(:operation_outcome_failure) do
    {
      outcomes: [{
        issues: [{
          level: 'ERROR',
          message: "Bundle/ccrr-content-bundle-examplexx: Bundle.entry[0]: The fullUrl 'http://hl7.org/fhir/us/central-cancer-registry-reporting/Composition/ccrr-composition-content-example' looks like a RESTful server URL, so it must end with the correct type and id (/Composition/ccrr-composition-content-examplex)"
        },
        {
          level: 'ERROR',
          message: "Bundle/ccrr-content-bundle-examplexx: Bundle.entry[0].resource.status: something bad in here"
        },
        {
          level: 'ERROR',
          message: "Bundle/ccrr-content-bundle-examplexx: Bundle.entry[5].resource/Encounter/patient: something bad in here"
        }
      ]
      }],
      sessionId: 'b8cf5547-1dc7-4714-a797-dc2347b93fe2'
    }
  end

  describe 'bundle_parse' do
    let(:dummy_must_support_test) { CancerRegistryReportingTestKit::HDEAV100::DummyMustSupportTest }
    let(:validation_test) do 
      Class.new(CancerRegistryReportingTestKit::HDEAV100::CcrrContentBundleParseAndValidationTest) do
        input :reports,
          type: 'textarea'    
          
        fhir_resource_validator do
          url ENV.fetch('FHIR_RESOURCE_VALIDATOR_URL')
  
          cli_context do
            txServer nil
            displayWarnings true
            disableDefaultResourceFetcher true
          end
  
          igs 'hl7.fhir.us.central-cancer-registry-reporting#2.0.0-ballot'
        end
      end
    end 
    let(:incomplete_bundle) do
      File.read(File.join(__dir__, 'fixtures', 'ccrr_hdea_content_bundle_example_incomplete.json'))
    end
    let(:complete_bundle) do
      File.read(File.join(__dir__, 'fixtures', 'ccrr_hdea_content_bundle_example_complete.json'))
    end
    let(:validation_ok_response) do
      File.read(File.join(__dir__, 'fixtures', 'validation_ok.json'))
    end

    it 'returns unresolved references if report contains any' do
      result = run(dummy_must_support_test, { input_bundle: incomplete_bundle })
      expect(result.result).to eq('fail')
      expect(result.result_message).to eq('Reference Missed: ["Observation/tnm-clinical-stage-group-jenny-m"]')
    end

    it 'reports no unresolved references if report does not contain any' do
      result = run(dummy_must_support_test, { input_bundle: complete_bundle })
      expect(result.result).to eq('pass')
    end

    it 'does not convolute missing references from different calls' do
      result = run(dummy_must_support_test, { input_bundle: incomplete_bundle })
      expect(result.result).to eq('fail')
      expect(result.result_message).to eq('Reference Missed: ["Observation/tnm-clinical-stage-group-jenny-m"]')

      result = run(dummy_must_support_test, { input_bundle: complete_bundle })
      expect(result.result).to eq('pass')
    end

    context 'within the validation test' do
      it 'stores all resources in scratch when given multiple input reports' do
        allow_any_instance_of(validation_test).to receive(:scratch).and_return(test_scratch)
        stub_request(:post, 'https://example.com/validatorapi/validate').to_return(status: 200,
                                                                                   body: validation_ok_response,
                                                                                   headers: { 'Content-Type' =>
                                                                                    'application/fhir+json' })
        run(validation_test, { reports: "#{incomplete_bundle},#{complete_bundle}" })
        patient_ids = test_scratch.dig(:patient_resources,:all)&.map(&:id)
        primary_condition_ids = test_scratch.dig(:central_cancer_registry_primary_cancer_condition_resources, :all)&.map(&:id)
        expect(patient_ids).to eq(%w[example-incomplete-Patient example-complete-Patient])
        expect(primary_condition_ids).to eq(%w[primary-cancer-condition-incomplete
                                               primary-cancer-condition-complete])
      end

      it 'stores author under the correct field' do
        allow_any_instance_of(validation_test).to receive(:scratch).and_return(test_scratch)
        stub_request(:post, 'https://example.com/validatorapi/validate').to_return(status: 200,
                                                                                   body: validation_ok_response,
                                                                                   headers: { 'Content-Type' =>
                                                                                    'application/fhir+json' })
        run(validation_test, { reports: "#{incomplete_bundle},#{complete_bundle}" })
        practitioner_ids = test_scratch.dig(:author_resources, :all)&.map(&:id)
        expect(practitioner_ids).to eq(%w[example-practitionerrole-incomplete example-practitioner-complete])
      end

      it 'stores all references if multiple entries' do
        allow_any_instance_of(validation_test).to receive(:scratch).and_return(test_scratch)
        stub_request(:post, 'https://example.com/validatorapi/validate').to_return(status: 200,
                                                                                   body: validation_ok_response,
                                                                                   headers:
                                                                                   { 'Content-Type' =>
                                                                                    'application/fhir+json' })
        run(validation_test, { reports: complete_bundle })
        medication_ids = test_scratch.dig(:medication_resources, :all)&.map(&:id)
        medication_administration_ids = test_scratch.dig(:medication_administration_resources, :all)&.map(&:id)
        expect(medication_ids).to eq(['uscore-med1'])
        expect(medication_administration_ids).to eq(['cancer-related-medication-admin-cyclophosphamide-jenny-m'])
      end

      it 'filters errors on entry resources' do
        allow_any_instance_of(validation_test).to receive(:scratch).and_return(test_scratch)
        stub_request(:post, 'https://example.com/validatorapi/validate').to_return(
          status: 200,
            body: operation_outcome_failure.to_json,
            headers: { 'Content-Type' =>
            'application/fhir+json' }
          )
        result = run(validation_test, { reports: complete_bundle })
        expect(result.result).to eq('fail')

        result_messages = Inferno::Repositories::Messages.new.messages_for_result(result.id)
        expect(result_messages.length).to be(1)
        expect(result_messages[0].message).to match(
          /Bundle\/ccrr-content-bundle-examplexx: Bundle.entry\[0\]: The fullUrl/
        )
      end

      it 'uses well-formed reports and logs errors for bad ones' do
        allow_any_instance_of(validation_test).to receive(:scratch).and_return(test_scratch)
        stub_request(:post, 'https://example.com/validatorapi/validate').to_return(
          status: 200,
            body: validation_ok_response,
            headers: { 'Content-Type' =>
            'application/fhir+json' }
          )
        result = run(validation_test, { reports: two_reports_second_no_composition })
        expect(result.result).to eq('fail')

        result_messages = Inferno::Repositories::Messages.new.messages_for_result(result.id)
        expect(result_messages.length).to be(1)
        expect(result_messages.find do |message|
          /Unable to parse bundle 2: the first entry must be a Composition/.match(message.message)
        end).to_not be_nil

        patient_ids = test_scratch.dig(:patient_resources,:all)&.map(&:id)
        expect(patient_ids).to_not be_nil
      end
    end
  end
end
