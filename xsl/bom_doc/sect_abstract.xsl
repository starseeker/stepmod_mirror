<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_abstract.xsl,v 1.3 2004/02/05 17:51:07 robbod Exp $
  Author:  Mike Ward, Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep.
  Purpose: Display the abstract for an BO Model document.     
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:import href="business_object_model.xsl"/>

  <xsl:output method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd" 
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" indent="yes"/>

  
  <xsl:template match="/">
    <xsl:apply-templates select="./business_object_model_clause"/>
  </xsl:template>

  <xsl:template match="business_object_model_clause">

    <xsl:variable name="business_object_model_xml_file" 
      select="concat('../../data/business_object_models/',@directory,'/business_object_model.xml')"/>

    <xsl:variable 
      name="business_object_model_xml" 
      select="document($business_object_model_xml_file)"/>

    <html>
      <head>
        <xsl:apply-templates select="$business_object_model_xml/business_object_model" mode="meta_data"/>
        <title>
          <xsl:apply-templates 
            select="$business_object_model_xml/business_object_model"
            mode="title"/>
        </title>
      </head>
      <body>
        <xsl:apply-templates 
          select="$business_object_model_xml/business_object_model" mode="abstract"/>
      </body>
    </html>

  </xsl:template>


	
</xsl:stylesheet>
