<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_f_guide.xsl,v 1.3 2002-07-16 16:50:08 mwd Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:import href="application_protocol.xsl"/>
	
	<!-- the stylesheet that allows different stylesheets to be applied -->
	
	<xsl:import href="application_protocol_clause.xsl"/>
	
	<xsl:output method="html"/>
	
	<!-- overwrites the template declared in module.xsl -->
	<xsl:template match="module">
		<xsl:call-template name="annex_header">
			<xsl:with-param name="annex_no" select="'H'"/>
			<xsl:with-param name="heading" select="'Application protocol implementation guide'"/>
			<xsl:with-param name="aname" select="'annexh'"/>
		</xsl:call-template>
		<xsl:apply-templates select="usage_guide"/>
	</xsl:template>
</xsl:stylesheet>
