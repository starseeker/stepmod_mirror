<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: frame_index.xsl,v 1.8 2004/12/29 14:29:24 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: Display the main set of frames for an AP document.     
-->
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  version="1.0">

  <xsl:import href="common.xsl"/>

  <xsl:output method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" indent="yes"/> 

  <xsl:template match="/">
    <xsl:apply-templates select="./application_protocol"/>
  </xsl:template>

  <xsl:template match="application_protocol">
    <xsl:variable name="application_protocol_xml_file" 
      select="document(concat('../../data/application_protocols/',@directory,'/application_protocol.xml'))"/>
    <html>
      <head>
        <xsl:apply-templates select="$application_protocol_xml_file/application_protocol" mode="meta_data"/>
        <title>
          <xsl:apply-templates 
            select="$application_protocol_xml_file/application_protocol" mode="title"/>
          Navigation indices
        </title>
      </head>
      <body>
        <h2>Navigation Indices</h2>
        <a href="./index_apdoc{$FILE_EXT}" target="info">Application Protocol Index</a><br/>
        Module ARMs<br/>
        &#160;&#160;&#160;&#160;<a href="index_arm_modules{$FILE_EXT}">alphabetical</a>
        <br/>
        &#160;&#160;&#160;&#160;<a href="index_arm_modules_inner_part{$FILE_EXT}">part</a><br/>
        
        Module MIMs<br/>
        &#160;&#160;&#160;&#160;<a href="index_mim_modules{$FILE_EXT}">alphabetical</a>
        <br/>
        &#160;&#160;&#160;&#160;<a href="index_mim_modules_inner_part{$FILE_EXT}">part</a><br/>
        Resource schemas<br/>
        &#160;&#160;&#160;&#160;<a href="index_resources{$FILE_EXT}">alphabetical</a>
        <br/>
        &#160;&#160;&#160;&#160;<a href="index_resources_inner_part{$FILE_EXT}">part</a><br/>
        <a href="index_arm_express{$FILE_EXT}">ARM EXPRESS</a><br/>
        <a href="index_mim_express{$FILE_EXT}">MIM EXPRESS</a><br/>
        <a href="index_arm_mappings{$FILE_EXT}">ARM Entity Mappings</a><br/>
        <a href="index_arm_express_nav{$FILE_EXT}">ARM EXPRESS Navigation</a><br/>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
