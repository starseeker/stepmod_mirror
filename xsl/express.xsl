<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: express.xsl,v 1.5 2001/11/21 08:11:54 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: Display the  express for an Integrated Resource schema
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">


  <xsl:import href="express_code.xsl"/>

  <xsl:output method="html"/>

  <!-- +++++++++++++++++++
         Global variables
       +++++++++++++++++++ -->

  <!-- 
       Global variable used in express_link.xsl by:
         link_object
         link_list
       Provides a lookup table of all the references for the entities and
       types indexed through all the interface specifications in the
       express.
       Note:  This variable must defined in each XSL that is used for
       formatting express.
         sect_4_info.xsl
         sect_5_mim.xsl
         sect_e_exp_arm.xsl
         sect_e_exp_mim.xsl
       build_xref_list is defined in express_link
       -->
  <xsl:variable name="global_xref_list">
    <!-- debug  
    <xsl:message>
      global_xref_list defined in resource_exp.xsl
    </xsl:message> -->
    <xsl:call-template name="build_xref_list">
      <xsl:with-param name="express" select="/express"/>
    </xsl:call-template>
  </xsl:variable>

  
  <!-- A global variable used by the express_file_to_ref template defined
       in express_link.xsl.
       It defines the relative path from the file applying the stylesheet
       to the root of the stepmod repository.
       Express.xsl stylesheet is normally used
         stepmod/data/module/?module?/arm.xml
         stepmod/data/module/?module?/mim.xml
         stepmod/data/module/?module?/mim_lf.xml
         stepmod/data/module/?resource_schema?/?resource_schema?.xml
       Hence the relative root is: ../../../
       -->
  <xsl:variable 
    name="relative_root"
    select="'../../../'"/>

  <!-- +++++++++++++++++++
         Templates
       +++++++++++++++++++ -->

<!-- overwrites the template declared in module.xsl -->
<xsl:template match="/">
  <HTML>
    <HEAD>
      <xsl:apply-templates select="./application" mode="meta"/>
        <!-- apply a cascading stylesheet.
             the stylesheet will only be applied if the parameter output_css
             is set in parameter.xsl 
             -->
      <xsl:call-template name="output_css">
        <xsl:with-param name="path" select="'../../../css/'"/>
      </xsl:call-template>
      <TITLE>Integrated Resource: <xsl:value-of select="./express/schema/@name"/></TITLE>
    </HEAD>
    <BODY>  
  <!-- debug <xsl:value-of select="$global_xref_list"/> -->
    <h3>
      <xsl:value-of select="concat('Schema: ',./express/schema/@name)"/>
    </h3>

    <xsl:apply-templates select="./express/schema" mode="code"/>
    </BODY>
  </HTML>
</xsl:template>


<xsl:template match="express" >
  <HTML>
    <HEAD>
      <xsl:apply-templates select="./application" mode="meta"/>
        <!-- apply a cascading stylesheet.
             the stylesheet will only be applied if the parameter output_css
             is set in parameter.xsl 
             -->
      <xsl:call-template name="output_css">
        <xsl:with-param name="path" select="'../../../css/'"/>
      </xsl:call-template>
      <TITLE></TITLE>
    </HEAD>
    <BODY>  
    <xsl:apply-templates select="./schema" mode="code"/>
    </BODY>
  </HTML>
</xsl:template>




  
</xsl:stylesheet>
