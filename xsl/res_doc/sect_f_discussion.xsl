<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_f_discussion.xsl,v 1.1 2002/10/16 00:43:38 thendrix Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="resource.xsl"/>

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
  <xsl:import href="resource_clause.xsl"/>


  <xsl:output method="html"/>

<!-- overwrites the template declared in module.xsl -->
<xsl:template match="resource">


   <xsl:variable name="annex_list">
     <xsl:apply-templates select="." mode="annex_list" />
   </xsl:variable>

  <xsl:variable name="pos" >
	<xsl:call-template name="annex_position" >
		<xsl:with-param name="annex_name" select="'Examples'"/>
		<xsl:with-param name="annex_list" select="$annex_list" />
	</xsl:call-template>
  </xsl:variable>

  <xsl:variable name="annex_letter" select="substring('EFGH',$pos,1)" />

  <xsl:call-template name="annex_header">
    <xsl:with-param name="annex_no" select="$annex_letter"/>
    <xsl:with-param name="heading" 
      select="'Application module implementation and usage guide'"/>
    <xsl:with-param name="aname" select="'usage_guide'"/>
  </xsl:call-template>

  <xsl:apply-templates select="usage_guide"/>
</xsl:template>

</xsl:stylesheet>
