<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: modules_list.xsl,v 1.1 2002/09/03 14:25:21 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: Display an alphabetical list of modules.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:saxon="http://icl.com/saxon"
  version="1.0">


  <xsl:import href="modules_list.xsl"/>

  <xsl:output method="html"/>

<xsl:template match="modules">
  <xsl:variable name="modules">
    <xsl:element name="modules">
      <xsl:apply-templates select="./module" mode="get_node"/>
    </xsl:element>
  </xsl:variable>

  <xsl:variable name="modules-node-set" select="msxsl:node-set($modules)"/>

  <!-- now sort the modules -->
  <xsl:variable name="sorted">
    <xsl:element name="modules">
      <xsl:apply-templates select="$modules-node-set/modules/module" mode="copy">
        <xsl:sort select="@projlead"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:variable>

  <xsl:variable name="sorted-node-set" select="msxsl:node-set($sorted)"/>
  <xsl:apply-templates select="$sorted-node-set/modules/module" mode="projlead"/>

  <!--
  <xsl:apply-templates select="$modules-node-set/modules/module" mode="projlead">
    <xsl:sort select="@projlead"/>
  </xsl:apply-templates>
  -->
</xsl:template>


<xsl:template match="module" mode="copy">
  <xsl:element name="module">
    <xsl:attribute name="name">
      <xsl:value-of select="@name"/>
    </xsl:attribute>
    <xsl:attribute name="part">
      <xsl:value-of select="@part"/>
    </xsl:attribute>
    <xsl:attribute name="projlead">
      <xsl:value-of select="@projlead"/>
    </xsl:attribute>
  </xsl:element>
</xsl:template>


<xsl:template match="module" mode="projlead">
  <xsl:variable name="projlead" select="@projlead"/>
  <!-- return the node if the it is the first occurrence of a node with a
       given projlead -->
  <xsl:variable name="prev" 
    select="self::*[not(@projlead = preceding-sibling::*/@projlead)]"/>
  <xsl:if test="string-length($prev/@projlead)!=0">
    <p class="alpha">
      <A NAME="{$projlead}">
        <xsl:value-of select="$prev/@projlead"/>
      </A>
    </p>
  </xsl:if>

  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="module" mode="get_node">
  <xsl:variable name="mod_doc" 
    select="concat('../../data/modules/',@name,'/module.xml')"/>
  <xsl:element name="module">
    <xsl:attribute name="name">
      <xsl:value-of select="@name"/>
    </xsl:attribute>
    <xsl:attribute name="part">
    </xsl:attribute>
    <xsl:attribute name="projlead">
      <xsl:apply-templates
        select="document($mod_doc)/module/contacts/projlead" mode="name"/>
    </xsl:attribute>
  </xsl:element>
</xsl:template>

<xsl:template match="projlead" mode="name">
  <xsl:variable name="ref" select="@ref"/>
  <xsl:variable name="projlead"
    select="document('../../data/basic/contacts.xml')/contact.list/contact[@id=$ref]"/>
  <xsl:apply-templates select="$projlead" mode="name"/>
</xsl:template>

<xsl:template match="contact" mode="name">
  <xsl:apply-templates select="lastname"/>,&#160;
  <xsl:apply-templates select="firstname"/>
</xsl:template>

</xsl:stylesheet>