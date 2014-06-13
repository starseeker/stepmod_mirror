<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: frame_toc.xsl,v 1.1 2012/10/24 06:29:18 mikeward Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep.
  Purpose: Display the table of contents frame for a BOM.     
-->

<!-- BOM -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:import href="sect_contents.xsl"/>

  <xsl:output method="html" doctype-system="http://www.w3.org/TR/html4/loose.dtd" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" indent="yes"/> 

  <xsl:template match="/">
    <xsl:apply-templates select="./business_object_model_clause"/>
  </xsl:template>

  <xsl:template match="business_object_model_clause">
    <xsl:variable name="business_object_model_xml_file" select="document(concat('../../data/business_object_models/',@directory,'/business_object_model.xml'))"/>
    <html>
      <head>
        <xsl:apply-templates select="$business_object_model_xml_file/business_object_model" mode="meta_data"/>
        <title>
          <xsl:apply-templates select="$business_object_model_xml_file/application_protocol" mode="title"/>
        </title>
      </head>
      <body>
         <xsl:apply-templates select="$business_object_model_xml_file/business_object_model" mode="contents">  
         <xsl:with-param name="target" select="'info'"/>
             <xsl:with-param name="complete" select="'yes'"/>
          </xsl:apply-templates>
        
        
        <!--<xsl:apply-templates 
          select="$application_protocol_xml_file/application_protocol" 
          mode="contents_tables_figures">
          <xsl:with-param name="target" select="'info'"/>
          <xsl:with-param name="complete" select="'yes'"/>
          <xsl:with-param name="short" select="'no'"/>
        </xsl:apply-templates>-->
        
    </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
