<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: impl.xsl,v 1.6 2004/02/11 17:22:32 mikeward Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to UK MOD under contract.
  Purpose:
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">


  <xsl:import href="../common.xsl"/>

  <xsl:template match="implementation_methods">
    <xsl:variable 
      name="module_xml"
      select="document(concat('../../data/modules/',@module,'/module.xml'))"/>  
    <HTML>
      <HEAD>
        <link
          rel="stylesheet"
          type="text/css"
          href="../../../css/stepmod.css"/>
        <xsl:apply-templates select="$module_xml/module" mode="meta_data"/>

        <TITLE>
          <!-- output the module page title -->
          <xsl:apply-templates 
            select="$module_xml/module"
            mode="title"/>
        </TITLE>
      </HEAD>
      <BODY>
        <h2>
          Implementation methods for module: 
          <a href="./sys/introduction{$FILE_EXT}"><xsl:value-of select="@module"/></a>
        </h2>
        <p>
          <b>WARNING:</b>
        </p>
        <p>
          <b>
            This xml schema is based on the 2004 CD draft of ISO 10303-28 Edition 2. It
            is subject to further change and is awaiting resolution of technical
            issues. Do not use.
          </b>
        </p>
        
        <xsl:choose>
          <xsl:when test="child::*">
            <p>
              The following implementation methods are available for this module:
            </p>
            <xsl:apply-templates/>
          </xsl:when>
          <xsl:otherwise>
            Part 21 is the only implementation method available for this module.
          </xsl:otherwise>
        </xsl:choose>
      </BODY>
    </HTML>
  </xsl:template>

  <xsl:template match="p28xsd">
    <xsl:variable 
      name="module_xml"
      select="document(concat('../../data/modules/',../@module,'/module.xml'))"/>  
    <xsl:choose>
      <xsl:when test="$module_xml/module/arm_lf">
        <h3>ISO 103030 Part 28 XML Schema binding for ARM long form</h3>
        <ul>
          <li>
            <a href="sys/p28xsd{$FILE_EXT}">Generate arm_lf_p28xsd.xsd</a>
          </li>
          <li>
            <a href="arm_lf_p28xsd.xsd">arm_lf_p28xsd.xsd</a>
          </li>
           <li>
            <a href="../../../dtd/part28/ex.xsd">Part 28 base schema ex.xsd</a>
          </li>

        </ul>
      </xsl:when>
      <xsl:otherwise>
      <xsl:call-template name="error_message">
        <xsl:with-param 
          name="message" 
          select="concat('Error IMPL1: The module ',../@module,' must have a long form')"/>
      </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
