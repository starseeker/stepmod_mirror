<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: sect_5_mapping.xsl,v 1.4 2001/11/21 15:34:33 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="module.xsl"/>

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
  <xsl:import href="module_clause.xsl"/>


  <xsl:output method="html"/>


  <!-- +++++++++++++++++++
         Global variables
       +++++++++++++++++++ -->

  <!-- a list of all the entities and resources defined in the resources.
       Used by link_resource_object to produce a URL
       -->
  <xsl:variable name="global_resource_xref_list">
    <xsl:call-template name="build_resource_xref_list"/>
  </xsl:variable>


  <!-- A global variable used by the express_file_to_ref template defined
       in express_link.xsl.
       It defines the relative path from the file applying the stylesheet
       to the root of the stepmod repository.
       sect_e_exp_arm.xsl stylesheet is normally used
         stepmod/data/module/?module?/sys/5_mapping.xml
       Hence the relative root is: ../../../../
       -->
  <xsl:variable 
    name="relative_root"
    select="'../../../../'"/>

  <!-- +++++++++++++++++++
         Templates
       +++++++++++++++++++ -->

<!-- overwrites the template declared in module.xsl -->
<xsl:template match="module">
  <xsl:apply-templates select="./mapping_table" mode="toc"/>
  <xsl:apply-templates select="./mapping_table/ae" mode="table"/>
</xsl:template>

<xsl:template match="mapping_table" mode="toc">
  <xsl:variable name="table_count" select="(count(./ae)+1) div 2"/>
  <blockquote>
    <table width="90%" cellspacing="0" cellpadding="4">
      <tr>
        <td>
          <xsl:apply-templates 
            select="./ae[not(position() > $table_count)]"
            mode="toc">
            <xsl:sort select="@entity"/>
          </xsl:apply-templates>
        </td>
        <td>
          <xsl:apply-templates 
            select="./ae[position() > $table_count]"
            mode="toc">
            <xsl:sort select="@entity"/>
          </xsl:apply-templates>
        </td>
      </tr>
    </table>
  </blockquote>
  <hr/>
</xsl:template>

<xsl:template match="ae" mode="toc">
  <xsl:variable name="aname" select="@entity"/>
  <a href="#{$aname}">
    <xsl:value-of select="concat('Table: ', $aname)"/>
  </a>
  <br/>
</xsl:template>

<xsl:template match="ae" mode="table">
  <xsl:variable name="aname" select="@entity"/>
  <a name="{$aname}">
    <h3>
      <a href="../../../basic/mapping.htm">Mapping specification</a>
    </h3>
  </a>
  <h3>
      <xsl:value-of select="concat('Table ',position(),' - ', @entity)"/>
  </h3>
  <table border="1" width="622">
    <tr>
      <td VALIGN="TOP" width="21%">
        <font size="-1"><b>Application element</b></font>
      </td>
      <td VALIGN="TOP" width="21%">
        <font size="-1"><b>MIM element</b></font>
      </td>
      <td VALIGN="TOP" width="6%">
        <font size="-1"><b>Source</b></font>
      </td>
      <td VALIGN="TOP" width="5%">
        <font size="-1"><b>Rules</b></font>
      </td>
      <td VALIGN="TOP" width="47%">
        <font size="-1"><b>Reference path</b></font>
      </td>
    </tr>

    <tr>

      <xsl:apply-templates select="."/>
      <xsl:apply-templates select="./aimelt"/>
      <xsl:apply-templates select="./source"/>

      <!-- no rules -->
      <td VALIGN="TOP" width="5%">&#160;</td>
      
      <!-- ref path-->
      <td VALIGN="TOP" width="47%">&#160;</td>
    </tr>
    
    <!-- now do the attributes rows -->
    <xsl:apply-templates select="./aa"/>
  </table>
</xsl:template>

<xsl:template match="ae">
  <xsl:variable 
    name="schema_name" 
    select="concat(../../../module/@name,'_arm')"/>
    <xsl:variable name="ae_aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@entity"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable 
    name="ae_xref"
    select="concat('./4_info_reqs',$FILE_EXT,'#',$ae_aname)"/>

  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="arm_entity"
    select="translate(@entity,$LOWER,$UPPER)"/>



  <td VALIGN="TOP" width="21%">
    <font size="-1">
      <a href="{$ae_xref}">
        <xsl:value-of select="$arm_entity"/>
      </a>
    </font>
  </td>

</xsl:template>


<xsl:template match="aa">
  <xsl:variable 
    name="schema_name" 
    select="concat(../../../../module/@name,'_arm')"/>

  <xsl:variable name="aa_aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="../@entity"/>
      <xsl:with-param name="section3" select="@attribute"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable 
    name="aa_xref"
    select="concat('./4_info_reqs',$FILE_EXT,'#',$aa_aname)"/>

  <tr>
    <td VALIGN="TOP" width="21%">
      <font size="-1">
        <a href="{$aa_xref}">
          <xsl:value-of select="@attribute"/>
        </a>
      </font>
    </td>
    
    <xsl:apply-templates select="./aimelt"/>
    <xsl:apply-templates select="./source"/>
    
    <!-- no rules -->
    <td VALIGN="TOP" width="5%">&#160;</td>
    
    <!-- ref path-->
    <td VALIGN="TOP" width="47%">&#160;</td>    
  </tr>
</xsl:template>

<xsl:template match="aimelt">

  <xsl:variable 
    name="aimelt"
    select="translate(normalize-space(string(.)),' ','')"/>

  <xsl:variable name="aim_entity">
    <xsl:choose>
      <xsl:when test="contains($aimelt,'.')">
        <xsl:value-of select="substring-before($aimelt,'.')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$aimelt"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="aim_xref">
    <xsl:call-template name="xref_resource_object">
      <xsl:with-param name="object_name" select="$aim_entity"/>
    </xsl:call-template>
  </xsl:variable>

  <td VALIGN="TOP" width="21%">
    <font size="-1">
      <a href="{$aim_xref}">
        <xsl:value-of select="$aimelt"/>
      </a>
    </font>
  </td>
</xsl:template>

<xsl:template match="source">
  <td VALIGN="TOP" width="6%">
    <font size="-1">
      <xsl:value-of select="string(.)"/>
    </font>
  </td>        
</xsl:template>

 
</xsl:stylesheet>
