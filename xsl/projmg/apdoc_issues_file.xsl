<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="../document_xsl.xsl" ?>
<!--
$Id: apdoc_issues_file.xsl,v 1.1 2003/06/02 12:36:48 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: Display the issues raised against an AP document.     
-->


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../ap_doc/application_protocol.xsl"/>
  <xsl:import href="../ap_doc/application_protocol_toc.xsl"/>

  <xsl:output method="html"/>
  
  <xsl:template match="/">
    <xsl:apply-templates select="/issues"/>
  </xsl:template>
  
  <xsl:template match="issues">
    <xsl:variable name="apdoc_name" select="@ap_doc"/>
    <xsl:variable name="open_issues"
      select="count(//issue[@status!='closed'])"/>
    <xsl:if test="$open_issues>0">
      <xsl:call-template name="error_message">
        <xsl:with-param name="message">
          <xsl:value-of select="concat('Warning Issues1: ','AP doc ', $apdoc_name, ' has ',$open_issues , ' open issues' )"/>
        </xsl:with-param>
        <xsl:with-param name="inline" select="'no'"/>
      </xsl:call-template>      
    </xsl:if>

    <xsl:variable name="apdoc_file"
      select="concat('../../data/application_protocols/',@ap_doc,'/application_protocol.xml')"/>
    <xsl:variable name="in_repo"
      select="document('../../repository_index.xml')/repository_index/application_protocols/application_protocol[@name=$apdoc_name]"/>

    <html>
      <title>
        <xsl:value-of select="concat(/issues/@ap_doc,' - issues')"/>
      </title>
      
      <body>
        <!-- Output a Table of contents -->
        <xsl:choose>
          <!-- the module is present in the STEP mod repository -->
          <xsl:when test="$in_repo">
            <xsl:variable name="apdoc_node"
              select="document($apdoc_file)/application_protocol[@name=$apdoc_name]"/>
            <xsl:apply-templates select="$apdoc_node" mode="TOCmultiplePage"/> 
          </xsl:when>
          <xsl:otherwise>
            <p>
              <xsl:call-template name="error_message">
                <xsl:with-param name="warning_gif"
                  select="'../../../images/warning.gif'"/>
                
                <xsl:with-param name="message">
                  <xsl:value-of select="concat('Error B1: Application_protocol ',
                                        $apdoc_name,
                                        ' does not exist in stepmod/repository_index.xml')"/>
                </xsl:with-param>
              </xsl:call-template>
            </p>
          </xsl:otherwise>
        </xsl:choose>
        
        <h3>
          Issues raised against:
          <xsl:value-of select="@ap_doc"/>
        </h3>
        
        <xsl:if test="issue[@type='general']">
          &#160;<a href="#general">general</a>&#160;|
        </xsl:if>
  
      <xsl:if test="issue[@type='keywords']">
        &#160;<a href="#keywords">keywords</a>&#160;|
      </xsl:if>
      <xsl:if test="issue[@type='contacts']">
        &#160;<a href="#contacts">contacts</a>&#160;|
      </xsl:if>
      <xsl:if test="issue[@type='purpose']">
        &#160;<a href="#purpose">purpose</a>&#160;|
      </xsl:if>  
      <xsl:if test="issue[@type='inscope']">
        &#160;<a href="#inscope">inscope</a>&#160;|
      </xsl:if>
      <xsl:if test="issue[@type='outscope']">
        &#160;<a href="#outscope">outscope</a>&#160;|
      </xsl:if>
      <xsl:if test="issue[@type='normrefs']">
        &#160;<a href="#normrefs">normrefs</a>&#160;|
      </xsl:if>
      <xsl:if test="issue[@type='definition']">
        &#160;<a href="#definition">definition</a>&#160;|
      </xsl:if>
      <xsl:if test="issue[@type='abbreviations']">
        &#160;<a href="#abbreviations">abbreviations</a>&#160;|
      </xsl:if>
      <xsl:if test="issue[@type='arm']">
        &#160;<a href="#arm">arm</a>&#160;|
      </xsl:if>
      <xsl:if test="issue[@type='armexpg']">
        &#160;<a href="#armexpg">armexpg</a>&#160;|
      </xsl:if>
      <xsl:if test="issue[@type='arm_lf']">
        &#160;<a href="#arm_lf">arm_lf</a>&#160;|
      </xsl:if>
      <xsl:if test="issue[@type='armexpg_lf']">
        &#160;<a href="#armexpg_lf">armexpg_lf</a>&#160;|
     </xsl:if>
     <xsl:if test="issue[@type='mapping_table']">
        &#160;<a href="#mapping_table">mapping_table</a>&#160;|
     </xsl:if>
     <xsl:if test="issue[@type='mim']">
       &#160;<a href="#mim ">mim</a>&#160;|
     </xsl:if>
     <xsl:if test="issue[@type='mimexpg']">
        &#160;<a href="#mimexpg">mimexpg</a>&#160;|
     </xsl:if>
     <xsl:if test="issue[@type='mim_lf']">
        &#160;<a href="#mim_lf">mim_lf</a>&#160;|
     </xsl:if>
     <xsl:if test="issue[@type='mimexpg_lf']">
       &#160;<a href="#mimexpg_lf">mimexpg_lf</a>&#160;|
     </xsl:if>
     <xsl:if test="issue[@type='usage_guide']">
        &#160;<a href="#usage_guide">usage_guide</a>&#160;|
     </xsl:if>
     <xsl:if test="issue[@type='bibliography']">
        &#160;<a href="#bibliography">bibliography</a>&#160;|
     </xsl:if>
     <xsl:if test="(issue[@type!='general']) and (issue[@type!='keywords'])
                   and (issue[@type!='contacts'])
                   and (issue[@type!='purpose'])
                   and (issue[@type!='inscope'])
                   and (issue[@type!='outscope'])
                   and (issue[@type!='normrefs'])
                   and (issue[@type!='definition'])
                   and (issue[@type!='abbreviations'])
                   and (issue[@type!='arm'])
                   and (issue[@type!='armexpg'])
                   and (issue[@type!='arm_lf'])
                   and (issue[@type!='armexpg_lf'])
                   and (issue[@type!='mapping_table'])
                   and (issue[@type!='mim'])
                   and (issue[@type!='mimexpg'])
                   and (issue[@type!='mim_lf'])
                   and (issue[@type!='mimexpg_lf'])
                   and (issue[@type!='usage_guide'])
                   and (issue[@type!='bibliography'])">       
     &#160;<a href="#other">Other</a>
   </xsl:if>

        <!-- Order the issues -->
        <xsl:apply-templates select="issue[@type='general']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='keywords']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='contacts']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='purpose']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='inscope']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='outscope']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='normrefs']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='definition']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='abbreviations']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='arm']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='armexpg']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='arm_lf']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='armexpg_lf']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='mapping_table']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='mim']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='mimexpg']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='mim_lf']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='mimexpg_lf']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='usage_guide']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='bibliography']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <!-- deal with unknown type -->
        <xsl:apply-templates select="issue[(@type!='general')
                                     and (@type!='keywords')
                                     and (@type!='contacts')
                                     and (@type!='purpose')
                                     and (@type!='inscope')
                                     and (@type!='outscope')
                                     and (@type!='normrefs')
                                     and (@type!='definition')
                                     and (@type!='abbreviations')
                                     and (@type!='arm')
                                     and (@type!='armexpg')
                                     and (@type!='arm_lf')
                                     and (@type!='armexpg_lf')
                                     and (@type!='mapping_table')
                                     and (@type!='mim')
                                     and (@type!='mimexpg')
                                     and (@type!='mim_lf')
                                     and (@type!='mimexpg_lf')
                                     and (@type!='usage_guide')
                                     and (@type!='bibliography')]">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>
      </body>
    </html>
  </xsl:template>



  <xsl:template match="issue">
    <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>
    <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

    <xsl:if test="position()=1">
      <xsl:variable name="aname">
        <xsl:choose>
          <xsl:when test="(@type!='general') and (@type!='keywords')
                          and (@type!='contacts')
                          and (@type!='purpose')
                          and (@type!='inscope')
                          and (@type!='outscope')
                          and (@type!='normrefs')
                          and (@type!='definition')
                          and (@type!='abbreviations')
                          and (@type!='arm')
                          and (@type!='armexpg')
                          and (@type!='arm_lf')
                          and (@type!='armexpg_lf')
                          and (@type!='mapping_table')
                          and (@type!='mim')
                          and (@type!='mimexpg')
                          and (@type!='mim_lf')
                          and (@type!='mimexpg_lf')
                          and (@type!='usage_guide')
                          and (@type!='bibliography')">
            <xsl:value-of select="'other'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@type"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <span style="background-color: #FFFF99">
        <h3>
          <a name="{$aname}">
            <b>
              <xsl:value-of select="translate($aname,$LOWER,$UPPER)"/>
            </b>
          </a>
          issues
        </h3>
      </span>
    </xsl:if>

    <xsl:variable name="issue_target" 
      select="translate(
              concat(string(@id), string(@by)),
              '&#xA;', '' ) "/>
    
    <xsl:variable name="status" select="@status"/>  
    <!-- put in place to use CSS -->
    <p class="{$status}">      
    <hr size="3" />
      <!-- replace with CSS -->
      <xsl:choose>
        <xsl:when test="not($status='closed')">
          <img alt="Open issue" 
            border="0"
            align="middle"
            src="../../../../images/issues.gif"/>
        </xsl:when>
        <xsl:otherwise>
          <img alt="Closed issue" 
            border="0"
            align="middle"
            src="../../../../images/closed.gif"/>          
        </xsl:otherwise>
      </xsl:choose>
      <i>
        <b>
          Issue:
          <A NAME="{$issue_target}"> 
          <xsl:value-of select="concat(
                                string(@id), 
                                ' by ', string(@by),
                                ' (', string(@date), 
                                ')')" /> 
          </A>
        </b>
        <xsl:value-of select="concat(' ',@category,' issue ')"/>
        <xsl:call-template name="resolve_linkend"/>
      </i>
    <br/>
<!-- commented out as tc184-sc4.rg no longer operational
    <i>
      <xsl:if test="@seds='yes'">
        Registered in the 
        <a href="http://www.tc184-sc4.org/private/Projects/maindisp.cfm">
          SC4 database
        </a>
        as SEDS: 
        <xsl:value-of select="@id"/>
      </xsl:if>
    </i> 
    <br/>
-->
    </p>
    <xsl:apply-templates />
  </xsl:template>


  <xsl:template name="resolve_linkend">
    <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>
    <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
    <xsl:choose>
      <xsl:when test="@type='keywords'">
        <b> keywords</b> issue<br/>
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
          (module.xml/module/purpose).
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

  <xsl:template match="comment">
  <blockquote>
    <b>Comment: </b>
    <i><xsl:value-of select="string(@status)" /></i>
    (<xsl:value-of select="concat(string(@by),' ', string(@date))" />
    <b>)</b><br/>
    <xsl:apply-templates />
  </blockquote>
  </xsl:template>

</xsl:stylesheet>
