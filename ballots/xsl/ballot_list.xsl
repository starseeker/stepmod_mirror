<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: ballot_list.xsl,v 1.2 2002/07/09 10:32:52 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited http://www.eurostep.com
  Purpose: To display the modules according to ballot packages

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">


  <xsl:import href="../../xsl/common.xsl"/>


  <xsl:output 
    method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    indent="yes"
    />


  <!-- force the application of the stylesheet to the file specified in the
       file attribute -->
  <xsl:template match="/">
    <xsl:variable name="ballot_index" 
      select="concat('../ballots/',./ballot/@directory,'/ballot_index.xml')"/>
    <xsl:apply-templates select="document($ballot_index)/ballot_index"/>
  </xsl:template>



<xsl:template match="ballot_index">
  <HTML>
    <head>
      <title>
        <xsl:value-of select="@name"/>
      </title>
    </head>
    <body>

      <xsl:call-template name="output_menubar">
        <xsl:with-param name="module_root" select="'.'"/>
        <xsl:with-param name="module_name" select="@name"/>
      </xsl:call-template>
      <hr/>
      <p align="center">
        <xsl:apply-templates select="./ballot_package" mode="TOC"/>
      </p>
      <xsl:apply-templates select="./ballot_package"/>
    </body>
  </HTML>
</xsl:template>


<xsl:template match="ballot_package" mode="TOC">
  <xsl:variable name="bpxref" select="concat(@id,'-',@name)"/>
  <small>
    <a href="#{$bpxref}">
      <xsl:choose>
        <xsl:when test="@id">
          <xsl:value-of select="concat(@id,' - ',@name)"/>    
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@name"/> 
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </small>
    <xsl:if test="position() != last()">
      &#160;&#124;&#160;
    </xsl:if>        
</xsl:template>



<xsl:template match="ballot_package">
  <xsl:variable name="bpaname" select="concat(@id,'-',@name)"/>
  <h3>
    <a name="{$bpaname}">
      <xsl:choose>
        <xsl:when test="@id">
          <xsl:value-of select="concat(@id,' - ',@name)"/>    
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@name"/> 
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </h3>

  <xsl:variable name="module_mid_point"
    select="(count(./module)+1) div 2"/>
  
  <blockquote>
    <table width="90%" cellspacing="0" cellpadding="4">
      <tr>
        <td valign="top">
          <xsl:apply-templates select="./module" mode="col1">
            <xsl:with-param name="mid_point" select="$module_mid_point"/>
            <xsl:sort select="@name"/>
          </xsl:apply-templates>
        </td>
        <td valign="top">
          <xsl:apply-templates select="./module" mode="col2">
            <xsl:with-param name="mid_point" select="$module_mid_point"/>
            <xsl:sort select="@name"/>
          </xsl:apply-templates>
        </td>
      </tr>
    </table>
  </blockquote>
</xsl:template>

<xsl:template match="module" mode="col1">
  <xsl:param name="mid_point"/>
  <xsl:if test="not(position()>$mid_point)">
    <xsl:apply-templates select="." mode="output"/>
  </xsl:if>
</xsl:template>

<xsl:template match="module" mode="col2">
  <xsl:param name="mid_point"/>
  <xsl:if test="position()>$mid_point">
    <xsl:apply-templates select="."  mode="output"/>
  </xsl:if>
</xsl:template>


<xsl:template match="module" mode="output">
  <xsl:variable name="xref"
    select="concat('../../../data/modules/',@name,'/sys/introduction',$FILE_EXT)"/>
  <a href="{$xref}">
    <small>
      <b>
        <xsl:value-of select="@name"/>&#160;
        <xsl:call-template name="get_module_part">
          <xsl:with-param name="module_name" select="@name"/>
        </xsl:call-template>
      </b>
    </small>
  </a>
  <br/>
</xsl:template>


<xsl:template name="get_module_part">
  <xsl:variable name="module_name" select="@name"/>
  <xsl:variable name="module_file"
    select="concat('../../data/modules/',@name,'/module.xml')"/>

  <xsl:variable name="in_repo"
    select="document('../../repository_index.xml')/repository_index/modules/module[@name=$module_name]"/>
  <xsl:choose>
    <!-- the module is present in the STEP mod repository -->
    <xsl:when test="$in_repo">
      <xsl:variable name="module_node"
        select="document($module_file)/module[@name=$module_name]"/>
      <xsl:variable name="part" select="$module_node/@part"/>
      (<xsl:value-of select="$part"/>)
    </xsl:when>

    <xsl:otherwise>
      <p>
        <xsl:call-template name="error_message">
          <xsl:with-param name="warning_gif"
            select="'../../../images/warning.gif'"/>
          
          <xsl:with-param name="message">
            <xsl:value-of select="concat('Error B1: Module ',
                                  $module_name,
                                  ' does not exist in stepmod/repsotory_index.xml')"/>
          </xsl:with-param>
        </xsl:call-template>
      </p>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>