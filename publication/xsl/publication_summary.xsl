<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: ballot_summary.xsl,v 1.20 2003/07/25 00:33:31 thendrix Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited http://www.eurostep.com
  Purpose: To display a table summarising the modules in a publication package

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="../../xsl/ap_doc/common.xsl"/>
  <xsl:import href="../../xsl/res_doc/common.xsl"/>


  <xsl:output 
    method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    indent="yes"
    />

    <xsl:param name="stepmodhome" select="'../../../..'"/>
    <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>
    <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

  <!-- force the application of the stylesheet to the file specified in the
       file attribute -->
  <xsl:template match="/">
    <xsl:variable name="publication_index" 
      select="concat('../publication/',./publication/@directory,'/publication_index.xml')"/>
    <xsl:apply-templates select="document($publication_index)/publication_index"/>
  </xsl:template>

  <xsl:template match="publication_index">
    <HTML>
    <head>
      <title>
        <xsl:value-of select="@name"/>
      </title>
    </head>
    <body>
      <hr/>
      <table>
        <tr>
          <td>Publication set name:</td>
          <td><xsl:value-of select="@name"/></td>
        </tr>
        <tr>
          <td>Date submitted to ISO:</td>
          <td><xsl:value-of select="@date.iso_submission"/></td>
        </tr>
        <tr>
          <td>Date published by ISO:</td>
          <td><xsl:value-of select="@date.iso_publication"/></td>
        </tr>
        <tr>
          <td>Publication set working group:</td>
          <td><xsl:value-of select="@sc4.working_group"/></td>
        </tr>

        <tr>
          <td>Publication set WG number:</td>
          <td><xsl:value-of select="concat('WG',@sc4.working_group,' N', @wg.number.publication_set"/></td>
        </tr>
        <tr>
          <td>Publication project leader:</td>
          <td>
              <xsl:apply-templates select="./contacts/projlead"
                mode="no_address"/>
          </td>
        </tr>
        <tr>
          <td>Description:</td>
          <td><xsl:value-of select="@description"/><xsl:value-of select="./description"/></td>
        </tr>
      </table>
      <hr/>
      
      <xsl:apply-templates select="./modules" mode="table_hdr"/>
      <xsl:apply-templates select="./resource_docs" mode="table_hdr"/>
      <xsl:apply-templates select="./application_protocols" mode="table_hdr"/>
      
    </body>
  </HTML>
  </xsl:template>


  <xsl:template match="modules" mode="table_hdr">
    <p/>
    <table border="1">
      <tr>
      <td><b>Module</b></td>
      <td><b>Part</b></td>
      <td><b>Edition</b></td>
      <td><b>Stage</b></td>
      <td><b>Year of<br/>publication</b></td>
      <td><b>SC4 cover page</b></td>
      <td><b>Abstract</b></td>
      <td><b>ARM EXPRESS</b></td>
      <td><b>ARM LF EXPRESS</b></td>          
      <td><b>MIM EXPRESS</b></td>
      <td><b>MIM LF EXPRESS</b></td>
      <td><b>ZIP file for ISO</b></td>
      <td><b>CVS file revisions</b></td>
      </tr>
      <xsl:apply-templates select="./module" mode="table_row"/>
    </table>
  </xsl:template>

  <xsl:template match="resource_docs" mode="table_hdr">
    NOT YET IMPLEMENTED
  </xsl:template>

  <xsl:template match="application_protocols" mode="table_hdr">
    <p/>
    <table border="1">
      <tr>
      <td><b>AP</b></td>
      <td><b>Part</b></td>
      <td><b>Edition</b></td>
      <td><b>Stage</b></td>
      <td><b>Year of<br/>publication</b></td>
      <td><b>SC4 cover page</b></td>
      <td><b>Abstract</b></td>
      <td><b>ZIP file for ISO</b></td>
      <td><b>CVS file revisions</b></td>
      </tr>
      <xsl:apply-templates select="./ap_doc" mode="table_row"/>
    </table>
  </xsl:template>

  <xsl:template match="module" mode="table_row">
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
        <xsl:variable name="pub_dir" select="concat($stepmodhome,'/iso10303_',$module_node/@part)"/>
        
        <xsl:variable name="mod_dir_name"
          select="concat('iso10303_',$module_node/@part)"/>
        
        <tr>
          <!-- Part -->
          <td>
            <xsl:variable name="mod_cover"
              select="concat($mod_dir_name,'.htm')"/>
            <xsl:variable name="mod_xref"
              select="concat($pub_dir,'/',$mod_cover)"/>
            <xsl:value-of select="@name"/> 
            <a href="{$mod_xref}">
              <xsl:value-of select="$mod_cover"/>
            </a>
          </td>
          
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
        
        <!-- SC4 cover page -->
        <td>
          <xsl:variable name="sc4_xref"
            select="concat($pub_dir,'/data/modules/',@name,'/sys/cover_sc4',$FILE_EXT)"/>
          <a href="{$sc4_xref}">sc4_cover.htm</a>
        </td>
        
        <!-- Abstract -->
        <td>
          <xsl:variable name="abstract_name"
            select="concat('abstract_',$module_node/@part,'.htm')"/>
          <xsl:variable name="abstract_xref"
            select="concat($pub_dir,'/abstracts/',$abstract_name)"/>
          <a href="{$abstract_xref}">
            <xsl:value-of select="$abstract_name"/>
          </a>
        </td>
        
        <xsl:variable name="status"
          select="translate(translate($module_node/@status,$UPPER,$LOWER),'-_ ','')"/>        
        <!-- ARM express -->
        <td>
          <xsl:variable name="armfile"
            select="concat('part',
                    $module_node/@part,
                    $status, '_wg',
                    $module_node/@sc4.working_group,'n',
                    $module_node/@wg.number.arm,
                    'arm.exp')"/>
          <xsl:variable name="arm_href" select="concat($mod_dir_name,'/express/',$armfile)"/>
          <a href="{$arm_href}">
            <xsl:value-of select="$armfile"/>
          </a>
        </td>
        
        
        <!-- ARM Long form express -->
        <xsl:choose>
          <xsl:when test="$module_node/@wg.number.arm_lf">
            <td>
              <xsl:variable name="arm_lf_file"
                select="concat('part',
                        $module_node/@part,
                        $status, '_wg',
                        $module_node/@sc4.working_group,'n',
                        $module_node/@wg.number.arm_lf,
                        'arm_lf.exp')"/>
              <xsl:variable name="arm_lf_href" select="concat($mod_dir_name,'/express/',$arm_lf_file)"/>
              <a href="{$arm_lf_href}">
                <xsl:value-of select="$arm_lf_file"/>
              </a>
            </td>
          </xsl:when>
          <xsl:otherwise>
            <td>
              No Long Form
            </td>
          </xsl:otherwise>
        </xsl:choose>
        
        
        <!-- MIM express -->
        <td>
          <xsl:variable name="mimfile"
            select="concat('part',
                    $module_node/@part,
                    $status, '_wg',
                    $module_node/@sc4.working_group,'n',
                    $module_node/@wg.number.mim,
                    'mim.exp')"/>
          <xsl:variable name="mim_href" select="concat($mod_dir_name,'/express/',$mimfile)"/>
          <a href="{$mim_href}">
            <xsl:value-of select="$mimfile"/>
          </a>
        </td>
        
        
        <!-- MIM Long form express -->
        <xsl:choose>
          <xsl:when test="$module_node/@wg.number.mim_lf">
            <td>
              <xsl:variable name="mim_lf_file"
                select="concat('part',
                        $module_node/@part,
                        $status, '_wg',
                        $module_node/@sc4.working_group,'n',
                        $module_node/@wg.number.mim_lf,
                        'mim_lf.exp')"/>
              <xsl:variable name="mim_lf_href" 
                select="concat($mod_dir_name,'/express/',$mim_lf_file)"/>
              <a href="{$mim_lf_href}">
                <xsl:value-of select="$mim_lf_file"/>
              </a>
            </td>
          </xsl:when>
          <xsl:otherwise>
            <td>
              No Long Form
            </td>
          </xsl:otherwise>
        </xsl:choose>
        
        <!-- ZIP file -->
        <td>
          <xsl:variable name="zipfile_name" 
            select="concat($mod_dir_name,'.zip')"/>
          <xsl:variable name="zipfile_xref" select="concat('./zip/',$zipfile_name)"/>
          <a href="{$zipfile_xref}">
            <xsl:value-of select="$zipfile_name"/>
          </a>
        </td>
        
        <!-- CVS revisions -->
        <td>
          <xsl:variable name="cvs_xref"
            select="concat($pub_dir,'/data/modules/',@name,'/publication_record.xml')"/>
          
          <a href="{$cvs_xref}">publication_record.xml</a>
        </td>
      </tr>
    </xsl:when>
    <!-- module does not exist in repository index -->
    <xsl:otherwise>
      <tr>
        <td>
          <xsl:value-of select="../@name"/>
        </td>
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
      </tr>      
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="res_doc" mode="table_row">
</xsl:template>

  <xsl:template match="ap_doc" mode="table_row">
    <xsl:variable name="apdoc_ok">
      <xsl:call-template name="check_application_protocol_exists">
        <xsl:with-param name="application_protocol" select="@name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$apdoc_ok='true'">
        <xsl:variable name="apdoc_file"
          select="concat('../../data/application_protocols/',@name,'/application_protocol.xml')"/>
        <xsl:variable name="apdoc_node"
          select="document($apdoc_file)/application_protocol"/>
        <xsl:variable name="pub_dir" select="concat($stepmodhome,'/iso10303_',$apdoc_node/@part)"/>
        
        <xsl:variable name="apdoc_dir_name" select="concat('iso10303_',$apdoc_node/@part)"/>
        
        <tr>
          <!-- Part -->
          <td>
            <xsl:variable name="apdoc_cover"
              select="concat($apdoc_dir_name,'.htm')"/>
            <xsl:variable name="apdoc_xref"
              select="concat($pub_dir,'/',$apdoc_cover)"/>
            <xsl:value-of select="@name"/>&#160;
            <a href="{$apdoc_xref}">
              <xsl:value-of select="$apdoc_cover"/>
            </a>
          </td>
          
          <!-- Part -->
          <td>
            <xsl:choose>
              <xsl:when test="$apdoc_node/@part">
                <xsl:value-of select="concat('10303-',$apdoc_node/@part)"/>
                
                <!-- check that the part number in repository_index - that in
                     application_protocol -->
                <xsl:variable name="application_protocol" select="@name"/>
                <xsl:variable name="repo_apdoc_number"
                  select="document('../../repository_index.xml')/repository_index/application_protocols/application_protocol[@name=$application_protocol]/@part"/>
                <xsl:if test="$repo_apdoc_number != $apdoc_node/@part">
                  <br/>
                  <font color="#FF0000" size="-1">
                    The part number in repository_index
                    (<xsl:value-of select="$repo_apdoc_number"/>)
                  does not equal that in application_protocol 
                  (<xsl:value-of select="$apdoc_node/@part"/>).
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
              test="string-length(normalize-space($apdoc_node/@version))>0">
              <xsl:value-of select="$apdoc_node/@version"/>
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
              test="string-length(normalize-space($apdoc_node/@status))>0">
              <xsl:value-of select="$apdoc_node/@status"/>
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
              test="string-length(normalize-space($apdoc_node/@publication.year))>0">
              <xsl:value-of select="$apdoc_node/@publication.year"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>
        
        <!-- SC4 cover page -->
        <td>
          <xsl:variable name="sc4_xref"
            select="concat($pub_dir,'/data/application_protocols/',@name,'/sys/cover_sc4',$FILE_EXT)"/>
          <a href="{$sc4_xref}">sc4_cover.htm</a>
        </td>
        
        <!-- Abstract -->
        <td>
          <xsl:variable name="abstract_name"
            select="concat('abstract_',$apdoc_node/@part,'.htm')"/>
          <xsl:variable name="abstract_xref"
            select="concat($pub_dir,'/abstracts/',$abstract_name)"/>
          <a href="{$abstract_xref}">
            <xsl:value-of select="$abstract_name"/>
          </a>
        </td>        
        
        <!-- ZIP file -->
        <td>
          <xsl:variable name="zipfile_name" 
            select="concat($apdoc_dir_name,'.zip')"/>
          <xsl:variable name="zipfile_xref" select="concat('./zip/',$zipfile_name)"/>
          <a href="{$zipfile_xref}">
            <xsl:value-of select="$zipfile_name"/>
          </a>
        </td>
        
        <!-- CVS revisions -->
        <td>
          <xsl:variable name="cvs_xref"
            select="concat($pub_dir,'/data/application_protocols/',@name,'/publication_record.xml')"/>
          
          <a href="{$cvs_xref}">publication_record.xml</a>
        </td>
      </tr>
    </xsl:when>
    <!-- application_protocol does not exist in repository index -->
    <xsl:otherwise>
      <tr>
        <td>
          <xsl:value-of select="../@name"/>
        </td>
        <td>
          <xsl:value-of select="@name"/>
          <xsl:call-template name="error_message">
            <xsl:with-param name="message">
              <xsl:value-of select="concat('Error ballot1: ', $apdoc_ok)"/>
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
      </tr>      
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>