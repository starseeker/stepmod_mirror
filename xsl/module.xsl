<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: module.xsl,v 1.1 2001/10/05 07:52:22 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="common.xsl"/>

  <xsl:output method="html"/>



<xsl:template match="/">
  <HTML>
    <HEAD>
      <TITLE>
        <!-- output the module page title -->
        <xsl:apply-templates select="./module" mode="title"/>
      </TITLE>
    </HEAD>
    <BODY>
      <xsl:apply-templates select="./module" mode="TOCsinglePage"/>
      <xsl:apply-templates select="./module" />
    </BODY>
  </HTML>
</xsl:template>

<xsl:template match="module">
  <xsl:apply-templates select="." mode="coverpage"/>
  <xsl:apply-templates select="." mode="forword"/>
  <xsl:apply-templates/>
</xsl:template>

<!-- Outputs the cover page -->
<xsl:template match="module" mode="coverpage">
  COVER PAGE
</xsl:template>


<!-- Outputs the foreword -->
<xsl:template match="module" mode="forword">
  <xsl:call-template name="clause_header">
    <xsl:with-param name="heading" select="'Foreword'"/>
    <xsl:with-param name="aname" select="'foreword'"/>
  </xsl:call-template>
  <p>
    <xsl:value-of select="@name"/>
    was prepared by Technical Committee ISO/TC 184, Industrial automation
    systems and integration, Subcommittee SC4, Industrial data.  
  </p>
  <p>
    This International Standard is organized as a series of parts, each
    published separately. The structure of this International Standard is
    described in ISO 10303-1. Each part of this International Standard is a
    member of one of the following series: description methods, implementation
    methods, conformance testing methodology and framework, integrated generic
    resources, integrated application resources, application protocols,
    abstract test suites, application interpreted constructs, and application
    modules. This part is a member of the application modules series. A
    complete list of parts of ISO 10303 is available from the Internet: 
  </p>
  <blockquote>
    <A HREF="http://www.nist.gov/sc4/editing/step/titles/">
      &lt;http://www.nist.gov/sc4/editing/step/titles/&gt;
    </A>.
  </blockquote>
  <p>
    Annexes A and B form an integral part of this part of ISO 10303. Annexes C,
    D, E, and F are for information only.  
  </p> 
</xsl:template>



<xsl:template match="inscope">
  <xsl:call-template name="clause_header">
    <xsl:with-param name="heading" select="'1 Scope'"/>
    <xsl:with-param name="aname" select="'scope'"/>
  </xsl:call-template>
  <p>
    This part of ISO 10303 specifies the application module for 
    <xsl:value-of select="../@name"/>.
    The following are within scope of this part of ISO 10303: 
  </p>
  <ul>
    <xsl:apply-templates/>
  </ul>
</xsl:template>


<xsl:template match="outscope">
  <p>
    The following are outside the scope of this part of ISO 10303: 
  </p>
  <ul>
    <xsl:apply-templates/>
  </ul>
</xsl:template>


</xsl:stylesheet>
