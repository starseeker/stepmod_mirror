<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: common.xsl,v 1.23 2002/02/14 16:47:52 robbod Exp $
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


<xsl:template match="contentsindex">
  <html>
    <head>
      <link rel="stylesheet" type="text/css" href="../css/stepmod.css"/>
    <title>
      <xsl:value-of select="@title" />
    </title>
  </head>

  <xsl:variable name="index_item" 
    select="indexitem[@default='index']"/>
  <xsl:variable name="index_file" 
    select="concat($index_item/@href,$FILE_EXT)"/>

  <xsl:variable name="content_item" 
    select="indexitem[@default='content']"/>
  <xsl:variable name="content_file" 
    select="concat($content_item/@href,$FILE_EXT)"/>

  <frameset framespacing="1" border="0" rows="13%,*" frameborder="0">
    <frame name="banner" 
      src="contents{$FILE_EXT}"
      marginwidth="2" marginheight="0" scrolling="auto"/>
      <frameset cols="*,80%">
        <frame name="index" 
          target="main"
          src="{$index_file}"
          scrolling="auto"/>
        <frame name="content" 
          src="{$content_file}"
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