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
        <xsl:with-param name="annex_name" select="'tech_disc'"/>
        <xsl:with-param name="annex_list" select="$annex_list"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:call-template name="annex_letter" >
      <xsl:with-param name="annex_no" select="$annex_letter"/>
      <xsl:with-param name="heading" select="'Technical discussion'"/>
      <xsl:with-param name="aname" select="'annexj'"/>
    </xsl:call-template>

    <xsl:apply-templates select="tech_disc"/>
  </xsl:template>
	
</xsl:stylesheet>
