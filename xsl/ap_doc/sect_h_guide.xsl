<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
	$Id: sect_h_guide.xsl,v 1.4 2002/10/08 10:17:28 mikeward Exp $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="../sect_f_guide.xsl"/>
	<xsl:import href="application_protocol.xsl"/>
	<xsl:import href="application_protocol_clause.xsl"/>
	<xsl:output method="html"/>
	
	<xsl:template match="module"/>
	
	<xsl:template match="application_protocol">
		<xsl:call-template name="annex_header">
			<xsl:with-param name="annex_no" select="'H'"/>
			<xsl:with-param name="heading" select="'Application protocol implementation guide'"/>
			<xsl:with-param name="aname" select="'annexh'"/>
		</xsl:call-template>
		<xsl:apply-templates select="usage_guide"/>
	</xsl:template>


<xsl:template match="usage_guide">
  <xsl:apply-templates/>
</xsl:template>
	
</xsl:stylesheet>
