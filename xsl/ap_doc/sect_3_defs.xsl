<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
     $Id: sect_3_defs.xsl,v 1.2 2002/09/18 09:50:07 mikeward Exp $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="application_protocol.xsl"/>
	<xsl:import href="application_protocol_clause.xsl"/>
	<xsl:output method="html"/>
	<xsl:template match="application_protocol"/>
	<xsl:template match="module">
		<a name="defns">
			<h3>
				<xsl:choose>
					<xsl:when test="./definition/term">
						3 Terms, definitions and abbreviations
					</xsl:when>
					<xsl:otherwise>
						3 Terms and abbreviations
					</xsl:otherwise>
				</xsl:choose>
			</h3>
		</a>
		<xsl:call-template name="output_terms"/>
	</xsl:template>
</xsl:stylesheet>
