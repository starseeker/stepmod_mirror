<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: frame_index.xsl,v 1.5 2004/02/05 17:51:07 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: Display the main set of frames for an AP document.     
-->
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  version="1.0">

  <xsl:import href="../file_ext.xsl"/>

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
          <xsl:apply-templates 
            select="document($application_protocol_xml_file)/application_protocol" mode="title"/>
        </title>
      </head>
      <body>
        <h2>Navigation Indices</h2>
	<a href="./index_apdoc{$FILE_EXT}" target="info">Application Protocol Index</a><br/>
        <a href="index_arm_modules{$FILE_EXT}">Module ARMs</a><br/>
        <a href="index_mim_modules{$FILE_EXT}">Module MIMs</a><br/>
        <a href="index_resources{$FILE_EXT}">Resource schemas</a><br/>
        <a href="index_arm_express{$FILE_EXT}">ARM EXPRESS</a><br/>
        <a href="index_mim_express{$FILE_EXT}">MIM EXPRESS</a><br/>
        <a href="index_arm_mappings{$FILE_EXT}">ARM Entity Mappings</a><br/>
        <a href="index_arm_express_nav{$FILE_EXT}">ARM EXPRESS Navigation</a><br/>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
