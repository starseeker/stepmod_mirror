<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
     $Id: extract_descriptions.xsl,v 1.2 2002/03/19 15:13:42 robbod Exp $

  Author: Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep and supplied to NIST under contract.
  Purpose: 
     Used to extract the mapping table from a module.xml file
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
  doctype-system="../../../dtd/description.dtd"
  encoding="utf-8"
  />





<xsl:template match="module">

<xsl:processing-instruction name="xml-stylesheet">
  type="text/xsl" 
  href="../../../xsl/descriptions.xsl"</xsl:processing-instruction>

  <xsl:element name="ext_mapping_table">
    <xsl:attribute name="module_name">
      <xsl:value-of select="@name"/>
    </xsl:attribute>

    <xsl:attribute name="rcs.date">
      <xsl:value-of select="'$Date: 2002/03/19 15:13:42 $'"/>
    </xsl:attribute>
    <xsl:attribute name="rcs.revision">
      <xsl:value-of select="'$Revision: 1.2 $'"/>
    </xsl:attribute>
    
    <xsl:apply-templates select="mapping_table"/>  

  </xsl:element>
</xsl:template>

<xsl:template match="mapping_table">
  <xsl:apply-templates select="node()" mode="copy"/>
</xsl:template>

<xsl:template match="*" mode="copy">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <!-- recurse through rest of the elements - a deep copy -->
    <xsl:apply-templates select="node()" mode="copy"/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>