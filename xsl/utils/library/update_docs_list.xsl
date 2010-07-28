<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
     $Id:  $

     Used to update the file docs.xml when a CR is merged
     into the SMRL.
-->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>

<xsl:output 
  method="xml"
  indent="yes"
  omit-xml-declaration="yes"
  doctype-system="../../dtd/part1000/docs.dtd"
  encoding="utf-8"
  />

<xsl:param name="CR_list_URI"/>

<xsl:param name="CR_pub_year_mo"/>

<xsl:template match="docs">
  <xsl:copy>
    <xsl:apply-templates select="node()|attribute()|comment()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="doc">
  <xsl:variable name="name" select="@name"/>
  <xsl:variable name="pub_year_mo">
    <xsl:choose>
      <xsl:when test="document($CR_list_URI)/docs/doc[@name = $name]">
	<xsl:value-of select="$CR_pub_year_mo"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="@pub_year_mo"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="edition">
    <xsl:choose>
      <xsl:when test="document($CR_list_URI)/docs/doc[@name = $name]">
	<xsl:value-of select="number(@edition) + 1"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="@edition"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <doc name="{@name}" series="{@series}" part="{@part}" pub_type="{@pub_type}" edition="{$edition}" pub_year_mo="{$pub_year_mo}" format="{@format}">
    <xsl:apply-templates select="tc"/>
  </doc>
</xsl:template>

<xsl:template match="tc|comment()">
  <xsl:copy-of select="."/>
</xsl:template>

</xsl:stylesheet>
