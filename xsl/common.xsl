<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: common.xsl,v 1.7 2001/11/15 18:16:11 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     Templates that are common to most other stylesheets
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <!-- 
       Template to detemine whether the output is XML or HTML 
       Sets variable global FILE_EXT
       -->
  <xsl:import href="file_ext.xsl"/>

  <!-- parameters that control the output -->
  <xsl:import href="parameters.xsl"/>

  <xsl:output method="html"/>

<!--
     Output a cascading stylesheet. The stylesheet is specified in the 
     global parameter: output_css in parameter.xsl, so to prevent a
     cascading stylesheet being used set output_css to ''
     To override this and force a cascading stylesheet set
     overide_css
     -->
<xsl:template name="output_css">
  <xsl:param name="path"/>
  <xsl:param name="override_css"/>
  <xsl:choose>
    <xsl:when test="$override_css">
      <xsl:variable name="hpath"
      select="concat($path,$override_css)"/>
      <link 
        rel="stylesheet" 
        type="text/css" 
        href="{$hpath}"/>
    </xsl:when>
    <xsl:when test="$output_css">
      <xsl:variable name="hpath"
        select="concat($path,$output_css)"/>
      <link 
        rel="stylesheet" 
        type="text/css" 
        href="{$hpath}"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>


<!--
     Output an HTML meta element for inclusion in the header of the HTML file
-->
<xsl:template name="meta-elements">
  <xsl:param name="name" />
  <xsl:param name="content" />

  <xsl:element name="META">
    <xsl:attribute name="name">
      <xsl:value-of select="$name"/>
    </xsl:attribute>
    <xsl:attribute name="content">
      <xsl:value-of select="$content"/>
    </xsl:attribute>
  </xsl:element>
</xsl:template>

<!--
     Output the module title - used to create the HTML TITLE
     If the global parameter: output_rcs in parameter.xsl
     is set, then RCS version control information is displayed
-->
<xsl:template match="module" mode="title">
  <xsl:variable 
    name="lpart">
    <xsl:choose>
      <xsl:when test="string-length(@part)>0">
        <xsl:value-of select="@part"/>
      </xsl:when>
      <xsl:otherwise>
        XXXX
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$output_rcs">
      <xsl:variable 
        name="date"
        select="translate(@rcs.date,'$','')"/>
      <xsl:variable 
        name="rev"
        select="translate(@rcs.revision,'$','')"/>
      <xsl:value-of 
        select="concat($lpart,' :- ',@name,'  (',$date,' ',$rev,')')"/>      
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of 
        select="concat($lpart,' :- ',@name)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

  <!-- output RCS version control information -->
<xsl:template name="rcs_output">
  <xsl:param name="module" select="@name"/>
  <xsl:if test="$output_rcs">
    <xsl:variable name="mod_dir">
      <xsl:call-template name="module_directory">
        <xsl:with-param name="module" select="$module"/>
      </xsl:call-template>           
    </xsl:variable>

    <table cellspacing="0" border="0">
      <xsl:variable
        name="module_file" 
        select="concat($mod_dir,'/module.xml')"/>
      <xsl:variable 
        name="module_date"
        select="translate(document($module_file)/module/@rcs.date,'$','')"/>
      <xsl:variable 
      name="module_rev"
        select="translate(document($module_file)/module/@rcs.revision,'$','')"/>
      <tr>
        <td>
          <font size="-2">
            <xsl:value-of select="'module.xml'"/>
          </font>
        </td> 
        <td>
          <font size="-2">
            <xsl:value-of select="concat('(',$module_date,' ',$module_rev,')')"/>
          </font>
        </td>
        <td>&#160;&#160;</td>
      <xsl:variable
        name="arm_file" 
        select="concat($mod_dir,'/arm.xml')"/>
      <xsl:variable 
        name="arm_date"
        select="translate(document($arm_file)/express/@rcs.date,'$','')"/>
      <xsl:variable 
        name="arm_rev"
        select="translate(document($arm_file)/express/@rcs.revision,'$','')"/>

        <td>
          <font size="-2">
            <xsl:value-of select="'arm.xml'"/>
          </font>
        </td>
        <td>
          <font size="-2">
            <xsl:value-of select="concat('(', $arm_date,' ',$arm_rev,')')"/>
          </font>
        </td>
        <td>&#160;&#160;</td>
      
      <xsl:variable
        name="mim_file" 
        select="concat($mod_dir,'/mim.xml')"/>
      <xsl:variable 
        name="mim_date"
        select="translate(document($mim_file)/express/@rcs.date,'$','')"/>
      <xsl:variable 
        name="mim_rev"
        select="translate(document($mim_file)/express/@rcs.revision,'$','')"/>

        <td>
          <font size="-2">
            <xsl:value-of select="'mim.xml'"/>
          </font>
        </td>
        <td>
          <font size="-2">
            <xsl:value-of select="concat('(',$mim_date,' ',$mim_rev,')')"/>
          </font>
        </td>
      </tr>
    </table>
  </xsl:if>  
</xsl:template>

<!--
     Output the tile for a table of contents banner for a module
     displayed on separate pages
     If the global parameter: output_rcs in parameter.xsl
     is set, then RCS version control information is displayed
-->
<xsl:template match="module" mode="TOCbannertitle">
  <!-- the entry that has been selected -->
  <xsl:param name="selected"/>

  <!-- output RCS version control information -->
  <xsl:call-template name="rcs_output">
    <xsl:with-param name="module" select="@name"/>
  </xsl:call-template>

  <TABLE cellspacing="0" border="0" width="100%">
    <TR>
      <TD valign="MIDDLE">
        <B>
          application module: 
          <xsl:value-of select="@name"/>
        </B>
      </TD>
      <TD valign="MIDDLE">
        <xsl:choose>
          <xsl:when test="string-length(@part)>0">
            <b>
              <xsl:value-of 
                select="concat('ISO/',@status,'10303-',@part,':2001(E)')"/>
            </b>
          </xsl:when>
          <xsl:otherwise>
            <b>
              <xsl:value-of select="concat('ISO/',@status,'10303-')"/><font color="#FF0000">XXXX</font>:2001(E)</b>
      </xsl:otherwise>
    </xsl:choose>

      </TD>
    </TR>
  </TABLE>
</xsl:template>



<!-- output the clause heading -->
<xsl:template name="clause_header">
  <xsl:param name="heading"/>
  <xsl:param name="aname"/>
  <H3>
    <A NAME="{$aname}">
      <xsl:value-of select="$heading"/>
    </A>
  </H3>
</xsl:template>

<xsl:template match="description">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="note" >
  <blockquote>
    <xsl:value-of select="concat('NOTE ',position(),' ')"/>
    <xsl:apply-templates/>
  </blockquote>
</xsl:template>


<!-- 
     An unordered list 
     -->
<xsl:template match="ul" >
  <ul>
    <xsl:apply-templates/>
  </ul>
</xsl:template>

<!-- 
     An ordered list 
     -->
<xsl:template match="ol" >
  <xsl:variable
    name="type"
    select="@type"/>
  <xsl:choose>
    <xsl:when test="$type">
      <ol type="{$type}">
        <xsl:apply-templates/>
      </ol>
    </xsl:when>
    <xsl:otherwise>
      <ol>
        <xsl:apply-templates/>
      </ol>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- 
     A list item
     -->
<xsl:template match="li" >
  <li>
    <xsl:apply-templates/>
  </li>
</xsl:template>



<!-- Given a string representing a space separated list, remove all
     duplicate words
-->
  <!--
       Removes all duplicate words from the list
       -->
  <xsl:template name="remove_duplicates">
    <xsl:param name="list" />
    <xsl:call-template name="remove_duplicates_rec">
      <xsl:with-param name="list" 
        select="concat(normalize-space($list),' ')" />
      <xsl:with-param name="return_list" select="' '" />
    </xsl:call-template>      
  </xsl:template>
  <xsl:template name="remove_duplicates_rec">
    <xsl:param name="list" />
    <xsl:param name="return_list" />
    <xsl:variable 
      name="first"
      select="substring-before($list,' ')" />
    <xsl:variable 
      name="rest"
      select="substring-after($list,' ')" />
    <xsl:choose>
      <!-- only one word left -->
      <xsl:when test="not($first)" >
        <xsl:choose>
          <!-- check that the word has not already been found -->
          <xsl:when test="contains($return_list,concat(' ',$list,' '))">
            <xsl:value-of select="normalize-space($return_list)" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="normalize-space(concat($return_list,' ',$list))" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="contains($return_list,concat(' ',$first,' '))" >
        <xsl:call-template name="remove_duplicates_rec">
          <xsl:with-param name="list" select="$rest" />
          <xsl:with-param name="return_list" select="$return_list" />
        </xsl:call-template>      
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="remove_duplicates_rec">
          <xsl:with-param name="list" select="$rest" />
          <xsl:with-param name="return_list" select="concat($return_list,$first,' ')" />
        </xsl:call-template>      
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- output a warning message
       -->
  <xsl:template name="error_message">
    <xsl:param name="message"/>
      <!-- default -->
    <xsl:param name="warning_gif"
      select="'../../../../images/warning.gif'"/>
    <br/> 
    <IMG 
      SRC="{$warning_gif}" ALT="[warning:]" 
      align="absbottom" border="0"
      width="20" height="20"/>
    <font color="#FF0000" size="-1">
      <i>
        <xsl:value-of select="$message"/>
      </i>
    </font>
    <br/>
  </xsl:template>


  <!-- given the name of a module, or module arm or mim schema
       return the name of the module
       -->
  <xsl:template name="module_name">
    <xsl:param name="module"/>
    <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
    <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
    <xsl:variable name="module_lcase"
      select="translate($module,$UPPER, $LOWER)"/>
    <xsl:variable name="mod_name">
      <xsl:choose>
        <xsl:when test="contains($module_lcase,'_arm')">
          <xsl:value-of select="substring-before($module_lcase,'_arm')"/>
        </xsl:when>
        <xsl:when test="contains($module_lcase,'_mim')">
          <xsl:value-of select="substring-before($module_lcase,'_mim')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="string($module_lcase)"/>
        </xsl:otherwise>
      </xsl:choose>      
    </xsl:variable>
    <xsl:value-of select="$mod_name"/>
  </xsl:template>

  <!-- given the name of a module, or module arm or mim schema
       return the directory part
-->
  <xsl:template name="module_directory">
    <xsl:param name="module"/>
    <xsl:variable name="mod_dir">
      <xsl:call-template name="module_name">
        <xsl:with-param name="module" select="$module"/>
      </xsl:call-template>           
    </xsl:variable>
    <xsl:value-of select="concat('../data/modules/',$mod_dir)"/>
  </xsl:template>

  <!-- return the target for an express entity
       This will be of the form schema.entity.attribute
       -->
  <xsl:template name="express_a_name">
    <xsl:param name="section1" select="''"/>
    <xsl:param name="section2" select="''"/>
    <xsl:param name="section3" select="''"/>
    <xsl:param name="section3separator" select="'.'"/>
    <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
    <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
    
    <xsl:variable name="s1"
      select="normalize-space(translate($section1,$UPPER,$LOWER))"/>
    <xsl:variable name="s2"
      select="normalize-space(translate($section2,$UPPER,$LOWER))"/>
    <xsl:variable name="s3"
      select="normalize-space(translate($section3,$UPPER,$LOWER))"/>

    <xsl:choose>
      <xsl:when test="$s3">
        <xsl:value-of select="concat($s1,'.',$s2,$section3separator,$s3)"/>
      </xsl:when>
      <xsl:when test="$s2">
        <xsl:value-of select="concat($s1,'.',$s2)"/>    
      </xsl:when>
      <xsl:when test="$s1">
        <xsl:value-of select="$s1"/>    
      </xsl:when>
    </xsl:choose>
    
  </xsl:template>

</xsl:stylesheet>


