<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: index.xsl,v 1.1 2002/06/20 12:49:08 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited http://www.eurostep.com
  Purpose: To display the ballot packages
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="../../xsl/common.xsl"/>


  <xsl:output 
    method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    indent="yes"
    />


  <xsl:template match="/">
    <HTML>
      <head>
        <title>
          Module Ballots
        </title>
      </head>
      <body>
        <h2>Module ballots</h2>
        <xsl:call-template name="output_menubar">
          <xsl:with-param name="module_root" select="'./pdm_ballot_072002/'"/>
          <xsl:with-param name="module_name" select="@name"/>
        </xsl:call-template>
        <hr/>

        <p>
          The modules have been balloted according to the following ballot
          packages. 
        </p>
        <ul>
          <xsl:apply-templates select="./ballots/ballot"/>
        </ul>
      </body>
    </HTML>
  </xsl:template>

  <xsl:template match="ballot">
    <li>
      <xsl:variable name="xref" 
        select="concat('./ballots/',@name,'/start',$FILE_EXT)"/>
      <a href="{$xref}">
        <xsl:value-of select="@name"/>
      </a>
    </li>
  </xsl:template>

</xsl:stylesheet>