<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: resource_part_list.xsl,v 1.7 2004/10/15 00:23:48 thendrix Exp $
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
        <xsl:value-of select="'Resource parts'" />
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
  
 
  <!-- Main resource part  menu (OPEN) -->
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

    <xsl:apply-templates select="." mode="iso_sub_menus">
      <xsl:with-param name="resdoc_root" select="concat('../data/resource_docs/',@name)"/>
      <xsl:with-param name="image_root" select="'../images'"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="." mode="schema_sub_menus">
      <xsl:with-param name="resdoc_root" select="concat('../data/resource_docs/',@name)"/>
      <xsl:with-param name="image_root" select="'../images'"/>
    </xsl:apply-templates>
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

<xsl:template match="resource_doc" mode="iso_sub_menus">
  <xsl:param name="part_no" select="'no'"/>
  <xsl:param name="resdoc_root" select="''"/>
  <xsl:param name="image_root" select="''"/>
  <xsl:variable name="iso_href" 
    select="concat($resdoc_root,'/sys/introduction',$FILE_EXT)"/>
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
  

   <!-- ISO view menu (OPEN) -->
    <div id="{$Menu}ISO" style="display:none">
      <p class="menulist1">
        <a href="javascript:swap({$NoMenu}ISO, {$Menu}ISO);">
          <img src="../images/minus.gif" alt="Close menu" 
            border="false" align="middle"/>    
        </a>
        <a href="{$iso_href}" target="content">ISO view</a>
      </p>
        <xsl:variable name="cover" 
          select="concat('../data/resource_docs/',@name,'/sys/isocover',$FILE_EXT)"/>
    <p class="menuitem2">
      <a href="{$cover}" target="content">Cover</a>
    </p>
      <xsl:variable name="scope" 
        select="concat('../data/resource_docs/',@name,'/sys/1_scope',$FILE_EXT)"/>
      <p class="menuitem2">
        <a href="{$scope}" target="content">Scope</a>
        &#160;
        <a href="{$iso_href}" target="content">Introduction</a>
        &#160;
      </p>
    </div>

    <!-- ISO view menu (CLOSED)  -->
    <div id="{$NoMenu}ISO">
      <p class="menulist1">
        <a href="javascript:swap({$Menu}ISO, {$NoMenu}ISO);" >
 <img src="../images/plus.gif" alt="Open menu"
            border="false" align="middle"/> 
        </a>
        <a href="{$iso_href}" target="content">ISO view</a>
      </p>
    </div>
  </xsl:template>


<xsl:template match="resource_doc" mode="schema_sub_menus">
  <xsl:param name="part_no" select="'no'"/>
  <xsl:param name="resdoc_root" select="''"/>
  <xsl:param name="image_root" select="''"/>
  <xsl:variable name="iso_href" 
    select="concat($resdoc_root,'/sys/introduction',$FILE_EXT)"/>
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

   
    <!-- Schema view menu (OPEN) -->
    <xsl:variable name="schemas" 
      select="concat('../data/resource_docs/',@name,'/sys/4_schema',$FILE_EXT)"/>
    <div id="{$Menu}Schemas" style="display:none">
      <p class="menulist1">
        <a href="javascript:swap({$NoMenu}Schemas, {$Menu}Schemas);">
          <img src="../images/minus.gif" alt="Close menu" 
            border="false" align="middle"/>    
        </a>
        <a href="{$schemas}" target="content">Schemas</a>
      </p>
  <xsl:variable name="res_dir" select="concat('../../data/resource_docs/',@name,'/resource.xml')" />
  <xsl:variable name="this_resource" select="document($res_dir)/resource" />      

      <xsl:for-each select="$this_resource/schema" >
	      <p class="menuitem">
        	<xsl:variable name="schema_dir" 
	          select="concat('../data/resource_docs/',$this_resource/@name,'/sys/',position()+3,'_schema',$FILE_EXT)"/>
        	&#160;&#160;&#160;&#160;<a href="{$schema_dir}" target="content"><xsl:value-of select="@name"/></a>
		<br/>
        	<xsl:variable name="first_expg" 
                  select="substring-before(./express-g/imgfile/@file,'.xml')"/>
        	<xsl:variable name="schema_expg" 
	          select="concat('../data/resources/',@name,'/',$first_expg,$FILE_EXT)"/>
		&#160;&#160;&#160;&#160;&#160;&#160;<a href="{$schema_expg}" target="content">EXPRESS-G</a>
		<br/>
        	<xsl:variable name="schema_dev" 
	          select="concat('../data/resources/',@name,'/developer',$FILE_EXT)"/>
		&#160;&#160;&#160;&#160;&#160;&#160;<a href="{$schema_dev}" target="content">Developer view</a>
		<br/>
        	<xsl:variable name="schema_map" 
	          select="concat('../data/resources/',@name,'/resource_map',$FILE_EXT)"/>
		&#160;&#160;&#160;&#160;&#160;&#160;<a href="{$schema_map}" target="content">Mappings</a>
	      </p>
     	
      
      </xsl:for-each>
   
    </div>

    <!-- Schemas view menu (CLOSED) -->
    <div id="{$NoMenu}Schemas">
      <p class="menulist1">
        <a href="javascript:swap({$Menu}Schemas, {$NoMenu}Schemas);">
          <img src="../images/plus.gif" alt="Open menu" 
            border="false" align="middle"/> 
        </a>
        <a href="{$schemas}" target="content">Schemas</a>
      </p>
  </div>
  
</xsl:template>
 
</xsl:stylesheet>

