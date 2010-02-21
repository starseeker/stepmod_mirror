<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: smrl_crs.xsl,v 1.1 2010/02/19 15:01:26 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: Display a list of ballot packages.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="../../xsl/common.xsl"/>
  <xsl:output method="html"/>

  <xsl:template match="/" >
    <xsl:apply-templates select="./stylesheet_application"/>
  </xsl:template>

  <xsl:template match="stylesheet_application">
    <xsl:apply-templates select="document('../../config_management/tags.xml')/tags"/>
  </xsl:template>

  
  <xsl:template match="tags">
  <html>
    <head>
      <link rel="stylesheet" type="text/css" href="./css/nav.css"/>
      <title>
        CVS tags
      </title>
    </head>
    <body>
      <h1>Record of CVS tags </h1>
      <p>
        This contains a list of the CVS tags applied to the CVS repository as recorded in:
        stepmod/config_management/tags.xml
      </p>
      <xsl:apply-templates select="tag"/>
    </body>
  </html>
</xsl:template>


  <xsl:template match="tag">
    <h3>
      <a name="{@name}">
        <xsl:value-of select="@name"/>
      </a>
    </h3>
    <table>
      <tr>
        <td>Date:</td><td><xsl:value-of select="@date"/></td>
      </tr>
      <tr>
        <td>Tagged by:</td><td><xsl:value-of select="@taggedby"/></td>
      </tr>      
      <tr>
        <td>Description:</td><td><xsl:apply-templates select="description"/></td>
      </tr>
    </table>
   
  </xsl:template>

</xsl:stylesheet>