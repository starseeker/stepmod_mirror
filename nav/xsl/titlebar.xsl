<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: banner.xsl,v 1.5 2002/09/11 08:24:45 robbod Exp $
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
          Title bar
        </title>
        </head>
        <body>
          <!-- this will get populated by updateTitleFrame function
               defined in index.xsl -->
          <a href="#" onclick="history.go(-1)">
            <img align="middle" border="0"
              alt="Previous page"
              src="../images/prev.gif"
              onclick="history.go(-1)"/>
          </a>
          <div id="DIVtitletext" class="DIVtitletext"/>
        </body>
      </html>
    </xsl:template>
  </xsl:stylesheet>