<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_help.xsl,v 1.4 2004/02/05 17:51:07 robbod Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep.
  Purpose:     
-->

<!-- BOM -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <!--<xsl:import href="common.xsl"/>-->

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
        <!--<xsl:apply-templates select="$business_object_model_xml/business_object_model" mode="meta_data"/>-->
        <title>
          <!--<xsl:apply-templates 
            select="$business_object_model_xml/business_object_model" mode="title"/>-->
        </title>
      </head>
      <body>
        <h2>Help</h2>

        
        <p>
          This is the collection of HTML pages that make up the AP document
          for: 
          <br/>
          <xsl:variable name="stdnumber">
            <!--<xsl:call-template name="get_protocol_stdnumber">
              <xsl:with-param name="business_object_model" select="$business_object_model_xml/business_object_model"/>
            </xsl:call-template>-->
          </xsl:variable>
          <xsl:value-of select="$stdnumber"/>&#160;
            Application protocol: 
            <!--<xsl:call-template name="protocol_display_name">
              <xsl:with-param name="business_object_model" select="$business_object_model_xml/business_object_model/@title"/>
            </xsl:call-template>-->

        </p>
        
        <p>
          The document is presented as frames as described in the Figure below.
        </p>
        <!--<img alt="frame and menu layout" 
          border="0"
          align="middle"
          src="../../../../images/bom_doc/bom_help.png"/>
-->
      </body>
    </html>
  </xsl:template> 


</xsl:stylesheet>
