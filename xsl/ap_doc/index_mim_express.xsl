<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: index_mim_express.xsl,v 1.2 2003/06/06 12:51:27 nigelshaw Exp $
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
        <title>
          MIM EXPRESS
        </title>
      </head>
      <frameset rows="40,60">
        <frame name="toc_top" 
          src="./index_mim_express_top{$FILE_EXT}"
          marginwidth="2" marginheight="0"/>
        <frame name="toc_inner" 
          src="./index_mim_express_inner{$FILE_EXT}"
          marginwidth="2" marginheight="0" scrolling="auto"/>
        <noframes>
          <p>This page uses frames, but your browser doesn't support them.</p>
        </noframes>
      </frameset>
    </html>
  </xsl:template>

</xsl:stylesheet>

