<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: common.xsl,v 1.4 2001/11/12 08:55:58 robbod Exp $
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
     global parameter: output_css in parameter.xsl
     -->
<xsl:template name="output_css">
  <xsl:param name="path"/>
  <xsl:if test="$output_css">
    <xsl:variable name="hpath"
      select="concat($path,$output_css)"/>
    <link 
      rel="stylesheet" 
      type="text/css" 
      href="{$hpath}"/>
  </xsl:if>
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
     Output the module title
-->
<xsl:template match="module" mode="title">
  <xsl:variable 
    name="date"
    select="translate(@cvs.date,'$','')"/>
  <xsl:variable 
    name="rev"
    select="translate(@cvs.revision,'$','')"/>
  <xsl:value-of select="concat(@part,' :- ',@name,'  (',$date,' ',$rev,')')"/>
</xsl:template>

<!--
     Output the tile for a table of contents banner for a module
     displayed on separate pages
-->
<xsl:template match="module" mode="TOCbannertitle">
  <!-- the entry that has been selected -->
  <xsl:param name="selected"/>
  <TABLE cellspacing="0" border="0" width="100%">
    <TR>
      <TD valign="MIDDLE">
        <B>
          application module: 
          <xsl:value-of select="@name"/>
        </B>
      </TD>
      <TD valign="MIDDLE">
        <B>
          <xsl:value-of select="concat('ISO/',@status,'10303-',@part,':2001(E)')"/>
        </B>
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
      select="'../../../warning.gif'"/>
    <br/> 
    <IMG 
      SRC="{$warning_gif}" 
      ALT="[warning:]" 
      align="absbottom"
      BORDER="0"/>
    <xsl:value-of select="$message"/>
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

  <!-- output the error message -->
  <xsl:template name="error">
    <xsl:param name="message"/>
    
    <xsl:variable name="warning_gif" select="'../../../../images/warning.gif'"/>
    <br/>
    <IMG 
      SRC="{$warning_gif}" ALT="[warning:]" 
      align="absbottom" border="0"
      width="20" height="20"/>
    <font color="#FF0000" size="-1">
      <i>
        <xsl:value-of select="concat('Error: ',$message)"/>
      </i>
    </font>
    <br/>
  </xsl:template>

</xsl:stylesheet>


