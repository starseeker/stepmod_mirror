<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: index.xsl,v 1.1 2002/09/03 14:25:21 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: Set up the main frames
     
-->
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>

  <xsl:import href="../../xsl/common.xsl"/>

  <xsl:output method="html"/>


  <xsl:template match="/" >
    <xsl:apply-templates select="./stylesheet_application"/>
  </xsl:template>

  <xsl:template match="stylesheet_application">
    <html>
    <head>
      <link rel="stylesheet" type="text/css" href="../css/stepmod.css"/>
    <title>
      STEP modules
    </title>
  </head>

  <frameset framespacing="1" border="0" rows="13%,*" frameborder="0">
    <frame name="banner" 
      src="banner{$FILE_EXT}"
      marginwidth="2" marginheight="0" scrolling="auto"/>
      <frameset cols="*,80%">
        <frame name="index" 
          target="main"
          src="modules_alpha{$FILE_EXT}"
          scrolling="auto"/>
        <frame name="content" 
          src="introduction{$FILE_EXT}"
          scrolling="auto"/>
      </frameset>
      <noframes>
        <body>
          <p>This page uses frames, but your browser doesn't support them.</p>
        </body>
      </noframes>
    </frameset>
  </html>
</xsl:template>

</xsl:stylesheet>