<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: expressg.xsl,v 1.1 2002/10/16 00:43:38 thendrix Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: Display the expressg
THIS IS UNDER DEVELOPMENT
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">



  <xsl:output method="html"/>

  <xsl:template match="/">
    <xsl:apply-templates select="expressg"/>
  </xsl:template>

<xsl:template match="expressg">
  <HTML>
    <HEAD>
    </HEAD>
    <BODY bgcolor="#FFFFFF" link="#0000FF" vlink="#800080">
      <xsl:apply-templates select="expressg.page"/>
    </BODY>
  </HTML>
</xsl:template>


<!-- need a way to deal with multiple pages -->
<xsl:template match="expressg.page">
  <xsl:variable name="img" select="@image"/>
  <xsl:variable name="title" select="@title"/>
  <h2><xsl:value-of select="$title"/></h2>
  <img src="{$img}" usemap="#arm"/>
  <map name="arm">
    <xsl:apply-templates select="expressg.element"/>
  </map>
</xsl:template>


<xsl:template match="expressg.element">
  <xsl:variable name="coords" select="@coords"/>
  <xsl:variable name="shape" select="@shape"/>
  <xsl:variable name="href" select="@reference"/>
  <area coords="{$coords}" shape="{$shape}" href="{$href}"/>
</xsl:template>
</xsl:stylesheet>