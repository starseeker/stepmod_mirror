<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
  Author:  Nigel Shaw, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, Liberty BA under contract.
  Purpose: Display the main set of frames for an AP document.     
-->
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  version="1.0">

  <xsl:import href="../ap_doc/application_protocol.xsl"/>

  <xsl:output method="html"
    doctype-system="http://www.w3.org/TR/html4/frameset.dtd" 
    doctype-public="-//W3C//DTD HTML 4.01 Frameset//EN" indent="yes"/>

  <xsl:template match="/">
    <xsl:apply-templates select="./business_object_model_clause"/>
  </xsl:template>

  <xsl:template match="business_object_model_clause">
    <xsl:variable name="selected_bom" select="/business_object_model_clause/@directory"/>
    <xsl:variable name="bom_file" 
      select="concat('../../data/business_object_models/',$selected_bom,'/business_object_model.xml')"/>
    <xsl:variable name="bom-node" select="document($bom_file)"/>

    <xsl:variable name="selected_ap" select="$bom-node/business_object_model/@name"/>
    <xsl:variable name="ap_file" 
      select="concat('../../data/application_protocols/',$selected_ap,'/application_protocol.xml')"/>
    <xsl:variable name="ap_node" select="document($ap_file)"/>


    <html>
      <head>
        <xsl:apply-templates select="$ap_node" mode="meta_data"/>
        <title>BOM EXPRESS index</title>
      </head>
      <!--      <frameset rows="40,60"> -->
      <frameset rows="25,125"> 
        <frame name="toc_top" 
		src="../../../../data/business_object_models/{$selected_bom}/sys/index_bom_express_top{$FILE_EXT}" 
          frameborder="0"
          marginwidth="2" marginheight="0"/>
        <frame name="toc_inner" 
          src="../../../../data/business_object_models/{$selected_bom}/sys/index_bom_express_inner{$FILE_EXT}"
          marginwidth="2" marginheight="0" scrolling="auto" 
          frameborder="0"/>
        <noframes>
          <p>This page uses frames, but your browser doesn't support them.</p>
        </noframes>          
      </frameset>
    </html>
  </xsl:template>

</xsl:stylesheet>
