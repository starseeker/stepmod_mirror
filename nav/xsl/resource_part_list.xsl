<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: resource_part_list.xsl,v 1.1 2002/10/22 13:18:57 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: A set of imported templates to set up a list of resource parts
     The importing file will define the resource template which
     displays the list of resource parts
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="../../xsl/res_doc/common.xsl"/>


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
      <xsl:apply-templates select="resource_docs"/>
    </body>
  </HTML>
</xsl:template>


<xsl:template match="resource_doc">
  <xsl:param name="part_no" select="'no'"/>
  <xsl:variable name="iso_href" 
    select="concat('../data/resource_docs/',@name,'/sys/introduction',$FILE_EXT)"/>
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
  
  <!-- Main module menu (OPEN) -->
  <div id="{$Menu}" style="display:none">
    <p class="menulist">
      <a href="javascript:swap({$NoMenu}, {$Menu});">
        <img src="../images/minus.gif" alt="Close menu" 
          border="false" align="middle"/>    
      </a>
      <a href="{$iso_href}" target="content">
        <xsl:value-of select="$part_name"/>
      </a>
    </p>

    <!-- ISO view menu (OPEN) -->
    <div id="{$Menu}ISO" style="display:none">
      <p class="menulist">
        <a href="javascript:swap({$NoMenu}ISO, {$Menu}ISO);">
          &#160;&#160;<img src="../images/minus.gif" alt="Close menu" 
            border="false" align="middle"/>    
        </a>
        <a href="{$iso_href}" target="content">ISO view</a>
      </p>
      <xsl:variable name="scope" 
        select="concat('../data/resource_docs/',@name,'/sys/1_scope',$FILE_EXT)"/>
      <xsl:variable name="express_g" 
        select="concat('../data/resource_docs/',@name,'/sys/d_expg',$FILE_EXT)"/>
      <p class="menuitem">
        &#160;&#160;<a href="{$scope}" target="content">Scope</a>
        &#160;
        <a href="{$iso_href}" target="content">Introduction</a>
        &#160;
        <xsl:call-template name="schema_section_list" />
        <a href="{$express_g}" target="content">EXPRESS-G</a>
      </p>
    </div>

    <!-- ISO view menu (CLOSED) -->
    <div id="{$NoMenu}ISO">
      <p class="menulist">
        <a href="javascript:swap({$Menu}ISO, {$NoMenu}ISO);">
          &#160;&#160;<img src="../images/plus.gif" alt="Open menu" 
            border="false" align="middle"/> 
        </a>
        <a href="{$iso_href}" target="content">ISO view</a>
      </p>
    </div>

  </div>
  
  <!-- Main view menu (CLOSED) -->
  <div id="{$NoMenu}">
    <p class="menulist">
      <a href="javascript:swap({$Menu}, {$NoMenu});">
        <img src="../images/plus.gif" alt="Open menu" 
          border="false" align="middle"/> 
      </a>
      <a href="{$iso_href}" target="content">
        <xsl:value-of select="$part_name"/>
      </a>
    </p>
  </div>
</xsl:template>

<xsl:template name="schema_section_list">
  <!-- depth of xsl/res_doc is the same as nav\xsl -->

  <xsl:variable name="resdoc_dir">
    <xsl:call-template name="resdoc_directory">
      <xsl:with-param name="resdoc" select="./@name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="resource_xml" 
    select="concat($resdoc_dir,'/resource.xml')"/>
  <xsl:message >
    resdoc_dir: <xsl:value-of select="$resdoc_dir"/> : resource_dir
  </xsl:message>

      <xsl:apply-templates 
        select="document($resource_xml)/resource/schema"
        mode="schema_sect">
        <xsl:with-param name="resource_xml" select="$resource_xml"/>
      </xsl:apply-templates>
</xsl:template>

<xsl:template match="schema" mode="schema_sect">
  <xsl:param name="resource_xml"/>

  <xsl:variable name="schema_sect_url"
    select="concat('../data/resource_docs/',../@name,'/sys/',(number(position())+3),'_schema',$FILE_EXT)" />

    <xsl:variable name="schema_name">
     <xsl:call-template name="resource_name">
      <xsl:with-param name="resource" select="./@name" />
    </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="sch_dis_name">
     <xsl:call-template name="res_display_name">
      <xsl:with-param name="res" select="$schema_name" />
    </xsl:call-template>
    </xsl:variable>

 <a href="{$schema_sect_url}" target="content">
          <xsl:value-of select="$sch_dis_name" />
          </a><br/>
 
</xsl:template>
</xsl:stylesheet>