<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: frame_contenttitle.xsl,v 1.1 2003/05/21 13:18:32 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: Display the main set of frames for an AP document.     
-->
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  version="1.0">

  <xsl:output method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" indent="yes"/> 

  <xsl:template match="/">
    <xsl:apply-templates select="./application_protocol"/>
  </xsl:template>

  <xsl:template match="application_protocol">
    <xsl:variable name="application_protocol_xml_file" 
      select="concat('../../data/application_protocols/',@directory,'/application_protocol.xml')"/>
    <html>
      <head>
        <title>
          Title bar
        </title>
      </head>
      <body>
        <!-- this will get populated by updateTitleFrame function
             defined in index.xsl -->
        <div id="DIVtitletext" class="DIVtitletext"/>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>