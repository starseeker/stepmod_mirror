<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_abstract.xsl,v 1.1 2003/03/27 15:36:12 thendrix Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="resource.xsl"/>


  <xsl:output 
    method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    indent="yes"
    />



  <xsl:template match="/" >
    <xsl:apply-templates select="./resource_clause" />
  </xsl:template>
  
  <xsl:template match="resource_clause">

    <xsl:variable 
      name="resource_xml_file"
      select="concat('../../data/resource_docs/',@directory,'/resource.xml')"/>

    <xsl:variable 
      name="resource_xml"
      select="document($resource_xml_file)/resource" />


    <HTML>
      <HEAD>
      <TITLE>
        <!-- output the resource page title -->
        <xsl:apply-templates select="." mode="title">
          <xsl:with-param name="resdoc" select="$resource_xml"/>
          </xsl:apply-templates>
      </TITLE>
      </HEAD>
      <BODY>
        <xsl:apply-templates 
          select="$resource_xml"
          mode="abstract"/>
      </BODY>
    </HTML>
  </xsl:template>

<!-- for abstracts, which do not have a TOC and therefore
     do not get build in resources, but in sect_abstract.
-->

<xsl:template match="resource_clause" mode="title">
  <xsl:param name="resdoc" />
  <xsl:variable
    name="lpart">
    <xsl:choose>
      <xsl:when test="string-length(@directory)>0">
        <xsl:value-of select="@directory"/>
      </xsl:when>
      <xsl:otherwise>
        XXXX
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="stdnumber">
    <xsl:call-template name="get_resdoc_stdnumber">
      <xsl:with-param name="resdoc" select="$resdoc"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="resdoc_name">
    <xsl:call-template name="res_display_name">
      <xsl:with-param name="res" select="@directory"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="concat($stdnumber,' ',$resdoc_name)"/>


</xsl:template>


</xsl:stylesheet>