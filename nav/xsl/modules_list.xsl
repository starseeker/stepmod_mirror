<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: modules_list.xsl,v 1.9 2002/10/10 11:29:24 nigelshaw Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: A set of imported templates to set up a list of modules
     The importing file will define the modules template which
     displays the list of modules
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
      <xsl:apply-templates select="modules"/>
    </body>
  </HTML>
</xsl:template>


<xsl:template match="module">
  <xsl:param name="part_no" select="'no'"/>
  <xsl:variable name="iso_href" 
    select="concat('../data/modules/',@name,'/sys/introduction',$FILE_EXT)"/>
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
        select="concat('../data/modules/',@name,'/sys/1_scope',$FILE_EXT)"/>
      <p class="menuitem">
        &#160;&#160;<a href="{$scope}" target="content">Scope</a>
        &#160;
        <a href="{$iso_href}" target="content">Introduction</a>
      </p>
      <xsl:variable name="arm" 
        select="concat('../data/modules/',@name,'/sys/4_info_reqs',$FILE_EXT)"/>      
      <xsl:variable name="armg" 
        select="concat('../data/modules/',@name,'/armexpg1',$FILE_EXT)"/>
      <p class="menuitem">
        &#160;&#160;<a href="{$arm}" target="content">ARM</a>
        &#160;&#160;&#160;
        <a href="{$armg}" target="content">EXPRESS-G</a>
      </p>

      <xsl:variable name="mapping" 
        select="concat('../data/modules/',@name,'/sys/5_mapping',$FILE_EXT)"/>
      <p class="menuitem">
        &#160;&#160;<a href="{$mapping}" target="content">Mapping</a>
      </p>

      <xsl:variable name="mim" 
        select="concat('../data/modules/',@name,'/sys/5_mim',$FILE_EXT)"/>
      <xsl:variable name="mimg" 
        select="concat('../data/modules/',@name,'/mimexpg1',$FILE_EXT)"/>
      <p class="menuitem">
        &#160;&#160;<a href="{$mim}" target="content">MIM</a>
        &#160;&#160;&#160;
        <a href="{$mimg}" target="content">EXPRESS-G</a>
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


    <!-- Summary view menu (OPEN) -->
    <xsl:variable name="summary" 
      select="concat('../data/modules/',@name,'/nav/summary',$FILE_EXT)"/>
    <div id="{$Menu}summary" style="display:none">
      <p class="menulist">
        <a href="javascript:swap({$NoMenu}summary, {$Menu}summary);">
          &#160;&#160;<img src="../images/minus.gif" alt="Close menu" 
            border="false" align="middle"/>    
        </a>
        <a href="{$summary}" target="content">Summary view</a>
      </p>
      <p class="menuitem">
        &#160;&#160;<a href="{$summary}" target="content">Summary</a>
      </p>
      <p class="menuitem">
        &#160;&#160;<a href="{$summary}#arm_dict_types" target="content">ARM dictionary
      </a>
      </p>
      <!-- would need to determin whether the ARM actually had these
           sections, which would slow everything down 
      <p class="menuitem">
        &#160;&#160;<a href="{$summary}#arm_dict_types" target="content">ARM Type dictionary
      </a>
      </p>
      <p class="menuitem">
        &#160;&#160;<a href="{$summary}#arm_dict_entities" target="content">ARM Entity dictionary
      </a>
      </p>
      <p class="menuitem">
        &#160;&#160;<a href="{$summary}#arm_dict_rules" target="content">ARM Rule dictionary
      </a>
      </p>
      <p class="menuitem">
        &#160;&#160;<a href="{$summary}#arm_dict_functions" target="content">ARM Function dictionary
      </a>
      </p>
      <p class="menuitem">
        &#160;&#160;<a href="{$summary}#arm_dict_procedures" target="content">ARM Procedure dictionary
      </a>
      </p>
      -->
    </div>
    
    <!-- Summary view menu (CLOSED) -->
    <div id="{$NoMenu}summary">
      <p class="menulist">
        <a href="javascript:swap({$Menu}summary, {$NoMenu}summary);">
          &#160;&#160;<img src="../images/plus.gif" alt="Open menu" 
            border="false" align="middle"/> 
        </a>
        <a href="{$summary}" target="content">Summary view</a>
      </p>
    </div>


    <!-- Developer view menu (OPEN) -->
    <xsl:variable name="developer" 
      select="concat('../data/modules/',@name,'/nav/developer',$FILE_EXT)"/>
    <div id="{$Menu}Developer" style="display:none">
      <p class="menulist">
        <a href="javascript:swap({$NoMenu}Developer, {$Menu}Developer);">
          &#160;&#160;<img src="../images/minus.gif" alt="Close menu" 
            border="false" align="middle"/>    
        </a>
        <a href="{$developer}" target="content">Developer View</a>
      </p>

      <p class="menuitem">
        &#160;&#160;<a href="{$developer}" target="content">XML references</a>
      </p>

      <p class="menuitem">
        <xsl:variable name="select_view" 
          select="concat('../data/modules/',@name,'/nav/select_view',$FILE_EXT)"/>
        &#160;&#160;<a href="{$select_view}" target="content">ARM SELECTs view</a>
      </p>

      <p class="menuitem">
        <xsl:variable name="arm_lf_view" 
          select="concat('../data/modules/',@name,'/nav/arm_long_form',$FILE_EXT)"/>
        &#160;&#160;<a href="{$arm_lf_view}" target="content">ARM Long form view</a>
      </p>


      <p class="menuitem">
        <xsl:variable name="arm_descriptions" 
          select="concat('../data/modules/',@name,'/nav/arm_descriptions',$FILE_EXT)"/>
        &#160;&#160;<a href="{$arm_descriptions}" target="content">ARM descriptions</a>
      </p>
      <p class="menuitem">
        <xsl:variable name="mim_descriptions" 
          select="concat('../data/modules/',@name,'/nav/mim_descriptions',$FILE_EXT)"/>
        &#160;&#160;<a href="{$mim_descriptions}" target="content">MIM descriptions</a>
      </p>

      <!-- decided not to include these yet
      <p class="menuitem">
        <xsl:variable name="intro_scope" 
          select="concat('../data/modules/',@name,'/nav/intro_scope',$FILE_EXT)"/>
        &#160;&#160;<a href="{$intro_scope}" target="content">Scope - Introduction</a>
      </p>
      <p class="menuitem">
        <xsl:variable name="arm_dvl" 
          select="concat('../data/modules/',@name,'/nav/arm',$FILE_EXT)"/>
        <xsl:variable name="arm_dvl_expg" 
          select="concat('../data/modules/',@name,'/nav/armexpg',$FILE_EXT)"/>
        &#160;&#160;<a href="{$arm_dvl}" target="content">ARM</a>
        &#160;<a href="{$arm_dvl_expg}" target="content">EXPRESS-G</a>   
      </p>
      <p class="menuitem">
        <xsl:variable name="mapping_dvl" 
          select="concat('../data/modules/',@name,'/nav/mapping',$FILE_EXT)"/>
        &#160;&#160;<a href="{$mapping_dvl}" target="content">Mapping</a>
      </p>
      <p class="menuitem">
        <xsl:variable name="mim_dvl" 
          select="concat('../data/modules/',@name,'/nav/mim',$FILE_EXT)"/>
        <xsl:variable name="mim_dvl_expg" 
          select="concat('../data/modules/',@name,'/nav/mimexpg',$FILE_EXT)"/>
        &#160;&#160;<a href="{$mim_dvl}" target="content">MIM</a>
        &#160;<a href="{$mim_dvl_expg}" target="content">EXPRESS-G</a>   
      </p>
        -->
    </div>

    <!-- Developer view menu (CLOSED) -->
    <div id="{$NoMenu}Developer">
      <p class="menulist">
        <a href="javascript:swap({$Menu}Developer, {$NoMenu}Developer);">
          &#160;&#160;<img src="../images/plus.gif" alt="Open menu" 
            border="false" align="middle"/> 
        </a>
        <a href="{$summary}" target="content">Developer View</a>
      </p>
    </div>
  </div>
  
  <!-- Main module menu (CLOSED) -->
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


</xsl:stylesheet>
