<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
     $Id: extract_descriptions.xsl,v 1.3 2002/03/19 16:29:42 robbod Exp $

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
    <xsl:value-of select="'$Date: 2002/03/19 16:29:42 $'"/>
  </xsl:attribute>
  <xsl:attribute name="rcs.revision">
    <xsl:value-of select="'$Revision: 1.3 $'"/>
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
  Schema: <xsl:value-of select="@name"/>
  &#x20;<xsl:call-template name="output_express_ref">
    <xsl:with-param name="schema" select="@name"/>
    <xsl:with-param name="linkend" select="$linkend"/>
  </xsl:call-template>
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
  &#x20;<xsl:call-template name="output_express_ref">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="linkend" select="$linkend"/>
  </xsl:call-template>
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
  &#x20;<xsl:call-template name="output_express_ref">
    <xsl:with-param name="schema" select="../../@name"/>
    <xsl:with-param name="linkend" select="$linkend"/>
  </xsl:call-template>
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
  &#x20;<xsl:call-template name="output_express_ref">
  <xsl:with-param name="schema" select="../../@name"/>
    <xsl:with-param name="rule" select="'wr'"/>
    <xsl:with-param name="linkend" select="$linkend"/>
  </xsl:call-template>

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
  &#x20;<xsl:call-template name="output_express_ref">
  <xsl:with-param name="schema" select="../../@name"/>
    <xsl:with-param name="rule" select="'ur'"/>
    <xsl:with-param name="linkend" select="$linkend"/>
  </xsl:call-template>
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
  &#x20;<xsl:call-template name="output_express_ref">
  <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="linkend" select="$linkend"/>
  </xsl:call-template>
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
  &#x20;<xsl:call-template name="output_express_ref">
  <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="linkend" select="$linkend"/>
  </xsl:call-template>
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
  &#x20;<xsl:call-template name="output_express_ref">
  <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="linkend" select="$linkend"/>
  </xsl:call-template>
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
  &#x20;<xsl:call-template name="output_express_ref">
  <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="linkend" select="$linkend"/>
  </xsl:call-template>
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
  &#x20;<xsl:call-template name="output_express_ref">
  <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="linkend" select="$linkend"/>
  </xsl:call-template>
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

<xsl:template name="output_express_ref">
  <xsl:param name="schema"/>
  <xsl:param name="linkend"/>
  <xsl:param name="rule"/>
  <xsl:variable name="arm_mim">
    <xsl:choose>
      <xsl:when test="contains($schema,'_arm')">
        <xsl:value-of select="'arm'"/>
      </xsl:when>
      <xsl:when test="contains($schema,'_mim')">
        <xsl:value-of select="'mim'"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="module">
    <xsl:call-template name="module_name">
      <xsl:with-param name="module" select="$schema"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of 
      select="concat('&lt;express_ref linkend=&quot;',
              $module,':',$arm_mim,':'$linkend,'&quot;/&gt;')"/>  
</xsl:template>




</xsl:stylesheet>