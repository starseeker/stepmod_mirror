<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: application_protocol_clause.xsl,v 1.9 2003/05/21 14:37:17 robbod Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose:     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:import href="../module_clause.xsl"/>
	
  <xsl:template match="/" >
    <xsl:apply-templates select="./application_protocol_clause"/>
  </xsl:template>
	
  <xsl:template match="application_protocol_clause">
    <xsl:variable name="application_protocol_xml_file" 
      select="concat('../../data/application_protocols/',@directory,'/application_protocol.xml')"/>
    
    <!-- RBN don't think that we need this
    <xsl:variable name="module_xml_file" 
      select="concat('../../data/modules/',@module_directory,'/module.xml')"/>
    -->

    <html>
      <head>
        <title>
          <xsl:apply-templates 
            select="document($application_protocol_xml_file)/application_protocol" mode="title"/>
        </title>
      </head>
      <body bgcolor="#FAFAFA">
        <xsl:apply-templates 
          select="document($application_protocol_xml_file)/application_protocol" 
          mode="TOCmultiplePage"/>
        <xsl:apply-templates select="document($application_protocol_xml_file)/application_protocol"/>

        <!-- RBN don't think that we need this
        <xsl:apply-templates select="document($module_xml_file)/module"/>
        -->
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
