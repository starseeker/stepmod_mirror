<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
	$Id: $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:import href="../sect_5_main.xsl"/>
	<xsl:import href="application_protocol.xsl"/>
	<xsl:import href="application_protocol_clause.xsl"/>	
	<xsl:output method="html"/>
	
	<xsl:template match="module"/>
	
	<xsl:template match="application_protocol">
		<xsl:call-template name="clause_header">
			<xsl:with-param name="heading" select="'5 Application interpreted model'"/>
			<xsl:with-param name="aname" select="'mim'"/>
		</xsl:call-template>
		<h3>
			<a href="../sys/5_mapping{$FILE_EXT}">
				5.1 Mapping specification
			</a>
		</h3>
		<h3>
			<a href="../sys/5_aim{$FILE_EXT}">
				5.2 AIM EXPRESS short listing
			</a>
		</h3>
	</xsl:template>
	
</xsl:stylesheet>
