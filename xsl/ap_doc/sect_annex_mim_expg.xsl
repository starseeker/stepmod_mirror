<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_annex_arm_expg.xsl,v 1.2 2003/06/01 13:57:53 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
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
        <xsl:with-param name="annex_name" select="'MIMexpressG'"/>
        <xsl:with-param name="annex_list" select="$annex_list"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:call-template name="annex_header">
      <xsl:with-param name="annex_no" select="$annex_letter"/>
      <xsl:with-param name="heading" select="'MIM EXPRESS-G'"/>
      <xsl:with-param name="aname" select="'annexf'"/>
    </xsl:call-template>
    
    <p>
      THE XSL HAS NOT BEEN IMPLEMENTED
      sect_annex_mim_expg.xsl
    </p>
  </xsl:template>
	
</xsl:stylesheet>
