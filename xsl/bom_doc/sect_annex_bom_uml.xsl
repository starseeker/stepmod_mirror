<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_annex_arm_expg.xsl,v 1.2 2003/06/01 13:57:53 mikeward Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose:  Display Annex D for a BOM document.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="business_object_model.xsl"/>
  <xsl:import href="business_object_model_clause.xsl"/>
  <xsl:output method="html"/>
  
  <xsl:template match="business_object_model">
    
    <xsl:call-template name="annex_header">
      <xsl:with-param name="annex_no" select="'D'"/>
      <xsl:with-param name="heading" select="'BO Model UML diagrams'"/>
      <xsl:with-param name="aname" select="'annexd'"/>
      <xsl:with-param name="informative" select="'informative'"/>
    </xsl:call-template>
    <p>
      The content for this annex will be provided in a later edition.
    </p>
    
  </xsl:template>
	
</xsl:stylesheet>
