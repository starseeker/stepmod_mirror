@echo off
REM $Id: make_html_all.bat,v 1.9 2001-09-12 09:16:31+01 rob Exp rob $

REM Generate the html for all the modules.


REM +++++++++++++++++++++++++++++++++++++++
REM create the html for all the modules
REM ++ copy the next line for each new module

cscript express2xml.js advanced_boundary_representation arm
cscript express2xml.js alias_identification arm
cscript express2xml.js approval arm
cscript express2xml.js boundary_representation_model arm
cscript express2xml.js certification arm
cscript express2xml.js configuration_effectivity arm
cscript express2xml.js constructive_solid_geometry arm
cscript express2xml.js constructive_solid_geometry_2d arm
cscript express2xml.js constructive_solid_geometry_3d arm
cscript express2xml.js contract arm
cscript express2xml.js date_time arm
cscript express2xml.js date_time_assignment arm
cscript express2xml.js document_and_version_identification arm
cscript express2xml.js document_assignment arm
cscript express2xml.js document_definition arm
cscript express2xml.js document_properties arm
cscript express2xml.js document_structure arm
cscript express2xml.js edge_based_wireframe arm
cscript express2xml.js effectivity arm
cscript express2xml.js effectivity_application arm
cscript express2xml.js elemental_geometric_shape arm
cscript express2xml.js elemental_topology arm
cscript express2xml.js end_item_identification arm
cscript express2xml.js event arm
cscript express2xml.js external_item_identification_assignment arm
cscript express2xml.js faceted_boundary_representation arm
cscript express2xml.js faceted_boundary_representation_model arm
cscript express2xml.js file_identification arm
cscript express2xml.js file_properties arm
cscript express2xml.js foundation_representation arm
cscript express2xml.js geometric_shape_with_topology arm
cscript express2xml.js geometric_validation_property_representation arm
cscript express2xml.js geometrically_bounded_surface arm
cscript express2xml.js geometrically_bounded_wireframe arm
cscript express2xml.js identification_assignment arm
cscript express2xml.js independent_property arm
cscript express2xml.js independent_property_representation arm
cscript express2xml.js independent_property_usage arm
cscript express2xml.js manifold_surface arm
cscript express2xml.js part_and_version_identification arm
cscript express2xml.js part_occurrence arm
cscript express2xml.js part_structure arm
cscript express2xml.js part_view_definition arm
cscript express2xml.js person_organisation arm
cscript express2xml.js person_organisation_assignment arm
cscript express2xml.js process_property_assignment arm
cscript express2xml.js product_categorisation arm
cscript express2xml.js product_concept_identification arm
cscript express2xml.js product_identification arm
cscript express2xml.js product_structure arm
cscript express2xml.js product_version arm
cscript express2xml.js product_version_structure arm
cscript express2xml.js product_view_definition arm
cscript express2xml.js product_view_definition_properties arm
cscript express2xml.js product_view_definition_structure arm
cscript express2xml.js product_view_definition_structure_properties arm
cscript express2xml.js project arm
cscript express2xml.js property_assignment arm
cscript express2xml.js property_representation arm
cscript express2xml.js security_classification arm
cscript express2xml.js shape_property_assignment arm
cscript express2xml.js shape_property_representation arm
cscript express2xml.js shell_based_wireframe arm
cscript express2xml.js solid_model arm
cscript express2xml.js time_interval arm
cscript express2xml.js topologically_bounded_surface arm
cscript express2xml.js work_order arm
cscript express2xml.js work_request arm

