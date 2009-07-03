*** ap203_configuration_controlled_3d_design_of_mechanical_parts_and_assemblies_arm.lfepm_500030206.exp	Fri Jul  3 13:19:50 2009
--- patched_ap203_configuration_controlled_3d_design_of_mechanical_parts_and_assemblies_arm.lfepm_500030206.exp	Fri Jul  3 13:17:42 2009
***************
***************
*** 3850,3912 ****
        multiplication_matrix : ARRAY[1:3] OF Direction;
        translation           : Cartesian_point;
      WHERE
        WR1: SIZEOF(multiplication_matrix[1]\Direction.coordinates)=3;
        WR2: SIZEOF(multiplication_matrix[2]\Direction.coordinates)=3;
        WR3: SIZEOF(multiplication_matrix[3]\Direction.coordinates)=3;
        WR4: SIZEOF(translation.coordinates)=3;
    END_ENTITY;
  
    ENTITY Detailed_geometric_model_element
!       ABSTRACT SUPERTYPE OF ( ( ONEOF (
!                         CARTESIAN_POINT,
!                         DIRECTION,
!                         AXIS_PLACEMENT,
!                         CARTESIAN_TRANSFORMATION_2D,
!                         CARTESIAN_TRANSFORMATION_3D) )ANDOR( ONEOF (
!                         CLIPPING_OPERATOR,
!                         MODEL_IMAGE_3D,
!                         LIGHT_SOURCE,
!                         CAMERA_MODEL_D3) )ANDOR( ONEOF (
!                         CARTESIAN_POINT,
!                         DIRECTION,
!                         AXIS_PLACEMENT,
!                         CARTESIAN_TRANSFORMATION_2D,
!                         CARTESIAN_TRANSFORMATION_3D,
!                         CURVE,
!                         POINT_ON_CURVE,
!                         POINT_ON_SURFACE,
!                         SURFACE) )ANDOR( ONEOF (
!                         COMPOSITE_PRESENTABLE_TEXT,
!                         TEXT_LITERAL) )ANDOR( ONEOF (
!                         CAMERA_MODEL_D2,
!                         CAMERA_IMAGE_2D_WITH_SCALE) )ANDOR( ONEOF (
!                         POINT_AND_VECTOR,
!                         POINT_PATH) )ANDOR( ONEOF (
                          ADVANCED_FACE,
                          AXIS_PLACEMENT,
                          CARTESIAN_POINT,
                          CARTESIAN_TRANSFORMATION_2D,
                          CARTESIAN_TRANSFORMATION_3D,
!                         DIRECTION,
!                         SOLID_MODEL_ELEMENT) )ANDOR( ONEOF (
!                         CARTESIAN_POINT,
!                         DIRECTION,
!                         AXIS_PLACEMENT,
!                         CARTESIAN_TRANSFORMATION_2D,
!                         CARTESIAN_TRANSFORMATION_3D,
                          CURVE,
!                         GEOMETRIC_MODEL_ELEMENT_RELATIONSHIP,
                          POINT_ON_CURVE,
                          POINT_ON_SURFACE,
                          SURFACE,
!                         VECTOR) )  ) 
    SUBTYPE OF (Representation_item);
    END_ENTITY;
  
    ENTITY Direction
      SUBTYPE OF (Detailed_geometric_model_element);
        coordinates : LIST[2:3] OF length_measure;  
    END_ENTITY;
  
    ENTITY Geometric_coordinate_space
      SUBTYPE OF (Numerical_representation_context);
--- 3850,3893 ----
        multiplication_matrix : ARRAY[1:3] OF Direction;
        translation           : Cartesian_point;
      WHERE
        WR1: SIZEOF(multiplication_matrix[1]\Direction.coordinates)=3;
        WR2: SIZEOF(multiplication_matrix[2]\Direction.coordinates)=3;
        WR3: SIZEOF(multiplication_matrix[3]\Direction.coordinates)=3;
        WR4: SIZEOF(translation.coordinates)=3;
    END_ENTITY;
  
    ENTITY Detailed_geometric_model_element
!       ABSTRACT SUPERTYPE OF (ONEOF(
                          ADVANCED_FACE,
                          AXIS_PLACEMENT,
+                         CAMERA_MODEL_D2,
+                         CAMERA_IMAGE_2D_WITH_SCALE,
+                         CAMERA_MODEL_D3,
                          CARTESIAN_POINT,
                          CARTESIAN_TRANSFORMATION_2D,
                          CARTESIAN_TRANSFORMATION_3D,
!                         CLIPPING_OPERATOR,
!                         COMPOSITE_PRESENTABLE_TEXT,
                          CURVE,
!                         DIRECTION,
!                         LIGHT_SOURCE,
!                         MODEL_IMAGE_3D,
!                         POINT_AND_VECTOR,
                          POINT_ON_CURVE,
                          POINT_ON_SURFACE,
+                         POINT_PATH,
+                         SOLID_MODEL_ELEMENT,
                          SURFACE,
!                         TEXT_LITERAL,
!                         GEOMETRIC_MODEL_ELEMENT_RELATIONSHIP,
!                         VECTOR))
    SUBTYPE OF (Representation_item);
    END_ENTITY;
  
    ENTITY Direction
      SUBTYPE OF (Detailed_geometric_model_element);
        coordinates : LIST[2:3] OF length_measure;  
    END_ENTITY;
  
    ENTITY Geometric_coordinate_space
      SUBTYPE OF (Numerical_representation_context);
***************
*** 3940,3971 ****
  END_ENTITY;
  
  ENTITY Representation_context;
    id : STRING;
    kind : STRING;
  INVERSE
    representations_in_context : SET[1:?] OF Representation FOR context_of_items;
  END_ENTITY;
  
  ENTITY Representation_item
!     ABSTRACT SUPERTYPE OF ( ( ONEOF (
!                         STYLED_ELEMENT,
!                         STYLED_MODEL_REPLICATION) )ANDOR( (ONEOF (
!                         CHARACTERISTIC_DATA_TABLE,
!                         CHARACTERISTIC_DATA_TABLE_ROW)) )ANDOR( (ONEOF (
                          BOOLEAN_REPRESENTATION_ITEM,
                          COMPOUND_REPRESENTATION_ITEM,
                          DATE_TIME_REPRESENTATION_ITEM,
                          INTEGER_REPRESENTATION_ITEM,
                          LOGICAL_REPRESENTATION_ITEM,
                          RATIONAL_REPRESENTATION_ITEM,
!                         REAL_REPRESENTATION_ITEM)) )  ) ;
    name : OPTIONAL STRING;
  END_ENTITY;
  
  ENTITY Representation_relationship;
    relation_type : OPTIONAL STRING;
    description : OPTIONAL STRING;
    rep_1 : Representation;
    rep_2 : Representation;
  WHERE
    WR1 : EXISTS(relation_type) OR (TYPEOF(SELF\Representation_relationship) <> TYPEOF(SELF));
--- 3921,3952 ----
  END_ENTITY;
  
  ENTITY Representation_context;
    id : STRING;
    kind : STRING;
  INVERSE
    representations_in_context : SET[1:?] OF Representation FOR context_of_items;
  END_ENTITY;
  
  ENTITY Representation_item
!     ABSTRACT SUPERTYPE OF (ONEOF(
                          BOOLEAN_REPRESENTATION_ITEM,
+                         CHARACTERISTIC_DATA_TABLE,
+                         CHARACTERISTIC_DATA_TABLE_ROW,
                          COMPOUND_REPRESENTATION_ITEM,
                          DATE_TIME_REPRESENTATION_ITEM,
                          INTEGER_REPRESENTATION_ITEM,
                          LOGICAL_REPRESENTATION_ITEM,
                          RATIONAL_REPRESENTATION_ITEM,
!                         STYLED_ELEMENT,
!                         REAL_REPRESENTATION_ITEM,
!                         STYLED_MODEL_REPLICATION));
    name : OPTIONAL STRING;
  END_ENTITY;
  
  ENTITY Representation_relationship;
    relation_type : OPTIONAL STRING;
    description : OPTIONAL STRING;
    rep_1 : Representation;
    rep_2 : Representation;
  WHERE
    WR1 : EXISTS(relation_type) OR (TYPEOF(SELF\Representation_relationship) <> TYPEOF(SELF));
***************
*** 4168,4192 ****
        values : SET[1:?] OF Measure_item;
    END_ENTITY;
  
    ENTITY Value_with_tolerances
      SUBTYPE OF (Measure_item);
        item_value : Numerical_item_with_unit;
        lower_limit : REAL;
        upper_limit : REAL;
    END_ENTITY;
  
! ENTITY Independent_property  SUPERTYPE OF ( ( ONEOF (
                 CHARACTERISTIC_DATA_TABLE_HEADER,
!                CHARACTERISTIC_DATA_COLUMN_HEADER) )ANDOR( ONEOF (
                 PLIB_PROPERTY_REFERENCE,
!                EXTERNAL_LIBRARY_PROPERTY) )  ) ;
    id : STRING;
    property_type : STRING;
    description : OPTIONAL STRING;
  END_ENTITY;
  
  ENTITY Independent_property_relationship;
    relation_type : STRING;
    description : OPTIONAL STRING;
    relating : Independent_property;
    related : Independent_property;
--- 4149,4173 ----
        values : SET[1:?] OF Measure_item;
    END_ENTITY;
  
    ENTITY Value_with_tolerances
      SUBTYPE OF (Measure_item);
        item_value : Numerical_item_with_unit;
        lower_limit : REAL;
        upper_limit : REAL;
    END_ENTITY;
  
! ENTITY Independent_property  SUPERTYPE OF (ONEOF(
                 CHARACTERISTIC_DATA_TABLE_HEADER,
!                CHARACTERISTIC_DATA_COLUMN_HEADER,
                 PLIB_PROPERTY_REFERENCE,
!                EXTERNAL_LIBRARY_PROPERTY));
    id : STRING;
    property_type : STRING;
    description : OPTIONAL STRING;
  END_ENTITY;
  
  ENTITY Independent_property_relationship;
    relation_type : STRING;
    description : OPTIONAL STRING;
    relating : Independent_property;
    related : Independent_property;
***************
*** 6137,6160 ****
    END_ENTITY;
  
    ENTITY Standard_uncertainty
      SUPERTYPE OF (
                EXPANDED_UNCERTAINTY)
    SUBTYPE OF (Uncertainty_qualifier);
        uncertainty_value : REAL;
    END_ENTITY;
  
    ENTITY Type_qualifier
!       ABSTRACT SUPERTYPE OF ( ( 
!                         PRE_DEFINED_TYPE_QUALIFIER )ANDOR( ONEOF (
                          EXTERNALLY_DEFINED_TYPE_QUALIFIER,
!                         PRE_DEFINED_TYPE_QUALIFIER) )  ) ;
      name : STRING;
    END_ENTITY;
  
    ENTITY Uncertainty_qualifier
      SUPERTYPE OF (ONEOF (
                STANDARD_UNCERTAINTY,
                QUALITATIVE_UNCERTAINTY));
        measure_name : STRING; 
        description  : STRING; 
    END_ENTITY;
--- 6118,6140 ----
    END_ENTITY;
  
    ENTITY Standard_uncertainty
      SUPERTYPE OF (
                EXPANDED_UNCERTAINTY)
    SUBTYPE OF (Uncertainty_qualifier);
        uncertainty_value : REAL;
    END_ENTITY;
  
    ENTITY Type_qualifier
!       ABSTRACT SUPERTYPE OF (ONEOF(
                          EXTERNALLY_DEFINED_TYPE_QUALIFIER,
!                         PRE_DEFINED_TYPE_QUALIFIER));
      name : STRING;
    END_ENTITY;
  
    ENTITY Uncertainty_qualifier
      SUPERTYPE OF (ONEOF (
                STANDARD_UNCERTAINTY,
                QUALITATIVE_UNCERTAINTY));
        measure_name : STRING; 
        description  : STRING; 
    END_ENTITY;
***************
*** 7044,7069 ****
                          PROJECTION_CURVE,
                          DIMENSION_CURVE)
                          ANDOR (
                          GENERIC_ANNOTATION_CURVE)) ) 
    SUBTYPE OF (Annotation_element);
        annotation_curve_type       : OPTIONAL STRING;
        SELF\Styled_element.element : Curve;
    END_ENTITY;
  
    ENTITY Annotation_element 
!       SUPERTYPE OF ( ( ONEOF (
                 TEXT,
!                ANNOTATION_CURVE) )ANDOR( ONEOF (
                 ANNOTATION_SUBFIGURE,
                 ANNOTATION_SYMBOL,
!                FILL_AREA) )  ) 
    SUBTYPE OF (Detailed_geometric_model_element, Styled_element);
    END_ENTITY;
  
    ENTITY Annotation_text
      SUBTYPE OF (Detailed_geometric_model_element);
        replicated_model : Text_string_representation;
        source           : Axis_placement;
        target           : Axis_placement;
    END_ENTITY;
  
--- 7024,7049 ----
                          PROJECTION_CURVE,
                          DIMENSION_CURVE)
                          ANDOR (
                          GENERIC_ANNOTATION_CURVE)) ) 
    SUBTYPE OF (Annotation_element);
        annotation_curve_type       : OPTIONAL STRING;
        SELF\Styled_element.element : Curve;
    END_ENTITY;
  
    ENTITY Annotation_element 
!       SUPERTYPE OF (ONEOF(
                 TEXT,
!                ANNOTATION_CURVE,
                 ANNOTATION_SUBFIGURE,
                 ANNOTATION_SYMBOL,
!                FILL_AREA)) 
    SUBTYPE OF (Detailed_geometric_model_element, Styled_element);
    END_ENTITY;
  
    ENTITY Annotation_text
      SUBTYPE OF (Detailed_geometric_model_element);
        replicated_model : Text_string_representation;
        source           : Axis_placement;
        target           : Axis_placement;
    END_ENTITY;
  
***************
*** 7320,7345 ****
    ENTITY Silhouette_curve_appearance
      SUBTYPE OF (Surface_related_curve_appearance);
    END_ENTITY;
  
    ENTITY Surface_appearance;
      side   : surface_side;    
      styles : SET[1:7] OF Surface_appearance_element;
    END_ENTITY;
  
    ENTITY Surface_appearance_element
!       ABSTRACT SUPERTYPE OF ( ( ONEOF (
!                         SURFACE_RELATED_CURVE_APPEARANCE,
!                         SURFACE_COLOUR) )ANDOR( ONEOF (
                          SURFACE_COLOUR,
                          SURFACE_RELATED_CURVE_APPEARANCE,
!                         SURFACE_STYLE_RENDERING) )  ) ; 
    END_ENTITY;
  
    ENTITY Surface_colour 
      SUBTYPE OF (Surface_appearance_element);
        assigned_colour : Colour;
    END_ENTITY;
  
    ENTITY Surface_related_curve_appearance 
       ABSTRACT SUPERTYPE OF (ONEOF (
                          BOUNDARY_CURVE_APPEARANCE,
--- 7300,7323 ----
    ENTITY Silhouette_curve_appearance
      SUBTYPE OF (Surface_related_curve_appearance);
    END_ENTITY;
  
    ENTITY Surface_appearance;
      side   : surface_side;    
      styles : SET[1:7] OF Surface_appearance_element;
    END_ENTITY;
  
    ENTITY Surface_appearance_element
!       ABSTRACT SUPERTYPE OF (ONEOF(
                          SURFACE_COLOUR,
                          SURFACE_RELATED_CURVE_APPEARANCE,
!                         SURFACE_STYLE_RENDERING)); 
    END_ENTITY;
  
    ENTITY Surface_colour 
      SUBTYPE OF (Surface_appearance_element);
        assigned_colour : Colour;
    END_ENTITY;
  
    ENTITY Surface_related_curve_appearance 
       ABSTRACT SUPERTYPE OF (ONEOF (
                          BOUNDARY_CURVE_APPEARANCE,
