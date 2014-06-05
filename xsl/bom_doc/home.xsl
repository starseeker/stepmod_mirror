<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
  $Id: home.xsl,v 1.2 2013/03/05 15:55:50 mikeward Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep Limited.
  Purpose: Display the main set of frames for a BOM.     
-->

<!-- BOM -->

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  version="1.0">

  <xsl:import href="business_object_model.xsl"/>
  
  <xsl:output method="html"
    doctype-system="http://www.w3.org/TR/html4/frameset.dtd" 
    doctype-public="-//W3C//DTD HTML 4.01 Frameset//EN" indent="yes"/>

  <xsl:template match="/">
    <xsl:apply-templates select="./business_object_model"/>
  </xsl:template>

  <xsl:template match="business_object_model">
    <xsl:variable name="business_object_model_xml_file" 
      select="concat('../../data/business_object_models/',@directory,'/business_object_model.xml')"/>
    <html>
      <head>
        <title>
          <!--<xsl:apply-templates select="document($business_object_model_xml_file)/business_object_model" mode="title"/>-->
        </title>
      </head>
      
    <frameset rows="60,*">
      <frame name="menu" 
        src="./sys/frame_title{$FILE_EXT}"
        frameborder="0"
        marginwidth="2" marginheight="0" scrolling="no"/>
      <frameset rows="30%,70%">
      
        <frame name="index" 
          src="./sys/frame_toc{$FILE_EXT}" 
          frameborder="0"
          marginwidth="2" marginheight="0" scrolling="auto"/>
        <frame name="info"
            src="./sys/contents{$FILE_EXT}" 
            frameborder="0"
            scrolling="auto"/>
      </frameset>
      <noframes>
        <p>This page uses frames, but your browser doesn't support them.</p>
      </noframes>
    </frameset>
    </html>
  </xsl:template>

</xsl:stylesheet>