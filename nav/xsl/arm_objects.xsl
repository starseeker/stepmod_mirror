<?xml version="1.0" encoding="utf-8"?>

<!--
$Id: module.xsl,v 1.19 2002/01/06 08:46:40 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:saxon="http://icl.com/saxon"
  version="1.0">

  <xsl:import href="express_index.xsl"/>


  <xsl:output method="html"/>

  <xsl:template match="/" >
    <xsl:apply-templates select="./stylesheet_application"/>
  </xsl:template>

  <xsl:template match="stylesheet_application">
    <xsl:apply-templates 
      select="document('../../repository_index.xml')/repository_index">
      <xsl:with-param name="arm_mim" select="'arm'"/>
    </xsl:apply-templates>
  </xsl:template>

</xsl:stylesheet>