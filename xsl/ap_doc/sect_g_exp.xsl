<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
	$Id: sect_g_exp.xsl,v 1.4 2003/02/19 17:51:55 goset1 Exp $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:import href="../sect_e_exp.xsl"/>
	<xsl:import href="application_protocol.xsl"/>
  <xsl:import href="application_protocol_clause.xsl"/>
	<xsl:output method="html"/>
	
	<xsl:template match="application_protocol"/>
	
	<!-- display content of ap module -->
	<xsl:template match="module">
		<xsl:apply-templates select="." mode="annexg"/>
	</xsl:template>
	
</xsl:stylesheet>
