<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
     $Id: extract_descriptions.xsl,v 1.2 2002/03/19 15:13:42 robbod Exp $

  Author: Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep and supplied to NIST under contract.
  Purpose: 
     Used to extract the description elements out of a an EXPRESS XML file
-->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>

  <xsl:import href="../common.xsl"/>

<xsl:output 
  method="xml"
  indent="yes"
  omit-xml-declaration="yes"
  encoding="utf-8"
  />





<xsl:template match="express">

<xsl:processing-instruction name="xml-stylesheet">
  type="text/xsl" 
  href="../../../xsl/descriptions.xsl"</xsl:processing-instruction>

<xsl:processing-instruction name="DOCTYPE">
  express SYSTEM "../../../dtd/description.dtd"</xsl:processing-instruction>
  <xsl:element name="ext_descriptions">
    <xsl:attribute name="module_directory">
      <xsl:call-template name="module_name">
        <xsl:with-param name="module" select="./schema/@name"/>
      </xsl:call-template>
    </xsl:attribute>

    <xsl:variable name="type"
      select="substring(./schema/@name, string-length(./schema/@name)-3)"/>

    <xsl:attribute name="schema_file">
      <xsl:choose>
        <xsl:when test="$type='_mim'">
          <xsl:value-of select="'mim.xml'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'arm.xml'"/> 
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>

  <xsl:attribute name="rcs.date">
    <xsl:value-of select="'$Date: 2002/03/19 15:13:42 $'"/>
  </xsl:attribute>
  <xsl:attribute name="rcs.revision">
    <xsl:value-of select="'$Revision: 1.2 $'"/>
  </xsl:attribute>

    <xsl:apply-templates select="schema">      
      <xsl:sort select="./schema/@name"/>
    </xsl:apply-templates> 
  </xsl:element>
</xsl:template>

<xsl:template match="description">
  <xsl:apply-templates select="node()" mode="copy"/>
</xsl:template>

<xsl:template match="*" mode="copy">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <!-- recurse through rest of the elements - a deep copy -->
    <xsl:apply-templates select="node()" mode="copy"/>
  </xsl:copy>
</xsl:template>



<xsl:template match="schema">
  <!-- 
  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="linkend" select="translate(@name,$UPPER, $LOWER)"/>
  -->
  <xsl:variable name="linkend" select="@name"/>
  <xsl:comment> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  <xsl:value-of select="concat(' Schema: ',@name,' ')"/>
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ </xsl:comment>
  <xsl:element name="ext_description">
    <xsl:attribute name="linkend">
      <xsl:value-of select="$linkend"/>
    </xsl:attribute>
    <!-- <xsl:copy-of select="./description"/> -->
    <xsl:apply-templates select="./description"/>
  </xsl:element>
  <xsl:apply-templates select="./constant"/>
  <xsl:apply-templates select="./type"/>
  <xsl:apply-templates select="./entity"/>
  <xsl:apply-templates select="./rule"/>
  <xsl:apply-templates select="./function"/>
  <xsl:apply-templates select="./procedure"/>
</xsl:template>

<xsl:template match="entity">
  <!--
  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="linkend" 
    select="concat(
            translate(../@name,$UPPER, $LOWER),
            '.',
            translate(@name,$UPPER, $LOWER))"/>
  -->
  <xsl:variable name="linkend" 
    select="concat(../@name, '.', @name)"/>
  <xsl:comment> 
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  <xsl:value-of select="concat(' Schema: ',../@name,' ')"/>
  <xsl:value-of select="concat(' Entity: ',@name,' ')"/>
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
  </xsl:comment>
  <xsl:element name="ext_description">
    <xsl:attribute name="linkend">
      <xsl:value-of select="$linkend"/>
    </xsl:attribute>
    <!-- <xsl:copy-of select="./description"/> -->
    <xsl:apply-templates select="./description"/>
  </xsl:element>
  <xsl:apply-templates select="explicit|derived|inverse"/>
  <xsl:apply-templates select="where"/>
  <xsl:apply-templates select="unique"/>
</xsl:template>


<xsl:template match="explicit|derived|inverse">
  <!--
  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="linkend" 
    select="concat(
            translate(../../@name,$UPPER, $LOWER),
            '.',
            translate(../@name,$UPPER, $LOWER),
            '.',
            translate(@name,$UPPER, $LOWER))"/>
  -->
  <xsl:variable name="linkend" 
    select="concat(../../@name,'.',../@name,'.',@name)"/>
  <xsl:comment> 
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  <xsl:value-of select="concat(' Schema: ',../../@name,' ')"/>
  <xsl:value-of select="concat(' Entity: ',../@name,' ')"/>
  <xsl:value-of select="concat(' Attribute: ',@name,' ')"/>
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
  </xsl:comment>
  <xsl:element name="ext_description">
    <xsl:attribute name="linkend">
      <xsl:value-of select="$linkend"/>
    </xsl:attribute>
    <!-- <xsl:copy-of select="./description"/> -->
    <xsl:apply-templates select="./description"/>
  </xsl:element>
</xsl:template>

<xsl:template match="where">
  <!--
  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="linkend" 
    select="concat(
            translate(../../@name,$UPPER, $LOWER),
            '.',
            translate(../@name,$UPPER, $LOWER),
            '.wr:',
            translate(@label,$UPPER, $LOWER))"/>
  -->
  <xsl:variable name="linkend" 
    select="concat(../../@name,'.',../@name,'.wr:',@label)"/>
  <xsl:comment> 
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  <xsl:value-of select="concat(' Schema: ',../../@name,' ')"/>
  <xsl:value-of select="concat(' Entity: ',../@name,' ')"/>
  <xsl:value-of select="concat(' Where: ',@label,' ')"/>
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
  </xsl:comment>
  <xsl:element name="ext_description">
    <xsl:attribute name="linkend">
      <xsl:value-of select="$linkend"/>
    </xsl:attribute>
    <!-- <xsl:copy-of select="./description"/> -->
    <xsl:apply-templates select="./description"/>
  </xsl:element>
</xsl:template>


<xsl:template match="unique">
  <!--
  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="linkend" 
    select="concat(
            translate(../../@name,$UPPER, $LOWER),
            '.',
            translate(../@name,$UPPER, $LOWER),
            '.ur:',
            translate(@label,$UPPER, $LOWER))"/>
  -->
  <xsl:variable name="linkend" 
    select="concat(../../@name,'.',../@name,'.ur:',@label)"/>
  <xsl:comment> 
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  <xsl:value-of select="concat(' Schema: ',../../@name,' ')"/>
  <xsl:value-of select="concat(' Entity: ',../@name,' ')"/>
  <xsl:value-of select="concat(' Unique: ',@label,' ')"/>
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
  </xsl:comment>
  <xsl:element name="ext_description">
    <xsl:attribute name="linkend">
      <xsl:value-of select="$linkend"/>
    </xsl:attribute>
    <!-- <xsl:copy-of select="./description"/> -->
    <xsl:apply-templates select="./description"/>
  </xsl:element>
</xsl:template>



<xsl:template match="type">
  <!--
  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="linkend" 
    select="concat(
            translate(../@name,$UPPER, $LOWER),
            '.',
            translate(@name,$UPPER, $LOWER))"/>
  -->
  <xsl:variable name="linkend" 
    select="concat(../@name,'.',@name)"/>
  <xsl:comment> 
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  <xsl:value-of select="concat(' Schema: ',../@name,' ')"/>
  <xsl:value-of select="concat(' Type: ',@name,' ')"/>
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
  </xsl:comment>
  <xsl:element name="ext_description">
    <xsl:attribute name="linkend">
      <xsl:value-of select="$linkend"/>
    </xsl:attribute>
    <!-- <xsl:copy-of select="./description"/> -->
    <xsl:apply-templates select="./description"/>
  </xsl:element>
</xsl:template>


<xsl:template match="function">
  <!--
  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="linkend" 
    select="concat(
            translate(../@name,$UPPER, $LOWER),
            '.',
            translate(@name,$UPPER, $LOWER))"/>
-->
  <xsl:variable name="linkend" 
    select="concat(../@name,'.',@name)"/>
  <xsl:comment> 
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  <xsl:value-of select="concat(' Schema: ',../@name,' ')"/>
  <xsl:value-of select="concat(' Function: ',@name,' ')"/>
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
  </xsl:comment>
  <xsl:element name="ext_description">
    <xsl:attribute name="linkend">
      <xsl:value-of select="$linkend"/>
    </xsl:attribute>
    <!-- <xsl:copy-of select="./description"/> -->
    <xsl:apply-templates select="./description"/>
  </xsl:element>
</xsl:template>

<xsl:template match="rule">
  <!--
  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="linkend" 
    select="concat(
            translate(../@name,$UPPER, $LOWER),
            '.',
            translate(@name,$UPPER, $LOWER))"/>
-->
  <xsl:variable name="linkend" 
    select="concat(../@name,'.',@name)"/>
  <xsl:comment> 
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  <xsl:value-of select="concat(' Schema: ',../@name,' ')"/>
  <xsl:value-of select="concat(' Rule: ',@name,' ')"/>
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
  </xsl:comment>
  <xsl:element name="ext_description">
    <xsl:attribute name="linkend">
      <xsl:value-of select="$linkend"/>
    </xsl:attribute>
    <!-- <xsl:copy-of select="./description"/> -->
    <xsl:apply-templates select="./description"/>
  </xsl:element>
</xsl:template>

<xsl:template match="procedure">
  <!--
  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="linkend" 
    select="concat(
            translate(../@name,$UPPER, $LOWER),
            '.',
            translate(@name,$UPPER, $LOWER))"/>
-->
  <xsl:variable name="linkend" 
    select="concat(../@name,'.',@name)"/>

  <xsl:comment> 
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  <xsl:value-of select="concat(' Schema: ',../@name,' ')"/>
  <xsl:value-of select="concat(' Procedure: ',@name,' ')"/>
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
  </xsl:comment>
  <xsl:element name="ext_description">
    <xsl:attribute name="linkend">
      <xsl:value-of select="$linkend"/>
    </xsl:attribute>
    <!-- <xsl:copy-of select="./description"/> -->
    <xsl:apply-templates select="./description"/>
  </xsl:element>

</xsl:template>


<xsl:template match="constant">
  <!--
  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="linkend" 
    select="concat(
            translate(../@name,$UPPER, $LOWER),
            '.',
            translate(@name,$UPPER, $LOWER))"/>
-->
  <xsl:variable name="linkend" 
    select="concat(../@name,'.',@name)"/>
  <xsl:comment> 
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  <xsl:value-of select="concat(' Schema: ',../@name,' ')"/>
  <xsl:value-of select="concat(' Constant: ',@name,' ')"/>
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
  </xsl:comment>
  <xsl:element name="ext_description">
    <xsl:attribute name="linkend">
      <xsl:value-of select="$linkend"/>
    </xsl:attribute>
    <!-- <xsl:copy-of select="./description"/> -->
    <xsl:apply-templates select="./description"/>
  </xsl:element>
</xsl:template>


<xsl:template match="subtype.constraint">  
</xsl:template>



<xsl:template match="described.item">

</xsl:template>




</xsl:stylesheet>