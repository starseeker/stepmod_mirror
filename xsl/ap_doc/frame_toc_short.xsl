<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: frame_toc_short.xsl,v 1.1 2003/07/31 07:30:30 robbod Exp $
  Author: Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: Display the main set of frames for an AP document.     
-->
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  version="1.0">

  <xsl:import href="sect_contents.xsl"/>

  <xsl:output method="html"/>

  <xsl:template match="/">
    <xsl:apply-templates select="./application_protocol"/>
  </xsl:template>

  <xsl:template match="application_protocol">
    <xsl:variable name="application_protocol_xml_file" 
      select="document(concat('../../data/application_protocols/',@directory,'/application_protocol.xml'))"/>    
    <html>
      <head>
        <title>
          <xsl:apply-templates 
            select="$application_protocol_xml_file/application_protocol" mode="title"/>
        </title>
      </head>

      <body>
        <small>
          <xsl:apply-templates select="$application_protocol_xml_file/application_protocol" mode="contents">
            <xsl:with-param name="complete" select="'yes'"/>
            <xsl:with-param name="target" select="'info'"/>
            <xsl:with-param name="short" select="'yes'"/>
          </xsl:apply-templates>
        </small>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
