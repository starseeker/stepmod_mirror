<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: merge.xsl,v 1.2 2001/11/23 12:45:47 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: Extracts the basis of a mapping table from the ARM express
        defined in arm.xml.
     The table lists every arm element and attributes and maps them to a
     aim constructs of the same name.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="../../xsl/common.xsl"/>


  <xsl:output 
    method="xml"
    indent="yes"
    omit-xml-declaration="yes"
    encoding="utf-8"
    />
    


  <xsl:template match="/">
    <xsl:processing-instruction name="xml-stylesheet">
      type="text/xsl" 
      href="../../../../xsl/mapping.xsl"</xsl:processing-instruction>
      
    <xsl:element name="module">
      <xsl:variable name="module_name">
        <xsl:call-template name="module_name">
          <xsl:with-param name="module" select="/express/schema/@name"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:attribute name="name">
        <xsl:value-of select="$module_name"/>
      </xsl:attribute>      
      <xsl:attribute name="rcs.date">
        <xsl:value-of select="'$Date: 2002/03/19 15:13:42 $'"/>
      </xsl:attribute>
      <xsl:attribute name="rcs.revision">
        <xsl:value-of select="'$Revision: 1.2 $'"/>
      </xsl:attribute>

      <xsl:element name="mapping_table">
        <xsl:apply-templates select="/express/schema/entity"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="entity">
    <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
    <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>

    <xsl:variable name="arm_entity" 
      select="@name"/>

    <xsl:variable name="aim_entity"
      select="translate($arm_entity,$UPPER,$LOWER)"/>
    <xsl:text>
      
    </xsl:text>
    <xsl:comment>
      <xsl:value-of select="concat('  ++  ',
                            translate($aim_entity,$LOWER,$UPPER), 
                            '  ++ ')"/>
    </xsl:comment>
    <xsl:element name="ae">
      <xsl:attribute name="entity">
        <xsl:value-of select="$arm_entity"/>
      </xsl:attribute>
      <xsl:element name="aimelt">-</xsl:element>
        <!--  <xsl:value-of select="$aim_entity"/> -->
      <xsl:element name="source">-</xsl:element>
      <xsl:element name="refpath">-</xsl:element>
      <xsl:apply-templates select="./explicit"/>
      <xsl:apply-templates select="./inverse"/>
    </xsl:element>
  </xsl:template>

  
  <xsl:template match="explicit|inverse">
    <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
    <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
    <xsl:variable name="aim_attr"
      select="concat(translate(../@name,$UPPER,$LOWER),'.',@name)"/>
    <xsl:element name="aa">
      <xsl:attribute name="attribute">
        <xsl:value-of select="@name"/>
      </xsl:attribute>
      <xsl:apply-templates select="typename"/>
      <xsl:if test="not(./typename)">
        <!-- output PATH -->
        <xsl:element name="aimelt">-</xsl:element>
      </xsl:if>
      <xsl:element name="source">-</xsl:element>
      <xsl:element name="refpath">-</xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="typename">
      <xsl:attribute name="assertion_to">
        <xsl:value-of select="@name"/>
      </xsl:attribute>    
      <xsl:element name="aimelt">PATH</xsl:element>
  </xsl:template>

</xsl:stylesheet>
