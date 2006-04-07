<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: ballot_checklist.xsl,v 1.10 2005/02/17 02:20:31 thendrix Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited http://www.eurostep.com
  Purpose: To display a table summarising the modules in a ballot package
     including all the WG numbers

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="./common.xsl"/>
  <xsl:import href="../../xsl/common.xsl"/>



  <xsl:output 
    method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    indent="yes"
    />


  <!-- force the application of the stylesheet to the file specified in the
       file attribute -->
  <xsl:template match="/">
    <xsl:variable name="ballot_index" 
      select="concat('../ballots/',./ballot/@directory,'/ballot_index.xml')"/>
    <xsl:apply-templates select="document($ballot_index)/ballot_index"/>
  </xsl:template>



<xsl:template match="ballot_index">
  <HTML>
    <head>
      <title>
        <xsl:value-of select="@name"/>
      </title>
    </head>
    <body>

      <xsl:call-template name="output_menubar">
        <xsl:with-param name="module_root" select="'.'"/>
        <xsl:with-param name="module_name" select="@name"/>
        <xsl:with-param name="new_menubar_file" 
          select="concat('./ballots/ballots/',@name,'/menubar_ballot.xml')"/>
      </xsl:call-template>
      <hr/>

      <xsl:call-template name="ballot_header"/>
      <table border="1">
        <tr>
          <td><b>Ballot cycle</b></td>
          <td><b>Ballot package</b></td>
          <td><b>Module</b></td>
          <td><b>WG group</b></td>
          <!-- URL <td><b>URL</b></td> -->
          <td><b>Part</b></td>
          <td><b>Version</b></td>
          <td><b>Status</b></td>
          <td><b>Year</b></td>
          <td><b>Published</b></td>
          <td><b>Doc WGn</b></td>
          <td><b>Superseded Doc WGn</b></td>

          <td><b>ARM WGn</b></td>
          <td><b>Superseded ARM WGn</b></td>

          <td><b>ARM LF WGn</b></td>
          <td><b>Superseded ARM LF WGn</b></td>

          <td><b>MIM WGn</b></td>
          <td><b>Superseded MIM WGn</b></td>

          <td><b>MIM LF WGn</b></td>
          <td><b>Superseded MIM LF WGn</b></td>

          <td><b>Internal checklist WGn</b></td>
          <td><b>Project leader checklist WGn</b></td>
          <td><b>Convener leader checklist WGn</b></td>
          <td><b>Project leader</b></td>
          <td><b>Project editor</b></td>

          <td><b>Scope</b></td>
          <td><b>Introduction</b></td>
          <td><b>Normrefs</b></td>
          <td><b>Bibliography</b></td>
          <td><b>ARM</b></td>
          <td><b>MIM</b></td>
          <td><b>Mapping</b></td>
          <td><b>QC complete</b></td>
          <td><b>ARM dvlp file</b></td>
          <td><b>MIM dvlp file</b></td>
        </tr>
        <tr>
          <td><small><i>&#160;</i></small></td>
          <td><small><i>&#160;</i></small></td>
          <td align="right"><small>file:</small></td>
          <td><small><i>module.xml</i></small></td>
          <!-- URL <td>&#160;</td> -->
          <td><small><i>module.xml</i></small></td>
          <td><small><i>module.xml</i></small></td>
          <td><small><i>module.xml</i></small></td>
          <td><small><i>module.xml</i></small></td>
          <td><small><i>module.xml</i></small></td>
          <td><small><i>module.xml</i></small></td>
          <td><small><i>module.xml</i></small></td>
          <td><small><i>module.xml</i></small></td>
          <td><small><i>module.xml</i></small></td>
          <td><small><i>module.xml</i></small></td>
          <td><small><i>module.xml</i></small></td>
          <td><small><i>module.xml</i></small></td>
          <td><small><i>module.xml</i></small></td>
          <td><small><i>module.xml</i></small></td>
          <td><small><i>module.xml</i></small></td>
          <td><small><i>module.xml</i></small></td>
          <td><small><i>module.xml</i></small></td>
          <td><small><i>module.xml</i></small></td>
          <td><small><i>module.xml</i></small></td>
          <td><small><i>module.xml</i></small></td>
          <td><small><i>module.xml</i></small></td>
          <td><small><i>module.xml</i></small></td>
          <!-- Scope -->
          <td><small><i>module.xml</i></small></td>

          <!-- Introduction -->
          <td><small><i>module.xml</i></small></td>

          <!-- Normrefs -->
          <td><small><i>module.xml</i></small></td>

          <!-- Bibliography -->
          <td><small><i>module.xml</i></small></td>

          <!-- ARM -->
          <td>
            <small><i>arm.xml</i></small><br/>
            <small><i>arm_descriptions.xml</i></small><br/>
            <small><i>armexpg1.xml</i></small>
          </td>

          <!-- MIM -->
          <td>
            <small><i>mim.xml</i></small><br/>
            <small><i>mim_descriptions.xml</i></small><br/>
            <small><i>mimexpg1.xml</i></small>
          </td>

          <!-- Mapping -->
          <td><small><i>module.xml</i></small></td>

          <!-- QC complete -->
          <td>&#160;</td>
        </tr>
        <tr>
          <td><small><i>&#160;</i></small></td>
          <td><small><i>&#160;</i></small></td>
          <td align="right"><small>attribute:</small></td>
          <td><small><i>/module/@sc4.working_group</i></small></td>
          <!-- URL <td>&#160;</td> -->
          <td><small><i>/module/@part</i></small></td>


        <!-- Version -->
        <td><small><i>
          /module/@version
        </i></small></td>

        <!-- Status -->
        <td><small><i>
          /module/@status
        </i></small></td>

        <!-- Year -->
        <td><small><i>
          /module/@publication.year
        </i></small></td>

        <!-- Published -->
        <td><small><i>
          /module/@published
        </i></small></td>

        <!-- Doc WGn -->
        <td><small><i>
          /module/@wg.number
        </i></small></td>

        <!-- Superceded Doc WGn -->
        <td><small><i>
          /module/@wg.number.supersedes
        </i></small></td>
        
        <!-- ARM WGn -->
        <td><small><i>
          /module/@wg.number.arm
        </i></small></td>

        <!-- Superseded ARM WGn -->
        <td><small><i>
          /module/@wg.number.arm.supersedes
        </i></small></td>

        <!-- ARM LF WGn -->
        <td><small><i>
          /module/@wg.number.arm_lf
        </i></small></td>
        <!-- Superseded ARM LF WGn -->
        <td><small><i>
          /module/@wg.number.arm_lf.supersedes
        </i></small></td>

        <!-- MIM WGn -->
        <td><small><i>
          /module/@wg.number.mim
        </i></small></td>
        <!-- Superseded MIM WGn -->
        <td><small><i>
          /module/@wg.number.mim.supersedes
        </i></small></td>

        <!-- MIM LF WGn -->
        <td><small><i>
          /module/@wg.number.mim_lf
        </i></small></td>

        <!-- Superseded MIM LF WGn -->
        <td><small><i>
          /module/@wg.number.mim_lf.supersedes
        </i></small></td>

        <!-- Internal checklist WGn -->
        <td><small><i>
          /module/@checklist.internal_review
        </i></small></td>
        
        <!-- Project leader checklist WGn -->
        <td><small><i>
          module/@checklist.project_leader
        </i></small></td>

        <!-- Convener leader checklist WGn -->
        <td><small><i>
          module/@checklist.convener
        </i></small></td>
        
        <!-- Project leader -->
        <td><small><i>
          module/contacts/projlead/@ref
        </i></small></td>

        <!-- Project editor -->
        <td><small><i>
          module/contacts/editor/@ref
        </i></small></td>
          <!-- Scope -->
          <td>&#160;</td>

          <!-- Introduction -->
          <td>&#160;</td>

          <!-- Normrefs -->
          <td>&#160;</td>

          <!-- Bibliography -->
          <td>&#160;</td>

          <!-- ARM -->
          <td>&#160;</td>

          <!-- MIM -->
          <td>&#160;</td>

          <!-- Mapping -->
          <td>&#160;</td>

          <!-- QC complete -->
          <td>&#160;</td>

        </tr>
        <xsl:apply-templates select="./*/module"/>
        <xsl:apply-templates select="./*/res_doc"/>
      </table>
      <br/>
    </body>
  </HTML>
</xsl:template>

<xsl:template match="module">

  <xsl:variable name="module_ok">
    <xsl:call-template name="check_module_exists">
      <xsl:with-param name="module" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$module_ok='true'">

      <xsl:variable name="module_file"
        select="concat('../../data/modules/',@name,'/module.xml')"/>
      <xsl:variable name="module_node"
        select="document($module_file)/module"/>
      <tr>
        <!-- Ballot package -->
        <td>
          <xsl:value-of select="../../@name"/>    
        </td>

        <!-- Ballot cycle -->
        <td>
          <xsl:value-of select="../@name"/> 
        </td>

        <!-- Module -->
        <td>
          <xsl:value-of select="@name"/>
        </td>

        <!-- WG group -->
        <xsl:variable name="wg_group">
            <xsl:choose>
              <xsl:when test="string-length($module_node/@sc4.working_group)>0">
                <xsl:value-of select="concat('WG',normalize-space($module_node/@sc4.working_group))"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="string('WG12')"/>
              </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <td>
          <xsl:value-of select="$wg_group"/>
        </td>

        <!-- URL 
        <xsl:variable name="mod_xref"
          select="concat('../../../data/modules/',@name,'/sys/1_scope',$FILE_EXT)"/>
        <td>
          <a href="{$mod_xref}">
            <img align="middle" border="0" 
              alt="URL" src="../../../images/url.gif"/>
          </a>
        </td> -->

        <!-- Part -->
        <td>
          <xsl:choose>
            <xsl:when test="$module_node/@part">
              <xsl:value-of select="concat('10303-',$module_node/@part)"/>

              <!-- check that the part number in repository_index - that in
                   module -->
              <xsl:variable name="module" select="@name"/>
              <xsl:variable name="repo_mod_number"
                select="document('../../repository_index.xml')/repository_index/modules/module[@name=$module]/@part"/>
              <xsl:if test="$repo_mod_number != $module_node/@part">
                <br/>
                <font color="#FF0000" size="-1">
                  The part number in repository_index
                  (<xsl:value-of select="$repo_mod_number"/>)
                does not equal that in module 
                (<xsl:value-of select="$module_node/@part"/>).
              </font>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Version -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($module_node/@version))>0">
              <xsl:value-of select="$module_node/@version"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Status -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($module_node/@status))>0">
              <xsl:value-of select="$module_node/@status"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Year -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($module_node/@publication.year))>0">
              <xsl:value-of select="$module_node/@publication.year"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Published -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($module_node/@published))>0">
              <xsl:value-of select="$module_node/@published"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Doc WGn -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($module_node/@wg.number))>0">
              <xsl:value-of select="$module_node/@wg.number"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Superceded Doc WGn -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($module_node/@wg.number.supersedes))>0">
              <xsl:value-of select="$module_node/@wg.number.supersedes"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>
        
        <!-- ARM WGn -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($module_node/@wg.number.arm))>0">
              <xsl:value-of select="$module_node/@wg.number.arm"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Supersedes ARM WGn -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($module_node/@wg.number.arm.supersedes))>0">
              <xsl:value-of select="$module_node/@wg.number.arm.supersedes"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- ARM LFWGn -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($module_node/@wg.number.arm_lf))>0">
              <xsl:value-of select="$module_node/@wg.number.arm_lf"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Supersedes ARM LFWGn -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($module_node/@wg.number.arm_lf.supersedes))>0">
              <xsl:value-of select="$module_node/@wg.number.arm_lf.supersedes"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- MIM WGn -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($module_node/@wg.number.mim))>0">
              <xsl:value-of select="$module_node/@wg.number.mim"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Supersedes MIM WGn -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($module_node/@wg.number.mim.supersedes))>0">
              <xsl:value-of select="$module_node/@wg.number.mim.supersedes"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>



        <!-- MIM LF WGn -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($module_node/@wg.number.mim_lf))>0">
              <xsl:value-of select="$module_node/@wg.number.mim_lf"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Supersedes  MIM LF WGn -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($module_node/@wg.number.mim_lf.supersedes))>0">
              <xsl:value-of select="$module_node/@wg.number.mim_lf.supersedes"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Internal checklist WGn -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($module_node/@checklist.internal_review))>0">
              <xsl:value-of select="$module_node/@checklist.internal_review"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>
        
        <!-- Project leader checklist WGn -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($module_node/@checklist.project_leader))>0">
              <xsl:value-of select="$module_node/@checklist.project_leader"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Convener leader checklist WGn -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($module_node/@checklist.convener))>0">
              <xsl:value-of select="$module_node/@checklist.convener"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>
        
        <!-- Project leader -->
        <xsl:variable name="projlead_ref" 
          select="$module_node/contacts/projlead/@ref"/>        
        <td>
          <xsl:call-template name="get_contact_name">
            <xsl:with-param name="ref" select="$projlead_ref"/>
          </xsl:call-template>
        </td>

        <!-- Project editor -->
        <xsl:variable name="projed_ref" 
          select="$module_node/contacts/editor/@ref"/>
        <td>
          <xsl:call-template name="get_contact_name">
            <xsl:with-param name="ref" select="$projed_ref"/>
          </xsl:call-template>
        </td>

        <!-- Scope -->
        <td>&#160;</td>
        
        <!-- Introduction -->
        <td>&#160;</td>

        <!-- Normrefs -->
        <td>&#160;</td>
        
        <!-- Bibliography -->
        <td>&#160;</td>
        
        <!-- ARM -->
        <td>&#160;</td>
        
        <!-- MIM -->
        <td>&#160;</td>
        
        <!-- Mapping -->
        <td>&#160;</td>
        
        <!-- QC complete -->
        <td>&#160;</td>
        
        <!-- ARM dvlp file -->
        <td>
          <xsl:call-template name="get_dvlp_file">
            <xsl:with-param name="module" select="@name"/>
            <xsl:with-param name="arm_or_mim" select="'arm'"/>
          </xsl:call-template>
	</td>

        
        <!-- MIM dvlp file -->
          <td>
          <xsl:call-template name="get_dvlp_file">
            <xsl:with-param name="module" select="@name"/>
            <xsl:with-param name="arm_or_mim" select="'mim'"/>
          </xsl:call-template>
	</td>
      </tr>
    </xsl:when>

    <!-- module does not exist in repository index -->
    <xsl:otherwise>
      <tr>
        <!-- Ballot package -->
        <td>
          <xsl:value-of select="../../@name"/>    
        </td>

        <!-- Ballot cycle -->
        <td>
          <xsl:value-of select="../@name"/> 
        </td>

        <!-- Module -->
        <td>
          <xsl:value-of select="@name"/>
          <xsl:call-template name="error_message">
            <xsl:with-param name="message">
              <xsl:value-of select="concat('Error ballot1: ', $module_ok)"/>
            </xsl:with-param>
          </xsl:call-template>
        </td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <!-- Scope -->
        <td>&#160;</td>
        
        <!-- Introduction -->
        <td>&#160;</td>

        <!-- Normrefs -->
        <td>&#160;</td>
        
        <!-- Bibliography -->
        <td>&#160;</td>
        
        <!-- ARM -->
        <td>&#160;</td>

        <!-- ARM LF-->
        <td>&#160;</td>
        
        <!-- MIM -->
        <td>&#160;</td>

        <!-- MIM LF -->
        <td>&#160;</td>
        
        <!-- Mapping -->
        <td>&#160;</td>
        
        <!-- QC complete -->
        <td>&#160;</td>
      </tr>      
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="res_doc">

  <xsl:variable name="resdoc_ok">
    <xsl:call-template name="check_resdoc_exists">
      <xsl:with-param name="resdoc" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$resdoc_ok='true'">

      <xsl:variable name="resdoc_file"
        select="concat('../../data/resource_docs/',@name,'/resource.xml')"/>
      <xsl:variable name="resdoc_node"
        select="document($resdoc_file)/resource"/>
      <tr>
        <!-- Ballot package -->
        <td>
          <xsl:value-of select="../../@name"/>    
        </td>

        <!-- Ballot cycle -->
        <td>
          <xsl:value-of select="../@name"/> 
        </td>

        <!-- Module -->
        <td>
          <xsl:value-of select="@name"/>
        </td>

        <!-- WG group -->
        <xsl:variable name="wg_group">
            <xsl:choose>
              <xsl:when test="string-length($resdoc_node/@sc4.working_group)>0">
                <xsl:value-of select="concat('WG',normalize-space($resdoc_node/@sc4.working_group))"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="string('WG12')"/>
              </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <td>
          <xsl:value-of select="$wg_group"/>
        </td>

        <!-- URL 
        <xsl:variable name="mod_xref"
          select="concat('../../../data/modules/',@name,'/sys/1_scope',$FILE_EXT)"/>
        <td>
          <a href="{$mod_xref}">
            <img align="middle" border="0" 
              alt="URL" src="../../../images/url.gif"/>
          </a>
        </td> -->

        <!-- Part -->
        <td>
          <xsl:choose>
            <xsl:when test="$resdoc_node/@part">
              <xsl:value-of select="concat('10303-',$resdoc_node/@part)"/>

              <!-- check that the part number in repository_index - that in
                   module -->
              <xsl:variable name="resdoc" select="@name"/>
              <xsl:variable name="repo_mod_number"
                select="document('../../repository_index.xml')/repository_index/resource_docs/resource_doc[@name=$resdoc]/@part"/>
              <xsl:if test="$repo_mod_number != $resdoc_node/@part">
                <br/>
                <font color="#FF0000" size="-1">
                  The part number in repository_index
                  (<xsl:value-of select="$repo_mod_number"/>)
                does not equal that in module 
                (<xsl:value-of select="$resdoc_node/@part"/>).
              </font>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Version -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($resdoc_node/@version))>0">
              <xsl:value-of select="$resdoc_node/@version"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Status -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($resdoc_node/@status))>0">
              <xsl:value-of select="$resdoc_node/@status"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Year -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($resdoc_node/@publication.year))>0">
              <xsl:value-of select="$resdoc_node/@publication.year"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Published -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($resdoc_node/@published))>0">
              <xsl:value-of select="$resdoc_node/@published"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Doc WGn -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($resdoc_node/@wg.number))>0">
              <xsl:value-of select="$resdoc_node/@wg.number"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Superceded Doc WGn -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($resdoc_node/@wg.number.supersedes))>0">
              <xsl:value-of select="$resdoc_node/@wg.number.supersedes"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>
        
        <!-- EXPRESS WGn -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($resdoc_node/@wg.number.express))>0">
              <xsl:value-of select="$resdoc_node/@wg.number.express"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Supersedes EXPRESS WGn -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($resdoc_node/@wg.number.express.supersedes))>0">
              <xsl:value-of select="$resdoc_node/@wg.number.express.supersedes"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

       <!-- Internal checklist WGn -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($resdoc_node/@checklist.internal_review))>0">
              <xsl:value-of select="$resdoc_node/@checklist.internal_review"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>
        
        <!-- Project leader checklist WGn -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($resdoc_node/@checklist.project_leader))>0">
              <xsl:value-of select="$resdoc_node/@checklist.project_leader"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Convener leader checklist WGn -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($resdoc_node/@checklist.convener))>0">
              <xsl:value-of select="$resdoc_node/@checklist.convener"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>
        
        <!-- Project leader -->
        <xsl:variable name="projlead_ref" 
          select="$resdoc_node/contacts/projlead/@ref"/>        
        <td>
          <xsl:call-template name="get_contact_name">
            <xsl:with-param name="ref" select="$projlead_ref"/>
          </xsl:call-template>
        </td>

        <!-- Project editor -->
        <xsl:variable name="projed_ref" 
          select="$resdoc_node/contacts/editor/@ref"/>
        <td>
          <xsl:call-template name="get_contact_name">
            <xsl:with-param name="ref" select="$projed_ref"/>
          </xsl:call-template>
        </td>

        <!-- Scope -->
        <td>&#160;</td>
        
        <!-- Introduction -->
        <td>&#160;</td>

        <!-- Normrefs -->
        <td>&#160;</td>
        
        <!-- Bibliography -->
        <td>&#160;</td>
        
      <!-- QC complete -->
        <td>&#160;</td>
      </tr>
    </xsl:when>

    <!-- module does not exist in repository index -->
    <xsl:otherwise>
      <tr>
        <!-- Ballot package -->
        <td>
          <xsl:value-of select="../../@name"/>    
        </td>

        <!-- Ballot cycle -->
        <td>
          <xsl:value-of select="../@name"/> 
        </td>

        <!-- Module -->
        <td>
          <xsl:value-of select="@name"/>
          <xsl:call-template name="error_message">
            <xsl:with-param name="message">
              <xsl:value-of select="concat('Error ballot1: ', $resdoc_ok)"/>
            </xsl:with-param>
          </xsl:call-template>
        </td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <!-- Scope -->
        <td>&#160;</td>
        
        <!-- Introduction -->
        <td>&#160;</td>

        <!-- Normrefs -->
        <td>&#160;</td>
        
        <!-- Bibliography -->
        <td>&#160;</td>
        
        <!-- EXPRESS -->
        <td>&#160;</td>

         <!-- QC complete -->
        <td>&#160;</td>
      </tr>      
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="get_contact_name">
  <xsl:param name="ref"/>
  <xsl:variable name="contact"
    select="document('../../data/basic/contacts.xml')/contact.list/contact[@id=$ref]"/>
  <xsl:choose>
    <xsl:when test="$contact">
      <xsl:value-of select="concat($contact/firstname,' ',$contact/lastname)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="'-'"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

  <xsl:template name="check_resdoc_exists">
    <xsl:param name="resdoc"/>

    <xsl:variable name="resdoc_name">
      <xsl:call-template name="module_name">
        <xsl:with-param name="module" select="$resdoc"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="ret_val">
        <xsl:choose>
          <xsl:when
            test="document('../../repository_index.xml')/repository_index/resource_docs/resource_doc[@name=$resdoc_name]">
            <xsl:value-of select="'true'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of
              select="concat(' The resource document ', $resdoc_name,
                      ' is not identified as a resource document  in repository_index.xml')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:value-of select="$ret_val"/>
  </xsl:template>

<xsl:template name="get_dvlp_file">
  <xsl:param name="module"/>
  <xsl:param name="arm_or_mim"/>
  <xsl:variable name="dvlp_file"
    select="document(concat('../../data/modules/',$module,'/',$arm_or_mim,'.xml'))/express/application/@source"/>
  <xsl:choose>
    <xsl:when test="$dvlp_file">
      <xsl:value-of select="$dvlp_file"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="'-'"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

  
</xsl:stylesheet>