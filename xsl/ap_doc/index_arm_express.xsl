<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: home.xsl,v 1.1 2003/05/21 13:18:32 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: Display the main set of frames for an AP document.     
-->
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  version="1.0">

  <xsl:import href="application_protocol.xsl"/>

  <xsl:output method="html"/>

  <xsl:template match="/">
    <xsl:apply-templates select="./application_protocol"/>
  </xsl:template>

  <xsl:template match="application_protocol">
    <html>
      <head>
      </head>
    <frameset framespacing="1" border="0" rows="40,60" frameborder="0">
      <frame name="toc_top" 
        src="./index_arm_express_top{$FILE_EXT}"
        marginwidth="2" marginheight="0" />
        <frame name="toc_inner" 
          src="./index_arm_express_inner{$FILE_EXT}"
          marginwidth="2" marginheight="0" scrolling="auto"/>
    </frameset>

    <noframes>
      <body>
        <p>This page uses frames, but your browser doesn't support them.</p>
      </body>
    </noframes>
    </html>
  </xsl:template>

</xsl:stylesheet>
