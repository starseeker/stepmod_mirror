<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
	$Id: sect_g_exp.xsl,v 1.3 2002/10/30 15:27:54 mikeward Exp $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:import href="../sect_e_exp.xsl"/>
	<xsl:import href="application_protocol.xsl"/>
  <xsl:import href="application_protocol_clause.xsl"/>
	<xsl:output method="html"/>
	
	<xsl:template match="application_protocol"/>
	
	<xsl:template match="module">
		<xsl:apply-templates select="." mode="annexg"/>
	</xsl:template>
	
</xsl:stylesheet>
