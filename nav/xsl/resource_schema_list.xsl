<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: resource_schema_list.xsl,v 1.2 2002/09/16 09:25:31 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: A set of imported templates to set up a list of resource schemas
     The importing file will define the resource template which
     displays the list of resource schemas
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="../../xsl/common.xsl"/>


  <xsl:output method="html"/>


  <xsl:template match="/" >
    <xsl:apply-templates select="./stylesheet_application"/>
  </xsl:template>

  <xsl:template match="stylesheet_application">
    <xsl:apply-templates select="document(@file)/repository_index"/>
  </xsl:template>

<xsl:template match="repository_index">
  <HTML>
    <head>
      <link rel="stylesheet" type="text/css" href="./css/nav.css"/>
      <title>
        <xsl:value-of select="Modules" />
      </title>

      <script language="JavaScript"><![CDATA[

          function swap(ShowDiv, HideDiv) {
            show(ShowDiv) ;
            hide(HideDiv) ;
          }

          function show(DivID) {
            DivID.style.display="block";
          }

          function hide(DivID) {
            DivID.style.display="none";
          }
      ]]></script>
    </head>
    <body>
      <xsl:apply-templates select="resources"/>
    </body>
  </HTML>
</xsl:template>


<xsl:template match="resource">
  <xsl:param name="part_no" select="'no'"/>
  <xsl:variable name="href" 
    select="concat('../data/resources/',@name,'/',@name,$FILE_EXT)"/>
  <xsl:variable name="Menu" select="concat('Menu',@name)"/>
  <xsl:variable name="NoMenu" select="concat('NoMenu',@name)"/>

  <xsl:variable name="part_name">
    <xsl:choose>
      <xsl:when test="$part_no='yes'">
        <xsl:value-of select="concat(@part,':',@name)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@name"/>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:variable>
  
  <div id="{$Menu}" style="display:none">
    <p class="menulist">
      <a href="javascript:swap({$NoMenu}, {$Menu});">
        <img src="../images/minus.gif" alt="Close menu" 
          border="false" align="middle"/>    
      </a>
      <a href="{$href}" target="content">
        <xsl:value-of select="$part_name"/>
      </a>
    </p>
    <p class="menuitem">
      <a href="{$href}" target="content">
        Schema
      </a>
    </p>
  <xsl:variable name="dvlpref" 
    select="concat('../data/resources/',@name,'/developer',$FILE_EXT)"/>
  <xsl:variable name="mappingref" 
    select="concat('../data/resources/',@name,'/resource_map',$FILE_EXT)"/>

    <p class="menuitem">
      <a href="{$dvlpref}" target="content">
        Developer view
      </a>
    </p>
  
    <p class="menuitem">
      <a href="{$mappingref}" target="content">
        Mapping view
      </a>
    </p>

  
  </div>
  
  <div id="{$NoMenu}">
    <p class="menulist">
      <a href="javascript:swap({$Menu}, {$NoMenu});">
        <img src="../images/plus.gif" alt="Open menu" 
          border="false" align="middle"/> 
      </a>
      <a href="{$href}" target="content">
        <xsl:value-of select="$part_name"/>
      </a>
    </p>
  </div>
</xsl:template>


</xsl:stylesheet>

