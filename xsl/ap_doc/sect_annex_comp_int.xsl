<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_annex_comp_int.xsl,v 1.1 2003/05/28 14:34:04 robbod Exp $
  Author:  Mike Ward, Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: 
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../sect_e_exp.xsl"/>
  <xsl:import href="application_protocol.xsl"/>
  <xsl:import href="application_protocol_clause.xsl"/>
  <xsl:output method="html"/>
	
  <xsl:template match="application_protocol">
    <xsl:apply-templates select="." mode="annexg"/>	
  </xsl:template>
  

<!-- Annex G -->
<xsl:template match="application_protocol" mode="annexg">
  <xsl:variable name="annex_list">
    <xsl:apply-templates select="." mode="annex_list"/>
  </xsl:variable>
  
  <xsl:variable name="annex_letter">
    <xsl:call-template name="annex_letter" >
      <xsl:with-param name="annex_name" select="'computerinterpretablelisting'"/>
      <xsl:with-param name="annex_list" select="$annex_list"/>
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:call-template name="annex_header">
    <xsl:with-param name="annex_no" select="$annex_letter"/>
    <xsl:with-param name="heading" select="'Computer interpretable listings'"/>
    <xsl:with-param name="aname" select="'annexg'"/>
  </xsl:call-template>
  
  <xsl:variable name="module" select="@module_name"/>
  <xsl:variable name="module_ok">
    <xsl:call-template name="check_module_exists">
      <xsl:with-param name="module" select="$module"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$module_ok!='true'">
    <xsl:call-template name="error_message">
      <xsl:with-param name="message">
        <xsl:value-of select="concat('Error AP1: The module ',$module,' does not exist.',
                              '  Correct application_protocol module_name in application_protocol.xml')"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:if>
  <xsl:variable name="module_dir">
    <xsl:call-template name="ap_module_directory">
      <xsl:with-param name="application_protocol" select="$module"/>
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:variable name="module_xml" select="document(concat($module_dir,'/module.xml'))"/>
  <xsl:apply-templates select="$module_xml/module" mode="annexe"/>
	</xsl:template>

	
</xsl:stylesheet>
