#!/bin/bash

# WARNING : WORKING DRAFT - SCRIPT NO TESTED AND NOT READY TO BE USED, development just started

# Use saxon command to extract information from CR pub indexes using XSLT:
# - sequence
# - parts included in CR
# see Trello or /stepmod/utils/pub-index_to_wg-n-tables.xsl for existing proposals

# use saxon and ant to build CR

# using last published SMRL, build SMRL_v_8.x using delete/past bash script, first working version:

echo "PURPOSE: Update last SMRL with new CR including updated modules and resources, then add AP build, in order to perform link checks"

if [ -d AP -a -d SMRL -a -d CR ]
then
echo "AP, SMRL and CR directories exist"

if [ -d CR/part1000/data/modules ]
then
echo "======================== Following CR/part1000/data/modules exists ========================"

ls CR/part1000/data/modules/

echo "======================== Deleting corresponding SMRL/data/modules ========================"
ls -d CR/part1000/data/modules/* | sed "s/CR\/part1000/SMRL/g" > list1.txt ; xargs rm -rfv < list1.txt

echo "======================== Copying modules from CR/part1000/data to SMRL/data ========================"
cd CR/part1000/data/ ; ls -d modules/* | xargs tar -cvf p1000_modules.tar ; cd ../../../SMRL/data/ ; tar -xvf ../../CR/part1000/data/p1000_modules.tar ; cd ../..

else
echo "CR/part1000/data/modules doesn't exist."
fi

if [ -d CR/iso10303_42 ]
#HARD CODED, to BE ENHANCED
then
echo "======================== Following CR/iso10303_xx/data/resource_docs and resources exist ========================"
ls -d CR/iso10303_4*/data/*/*

echo "======================== Deleting corresponding SMRL/data/resource_docs and resources ========================"
ls -d CR/iso10303_4*/data/*/* | sed "s/CR\/iso10303_4./SMRL/g" > list1.txt ; xargs rm -rfv < list1.txt

#for i in $( ls CR/iso10303_4*/ )
#do
#	echo "resin cr: $i"
#done
echo "======================== Copying from CR/iso10303_xx/data/resource_docs|resources to SMRL/data/resource_docs|resources exists ========================"

#P42 res:
cd CR/iso10303_42/data/ ; ls -d resources/* | xargs tar -cvf p42_resources.tar ; cd ../../../SMRL/data/ ; tar -xvf ../../CR/iso10303_42/data/p42_resources.tar ; cd ../..

#P42 res docs
cd CR/iso10303_42/data/ ; ls -d resource_docs/* | xargs tar -cvf p42_resource_docs.tar ; cd ../../../SMRL/data/ ; tar -xvf ../../CR/iso10303_42/data/p42_resource_docs.tar ; cd ../..

#P43 res:
cd CR/iso10303_43/data/ ; ls -d resources/* | xargs tar -cvf p43_resources.tar ; cd ../../../SMRL/data/ ; tar -xvf ../../CR/iso10303_43/data/p43_resources.tar ; cd ../..

#P43 res docs
cd CR/iso10303_43/data/ ; ls -d resource_docs/* | xargs tar -cvf p43_resource_docs.tar ; cd ../../../SMRL/data/ ; tar -xvf ../../CR/iso10303_43/data/p43_resource_docs.tar ; cd ../..

else
echo "No Resource docs in the CR."
fi

#echo "======================== AP merge ========================"



else
echo "Missing AP and/or SMRL and/or CR directories. Exit."
exit
fi


# to be cross platform

# other items: 2) format EDM log, 3) run EDM from this script



# SMRLv8.8 cvs tag updated using hardcoded list
cvs co -d "stepmod" -P -A "stepmod"

cd stepmod/data/modules/


cvs update -RAdr CR_Geometry elemental_geometric_shape elemental_topology value_with_unit procedural_solid_model solid_with_local_modification basic_geometric_topology geometrically_bounded_surface manifold_surface advanced_boundary_representation product_data_quality_definition product_data_quality_criteria product_data_quality_inspection_result shape_data_quality_criteria composite_surface basic_geometry manifold_subsurface constructive_solid_geometry_2d composite_constituent_shape geometric_constraints parameterization_and_variational_representation primitive_solids sketch parametric_representation tessellated_geometry point_direction_model edge_based_topological_representation_with_length scan_data_3d_shape

cd ../resource_docs/
cvs update -RAdr CR_Geometry geometric_and_topological_representation representation_structures
cd ../resources/
cvs update -RAdr CR_Geometry geometric_model_schema geometry_schema topology_schema representation_schema scan_data_3d_shape_model_schema

cd ../modules/

cvs update -RAdr CR_itemshape_1 product_view_definition assembly_structure contextual_shape_positioning shape_property_assignment product_view_definition_relationship surface_conditions design_material_aspects associative_draughting_elements shape_data_quality_inspection_result shape_feature characterizable_object assembly_component assembly_shape default_setting_association mating_structure model_based_3d_geometrical_dimensioning_and_tolerancing_representation

cvs update -RAdr CR_itemshape_2  part_view_definition geometric_tolerance product_occurrence derived_shape_element product_placement property_as_definition assembly_physical_requirement_allocation feature_and_connection_zone non_feature_shape_element part_external_reference part_feature_function part_template_3d_shape kinematic_motion_representation kinematic_structure kinematic_state part_shape product_and_manufacturing_information_with_nominal_3d_models product_and_manufacturing_annotation_presentation component_grouping

cvs update -RAdr CR_210_1 assembly_component_placement_requirements assembly_functional_interface_requirement assembly_module_with_macro_component assembly_module_with_subassembly assembly_module_with_interconnect_component assembly_module_with_cable_component assembly_module_with_packaged_connector_component footprint_definition bare_die component_grouping fabrication_joint fabrication_technology interconnect_2d_shape interconnect_module_to_assembly_module_relationship interconnect_module_usage_view interconnect_module_with_macros interconnect_physical_requirement_allocation interconnect_placement_requirements land layered_interconnect_module_3d_design layered_interconnect_module_design layered_interconnect_module_with_printed_component_design layout_macro_definition package packaged_connector_model packaged_part_black_box_model layered_interconnect_complex_template layered_interconnect_simple_template physical_node_requirement_to_implementing_component_allocation physical_unit_2d_shape physical_unit_design_view printed_physical_layout_template test_requirement_allocation assembly_module_with_packaged_component

cvs update -RAdr CR_210_2 geometric_model_2d_3d_relationship altered_package cable datum_difference_based_model design_specific_assignment_to_assembly_usage_view functional_decomposition_to_design part_template physical_unit_2d_design_view physical_unit_3d_design_view physical_unit_3d_shape physical_unit_interconnect_definition planned_characteristic pre_defined_datum_2d_symbol pre_defined_datum_3d_symbol sequential_laminate_assembly_design discrete_shield specification_document thermal_network_definition

cvs update -RAdr CR_PDM_1 approval work_request dimension_tolerance event product_class specification_based_configuration classification_with_attributes measure_representation document_assignment manufacturing_configuration_effectivity product_data_management product_breakdown drawing_definition draughting_element_specialisations incomplete_data_reference_mechanism inertia_characteristics design_product_data_management characteristic generic_material_aspects text_representation value_with_unit_extension external_unit explicit_constraints assembly_feature_relationship process_plan product_as_individual_assembly_and_test form_feature_in_panel machining_features product_view_definition_reference change_management

#For CR_IR_41-44,
# NOT Done (using head but related tag soon

#cd ../resource_docs/
#cvs update -RAdr CR_IR_41-44 fundamentals_of_product_description_and_support product_structure_configuration

#cd ../resources/
#cvs update -RAdr CR_IR_41-44 basic_attribute_schema product_definition_schema product_property_definition_schema product_property_representation_schema product_structure_schema configuration_management_schema

# NOT TESTED :
#cd ../modules/
#cvs update -RAdr CR_EWH product_occurrence assembly_module_design assembly_module_usage_view assembly_technology component_feature functional_assignment_to_part functional_specification interface_component model_parameter network_functional_design_view functional_usage_view part_feature_location physical_component_feature physical_unit_usage_view requirement_decomposition physical_connectivity_definition part_shape mating_structure physical_connectivity_layout_topology_requirement extruded_structure_cross_section wiring_harness_assembly_design edge_based_topological_representation_with_length general_design_connectivity wire_and_cable_design_connectivity

# AM 442, 410, 409, use HEAD

#NOT TESTED - TODO
#cd ../..
#stepmod_dir=‘pwd’

cd data/modules/ap210_electronic_assembly_interconnect_and_packaging_design/dvlp/pmi

# echo “stepmod=$stepmod_dir" > longform_arm.prop

echo "stepmod=/Users/klt/Projets/Eclipse_SMRL_v8.8/stepmod" > longform_arm.prop
echo "type=arm" >> longform_arm.prop
echo "roots=ap210_electronic_assembly_interconnect_and_packaging_design" >> longform_arm.prop

echo "stepmod=/Users/klt/Projets/Eclipse_SMRL_v8.8/stepmod" > longform_mim.prop
echo "type=mim" >> longform_mim.prop

echo "roots=ap210_electronic_assembly_interconnect_and_packaging_design" >> longform_mim.prop

#TO DO: same for 442 and 409

more longform_arm.prop
more longform_mim.prop

./longform_mim.sh

# more  logs

exit
