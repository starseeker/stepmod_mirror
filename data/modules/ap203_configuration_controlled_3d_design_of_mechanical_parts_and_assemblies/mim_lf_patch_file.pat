note note note note;
hand edits of mim_lf.exp after this patch file created.
remove these hand edits before running patch!
added to geometric_rep_item:
              camera_model,
              camera_model_d3_multi_clipping_intersection,
              camera_model_d3_multi_clipping_union,
              light_source))
see bug #3048


*** ap203_configuration_controlled_3d_design_of_mechanical_parts_and_assemblies_mim.lfepm_500030206.exp	Fri Jul  3 13:20:02 2009
--- patched_ap203_configuration_controlled_3d_design_of_mechanical_parts_and_assemblies_mim.lfepm_500030206.exp	Tue Jul  7 11:43:53 2009
***************
*** 566,592 ****
  
  
  (* Pruned unused type: ir_organization_item  *)
  
  
  (* Pruned unused type: ir_person_and_organization_item  *)
  
  
  TYPE ir_usage_item = action_items;
  WHERE
!   wr1 : NOT ('INFORMATION_RIGHTS_MIM.CONFIGURATION_EFFECTIVITY' IN TYPEOF(SELF));
!   wr2 : NOT ('INFORMATION_RIGHTS_MIM.PRODUCT_DEFINITION' IN TYPEOF(SELF));
!   wr3 : NOT ('INFORMATION_RIGHTS_MIM.PRODUCT_DEFINITION_FORMATION_RELATIONSHIP' IN TYPEOF(SELF));
!   wr4 : NOT ('INFORMATION_RIGHTS_MIM.PRODUCT_DEFINITION_RELATIONSHIP' IN TYPEOF(SELF));
  END_TYPE;
  
- 
  (* Pruned unused type: effectivity_item_for_replacement  *)
  
  
  (* Pruned unused type: pdpdms_person_and_organization_item  *)
  
  
  (* Pruned unused type: pdpdms_external_identification_item  *)
  
  
  (* Pruned unused type: pdm_action_items  *)
--- 566,588 ----
  
  
  (* Pruned unused type: ir_organization_item  *)
  
  
  (* Pruned unused type: ir_person_and_organization_item  *)
  
  
  TYPE ir_usage_item = action_items;
  WHERE
!   wr1 : NOT ('AP203_CONFIGURATION_CONTROLLED_3D_DESIGN_OF_MECHANICAL_PARTS_AND_ASSEMBLIES_MIM_LF.CONFIGURATION_EFFECTIVITY' IN TYPEOF(SELF));
  END_TYPE;
  
  (* Pruned unused type: effectivity_item_for_replacement  *)
  
  
  (* Pruned unused type: pdpdms_person_and_organization_item  *)
  
  
  (* Pruned unused type: pdpdms_external_identification_item  *)
  
  
  (* Pruned unused type: pdm_action_items  *)
***************
*** 773,792 ****
--- 769,797 ----
  
    TYPE draughting_model_item_association_select = SELECT
      (annotation_occurrence,
       draughting_callout);
    END_TYPE;
  
  (* Pruned unused type: aade_annotation_representation_select  *)
  
  
  (* Pruned unused type: aade_invisibility_context  *)
+ --patch by hand--
+ TYPE annotation_representation_select = SELECT (
+    -- area_dependent_annotation_representation,
+     presentation_area,
+     presentation_view,
+     symbol_representation
+    -- view_dependent_annotation_representation
+    );
+ END_TYPE;
  
  
    TYPE draughting_model_item_select = SELECT
      (mapped_item,
       styled_item,
       axis2_placement,
       camera_model,
       draughting_callout);
    END_TYPE;  
  
***************
*** 3187,3211 ****
    WR1: ('AP203_CONFIGURATION_CONTROLLED_3D_DESIGN_OF_MECHANICAL_PARTS_AND_ASSEMBLIES_MIM_LF.B_SPLINE_SURFACE' IN TYPEOF(SELF.reference_surface)) AND
           (SELF.reference_surface\b_spline_surface.u_degree = 1);         
    WR2: ('AP203_CONFIGURATION_CONTROLLED_3D_DESIGN_OF_MECHANICAL_PARTS_AND_ASSEMBLIES_MIM_LF.PCURVE' IN TYPEOF(SELF.directrix)) OR
          (('AP203_CONFIGURATION_CONTROLLED_3D_DESIGN_OF_MECHANICAL_PARTS_AND_ASSEMBLIES_MIM_LF.B_SPLINE_CURVE' IN TYPEOF(SELF.directrix\surface_curve.curve_3d))
           AND
           (SELF.directrix\surface_curve.curve_3d\b_spline_curve.degree =
           SELF.reference_surface\b_spline_surface.v_degree));
  END_ENTITY;
  
    ENTITY compound_representation_item
!       SUPERTYPE OF ( ( ONEOF (
                 POINT_AND_VECTOR,
!                POINT_PATH) )ANDOR( (ONEOF (
                 ROW_REPRESENTATION_ITEM,
!                TABLE_REPRESENTATION_ITEM)) )  ) 
        SUBTYPE OF (representation_item);
        item_element : compound_item_definition;
    END_ENTITY;
  
    ENTITY representation;
        name             : label;
        items            : SET[1:?] OF representation_item;
        context_of_items : representation_context;
      DERIVE
        id               : identifier := get_id_value (SELF);
--- 3192,3216 ----
    WR1: ('AP203_CONFIGURATION_CONTROLLED_3D_DESIGN_OF_MECHANICAL_PARTS_AND_ASSEMBLIES_MIM_LF.B_SPLINE_SURFACE' IN TYPEOF(SELF.reference_surface)) AND
           (SELF.reference_surface\b_spline_surface.u_degree = 1);         
    WR2: ('AP203_CONFIGURATION_CONTROLLED_3D_DESIGN_OF_MECHANICAL_PARTS_AND_ASSEMBLIES_MIM_LF.PCURVE' IN TYPEOF(SELF.directrix)) OR
          (('AP203_CONFIGURATION_CONTROLLED_3D_DESIGN_OF_MECHANICAL_PARTS_AND_ASSEMBLIES_MIM_LF.B_SPLINE_CURVE' IN TYPEOF(SELF.directrix\surface_curve.curve_3d))
           AND
           (SELF.directrix\surface_curve.curve_3d\b_spline_curve.degree =
           SELF.reference_surface\b_spline_surface.v_degree));
  END_ENTITY;
  
    ENTITY compound_representation_item
!       SUPERTYPE OF (ONEOF(
                 POINT_AND_VECTOR,
!                POINT_PATH,
                 ROW_REPRESENTATION_ITEM,
!                TABLE_REPRESENTATION_ITEM)) 
        SUBTYPE OF (representation_item);
        item_element : compound_item_definition;
    END_ENTITY;
  
    ENTITY representation;
        name             : label;
        items            : SET[1:?] OF representation_item;
        context_of_items : representation_context;
      DERIVE
        id               : identifier := get_id_value (SELF);
***************
*** 5460,5493 ****
    END_ENTITY;
  
    ENTITY representation_context;
        context_identifier : identifier;
        context_type       : text;
      INVERSE
        representations_in_context : SET [1:?] OF representation FOR context_of_items;
    END_ENTITY;
  
    ENTITY representation_item
!       SUPERTYPE OF ( ( ONEOF (
                 BINARY_REPRESENTATION_ITEM,
                 COMPOUND_REPRESENTATION_ITEM,
                 MAPPED_ITEM,
!                VALUE_REPRESENTATION_ITEM) )ANDOR( ONEOF (
                 MAPPED_ITEM,
!                STYLED_ITEM) )ANDOR( (ONEOF (
                 BOOLEAN_REPRESENTATION_ITEM,
                 DATE_REPRESENTATION_ITEM,
                 DATE_TIME_REPRESENTATION_ITEM,
                 INTEGER_REPRESENTATION_ITEM,
                 LOGICAL_REPRESENTATION_ITEM,
                 RATIONAL_REPRESENTATION_ITEM,
!                REAL_REPRESENTATION_ITEM)) )  ) ;
        name : label;
      WHERE
        WR1: SIZEOF(using_representations(SELF)) > 0;
    END_ENTITY;
  
    ENTITY uncertainty_measure_with_unit
      SUBTYPE OF (measure_with_unit);
        name        : label;
        description : OPTIONAL text;
      WHERE
--- 5465,5498 ----
    END_ENTITY;
  
    ENTITY representation_context;
        context_identifier : identifier;
        context_type       : text;
      INVERSE
        representations_in_context : SET [1:?] OF representation FOR context_of_items;
    END_ENTITY;
  
    ENTITY representation_item
!       SUPERTYPE OF (ONEOF(
                 BINARY_REPRESENTATION_ITEM,
                 COMPOUND_REPRESENTATION_ITEM,
                 MAPPED_ITEM,
!                VALUE_REPRESENTATION_ITEM,
                 MAPPED_ITEM,
!                STYLED_ITEM,
                 BOOLEAN_REPRESENTATION_ITEM,
                 DATE_REPRESENTATION_ITEM,
                 DATE_TIME_REPRESENTATION_ITEM,
                 INTEGER_REPRESENTATION_ITEM,
                 LOGICAL_REPRESENTATION_ITEM,
                 RATIONAL_REPRESENTATION_ITEM,
!                REAL_REPRESENTATION_ITEM));
        name : label;
      WHERE
        WR1: SIZEOF(using_representations(SELF)) > 0;
    END_ENTITY;
  
    ENTITY uncertainty_measure_with_unit
      SUBTYPE OF (measure_with_unit);
        name        : label;
        description : OPTIONAL text;
      WHERE
***************
*** 11842,11862 ****
     SUPERTYPE OF (ONEOF (
                POLYLINE,
                B_SPLINE_CURVE,
                TRIMMED_CURVE,
                BOUNDED_PCURVE,
                BOUNDED_SURFACE_CURVE,
                COMPOSITE_CURVE))
    SUBTYPE OF (curve);
   END_ENTITY;
  
!   ENTITY founded_item;
      DERIVE
        users : SET[0:?] OF founded_item_select := using_items(SELF,[]);
      WHERE
        WR1: SIZEOF(users) > 0;
        WR2: NOT(SELF IN users);  
    END_ENTITY;
  
   ENTITY bounded_surface
     SUPERTYPE OF (ONEOF (
                B_SPLINE_SURFACE,
--- 11847,11892 ----
     SUPERTYPE OF (ONEOF (
                POLYLINE,
                B_SPLINE_CURVE,
                TRIMMED_CURVE,
                BOUNDED_PCURVE,
                BOUNDED_SURFACE_CURVE,
                COMPOSITE_CURVE))
    SUBTYPE OF (curve);
   END_ENTITY;
  
!   ENTITY founded_item
!     SUPERTYPE OF (ONEOF(
!       
!       
!       character_glyph_style_outline,
!       character_glyph_style_stroke,
!       curve_style,
!       curve_style_font,
!       curve_style_font_and_scaling,
!       curve_style_font_pattern,
!       
!       fill_area_style,
!       point_style,
!       
!       presentation_style_assignment,
!       surface_side_style,
!       surface_style_boundary,
!       surface_style_control_grid,
!       surface_style_fill_area,
!       surface_style_parameter_line,
!       surface_style_segmentation_curve,
!       surface_style_silhouette,
!       surface_style_usage,
!       
!       symbol_style,
!       text_style));
      DERIVE
        users : SET[0:?] OF founded_item_select := using_items(SELF,[]);
      WHERE
        WR1: SIZEOF(users) > 0;
        WR2: NOT(SELF IN users);  
    END_ENTITY;
  
   ENTITY bounded_surface
     SUPERTYPE OF (ONEOF (
                B_SPLINE_SURFACE,
***************
*** 16359,16379 ****
  RULE validate_dependently_instantiable_entity_data_types FOR
        (action_method_role,annotation_text,attribute_value_role,auxiliary_geometric_representation_item,binary_numeric_expression,boolean_expression,bounded_curve,bounded_surface,cartesian_transformation_operator,comparison_expression,concept_feature_relationship,concept_feature_relationship_with_condition,connected_edge_set,document_usage_constraint,edge_blended_solid,effectivity_context_role,event_occurrence_role,explicit_procedural_representation_item_relationship,expression,founded_item,generic_expression,generic_variable,indirectly_selected_elements,interval_expression,literal_number,local_time,loop,modified_solid_with_placed_configuration,multiple_arity_boolean_expression,multiple_arity_generic_expression,multiple_arity_numeric_expression,numeric_expression,one_direction_repeat_factor,oriented_open_shell,oriented_path,positioned_sketch,procedural_representation,procedural_representation_sequence,product_definition_context_role,product_definition_effectivity,runout_zone_orientation,simple_boolean_expression,simple_generic_expression,simple_numeric_expression,solid_with_depression,solid_with_hole,solid_with_pocket,solid_with_protrusion,solid_with_shape_element_pattern,solid_with_slot,swept_area_solid,symbol_target,tolerance_zone_form,two_direction_repeat_factor,unary_generic_expression,unary_numeric_expression,user_selected_elements,variational_representation_item,view_volume --<list this first and all subsequent relevant referencedentity data types here>
        );
  LOCAL
    number_of_input_instances : INTEGER;
    previous_in_chain : LIST OF GENERIC := [];
    set_of_input_types : SET OF STRING := [];
    all_instances : SET OF GENERIC := [];
  END_LOCAL;
  
!   all_instances := action_method_role + annotation_text + attribute_value_role + auxiliary_geometric_representation_item + binary_numeric_expression + boolean_expression + bounded_curve + bounded_surface + cartesian_transformation_operator + comparison_expression + concept_feature_relationship + concept_feature_relationship_with_condition + connected_edge_set + document_usage_constraint + edge_blended_solid + effectivity_context_role + event_occurrence_role + explicit_procedural_representation_item_relationship + expression + founded_item + generic_expression + generic_variable + indirectly_selected_elements + interval_expression + literal_number + local_time + loop + modified_solid_with_placed_configuration + multiple_arity_boolean_expression + multiple_arity_generic_expression + multiple_arity_numeric_expression + numeric_expression + one_direction_repeat_factor + oriented_open_shell + oriented_path + positioned_sketch + procedural_representation + procedural_representation_sequence + product_definition_context_role + product_definition_effectivity + runout_zone_orientation + simple_boolean_expression + simple_generic_expression + simple_numeric_expression + solid_with_depression + solid_with_hole + solid_with_pocket + solid_with_protrusion + solid_with_shape_element_pattern + solid_with_slot + swept_area_solid + symbol_target + tolerance_zone_form + two_direction_repeat_factor + unary_generic_expression + unary_numeric_expression + user_selected_elements + variational_representation_item + view_volume;--<make a union of all implicit populations of the FOR-clause>
  number_of_input_instances := SIZEOF(all_instances);
  (* Collect all type strings of all FOR instances into one set. *)
  REPEAT i:=1 TO number_of_input_instances;
    set_of_input_types := set_of_input_types + TYPEOF(all_instances[i]);
  END_REPEAT;
  
  WHERE
    WR1: dependently_instantiated(all_instances, set_of_input_types,
                                  previous_in_chain);
  END_RULE;
--- 16389,16409 ----
  RULE validate_dependently_instantiable_entity_data_types FOR
        (action_method_role,annotation_text,attribute_value_role,auxiliary_geometric_representation_item,binary_numeric_expression,boolean_expression,bounded_curve,bounded_surface,cartesian_transformation_operator,comparison_expression,concept_feature_relationship,concept_feature_relationship_with_condition,connected_edge_set,document_usage_constraint,edge_blended_solid,effectivity_context_role,event_occurrence_role,explicit_procedural_representation_item_relationship,expression,founded_item,generic_expression,generic_variable,indirectly_selected_elements,interval_expression,literal_number,local_time,loop,modified_solid_with_placed_configuration,multiple_arity_boolean_expression,multiple_arity_generic_expression,multiple_arity_numeric_expression,numeric_expression,one_direction_repeat_factor,oriented_open_shell,oriented_path,positioned_sketch,procedural_representation,procedural_representation_sequence,product_definition_context_role,product_definition_effectivity,runout_zone_orientation,simple_boolean_expression,simple_generic_expression,simple_numeric_expression,solid_with_depression,solid_with_hole,solid_with_pocket,solid_with_protrusion,solid_with_shape_element_pattern,solid_with_slot,swept_area_solid,symbol_target,tolerance_zone_form,two_direction_repeat_factor,unary_generic_expression,unary_numeric_expression,user_selected_elements,variational_representation_item,view_volume --<list this first and all subsequent relevant referencedentity data types here>
        );
  LOCAL
    number_of_input_instances : INTEGER;
    previous_in_chain : LIST OF GENERIC := [];
    set_of_input_types : SET OF STRING := [];
    all_instances : SET OF GENERIC := [];
  END_LOCAL;
  
!   all_instances := all_instances + action_method_role + annotation_text + attribute_value_role + auxiliary_geometric_representation_item + binary_numeric_expression + boolean_expression + bounded_curve + bounded_surface + cartesian_transformation_operator + comparison_expression + concept_feature_relationship + concept_feature_relationship_with_condition + connected_edge_set + document_usage_constraint + edge_blended_solid + effectivity_context_role + event_occurrence_role + explicit_procedural_representation_item_relationship + expression + founded_item + generic_expression + generic_variable + indirectly_selected_elements + interval_expression + literal_number + local_time + loop + modified_solid_with_placed_configuration + multiple_arity_boolean_expression + multiple_arity_generic_expression + multiple_arity_numeric_expression + numeric_expression + one_direction_repeat_factor + oriented_open_shell + oriented_path + positioned_sketch + procedural_representation + procedural_representation_sequence + product_definition_context_role + product_definition_effectivity + runout_zone_orientation + simple_boolean_expression + simple_generic_expression + simple_numeric_expression + solid_with_depression + solid_with_hole + solid_with_pocket + solid_with_protrusion + solid_with_shape_element_pattern + solid_with_slot + swept_area_solid + symbol_target + tolerance_zone_form + two_direction_repeat_factor + unary_generic_expression + unary_numeric_expression + user_selected_elements + variational_representation_item + view_volume;--<make a union of all implicit populations of the FOR-clause>
  number_of_input_instances := SIZEOF(all_instances);
  (* Collect all type strings of all FOR instances into one set. *)
  REPEAT i:=1 TO number_of_input_instances;
    set_of_input_types := set_of_input_types + TYPEOF(all_instances[i]);
  END_REPEAT;
  
  WHERE
    WR1: dependently_instantiated(all_instances, set_of_input_types,
                                  previous_in_chain);
  END_RULE;
