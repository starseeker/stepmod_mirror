<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: index2.xsl,v 1.3 2003/04/17 12:30:41 robbod Exp $
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
      <script language="JavaScript"><![CDATA[
       function updateTitleFrame(title) {
         var divTT = top.titlebar.document.all.DIVtitletext;
         if (divTT) {
          divTT.innerText=title;
         }
       }

       function updateModuleIndexTitleFrame(title) {
         var divTT = top.module_index_title.document.all.DIVmoduleindextitle;
         if (divTT) {
           divTT.innerHTML=title;
         }
       }
      ]]></script>
    </head>

    <frameset framespacing="1" border="0" rows="76,*" frameborder="0">
      <frame name="banner" 
        src="banner{$FILE_EXT}"
        marginwidth="2" marginheight="0" scrolling="auto"/>
      <frameset cols="15%,0%,70%">
        <frame name="index" 
          src="modules_alpha{$FILE_EXT}"
          scrolling="auto"/>
        
        <frameset framespacing="1" border="0" rows="26,*" frameborder="0">
          <frame name="module_index_title" 
            src="module_index_title{$FILE_EXT}"
            scrolling="no"/>
          <frame name="module_index" 
            src="module_index_title{$FILE_EXT}"
            onload="updateModuleIndexTitleFrame(top.module_index.document.title)" 
            scrolling="auto"/>
        </frameset>
        
        <frameset framespacing="1" border="0" rows="48,*" frameborder="0">
          <frame name="titlebar"
            src="titlebar{$FILE_EXT}"
            scrolling="no"/>
          <frame name="content" 
            onload="updateTitleFrame(top.content.document.title)" 
            src="introduction{$FILE_EXT}"
            scrolling="auto"/>
        </frameset>
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