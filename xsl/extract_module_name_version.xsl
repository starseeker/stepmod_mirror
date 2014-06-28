<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xalan" xmlns:date="IntDate" exclude-result-prefixes="xalan date" extension-element-prefixes="date" version="1.0">
<!-- from docs.xml -->
  <xsl:output method="text"/>
  <xsl:template match= "/">
    <xsl:apply-templates select="/docs/doc[@series='AM']">
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="doc">
    <xsl:value-of select="@name"/>
    <xsl:text>:</xsl:text>
    <xsl:value-of select="@edition"/>
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>
  
  
  

</xsl:stylesheet>

