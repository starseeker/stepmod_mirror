This directory contains files used to generate a package
for distribution to SC4 for balloting.

1) Add the modules to be balloted to ballot_index.xml

2) Generate the build file using ANT
   ant -buildfile buildbuild.xml

3) Run ANT on the build.xml that has just been created:
     ant all

   This will create a directory:
     stepmod/ballots/isohtml/plcs_bp1

4) Create a zip file of the ballot package.
    ant zip

   This will create a zip file:
     stepmod/ballots/isohtml/plcs_bp1/plcs_bp1xxxx.zip

NOTE
The dependent resources which must added to build.xml are:
      <property name="RESOURCESXML" value="data/resources/action_schema/action_schema.xml,data/resources/application_context_schema/application_context_schema.xml,data/resources/approval_schema/approval_schema.xml,data/resources/basic_attribute_schema/basic_attribute_schema.xml,data/resources/certification_schema/certification_schema.xml,data/resources/classification_schema/classification_schema.xml,data/resources/configuration_management_schema/configuration_management_schema.xml,data/resources/contract_schema/contract_schema.xml,data/resources/date_time_schema/date_time_schema.xml,data/resources/document_schema/document_schema.xml,data/resources/effectivity_schema/effectivity_schema.xml,data/resources/expression_extension_schema/expression_extension_schema.xml,data/resources/external_reference_schema/external_reference_schema.xml,data/resources/group_schema/group_schema.xml,data/resources/management_resources_schema/management_resources_schema.xml,data/resources/material_property_definition_schema/material_property_definition_schema.xml,data/resources/measure_schema/measure_schema.xml,data/resources/person_organization_schema/person_organization_schema.xml,data/resources/process_property_schema/process_property_schema.xml,data/resources/product_concept_schema/product_concept_schema.xml,data/resources/product_definition_schema/product_definition_schema.xml,data/resources/product_property_definition_schema/product_property_definition_schema.xml,data/resources/product_property_representation_schema/product_property_representation_schema.xml,data/resources/product_structure_schema/product_structure_schema.xml,data/resources/qualified_measure_schema/qualified_measure_schema.xml,data/resources/representation_schema/representation_schema.xml,data/resources/security_classification_schema/security_classification_schema.xml,data/resources/set_theory_schema/set_theory_schema.xml,data/resources/support_resource_schema/support_resource_schema.xml"/>

------------------------------------------------------------
To generate the express

1) run stepmod\utils\getExpress.wsf

   pass stepmod/ballots/ballots/plcs_bp1/modlist.txt as argument.

   This will create a directory of the express files of the modules listed
   in modlist.txt

------------------------------------------------------------
To validate the HTML

1) build plcs_bp1
 This will create isohtml/plcs_bp1

2) build plcs_depenent - the modules that PLCS is