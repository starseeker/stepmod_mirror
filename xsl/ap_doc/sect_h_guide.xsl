<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_h_guide.xsl,v 1.1 2002/08/28 10:29:36 mikeward Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:import href="application_protocol.xsl"/>
	<xsl:import href="application_protocol_clause.xsl"/>
	
	<xsl:output method="html"/>
	<xsl:template match="application_protocol">
		<xsl:call-template name="annex_header">
			<xsl:with-param name="annex_no" select="'H'"/>
			<xsl:with-param name="heading" select="'Application protocol implementation guide'"/>
			<xsl:with-param name="aname" select="'annexh'"/>
		</xsl:call-template>
		<xsl:apply-templates select="usage_guide"/>
	</xsl:template>
</xsl:stylesheet>
