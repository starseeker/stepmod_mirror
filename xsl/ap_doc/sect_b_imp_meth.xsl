<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./pas_document_xsl.xsl" ?>
<!--
     $Id: $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="application_protocol.xsl"/>
	<xsl:import href="application_protocol_clause.xsl"/>
	 <xsl:output method="html"/>
	<xsl:template match="application_protocol">
		<xsl:call-template name="annex_header">
    			<xsl:with-param name="annex_no" select="'B'"/>
    			<xsl:with-param name="heading" select="'Implementation method specific requirements'"/>
    			<xsl:with-param name="aname" select="'annexb'"/>
			<xsl:with-param name="informative" select="'normative'"/>
		</xsl:call-template>
		<xsl:variable name="schema_name">
			<xsl:value-of select="@name"/>
		</xsl:variable>
		<xsl:variable name="imp_meths_phrase">
			<xsl:for-each select="imp_meths/imp_meth">
				<xsl:variable name="part_no" select="./@part"/>
				<xsl:choose>
					<xsl:when test="position()=1">
						<xsl:value-of select="concat('ISO 10303-', $part_no)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat(' or ISO 10303-', $part_no, ',')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>					
		 The implementation method defines what types of exchange behaviour are required with respect to this
		part of ISO 10303. Conformance to this part of ISO 10303 shall be realized in an exchange structure.
		The file format shall be encoded according to the syntax and EXPRESS language mapping defined
		in <xsl:value-of select="$imp_meths_phrase"/> and in the AIM defined in Annex A of this part of ISO 10303. The header of the
		exchange structure shall identify the use of this part of ISO 10303 by the schema name "<xsl:value-of select="$schema_name"/>".
	</xsl:template>
</xsl:stylesheet>
