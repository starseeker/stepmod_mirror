<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: $
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

  <xsl:output method="html"/>


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
  <xsl:value-of select="concat(@part,' :- ',@name)"/>
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


<!--
     Output the Table of contents banner for a module where all clauses are 
     displayed on separate pages
-->
<xsl:template match="module" mode="TOCmultiplePage">
  <!-- the entry that has been selected -->
  <xsl:param name="selected"/>
  <xsl:apply-templates select="." mode="TOCbannertitle"/>  
  <TABLE border="1" cellspacing="1" width="100%">
    <TR>
      <TD valign="TOP">
        <A HREF="cover_page{$FILE_EXT}">Cover page</A><BR/>
        <A HREF="foreword{$FILE_EXT}#foreword">Foreword</A><BR/>
        <A HREF="introduction{$FILE_EXT}#intro">Introduction</A><BR/>
        <A HREF="scope{$FILE_EXT}#scope">1 Scope</A><BR/>
        <A HREF="ref_defns{$FILE_EXT}#nref">2 Normative references</A><BR/>
        <A HREF="ref_defns{$FILE_EXT}#defns">3 Definitions and abbreviations</A>
      </TD>
      <TD valign="TOP">
        <A HREF="info_reqs{$FILE_EXT}#arm">4 Information requirements</A><BR/>
        <A HREF="mim{$FILE_EXT}#mim">5 Module interpreted model</A><BR/>
        <A HREF="annexes{$FILE_EXT}#annexa">A AM MIM short names</A><BR/>
        <A HREF="annexes{$FILE_EXT}#annexb">B Information requirements object
        registration</A><BR/>
        <A HREF="annexes{$FILE_EXT}#annexc">C ARM EXPRESS-G</A><BR/>
        <A HREF="annexes{$FILE_EXT}#annexd">D MIM EXPRESS-G</A>
      </TD>
      <TD valign="TOP">
        <A HREF="annexes{$FILE_EXT}#annexe">E AM ARM and MIM EXPRESS listings</A><BR/>
        <A HREF="annexes{$FILE_EXT}#annexf">F Application module implementation and
        usage guide</A><BR/>
        <A HREF="annexes{$FILE_EXT}#biblio">Bibliography</A>
      </TD>
    </TR>
  </TABLE>
</xsl:template>

<!--
     Output the Table of contents banner for a module where all clauses are 
     displayed on a single page
-->
<xsl:template match="module" mode="TOCsinglePage">
  <xsl:apply-templates select="." mode="TOCbannertitle"/>  
  <TABLE border="1" cellspacing="1" width="100%">
    <TR>
      <TD valign="TOP">
        <A HREF="module{$FILE_EXT}#cover_page">Cover page</A><BR/>
        <A HREF="module{$FILE_EXT}#foreword">Foreword</A><BR/>
        <A HREF="module{$FILE_EXT}#intro">Introduction</A><BR/>
        <A HREF="module{$FILE_EXT}#scope">1 Scope</A><BR/>
        <A HREF="module{$FILE_EXT}#nref">2 Normative references</A><BR/>
        <A HREF="module{$FILE_EXT}#defns">3 Definitions and abbreviations</A>
      </TD>
      <TD valign="TOP">
        <A HREF="module{$FILE_EXT}#arm">4 Information requirements</A><BR/>
        <A HREF="module{$FILE_EXT}#mim">5 Module interpreted model</A><BR/>
        <A HREF="module{$FILE_EXT}#annexa">A AM MIM short names</A><BR/>
        <A HREF="module{$FILE_EXT}#annexb">B Information requirements object
        registration</A><BR/>
        <A HREF="module{$FILE_EXT}#annexc">C ARM EXPRESS-G</A><BR/>
        <A HREF="module{$FILE_EXT}#annexd">D MIM EXPRESS-G</A>
      </TD>
      <TD valign="TOP">
        <A HREF="module{$FILE_EXT}#annexe">E AM ARM and MIM EXPRESS listings</A><BR/>
        <A HREF="module{$FILE_EXT}#annexf">F Application module implementation and
        usage guide</A><BR/>
        <A HREF="module{$FILE_EXT}#biblio">Bibliography</A>
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
    <xsl:value-of select="concat('NOTE ',position())"/>
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

</xsl:stylesheet>
