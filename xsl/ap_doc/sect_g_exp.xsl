<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: frame_index.xsl,v 1.2 2003/05/22 22:30:38 nigelshaw Exp $
  Author:  Mike Ward, Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: 
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:import href="../sect_e_exp.xsl"/>
	<xsl:import href="application_protocol.xsl"/>
  <xsl:import href="application_protocol_clause.xsl"/>
	<xsl:output method="html"/>
	
	<xsl:template match="application_protocol">
		<xsl:apply-templates select="." mode="annexg"/>	
	</xsl:template>
		<!-- display content of ap module -->
	<xsl:template match="module">

	</xsl:template>
	
</xsl:stylesheet>
