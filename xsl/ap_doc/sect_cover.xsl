<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
     $Id: sect_cover.xsl,v 1.3 2002/10/08 10:18:09 mikeward Exp $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<!--	
	<xsl:import href="../sect_cover.xsl"/>
-->
	<xsl:import href="application_protocol.xsl"/>
	<xsl:import href="application_protocol_clause.xsl"/>
	<xsl:output method="html"/>
	
	<xsl:template match="application_protocol">
		<xsl:apply-templates select="." mode="coverpage"/>
	</xsl:template>	
<!--	
<xsl:template match="module">
		<xsl:apply-templates select="." mode="coverpage"/>
	</xsl:template>
	-->
</xsl:stylesheet>
