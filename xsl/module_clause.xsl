<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: module_clause.xsl,v 1.6 2003/03/11 23:56:56 robbod Exp $
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
      name="module_xml"
      select="document(concat('../data/modules/',@directory,'/module.xml'))"/>
    <HTML>
      <HEAD>
        <!-- apply a cascading stylesheet.
             The stylesheet will only be applied if the parameter output_css
             is set in parameter.xsl 
             -->
        <xsl:call-template name="output_css">
          <xsl:with-param name="path" select="'../../../../css/'"/>
        </xsl:call-template>

        <xsl:apply-templates select="$module_xml/module" mode="meta_data"/>

        <TITLE>
          <!-- output the module page title -->
          <xsl:apply-templates 
            select="$module_xml/module"
            mode="title"/>
        </TITLE>
      </HEAD>
      <BODY>
        <!-- debug <xsl:message><xsl:value-of select="$global_xref_list"/></xsl:message> -->
        <!-- output the Table of contents banner -->
        <xsl:apply-templates 
          select="$module_xml/module"
          mode="TOCmultiplePage"/>

        <!-- now apply the stylesheet specified in the document -->
        <xsl:apply-templates select="$module_xml/module"/>

        <br/><br/>
        <p>&#169; ISO <xsl:value-of select="$module_xml/module/@publication.year"/> &#8212; All rights reserved</p>
      </BODY>
    </HTML>
  </xsl:template>


</xsl:stylesheet>
