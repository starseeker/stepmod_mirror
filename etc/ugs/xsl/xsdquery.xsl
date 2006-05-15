<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="../../../xsl/document_xsl.xsl" ?>
<!--
$Id: xsdquery.xsl,v 1.1 2005/08/05 23:50:18 thendrix Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     Templates that are common to most other stylesheets
-->
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:exslt="http://exslt.org/common"
  exclude-result-prefixes="msxsl exslt"
  version="1.0">

  <xsl:output method="html"/>
  <xsl:template match="query" >
    <xsl:variable name="xpath"><xsl:value-of select="@xpath"/></xsl:variable>
<!-- these work
    <xsl:variable name="doc_node" select="document('PLMXMLAnnotationSchema.xsd')//*[@name]"/> 
    <xsl:variable name="doc_node" select="document('PLMXMLAnnotationSchema.xsd')//xsd:complexType[@name]"/> 
    <xsl:variable name="doc_node" select="document('PLMXMLAnnotationSchema.xsd')//xsd:complexType"/>
    <xsl:variable name="doc_node" select="document('PLMXMLAnnotationSchema.xsd')//xsd:restriction[child::xsd:enumeration]"/>
-->


    <xsl:variable name="doc_node" select="document('../xsd/PLMXMLAnnotationSchema.xsd')//*"/>
    <xsl:for-each select="$doc_node">
      <xsl:value-of select="@name" />
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
