<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: ap_list.xsl,v 1.1 2002/09/13 12:08:39 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: A set of imported templates to set up a list of application_protocols
     The importing file will define the application_protocols template which
     displays the list of application_protocols
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
        <xsl:value-of select="Application_Protocols" />
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
      <xsl:apply-templates select="application_protocols"/>
    </body>
  </HTML>
</xsl:template>


<xsl:template match="application_protocol">
  <xsl:param name="part_no" select="'no'"/>
  <xsl:variable name="href" 
    select="concat('../data/application_protocols/',@name,'/home',$FILE_EXT)"/>
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

  <p class="menulist">
    <a href="{$href}" target="_blank">
      <xsl:value-of select="$part_name"/>
    </a>
  </p>

  <!--       
  <div id="{$Menu}" style="display:none">
    <p class="menulist">
      <a href="javascript:swap({$NoMenu}, {$Menu});">
        <img src="../images/minus.gif" alt="Close menu" 
          border="false" align="middle"/>    
      </a>
      <a href="{$href}" target="_blank">
        <xsl:value-of select="$part_name"/>
      </a>
    </p>
    
    <p class="menuitem">
      <a href="{$href}" target="_blank">
        ISO view
      </a>
    </p>
    
    <xsl:variable name="arm" 
      select="concat('../data/application_protocols/',@name,'/sys/4_info_reqs',$FILE_EXT)"/>

    <xsl:variable name="armg" 
      select="concat('../data/application_protocols/',@name,'/armexpg1',$FILE_EXT)"/>
    <p class="menuitem">
      <a href="{$arm}" target="content">ARM</a>
      &#160;
      <a href="{$armg}" target="content">EXPRESS-G</a>
    </p>
    
    <xsl:variable name="mim" 
      select="concat('../data/application_protocols/',@name,'/sys/5_main',$FILE_EXT)"/>
    <xsl:variable name="mimg" 
      select="concat('../data/application_protocols/',@name,'/mimexpg1',$FILE_EXT)"/>
    <p class="menuitem">
      <a href="{$mim}" target="content">MIM</a>
      &#160;
      <a href="{$mimg}" target="content">EXPRESS-G</a>
    </p>
    
    <p class="menuitem">Developer view</p>
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
  -->
</xsl:template>


</xsl:stylesheet>