<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
     $Id: repository_index.xsl,v 1.8 2002/03/04 07:50:08 robbod Exp $

  Author: Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep and supplied to NIST under contract.
  Purpose: 
     Used to display the index of modules and integrated resources in the
     module repository.  Normally called from: stepmod/repository_index.xml
-->


<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>

  <xsl:import href="common.xsl"/>


  <xsl:output method="html"/>


<xsl:template match="repository_index" >
  <HTML>
    <HEAD>
      <!-- apply a cascading stylesheet.
           the stylesheet will only be applied if the parameter output_css
           is set in parameter.xsl 
           -->
      <xsl:call-template name="output_css">
        <xsl:with-param name="override_css" select="'stepmod.css'"/>
        <xsl:with-param name="path" select="'./css/'"/>
      </xsl:call-template>
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
    select="concat('./data/modules/',@name,'/sys/introduction',$FILE_EXT)"/>
  <xsl:variable name="part">
    <xsl:call-template name="get_module_part">
      <xsl:with-param name="module_name" select="@name"/>
    </xsl:call-template>
  </xsl:variable>
  <a href="{$xref}">
    <font size="-1">
      <b><xsl:value-of select="@name"/> (<xsl:value-of select="$part"/>)</b>
    </font>
  </a>

  <xsl:variable name="xref4"
    select="concat('./data/modules/',@name,'/sys/4_info_reqs',$FILE_EXT,'#arm')"/>

  <xsl:variable name="arm_expg"
    select="concat('./data/modules/',@name,'/armexpg1',$FILE_EXT,'#arm')"/>
  
  <xsl:variable name="xref5"
    select="concat('./data/modules/',@name,'/sys/5_mim',$FILE_EXT,'#mim')"/>

  <xsl:variable name="mim_expg"
    select="concat('./data/modules/',@name,'/mimexpg1',$FILE_EXT,'#arm')"/>

  <xsl:variable name="mod_directory"
    select="concat('./data/modules/',@name)"/>
  
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
      <td>
        <font size="-2">
          <a href="{$mod_directory}">.</a>
        </font>
      </td>

      </tr>
    </table>
</xsl:template>

<xsl:template match="resource">
  <xsl:variable name="xref" select="concat('./data/resources/',@name,'/',@name,$FILE_EXT)"/>
  <a href="{$xref}">
    <font size="-1">
      <b><xsl:value-of select="@name"/></b>
    </font>
  </a>
  <br/>
</xsl:template>


<xsl:template name="get_module_part">
  <!--
       for now, just use@part
  <xsl:param name="module_name"/>
  <xsl:variable name="module_file" 
    select="concat('../data/modules/',$module_name,'/module.xml')"/>

  <xsl:variable name="module_node"
    select="document($module_file)/module[@name=$module_name]"/>
  <xsl:variable name="part" select="$module_node/@part"/>
  <xsl:value-of select="$part"/>
-->
  <xsl:value-of select="@part"/>
</xsl:template>

</xsl:stylesheet>