
cd c:/Users/rbn/Documents/sforge/stepmod/utils

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "activity_as_realized"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/activity_as_realized clean_module
ant -emacs -q -DMODULES=data/modules/activity_as_realized modules
ant -emacs -q -DMODULES=data/modules/activity_as_realized mapping
ant -emacs -q -DMODULES=data/modules/activity_as_realized valid_modules
cscript //nologo checkModuleBatch.wsf activity_as_realized
echo "end: activity_as_realized"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo " analysis_assignment"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/analysis_assignment clean_module
ant -emacs -q -DMODULES=data/modules/analysis_assignment modules
ant -emacs -q -DMODULES=data/modules/analysis_assignment mapping
ant -emacs -q -DMODULES=data/modules/analysis_assignment valid_modules
cscript //nologo checkModuleBatch.wsf analysis_assignment 
echo "end: analysis_assignment"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "ap239_document_management"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/ap239_document_management clean_module
ant -emacs -q -DMODULES=data/modules/ap239_document_management modules
ant -emacs -q -DMODULES=data/modules/ap239_document_management mapping
ant -emacs -q -DMODULES=data/modules/ap239_document_management valid_modules
cscript //nologo checkModuleBatch.wsf ap239_document_management
echo "end: ap239_document_management"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "ap239_management_resource_information"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/ap239_management_resource_information clean_module
ant -emacs -q -DMODULES=data/modules/ap239_management_resource_information modules
ant -emacs -q -DMODULES=data/modules/ap239_management_resource_information mapping
ant -emacs -q -DMODULES=data/modules/ap239_management_resource_information valid_modules
cscript //nologo checkModuleBatch.wsf  ap239_management_resource_information
echo "end: ap239_management_resource_information"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "ap239_part_definition_information"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/ap239_part_definition_information clean_module
ant -emacs -q -DMODULES=data/modules/ap239_part_definition_information modules
ant -emacs -q -DMODULES=data/modules/ap239_part_definition_information mapping
ant -emacs -q -DMODULES=data/modules/ap239_part_definition_information valid_modules
cscript //nologo checkModuleBatch.wsf ap239_part_definition_information
echo "end: ap239_part_definition_information"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "ap239_product_definition_information"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/ap239_product_definition_information clean_module
ant -emacs -q -DMODULES=data/modules/ap239_product_definition_information modules
ant -emacs -q -DMODULES=data/modules/ap239_product_definition_information mapping
ant -emacs -q -DMODULES=data/modules/ap239_product_definition_information
cscript //nologo checkModuleBatch.wsf ap239_product_definition_information
echo "end: ap239_product_definition_information"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "ap239_product_life_cycle_support"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/ap239_product_life_cycle_support clean_module
ant -emacs -q -DMODULES=data/modules/ap239_product_life_cycle_support modules
ant -emacs -q -DMODULES=data/modules/ap239_product_life_cycle_support mapping
ant -emacs -q -DMODULES=data/modules/ap239_product_life_cycle_support valid_modules
cscript //nologo checkModuleBatch.wsf ap239_product_life_cycle_support
echo "end: ap239_product_life_cycle_support"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "ap239_task_specification_resourced"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/ap239_task_specification_resourced clean_module
ant -emacs -q -DMODULES=data/modules/ap239_task_specification_resourced modules
ant -emacs -q -DMODULES=data/modules/ap239_task_specification_resourced mapping
ant -emacs -q -DMODULES=data/modules/ap239_task_specification_resourced valid_modules
cscript //nologo checkModuleBatch.wsf ap23n9_task_specification_resourced
echo "end: ap239_task_specification_resourced"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "ap239_work_definition"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/ap239_work_definition clean_module
ant -emacs -q -DMODULES=data/modules/ap239_work_definition modules
ant -emacs -q -DMODULES=data/modules/ap239_work_definition mapping
ant -emacs -q -DMODULES=data/modules/ap239_work_definition valid_modules
cscript //nologo checkModuleBatch.wsf ap239_work_definition
echo "end: ap239_work_definition"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "approval"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/approval clean_module
ant -emacs -q -DMODULES=data/modules/approval modules
ant -emacs -q -DMODULES=data/modules/approval mapping
ant -emacs -q -DMODULES=data/modules/approval valid_modules
cscript //nologo checkModuleBatch.wsf approval
echo "end: approval"


echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "assembly_structure"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/assembly_structure clean_module
ant -emacs -q -DMODULES=data/modules/assembly_structure modules
ant -emacs -q -DMODULES=data/modules/assembly_structure mapping
ant -emacs -q -DMODULES=data/modules/assembly_structure valid_modules
cscript //nologo checkModuleBatch.wsf  assembly_structure
echo "end: assembly_structure"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "basic_geometry"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/basic_geometry clean_module
ant -emacs -q -DMODULES=data/modules/basic_geometry modules
ant -emacs -q -DMODULES=data/modules/basic_geometry mapping
ant -emacs -q -DMODULES=data/modules/basic_geometry valid_modules
cscript //nologo checkModuleBatch.wsf basic_geometry
echo "end: basic_geometry"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "collection_identification_and_version"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/collection_identification_and_version clean_module
ant -emacs -q -DMODULES=data/modules/collection_identification_and_version modules
ant -emacs -q -DMODULES=data/modules/collection_identification_and_version mapping
ant -emacs -q -DMODULES=data/modules/collection_identification_and_version valid_modules
cscript //nologo checkModuleBatch.wsf collection_identification_and_version
echo "end: collection_identification_and_version"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "conditional_effectivity"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/conditional_effectivity clean_module
ant -emacs -q -DMODULES=data/modules/conditional_effectivity modules
ant -emacs -q -DMODULES=data/modules/conditional_effectivity mapping
ant -emacs -q -DMODULES=data/modules/conditional_effectivity valid_modules
cscript //nologo checkModuleBatch.wsf conditional_effectivity
echo "end: conditional_effectivity"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "configuration_effectivity"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/configuration_effectivity clean_module
ant -emacs -q -DMODULES=data/modules/configuration_effectivity modules
ant -emacs -q -DMODULES=data/modules/configuration_effectivity mapping
ant -emacs -q -DMODULES=data/modules/configuration_effectivity valid_modules
cscript //nologo checkModuleBatch.wsf configuration_effectivity
echo "end: configuration_effectivity"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "configuration_item"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/configuration_item clean_module
ant -emacs -q -DMODULES=data/modules/configuration_item modules
ant -emacs -q -DMODULES=data/modules/configuration_item mapping
ant -emacs -q -DMODULES=data/modules/configuration_item valid_modules
cscript //nologo checkModuleBatch.wsf configuration_item
echo "end: configuration_item"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "contract"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/contract clean_module
ant -emacs -q -DMODULES=data/modules/contract modules
ant -emacs -q -DMODULES=data/modules/contract mapping
ant -emacs -q -DMODULES=data/modules/contract valid_modules
cscript //nologo checkModuleBatch.wsf contract
echo "end: contract"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "document_management"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/document_management clean_module
ant -emacs -q -DMODULES=data/modules/document_management modules
ant -emacs -q -DMODULES=data/modules/document_management mapping
ant -emacs -q -DMODULES=data/modules/document_management valid_modules
cscript //nologo checkModuleBatch.wsf document_management
echo "end: document_management"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "document_properties"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/document_properties clean_module
ant -emacs -q -DMODULES=data/modules/document_properties modules
ant -emacs -q -DMODULES=data/modules/document_properties mapping
ant -emacs -q -DMODULES=data/modules/document_properties valid_modules
cscript //nologo checkModuleBatch.wsf document_properties
echo "end: document_properties"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "identification_relationship"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/identification_relationship clean_module
ant -emacs -q -DMODULES=data/modules/identification_relationship modules
ant -emacs -q -DMODULES=data/modules/identification_relationship mapping
ant -emacs -q -DMODULES=data/modules/identification_relationship valid_modules
cscript //nologo checkModuleBatch.wsf identification_relationship
echo "end: identification_relationship"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "information_rights"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/information_rights clean_module
ant -emacs -q -DMODULES=data/modules/information_rights modules
ant -emacs -q -DMODULES=data/modules/information_rights mapping
ant -emacs -q -DMODULES=data/modules/information_rights valid_modules
cscript //nologo checkModuleBatch.wsf information_rights
echo "end: information_rights"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "interface"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/interface clean_module
ant -emacs -q -DMODULES=data/modules/interface modules
ant -emacs -q -DMODULES=data/modules/interface mapping
ant -emacs -q -DMODULES=data/modules/interface valid_modules
cscript //nologo checkModuleBatch.wsf interface
echo "end: interface"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "justification"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/justification clean_module
ant -emacs -q -DMODULES=data/modules/justification modules
ant -emacs -q -DMODULES=data/modules/justification mapping
ant -emacs -q -DMODULES=data/modules/justification valid_modules
cscript //nologo checkModuleBatch.wsf justification
echo "end: justification"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "message"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/message clean_module
ant -emacs -q -DMODULES=data/modules/message modules
ant -emacs -q -DMODULES=data/modules/message mapping
ant -emacs -q -DMODULES=data/modules/message valid_modules
cscript //nologo checkModuleBatch.wsf message
echo "end: message"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "observation"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/observation clean_module
ant -emacs -q -DMODULES=data/modules/observation modules
ant -emacs -q -DMODULES=data/modules/observation mapping
ant -emacs -q -DMODULES=data/modules/observation valid_modules
cscript //nologo checkModuleBatch.wsf observation
echo "end: observation"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "part_and_version_identification"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/part_and_version_identification clean_module
ant -emacs -q -DMODULES=data/modules/part_and_version_identification modules
ant -emacs -q -DMODULES=data/modules/part_and_version_identification mapping
ant -emacs -q -DMODULES=data/modules/part_and_version_identification valid_modules
cscript //nologo checkModuleBatch.wsf part_and_version_identification
echo "end: part_and_version_identification"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "product_as_individual"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/product_as_individual clean_module
ant -emacs -q -DMODULES=data/modules/product_as_individual modules
ant -emacs -q -DMODULES=data/modules/product_as_individual mapping
ant -emacs -q -DMODULES=data/modules/product_as_individual valid_modules
cscript //nologo checkModuleBatch.wsf product_as_individual
echo "end: product_as_individual"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "product_categorization"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/product_categorization clean_module
ant -emacs -q -DMODULES=data/modules/product_categorization modules
ant -emacs -q -DMODULES=data/modules/product_categorization mapping
ant -emacs -q -DMODULES=data/modules/product_categorization valid_modules
cscript //nologo checkModuleBatch.wsf product_categorization
echo "end: product_categorization"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "product_environment_definition"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/product_environment_definition clean_module
ant -emacs -q -DMODULES=data/modules/product_environment_definition modules
ant -emacs -q -DMODULES=data/modules/product_environment_definition mapping
ant -emacs -q -DMODULES=data/modules/product_environment_definition valid_modules
cscript //nologo checkModuleBatch.wsf product_environment_definition
echo "end: product_environment_definition"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "product_environment_observed"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/product_environment_observed clean_module
ant -emacs -q -DMODULES=data/modules/product_environment_observed modules
ant -emacs -q -DMODULES=data/modules/product_environment_observed mapping
ant -emacs -q -DMODULES=data/modules/product_environment_observed valid_modules
cscript //nologo checkModuleBatch.wsf product_environment_observed
echo "end: product_environment_observed"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "product_identification "
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/product_identification clean_module
ant -emacs -q -DMODULES=data/modules/product_identification modules
ant -emacs -q -DMODULES=data/modules/product_identification mapping
ant -emacs -q -DMODULES=data/modules/product_identification valid_modules
cscript //nologo checkModuleBatch.wsf product_identification
echo "end: product_identification"


echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "required_resource"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/required_resource clean_module
ant -emacs -q -DMODULES=data/modules/required_resource modules
ant -emacs -q -DMODULES=data/modules/required_resource mapping
ant -emacs -q -DMODULES=data/modules/required_resource valid_modules
cscript //nologo checkModuleBatch.wsf  required_resource
echo "end: required_resource"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "required_resource_characterized "
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/required_resource_characterized clean_module
ant -emacs -q -DMODULES=data/modules/required_resource_characterized modules
ant -emacs -q -DMODULES=data/modules/required_resource_characterized mapping
ant -emacs -q -DMODULES=data/modules/required_resource_characterized valid_modules
cscript //nologo checkModuleBatch.wsf  required_resource_characterized
echo "end: required_resource_characterized"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "requirement_assignment"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/requirement_assignment clean_module
ant -emacs -q -DMODULES=data/modules/requirement_assignment modules
ant -emacs -q -DMODULES=data/modules/requirement_assignment mapping
ant -emacs -q -DMODULES=data/modules/requirement_assignment valid_modules
cscript //nologo checkModuleBatch.wsf  requirement_assignment
echo "end: requirement_assignment"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "requirement_management"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/requirement_management clean_module
ant -emacs -q -DMODULES=data/modules/requirement_management modules
ant -emacs -q -DMODULES=data/modules/requirement_management mapping
ant -emacs -q -DMODULES=data/modules/requirement_management valid_modules
cscript //nologo checkModuleBatch.wsf  requirement_management
echo "end: requirement_management"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "requirement_view_definition_relationship"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/requirement_view_definition_relationship clean_module
ant -emacs -q -DMODULES=data/modules/requirement_view_definition_relationship modules
ant -emacs -q -DMODULES=data/modules/requirement_view_definition_relationship mapping
ant -emacs -q -DMODULES=data/modules/requirement_view_definition_relationship valid_modules
cscript //nologo checkModuleBatch.wsf  requirement_view_definition_relationship
echo "end: requirement_view_definition_relationship"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "resource_as_realized"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/resource_as_realized clean_module
ant -emacs -q -DMODULES=data/modules/resource_as_realized modules
ant -emacs -q -DMODULES=data/modules/resource_as_realized mapping
ant -emacs -q -DMODULES=data/modules/resource_as_realized valid_modules
cscript //nologo checkModuleBatch.wsf  resource_as_realized
echo "end: resource_as_realized"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "resource_as_realized_characterized"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/resource_as_realized_characterized clean_module
ant -emacs -q -DMODULES=data/modules/resource_as_realized_characterized modules
ant -emacs -q -DMODULES=data/modules/resource_as_realized_characterized mapping
ant -emacs -q -DMODULES=data/modules/resource_as_realized_characterized valid_modules
cscript //nologo checkModuleBatch.wsf  resource_as_realized_characterized
echo "end: resource_as_realized_characterized"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "resource_item"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/resource_item clean_module
ant -emacs -q -DMODULES=data/modules/resource_item modules
ant -emacs -q -DMODULES=data/modules/resource_item mapping
ant -emacs -q -DMODULES=data/modules/resource_item valid_modules
cscript //nologo checkModuleBatch.wsf  resource_item
echo "end: resource_item"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "resource_management"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/resource_management clean_module
ant -emacs -q -DMODULES=data/modules/resource_management modules
ant -emacs -q -DMODULES=data/modules/resource_management mapping
ant -emacs -q -DMODULES=data/modules/resource_management valid_modules
cscript //nologo checkModuleBatch.wsf  resource_management
echo "end: resource_management"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "same_as_external_item"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/same_as_external_item clean_module
ant -emacs -q -DMODULES=data/modules/same_as_external_item modules
ant -emacs -q -DMODULES=data/modules/same_as_external_item mapping
ant -emacs -q -DMODULES=data/modules/same_as_external_item valid_modules
cscript //nologo checkModuleBatch.wsf same_as_external_item
echo "end: same_as_external_item"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "single_part_representation"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/single_part_representation clean_module
ant -emacs -q -DMODULES=data/modules/single_part_representation modules
ant -emacs -q -DMODULES=data/modules/single_part_representation mapping
ant -emacs -q -DMODULES=data/modules/single_part_representation valid_modules
cscript //nologo checkModuleBatch.wsf single_part_representation
echo "end: single_part_representation"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "task_specification"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
ant -emacs -q -DMODULES=data/modules/task_specification clean_module
ant -emacs -q -DMODULES=data/modules/task_specification modules
ant -emacs -q -DMODULES=data/modules/task_specification mapping
ant -emacs -q -DMODULES=data/modules/task_specification valid_modules
cscript //nologo checkModuleBatch.wsf task_specification
echo "end: task_specification"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"