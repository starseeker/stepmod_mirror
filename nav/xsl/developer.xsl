<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: modules_list.xsl,v 1.4 2002/09/12 09:12:20 robbod Exp $
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

  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>

  <xsl:template match="/" >
    <xsl:apply-templates select="./stylesheet_application"/>
  </xsl:template>

  <xsl:template match="stylesheet_application">
    <HTML>
    <head>
      <link rel="stylesheet" type="text/css" 
        href="../../../../nav/css/developer.css"/>
      <title>
        <xsl:value-of select="concat('Development tips for ',@directory)"/>
      </title>

      <script language="JavaScript"><![CDATA[

          function swap(ShowDiv, HideDiv) {
            show(ShowDiv);
            hide(HideDiv);
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
    <h3>References to module sections</h3>
    The following XML constructs can be used to reference sections of the
    module.
    <xsl:variable 
      name="module_xml_file"
      select="concat('../../data/modules/',@directory,'/module.xml')"/>

    <xsl:apply-templates 
      select="document($module_xml_file)/module" mode="linkend">
      <xsl:with-param name="section" select="'Introduction'"/>
      <xsl:with-param name="link_section" select="'introduction'"/>
      <xsl:with-param name="href" 
        select="concat('../../../modules/',@name,'/sys/introduction',$FILE_EXT)"/>
    </xsl:apply-templates>

    <h3>References to ARM EXPRESS types</h3>
    The following XML constructs can be used to reference ARM types.
    <xsl:variable 
      name="arm_xml_file"
      select="concat('../../data/modules/',@directory,'/arm.xml')"/>
    <xsl:apply-templates 
      select="document($arm_xml_file)/express/schema/type"/>

    <h3>References to ARM EXPRESS entities</h3>
    The following XML constructs can be used to reference ARM entities.
    <xsl:apply-templates 
      select="document($arm_xml_file)/express/schema/entity"/>

    <xsl:variable
      name="mim_xml_file"
      select="concat('../../data/modules/',@directory,'/mim.xml')"/>
    <h3>References to MIM EXPRESS types</h3>
    The following XML constructs can be used to reference MIM types.
    <xsl:apply-templates 
      select="document($mim_xml_file)/express/schema/type"/>

    <h3>References to MIM EXPRESS entities</h3>
    The following XML constructs can be used to reference MIM entities.
    <xsl:apply-templates 
      select="document($mim_xml_file)/express/schema/entity"/>
  </body>
</HTML>
</xsl:template>

<xsl:template match="module">
  <h2>Useful information for developer</h2>
</xsl:template>


<xsl:template match="entity|type">
  <xsl:variable name="linkend" select="concat(../@name, '.', @name)"/>
  <xsl:variable name="href" 
    select="translate(concat('../sys/4_info_reqs',$FILE_EXT,'#',$linkend),$UPPER,$LOWER)"/>
  <p class="hrefname">
    Entity: <a href="{$href}">
      <xsl:value-of select="@name"/>
    </a>
  </p>
  <p class="hrefhref">
    <xsl:call-template name="output_express_ref">
      <xsl:with-param name="schema" select="../@name"/>
      <xsl:with-param name="linkend" select="$linkend"/>
    </xsl:call-template>
  </p>
  <xsl:apply-templates select="explicit"/>
  <xsl:apply-templates select="derived"/>
  <xsl:apply-templates select="inverse"/>
</xsl:template>

<xsl:template match="explicit|derived|inverse">
  <xsl:variable name="linkend" 
    select="concat(../../@name,'.',../@name,'.',@name)"/>
  <xsl:variable name="href" 
    select="translate(concat('../sys/4_info_reqs',$FILE_EXT,'#',$linkend),$UPPER,$LOWER)"/>
  <p class="attrname">
        Attribute:
        <a href="{$href}">
      <xsl:value-of select="@name"/>
    </a>
  </p>
  <p class="attrhref">
    <xsl:call-template name="output_express_ref">
      <xsl:with-param name="schema" select="../../@name"/>
      <xsl:with-param name="linkend" select="$linkend"/>
    </xsl:call-template>
  </p>
</xsl:template>


<xsl:template name="output_express_ref">
  <xsl:param name="schema"/>
  <xsl:param name="linkend"/>
  <xsl:param name="rule"/>
  <xsl:variable name="arm_mim">
    <xsl:choose>
      <xsl:when test="contains($schema,'_arm')">
        <xsl:value-of select="'arm'"/>
      </xsl:when>
      <xsl:when test="contains($schema,'_mim')">
        <xsl:value-of select="'mim'"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="module">
    <xsl:call-template name="module_name">
      <xsl:with-param name="module" select="$schema"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of 
      select="concat('&lt;express_ref linkend=&quot;',
              $module,':',$arm_mim,':'$linkend,'&quot;/&gt;')"/>  
</xsl:template>


<xsl:template match="module" mode="linkend">
  <xsl:param name="section"/>
  <xsl:param name="link_section"/>
  <xsl:param name="href"/>
  <p class="hrefname">
    <xsl:value-of select="$section"/>
  </p>
  <xsl:variable name="linkend" 
    select="concat('&lt;module_ref linkend=&quot;',
            @name,':',$link_section,'&quot;/&gt;')"/>
  <p class="hrefhref">
    <a href="{$href}">
      <xsl:value-of select="$linkend"/>
    </a>
  </p>
</xsl:template>

</xsl:stylesheet>
