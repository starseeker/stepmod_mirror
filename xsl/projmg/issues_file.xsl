<?xml version="1.0" encoding="utf-8"?>
<!--
     $Id: issues_file.xsl,v 1.1 2002/08/14 12:44:36 robbod Exp $

  Author: Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep and supplied to NIST under contract.
  Purpose: 
     Used to display the issues raised against the a module
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <!-- need both for module TOC -->
  <xsl:import href="../sect_4_express.xsl"/>
  <xsl:import href="../module_toc.xsl"/>

  <xsl:output method="html"/>

  <xsl:template match="issues">
    <html>
      <title>
        <xsl:value-of select="concat(/issues/@module,' - issues')"/>
      </title>

      <body>

        <!-- Output a Table of contents -->
        <xsl:variable name="module_name" select="@module"/>
        <xsl:variable name="module_file"
          select="concat('../../data/modules/',@module,'/module.xml')"/>
        <xsl:variable name="in_repo"
          select="document('../../repository_index.xml')/repository_index/modules/module[@name=$module_name]"/>
        <xsl:choose>
          <!-- the module is present in the STEP mod repository -->
          <xsl:when test="$in_repo">
            <xsl:variable name="module_node"
              select="document($module_file)/module[@name=$module_name]"/>
            <xsl:apply-templates select="$module_node"
              mode="TOCmultiplePage"/> 

          </xsl:when>
          <xsl:otherwise>
            <p>
              <xsl:call-template name="error_message">
                <xsl:with-param name="warning_gif"
                  select="'../../../images/warning.gif'"/>
                
                <xsl:with-param name="message">
                  <xsl:value-of select="concat('Error B1: Module ',
                                        $module_name,
                                        ' does not exist in stepmod/repository_index.xml')"/>
                </xsl:with-param>
              </xsl:call-template>
            </p>
          </xsl:otherwise>
        </xsl:choose>
        
        <h3>
          Issues raised against:
          <xsl:value-of select="@module"/>
        </h3>
        <xsl:apply-templates select="issue"/>
      </body>
    </html>
  </xsl:template>


  <xsl:template match="issue">
    <xsl:variable name="issue_target" 
      select="translate(
              concat(string(@id), string(@by)),
              '&#xA;', '' ) "/>
    
    <xsl:variable name="status" select="@status"/>    
    <p class="{$status}">
    <hr size="3" />      
      <i>
        <b>
          
          issue:
          <A NAME="{$issue_target}"> 
          <xsl:value-of select="concat(
                                string(@id), 
                                ' by ', string(@by),
                                ' (', string(@date), 
                                ')')" /> 
          </A>
        </b>
        <xsl:call-template name="resolve_linkend"/>
      </i>
    <br/>
    <xsl:apply-templates />
    </p>
  </xsl:template>


  <xsl:template name="resolve_linkend">
    <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>
    <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
    <xsl:choose>
      <xsl:when test="@type='keywords'">
        against keywords
        <a href="../sys/cover{$FILE_EXT}#keywords">
          (module.xml/module/keywords).
        </a>
      </xsl:when>
      <xsl:when test="@type='contacts'">
        against contacts.
        <a href="../sys/cover{$FILE_EXT}#keywords">
          (module.xml/module/contacts).
        </a>
      </xsl:when>

      <xsl:when test="@type='purpose'">
        against purpose.
        <a href="../sys/introduction{$FILE_EXT}#introduction">
          (module.xml/module/purpise).
        </a>
      </xsl:when>

      <xsl:when test="@type='inscope'">
        against inscope.
        <a href="../sys/scope{$FILE_EXT}#scope">
          (module.xml/module/inscope).
        </a>
      </xsl:when>

      <xsl:when test="@type='outscope'">
        against outscope.
        <a href="../sys/scope{$FILE_EXT}#outscope">
          (module.xml/module/outscope).
        </a>
      </xsl:when>

      <xsl:when test="@type='normrefs'">
        against normrefs.
        <a href="../sys/2_refs{$FILE_EXT}">
          (module.xml/module/normrefs).
        </a>
      </xsl:when>

      <xsl:when test="@type='definition'">
        against definition.
        <a href="../sys/3_defs{$FILE_EXT}#defns">
          (module.xml/module/definition).
        </a>
      </xsl:when>

      <xsl:when test="@type='abbreviations'">
        against abbreviations.
        <a href="../sys/3_defs{$FILE_EXT}#abbrv">
          (module.xml/module/abbreviations).
        </a>
      </xsl:when>

      <xsl:when test="@type='arm'">
        <xsl:variable name="link" select="translate(@linkend,$UPPER,$LOWER)"/>
        against ARM.
        <a href="../sys/4_info_reqs{$FILE_EXT}#{$link}">
          <xsl:value-of select="concat('arm.xml/',@linkend)"/>
        </a>
      </xsl:when>

      <xsl:when test="@type='armexpg'">
        against ARM EXPRESS-G.
        <xsl:variable name="link" select="@linkend"/>
        <a href="../{$link}">
          <xsl:value-of select="@linkend"/>
        </a>
      </xsl:when>

      <xsl:when test="@type='arm_lf'">
        <xsl:variable name="link" select="translate(@linkend,$UPPER,$LOWER)"/>
        against ARM long form.
        <a href="../sys/4_info_reqs{$FILE_EXT}#{$link}">
          <xsl:value-of select="concat('arm_lf.xml/',@linkend)"/>
        </a>
      </xsl:when>

      <xsl:when test="@type='armexpg_lf'">
        against ARM Long form EXPRESS-G.
        <xsl:variable name="link" select="@linkend"/>
        <a href="../{$link}">
          <xsl:value-of select="@linkend"/>
        </a>
      </xsl:when>

      <xsl:when test="@type='mapping_table'">
        against mapping.

        <xsl:variable name="link" 
          select="translate(normalize-space(translate(@linkend,$UPPER,$LOWER)),
                  ' :=','')"/>

        <a href="../sys/5_mapping{$FILE_EXT}#{$link}">
          <xsl:choose>
            <xsl:when test="contains($link,'aaattribute')">
              <xsl:value-of 
                select="substring-before(substring-after($link,'aeentity'),'aaattribute')"/> to
              <xsl:value-of 
                select="substring-before(substring-after($link,'aaattribute'),'assertion_to')"/> (as
              <xsl:value-of 
                select="substring-after($link,'assertion_to')"/>)
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of 
                select="substring-after($link,'aeentity')"/> 
            </xsl:otherwise>
          </xsl:choose>
        </a>
      </xsl:when>

      <xsl:when test="@type='mim'">
        <xsl:variable name="link" select="translate(@linkend,$UPPER,$LOWER)"/>
        against MIM.
        <a href="../sys/5_mim{$FILE_EXT}#{$link}">
          <xsl:value-of select="concat('mim.xml/',@linkend)"/>
        </a>
      </xsl:when>

      <xsl:when test="@type='mimexpg'">
        against MIM EXPRESS-G.
        <xsl:variable name="link" select="@linkend"/>
        <a href="../{$link}">
          <xsl:value-of select="@linkend"/>
        </a>
      </xsl:when>

      <xsl:when test="@type='mim_lf'">
        <xsl:variable name="link" select="translate(@linkend,$UPPER,$LOWER)"/>
        against MIM long form.
        <a href="../sys/4_info_reqs{$FILE_EXT}#{$link}">
          <xsl:value-of select="concat('mim_lf.xml/',@linkend)"/>
        </a>
      </xsl:when>

      <xsl:when test="@type='mimexpg_lf'">
        against MIM Long form EXPRESS-G.
        <xsl:variable name="link" select="@linkend"/>
        <a href="../{$link}">
          <xsl:value-of select="@linkend"/>
        </a>
      </xsl:when>

      <xsl:when test="@type='usage_guide'">
        against usage guide.
        <a href="../sys/f_guide{$FILE_EXT}">
          (module.xml/module/usage_guide).
        </a>
      </xsl:when>

      <xsl:when test="@type='bibliography'">
        against bibliography
        <a href="../sys/biblio{$FILE_EXT}">
          (module.xml/module/bibliography).
        </a>
      </xsl:when>

      <xsl:when test="@type='general'">        
        General issue.
      </xsl:when>

      <xsl:otherwise>
        Issue type not given.    
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="description">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="status">
  <blockquote>
    <b>Status: </b>
    <i><xsl:value-of select="string(@status)" /></i>
    (<xsl:value-of select="concat(string(@by),' ', string(@date))" />
    <b>)</b><br/>
    <xsl:apply-templates />
  </blockquote>
  </xsl:template>

</xsl:stylesheet>