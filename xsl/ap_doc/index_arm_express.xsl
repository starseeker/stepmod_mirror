<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: index_arm_express.xsl,v 1.6 2004/11/27 18:05:32 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: Display the main set of frames for an AP document.     
-->
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  version="1.0">

  <xsl:import href="application_protocol.xsl"/>

  <xsl:output method="html"
    doctype-system="http://www.w3.org/TR/html4/frameset.dtd" 
    doctype-public="-//W3C//DTD HTML 4.01 Frameset//EN" indent="yes"/>

  <xsl:template match="/">
    <xsl:apply-templates select="./application_protocol"/>
  </xsl:template>

  <xsl:template match="application_protocol">
    <html>
      <head>
        <title>ARM EXPRESS index</title>
      </head>
      <!--      <frameset rows="40,60"> -->
      <frameset rows="25,125"> 
        <frame name="toc_top" 
          src="./index_arm_express_top{$FILE_EXT}" 
          frameborder="0"
          marginwidth="2" marginheight="0"/>
        <frame name="toc_inner" 
          src="./index_arm_express_inner{$FILE_EXT}"
          marginwidth="2" marginheight="0" scrolling="auto" 
          frameborder="0"/>
        <noframes>
          <p>This page uses frames, but your browser doesn't support them.</p>
        </noframes>          
      </frameset>
    </html>
  </xsl:template>

</xsl:stylesheet>
