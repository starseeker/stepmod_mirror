<?xml version="1.0" encoding="utf-8"?>
<!--
$ Id: build.xsl,v 1.9 2003/02/26 02:12:17 thendrix Exp $
   Author:  Rob Bodington, Eurostep Limited
   Owner:   Developed by Eurostep Limited http://www.eurostep.com and supplied to NIST under contract.
   Purpose: To output the front page for a published module.
-->

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exslt="http://exslt.org/common"
  exclude-result-prefixes="exslt"
  version="1.0">
  
  <xsl:import href="../file_ext.xsl"/>

  <xsl:output method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    indent="yes"
    />

  <xsl:template match="module">
    <xsl:variable name="new_page" select="concat('data/modules/',@name,'/sys/cover',$FILE_EXT)"/>
    <html>
      <head>
          <xsl:element name="meta">
            <xsl:attribute name="http-equiv">Refresh</xsl:attribute>
            <xsl:attribute name="content">
              <xsl:value-of select="concat('0; URL=',$new_page)"/>
            </xsl:attribute>
          </xsl:element>
      </head>
      <body>
        <xsl:value-of select="concat('You will be redirected to ',$new_page,' in 0 seconds')"/><br/>
        If not select 
        <a href="{$new_page}">
          <xsl:value-of select="$new_page"/>
        </a>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="application_protocol">
    <xsl:variable name="new_page" select="concat('data/application_protocols/',@name,'/home',$FILE_EXT)"/>
    <html>
      <head>
          <xsl:element name="meta">
            <xsl:attribute name="http-equiv">Refresh</xsl:attribute>
            <xsl:attribute name="content">
              <xsl:value-of select="concat('0; URL=',$new_page)"/>
            </xsl:attribute>
          </xsl:element>
      </head>
      <body>
        <xsl:value-of select="concat('You will be redirected to ',$new_page,' in 0 seconds')"/><br/>
        If not select 
        <a href="{$new_page}">
          <xsl:value-of select="$new_page"/>
        </a>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="resource">
    <xsl:variable name="new_page" select="concat('data/resource_docs/',@name,'/sys/cover',$FILE_EXT)"/>
    <html>
      <head>
          <xsl:element name="meta">
            <xsl:attribute name="http-equiv">Refresh</xsl:attribute>
            <xsl:attribute name="content">
              <xsl:value-of select="concat('0; URL=',$new_page)"/>
            </xsl:attribute>
          </xsl:element>
          <title></title>
      </head>
      <body>
        <xsl:value-of select="concat('You will be redirected to ',$new_page,' in 0 seconds')"/><br/>
        If not select 
        <a href="{$new_page}">
          <xsl:value-of select="$new_page"/>
        </a>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>