<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="../../../xsl/document_xsl.xsl" ?>
<!--
$Id: extract_schema.xsl,v 1.1 2005/08/05 23:50:18 thendrix Exp $

Author: Tom Hendrix, adapted from GE version.
Owner:  sourceforge stepmod
Purpose: 
Extract a schema from an xsd  file
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
    <xsl:variable name="doc_node" select="document('PLMXMLAnnotationSchema.xsd')//xsd:complexType[@name]"/> -->

    <xsl:variable name="doc_node" select="document('PLMXMLAnnotationSchema.xsd')//xsd:complexType"/>

    <xsl:for-each select="$doc_node">
      <xsl:value-of select="@name" />
    <xsl:message>GOT HERE 1
    </xsl:message>
    </xsl:for-each>
    <xsl:message>
doc_node:<xsl:value-of  select="$doc_node"/>:doc_node
    </xsl:message>
  </xsl:template>
</xsl:stylesheet>
