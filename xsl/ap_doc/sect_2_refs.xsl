<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
     $Id: sect_2_refs.xsl,v 1.3 2002/10/08 10:19:07 mikeward Exp $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="../sect_2_refs.xsl"/>
	<xsl:import href="application_protocol.xsl"/>
	<xsl:import href="application_protocol_clause.xsl"/>
	<xsl:output method="html"/>
	
	<xsl:template match="module"/>
	
	<xsl:template match="application_protocol">
		<xsl:call-template name="output_normrefs">
			<xsl:with-param name="application_protocol_number" select="./@part"/>
			<xsl:with-param name="current_application_protocol" select="."/>
		</xsl:call-template>
	</xsl:template>
	
</xsl:stylesheet>
