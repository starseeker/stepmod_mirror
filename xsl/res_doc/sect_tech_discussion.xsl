<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_e_examples.xsl,v 1.1 2002/10/16 00:43:38 thendrix Exp $
  Author:  Nigel Shaw, Eurostep Limited
  Owner:   Developed by Eurostep.
  Purpose: To display technical discussions annex of resource documents
     
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
		<xsl:with-param name="annex_name" select="'Technical discussion'"/>
		<xsl:with-param name="annex_list" select="$annex_list" />
	</xsl:call-template>
  </xsl:variable>

  <xsl:variable name="annex_letter" select="substring('EFGH',$pos,1)" />

  <xsl:call-template name="annex_header">
    <xsl:with-param name="annex_no" select="$annex_letter"/>
    <xsl:with-param name="heading" 
      select="'Technical discussion'"/>
    <xsl:with-param name="aname" select="'tech_discussion'"/>
  </xsl:call-template>

  <xsl:apply-templates select="tech_discussion"/>
</xsl:template>

</xsl:stylesheet>
