<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="../../xsl/document_xsl.xsl" ?>
<!--
$Id: ap_numbers.xsl,v 1.1 2005/03/31 22:29:29 thendrix Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: Display an alphabetical list of application_protocols.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:saxon="http://icl.com/saxon"
  xmlns:exslt="http://exslt.org/common"
  extension-element-prefixes="msxsl saxon"
  version="1.0">

  <xsl:import href="ap_list.xsl"/>

  <xsl:output method="html"/>


  <xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

<xsl:template match="application_protocols">

  <xsl:variable name="application_protocol_nodes">
    <xsl:element name="application_protocols">
      <xsl:apply-templates select="./application_protocol" mode="copy">
	<xsl:sort select="@part"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="function-available('msxsl:node-set')">
      <xsl:variable 
        name="application_protocols-node-set" 
        select="msxsl:node-set($application_protocol_nodes)"/>
      <xsl:for-each select="$application_protocols-node-set/application_protocols/application_protocol">
	<xsl:sort select="@part" data-type="number"/>
        <xsl:variable name="letter" 
          select="translate(substring(@name,1,1), $lower, $upper)"/>
        
        <xsl:if test="not($letter = 
                      translate(substring(preceding-sibling::application_protocol[1]/@name,1,1),
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

    <xsl:when test="function-available('saxon:node-set')">
      <xsl:variable 
        name="application_protocols-node-set" 
        select="saxon:node-set($application_protocol_nodes)"/>
      <xsl:for-each select="$application_protocols-node-set/application_protocols/application_protocol">
	<xsl:sort select="@part"/>
        <xsl:variable name="letter" 
          select="translate(substring(@name,1,1), $lower, $upper)"/>
        
        <xsl:if test="not($letter = 
                      translate(substring(preceding-sibling::application_protocol[1]/@name,1,1),
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
        name="application_protocols-node-set" 
        select="exslt:node-set($application_protocol_nodes)"/>
      <xsl:for-each select="$application_protocols-node-set/application_protocols/application_protocol">
	<xsl:sort select="@part"/>
        <xsl:variable name="letter" 
          select="translate(substring(@name,1,1), $lower, $upper)"/>
        
        <xsl:if test="not($letter = 
                      translate(substring(preceding-sibling::application_protocol[1]/@name,1,1),
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
      XSL require node-set function.
      Currently checks for SAXON MSXML
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="application_protocol" mode="copy">
  <xsl:element name="application_protocol">
    <xsl:attribute name="part">
      <xsl:value-of select="@part"/>
    </xsl:attribute>
    <xsl:attribute name="name">
      <xsl:value-of select="@name"/>
    </xsl:attribute>
  </xsl:element>
</xsl:template>

<xsl:template match="application_protocol" mode="alpha">
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