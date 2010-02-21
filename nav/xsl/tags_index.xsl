<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: smrl_crs.xsl,v 1.1 2010/02/19 15:01:26 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: Display a list of ballot packages.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="../../xsl/common.xsl"/>
  <xsl:output method="html"/>

  <xsl:template match="/" >
    <xsl:apply-templates select="./stylesheet_application"/>
  </xsl:template>

  <xsl:template match="stylesheet_application">
    <xsl:apply-templates select="document('../../config_management/tags.xml')/tags"/>
  </xsl:template>

  
  <xsl:template match="tags">
  <html>
    <head>
      <link rel="stylesheet" type="text/css" href="./css/nav.css"/>
      <title>
        CVS tags
      </title>
    </head>
    <body>
      <xsl:apply-templates select="tag"/>
    </body>
  </html>
</xsl:template>


  <xsl:template match="tag">
    <p class="menuitem">
      <a href="./tags_summary{$FILE_EXT}" target="content">
        <xsl:value-of select="@name"/>
      </a>
    </p>
</xsl:template>

</xsl:stylesheet>