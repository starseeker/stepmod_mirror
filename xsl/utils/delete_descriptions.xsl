<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
     $Id: extract_descriptions.xsl,v 1.3 2002/03/19 16:29:42 robbod Exp $

  Author: Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep and supplied to NIST under contract.
  Purpose: 
     Used to delete the description elements from an EXPRESS XML file
-->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>

  <xsl:import href="../common.xsl"/>

<xsl:output 
  method="xml"
  indent="yes"
  omit-xml-declaration="yes"
  encoding="utf-8"
  />


<!-- Start everything going -->
<xsl:template match="/">
  <xsl:apply-templates mode="copy"/>
</xsl:template>


<!-- make a copy of everything in the file --> 
<xsl:template match="*" mode="copy">
  <!-- create a shallow copy of the element being matched -->
  <xsl:copy>
    <!-- copy all the attributes of the element -->
    <xsl:copy-of select="@*"/>    
    <!-- recurse through rest of the elements - a deep copy -->
    <xsl:apply-templates select="node()" mode="copy"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="express" mode="copy">
  <!-- create a shallow copy of the element being matched -->
  <xsl:copy>
    <!-- copy all the attributes of the element -->
    <xsl:copy-of select="@*"/>    
    <!-- add description attribute -->
    <xsl:attribute name="description.file">arm_descriptions.xml</xsl:attribute>
    <!-- recurse through rest of the elements - a deep copy -->
    <xsl:apply-templates select="node()" mode="copy"/>    
  </xsl:copy>
</xsl:template>


<xsl:template match="description" mode="copy"/>


</xsl:stylesheet>