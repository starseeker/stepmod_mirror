<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
	$Id: sect_h_guide.xsl,v 1.4 2002/10/08 10:17:28 mikeward Exp $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="application_protocol.xsl"/>
	<xsl:import href="application_protocol_clause.xsl"/>
	<xsl:output method="html"/>
	
	<xsl:template match="module"/>
	
	<xsl:template match="application_protocol">
		<xsl:call-template name="annex_header">
			<xsl:with-param name="annex_no" select="'J'"/>
			<xsl:with-param name="heading" select="'Technical discussion'"/>
			<xsl:with-param name="aname" select="'annexj'"/>
		</xsl:call-template>
		<xsl:apply-templates select="tech_disc"/>

	</xsl:template>
	
</xsl:stylesheet>
