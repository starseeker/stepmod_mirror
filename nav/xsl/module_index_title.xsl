<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: titlebar.xsl,v 1.1 2002/09/11 11:36:08 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: 
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
        <title>Module index</title>
        </head>
        <body>
          <!-- this will get populated by updateTitleFrame function
               defined in index.xsl -->
          <div id="DIVmoduleindextitle" class="DIVmoduleindextitle"/>
        </body>
      </html>
    </xsl:template>
  </xsl:stylesheet>