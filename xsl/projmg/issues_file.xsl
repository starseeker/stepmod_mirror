<?xml version="1.0" encoding="utf-8"?>
<!--
     $Id: express.xsl,v 1.35 2001-09-04 14:23:37+01 rob Exp rob $

  Author: Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep and supplied to NIST under contract.
  Purpose: 
     Used to display the issues raised against the a module
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:output method="html"/>


  <xsl:template match="issues">
    <html>
      <title>
        <xsl:value-of select="concat(/issues/@module,' - issues')"/>
      </title>

      <body>
        <xsl:apply-templates select="issue"/>
      </body>
    </html>
  </xsl:template>




  <xsl:template match="issue">
    <xsl:variable name="issue_target" 
      select="translate(
              concat(string(@id), string(@by)),
              '&#xA;', '' ) "/>
    
    <xsl:variable name="href" select="concat(@file,'#',@linkend)"/>
    <xsl:variable name="status" select="@status"/>
    
    <p class="{$status}">
    <hr size="3" />      
      <i>
        <b>
          
          issue:
          <A NAME="{$issue_target}"> 
          <xsl:value-of select="concat(
                                string(@id), 
                                ' by ', string(@by),
                                ' (', string(@date), 
                                ')')" /> 
          </A>
        </b>
        against 
        <a href="{$href}">
          <xsl:value-of select="@linkend"/>
        </a>
      </i>
    <br/>
    <xsl:apply-templates />
    </p>
  </xsl:template>

  <xsl:template match="description">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="status">
  <blockquote>
    <b>Status: </b>
    <i><xsl:value-of select="string(@status)" /></i>
    (<xsl:value-of select="concat(string(@by),' ', string(@date))" />
    <b>)</b><br/>
    <xsl:apply-templates />
  </blockquote>
  </xsl:template>

</xsl:stylesheet>