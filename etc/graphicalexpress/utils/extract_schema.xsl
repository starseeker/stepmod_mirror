<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
     $Id: extract_schema.xsl,v 1.0 2002-06-06 07:58:26+01 rob Exp rob $

  Author: Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep and supplied to NIST under contract.
  Purpose: 
     Extract a schema from a file
-->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>

<xsl:output 
  method="xml"
  indent="yes"
  doctype-system="../../../dtd/express.dtd"
  omit-xml-declaration="yes"
  />


<xsl:template match="schema">

<xsl:processing-instruction name="xml-stylesheet">
  type="text/xsl" 
  href="../../../xsl/express.xsl"
</xsl:processing-instruction>
<xsl:text>

</xsl:text>
  <xsl:element name="express">
    <xsl:copy-of select="/express/@*"/>
    <xsl:apply-templates select="/express/application"/>

    <xsl:copy-of select="."/>
  </xsl:element>
</xsl:template>


<xsl:template match="application">
  <xsl:copy-of select="."/>
</xsl:template>

</xsl:stylesheet>

