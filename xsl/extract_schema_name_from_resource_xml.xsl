<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xalan" xmlns:date="IntDate" exclude-result-prefixes="xalan date" extension-element-prefixes="date" version="1.0">

  <xsl:output method="text"/>
  
  

  <xsl:template match= "/">
    
    <xsl:apply-templates select="resource/schema">
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="schema">
    
    <xsl:value-of select="attribute::name"/>
      
    <xsl:value-of select="concat(',','&#xA;')"/>
  </xsl:template>
</xsl:stylesheet>
