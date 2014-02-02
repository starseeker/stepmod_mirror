<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- $Id$ -->
    <!-- This script extracts a module name from publication_index.xml, ignoring deleted modules. -->
    <xsl:output method="text"/>  
    <xsl:template match= "/">
        <xsl:apply-templates select="/part1000.publication_index/modules/module"/>
    </xsl:template>
    <xsl:template match="module">
        <xsl:value-of select="@name" xml:space="default"/>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>
</xsl:stylesheet>