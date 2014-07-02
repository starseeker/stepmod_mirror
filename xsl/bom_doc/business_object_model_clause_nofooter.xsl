<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: business_object_model_clause_nofooter.xsl,v 1.1 2012/10/24 06:29:18 mikeward Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose:     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <!--<xsl:import href="parameters.xsl"/>-->
	
  <xsl:template match="/" >
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
            select="$business_object_model_xml/business_object_model" mode="title"/>
        </title>
      </head>
      <xsl:element name="body">
        <!--<xsl:if test="$output_ap_background='YES'">
          <xsl:attribute name="background">
            <xsl:value-of select="concat('../../../../images/',$ap_background_image)"/>
          </xsl:attribute>
        </xsl:if>-->
        
        <xsl:apply-templates 
          select="$business_object_model_xml/business_object_model" 
          mode="TOCmultiplePage"/>
        <xsl:apply-templates
          select="$business_object_model_xml/business_object_model"/>
      </xsl:element>
    </html>
  </xsl:template>

</xsl:stylesheet>
