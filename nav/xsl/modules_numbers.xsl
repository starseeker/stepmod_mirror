<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: modules_numbers.xsl,v 1.4 2002/09/11 08:26:07 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: Display an index of modules ordered by part number
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:saxon="http://icl.com/saxon"
  extension-element-prefixes="msxsl saxon"
  version="1.0">

  <xsl:import href="modules_list.xsl"/>

  <xsl:output method="html"/>

<xsl:template match="modules">
  <xsl:apply-templates select="module">
    <xsl:with-param name="part_no" select="'yes'"/>
    <xsl:sort select="@part"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="modules" mode="deprecated">
  <xsl:variable name="modules">
    <xsl:element name="modules">
      <xsl:apply-templates select="./module" mode="get_node"/>
    </xsl:element>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="function-available('msxsl:node-set')">
      <xsl:variable name="modules-node-set" select="msxsl:node-set($modules)"/>
      <xsl:apply-templates select="$modules-node-set/modules/module">
        <xsl:with-param name="part_no" select="'yes'"/>
        <xsl:sort select="@part"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="function-available('saxon:node-set')">
      <xsl:variable name="modules-node-set" select="saxon:node-set($modules)"/>
      <xsl:apply-templates select="$modules-node-set/modules/module">
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


<xsl:template match="module" mode="get_node">
  <xsl:variable name="mod_doc" 
    select="concat('../../data/modules/',@name,'/module.xml')"/>
  <xsl:element name="module">
    <xsl:attribute name="name">
      <xsl:value-of select="@name"/>
    </xsl:attribute>
    <xsl:attribute name="part">
      <xsl:value-of select="document($mod_doc)/module/@part"/>
    </xsl:attribute>
  </xsl:element>
</xsl:template>

</xsl:stylesheet>