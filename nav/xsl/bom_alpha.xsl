<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: bom_alpha.xsl,v 1.2 2005/03/31 22:29:24 mikeward Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: Display an alphabetical list of business_object_models.
-->

<!-- BOM -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:saxon="http://icl.com/saxon"
  xmlns:exslt="http://exslt.org/common"
  extension-element-prefixes="msxsl saxon"
  version="1.0">

  <xsl:import href="bom_list.xsl"/>

  <xsl:output method="html"/>


  <xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

<xsl:template match="business_object_models">

  <xsl:variable name="business_object_model_nodes">
    <xsl:element name="business_object_models">
      <xsl:apply-templates select="./business_object_model" mode="copy">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="function-available('msxsl:node-set')">
      <xsl:variable 
        name="business_object_models-node-set" 
        select="msxsl:node-set($business_object_model_nodes)"/>
      <xsl:for-each select="$business_object_models-node-set/business_object_models/business_object_model">
        <xsl:variable name="letter" 
          select="translate(substring(@name,1,1), $lower, $upper)"/>
        
        <xsl:if test="not($letter = 
                      translate(substring(preceding-sibling::business_object_model[1]/@name,1,1),
                      $lower, $upper))">
          <p class="alpha">
            <A NAME="{$letter}">
              <xsl:value-of select="$letter"/>
            </A>
          </p>
        </xsl:if>
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </xsl:when>

    <xsl:when test="function-available('saxon:node-set')">
      <xsl:variable 
        name="business_object_models-node-set" 
        select="saxon:node-set($business_object_model_nodes)"/>
      <xsl:for-each select="$business_object_models-node-set/business_object_models/business_object_model">
        <xsl:variable name="letter" 
          select="translate(substring(@name,1,1), $lower, $upper)"/>
        
        <xsl:if test="not($letter = 
                      translate(substring(preceding-sibling::business_object_model[1]/@name,1,1),
                      $lower, $upper))">
          <p class="alpha">
            <A NAME="{$letter}">
              <xsl:value-of select="$letter"/>
            </A>
          </p>
        </xsl:if>
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </xsl:when>

	<xsl:when test="function-available('exslt:node-set')">
      <xsl:variable 
        name="business_object_models-node-set" 
        select="exslt:node-set($business_object_model_nodes)"/>
      <xsl:for-each select="$business_object_models-node-set/business_object_models/business_object_model">
        <xsl:variable name="letter" 
          select="translate(substring(@name,1,1), $lower, $upper)"/>
        
        <xsl:if test="not($letter = 
                      translate(substring(preceding-sibling::business_object_model[1]/@name,1,1),
                      $lower, $upper))">
          <p class="alpha">
            <A NAME="{$letter}">
              <xsl:value-of select="$letter"/>
            </A>
          </p>
        </xsl:if>
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </xsl:when>

    <xsl:otherwise>
      XSL require node-set function.
      Currently checks for SAXON MSXML
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="business_object_model" mode="copy">
  <xsl:element name="business_object_model">
    <xsl:attribute name="name">
      <xsl:value-of select="@name"/>
    </xsl:attribute>
  </xsl:element>
</xsl:template>

<xsl:template match="business_object_model" mode="alpha">
  <xsl:variable 
    name="letter"
    select="translate(substring(@name,1,1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>

  <xsl:if test="position()=1">
    <p class="alpha">
      <A NAME="{$letter}">
        <xsl:value-of select="$letter"/>
      </A>
    </p>
  </xsl:if>

  <xsl:apply-templates select="."/>
</xsl:template>

</xsl:stylesheet>