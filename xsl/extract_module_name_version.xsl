<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xalan" xmlns:date="IntDate" exclude-result-prefixes="xalan date" extension-element-prefixes="date" version="1.0">

  <xsl:output method="xml"/>
  
  <xsl:template match="module">
    <xsl:text xml:space="preserve">,    
    </xsl:text>
      <xsl:element name="module">
      <xsl:value-of select="@name" />
    </xsl:element>

    <xsl:text xml:space="preserve">, </xsl:text>
       <xsl:element name="publication.year">
       <xsl:value-of select="@publication.year" />
    </xsl:element>

    <xsl:text xml:space="preserve">, </xsl:text>
      <xsl:element name="publication.date">   
      <xsl:value-of select="@publication.date" />
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>

