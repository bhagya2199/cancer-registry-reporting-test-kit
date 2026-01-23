# Central Cancer Registry Reporting      
      
The Central Cancer Registry Reporting (CCRR) Test Kit is a testing tool for Health IT systems
seeking to meet the requirements of the STU 1.0.0 version of the HL7® FHIR®
[Central Cancer Registry Reporting IG](https://build.fhir.org/ig/HL7/fhir-central-cancer-registry-reporting-ig/index).


This test kit currently contains suites that verify the conformance of systems playing the following roles:
- **Health Data Exchange App (HDEA) Report Generator**: Verifies that the Health IT system can generate
  conformant and complete reports to send to a cancer registry. The report content tests validate Bundles
  against the CCRR IG 2.0.0-ballot, which in turn references US Core 6.1.0 and mCODE 4.0.0 profiles.
- **Electronic Health Record (EHR) Data Source**: Verifies that the Health IT system can respond to queries
  for the data needed to create a cancer registry report in alignment with the CCRR IG 2.0.0-ballot EHR
  requirements, including US Core 6.1.0 and mCODE 4.0.0 where referenced by that specification.

## Status

These tests are a **DRAFT** intended to allow CCRR IG implementers to
perform preliminary checks of their implementations against the IG's requirements and provide feedback
on the tests. Future versions of these tests may validate other requirements and may change how these
are tested.

## Known Limitations

This test kit does not currently include test suites for all actors and all capabilities defined by the CCRR IG.
Out of scope areas of the IG include the Cancer Registry and Trusted Third Party actors and details related to the use of the
[MedMorph framework](https://hl7.org/fhir/us/medmorph/STU1/) by all actors to coordinate reporting triggering,
report content, and report delivery requirements.

The existing HDEA and EHR suites focus on report content and do not currently test most details of
the report exchange workflow. The following areas are not tested:
- EHR requirements around authentication and authorization and the use of Subscriptions to provide
  notifications to HDEAs.
- HDEA requirements around the gathering of report contents from EHRs and the delivery of completed reports
  using FHIR APIs.

For additional details on suite-specific limitations, see the suite documention in the running tests or the
corresponding content in the source repository ([EHR suite limitations](https://github.com/inferno-framework/cancer-registry-reporting-test-kit/blob/main/lib/cancer_registry_reporting_test_kit/docs/ehr_suite_description.md#current-limitations),
[HDEA suite limitations](https://github.com/inferno-framework/cancer-registry-reporting-test-kit/blob/main/lib/cancer_registry_reporting_test_kit/docs/hdea_suite_description.md#current-limitations))

## Repository and Resources

The Central Cancer Registry Reporting Test Kit can be [downloaded](https://github.com/inferno-framework/cancer-registry-reporting-test-kit/releases)
from its [GitHub repository](https://github.com/inferno-framework/cancer-registry-reporting-test-kit).

## Providing Feedback and Reporting Issues

We welcome feedback on the tests, including but not limited to the following areas:
- Validation logic, such as potential bugs, lax checks, and unexpected failures.
- Requirements coverage, such as requirements that have been missed, tests that necessitate features that the
  IG does not require, or other issues with the interpretation of the IG’s requirements.
- User experience, such as confusing or missing information in the test UI.

Please report any issues with this set of tests in the [issues section](https://github.com/inferno-framework/cancer-registry-reporting-test-kit/issues)
      of the repository.

## Inferno Documentation
- [Inferno documentation](https://inferno-framework.github.io/docs/)
- [Ruby API documentation](https://inferno-framework.github.io/inferno-core/docs/)
- [JSON API documentation](https://inferno-framework.github.io/inferno-core/api-docs/)

## License
Copyright 2024 TODO

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License. You may obtain a copy of the
License at
```
http://www.apache.org/licenses/LICENSE-2.0
```
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.

## Trademark Notice

HL7, FHIR and the FHIR [FLAME DESIGN] are the registered trademarks of Health
Level Seven International and their use does not constitute endorsement by HL7.
