<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: module_clause.xsl,v 1.1 2001/10/05 07:52:22 robbod Exp $
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
        <!-- apply a cascading stylesheet.
             the stylesheet will only be applied if the parameter output_css
             is set in parameter.xsl 
             -->
        <xsl:call-template name="output_css">
          <xsl:with-param name="path" select="'../../../../css/'"/>
        </xsl:call-template>
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
