<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:output method="html"/>


  <xsl:template match="/">
    <xsl:variable name="index" select="document('../../repository_index.xml')/repository_index/modules/module" />
    <html>
      <body bgcolor="#FFFFFF">
      <xsl:for-each select="$index">
        <xsl:value-of select="@name" /><br/>
      </xsl:for-each>
    </body>
  </html>
  </xsl:template>

  <xsl:template match="module" >
    <xsl:value-of select="@name" />
  </xsl:template>

</xsl:stylesheet>
