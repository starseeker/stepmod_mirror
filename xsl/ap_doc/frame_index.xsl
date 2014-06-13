<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: frame_index.xsl,v 1.10 2009/05/20 15:41:16 robbod Exp $
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
	<xsl:variable name="bom-dir" select="concat('../../../../data/business_object_models/',
			$application_protocol_xml_file/application_protocol/@business_object_model)"/>
        <h2>Navigation Indices</h2>
        <a href="./index_apdoc{$FILE_EXT}" target="info">Application Protocol Index</a><br/>
	<xsl:if test="$application_protocol_xml_file/application_protocol/@business_object_model">
	        Business Object Model<br/>
		&#160;&#160;&#160;&#160;<a href="{$bom-dir}/sys/index_bomdoc{$FILE_EXT}#index" target="info">Index</a>
	        <br/>
	</xsl:if>
        Module ARMs<br/>
        &#160;&#160;&#160;&#160;<a href="index_arm_modules{$FILE_EXT}">alphabetical</a>
        <br/>
        &#160;&#160;&#160;&#160;<a href="index_arm_modules_inner_part{$FILE_EXT}">by part</a><br/>
        
        Module MIMs<br/>
        &#160;&#160;&#160;&#160;<a href="index_mim_modules{$FILE_EXT}">alphabetical</a>
        <br/>
        &#160;&#160;&#160;&#160;<a href="index_mim_modules_inner_part{$FILE_EXT}">by part</a><br/>
        Resource schemas<br/>
        &#160;&#160;&#160;&#160;<a href="index_resources{$FILE_EXT}">alphabetical</a>
        <br/>
        &#160;&#160;&#160;&#160;<a href="index_resources_inner_part{$FILE_EXT}">by part</a><br/>
        <a href="index_mim_express{$FILE_EXT}">MIM EXPRESS</a><br/>
        <a href="index_arm_express{$FILE_EXT}">ARM EXPRESS</a><br/>
        <a href="index_arm_mappings{$FILE_EXT}">ARM Entity Mappings</a><br/>
        <a href="index_arm_express_nav{$FILE_EXT}">ARM EXPRESS Navigation</a><br/>
	<xsl:if test="$application_protocol_xml_file/application_protocol/@business_object_model">
	        Business Object Model<br/>
		<a href="{$bom-dir}/sys/index_bom_express{$FILE_EXT}">BOM EXPRESS</a><br/>
		<a href="{$bom-dir}/sys/index_bom_mappings{$FILE_EXT}">BOM Entity Mappings</a><br/>
		<a href="{$bom-dir}/sys/index_bom_express_nav{$FILE_EXT}">BOM EXPRESS Navigation</a><br/>
	</xsl:if>
      </body>
    </html>
  </xsl:template>
 <!-- NKS notes:
 ned to introduce new files and associated xsl as follows:
 index_bom.xml
 index_bom_express.xml
 index_bom_express_nav.xml
 index_bom_mappings.xml
 -->

</xsl:stylesheet>
