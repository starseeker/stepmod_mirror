<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: common.xsl,v 1.2 2001/10/05 15:35:00 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     Templates that are common to most other stylesheets
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">




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
        <A HREF="cover{$FILE_EXT}">Cover page</A><BR/>
        <A HREF="foreword{$FILE_EXT}#foreword">Foreword</A><BR/>
        <A HREF="introduction{$FILE_EXT}#intro">Introduction</A><BR/>
        <A HREF="1_scope{$FILE_EXT}#scope">1 Scope</A><BR/>
        <A HREF="2_refs{$FILE_EXT}#nref">2 Normative references</A><BR/>
        <A HREF="3_defs{$FILE_EXT}#defns">3 Definitions and abbreviations</A>
      </TD>
      <TD valign="TOP">
        <A HREF="4_info_reqs{$FILE_EXT}#arm">4 Information requirements</A><BR/>
        <A HREF="5_mim{$FILE_EXT}#mim">5 Module interpreted model</A><BR/>
        <A HREF="a_short_names{$FILE_EXT}#annexa">A AM MIM short names</A><BR/>
        <A HREF="b_obj_reg{$FILE_EXT}#annexb">B Information requirements object
        registration</A><BR/>
        <A HREF="c_arm_expg{$FILE_EXT}#annexc">C ARM EXPRESS-G</A><BR/>
        <A HREF="d_mim_expg{$FILE_EXT}#annexd">D MIM EXPRESS-G</A>
      </TD>
      <TD valign="TOP">
        <A HREF="e_exp{$FILE_EXT}#annexe">E AM ARM and MIM EXPRESS listings</A><BR/>
        <A HREF="f_guide{$FILE_EXT}#annexf">F Application module implementation and
        usage guide</A><BR/>
        <A HREF="biblio{$FILE_EXT}#biblio">Bibliography</A>
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


</xsl:stylesheet>
