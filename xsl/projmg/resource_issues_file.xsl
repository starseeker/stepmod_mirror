<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="../document_xsl.xsl" ?>
<!--
     $Id: resource_issues_file.xsl,v 1.9 2005/02/17 23:55:39 thendrix Exp $

  Author: Tom Hendrix
  Owner:  
  Purpose: 
     Used to display the issues raised against a resource document
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <!-- need both for resdoc TOC -->
  <xsl:import href="../res_doc/sect_4_express.xsl"/>
  <xsl:import href="../res_doc/res_toc.xsl"/>

  <xsl:output 
    method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    indent="yes"
    />


  <xsl:template match="issues">
    <html>
      <head>
        <title>
          <xsl:value-of select="concat(/issues/@resource,' - issues')"/>
        </title>
      </head>
      <body>

        <!-- Output a Table of contents -->
        <xsl:variable name="resdoc_name" select="@resource"/>
        <xsl:variable name="resdoc_file"
          select="concat('../../data/resource_docs/',@resource,'/resource.xml')"/>        
        <xsl:variable name="index_file" select="'../../repository_index.xml'" />
        
        <xsl:variable name="in_repo"
          select="document($index_file)/repository_index/resource_docs/resource_doc[@name=$resdoc_name]"/>
      
        <xsl:choose>
          <!-- the resource doc is present in the STEP mod repository -->
          <xsl:when test="$in_repo">
            <xsl:variable name="resdoc_node"
              select="document($resdoc_file)/resource[@name=$resdoc_name]"/>
            <xsl:apply-templates select="$resdoc_node"
              mode="TOCmultiplePage"/> 
          </xsl:when>
          <xsl:otherwise>
            <p>
              <xsl:call-template name="error_message">
                <xsl:with-param name="warning_gif"
                  select="'../../../images/warning.gif'"/>
                
                <xsl:with-param name="message">
                  <xsl:value-of select="concat('Error B1: Resource document ',
                                        $resdoc_name,
                                        ' does not exist in ', $index_file)"/>
                </xsl:with-param>
              </xsl:call-template>
            </p>
          </xsl:otherwise>
        </xsl:choose>
        
        <h3>
          Issues raised against:
          <xsl:value-of select="@resource"/>
        </h3>

        <xsl:if test="issue[@type='general']">
          &#160;<a href="#general">general</a>&#160;|
        </xsl:if>
  
        <xsl:if test="issue[@type='cover']">
        &#160;<a href="#cover">cover</a>&#160;|
      </xsl:if>

        <xsl:if test="issue[@type='keywords']">
        &#160;<a href="#keywords">keywords</a>&#160;|
      </xsl:if>

      <xsl:if test="issue[@type='contacts']">
        &#160;<a href="#contacts">contacts</a>&#160;|
      </xsl:if>
      <xsl:if test="issue[@type='intro']">
        &#160;<a href="#intro">introduction</a>&#160;|
      </xsl:if>
      <xsl:if test="issue[@type='contents']">
        &#160;<a href="#contents">contents</a>&#160;|
      </xsl:if>
        <xsl:if test="issue[@type='abstract']">
        &#160;<a href="#abstract">abstract</a>&#160;|
      </xsl:if>
      <xsl:if test="issue[@type='foreword']">
        &#160;<a href="#foreword">foreword</a>&#160;|
      </xsl:if>
      <xsl:if test="issue[@type='purpose']">
        &#160;<a href="#purpose">purpose</a>&#160;|
      </xsl:if>  
      <xsl:if test="issue[@type='schema_diag']">
        &#160;<a href="#schema_diag">schema_diag</a>&#160;|
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
      <xsl:if test="issue[@type='index']">
        &#160;<a href="#index">index</a>&#160;|
      </xsl:if>
      <xsl:if test="issue[@type='schema_intro']">
        &#160;<a href="#schema_intro">schema_intro</a>&#160;|
      </xsl:if>
      <xsl:if test="issue[@type='schema_clause']">
        &#160;<a href="#schema_intro">schema_clause</a>&#160;|
      </xsl:if>
      <xsl:if test="issue[@type='fund_cons']">
        &#160;<a href="#fund_cons">fund_cons</a>&#160;|
      </xsl:if>
      <xsl:if test="issue[@type='express']">
        &#160;<a href="#express">express</a>&#160;|
      </xsl:if>
      <xsl:if test="issue[@type='express_doc']">
        &#160;<a href="#express_doc">express doc</a>&#160;|
      </xsl:if>
      <xsl:if test="issue[@type='shortnames']">
        &#160;<a href="#shortnames">shortnames</a>&#160;|
      </xsl:if>
      <xsl:if test="issue[@type='tech_discussion']">
        &#160;<a href="#tech_discussion">tech_discussion</a>&#160;|
      </xsl:if>
      <xsl:if test="issue[@type='examples']">
        &#160;<a href="#examples">examples</a>&#160;|
      </xsl:if>
      <xsl:if test="issue[@type='add_scope']">
        &#160;<a href="#add_scope">abbreviations</a>&#160;|
      </xsl:if>


     <xsl:if test="issue[@type='bibliography']">
        &#160;<a href="#bibliography">bibliography</a>&#160;|
     </xsl:if>
     <xsl:if test="(issue[@type!='general']) 
                   and (issue[@type!='cover'])
                   and (issue[@type!='abstract'])
                   and (issue[@type!='keywords'])
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
     &#160;<a href="#other">other</a>
   </xsl:if>

        <!-- Order the issues -->
        <xsl:apply-templates select="issue[@type='general']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='cover']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='keywords']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='abstract']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>


        <xsl:apply-templates select="issue[@type='contacts']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='purpose']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='schema_diag']">
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

        <xsl:apply-templates select="issue[@type='intro']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='foreword']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='contents']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='index']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='schema_clause']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>


        <xsl:apply-templates select="issue[@type='schema_intro']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='fund_cons']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='express']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='express_doc']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>


        <xsl:apply-templates select="issue[@type='expg']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='shortnames']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='tech_discussion']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='examples']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='add_scope']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='bibliography']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="issue[@type='bibliography']">
          <xsl:sort select="./@status" order="descending"/>
        </xsl:apply-templates>

        <!-- deal with unknown type -->
        <xsl:apply-templates select="issue[(@type!='general')
                          and (@type!='cover')
                          and (@type!='keywords')
                          and (@type!='abstract')
                          and (@type!='contacts')
                          and (@type!='purpose')
                          and (@type!='schema_diag')
                          and (@type!='inscope')
                          and (@type!='outscope')
                          and (@type!='normrefs')
                          and (@type!='definition')
                          and (@type!='abbreviations')
                          and (@type!='intro')
                          and (@type!='foreword')
                          and (@type!='contents')
                          and (@type!='index')
                          and (@type!='schema_clause')
                          and (@type!='schema_intro')
                          and (@type!='fund_cons')
                          and (@type!='express')
                          and (@type!='express_doc')
                          and (@type!='expg')
                          and (@type!='shortnames')
                          and (@type!='tech_discussion')
                          and (@type!='examples')
                          and (@type!='add_scope')
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
          <xsl:when test="(@type!='general') 
                          and (@type!='cover')
                          and (@type!='keywords')
                          and (@type!='abstract')
                          and (@type!='contacts')
                          and (@type!='purpose')
                          and (@type!='schema_diag')
                          and (@type!='inscope')
                          and (@type!='outscope')
                          and (@type!='normrefs')
                          and (@type!='definition')
                          and (@type!='abbreviations')
                          and (@type!='intro')
                          and (@type!='foreword')
                          and (@type!='contents')
                          and (@type!='index')
                          and (@type!='schema_clause')
                          and (@type!='schema_intro')
                          and (@type!='fund_cons')
                          and (@type!='express_doc')
                          and (@type!='express')
                          and (@type!='expg')
                          and (@type!='shortnames')
                          and (@type!='tech_discussion')
                          and (@type!='examples')
                          and (@type!='add_scope')
                          and (@type!='bibliography')">
            <xsl:value-of select="'other'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@type"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
        <h3>
      <span style="background-color: #FFFF99">

          <a name="{$aname}">
            <b>
              <xsl:value-of select="translate($aname,$LOWER,$UPPER)"/>
            </b>
          </a>
          issues
      </span>
        </h3>

    </xsl:if>

    <xsl:variable name="issue_target" 
      select="translate(
              concat(string(@id), string(@by)),
              '&#xA;', '' ) "/>
    
    <xsl:variable name="status" select="@status"/>  
    <xsl:variable name="resolution">
      <xsl:choose>
        <xsl:when test="@resolution='reject'">Reject</xsl:when>
        <xsl:otherwise>Accept</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- put in place to use CSS -->
    <hr size="3" />
    <p class="{$status}">      

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
    <i>
      <xsl:value-of select="concat('Resolution: ',$resolution, '.  Status: ',@status)"/>
    </i>
    <br/>
<!-- commented out as tc184-sc4.rg no longer operational
    <xsl:if test="@seds='yes'">
      <i>
        Registered in the 
        <a href="http://www.tc184-sc4.org/private/Projects/maindisp.cfm">
          SC4 database
        </a>
        as SEDS: 
        <xsl:value-of select="@id"/>
      </i>
      <br/>
    </xsl:if>
-->
    <xsl:if test="@ballot_comment='yes'">
      <i>
        Registered as a ballot comment by: 
        <xsl:value-of select="@member_body"/>
      </i>
      <br/>
    </xsl:if>
  </p>
    <xsl:apply-templates />

  </xsl:template>


  <xsl:template name="resolve_linkend">
    <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>
    <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
    <xsl:choose>
      <xsl:when test="@type='cover'">
        <b> keywords</b> issue<br/>
        <a href="../sys/cover{$FILE_EXT}#keywords">
          (against the cover page).
        </a>
      </xsl:when>

      <xsl:when test="@type='abstract'">
        <b> keywords</b> issue<br/>
        <a href="../sys/cover{$FILE_EXT}#abstract">
          (resource.xml/resource/abstract or inscope).
        </a>
      </xsl:when>

      <xsl:when test="@type='keywords'">
        <b> keywords</b> issue<br/>
        <a href="../sys/cover{$FILE_EXT}#keywords">
          (resource.xml/resource/keywords).
        </a>
      </xsl:when>
      <xsl:when test="@type='contacts'">
        against contacts.
        <a href="../sys/cover{$FILE_EXT}#keywords">
          (resource.xml/resource/contacts).
        </a>
      </xsl:when>

      <xsl:when test="@type='purpose'">
        against purpose.
        <a href="../sys/introduction{$FILE_EXT}#introduction">
          (resource.xml/resource/purpose).
        </a>
      </xsl:when>

      <xsl:when test="@type='inscope'">
        against inscope.
        <a href="../sys/1_scope{$FILE_EXT}#scope">
          (resource.xml/resource/inscope).
        </a>
      </xsl:when>

      <xsl:when test="@type='outscope'">
        against outscope.
        <a href="../sys/1_scope{$FILE_EXT}#scope">
          (resource.xml/resource/outscope).
        </a>
      </xsl:when>

      <xsl:when test="@type='normrefs'">
        against normrefs.
        <a href="../sys/2_refs{$FILE_EXT}">
          (resource.xml/resource/normrefs).
        </a>
      </xsl:when>

      <xsl:when test="@type='definition'">
        against definition.
        <a href="../sys/3_defs{$FILE_EXT}#defns">
          (resource.xml/resource/definition).
        </a>
      </xsl:when>

      <xsl:when test="@type='abbreviations'">
        against abbreviations.
        <a href="../sys/3_defs{$FILE_EXT}#abbrv">
          (resource.xml/resource/abbreviations).
        </a>
      </xsl:when>

      <xsl:when test="@type='intro'">
        against introduction.
        <a href="../sys/introduction{$FILE_EXT}#introduction">
          (resource.xml/resource/purpose).
        </a>
      </xsl:when>

      <xsl:when test="@type='foreword'">
        against foreword.
        <a href="../sys/foreword{$FILE_EXT}#foreword">
          (see xsl).
        </a>
      </xsl:when>

      <xsl:when test="@type='contents'">
        against contents.
        <a href="../sys/contents{$FILE_EXT}#contents">
          (see xsl).
        </a>
      </xsl:when>

      <xsl:when test="@type='index'">
        against .
        <a href="../sys/index{$FILE_EXT}">
          (resource/index.xml).
        </a>
      </xsl:when>

      <xsl:when test="@type='schema_clause'">
        against schema introduction.
        <xsl:if test="string-length(@linkend)>0">
          <xsl:call-template name="link_schema">
            <xsl:with-param name="schema_name" select="@linkend"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
   
      <xsl:when test="@type='schema_intro'">
        against schema introduction.
        <xsl:if test="string-length(@linkend)>0">
          <xsl:call-template name="link_intro">
            <xsl:with-param name="schema_name" select="@linkend"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
   
      <xsl:when test="@type='fund_cons'">
        against fundamental concepts.
        <xsl:if test="string-length(@linkend)>0">
          <xsl:call-template name="link_fund_cons">
            <xsl:with-param name="schema_name" select="@linkend"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>

      <xsl:when test="@type='express'">
        against express
        <xsl:if test="string-length(@linkend)>0">
          <xsl:call-template name="link_schema">
            <xsl:with-param name="schema_name" select="@linkend"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>

      <xsl:when test="@type='express_doc'">
        against express
        <xsl:if test="string-length(@linkend)>0">
          <xsl:call-template name="link_schema">
            <xsl:with-param name="schema_name" select="@linkend"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>


      <xsl:when test="@type='expg'">
        against express-g.
        <a href="../sys/d_expg{$FILE_EXT}">
          (express-g directory).
        </a>
      </xsl:when>

      <xsl:when test="@type='shortnames'">
        against short names.
        <a href="../sys/a_short_names{$FILE_EXT}">
          (resource.xml/resource/shortnames).
        </a>
      </xsl:when>

      <xsl:when test="@type='tech_discussion'">
        against  technical discussion.
        <a href="../sys/tech_discussion{$FILE_EXT}">
          (resource.xml/resource/tech_discussion).
        </a>
      </xsl:when>

      <xsl:when test="@type='examples'">
        against examples.
        <a href="../sys/examples{$FILE_EXT}">
          (resource.xml/resource/examples).
        </a>
      </xsl:when>

      <xsl:when test="@type='add_scope'">
        against additional scope.
        <a href="../sys/add_scope{$FILE_EXT}">
          (resource.xml/resource/add_scope).
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


<xsl:template match="resource" mode="annex_list" >
<!-- returns a list of annexes with content as a string with each annex name as a single word(no spaces)
separated by spaces -->
        <xsl:if test="string-length(./tech_discussion) > 10">
            Technicaldiscussion
        </xsl:if>
        <xsl:if test="string-length(./examples) > 10">
            Examples 
        </xsl:if>
        <xsl:if test="string-length(./add_scope) > 10">
             Additionalscope
        </xsl:if>

</xsl:template>

<xsl:template name="annex_position" >
	<xsl:param name="annex_name" />
	<xsl:param name="annex_list" />
<!-- returns integer count of position of named annex in list of annexes -->
	<xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
	<xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>

	<xsl:variable name="annex" select="concat(translate($annex_name,' ',''),' ')" />

	<xsl:value-of select="string-length(
					translate(
						substring-before(
							concat(' ',normalize-space($annex_list),' '),
							$annex
							     ),
						concat($UPPER,$LOWER),
						'')
						)" />
</xsl:template>

<xsl:template name="annex_count" >
  <xsl:if test="string-length(./tech_discussion) > 10">T</xsl:if>
  <xsl:if test="string-length(./examples) > 10">E</xsl:if>
  <xsl:if test="string-length(./add_scope) > 10">A</xsl:if>
</xsl:template>


</xsl:stylesheet>
