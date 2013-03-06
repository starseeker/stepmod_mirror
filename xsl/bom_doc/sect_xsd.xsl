<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_abstract.xsl,v 1.1 2012/12/19 15:54:31 mikeward Exp $
  Author:  Mike Ward, Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep.
  Purpose: Display the abstract for an BO Model document.     
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" version="1.0">


  <xsl:output method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd" 
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" indent="yes"/>

  <xsl:variable name="bom_name" select="./business_object_model_clause/@directory"/>
  
  <xsl:template match="/">
    <xsl:apply-templates select="./business_object_model_clause"/>
  </xsl:template>
  
  

  <xsl:template match="business_object_model_clause">
   
    <xsl:variable name="business_object_model_xsd_file" select="concat('../../data/business_object_models/',@directory,'/bom.xsd')"/>

    <xsl:variable name="business_object_model_xsd" select="document($business_object_model_xsd_file)"/>

    <html>
      <head>
        
        <title>
          <xsl:value-of select="'XSD'"/>
        </title>
      </head>
      <body>
        <xsl:apply-templates select="$business_object_model_xsd" mode="create_html"/>
      </body>
    </html>

  </xsl:template>

  <xsl:template match="/" mode="create_html">
    <h1>XML Schema listing for <xsl:value-of select="$bom_name"/> </h1>
   <code>
     <xmp>
       <xsl:apply-templates select="*" mode="copy"/>
     </xmp>
   </code>
 </xsl:template>
  
 <xsl:template match="*" mode="copy">
    <xsl:copy>
       <xsl:apply-templates select="@*|node()" mode="copy"/>
    </xsl:copy>
 </xsl:template>
  
 <xsl:template match="@*|text()|comment()|processing-instruction()" mode="copy">
    <xsl:copy-of select="."/>
 </xsl:template>
	
</xsl:stylesheet>
