<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!-- last edited mwd 2002-08-23 -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="application_protocol.xsl"/>
	<xsl:import href="application_protocol_clause.xsl"/>
	<xsl:output method="html"/>

	<xsl:template match="application_protocol"/>
	
	<xsl:template match="module">
		<xsl:apply-templates select="./inscope"/>
		<xsl:apply-templates select="./outscope"/>
	</xsl:template>

</xsl:stylesheet>
