<?xml version="1.0" encoding="utf-8"?>
<!--
Ant project to run update tasks:
FilePurpose - extract data from *.exp.xml
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:param name="infilename"/>
	
	<xsl:output method="text"/>
	
	<!-- force the application of the stylesheet  -->
	<xsl:template match="/exp">
		<!-- output the schema text -->
		<xsl:variable name="basename" select="substring-before($infilename, '.')"/>
		<xsl:variable name="textafterbasename" select="substring-after(text(), concat('SCHEMA ', $basename))" />
		<xsl:value-of select="substring(substring-after($textafterbasename, ';'),2)" />
	</xsl:template>
	
</xsl:stylesheet>
