<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: ballot_list.xsl,v 1.5 2002/08/16 14:05:23 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited http://www.eurostep.com
  Purpose: To display the modules according to ballot packages

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">


  <xsl:import href="./ballot_list.xsl"/>


  <xsl:output 
    method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    indent="yes"/>

<xsl:template match="ballot_index">
  <HTML>
    <head>
      <title>
        <xsl:value-of select="@name"/>
      </title>
    </head>
    <body>

      <xsl:call-template name="output_menubar">
        <xsl:with-param name="module_root" select="'.'"/>
        <xsl:with-param name="module_name" select="@name"/>
        <xsl:with-param name="new_menubar_file" 
          select="concat('./ballots/ballots/',@name,'/menubar_ballot.xml')"/>
      </xsl:call-template>
      <hr/>
      <p align="center">
        <xsl:apply-templates select="./ballot_package" mode="TOC"/>
      </p>
      
      <xsl:call-template name="ballot_header"/>
      <xsl:apply-templates select="./description"/>
      <xsl:apply-templates select="./cvs_tags"/>
    </body>
  </HTML>
</xsl:template>


<xsl:template match="cvs_tags">
  <h3>CVS TAGS</h3>
  The following CVS tags have been created for the ballot package.
  <xsl:apply-templates select="./cvs_tag"/>
</xsl:template>


<xsl:template match="cvs_tag">
  <hr/>
  <h4>CVS tag: <xsl:value-of select="@tag"/></h4>
  <xsl:apply-templates/>
</xsl:template>



</xsl:stylesheet>