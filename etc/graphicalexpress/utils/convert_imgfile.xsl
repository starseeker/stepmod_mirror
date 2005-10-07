<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
     $Id: convert_imgfile.xsl,v 1.2 2005/01/08 01:02:55 thendrix Exp $

  Author: Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep and supplied to NIST under contract.
  Purpose: 
     Extract a schema from a file
-->

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:stepmod="http://eurostep.com/stepmod"
  version="1.0">

<xsl:output 
  method="xml"
  indent="yes"
  doctype-system="../../../dtd/text.ent"
  omit-xml-declaration="yes"
  />
  
  <!-- input from ge2moduleMain -->
  <xsl:param name="file" select="'qqq'"/>
  <xsl:param name="module" select="'qqq'"/>
  <xsl:param name="source" select="'qqq'"/>
  <xsl:param name="armormim" select="'qqq'"/>
  <xsl:variable name="xslhref">
    <xsl:choose >
<!--      <xsl:when test="contains($source, $module)"> -->
     <xsl:when test="$armormim='arm' or  $armormim='mim'">
         <xsl:value-of select="'../../../xsl/imgfile.xsl'" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'../../../xsl/res_doc/imgfile.xsl'" />
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:template match="/">
	  <xsl:processing-instruction name="xml-stylesheet">
	    type="text/xsl" 
	    <xsl:value-of select="concat('href=&quot;',$xslhref,'&quot;')"/>
	  </xsl:processing-instruction>
      <xsl:text>

      </xsl:text>
      <xsl:apply-templates/>
<!-- debug	<xsl:comment>armormim:<xsl:value-of select="$armormim"/>:armormim</xsl:comment> -->
    </xsl:template>

    <xsl:template match="imgfile.content">

      <!--
      <xsl:variable name="module">
	<xsl:call-template name="module_name">
	  <xsl:with-param name="module" select="@schema"/>
	</xsl:call-template>
      </xsl:variable>
  -->
      <xsl:element name="imgfile.content">

    <xsl:message>
      armormim:<xsl:value-of select="$armormim"/>:armormim
    </xsl:message>

      <xsl:choose>
  <!--       <xsl:when test="contains($source,$module)"> -->
  <xsl:when test="$armormim='arm' or $armormim='mim'">
    <xsl:attribute name="module">
      <xsl:value-of select="$module"/>
    </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
      <xsl:attribute name="module">
        <xsl:value-of select="substring-before($source,'_v0')"/>
      </xsl:attribute>
    </xsl:otherwise>
    </xsl:choose>

      <xsl:attribute name="file">
        <xsl:value-of select="$file"/>
      </xsl:attribute>

      <xsl:apply-templates/>

    </xsl:element>

  </xsl:template>

  <xsl:template match="img">
    <xsl:element name="img">
      <xsl:attribute name="src">
        <xsl:value-of select="@src"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>    
  </xsl:template>

  <xsl:template match="img.area">
    <xsl:element name="img.area">
      <xsl:attribute name="shape">
        <xsl:value-of select="@shape"/>
      </xsl:attribute>
      <xsl:attribute name="coords">
        <xsl:value-of select="@coords"/>
      </xsl:attribute>
      <xsl:attribute name="href">
        <xsl:value-of select="@href"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>


  <xsl:template name="module_name">
    <xsl:param name="module"/>
    <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
    <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
    <xsl:variable name="module_lcase"
      select="translate(
              normalize-space(translate($module,$UPPER, $LOWER)),
              '&#x20;','_')"/>
    <xsl:variable name="mod_name">
      <xsl:choose>
        <xsl:when test="contains($module_lcase,'_arm')">
          <xsl:value-of select="substring-before($module_lcase,'_arm')"/>
        </xsl:when>
        <xsl:when test="contains($module_lcase,'_mim')">
          <xsl:value-of select="substring-before($module_lcase,'_mim')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="string($module_lcase)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$mod_name"/>
  </xsl:template>

  <xsl:template name="get_file_name">
    <xsl:param name="path"/>
    <xsl:variable name="file_name">
      <xsl:choose>
        <xsl:when test="contains($path,'\')">
          <xsl:variable name="path1" select="substring-after($path,'\')"/>
          <xsl:call-template name="get_file_name">
            <xsl:with-param name="path" select="$path1"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$path"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$file_name"/> 
  </xsl:template>



</xsl:stylesheet>