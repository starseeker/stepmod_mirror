<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: common.xsl,v 1.23 2002/02/14 16:47:52 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: Set up the contents frame along the top
     The contents are defined in the index.xml file
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="../../xsl/repository_index.xsl"/>


  <xsl:output method="html"/>


  <xsl:template match="/" >
    <xsl:apply-templates select="./stylesheet_application"/>
  </xsl:template>

  <xsl:template match="stylesheet_application">
    <xsl:apply-templates select="document(@file)/repository_index"/>
  </xsl:template>

<xsl:template match="repository_index" >
  <HTML>
    <HEAD>
      <!-- apply a cascading stylesheet.
           the stylesheet will only be applied if the parameter output_css
           is set in parameter.xsl 
           -->
      <link rel="stylesheet" type="text/css" href="../css/stepmod.css"/>
      <TITLE>Module repository</TITLE>
    </HEAD>
    <BODY>
      <table width="600">
        <tr>
          <td>
            <h2>
              <a name="alphatop">
                Alphabetical list of Modules
              </a>
            </h2>
          </td>
          <td>
            <h2>
              <a href="help/index.htm">
                Help
              </a>
            </h2>
          </td>
        </tr>
      </table>
      <xsl:variable name="module_count"
        select="(count(./modules/module)+1) div 2"/>
      <blockquote>
        <table width="90%" cellspacing="0" cellpadding="4">
          <tr>
            <td>
              <xsl:apply-templates 
                select="./modules/module[not(position() > $module_count)]">
                <xsl:sort select="@name"/>
              </xsl:apply-templates>
            </td>
            <td>
              <xsl:apply-templates 
                select="./modules/module[position() > $module_count]">
                <xsl:sort select="@name"/>
              </xsl:apply-templates>              
            </td>
          </tr>
        </table>
      </blockquote>
      <h2>
        <a name="alphatop">
          Alphabetical list of Integrated Resource schemas
        </a>
      </h2>
      <xsl:variable name="resource_count"
        select="(count(./resources/resource)+1) div 2"/>

      <blockquote>
        <table width="90%" cellspacing="0" cellpadding="4">
          <tr>
            <td>
              <xsl:apply-templates select="./resources/resource[not(position() > $resource_count)]">
                <xsl:sort select="@name"/>
              </xsl:apply-templates>
            </td>
            <td>
              <xsl:apply-templates select="./resources/resource[position() > $resource_count]">
                <xsl:sort select="@name"/>
              </xsl:apply-templates>
            </td>
          </tr>
        </table>
      </blockquote>
    </BODY>
  </HTML>
</xsl:template>

<xsl:template match="module">
  <xsl:variable name="xref"
    select="concat('../data/modules/',@name,'/sys/introduction',$FILE_EXT)"/>
  <a href="{$xref}">
    <font size="-1">
      <b><xsl:value-of select="@name"/> (<xsl:value-of select="@part"/>)</b>
    </font>
  </a>

  <xsl:variable name="xref4"
    select="concat('../data/modules/',@name,'/sys/4_info_reqs',$FILE_EXT,'#arm')"/>

  <xsl:variable name="arm_expg"
    select="concat('../data/modules/',@name,'/armexpg1',$FILE_EXT,'#arm')"/>
  
  <xsl:variable name="xref5"
    select="concat('../data/modules/',@name,'/sys/5_mim',$FILE_EXT,'#mim')"/>

  <xsl:variable name="mim_expg"
    select="concat('../data/modules/',@name,'/mimexpg1',$FILE_EXT,'#arm')"/>
  
  <table cellspacing="0" cellpadding="1">
    <tr>
      <td>&#160;&#160;&#160;&#160;</td>
      <td>
        <font size="-2">
          <a href="{$xref4}">ARM</a>
        </font>
      </td>
      <td>
        <font size="-2">
          <a href="{$arm_expg}">ARM-G</a>
        </font>
      </td>
      <td>
        <font size="-2">
          <a href="{$xref5}">MIM</a>
        </font>
      </td>
      <td>
        <font size="-2">
          <a href="{$mim_expg}">MIM-G</a>
        </font>
      </td>
      </tr>
    </table>
</xsl:template>

<xsl:template match="resource">
  <xsl:variable name="xref" select="concat('../data/resources/',@name,'/',@name,$FILE_EXT)"/>
  <a href="{$xref}">
    <font size="-1">
      <b><xsl:value-of select="@name"/></b>
    </font>
  </a>
  <br/>
</xsl:template>


</xsl:stylesheet>