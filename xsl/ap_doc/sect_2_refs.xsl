<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
     $Id: $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="../sect_2_refs.xsl"/>
	<xsl:import href="application_protocol.xsl"/>
	<xsl:import href="application_protocol_clause.xsl"/>
	<xsl:output method="html"/>
	<xsl:template match="application_protocol"/>
	<xsl:template match="module">
		<xsl:call-template name="output_normrefs">
			<xsl:with-param name="module_number" select="./@part"/>
			<xsl:with-param name="current_module" select="."/>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>
