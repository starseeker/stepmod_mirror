<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_g_exp.xsl,v 1.8 2003/05/27 07:34:15 robbod Exp $
  Author:  Mike Ward, Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: 
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="application_protocol.xsl"/>
  <xsl:import href="application_protocol_clause.xsl"/>
  <xsl:output method="html"/>
  
	
  <xsl:template match="application_protocol">
    <xsl:variable name="annex_list">
      <xsl:apply-templates select="." mode="annex_list"/>
    </xsl:variable>
    
    <xsl:variable name="annex_letter">
      <xsl:call-template name="annex_letter" >
        <xsl:with-param name="annex_name" select="'usageguide'"/>
        <xsl:with-param name="annex_list" select="$annex_list"/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:call-template name="annex_header">
      <xsl:with-param name="annex_no" select="$annex_letter"/>
      <xsl:with-param name="heading" select="'Application protocol implementation guide'"/>
      <xsl:with-param name="aname" select="'annexh'"/>
    </xsl:call-template>
    <xsl:apply-templates select="usage_guide"/>
  </xsl:template>
  

<xsl:template match="usage_guide">
  <xsl:apply-templates/>
  <!-- output any issues -->
  <xsl:apply-templates select=".." mode="output_clause_issue">
    <xsl:with-param name="clause" select="'usage_guide'"/>
  </xsl:apply-templates>
</xsl:template>
	
</xsl:stylesheet>
