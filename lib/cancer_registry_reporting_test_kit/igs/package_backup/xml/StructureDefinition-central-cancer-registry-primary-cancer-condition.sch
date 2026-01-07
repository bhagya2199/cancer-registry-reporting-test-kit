<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <sch:ns prefix="f" uri="http://hl7.org/fhir"/>
  <sch:ns prefix="h" uri="http://www.w3.org/1999/xhtml"/>
  <!-- 
    This file contains just the constraints for the profile PrimaryCancerCondition
    It includes the base constraints for the resource as well.
    Because of the way that schematrons and containment work, 
    you may need to use this schematron fragment to build a, 
    single schematron that validates contained resources (if you have any) 
  -->
  <sch:pattern>
    <sch:title>f:Condition</sch:title>
    <sch:rule context="f:Condition">
      <sch:assert test="count(f:extension[@url = 'http://hl7.org/fhir/StructureDefinition/condition-assertedDate']) &gt;= 1">extension with URL = 'http://hl7.org/fhir/StructureDefinition/condition-assertedDate': minimum cardinality of 'extension' is 1</sch:assert>
      <sch:assert test="count(f:extension[@url = 'http://hl7.org/fhir/StructureDefinition/condition-assertedDate']) &lt;= 1">extension with URL = 'http://hl7.org/fhir/StructureDefinition/condition-assertedDate': maximum cardinality of 'extension' is 1</sch:assert>
      <sch:assert test="count(f:extension[@url = 'http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-histology-morphology-behavior']) &gt;= 1">extension with URL = 'http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-histology-morphology-behavior': minimum cardinality of 'extension' is 1</sch:assert>
      <sch:assert test="count(f:extension[@url = 'http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-histology-morphology-behavior']) &lt;= 1">extension with URL = 'http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-histology-morphology-behavior': maximum cardinality of 'extension' is 1</sch:assert>
      <sch:assert test="count(f:extension[@url = 'http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-cancer-disease-status-evidence-type']) &lt;= 1">extension with URL = 'http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-cancer-disease-status-evidence-type': maximum cardinality of 'extension' is 1</sch:assert>
      <sch:assert test="count(f:bodySite) &gt;= 1">bodySite: minimum cardinality of 'bodySite' is 1</sch:assert>
      <sch:assert test="count(f:bodySite) &lt;= 1">bodySite: maximum cardinality of 'bodySite' is 1</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern>
    <sch:title>f:Condition/f:bodySite</sch:title>
    <sch:rule context="f:Condition/f:bodySite">
      <sch:assert test="count(f:extension[@url = 'http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-laterality-qualifier']) &lt;= 1">extension with URL = 'http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-laterality-qualifier': maximum cardinality of 'extension' is 1</sch:assert>
      <sch:assert test="count(f:extension[@url = 'http://hl7.org/fhir/StructureDefinition/data-absent-reason']) &lt;= 1">extension with URL = 'http://hl7.org/fhir/StructureDefinition/data-absent-reason': maximum cardinality of 'extension' is 1</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
