<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_annex_changes.xsl,v 1.1 2003/05/28 14:34:04 robbod Exp $
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
        <xsl:with-param name="annex_name" select="'changedetail'"/>
        <xsl:with-param name="annex_list" select="$annex_list"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:call-template name="annex_header">
      <xsl:with-param name="annex_no" select="$annex_letter"/>
      <xsl:with-param name="heading" select="'Detailed changes'"/>
      <xsl:with-param name="aname" select="'annex_changes'"/>
      <xsl:with-param name="informative" select="'informative'"/>
    </xsl:call-template>

    <xsl:apply-templates select="./changes/change_detail"/>
  </xsl:template>

  <xsl:template match="change_detail">
    This annex provides a description of the technical changes from the
    previous version of 
    ISO 10303-203 

    <xsl:variable name="prev_edition">
      <xsl:apply-templates select="/application_protocol" mode="previous_edition"/>
    </xsl:variable>

    (<xsl:value-of 
    select="concat(/application_protocol/@previous.revision.number,' : ', /application_protocol/@previous.revision.year)"/>).
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>
