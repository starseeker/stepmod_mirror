<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_abstract.xsl,v 1.2 2003/07/31 14:44:18 robbod Exp $
  Author:  Mike Ward, Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: Display the main set of frames for an AP document.     
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:import href="application_protocol.xsl"/>

  <xsl:output method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd" 
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" indent="yes"/>

  
  <xsl:template match="/">
    <xsl:apply-templates select="./application_protocol_clause"/>
  </xsl:template>

  <xsl:template match="application_protocol_clause">

    <xsl:variable name="application_protocol_xml_file" 
      select="concat('../../data/application_protocols/',@directory,'/application_protocol.xml')"/>

    <xsl:variable 
      name="application_protocol_xml" 
      select="document($application_protocol_xml_file)"/>

    <html>
      <head>
        <xsl:apply-templates select="$application_protocol_xml/application_protocol" mode="meta_data"/>
        <title>
          <xsl:apply-templates 
            select="$application_protocol_xml/application_protocol"
            mode="title"/>
        </title>
      </head>
      <body>
        <xsl:apply-templates 
            select="$application_protocol_xml/application_protocol" mode="abstract"/>
      </body>
    </html>

  </xsl:template>


	
</xsl:stylesheet>
