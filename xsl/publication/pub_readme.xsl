<?xml version="1.0" encoding="utf-8"?>
<!--
$ Id: build.xsl,v 1.9 2003/02/26 02:12:17 thendrix Exp $
   Author:  Rob Bodington, Eurostep Limited
   Owner:   Developed by Eurostep Limited http://www.eurostep.com and supplied to NIST under contract.
   Purpose: To output the readme file for a published module.
-->

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exslt="http://exslt.org/common"
  exclude-result-prefixes="exslt"
  version="1.0">

  <xsl:import href="../ap_doc/common.xsl"/>
  <xsl:import href="../res_doc/common.xsl"/>

  <xsl:output method="text" encoding="us-ascii"/>


  <xsl:template match="module">
    <xsl:variable name="module_full_no">
      <xsl:call-template name="get_module_pageheader">
        <xsl:with-param name="module" select="."/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="standard_type">
      <xsl:choose>
        <xsl:when test="@status='TS'">
          <xsl:value-of select="'Technical Specification'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'ISO standard'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
ISO/TS 10303-<xsl:value-of select="@part"/>
TC 184/SC 4

To access the <xsl:value-of select="concat($standard_type,' ',$module_full_no)"/>
open the file "iso10303_<xsl:value-of select="@part"/>.htm".

The folders 
  "data"
  "images"
contain the various components of the main document.

To expand the document, unzip the file into an empty directory.
NOTE - if you already purchased other Application modules, then unzip the
file into the same directory as the other modules.
If asked when unzipping the file, you should overwrite any file in the images directory.
      <xsl:variable name="prefix" select="concat('part',@part,@status,'_wg',@wg,'n')"/>
      <xsl:variable name="arm_exp" select="concat('express/',$prefix,@wg.number.arm,'arm.exp')"/>
The ARM EXPRESS listing for part <xsl:value-of select="@part"/> is contained in file: <xsl:value-of select="$arm_exp"/>
      <xsl:if test="./arm_lf">        
        <xsl:variable name="armlf_exp" select="concat('express/',$prefix,@wg.number.arm_lf,'arm_lf.exp')"/>
The ARM long form EXPRESS listing for part <xsl:value-of select="@part"/> is contained in file: <xsl:value-of select="$armlf_exp"/>
      </xsl:if>
      <xsl:variable name="mim_exp" select="concat('express/',$prefix,@wg.number.mim,'mim.exp')"/>
The MIM EXPRESS listing for part <xsl:value-of select="@part"/> is contained in file: <xsl:value-of select="$mim_exp"/>
      <xsl:if test="./mim_lf">        
        <xsl:variable name="mimlf_exp" select="concat('express/',$prefix,@wg.number.mim_lf,'mim_lf.exp')"/>
The MIM long form EXPRESS listing for part <xsl:value-of select="@part"/> is contained in file: <xsl:value-of select="$mimlf_exp"/>
      </xsl:if>

The abstract for part <xsl:value-of select="@part"/> is contained in file: <xsl:value-of select="concat('abstracts/module_abstract_',@part,'.htm')"/>

NOTE
The HTML will have a number of broken links as this part is dependent on a
number of other ISO 10303 parts which are listed in the normative
references in Clause 2. 

  </xsl:template>


  <xsl:template match="application_protocol">
    <xsl:variable name="ap_full_no">
      <xsl:call-template name="get_protocol_stdnumber">
        <xsl:with-param name="application_protocol" select="."/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="standard_type">
      <xsl:choose>
        <xsl:when test="@status='TS'">
          <xsl:value-of select="'Technical Specification'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'ISO standard'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
ISO/TS 10303-<xsl:value-of select="@part"/>
TC 184/SC 4

To access the <xsl:value-of select="concat($standard_type,' ',$ap_full_no)"/>
open the file "iso10303_<xsl:value-of select="@part"/>.htm".

The folders 
  "data"
  "images"
contains the various components of the main document.

To expand the document, unzip the file into an empty directory.
NOTE - if you already purchased other Application modules, then unzip the
file into the same directory as the other modules.
If asked when unzipping the file, you should overwrite any file in the images directory.
      <xsl:variable name="prefix" select="concat('part',@part,@status,'_wg',@wg,'n')"/>
      <xsl:variable name="arm_exp" select="concat('express/',$prefix,@wg.number.arm,'arm.exp')"/>
The ARM EXPRESS listing for part <xsl:value-of select="@part"/> is contained in file: <xsl:value-of select="$arm_exp"/>
      <xsl:if test="./arm_lf">        
        <xsl:variable name="armlf_exp" select="concat('express/',$prefix,@wg.number.arm_lf,'arm_lf.exp')"/>
The ARM long form EXPRESS listing for part <xsl:value-of select="@part"/> is contained in file: <xsl:value-of select="$armlf_exp"/>
      </xsl:if>
      <xsl:variable name="mim_exp" select="concat('express/',$prefix,@wg.number.mim,'mim.exp')"/>
The MIM EXPRESS listing for part <xsl:value-of select="@part"/> is contained in file: <xsl:value-of select="$mim_exp"/>
      <xsl:if test="./mim_lf">        
        <xsl:variable name="mimlf_exp" select="concat('express/',$prefix,@wg.number.mim_lf,'mim_lf.exp')"/>
The MIM long form EXPRESS listing for part <xsl:value-of select="@part"/> is contained in file: <xsl:value-of select="$mimlf_exp"/>
      </xsl:if>

The abstract for part <xsl:value-of select="@part"/> is contained in file: <xsl:value-of select="concat('abstracts/module_abstract_',@part,'.htm')"/>

  </xsl:template>

  <xsl:template match="resource">
    <xsl:variable name="res_full_no">
      <xsl:call-template name="get_resdoc_stdnumber">
        <xsl:with-param name="resdoc" select="."/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="standard_type">
      <xsl:choose>
        <xsl:when test="@status='TS'">
          <xsl:value-of select="'Technical Specification'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'ISO standard'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
ISO/TS 10303-<xsl:value-of select="@part"/>
TC 184/SC 4

To access the <xsl:value-of select="concat($standard_type,' ',$res_full_no)"/>
open the file "iso10303_<xsl:value-of select="@part"/>.htm".

The folders 
  "data"
  "images"
contains the various components of the main document.

To expand the document, unzip the file into an empty directory.
NOTE - if you already purchased other parts, then unzip the
file into the same directory as the other modules.
If asked when unzipping the file, you should overwrite any file in the images directory.
      <xsl:variable name="prefix" select="concat('part',@part,@status,'_wg',@wg,'n')"/>
      <xsl:variable name="arm_exp" select="concat('express/',$prefix,@wg.number.arm,'arm.exp')"/>
The ARM EXPRESS listing for part <xsl:value-of select="@part"/> is contained in file: <xsl:value-of select="$arm_exp"/>
      <xsl:if test="./arm_lf">        
        <xsl:variable name="armlf_exp" select="concat('express/',$prefix,@wg.number.arm_lf,'arm_lf.exp')"/>
The ARM long form EXPRESS listing for part <xsl:value-of select="@part"/> is contained in file: <xsl:value-of select="$armlf_exp"/>
      </xsl:if>
      <xsl:variable name="mim_exp" select="concat('express/',$prefix,@wg.number.mim,'mim.exp')"/>
The MIM EXPRESS listing for part <xsl:value-of select="@part"/> is contained in file: <xsl:value-of select="$mim_exp"/>
      <xsl:if test="./mim_lf">        
        <xsl:variable name="mimlf_exp" select="concat('express/',$prefix,@wg.number.mim_lf,'mim_lf.exp')"/>
The MIM long form EXPRESS listing for part <xsl:value-of select="@part"/> is contained in file: <xsl:value-of select="$mimlf_exp"/>
      </xsl:if>

The abstract for part <xsl:value-of select="@part"/> is contained in file: <xsl:value-of select="concat('abstracts/module_abstract_',@part,'.htm')"/>
  </xsl:template>

</xsl:stylesheet>