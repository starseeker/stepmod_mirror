<?xml version="1.0"?>
<!--
     $Id: armschema.xsl,v 1.1 2001/06/29 18:45:30 lubell Exp $
-->

<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html"/>

  <xsl:template match="module">
<html>
  <head>
    <title>ARM EXPRESS Schema</title>
  </head>
  <body>
    <h2>ARM EXPRESS Schema for <xsl:apply-templates select="name"/>
 Application Module</h2>
    <xsl:apply-templates select="arm"/>
  </body>
</html>
  </xsl:template>

  <xsl:template match="arm">
    <xsl:apply-templates select="schema_decl"/>
  </xsl:template>

  <xsl:template match="schema_decl">
<p><code>
SCHEMA <xsl:apply-templates select="schema_id"/>;
</code></p>
    <xsl:apply-templates select="entity_decl"/>
<p><code>
END_SCHEMA;
</code></p>
  </xsl:template>

  <xsl:template match="entity_decl">
<p><code>
ENTITY <xsl:apply-templates select="entity_id"/>;<br />
    <xsl:apply-templates select="explicit_attr_block"/>
    <xsl:apply-templates select="unique_clause"/>
    <xsl:apply-templates select="where_clause"/>
END_ENTITY;
</code></p>
  </xsl:template>

  <xsl:template match="explicit_attr">
    <xsl:apply-templates select="attribute_id"/>
    <xsl:text> : </xsl:text>
    <xsl:apply-templates select="optional"/>
    <xsl:apply-templates select="base_type"/>
    <xsl:text>;</xsl:text>
<br />
  </xsl:template>

  <xsl:template match="optional">
    <xsl:text>OPTIONAL </xsl:text>
  </xsl:template>

  <xsl:template match="string">
    <xsl:text>STRING</xsl:text>
  </xsl:template>
  
  <xsl:template match="unique_clause">
    <xsl:text>UNIQUE</xsl:text>
<br />
    <xsl:apply-templates select="unique_rule"/>
  </xsl:template>

  <xsl:template match="unique_rule">
    <xsl:apply-templates select="label"/>
    <xsl:text>: </xsl:text>
    <xsl:apply-templates select="attribute_ref"/>
  </xsl:template>

  <xsl:template match="unique_rule/attribute_ref">
    <xsl:value-of select="."/>
    <xsl:choose>
      <xsl:when test="position()=last()">
        <xsl:text>;</xsl:text>
<br />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>, </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>