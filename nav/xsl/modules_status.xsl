<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: modules_alpha.xsl,v 1.3 2002/09/11 11:47:49 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: Display modules grouped according to state.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:saxon="http://icl.com/saxon"
  extension-element-prefixes="msxsl saxon"
  version="1.0">


  <xsl:import href="modules_list.xsl"/>

  <xsl:output method="html"/>

  <xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

<xsl:template match="modules">
  <xsl:variable name="modules">
    <xsl:element name="modules">
      <xsl:apply-templates select="./module" mode="copy">
        <xsl:sort select="@status"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="function-available('msxsl:node-set')">
      <xsl:variable name="modules-node-set" select="msxsl:node-set($modules)"/>
      <xsl:apply-templates select="$modules-node-set/modules/module" 
        mode="status"/>
    </xsl:when>

    <xsl:when test="function-available('saxon:node-set')">
      <xsl:variable name="modules-node-set" select="saxon:node-set($modules)"/>

      <xsl:apply-templates select="$modules-node-set/modules/module" 
        mode="status"/>
    </xsl:when>
    <xsl:otherwise>
      XSL require node-set function.
      Currently checks for SAXON MSXML3
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>


<xsl:template match="module" mode="copy">
   <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="name">
      <xsl:value-of select="@name"/>
    </xsl:attribute>
    <xsl:attribute name="part">
      <xsl:value-of select="@part"/>
    </xsl:attribute>
    <xsl:attribute name="status">
      <xsl:choose>
        <xsl:when test="string-length(@status) != 0">
          <xsl:value-of select="@status"/>
        </xsl:when>
        <xsl:otherwise>in development</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:copy>
</xsl:template>

<xsl:template match="module" mode="status">
  <xsl:variable name="status" select="@status"/>
  <!-- return the node if the it is the first occurrence of a node with a
       given projlead -->
  <xsl:variable name="prev" 
    select="self::*[not(@status = preceding-sibling::*/@status)]"/>
  <xsl:if test="string-length($prev/@status)!=0">
    <p class="alpha">
      <A NAME="{$status}">
        <xsl:value-of select="$prev/@status"/>
      </A>
    </p>
  </xsl:if>

  <xsl:apply-templates select="."/>
</xsl:template>

</xsl:stylesheet>