<?xml version="1.0" encoding="utf-8"?>
<!-- $Id: $

     XSLT transform to extract programlisting element content from a Docbook 
     instance.

     Created by Josh Lubell, lubell@nist.gov -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:output method="text"/>

  <xsl:template match="programlisting">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="text()"/>

  <xsl:template match="programlisting//text()">
    <xsl:copy/>
  </xsl:template>

</xsl:stylesheet>
