<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:template match="/" >
    <xsl:apply-templates select="./module_clause" />
  </xsl:template>


  <xsl:template match="module_clause">
    <!-- the XML file to which the stylesheet will be applied 
         NOTE: that the path used by document is relative to the directory
         of this xsl file
         -->
    <xsl:variable 
      name="module_xml_file"
      select="concat('../data/modules/',@directory,'/module.xml')"/>
    <HTML>
      <HEAD>
        <TITLE>
          <!-- output the module page title -->
          <xsl:apply-templates 
            select="document($module_xml_file)/module"
            mode="title"/>
        </TITLE>
      </HEAD>
      <BODY>
        <!-- output the Table of contents banner -->
        <xsl:apply-templates 
          select="document($module_xml_file)/module"
          mode="TOCmultiplePage"/>

        <!-- now apply the stylesheet specified in the document -->
        <xsl:apply-templates select="document($module_xml_file)/module"/>
      </BODY>
    </HTML>
  </xsl:template>


</xsl:stylesheet>
