<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: contents.xsl,v 1.1 2002/09/05 13:38:22 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: Set up a banner plus menus in the top frame
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="../../xsl/common.xsl"/>


  <xsl:output method="html"/>


  <xsl:template match="/" >
    <xsl:apply-templates select="./stylesheet_application"/>
  </xsl:template>

  <xsl:template match="stylesheet_application">
    <html>
      <head>
        <link rel="stylesheet" type="text/css" href="./css/nav.css"/>
        <title>
          STEPmod introduction
        </title>
        </head>
        <body>
          <h3>Introduction</h3>
          This is the STEP modules repository.
        </body>
      </html>
    </xsl:template>

  </xsl:stylesheet>