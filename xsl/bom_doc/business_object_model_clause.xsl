<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: application_protocol_clause.xsl,v 1.16 2004/02/05 17:51:07 robbod Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep.
  Purpose:     
-->

<!-- BOM -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:import href="parameters.xsl"/>
	
  <xsl:template match="/" >
    <xsl:apply-templates select="./business_object_model_clause"/>
  </xsl:template>
	
  <xsl:template match="business_object_model_clause">
    <xsl:variable name="business_object_model_xml_file" select="concat('../../data/business_object_models/',@directory,'/business_object_model.xml')"/>
    <xsl:variable name="business_object_model_xml" select="document($business_object_model_xml_file)"/>
    <html>
      <head>
        <xsl:apply-templates select="$business_object_model_xml/business_object_model" mode="meta_data"/>
        <title>
          <!--<xsl:apply-templates select="$business_object_model_xml/business_object_model" mode="title"/>-->
        </title>
      </head>
      <xsl:element name="body">
        <!--<xsl:if test="$output_ap_background='YES'">
          <xsl:attribute name="background">
            <xsl:value-of select="concat('../../../../images/',$ap_background_image)"/>
          </xsl:attribute>
          <!-\- can only use this for Internet explorer, so not valid HTML
          <xsl:attribute name="bgproperties" >
            <xsl:value-of select="'fixed'"/>
          </xsl:attribute> -\->
        </xsl:if>-->

        <!--<xsl:apply-templates select="$business_object_model_xml/business_object_model" mode="TOCmultiplePage"/>-->
        <xsl:apply-templates select="$business_object_model_xml/business_object_model"/>
        <br/><br/>
        <p>&#169; ISO <xsl:value-of select="$business_object_model_xml/business_object_model/@publication.year"/> &#8212; All rights reserved</p>

      </xsl:element>
    </html>
  </xsl:template>

</xsl:stylesheet>
