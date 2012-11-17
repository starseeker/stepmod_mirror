*** electronic_assembly_interconnect_and_packaging_design_mim.lfepm_32_5000100006.exp	2012-11-16 14:05:04.000000000 -0600
--- patched_electronic_assembly_interconnect_and_packaging_design_mim.lfepm_32_5000100006.exp	2012-11-17 12:53:52.000000000 -0600
***************
*** 5467,5473 ****
      SUBTYPE OF (zone_structural_makeup);
    END_ENTITY;
  (* USED FROM (document_schema); *)
!   ENTITY document_product_association;
      name : label;
      description : OPTIONAL text;
      relating_document : document;
--- 5467,5474 ----
      SUBTYPE OF (zone_structural_makeup);
    END_ENTITY;
  (* USED FROM (document_schema); *)
!   ENTITY document_product_association
!     ABSTRACT SUPERTYPE; --bug #4665
      name : label;
      description : OPTIONAL text;
      relating_document : document;
***************
*** 17428,17434 ****
  (* USED FROM (systems_engineering_representation_schema); *)
  ENTITY representation_proxy_item
  SUBTYPE OF (representation_item);
!   item : representation_proxy_select;
  END_ENTITY;
  (* USED FROM (date_time_schema); *)
  ENTITY time_interval;
--- 17429,17435 ----
  (* USED FROM (systems_engineering_representation_schema); *)
  ENTITY representation_proxy_item
  SUBTYPE OF (representation_item);
! --  item : representation_proxy_select; -- bug #4668
  END_ENTITY;
  (* USED FROM (date_time_schema); *)
  ENTITY time_interval;
***************
*** 40820,40826 ****
      WHERE 
        WR1:  SIZEOF( QUERY( ac <* application_context | 
                (SIZEOF (QUERY (apd <* USEDIN(ac,'AP210_ELECTRONIC_ASSEMBLY_INTERCONNECT_AND_PACKAGING_DESIGN_MIM_LF.APPLICATION_PROTOCOL_DEFINITION.APPLICATION') | 
!                 apd.application_interpreted_model_schema_name = 'ap242_managed_model_based_3d_engineering' 
                  )) > 0) 
                )) > 0;    
   
--- 40820,40826 ----
      WHERE 
        WR1:  SIZEOF( QUERY( ac <* application_context | 
                (SIZEOF (QUERY (apd <* USEDIN(ac,'AP210_ELECTRONIC_ASSEMBLY_INTERCONNECT_AND_PACKAGING_DESIGN_MIM_LF.APPLICATION_PROTOCOL_DEFINITION.APPLICATION') | 
!                 apd.application_interpreted_model_schema_name = 'ap210_electronic_assembly_interconnect_and_packaging_design' 
                  )) > 0) 
                )) > 0;    
   
