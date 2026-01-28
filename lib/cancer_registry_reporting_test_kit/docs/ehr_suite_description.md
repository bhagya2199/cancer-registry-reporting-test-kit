## Overview

The Cancer Registry Reporting EHR Test Suite verifies the
conformance of EHRs to the STU 1.0.0 version of the HL7® FHIR®
[Central Cancer Registry Reporting IG](https://hl7.org/fhir/us/central-cancer-registry-reporting/STU1/).

## Scope

The primary role of an EHR in the Central Cancer Registry Reporting IG workflow is to

> support the APIs as outlined in the [EHR Capability Statement](https://hl7.org/fhir/us/central-cancer-registry-reporting/STU1/CapabilityStatement-central-cancer-registry-reporting-ehr.html)
> for the HDEA [(Health Data Exchange App)] to access patient data.

The requesting HDEA then uses that data to create a report for submission to a cancer registry.

These tests support that role by verifying that the EHR can support the specified
APIs and serve up the data needed to create [central cancer registry reports](https://hl7.org/fhir/us/central-cancer-registry-reporting/STU1/StructureDefinition-ccrr-content-bundle.html)
that contain the full scope of must support profiles and elements.
Per the [EHR Capability Statement](https://hl7.org/fhir/us/central-cancer-registry-reporting/STU1/CapabilityStatement-central-cancer-registry-reporting-ehr.html), this includes FHIR read and search APIs for:
- US Core STU 6.1.0 profiles indicated in the [Server CapabilityStatement](https://hl7.org/fhir/us/core/STU6.1/CapabilityStatement-us-core-server.html)
- A subset of mCODE profiles, including
  - [mCODE Primary Cancer Condition Profile](http://hl7.org/fhir/us/mcode/STU3/StructureDefinition-mcode-primary-cancer-condition.html)
  - [mCODE Secondary Cancer Condition Profile](http://hl7.org/fhir/us/mcode/STU3/StructureDefinition-mcode-secondary-cancer-condition.html)
  - [mCODE Cancer Stage Group Profile](http://hl7.org/fhir/us/mcode/STU3/StructureDefinition-mcode-tnm-stage-group.html)
  - [mCODE TNM Distant Metastases Category Profile](http://hl7.org/fhir/us/mcode/STU3/StructureDefinition-mcode-tnm-distant-metastases-category.html)
  - [mCODE TNM Primary Tumor Category Profile](http://hl7.org/fhir/us/mcode/STU3/StructureDefinition-mcode-tnm-primary-tumor-category.html)
  - [mCODE TNM Regional Nodes Category Profile](http://hl7.org/fhir/us/mcode/STU3/StructureDefinition-mcode-tnm-regional-nodes-category.html)
  - [mCODE Cancer-Related Medication Request Profile](http://hl7.org/fhir/us/mcode/STU3/StructureDefinition-mcode-cancer-related-medication-request.html)
  - [mCODE Cancer-Related Administration Request Profile](http://hl7.org/fhir/us/mcode/STU3/StructureDefinition-mcode-cancer-related-medication-administration.html)
  - [mCODE Radiotherapy Course Summary Profile](http://hl7.org/fhir/us/mcode/STU3/StructureDefinition-mcode-radiotherapy-course-summary.html)

## Test Methodology

Inferno will simulate a FHIR client using the search and read API required by the [EHR Capability Statement](https://hl7.org/fhir/us/central-cancer-registry-reporting/STU1/CapabilityStatement-central-cancer-registry-reporting-ehr.html).
Through a combination of tester input and details returned by the searches it makes, Inferno will
attempt to search for and read resources conforming to each profile. This includes:
- Testing required search parameter combinations and verifying that the results returned are appropriate.
- For each must support element, observing an instance with that element populated.
- For each must support reference element, verifying that a populated reference can be resolved.

## Running the tests 

### Quick Start

The minimal amount of information Inferno needs to run these tests includes the following inputs:
- **FHIR Endpoint**: URL of the EHR's FHIR endpoint.
- **OAuth Credentials / Access Token** (optional): If needed, a token that Inferno will include in the `Authorization`
  HTTP header in the form `Bearer <input value>` on each request it makes to the system under test
- **Patient IDs**: Comma separated list of patient IDs. Inferno will use these when building searches.

### Demonstration

If you would like to try out the tests using the [Inferno Reference Server](https://inferno.healthit.gov/reference-server) 
([code](https://github.com/inferno-framework/inferno-reference-server)) as the system under test,
use the "Inferno Reference Server" preset. Not all of the tests are expected to pass when run against the
Inferno Reference Server.

### Additional Input Details

Inferno needs tester input for the following profiles to assist in creating a search guaranteed to return
only instances that are intended to conform to the target profile. Inferno will use these values along
with the **Patient IDs** input to create search queries used by the tests. With the exception of the 
**Implantable Device Type Code** input, missing values will result in these inputs will cause the corresponding
tests to skip.
- [US Core Implantable Device Profile](https://hl7.org/fhir/us/core/STU6.1/StructureDefinition-us-core-implantable-device.html) (optional): a list of codes unqiue to this profile in input **Implantable Device Type Code**.
- [mCODE Primary Cancer Condition Profile](http://hl7.org/fhir/us/mcode/STU3/StructureDefinition-mcode-primary-cancer-condition.html): a `category` code unique to primary cancer conditions in input **Primary Cancer Condition category**, such as the one suggested in the mCODE query `GET [base]/Condition?category=http://snomed.info/sct|372087000`
- [mCODE Secondary Cancer Condition Profile](http://hl7.org/fhir/us/mcode/STU3/StructureDefinition-mcode-secondary-cancer-condition.html): a `category` code unique to primary cancer conditions in input **Secondary Cancer Condition category**, such as the one suggested in the mCODE query `GET [base]/Condition?category=http://snomed.info/sct|128462008`
- [mCODE TNM Distant Metastases Category Profile](http://hl7.org/fhir/us/mcode/STU3/StructureDefinition-mcode-tnm-distant-metastases-category.html): a `code` value unique to this profile in input **TNM Distant Metastases Category code**.
- [mCODE TNM Primary Tumor Category Profile](http://hl7.org/fhir/us/mcode/STU3/StructureDefinition-mcode-tnm-primary-tumor-category.html): a `code` value unique to this profile in input **TNM Primary Tumor Category code**.
- [mCODE TNM Regional Nodes Category Profile](http://hl7.org/fhir/us/mcode/STU3/StructureDefinition-mcode-tnm-regional-nodes-category.html): a `code` value unique to this profile in input **TNM Regional Nodes Category code**.
- [mCODE Cancer Stage Group Profile](http://hl7.org/fhir/us/mcode/STU3/StructureDefinition-mcode-tnm-stage-group.html): a `code` value unique to this profile in input **TNM Stage Group code**.

## Current Limitations

### HDEA Report generation and EHR data access differences

The CCRR IG includes several inconsistencies between its specification of EHR capabilities and HDEA
capabilities, including:
- The EHR Capability Statement points to the [US Core 6.1.0 Server Capability Statement](https://hl7.org/fhir/us/core/STU6.1/CapabilityStatement-us-core-server.html),
  while the [CCRR Composition](https://hl7.org/fhir/us/central-cancer-registry-reporting/STU1/StructureDefinition-ccrr-content-bundle.html)
  created by the HDEA uses [US Core 5.0.1](https://hl7.org/fhir/us/core/STU5.0.1/)
  profiles, except for Condition which uses the US Core 6.1.0 profile.
- The EHR Capability Statement requires support for US Core APIs on resource types that are not
  required to be in the [CCRR Composition](https://hl7.org/fhir/us/central-cancer-registry-reporting/STU1/StructureDefinition-ccrr-content-bundle.html),
  either through a direct reference or through a reference from a must support element, e.g., the
  US Core Immunization profile.
- The [CCRR Composition](https://hl7.org/fhir/us/central-cancer-registry-reporting/STU1/StructureDefinition-ccrr-content-bundle.html)
  requires support for profiles that are not supported within the API, such as the Occupational Data for Health (ODH) 
  [Usual Work profile](http://hl7.org/fhir/us/odh/STU1.1/StructureDefinition-odh-UsualWork.html)
  and the [Central Cancer Registry Reporting Primary Cancer Condition](https://hl7.org/fhir/us/central-cancer-registry-reporting/STU1/StructureDefinition-central-cancer-registry-primary-cancer-condition.html).

Currently this EHR suite and the HDEA suite test the requirements indicated in the IG despite the mismatch
and their potential to cause interoperability issues or extra implementation burden. Future versions of
the test kit may update this approach based on community feedback and IG updates.

### Instance gathering

For some of the profiles that EHRs must support, there is not a clear search that HDEAs can perform that
will be guaranteed to return all and only instances of interest for including in a cancer report that
also need to conform to the target profile. For example, the mCODE IG specifies
[certain queries](https://hl7.org/fhir/us/mcode/STU3/conformance-general.html#support-querying-mcode-conforming-resources)
that must be supported, e.g., `GET [base]/Observation?category=http://snomed.info/sct|385356007`
to retrieve all [Cancer Stage](https://hl7.org/fhir/us/mcode/STU3/StructureDefinition-mcode-cancer-stage.html)
instances. However, the corresponding profile data requirements don't always match, e.g., for 
[Cancer Stage](https://hl7.org/fhir/us/mcode/STU3/StructureDefinition-mcode-cancer-stage.html), the `category`
element is not required or must support within that profile and there is no mention of that specific
SNOMED code referenced in the search, which suggests that it may not be something servers choose to support.
This causes challenges for testing because if Inferno cannot perform a search for which the server will return
only instances conformant to the target profile or otherwise filter those results down to just instances that
are intended to conform to the target profile, then Inferno will not be able to determine which errors to treat
as fatal and display and which are simply an indication that the instances is not relevant to the test.

For that reason, Inferno requires testers to provide additional information that allows Inferno to construct a
query that will return only instances that are intended to conform to the target profile. Any HDEA working
with an EHR would need to be aware of such queries to allow them to gather the instances needed to create a
[central cancer registry reports](https://hl7.org/fhir/us/central-cancer-registry-reporting/STU1/StructureDefinition-ccrr-content-bundle.html)
and be confident of its completeness.

As this approach places additional constraints on tested systems beyond those present in the IG, future
versions of the test kit may update this approach or the requested details for each profile as details in
the IG are clarified.

### Limited authentication and authorization options

This test suite currently provides only one option for testers to adjust the requests that Inferno makes
so that the system under test can identify Inferno as the requestor. If the **Access Token** input is populated, 
the provided value will be placed in the HTTP `Authorization` header with the prefix `Bearer `.
Support for Inferno to obtain bearer tokens using SMART on FHIR workflows or other auth schemes may be added
in the future based on community feedback.

### mCODE reference resolution tests

This test suite includes must support reference element resolution tests for US Core profiles, but not for mCODE
profiles.