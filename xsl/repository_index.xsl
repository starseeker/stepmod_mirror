<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
     $Id: repository_index.xsl,v 1.22 2003/02/03 13:46:19 robbod Exp $

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
          <td>
            <h2>
              <a href="ballots/index{$FILE_EXT}">
                Ballots
              </a>
            </h2>
          </td>
        </tr>
      </table>
      
  <font size="-1">
  <b>
    The use of this page is deprecated. 
    <br/>
    It has been replaced by a significantly improved navigation facility available at: 
    <br/>
    <a href="./nav/index{$FILE_EXT}">
      <xsl:value-of select="concat('./nav/index',$FILE_EXT)"/>        
    </a>
  </b>
</font>

      <xsl:variable name="module_mid_point"
        select="(count(./modules/module)+1) div 2"/>

      <blockquote>
        <table width="90%" cellspacing="0" cellpadding="4">
          <tr>
            <td valign="top">
              <xsl:apply-templates select="./modules/module" mode="col1">
                <xsl:with-param name="mid_point" select="$module_mid_point"/>
                <xsl:sort select="@name"/>
              </xsl:apply-templates>
            </td>
            <td valign="top">
              <xsl:apply-templates select="./modules/module" mode="col2">
                <xsl:with-param name="mid_point" select="$module_mid_point"/>
                <xsl:sort select="@name"/>
              </xsl:apply-templates>
            </td>
          </tr>
        </table>
      </blockquote>
      <h2>
        <a name="alphatop">
          Alphabetical list of Common Resource schemas
        </a>
      </h2>
      <xsl:variable name="resource_mid_point"
        select="(count(./resources/resource)+1) div 2"/>

      <blockquote>
        <table width="90%" cellspacing="0" cellpadding="4">
          <tr>
            <td valign="top">
              <xsl:apply-templates select="./resources/resource" mode="col1">
                <xsl:with-param name="mid_point" select="$resource_mid_point"/>
                <xsl:sort select="@name"/>
              </xsl:apply-templates>
            </td>
            <td valign="top">
              <xsl:apply-templates select="./resources/resource" mode="col2">
                <xsl:with-param name="mid_point" select="$resource_mid_point"/>
                <xsl:sort select="@name"/>
              </xsl:apply-templates>
            </td>
          </tr>
        </table>
      </blockquote>
      <xsl:apply-templates select="./application_protocols"/>
    </BODY>
  </HTML>
</xsl:template>

<xsl:template match="module" mode="col1">
  <xsl:param name="mid_point"/>
  <xsl:if test="not(position()>$mid_point)">
     <xsl:apply-templates select="." mode="output"/> 
     <!-- <xsl:apply-templates select="." mode="output_mod_part_nos"/> -->
  </xsl:if>
</xsl:template>

<xsl:template match="module" mode="col2">
  <xsl:param name="mid_point"/>
  <xsl:if test="position()>$mid_point">
    <!-- <xsl:apply-templates select="." mode="output_mod_part_nos"/>  -->
    <xsl:apply-templates select="."  mode="output"/> 
  </xsl:if>
</xsl:template>


<xsl:template match="module" mode="output">
  <xsl:variable name="xref"
    select="concat('./data/modules/',@name,'/sys/introduction',$FILE_EXT)"/>
  <xsl:variable name="part" select="@part"/>

  <a href="{$xref}">
    <font size="-1">
      <b><xsl:value-of select="@name"/> (<xsl:value-of select="$part"/>)</b>
    </font>
  </a>

  <xsl:variable name="xref4"
    select="concat('./data/modules/',@name,'/sys/4_info_reqs',$FILE_EXT)"/>

  <!--
  <xsl:variable name="arm_expg"
    select="concat('./data/modules/',@name,'/sys/c_arm_expg',$FILE_EXT,'#armexpg')"/>
  -->

  <xsl:variable name="arm_expg"
    select="concat('./data/modules/',@name,'/armexpg1',$FILE_EXT)"/>
  
  <xsl:variable name="xref5"
    select="concat('./data/modules/',@name,'/sys/5_mim',$FILE_EXT)"/>


  <!--
       <xsl:variable name="mim_expg"
    select="concat('./data/modules/',@name,'/sys/d_mim_expg',$FILE_EXT,'#mimexpg')"/>
       -->
       
  <xsl:variable name="mim_expg"
    select="concat('./data/modules/',@name,'/mimexpg1',$FILE_EXT)"/>

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
          <a href="{$mod_directory}">
            <img alt="module folder" 
              border="0"
              align="middle"
              src="./images/folder.gif"/>
          </a>
        </font>
      </td>

      </tr>
    </table>
</xsl:template>



<xsl:template match="module" mode="output_mod_part_nos">
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
    select="concat('./data/modules/',@name,'/sys/4_info_reqs',$FILE_EXT)"/>

  <!--
  <xsl:variable name="arm_expg"
    select="concat('./data/modules/',@name,'/sys/c_arm_expg',$FILE_EXT,'#armexpg')"/>
  -->

  <xsl:variable name="arm_expg"
    select="concat('./data/modules/',@name,'/armexpg1',$FILE_EXT)"/>
  
  <xsl:variable name="xref5"
    select="concat('./data/modules/',@name,'/sys/5_mim',$FILE_EXT)"/>


  <!--
       <xsl:variable name="mim_expg"
    select="concat('./data/modules/',@name,'/sys/d_mim_expg',$FILE_EXT,'#mimexpg')"/>
       -->
       
  <xsl:variable name="mim_expg"
    select="concat('./data/modules/',@name,'/mimexpg1',$FILE_EXT)"/>

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
          <a href="{$mod_directory}">
            <img alt="module folder" 
              border="0"
              align="middle"
              src="./images/folder.gif"/>
          </a>
        </font>
      </td>

      </tr>
    </table>
</xsl:template>




<xsl:template match="resource" mode="col1">
  <xsl:param name="mid_point"/>
  <xsl:if test="not(position()>$mid_point)">
    <xsl:apply-templates select="." mode="output"/>
  </xsl:if>
</xsl:template>

<xsl:template match="resource" mode="col2">
  <xsl:param name="mid_point"/>
  <xsl:if test="position()>$mid_point">
    <xsl:apply-templates select="."  mode="output"/>
  </xsl:if>
</xsl:template>


<xsl:template match="resource" mode="output">
  <xsl:variable name="xref" select="concat('./data/resources/',@name,'/',@name,$FILE_EXT)"/>
  <a href="{$xref}">
    <font size="-1">
      <b><xsl:value-of select="@name"/></b>
    </font>
  </a>
  <br/>
</xsl:template>


<xsl:template name="get_module_part">
  <xsl:param name="module_name"/>
  <xsl:variable name="module_file" 
    select="concat('../data/modules/',$module_name,'/module.xml')"/>

  <xsl:variable name="module_node"
    select="document($module_file)/module[@name=$module_name]"/>
  <xsl:variable name="part" select="$module_node/@part"/>
  <xsl:value-of select="$part"/>
</xsl:template>


<xsl:template match="application_protocols">
  <h2>
    <a name="alphatop">
      Alphabetical list of Application Protocols
    </a>
  </h2>
  <xsl:variable name="application_protocol_mid_point" select="(count(./application_protocol)+1) div 2"/>
  <blockquote>
    <table width="90%" cellspacing="0" cellpadding="4">
      <tr>
        <td valign="top">
          <xsl:apply-templates select="./application_protocol" mode="col1">
            <xsl:with-param name="mid_point" select="$application_protocol_mid_point"/>
            <xsl:sort select="@name"/>
          </xsl:apply-templates>
        </td>
        <td valign="top">
          <xsl:apply-templates select="./application_protocol" mode="col2">
            <xsl:with-param name="mid_point" select="$application_protocol_mid_point"/>
            <xsl:sort select="@name"/>
          </xsl:apply-templates>
        </td>
      </tr>
    </table>
  </blockquote>
</xsl:template>

<xsl:template match="application_protocol" mode="col1">
  <xsl:param name="mid_point"/>
  <xsl:if test="not(position()>$mid_point)">
    <xsl:apply-templates select="." mode="output"/>
  </xsl:if>
</xsl:template>

<xsl:template match="application_protocol" mode="col2">
  <xsl:param name="mid_point"/>
  <xsl:if test="position()>$mid_point">
    <xsl:apply-templates select="."  mode="output"/>
  </xsl:if>
</xsl:template>

	
<xsl:template match="application_protocol" mode="output">
  <xsl:variable name="xref" 
    select="concat('./data/application_protocols/',@name,'/sys/introduction',$FILE_EXT)"/>
  <xsl:variable name="part">
    <xsl:call-template name="get_application_protocol_part">
      <xsl:with-param name="application_protocol_name" select="@name"/>
    </xsl:call-template>
  </xsl:variable>
  <a href="{$xref}">
    <font size="-1">
      <b>
        <xsl:value-of select="@name"/>
        (
        <xsl:value-of select="$part"/>
        )
      </b>
    </font>
  </a>
  <xsl:variable name="xref4" select="concat('./data/application_protocols/',@name,'/sys/4_info_reqs',$FILE_EXT)"/>
  <xsl:variable name="arm_expg" select="concat('./data/modules/',@name,'/armexpg1',$FILE_EXT)"/>
  <xsl:variable name="xref5" select="concat('./data/application_protocols/',@name,'/sys/5_aim',$FILE_EXT)"/>
<xsl:variable name="aim_expg" select="concat('./data/modules/',@name,'/mimexpg1',$FILE_EXT)"/>
  <xsl:variable name="aam" select="concat('./data/application_protocols/',@name,'/sys/e_aam',$FILE_EXT)"/>
  <xsl:variable name="ap_directory" select="concat('./data/application_protocols/',@name)"/>
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
          <a href="{$xref5}">AIM</a>
        </font>
      </td>
      <td>
        <font size="-2">
          <a href="{$aim_expg}">AIM-G</a>
        </font>
      </td>
      <td>
        <font size="-2">
          <a href="{$aam}">AAM</a>
        </font>
      </td>
      
      <td>
        <font size="-2">
          <a href="{$ap_directory}">
            <img alt="application_protocol folder" border="0" align="middle" src="./images/folder.gif"/>
          </a>
        </font>
      </td>
    </tr>
  </table>
</xsl:template>

<xsl:template name="get_application_protocol_part">
  <xsl:value-of select="@part"/>
</xsl:template>

</xsl:stylesheet>