<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: sect_e_exp.xsl,v 1.1 2001/10/22 09:31:59 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: Display the  express for an Integrated Resource schema
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">


  <xsl:import href="express_code.xsl"/>

  <xsl:output method="html"/>

  <xsl:variable name="global_xref_list">
    <!-- debug  -->
    <xsl:message>
      global_xref_list defined in resource_exp.xsl
    </xsl:message>
    <xsl:call-template name="build_xref_list">
      <xsl:with-param name="express" select="/express"/>
    </xsl:call-template>
  </xsl:variable>


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
    <h3>
      <xsl:value-of select="concat('Schema: ',./express/schema/@name)"/>
    </h3>

    <xsl:apply-templates select="./express/schema" mode="code"/>
    </BODY>
  </HTML>
</xsl:template>



  
</xsl:stylesheet>
