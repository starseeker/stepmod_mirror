<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_annex_obj_reg.xsl,v 1.1 2012/10/24 06:29:18 mikeward Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep Limited.
  Purpose: Display BOM Annex A
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <!--<xsl:import href="../sect_a_obj_reg.xsl"/>-->
  <xsl:import href="business_object_model.xsl"/>
  <xsl:import href="business_object_model_clause_nofooter.xsl"/> 
  <xsl:output method="html"/>
  
  <!--<xsl:template match="module"/>-->
  
  <xsl:template match="business_object_model">
    <xsl:call-template name="annex_header">
      <xsl:with-param name="annex_no" select="'A'"/>
      <xsl:with-param name="heading" select="'Information object registration'"/>
      <xsl:with-param name="aname" select="'annexe'"/>
      <xsl:with-param name="informative" select="'normative'"/>
    </xsl:call-template>
    <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ_</xsl:variable>
    <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz-</xsl:variable>
    <xsl:variable name="bo_model_dir" select="./@name"/>
      
<!--
    <xsl:variable name="arm_xml" select="concat($ap_module_dir,'/arm.xml')"/>
    <xsl:variable name="aim_xml" select="concat($ap_module_dir,'/mim.xml')"/>
    <xsl:variable name="schema_name" select="document($arm_xml)/express/schema/@name"/>
    <xsl:variable name="module_xml" select="document(concat($ap_module_dir,'/module.xml'))"/>		
-->
    <xsl:variable name="bom_dir" select="./@name"/>
    <xsl:variable name="bom_xml" select="concat('../../data/business_object_models/', $bom_dir,'/bom.xml')"/>

  <xsl:variable name="object_reg">
    <xsl:choose>
	  <xsl:when test="@object.reg.version"> 
	    <xsl:value-of  select="concat('{ iso standard 10303 part(',@part,') version(',@object.reg.version,')')"/> 
	  </xsl:when>
      <xsl:otherwise>
        <xsl:value-of  select="concat('{ iso standard 10303 part(',@part,') version(',@version,')')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


    <h2>
      <a name="a1">
        A.1 Document identification
      </a>
    </h2>

    <p>
      To provide for unambiguous identification of an information object in
      an open system, the object identifier
    </p>
    <p align="center">
      <xsl:value-of select="concat($object_reg,' }' )"/>
    </p>
    <p>
      is assigned to this part of ISO 10303. The meaning of this value is
      defined in ISO/IEC 8824-1, and is described in ISO 10303-1.
    </p>

    <h2>
      <a name="A2">
        A.2 Schema identification
      </a>
    </h2>
		
    <xsl:variable name="bom_schema" select="document($bom_xml)/express/schema/@name"/>
   <xsl:variable name="bom_schema_reg" select="translate($bom_schema,$UPPER, $LOWER)"/>

    <h2>
      <a name="a21">
        A.2.1 <xsl:value-of select="$bom_schema"/> schema identification
      </a>
    </h2>
   <p>
      To provide for unambiguous identification of the schema
      specifications given in this application module in an open information
      system, the object identifiers are assigned as follows: 
   </p>
   
   <p align="center">
      <xsl:value-of select="concat($object_reg,' schema(1) ', $bom_schema_reg,'(1) }' )"/>
    </p>
    <p>
      is assigned to the <xsl:value-of select="$bom_schema"/> schema. The
      meaning of this value is defined in ISO 8824-1, and is described in ISO
      10303-1. 
    </p>
    <!--  

    
    <p>
      To provide for unambiguous identification of the schema
      specifications given in this application module in an open information
      system, the object identifiers are assigned as follows: 
    </p>
    <p align="center">
      <xsl:value-of select="concat($object_reg,' schema(1) ', $aim_schema_reg,'(2) }' )"/>
    </p>
    <p>
      is assigned to the 
      <xsl:value-of select="substring-before($aim_schema, '_mim')"/>_mim schema. The meaning of
      this value is defined in ISO 8824-1, and is described in  ISO 10303-1.
    </p>

  <xsl:if test="$module_xml//arm_lf">
   <xsl:variable name="arm_lf_xml" select="concat($ap_module_dir,'/arm_lf.xml')"/>
    <xsl:variable name="arm_schema_lf" select="document($arm_lf_xml)/express/schema/@name"/>
    <xsl:variable name="arm_schema_lf_reg" select="translate($arm_schema_lf,$UPPER, $LOWER)"/>

    <h2>
      <a name="e23">
        E.2.3 <xsl:value-of select="$arm_schema_lf"/> schema identification
      </a>
    </h2>

    <p>
      To provide for unambiguous identification of the schema specifications
      given in this application module in an open information system, the object
      identifiers are assigned as follows: 
    </p>
    <p align="center">
      <xsl:value-of 
        select="concat($object_reg,' schema(1) ', $arm_schema_lf_reg,'(3) }' )"/>
    </p>
    <p>
      is assigned to the <xsl:value-of select="$arm_schema_lf"/> schema. 
      The meaning of this value is defined in ISO 8824-1, and is described in
      ISO 10303-1.
    </p>
  </xsl:if>

  <xsl:if test="$module_xml//mim_lf">
   <xsl:variable name="mim_lf_xml" select="concat($ap_module_dir,'/mim_lf.xml')"/>
    <xsl:variable name="mim_schema_lf"  select="document($mim_lf_xml)/express/schema/@name"/>
    <xsl:variable name="mim_schema_lf_reg"  select="translate($mim_schema_lf,$UPPER, $LOWER)"/>
    
    <h2>
      <a name="e24">
       E.2.4 <xsl:value-of select="$mim_schema_lf"/> schema identification
     </a>
    </h2>

    <p>
      To provide for unambiguous identification of the schema specifications
      given in this application module in an open information system, the object
      identifiers are assigned as follows: 
    </p>
    <p align="center">
      <xsl:value-of 
        select="concat($object_reg,' schema(1) ', $mim_schema_lf_reg,'(4) }' )"/>
    </p>
    <p>
      is assigned to the <xsl:value-of select="$mim_schema_lf"/> schema. 
      The meaning of this value is defined in ISO 8824-1, and is described in
      ISO 10303-1.
    </p>
  </xsl:if>

-->
  </xsl:template>
	
</xsl:stylesheet>
