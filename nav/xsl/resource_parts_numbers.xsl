<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: resource_parts_numbers.xsl,v 1.5 2002/09/11 17:10:57 robbod Exp $
  Author: Tom Hendrix, Boeing.
  Purpose: Display an index of resource parts ordered by part number
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:saxon="http://icl.com/saxon"
  extension-element-prefixes="msxsl saxon"
  version="1.0">

  <xsl:import href="resource_part_list.xsl"/>

  <xsl:output method="html"/>

<xsl:template match="resource_docs">
  <xsl:apply-templates select="resource_doc">
    <xsl:with-param name="part_no" select="'yes'"/>
    <xsl:sort select="@part"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="resource_docs" mode="deprecated">
  <xsl:variable name="resource_docs">
    <xsl:element name="resource_docs">
      <xsl:apply-templates select="./resource_doc" mode="get_node"/>
    </xsl:element>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="function-available('msxsl:node-set')">
      <xsl:variable name="resdoc-node-set" select="msxsl:node-set($resource_docs)"/>
      <xsl:apply-templates select="$resdoc-node-set/resource_docs/resource_doc">
        <xsl:with-param name="part_no" select="'yes'"/>
        <xsl:sort select="@part"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="function-available('saxon:node-set')">
      <xsl:variable name="resdoc-node-set" select="saxon:node-set($resource_docs)"/>
      <xsl:apply-templates select="$resdoc-node-set/resource_docs/resource_doc">
        <xsl:with-param name="part_no" select="'yes'"/>
        <xsl:sort select="@part"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      XSL require node-set function.
      Currently checks for SAXON MSXML3
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="resource_doc" mode="get_node">
  <xsl:variable name="res_doc" 
    select="concat('../../data/resource_docs/',@name,'/resource.xml')"/>
  <xsl:element name="resource_doc">
    <xsl:attribute name="name">
      <xsl:value-of select="@name"/>
    </xsl:attribute>
    <xsl:attribute name="part">
      <xsl:value-of select="document($res_doc)/resource/@part"/>
    </xsl:attribute>
  </xsl:element>
</xsl:template>

</xsl:stylesheet>