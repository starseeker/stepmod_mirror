<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_abstract.xsl,v 1.2 2003/08/04 16:39:42 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="module.xsl"/>


  <xsl:output 
    method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    indent="yes"
    />

  <xsl:template match="/" >
    <xsl:apply-templates select="./module_clause" />
  </xsl:template>
  
  <xsl:template match="module_clause">
    <xsl:variable 
      name="module_xml"
      select="document(concat('../data/modules/',@directory,'/module.xml'))"/>

    <HTML>
      <HEAD>
        <xsl:apply-templates select="$module_xml/module" mode="meta_data"/>

        <TITLE>
          <!-- output the module page title -->
          <xsl:apply-templates 
            select="$module_xml/module"
            mode="title"/>
        </TITLE>
      </HEAD>
      <BODY>
        <xsl:apply-templates 
          select="$module_xml/module"
          mode="abstract"/>
      </BODY>
    </HTML>
  </xsl:template>

  <xsl:template match="module_ref">
    <!-- remove all whitespace -->
    <xsl:variable
      name="nlinkend"
      select="translate(@linkend,'&#x9;&#xA;&#x20;&#xD;','')"/>

    <xsl:variable name="module_sect">
      <xsl:choose>
        <xsl:when test="contains($nlinkend,':')">
          <xsl:value-of select="substring-before($nlinkend,':')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$nlinkend"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="module">
      <xsl:call-template name="module_name">
        <xsl:with-param name="module" select="$module_sect"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="string-length(.)>0">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="module_name">
          <xsl:call-template name="module_display_name">
            <xsl:with-param name="module" select="$module"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$module_name"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="express_ref">
    <xsl:variable name="item">
      <xsl:call-template name="get_last_section">
        <xsl:with-param name="path" select="@linkend"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="string-length(.)>0">
        <b><xsl:apply-templates/></b>
      </xsl:when>
      <xsl:otherwise>
        <b><xsl:value-of select="$item"/></b>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


</xsl:stylesheet>