<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_annex_bom_expg.xsl,v 1.1 2012/10/24 06:29:18 mikeward Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose:  Display Annex C for a BOM document.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="business_object_model.xsl"/>
  <xsl:import href="business_object_model_clause_nofooter.xsl"/> 
  <xsl:output method="html"/>
  
  <xsl:variable name="sect4" select="concat('4_info_reqs',$FILE_EXT)"/>
  
  <xsl:template match="business_object_model">
    
    <xsl:call-template name="annex_header">
      <xsl:with-param name="annex_no" select="'C'"/>
      <xsl:with-param name="heading" select="'BOM EXPRESS-G'"/>
      <xsl:with-param name="aname" select="'annexc'"/>
      <xsl:with-param name="informative" select="'informative'"/>
    </xsl:call-template>
    <p>
      The following diagrams provide a graphical representation of the Business Object Model EXPRESS short listing defined in Clause <a href="{$sect4}">4</a>.
      The diagrams are presented in EXPRESS-G.
    </p>
    <p>
      The EXPRESS-G graphical notation is defined in ISO 10303-11.
    </p>
    
    <xsl:apply-templates select="//imgfile" mode="expressg"/>
        
  </xsl:template>
	
</xsl:stylesheet>
