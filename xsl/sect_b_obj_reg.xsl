<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_b_obj_reg.xsl,v 1.5 2002/03/21 10:30:34 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="module.xsl"/>

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
  <xsl:import href="module_clause.xsl"/>


  <xsl:output method="html"/>

<!-- overwrites the template declared in module.xsl -->
<xsl:template match="module">
  <xsl:call-template name="annex_header">
    <xsl:with-param name="annex_no" select="'B'"/>
    <xsl:with-param name="heading" 
      select="'Information object registration'"/>
    <xsl:with-param name="aname" select="'annexb'"/>
    <xsl:with-param name="informative" select="'normative'"/>
  </xsl:call-template>

  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ_</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz-</xsl:variable>
  
  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="arm_xml"
    select="concat($module_dir,'/arm.xml')"/>

  <xsl:variable name="mim_xml"
    select="concat($module_dir,'/mim.xml')"/>

  <!-- there is only one schema in a module -->
  <xsl:variable 
    name="schema_name" 
    select="document($arm_xml)/express/schema/@name"/>

  <xsl:variable
    name="object_reg" 
    select="concat('{ iso standard 10303 part(',@part,') version(',@version,')')"/>
  <h3>B.1 Document Identification </h3>
  To provide for unambiguous identification of an information object in an
  open system, the object identifier
  <p align="center">
    <xsl:value-of 
      select="concat($object_reg,' }' )"/>
  </p>
  is assigned to this part of ISO 10303. The meaning of this value is defined
  in ISO/IEC 8824-1, and is described in ISO 10303-1.  

  <h3>B.2 Schema identification</h3>
  <!-- get the name of the ARM schema from the express -->
  <xsl:variable name="arm_schema" 
    select="document($arm_xml)/express/schema/@name"/>
  <xsl:variable name="arm_schema_reg" 
    select="translate($arm_schema,$UPPER, $LOWER)"/>


  <h3>B.2.1 <xsl:value-of select="$arm_schema"/> schema identification</h3>

  <p>
    To provide for unambiguous identification of the schema specifications
    given in this application module in an open information system, the object
    identifiers are assigned as follows: 
  </p>
  <p align="center">
    <xsl:value-of 
      select="concat($object_reg,' object(1) ', $arm_schema_reg,'(1) }' )"/>
  </p>
  <p>
    is assigned to the <xsl:value-of select="$arm_schema"/> schema. 
    The meaning of this value is defined in ISO 8824-1, and is described in
    ISO 10303-1.  
  </p>

  <!-- get the name of the MIM schema from the express -->
  <xsl:variable name="mim_schema" 
    select="document($mim_xml)/express/schema/@name"/>
  <xsl:variable name="mim_schema_reg" 
    select="translate($mim_schema,$UPPER, $LOWER)"/>

  <h3>B.2.2 <xsl:value-of select="$mim_schema"/> schema identification</h3>

  <p>
    To provide for unambiguous identification of the schema specifications
    given in this application module in an open information system, the object
    identifiers are assigned as follows: 
  </p>
  <p align="center">
    <xsl:value-of 
      select="concat($object_reg,' object(1) ', $mim_schema_reg,'(2) }' )"/>
  </p>
  <p>
    is assigned to the <xsl:value-of select="$mim_schema"/> schema. 
    The meaning of this value is defined in ISO 8824-1, and is described in
    ISO 10303-1.  
  </p>

</xsl:template>
  
</xsl:stylesheet>
