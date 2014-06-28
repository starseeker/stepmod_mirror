<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- $Id: extract_module_name_from_publication_index.xsl,v 1.1 2014/02/02 18:35:16 thomasrthurman Exp $ -->
    <!-- This script extracts a module name from publication_index.xml, ignoring deleted modules. -->
    <xsl:output method="text"/>  
    <xsl:template match= "/">
        <xsl:apply-templates select="/part1000.publication_index/modules/module"/>
    </xsl:template>
    <xsl:template match="/modules/module">
        <xsl:value-of select="@name" xml:space="default"/>
        <xsl:text>:</xsl:text>
        <xsl:value-of select="attribute::version"/>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
</xsl:stylesheet>