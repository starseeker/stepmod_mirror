//$Id: modImgMap2xml.js,v 1.2 2002/03/04 07:55:11 robbod Exp $

// Convert a ballot module expressG HTML file containing a single image map 
// into an XML file
// cscript modImgMap2xml.js

// The string added to the begining of the xml output to indent the output
var indent = "";

var armOrmim = "";

var appltypeDict, applobjDict;
// ------------------------------------------------------------
// Call Main program
// -----------------------------------------------------------
Main();
//convertAllModulesArm();
//convertAllModulesMim();

function init() {
appltypeDict = new ActiveXObject("Scripting.Dictionary");
appltypeDict.add("affected_item_select","../work_request/sys/4_info_reqs.xml#work_request_arm.affected_item_select");
appltypeDict.add("alias_identification_item","../alias_identification/sys/4_info_reqs.xml#alias_identification_arm.alias_identification_item");
appltypeDict.add("assigned_document_select","../document_assignment/sys/4_info_reqs.xml#document_assignment_arm.assigned_document_select");
appltypeDict.add("boolean_operand","../constructive_solid_geometry/sys/4_info_reqs.xml#constructive_solid_geometry_arm.boolean_operand");
appltypeDict.add("boolean_operand_3d","../constructive_solid_geometry_3d/sys/4_info_reqs.xml#constructive_solid_geometry_3d_arm.boolean_operand_3d");
appltypeDict.add("boolean_operator","../constructive_solid_geometry/sys/4_info_reqs.xml#constructive_solid_geometry_arm.boolean_operator");
appltypeDict.add("certification_approval_item","../certification/sys/4_info_reqs.xml#certification_arm.certification_approval_item");
appltypeDict.add("certification_item","../certification/sys/4_info_reqs.xml#certification_arm.certification_item");
appltypeDict.add("configuration_item_alias_identification_item","../Configuration_item/sys/4_info_reqs.xml#Configuration_item_arm.configuration_item_alias_identification_item");
appltypeDict.add("configuration_item_approval_item","../Configuration_item/sys/4_info_reqs.xml#Configuration_item_arm.configuration_item_approval_item");
appltypeDict.add("configuration_item_organisation_or_person_in_organisation_item","../Configuration_item/sys/4_info_reqs.xml#Configuration_item_arm.configuration_item_organisation_or_person_in_organisation_item");
appltypeDict.add("contract_approval_item","../contract/sys/4_info_reqs.xml#contract_arm.contract_approval_item");
appltypeDict.add("contract_date_or_date_time_item","../contract/sys/4_info_reqs.xml#contract_arm.contract_date_or_date_time_item");
appltypeDict.add("contract_item","../contract/sys/4_info_reqs.xml#contract_arm.contract_item");
appltypeDict.add("contract_organisation_or_person_in_organisation_item","../contract/sys/4_info_reqs.xml#contract_arm.contract_organisation_or_person_in_organisation_item");
appltypeDict.add("csg_primitive","../constructive_solid_geometry/sys/4_info_reqs.xml#constructive_solid_geometry_arm.csg_primitive");
appltypeDict.add("csg_primitive_3d","../constructive_solid_geometry_3d/sys/4_info_reqs.xml#constructive_solid_geometry_3d_arm.csg_primitive_3d");
appltypeDict.add("csg_select","../constructive_solid_geometry/sys/4_info_reqs.xml#constructive_solid_geometry_arm.csg_select");
appltypeDict.add("date_or_date_time_item","../date_time_assignment/sys/4_info_reqs.xml#date_time_assignment_arm.date_or_date_time_item");
appltypeDict.add("date_or_date_time_select","../date_time/sys/4_info_reqs.xml#date_time_arm.date_or_date_time_select");
appltypeDict.add("document_property_assignment","../document_properties/sys/4_info_reqs.xml#document_properties_arm.document_property_assignment");
appltypeDict.add("documented_element_select","../document_assignment/sys/4_info_reqs.xml#document_assignment_arm.documented_element_select");
appltypeDict.add("effectivity_context_select","../effectivity_application/sys/4_info_reqs.xml#effectivity_application_arm.effectivity_context_select");
appltypeDict.add("effectivity_item","../effectivity_application/sys/4_info_reqs.xml#effectivity_application_arm.effectivity_item");
appltypeDict.add("effectivity_organisation_or_person_in_organisation_item","../effectivity/sys/4_info_reqs.xml#effectivity_arm.effectivity_organisation_or_person_in_organisation_item");
appltypeDict.add("event_date_or_date_time_item","../event/sys/4_info_reqs.xml#event_arm.event_date_or_date_time_item");
appltypeDict.add("event_item","../event/sys/4_info_reqs.xml#event_arm.event_item");
appltypeDict.add("event_organisation_or_person_in_organisation_item","../event/sys/4_info_reqs.xml#event_arm.event_organisation_or_person_in_organisation_item");
appltypeDict.add("external_identification_item","../external_item_identification_assignment/sys/4_info_reqs.xml#external_item_identification_assignment_arm.external_identification_item");
appltypeDict.add("file_alias_identification_item","../file_identification/sys/4_info_reqs.xml#file_identification_arm.file_alias_identification_item");
appltypeDict.add("file_property_assignment","../file_properties/sys/4_info_reqs.xml#file_properties_arm.file_property_assignment");
appltypeDict.add("identification_item","../identification_assignment/sys/4_info_reqs.xml#identification_assignment_arm.identification_item");
appltypeDict.add("identification_organisation_or_person_in_organisation_item","../identification_assignment/sys/4_info_reqs.xml#identification_assignment_arm.identification_organisation_or_person_in_organisation_item");
appltypeDict.add("independent_process_property_assignment","../process_property_assignment/sys/4_info_reqs.xml#process_property_assignment_arm.independent_process_property_assignment");
appltypeDict.add("independent_property_usage_select","../independent_property_usage/sys/4_info_reqs.xml#independent_property_usage_arm.independent_property_usage_select");
appltypeDict.add("item_shape_or_shape_element_select","../shape_property_assignment/sys/4_info_reqs.xml#shape_property_assignment_arm.item_shape_or_shape_element_select");
appltypeDict.add("ordered_item_select","../work_order/sys/4_info_reqs.xml#work_order_arm.ordered_item_select");
appltypeDict.add("organisation_or_person_in_organisation_item","../person_organisation_assignment/sys/4_info_reqs.xml#person_organisation_assignment_arm.organisation_or_person_in_organisation_item");
appltypeDict.add("part_version_organisation_or_person_in_organisation_item","../part_and_version_identification/sys/4_info_reqs.xml#part_and_version_identification_arm.part_version_organisation_or_person_in_organisation_item");
appltypeDict.add("part_view_definition_alias_identification_item","../part_view_definition/sys/4_info_reqs.xml#part_view_definition_arm.part_view_definition_alias_identification_item");
appltypeDict.add("product_categorisation_organisation_or_person_in_organisation_item","../product_categorisation/sys/4_info_reqs.xml#product_categorisation_arm.product_categorisation_organisation_or_person_in_organisation_item");
appltypeDict.add("product_concept_organisation_or_person_in_organisation_item","../product_concept_identification/sys/4_info_reqs.xml#product_concept_identification_arm.product_concept_organisation_or_person_in_organisation_item");
appltypeDict.add("product_concept_project_item","../product_concept_identification/sys/4_info_reqs.xml#product_concept_identification_arm.product_concept_project_item");
appltypeDict.add("product_organisation_or_person_in_organisation_item","../product_identification/sys/4_info_reqs.xml#product_identification_arm.product_organisation_or_person_in_organisation_item");
appltypeDict.add("product_version_approval_item","../product_version/sys/4_info_reqs.xml#product_version_arm.product_version_approval_item");
appltypeDict.add("product_version_contract_item","../product_version/sys/4_info_reqs.xml#product_version_arm.product_version_contract_item");
appltypeDict.add("product_version_organisation_or_person_in_organisation_item","../product_version/sys/4_info_reqs.xml#product_version_arm.product_version_organisation_or_person_in_organisation_item");
appltypeDict.add("product_version_security_classification_item","../product_version/sys/4_info_reqs.xml#product_version_arm.product_version_security_classification_item");
appltypeDict.add("product_view_definition_approval_item","../product_view_definition/sys/4_info_reqs.xml#product_view_definition_arm.product_view_definition_approval_item");
appltypeDict.add("product_view_definition_date_or_date_time_item","../product_view_definition/sys/4_info_reqs.xml#product_view_definition_arm.product_view_definition_date_or_date_time_item");
appltypeDict.add("product_view_definition_organisation_or_person_in_organisation_item","../product_view_definition/sys/4_info_reqs.xml#product_view_definition_arm.product_view_definition_organisation_or_person_in_organisation_item");
appltypeDict.add("product_view_definition_property_assignment","../product_view_definition_properties/sys/4_info_reqs.xml#product_view_definition_properties_arm.product_view_definition_property_assignment");
appltypeDict.add("product_view_definition_structure_property_assignment","../product_view_definition_structure_properties/sys/4_info_reqs.xml#product_view_definition_structure_properties_arm.product_view_definition_structure_property_assignment");
appltypeDict.add("project_event_item","../project/sys/4_info_reqs.xml#project_arm.project_event_item");
appltypeDict.add("project_organisation_or_person_in_organisation_item","../project/sys/4_info_reqs.xml#project_arm.project_organisation_or_person_in_organisation_item");
appltypeDict.add("property_assignment_select","../property_assignment/sys/4_info_reqs.xml#property_assignment_arm.property_assignment_select");
appltypeDict.add("property_source_select","../independent_property/sys/4_info_reqs.xml#independent_property_arm.property_source_select");
appltypeDict.add("represented_item_select","../property_representation/sys/4_info_reqs.xml#property_representation_arm.represented_item_select");
appltypeDict.add("security_classification_alias_identification_item","../security_classification/sys/4_info_reqs.xml#security_classification_arm.security_classification_alias_identification_item");
appltypeDict.add("security_classification_approval_item","../security_classification/sys/4_info_reqs.xml#security_classification_arm.security_classification_approval_item");
appltypeDict.add("security_classification_date_or_date_time_item","../security_classification/sys/4_info_reqs.xml#security_classification_arm.security_classification_date_or_date_time_item");
appltypeDict.add("security_classification_item","../security_classification/sys/4_info_reqs.xml#security_classification_arm.security_classification_item");
appltypeDict.add("security_classification_organisation_or_person_in_organisation_item","../security_classification/sys/4_info_reqs.xml#security_classification_arm.security_classification_organisation_or_person_in_organisation_item");
appltypeDict.add("shape_definition_select","../shape_property_representation/sys/4_info_reqs.xml#shape_property_representation_arm.shape_definition_select");
appltypeDict.add("shape_model_assignment","../shape_property_representation/sys/4_info_reqs.xml#shape_property_representation_arm.shape_model_assignment");
appltypeDict.add("shape_property_assignment","../shape_property_assignment/sys/4_info_reqs.xml#shape_property_assignment_arm.shape_property_assignment");
appltypeDict.add("shape_select","../shape_property_assignment/sys/4_info_reqs.xml#shape_property_assignment_arm.shape_select");
appltypeDict.add("status_value","../work_request/sys/4_info_reqs.xml#work_request_arm.status_value");
appltypeDict.add("time_interval_item","../time_interval/sys/4_info_reqs.xml#time_interval_arm.time_interval_item");
appltypeDict.add("time_interval_organisation_or_person_in_organisation_item","../time_interval/sys/4_info_reqs.xml#time_interval_arm.time_interval_organisation_or_person_in_organisation_item");
appltypeDict.add("view_definition_usage_security_classification_item","../product_view_definition_structure/sys/4_info_reqs.xml#product_view_definition_structure_arm.view_definition_usage_security_classification_item");
appltypeDict.add("work_order_approval_item","../work_order/sys/4_info_reqs.xml#work_order_arm.work_order_approval_item");
appltypeDict.add("work_order_contract_item","../work_order/sys/4_info_reqs.xml#work_order_arm.work_order_contract_item");
appltypeDict.add("work_order_date_or_date_time_item","../work_order/sys/4_info_reqs.xml#work_order_arm.work_order_date_or_date_time_item");
appltypeDict.add("work_order_organisation_or_person_in_organisation_item","../work_order/sys/4_info_reqs.xml#work_order_arm.work_order_organisation_or_person_in_organisation_item");
appltypeDict.add("work_request_approval_item","../work_request/sys/4_info_reqs.xml#work_request_arm.work_request_approval_item");
appltypeDict.add("work_request_date_or_date_time_item","../work_request/sys/4_info_reqs.xml#work_request_arm.work_request_date_or_date_time_item");
appltypeDict.add("work_request_organisation_or_person_in_organisation_item","../work_request/sys/4_info_reqs.xml#work_request_arm.work_request_organisation_or_person_in_organisation_item");

applobjDict = new ActiveXObject("Scripting.Dictionary");
applobjDict.add("activity","../work_order/sys/4_info_reqs.xml#work_order_arm.activity");
applobjDict.add("activity_method","../work_request/sys/4_info_reqs.xml#work_request_arm.activity_method");
applobjDict.add("activity_property","../process_property_assignment/sys/4_info_reqs.xml#process_property_assignment_arm.activity_property");
applobjDict.add("activity_property_representation","../process_property_assignment/sys/4_info_reqs.xml#process_property_assignment_arm.activity_property_representation");
applobjDict.add("address","../person_organization/sys/4_info_reqs.xml#person_organization_arm.address");
applobjDict.add("advanced_brep_shape_representation","../advanced_boundary_representation/sys/4_info_reqs.xml#advanced_boundary_representation_arm.advanced_brep_shape_representation");
applobjDict.add("advanced_face","../topologically_bounded_surface/sys/4_info_reqs.xml#topologically_bounded_surface_arm.advanced_face");
applobjDict.add("alias_identification","../alias_identification/sys/4_info_reqs.xml#alias_identification_arm.alias_identification");
applobjDict.add("alternate_part","../part_structure/sys/4_info_reqs.xml#part_structure_arm.alternate_part");
applobjDict.add("approval","../approval/sys/4_info_reqs.xml#approval_arm.approval");
applobjDict.add("approval_assignment","../approval/sys/4_info_reqs.xml#approval_arm.approval_assignment");
applobjDict.add("approval_relationship","../approval/sys/4_info_reqs.xml#approval_arm.approval_relationship");
applobjDict.add("assembly_component","../product_view_definition_structure/sys/4_info_reqs.xml#product_view_definition_structure_arm.assembly_component");
applobjDict.add("assembly_component_shape","../shape_property_assignment/sys/4_info_reqs.xml#shape_property_assignment_arm.assembly_component_shape");
applobjDict.add("block","../constructive_solid_geometry_3d/sys/4_info_reqs.xml#constructive_solid_geometry_3d_arm.block");
applobjDict.add("boolean_result","../constructive_solid_geometry/sys/4_info_reqs.xml#constructive_solid_geometry_arm.boolean_result");
applobjDict.add("brep_model","../boundary_representation_model/sys/4_info_reqs.xml#boundary_representation_model_arm.brep_model");
applobjDict.add("brep_with_voids","../boundary_representation_model/sys/4_info_reqs.xml#boundary_representation_model_arm.brep_with_voids");
applobjDict.add("calendar_date","../date_time/sys/4_info_reqs.xml#date_time_arm.calendar_date");
applobjDict.add("cartesian_coordinate_space","../elemental_geometric_shape/sys/4_info_reqs.xml#elemental_geometric_shape_arm.cartesian_coordinate_space");
applobjDict.add("certification","../certification/sys/4_info_reqs.xml#certification_arm.certification");
applobjDict.add("certification_assignment","../certification/sys/4_info_reqs.xml#certification_arm.certification_assignment");
applobjDict.add("class","../class/sys/4_info_reqs.xml#class_arm.class");
applobjDict.add("class_by_extension","../class/sys/4_info_reqs.xml#class_arm.class_by_extension");
applobjDict.add("class_by_intension","../class/sys/4_info_reqs.xml#class_arm.class_by_intension");
applobjDict.add("complement","../set_theory/sys/4_info_reqs.xml#set_theory_arm.complement");
applobjDict.add("configuration_effectivity","../configuration_effectivity/sys/4_info_reqs.xml#configuration_effectivity_arm.configuration_effectivity");
applobjDict.add("configuration_item","../Configuration_item/sys/4_info_reqs.xml#Configuration_item_arm.configuration_item");
applobjDict.add("contract","../contract/sys/4_info_reqs.xml#contract_arm.contract");
applobjDict.add("contract_assignment","../contract/sys/4_info_reqs.xml#contract_arm.contract_assignment");
applobjDict.add("convex_hexahedron","../constructive_solid_geometry_3d/sys/4_info_reqs.xml#constructive_solid_geometry_3d_arm.convex_hexahedron");
applobjDict.add("csg_model","../constructive_solid_geometry/sys/4_info_reqs.xml#constructive_solid_geometry_arm.csg_model");
applobjDict.add("csg_shape_representation","../constructive_solid_geometry/sys/4_info_reqs.xml#constructive_solid_geometry_arm.csg_shape_representation");
applobjDict.add("csg_shape_representation_3d","../constructive_solid_geometry_3d/sys/4_info_reqs.xml#constructive_solid_geometry_3d_arm.csg_shape_representation_3d");
applobjDict.add("cyclide_segment_solid","../constructive_solid_geometry_3d/sys/4_info_reqs.xml#constructive_solid_geometry_3d_arm.cyclide_segment_solid");
applobjDict.add("date_or_date_time_assignment","../date_time_assignment/sys/4_info_reqs.xml#date_time_assignment_arm.date_or_date_time_assignment");
applobjDict.add("date_time","../date_time/sys/4_info_reqs.xml#date_time_arm.date_time");
applobjDict.add("dated_effectivity","../effectivity/sys/4_info_reqs.xml#effectivity_arm.dated_effectivity");
applobjDict.add("detailed_geometric_model_element","../elemental_geometric_shape/sys/4_info_reqs.xml#elemental_geometric_shape_arm.detailed_geometric_model_element");
applobjDict.add("detailed_topological_model_element","../elemental_topology/sys/4_info_reqs.xml#elemental_topology_arm.detailed_topological_model_element");
applobjDict.add("digital_document_definition","../document_definition/sys/4_info_reqs.xml#document_definition_arm.digital_document_definition");
applobjDict.add("digital_file","../file_identification/sys/4_info_reqs.xml#file_identification_arm.digital_file");
applobjDict.add("document","../document_and_version_identification/sys/4_info_reqs.xml#document_and_version_identification_arm.document");
applobjDict.add("document_assignment","../document_assignment/sys/4_info_reqs.xml#document_assignment_arm.document_assignment");
applobjDict.add("document_content_property","../document_properties/sys/4_info_reqs.xml#document_properties_arm.document_content_property");
applobjDict.add("document_creation_property","../document_properties/sys/4_info_reqs.xml#document_properties_arm.document_creation_property");
applobjDict.add("document_definition","../document_definition/sys/4_info_reqs.xml#document_definition_arm.document_definition");
applobjDict.add("document_definition_relationship","../document_structure/sys/4_info_reqs.xml#document_structure_arm.document_definition_relationship");
applobjDict.add("document_format_property","../document_properties/sys/4_info_reqs.xml#document_properties_arm.document_format_property");
applobjDict.add("document_size_property","../document_properties/sys/4_info_reqs.xml#document_properties_arm.document_size_property");
applobjDict.add("document_source_property","../document_properties/sys/4_info_reqs.xml#document_properties_arm.document_source_property");
applobjDict.add("document_version","../document_and_version_identification/sys/4_info_reqs.xml#document_and_version_identification_arm.document_version");
applobjDict.add("document_version_relationship","../document_structure/sys/4_info_reqs.xml#document_structure_arm.document_version_relationship");
applobjDict.add("eccentric_cone","../constructive_solid_geometry_3d/sys/4_info_reqs.xml#constructive_solid_geometry_3d_arm.eccentric_cone");
applobjDict.add("edge_based_wireframe_shape_representation","../edge_based_wireframe/sys/4_info_reqs.xml#edge_based_wireframe_arm.edge_based_wireframe_shape_representation");
applobjDict.add("edge_transition","../constructive_solid_geometry/sys/4_info_reqs.xml#constructive_solid_geometry_arm.edge_transition");
applobjDict.add("effectivity","../effectivity/sys/4_info_reqs.xml#effectivity_arm.effectivity");
applobjDict.add("effectivity_assignment","../effectivity_application/sys/4_info_reqs.xml#effectivity_application_arm.effectivity_assignment");
applobjDict.add("effectivity_relationship","../effectivity/sys/4_info_reqs.xml#effectivity_arm.effectivity_relationship");
applobjDict.add("element_property","../property_assignment/sys/4_info_reqs.xml#property_assignment_arm.element_property");
applobjDict.add("ellipsoid","../constructive_solid_geometry_3d/sys/4_info_reqs.xml#constructive_solid_geometry_3d_arm.ellipsoid");
applobjDict.add("event","../event/sys/4_info_reqs.xml#event_arm.event");
applobjDict.add("event_assignment","../event/sys/4_info_reqs.xml#event_arm.event_assignment");
applobjDict.add("event_relationship","../event/sys/4_info_reqs.xml#event_arm.event_relationship");
applobjDict.add("external_item_identification_assignment","../external_item_identification_assignment/sys/4_info_reqs.xml#external_item_identification_assignment_arm.external_item_identification_assignment");
applobjDict.add("external_library_reference","../independent_property/sys/4_info_reqs.xml#independent_property_arm.external_library_reference");
applobjDict.add("extruded_area_solid","../solid_model/sys/4_info_reqs.xml#solid_model_arm.extruded_area_solid");
applobjDict.add("extruded_face_solid","../solid_model/sys/4_info_reqs.xml#solid_model_arm.extruded_face_solid");
applobjDict.add("face_transition","../constructive_solid_geometry/sys/4_info_reqs.xml#constructive_solid_geometry_arm.face_transition");
applobjDict.add("faceted_brep_shape_representation","../faceted_boundary_representation/sys/4_info_reqs.xml#faceted_boundary_representation_arm.faceted_brep_shape_representation");
applobjDict.add("faceted_model","../faceted_boundary_representation_model/sys/4_info_reqs.xml#faceted_boundary_representation_model_arm.faceted_model");
applobjDict.add("faceted_primitive","../constructive_solid_geometry_3d/sys/4_info_reqs.xml#constructive_solid_geometry_3d_arm.faceted_primitive");
applobjDict.add("file","../file_identification/sys/4_info_reqs.xml#file_identification_arm.file");
applobjDict.add("file_content_property","../file_properties/sys/4_info_reqs.xml#file_properties_arm.file_content_property");
applobjDict.add("file_creation_property","../file_properties/sys/4_info_reqs.xml#file_properties_arm.file_creation_property");
applobjDict.add("file_format_property","../file_properties/sys/4_info_reqs.xml#file_properties_arm.file_format_property");
applobjDict.add("file_relationship","../document_structure/sys/4_info_reqs.xml#document_structure_arm.file_relationship");
applobjDict.add("file_size_property","../file_properties/sys/4_info_reqs.xml#file_properties_arm.file_size_property");
applobjDict.add("file_source_property","../file_properties/sys/4_info_reqs.xml#file_properties_arm.file_source_property");
applobjDict.add("geometric_model","../elemental_geometric_shape/sys/4_info_reqs.xml#elemental_geometric_shape_arm.geometric_model");
applobjDict.add("geometric_validation_property_representation","../geometric_validation_property_representation/sys/4_info_reqs.xml#geometric_validation_property_representation_arm.geometric_validation_property_representation");
applobjDict.add("geometrically_bounded_surface_shape_representation","../geometrically_bounded_surface/sys/4_info_reqs.xml#geometrically_bounded_surface_arm.geometrically_bounded_surface_shape_representation");
applobjDict.add("geometrically_bounded_wireframe_shape_representation","../geometrically_bounded_wireframe/sys/4_info_reqs.xml#geometrically_bounded_wireframe_arm.geometrically_bounded_wireframe_shape_representation");
applobjDict.add("geometry_with_topology","../geometric_shape_with_topology/sys/4_info_reqs.xml#geometric_shape_with_topology_arm.geometry_with_topology");
applobjDict.add("half_space_solid","../constructive_solid_geometry_3d/sys/4_info_reqs.xml#constructive_solid_geometry_3d_arm.half_space_solid");
applobjDict.add("hardcopy","../file_identification/sys/4_info_reqs.xml#file_identification_arm.hardcopy");
applobjDict.add("identification_assignment","../identification_assignment/sys/4_info_reqs.xml#identification_assignment_arm.identification_assignment");
applobjDict.add("independent_property","../independent_property/sys/4_info_reqs.xml#independent_property_arm.independent_property");
applobjDict.add("independent_property_relationship","../independent_property/sys/4_info_reqs.xml#independent_property_arm.independent_property_relationship");
applobjDict.add("independent_property_representation","../independent_property_representation/sys/4_info_reqs.xml#independent_property_representation_arm.independent_property_representation");
applobjDict.add("independent_property_usage","../independent_property_usage/sys/4_info_reqs.xml#independent_property_usage_arm.independent_property_usage");
applobjDict.add("intersection","../set_theory/sys/4_info_reqs.xml#set_theory_arm.intersection");
applobjDict.add("item_shape","../shape_property_assignment/sys/4_info_reqs.xml#shape_property_assignment_arm.item_shape");
applobjDict.add("lot_effectivity","../effectivity/sys/4_info_reqs.xml#effectivity_arm.lot_effectivity");
applobjDict.add("make_from","../product_view_definition_structure/sys/4_info_reqs.xml#product_view_definition_structure_arm.make_from");
applobjDict.add("manifold_surface_shape_representation","../manifold_surface/sys/4_info_reqs.xml#manifold_surface_arm.manifold_surface_shape_representation");
applobjDict.add("market","../product_concept_identification/sys/4_info_reqs.xml#product_concept_identification_arm.market");
applobjDict.add("next_assembly_usage","../part_structure/sys/4_info_reqs.xml#part_structure_arm.next_assembly_usage");
applobjDict.add("organisation","../person_organization/sys/4_info_reqs.xml#person_organization_arm.organisation");
applobjDict.add("organisation_or_person_in_organisation_assignment","../person_organisation_assignment/sys/4_info_reqs.xml#person_organisation_assignment_arm.organisation_or_person_in_organisation_assignment");
applobjDict.add("part","../part_and_version_identification/sys/4_info_reqs.xml#part_and_version_identification_arm.part");
applobjDict.add("part_instance","../part_occurrence/sys/4_info_reqs.xml#part_occurrence_arm.part_instance");
applobjDict.add("part_occurrence","../part_occurrence/sys/4_info_reqs.xml#part_occurrence_arm.part_occurrence");
applobjDict.add("part_version","../part_and_version_identification/sys/4_info_reqs.xml#part_and_version_identification_arm.part_version");
applobjDict.add("part_view_definition","../part_view_definition/sys/4_info_reqs.xml#part_view_definition_arm.part_view_definition");
applobjDict.add("partial_document_assignment","../document_assignment/sys/4_info_reqs.xml#document_assignment_arm.partial_document_assignment");
applobjDict.add("person_in_organisation","../person_organization/sys/4_info_reqs.xml#person_organization_arm.person_in_organisation");
applobjDict.add("physical_document_definition","../document_definition/sys/4_info_reqs.xml#document_definition_arm.physical_document_definition");
applobjDict.add("power_set","../set_theory/sys/4_info_reqs.xml#set_theory_arm.power_set");
applobjDict.add("product","../product_identification/sys/4_info_reqs.xml#product_identification_arm.product");
applobjDict.add("product_category","../product_categorisation/sys/4_info_reqs.xml#product_categorisation_arm.product_category");
applobjDict.add("product_category_hierarchy","../product_categorisation/sys/4_info_reqs.xml#product_categorisation_arm.product_category_hierarchy");
applobjDict.add("product_concept","../product_concept_identification/sys/4_info_reqs.xml#product_concept_identification_arm.product_concept");
applobjDict.add("product_iteration","../product_version_structure/sys/4_info_reqs.xml#product_version_structure_arm.product_iteration");
applobjDict.add("product_relationship","../product_structure/sys/4_info_reqs.xml#product_structure_arm.product_relationship");
applobjDict.add("product_version","../product_version/sys/4_info_reqs.xml#product_version_arm.product_version");
applobjDict.add("product_view_definition","../product_view_definition/sys/4_info_reqs.xml#product_view_definition_arm.product_view_definition");
applobjDict.add("project","../project/sys/4_info_reqs.xml#project_arm.project");
applobjDict.add("project_assignment","../project/sys/4_info_reqs.xml#project_arm.project_assignment");
applobjDict.add("project_relationship","../project/sys/4_info_reqs.xml#project_arm.project_relationship");
applobjDict.add("promissory_usage","../part_structure/sys/4_info_reqs.xml#part_structure_arm.promissory_usage");
applobjDict.add("proper_subset","../set_theory/sys/4_info_reqs.xml#set_theory_arm.proper_subset");
applobjDict.add("property_of_shape","../shape_property_assignment/sys/4_info_reqs.xml#shape_property_assignment_arm.property_of_shape");
applobjDict.add("property_representation","../property_representation/sys/4_info_reqs.xml#property_representation_arm.property_representation");
applobjDict.add("rectangular_pyramid","../constructive_solid_geometry_3d/sys/4_info_reqs.xml#constructive_solid_geometry_3d_arm.rectangular_pyramid");
applobjDict.add("relative_event","../event/sys/4_info_reqs.xml#event_arm.relative_event");
applobjDict.add("representation","../foundation_representation/sys/4_info_reqs.xml#foundation_representation_arm.representation");
applobjDict.add("representation_context","../foundation_representation/sys/4_info_reqs.xml#foundation_representation_arm.representation_context");
applobjDict.add("representation_item","../foundation_representation/sys/4_info_reqs.xml#foundation_representation_arm.representation_item");
applobjDict.add("revolved_area_solid","../solid_model/sys/4_info_reqs.xml#solid_model_arm.revolved_area_solid");
applobjDict.add("revolved_face_solid","../solid_model/sys/4_info_reqs.xml#solid_model_arm.revolved_face_solid");
applobjDict.add("right_angular_wedge","../constructive_solid_geometry_3d/sys/4_info_reqs.xml#constructive_solid_geometry_3d_arm.right_angular_wedge");
applobjDict.add("right_circular_cone","../constructive_solid_geometry_3d/sys/4_info_reqs.xml#constructive_solid_geometry_3d_arm.right_circular_cone");
applobjDict.add("right_circular_cylinder","../constructive_solid_geometry_3d/sys/4_info_reqs.xml#constructive_solid_geometry_3d_arm.right_circular_cylinder");
applobjDict.add("same_membership","../set_theory/sys/4_info_reqs.xml#set_theory_arm.same_membership");
applobjDict.add("security_classification","../security_classification/sys/4_info_reqs.xml#security_classification_arm.security_classification");
applobjDict.add("security_classification_assignment","../security_classification/sys/4_info_reqs.xml#security_classification_arm.security_classification_assignment");
applobjDict.add("serial_effectivity","../effectivity/sys/4_info_reqs.xml#effectivity_arm.serial_effectivity");
applobjDict.add("shape_dependent_property_representation","../shape_property_representation/sys/4_info_reqs.xml#shape_property_representation_arm.shape_dependent_property_representation");
applobjDict.add("shape_description_association","../shape_property_representation/sys/4_info_reqs.xml#shape_property_representation_arm.shape_description_association");
applobjDict.add("shape_element","../shape_property_assignment/sys/4_info_reqs.xml#shape_property_assignment_arm.shape_element");
applobjDict.add("shape_element_relationship","../shape_property_assignment/sys/4_info_reqs.xml#shape_property_assignment_arm.shape_element_relationship");
applobjDict.add("shell_based_wireframe_shape_representation","../shell_based_wireframe/sys/4_info_reqs.xml#shell_based_wireframe_arm.shell_based_wireframe_shape_representation");
applobjDict.add("solid_replica","../solid_model/sys/4_info_reqs.xml#solid_model_arm.solid_replica");
applobjDict.add("sphere","../constructive_solid_geometry_3d/sys/4_info_reqs.xml#constructive_solid_geometry_3d_arm.sphere");
applobjDict.add("subset","../set_theory/sys/4_info_reqs.xml#set_theory_arm.subset");
applobjDict.add("substitute_part","../part_structure/sys/4_info_reqs.xml#part_structure_arm.substitute_part");
applobjDict.add("supplied_part","../part_structure/sys/4_info_reqs.xml#part_structure_arm.supplied_part");
applobjDict.add("surface_curve_swept_area_solid","../solid_model/sys/4_info_reqs.xml#solid_model_arm.surface_curve_swept_area_solid");
applobjDict.add("surface_curve_swept_face_solid","../solid_model/sys/4_info_reqs.xml#solid_model_arm.surface_curve_swept_face_solid");
applobjDict.add("swept_area_solid","../solid_model/sys/4_info_reqs.xml#solid_model_arm.swept_area_solid");
applobjDict.add("swept_face_solid","../solid_model/sys/4_info_reqs.xml#solid_model_arm.swept_face_solid");
applobjDict.add("template_instance","../elemental_geometric_shape/sys/4_info_reqs.xml#elemental_geometric_shape_arm.template_instance");
applobjDict.add("tetrahedron","../constructive_solid_geometry_3d/sys/4_info_reqs.xml#constructive_solid_geometry_3d_arm.tetrahedron");
applobjDict.add("time_interval","../time_interval/sys/4_info_reqs.xml#time_interval_arm.time_interval");
applobjDict.add("time_interval_assignment","../time_interval/sys/4_info_reqs.xml#time_interval_arm.time_interval_assignment");
applobjDict.add("time_interval_effectivity","../effectivity/sys/4_info_reqs.xml#effectivity_arm.time_interval_effectivity");
applobjDict.add("time_offset","../date_time/sys/4_info_reqs.xml#date_time_arm.time_offset");
applobjDict.add("torus","../constructive_solid_geometry_3d/sys/4_info_reqs.xml#constructive_solid_geometry_3d_arm.torus");
applobjDict.add("transformation","../elemental_geometric_shape/sys/4_info_reqs.xml#elemental_geometric_shape_arm.transformation");
applobjDict.add("trimmed_volume","../solid_model/sys/4_info_reqs.xml#solid_model_arm.trimmed_volume");
applobjDict.add("union","../set_theory/sys/4_info_reqs.xml#set_theory_arm.union");
applobjDict.add("version_iteration_relationship","../product_version_structure/sys/4_info_reqs.xml#product_version_structure_arm.version_iteration_relationship");
applobjDict.add("version_relationship","../product_version_structure/sys/4_info_reqs.xml#product_version_structure_arm.version_relationship");
applobjDict.add("version_sequence_relationship","../product_version_structure/sys/4_info_reqs.xml#product_version_structure_arm.version_sequence_relationship");
applobjDict.add("view_definition_context","../product_view_definition/sys/4_info_reqs.xml#product_view_definition_arm.view_definition_context");
applobjDict.add("view_definition_relationship","../product_view_definition_structure/sys/4_info_reqs.xml#product_view_definition_structure_arm.view_definition_relationship");
applobjDict.add("view_definition_usage","../product_view_definition_structure/sys/4_info_reqs.xml#product_view_definition_structure_arm.view_definition_usage");
applobjDict.add("work_definition","../work_order/sys/4_info_reqs.xml#work_order_arm.work_definition");
applobjDict.add("work_order","../work_order/sys/4_info_reqs.xml#work_order_arm.work_order");
applobjDict.add("work_request","../work_request/sys/4_info_reqs.xml#work_request_arm.work_request");
}


function debug(txt) {
    WScript.Echo("Dbx: " + txt);
}

function userMessage(msg){
    WScript.Echo(msg);
}


function ErrorMessage(msg){
    var objShell = WScript.CreateObject("WScript.Shell");
    WScript.Echo(msg);
    objShell.Popup(msg);
}


function xmlXMLhdr(xmlTs) {
    xmlTs.Writeline("<?xml version=\"1.0\"?>");
    xmlTs.Writeline("<!-- $Id: modImgMap2xml.js,v 1.2 2002/03/04 07:55:11 robbod Exp $ -->");
    xmlTs.Writeline("<?xml-stylesheet type=\"text\/xsl\" href=\"..\/..\/..\/xsl\/imgfile.xsl\"?>");
    xmlTs.Writeline("<!DOCTYPE imgfile.content SYSTEM \"../../../dtd/text.ent\">");
}

function xmlOpenElement(xmlElement, xmlTs) {
    var txt = indent+xmlElement;
    xmlTs.Write(txt);
    indent = indent+"  ";
}

function xmlCloseElement(xmlElement, xmlTs) {
    if (indent.length >= 2) {
	indent = indent.substr(2);
    } else {
	indent = indent+"-------";
    }
    var txt = indent+xmlElement;
    xmlTs.WriteLine(txt);
}


// Output an indented attribute.
function xmlAttr(name, value, xmlTs) {
    var txt = indent+name+"=\""+value+"\"";
    xmlTs.WriteLine();
    xmlTs.Write(txt);
}

function xmlCloseAttr(xmlTs) {
    xmlTs.WriteLine("/>");    
    if (indent.length >= 2) {
	indent = indent.substr(2);
    } else {
	indent = indent+"-------";
    }
}

function getAttribute(attr,element) {
    attr = attr.toLowerCase();
    element = element.toLowerCase();
    element =  element.replace(/\t/g," ");
    element =  element.replace(/\n/g," ");
    element =  element.replace(/\r/g," ");
    element = element.replace(/\s*=\s*/g,"=");
    var reg = new RegExp("\\b"+attr+"=","i");
    var pos = element.search(reg);
    if (pos != -1) {
	element = element.substr(pos+attr.length+2);
	element = element.replace(/\".*$/g,"");
    } else {
	element="";
    }
    return(element);
}

function elementName(element) {
    var name = "";
    var reg = /<\/.*\b/;
    name = element.match(reg);
    if (name) {
	name = null;
    } else {
	reg = /<.*\b/;
	name = element.match(reg);
	name = name.toString();
	name = name.substr(1);
	name = name.replace(/ .*/,"");
	name = name.toLowerCase();
    }
    return(name);
}

function readElement(tStream) {
    var element, inElement=0;
    while (!tStream.AtEndOfStream) {
	var c = tStream.Read(1);
	switch (c) {
	case "<" :
	    inElement=1;
	    element = element+c;
	    break;
	case ">" :
	    return(element+c);
	    break;
	default:
	    if (inElement==1)
		element = element+c;
	}
    }
    return(element);
}


function Output2xml(htmFile, xmlFile, module, title) {
    var ForReading = 1, ForWriting = 2, TristateUseDefault = -2;   
    userMessage("Reading HTML: " + htmFile);
    userMessage("Writing XML: " + xmlFile);
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    var htmF = fso.GetFile(htmFile);
    var htmTs = htmF.OpenAsTextStream(ForReading, TristateUseDefault);

    fso.CreateTextFile(xmlFile,true);
    var xmlF = fso.GetFile(xmlFile);
    var xmlTs = xmlF.OpenAsTextStream(ForWriting, TristateUseDefault);
    xmlXMLhdr(xmlTs);

    xmlOpenElement("<imgfile.content", xmlTs);
    xmlAttr("module", module, xmlTs);
    xmlAttr("title", title, xmlTs);
    xmlTs.WriteLine(">");


    while (!htmTs.AtEndOfStream) {
	var element = readElement(htmTs);
	var eName;
	if (element) {
	    eName = elementName(element);
	}
	switch (eName) {
	case "img" :
	    var imgfile = getAttribute("SRC",element);
	    xmlOpenElement("<img", xmlTs);
	    xmlAttr("src",imgfile,xmlTs);
	    xmlTs.WriteLine(">");
	    break;
	case "area" :
	    xmlOpenElement("<img.area", xmlTs);
	    var shape = getAttribute("shape",element);
	    var coords = getAttribute("coords",element);
	    var href = getAttribute("href",element);
	    xmlAttr("shape",shape,xmlTs);
	    xmlAttr("coords",coords,xmlTs);
	    href = convertHref(href,module);
	    xmlAttr("href",href,xmlTs);
	    xmlCloseAttr(xmlTs);
	    break;
	default:
	    break;
	}
    }
    xmlCloseElement("</img>", xmlTs);
    xmlCloseElement("</imgfile.content>",xmlTs);
    htmTs.Close();    
    xmlTs.Close();
}

function getApplobjHref(applobj) {
    userMessage(applobjDict.item("work_request"));
}

function convertHref(href, currentModule) {
    var nHref = '?????'+href;
    if (armOrmim == 'arm') {
	//ARM
	if (href.search('\/pdm\/') != -1) {
	    var reg = '..\/..\/pdm\/';
	    var module = href.replace(reg,'');
	    reg = /\/.*/g;
	    module = module.replace(reg,'');
	    reg = /^.*#/g;
	    var entity = href.replace(reg,'');
	    nHref = '../'+module+'/sys/4_info_reqs.xml#'+module+"_schema."+entity; }
	else if (href.search('\/properties\/') != -1) {
	    var reg = '..\/..\/properties\/';
	    var module = href.replace(reg,'');
	    reg = /\/.*/g;
	    module = module.replace(reg,'');
	    reg = /^.*#/g;
	    var entity = href.replace(reg,'');
	    nHref = '../'+module+'/sys/4_info_reqs.xml#'+module+"_schema."+entity; }
	else if (href.search('\/independent_property\/') != -1) {
	    var reg = '..\/..\/independent_property\/';
	    var module = href.replace(reg,'');
	    reg = /\/.*/g;
	    module = module.replace(reg,'');
	    reg = /^.*#/g;
	    var entity = href.replace(reg,'');
	    nHref = '../'+module+'/sys/4_info_reqs.xml#'+module+"_schema."+entity; }
	else if (href.search('\/property_assignment\/') != -1) {
	    var reg = '..\/..\/property_assignment\/';
	    var module = href.replace(reg,'');
	    reg = /\/.*/g;
	    module = module.replace(reg,'');
	    reg = /^.*#/g;
	    var entity = href.replace(reg,'');
	    nHref = '../'+module+'/sys/4_info_reqs.xml#'+module+"_schema."+entity; }
	else if (href.search('\/applobj\/') != -1) {
	    var reg = '..\/applobj\/';
	    var entity = href.replace(reg,'');
	    reg = /\.html/;
	    entity = entity.replace(reg,'');
	    nHref = applobjDict.item(entity); } 
	else if (href.search('\/appltype\/') != -1) {
	    var reg = '..\/appltype\/';
	    var type = href.replace(reg,'');
	    reg = /\.html/;
	    type = type.replace(reg,'');
	    nHref = appltypeDict.item(type); }
	else if (href.search('\/armdiag\.html') != -1) {
	    var reg = '..\/';
	    var module = href.replace(reg,'');
	    reg = /\/.*/g;
	    module = module.replace(reg,'');
	    reg = /^.*#/g;
	    var entity = href.replace(reg,'');
	    nHref = '../'+module+'/sys/4_info_reqs.xml#'+module+"_schema."+entity; }
	else if (href.search('arm\.html') != -1) {
	    var module = currentModule;
	    reg = /^.*#/g;
	    var ref = href.replace(reg,'');
	    nHref = '../'+module+'/sys/4_info_reqs.xml#'+module+"_arm."+ref; }
	else {
	    userMessage('Not converted:'+href);
	}
    } else {
	// MIM
	if (href.search('\/pdm\/') != -1) {
	    var reg = '..\/..\/pdm\/';
	    var module = href.replace(reg,'');
	    reg = /\/.*/g;
	    module = module.replace(reg,'');
	    reg = /^.*#/g;
	    var entity = href.replace(reg,'');
	    nHref = '../'+module+'/sys/5_mim.xml#'+module+"_mim."+entity;
	} else if (href.search('\/resources\/') != -1) {
	    var reg = '..\/..\/resources\/';
	    var resource = href.replace(reg,'');
	    reg = /\.html#.*/g;
	    resource = resource.replace(reg,'');
	    reg = /^.*#/g;
	    var ref = href.replace(reg,'');
	    nHref = '../../resources/'+resource+'/'+resource+'.xml'+'#'+ref; 
	}
	else if (href.search('\/mimdiag.*\.html') != -1) {
	    var reg = '..\/';
	    var module = href.replace(reg,'');
	    reg = /\/.*/g;
	    module = module.replace(reg,'');
	    reg = /^.*#/g;
	    var entity = href.replace(reg,'');
	    nHref = '../'+module+'/sys/5_mim.xml#'+module+'_mim.'+entity; 
	} else if (href.search('mim\.html') != -1) {
	    var module = currentModule;
	    reg = /^.*#/g;
	    var ref = href.replace(reg,'');
	    nHref = '../'+module+'/sys/5_mim.xml#'+module+'_mim.'+ref;
	} else {
	    userMessage('Not converted:'+href);
	}
    }
    return(nHref);
}



function testArgs() {
    var cArgs = WScript.Arguments;
    var msg="Incorrect arguments\n"+
	"  cscript imagemap2xml.js <module> <arm|mim> <imagemap.html> <file.xml> <optional title>\n";
    userMessage( cArgs(0) );
    if ( !((cArgs.length == 4) || (cArgs.length == 5)) ) {
	ErrorMessage(msg);
	return(0);    
    } else if ( (cArgs(1)=='arm') || (cArgs(1)=='mim')) {
	return(1);	

    } else {
	ErrorMessage(msg);
	return(0); 
    }
}


// ------------------------------------------------------------
// Main program
// -----------------------------------------------------------
function Main() {
    if (testArgs()==1) {
	var cArgs = WScript.Arguments;
	var module = cArgs(0);
	armOrmim = cArgs(1);
	var htmFile = cArgs(2);
	var xmlFile = cArgs(3);
	var title ="";
	if (cArgs.length == 5) 
	    title = cArgs(4);
	xmlFile='../data/modules/'+module+'/'+xmlFile;
	init();
	Output2xml(htmFile, xmlFile, module, title);
    }
}

function convertAllModulesArm() {
    init();
    armOrmim = 'arm';
    var htmFile, xmlFile, module;
    var title ='Figure C.1 ARM EXPRESS-G diagram 1 of 1';    
    var xmlbase = '../data/modules/';

    var htmbase = 'E:/My Documents/technology/stepparts/modules/BallotModulesSC4N1169/ec';
    module = 'work_request';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'work_order';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    var htmbase = 'E:/My Documents/technology/stepparts/modules/BallotModulesSC4N1169/pdm';


    module = 'alias_identification';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'approval';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'certification';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'configuration_effectivity';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'contract';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'date_time';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'date_time_assignment';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'effectivity';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'effectivity_application';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'Configuration_item';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'event';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'identification_assignment';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'part_and_version_identification';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'part_occurrence';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'part_structure';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'part_view_definition';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'person_organisation';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'person_organisation_assignment';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'product_categorisation';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'product_concept_identification';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'product_identification';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'product_structure';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'product_version';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'product_version_structure';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'product_view_definition';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'product_view_definition_structure';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'project';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'security_classification';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'time_interval';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

var htmbase = 'E:/My Documents/technology/stepparts/modules/BallotModulesSC4N1169/document_management';

    module = 'document_and_version_identification';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'document_assignment';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'document_definition';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'document_properties';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'document_structure';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'external_item_identification_assignment';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'file_identification';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'file_properties';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);


    var htmbase = 'E:/My Documents/technology/stepparts/modules/BallotModulesSC4N1169/properties';
    module = 'independent_property';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag1.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'independent_property_representation';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag1.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'independent_property_usage';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag1.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'process_property_assignment';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag1.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'product_view_definition_properties';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag1.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'product_view_definition_structure_properties';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag1.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'property_assignment';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag1.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'property_representation';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag1.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'shape_property_assignment';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag1.html';
    Output2xml(htmFile, xmlFile, module, title);
    xmlFile = xmlbase+module+'/armexpg2.xml';
    htmFile = htmbase+'/'+module+'/armdiag2.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'shape_property_representation';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag1.html';
    Output2xml(htmFile, xmlFile, module, title);
    xmlFile = xmlbase+module+'/armexpg2.xml';
    htmFile = htmbase+'/'+module+'/armdiag2.html';
    Output2xml(htmFile, xmlFile, module, title);



    var htmbase = 'E:/My Documents/technology/stepparts/modules/BallotModulesSC4N1169/representation';
    module = 'advanced_boundary_representation';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'boundary_representation_model';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'constructive_solid_geometry';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'constructive_solid_geometry_2d';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'constructive_solid_geometry_3d';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'edge_based_wireframe';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'elemental_geometric_shape';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'elemental_topology';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'faceted_boundary_representation';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'faceted_boundary_representation_model';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'foundation_representation';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'geometrically_bounded_surface';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'geometrically_bounded_wireframe';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'geometric_shape_with_topology';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'manifold_surface';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'shell_based_wireframe';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'solid_model';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'topologically_bounded_surface';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);


    var htmbase = 'E:/My Documents/technology/stepparts/modules/BallotModulesSC4N1169/val_props';
    module = 'geometric_validation_property_representation';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/armexpg1.xml';
    htmFile = htmbase+'/'+module+'/armdiag.html';
    Output2xml(htmFile, xmlFile, module, title);


}


function convertAllModulesMim() {
    init();
    armOrmim = 'mim';
    var htmFile, xmlFile, module;
    var title ='Figure C.1 MIM EXPRESS-G diagram 1 of 1';    
    var xmlbase = '../data/modules/';

    var htmbase = 'E:/My Documents/technology/stepparts/modules/BallotModulesSC4N1169/ec';
    module = 'work_request';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'work_order';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);



    var htmbase = 'E:/My Documents/technology/stepparts/modules/BallotModulesSC4N1169/pdm';


    module = 'alias_identification';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'approval';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'certification';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'configuration_effectivity';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'contract';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'date_time';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'date_time_assignment';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'effectivity';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'effectivity_application';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'Configuration_item';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'event';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'identification_assignment';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'part_and_version_identification';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'part_occurrence';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'part_structure';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'part_view_definition';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'person_organisation';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'person_organisation_assignment';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'product_categorisation';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'product_concept_identification';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'product_identification';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'product_structure';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'product_version';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'product_version_structure';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'product_view_definition';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'product_view_definition_structure';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);
    xmlFile = xmlbase+module+'/mimexpg2.xml';
    htmFile = htmbase+'/'+module+'/mimdiag2.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'project';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'security_classification';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'time_interval';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    var htmbase = 'E:/My Documents/technology/stepparts/modules/BallotModulesSC4N1169/document_management';

    module = 'document_and_version_identification';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'document_assignment';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'document_definition';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'document_properties';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'document_structure';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'external_item_identification_assignment';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'file_identification';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'file_properties';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);


    var htmbase = 'E:/My Documents/technology/stepparts/modules/BallotModulesSC4N1169/properties';
    module = 'independent_property';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag1.html';
    Output2xml(htmFile, xmlFile, module, title);
    xmlFile = xmlbase+module+'/mimexpg2.xml';
    htmFile = htmbase+'/'+module+'/mimdiag2.html';
    Output2xml(htmFile, xmlFile, module, title);
    xmlFile = xmlbase+module+'/mimexpg3.xml';
    htmFile = htmbase+'/'+module+'/mimdiag3.html';
    Output2xml(htmFile, xmlFile, module, title);
    xmlFile = xmlbase+module+'/mimexpg4.xml';
    htmFile = htmbase+'/'+module+'/mimdiag4.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'independent_property_representation';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag1.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'independent_property_usage';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag1.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'process_property_assignment';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag1.html';
    Output2xml(htmFile, xmlFile, module, title);
    xmlFile = xmlbase+module+'/mimexpg2.xml';
    htmFile = htmbase+'/'+module+'/mimdiag2.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'product_view_definition_properties';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag1.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'product_view_definition_structure_properties';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag1.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'property_assignment';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag1.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'property_representation';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag1.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'shape_property_assignment';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag1.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'shape_property_representation';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag1.html';
    Output2xml(htmFile, xmlFile, module, title);

    var htmbase = 'E:/My Documents/technology/stepparts/modules/BallotModulesSC4N1169/representation';
    module = 'advanced_boundary_representation';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'boundary_representation_model';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'constructive_solid_geometry';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'constructive_solid_geometry_2d';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'constructive_solid_geometry_3d';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'edge_based_wireframe';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'elemental_geometric_shape';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'elemental_topology';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'faceted_boundary_representation';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'faceted_boundary_representation_model';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'foundation_representation';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'geometrically_bounded_surface';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'geometrically_bounded_wireframe';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'geometric_shape_with_topology';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'manifold_surface';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'shell_based_wireframe';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'solid_model';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

    module = 'topologically_bounded_surface';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);


    var htmbase = 'E:/My Documents/technology/stepparts/modules/BallotModulesSC4N1169/val_props';
    module = 'geometric_validation_property_representation';
    userMessage(module+'\n');
    xmlFile = xmlbase+module+'/mimexpg1.xml';
    htmFile = htmbase+'/'+module+'/mimdiag.html';
    Output2xml(htmFile, xmlFile, module, title);

}

