<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_help.xsl,v 1.2 2003/07/31 13:01:23 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose:     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:import href="common.xsl"/>
  <xsl:output method="html"/>

  <xsl:template match="/">
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
      <body>
        <h2>Help</h2>

        
        <p>
          This is the collection of HTML pages that make up the AP document
          for: 
          <br/>
          <xsl:variable name="stdnumber">
            <xsl:call-template name="get_protocol_stdnumber">
              <xsl:with-param name="application_protocol" select="$application_protocol_xml/application_protocol"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:value-of select="$stdnumber"/>&#160;
            Application protocol: 
            <xsl:call-template name="protocol_display_name">
              <xsl:with-param name="application_protocol" select="$application_protocol_xml/application_protocol/@title"/>
            </xsl:call-template>

        </p>
        <p>
          All of the modules that are used by this AP are also included.
        </p>
        <p>
          The document is presented as frames as described in the Figure below.
        </p>
        <img alt="frame and menu layout" 
          border="0"
          align="middle"
          src="../../../../images/ap_doc/ap_help.png"/>

      </body>
    </html>
  </xsl:template> 


</xsl:stylesheet>
