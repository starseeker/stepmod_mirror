<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: sect_d_mim_expg.xsl,v 1.2 2001/12/28 16:03:19 robbod Exp $
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
    <xsl:with-param name="annex_no" select="'D'"/>
    <xsl:with-param name="heading" 
      select="'MIM EXPRESS-G'"/>
    <xsl:with-param name="aname" select="'annexd'"/>
  </xsl:call-template>

  <xsl:variable name="href"
    select="concat('./5_mim',$FILE_EXT,'#mim_express')"/>
       
  The following diagrams correspond to the 
  <a href="{$href}">MIM EXPRESS short listing</a> given in
  Clause 5.2. The diagrams use the EXPRESS-G graphical notation for the
  EXPRESS language. EXPRESS-G is defined in annex D of ISO 10303-11.  


  <xsl:apply-templates select="mim/express-g"/>
</xsl:template>
  
</xsl:stylesheet>
