<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: sect_5_mapping.xsl,v 1.8 2002/01/21 14:22:10 robbod Exp $
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
    <center>
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
  </center>
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
  <center>
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

      <xsl:call-template name="output_mapping_cells">
        <xsl:with-param name="context" select="."/>
      </xsl:call-template>
    </tr>

    <!-- now do the attributes rows -->
    <xsl:apply-templates select="./aa"/>
  </table>
  <h3>
      <xsl:value-of select="concat('Table ',position(),' - Mapping table for ', @entity)"/>
  </h3>
  <a name="{$aname}">
    <h3>
      <a href="../../../basic/mapping.htm">Mapping specification</a>
    </h3>
  </a>
</center>
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
    <xsl:apply-templates select="./alt"/>
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
        <xsl:choose>
          <xsl:when test="@assertion_to">
            <xsl:value-of select="../@entity"/> 
            to 
            <xsl:value-of select="@assertion_to"/><br/>
            (as <xsl:value-of select="@attribute"/>)
          </xsl:when>
          <xsl:otherwise>
            <a href="{$aa_xref}">
              <xsl:value-of select="@attribute"/>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </font>
    </td>

    <!-- Output the remaining mapping table cells -->
    <xsl:call-template name="output_mapping_cells">
      <xsl:with-param name="context" select="."/>
    </xsl:call-template>    
    
  </tr>
</xsl:template>


<!-- output the AIM element cell in the mapping table -->
<xsl:template name="output_aimelt">
  <xsl:param name="aimelt_parent"/>
  <td VALIGN="TOP" width="21%">
    <xsl:if test="not(./aimelt)">
      <!-- no source so setup empty cell -->
      &#160;
    </xsl:if>
    <!-- Output AIM element -->
    <xsl:apply-templates select="$aimelt_parent/aimelt"/>  
  </td>
</xsl:template>

<xsl:template match="aimelt">
  <xsl:apply-templates />  
</xsl:template>

<xsl:template match="aimelt" mode="old">

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

  <!-- ignore HREF when aimelt PATH -->
  <xsl:choose>
    <xsl:when test="$aimelt='PATH'">
      <xsl:value-of select="$aimelt"/>
    </xsl:when>
    <xsl:when test="./express_ref">
      <xsl:apply-templates select="./express_ref"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="aim_xref">
        <xsl:call-template name="xref_resource_object">
          <xsl:with-param name="object_name" select="$aim_entity"/>
        </xsl:call-template>
      </xsl:variable>

      <font size="-1">
        <a href="{$aim_xref}">
          <xsl:value-of select="$aimelt"/>
        </a>
      </font>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>


<!-- output the source element cell in the mapping table -->
<xsl:template name="output_source">
  <xsl:param name="source_parent"/>
  <td VALIGN="TOP" width="6%">
    <xsl:if test="not($source_parent/source)">
      <!-- no source so setup empty cell -->
      &#160;
    </xsl:if>
    <xsl:apply-templates select="$source_parent/source"/>
  </td>
</xsl:template>

<xsl:template match="source">
  <font size="-1">
    <xsl:value-of select="string(.)"/>
  </font>
</xsl:template>



<!-- output the rule cell in the mapping table -->
<xsl:template name="output_rule">
  <xsl:param name="rule_parent"/>
  <td VALIGN="TOP" width="5%">
    <xsl:if test="not($rule_parent/express_ref)">
      <!-- no rules so setup empty cell-->
      &#160;
    </xsl:if>
    <xsl:apply-templates 
      select="$rule_parent/express_ref"/>
  </td>
</xsl:template>

<!-- output alt text in the mapping table -->
<xsl:template match="alt">
  <font size="-1">
    <xsl:value-of select="string(.)"/>
  </font>  
</xsl:template>


<!-- output the refpath cell in the mapping table -->
<xsl:template name="output_refpath">
  <xsl:param name="refpath_parent"/>
  <td VALIGN="TOP" width="6%">
    <xsl:if test="not($refpath_parent/refpath)">
      <!-- no refpath so setup empty cell -->
      &#160;
    </xsl:if>
    <xsl:apply-templates select="$refpath_parent/refpath"/>
  </td>
</xsl:template>

<xsl:template match="refpath">

  <center>
    <font size="-1">
      <xsl:call-template name="output_string_with_linebreaks">
        <xsl:with-param name="string" select="string(.)"/>
      </xsl:call-template>
    </font>  
  </center>
</xsl:template>


<xsl:template name="output_mapping_cells">
  <xsl:param name="context"/>

  <!-- Output AIM element cell-->
  <xsl:call-template name="output_aimelt">
    <xsl:with-param name="aimelt_parent" select="$context"/>
  </xsl:call-template>

  <!-- Output source cell -->
  <xsl:call-template name="output_source">
    <xsl:with-param name="source_parent" select="$context"/>
  </xsl:call-template>

  <!-- Output express_ref (rule) cell -->
  <xsl:call-template name="output_rule">
    <xsl:with-param name="rule_parent" select="$context"/>
  </xsl:call-template>
  
  <!-- Output refpath cell -->
  <xsl:call-template name="output_refpath">
    <xsl:with-param name="refpath_parent" select="$context"/>
  </xsl:call-template>
  
</xsl:template>

</xsl:stylesheet>
