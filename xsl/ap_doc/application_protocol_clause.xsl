<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: application_protocol_clause.xsl,v 1.13 2003/05/27 07:34:15 robbod Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose:     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	
  <xsl:template match="/" >
    <xsl:apply-templates select="./application_protocol_clause"/>
  </xsl:template>
	
  <xsl:template match="application_protocol_clause">
    <xsl:variable name="application_protocol_xml_file" 
      select="concat('../../data/application_protocols/',@directory,'/application_protocol.xml')"/>

    <xsl:variable 
      name="application_protocol_xml" 
      select="document($application_protocol_xml_file)"/>
    
    <html>
      <head>
        <xsl:apply-templates select="$application_protocol_xml/application_protocol" mode="meta_data"/>

        <title>
          <xsl:apply-templates 
            select="$application_protocol_xml/application_protocol" mode="title"/>
        </title>
      </head>
      <body bgcolor="#eeeeee">
        
        <xsl:variable name="module" select="$application_protocol_xml/application_protocol/@module_name"/>
        <xsl:variable name="module_ok">
          <xsl:call-template name="check_module_exists">
            <xsl:with-param name="module" select="$module"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:if test="$module_ok!='true'">
          <xsl:call-template name="error_message">
            <xsl:with-param name="message">
              <xsl:value-of select="concat('Error AP1s: The module ',$module,' does not exist.',
                                    '  Correct application_protocol module_name in application_protocol.xml')"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>

        <xsl:apply-templates 
          select="$application_protocol_xml/application_protocol" 
          mode="TOCmultiplePage"/>
        <xsl:apply-templates
          select="$application_protocol_xml/application_protocol"/>
        <br/><br/>
        <p>&#169; ISO <xsl:value-of select="$application_protocol_xml/application_protocol/@publication.year"/> &#8212; All rights reserved</p>

      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
