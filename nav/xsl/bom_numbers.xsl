<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="../../xsl/document_xsl.xsl" ?>
<!--
$Id: bom_numbers.xsl,v 1.3 2009/02/04 16:08:43 mikeward Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: Display an numerical list of business_object_models.
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
	<xsl:sort select="@part"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="function-available('msxsl:node-set')">
      <xsl:variable 
        name="business_object_models-node-set" 
        select="msxsl:node-set($business_object_model_nodes)"/>
      <xsl:for-each select="$business_object_models-node-set/business_object_models/business_object_model">
	<xsl:sort select="@part" data-type="number"/>
<!--        <xsl:variable name="letter" 
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
-->
        <xsl:apply-templates select=".">
	  <xsl:with-param name="part_no" select="'yes'"/>
	</xsl:apply-templates>
      </xsl:for-each>
    </xsl:when>

    <xsl:when test="function-available('saxon:node-set')">
      <xsl:variable 
        name="business_object_models-node-set" 
        select="saxon:node-set($business_object_model_nodes)"/>
      <xsl:for-each select="$business_object_models-node-set/business_object_models/business_object_model">
	<xsl:sort select="@part"/>
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
        <xsl:apply-templates select=".">
	  <xsl:with-param name="part_no" select="'yes'"/>
	</xsl:apply-templates>
      </xsl:for-each>
    </xsl:when>

	<xsl:when test="function-available('exslt:node-set')">
      <xsl:variable 
        name="business_object_models-node-set" 
        select="exslt:node-set($business_object_model_nodes)"/>
      <xsl:for-each select="$business_object_models-node-set/business_object_models/business_object_model">
	<xsl:sort select="@part"/>
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
        <xsl:apply-templates select=".">
	  <xsl:with-param name="part_no" select="'yes'"/>
	</xsl:apply-templates>
      </xsl:for-each>
    </xsl:when>

    <xsl:otherwise>
      XSL require node-set function1.
      Currently checks for SAXON MSXML
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="business_object_model" mode="copy">
  <xsl:element name="business_object_model">
    <xsl:attribute name="part">
      <xsl:value-of select="@part"/>
    </xsl:attribute>
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
  <xsl:apply-templates select=".">
	  <xsl:with-param name="part_no" select="'yes'"/>
  </xsl:apply-templates>
</xsl:template>

</xsl:stylesheet>