<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: module.xsl,v 1.159 2003/08/15 07:14:24 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to UK MOD under contract.
  Purpose: To apply the XSL that generates the XSD from the arm_lf
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		xmlns:exslt="http://exslt.org/common"
                exclude-result-prefixes="msxsl exslt"
                version="1.0">


  <xsl:import href="modXML2schema.xsl"/>
  <xsl:import href="../common.xsl"/>

  <xsl:output method="html"/>

  <xsl:template match="/" >
    <xsl:apply-templates select="./module_clause" />
  </xsl:template>


  <xsl:template match="module_clause">
    <xsl:variable 
      name="module_xml"
      select="document(concat('../../data/modules/',@directory,'/module.xml'))"/>
    <HTML>
      <HEAD>
        <link
          rel="stylesheet"
          type="text/css"
          href="../../../../css/stepmod.css"/>
        <xsl:apply-templates select="$module_xml/module" mode="meta_data"/>

        <TITLE>
          <!-- output the module page title -->
          <xsl:apply-templates 
            select="$module_xml/module"
            mode="title"/>
        </TITLE> 
      </HEAD>
      <BODY>
        <h3>
          ISO 10303 P28 XML Schema for:
          <a href="./sys/introduction{$FILE_EXT}"><xsl:value-of select="@directory"/></a>
        </h3>
        <p>
          <b>WARNING THIS IS UNDER DEVELOPMENT</b>
        </p>
        <xsl:choose>
          <xsl:when test="$module_xml/module/arm_lf">
            <xsl:variable name="arm_lf" select="document(concat('../../data/modules/',@directory,'/arm_lf.xml'))"/>
            <xsl:variable name="p28_xml">
              <xsl:apply-templates select="$arm_lf/express"/>
            </xsl:variable>            
            <xsl:choose>
              <xsl:when test="function-available('msxsl:node-set')">
                <xsl:variable name="p28_node_set" select="msxsl:node-set($p28_xml)"/>
                <xsl:apply-templates select="$p28_node_set"/>
              </xsl:when>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="error_message">
              <xsl:with-param 
                name="message" 
                select="concat('Error IMPL1: The module ',../@directory,' must have a long form')"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </BODY>
    </HTML>
  </xsl:template>




</xsl:stylesheet>

