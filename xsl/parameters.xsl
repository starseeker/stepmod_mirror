<?xml version="1.0"?>
<!--
     $Id: parameters.xsl,v 1.1 2001/10/22 09:34:10 robbod Exp $

  Author: Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep and supplied to NIST under contract.
  Purpose: 
     Used to display the commented XML encoded Express generated 
     from GraphicalExpress 
-->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>

  <!-- parameters that control the output -->

  <!-- the name of a cascading stylesheet. If no cascading stylesheets
       are required do set the paramter null -->
  <!-- <xsl:param name="output_css" select="'test.css'"/> -->
  <xsl:param name="output_css" select="''"/>

  <!-- When YES the Table of schema table of contents will be output -->
  <xsl:param name="output_toc" select="'YES'"/>

  <!-- When YES the RCS version control informatin will be output 
       Used by:
       xsl:template match="module" mode="title" in common.xsl
       xsl:template match="module" mode="TOCbannertitle" in common.xsl
       -->
  <xsl:param name="output_rcs" select="'YES'"/>



</xsl:stylesheet>