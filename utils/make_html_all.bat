@echo off
REM $Id: make_html_all.bat,v 1.1 2001/11/21 15:41:31 robbod Exp $

REM Generate the html for all the modules.


REM +++++++++++++++++++++++++++++++++++++++
REM create the html for all the modules
REM ++ copy the next line for each new module

call make_html advanced_boundary_representation
call make_html alias_identification
call make_html approval
call make_html boundary_representation_model
call make_html certification
call make_html configuration_effectivity
call make_html constructive_solid_geometry
call make_html constructive_solid_geometry_2d
call make_html constructive_solid_geometry_3d
call make_html contract
call make_html date_time
call make_html date_time_assignment
call make_html document_and_version_identification
call make_html document_assignment
call make_html document_definition
call make_html document_properties
call make_html document_structure
call make_html edge_based_wireframe
call make_html effectivity
call make_html effectivity_application
call make_html elemental_geometric_shape
call make_html elemental_topology
call make_html end_item_identification
call make_html event
call make_html external_item_identification_assignment
call make_html faceted_boundary_representation
call make_html faceted_boundary_representation_model
call make_html file_identification
call make_html file_properties
call make_html foundation_representation
call make_html geometric_shape_with_topology
call make_html geometric_validation_property_representation
call make_html geometrically_bounded_surface
call make_html geometrically_bounded_wireframe
call make_html identification_assignment
call make_html independent_property
call make_html independent_property_representation
call make_html independent_property_usage
call make_html manifold_surface
call make_html part_and_version_identification
call make_html part_occurrence
call make_html part_structure
call make_html part_view_definition
call make_html person_organisation
call make_html person_organisation_assignment
call make_html process_property_assignment
call make_html product_categorisation
call make_html product_concept_identification
call make_html product_identification
call make_html product_structure
call make_html product_version
call make_html product_version_structure
call make_html product_view_definition
call make_html product_view_definition_properties
call make_html product_view_definition_structure
call make_html product_view_definition_structure_properties
call make_html project
call make_html property_assignment
call make_html property_representation
call make_html security_classification
call make_html shape_property_assignment
call make_html shape_property_representation
call make_html shell_based_wireframe
call make_html solid_model
call make_html time_interval
call make_html topologically_bounded_surface
call make_html work_order
call make_html work_request

:END