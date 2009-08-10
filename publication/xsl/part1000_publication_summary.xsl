<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: part1000_publication_summary.xsl,v 1.2 2009/07/15 16:33:54 robbod Exp $
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
      select="concat('../part1000/',./publication/@directory,'/publication_index.xml')"/>
    <xsl:apply-templates select="document($publication_index)/part1000.publication_index"/>
  </xsl:template>

  <xsl:template match="part1000.publication_index">
    <HTML>
    <head>
      <title>
        <xsl:value-of select="@name"/>
      </title>
    </head>
      <body>
        <hr/>
        <h2>Part 1000 change request</h2>
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
          <xsl:variable name="wgroup">
            <xsl:choose>
              <xsl:when test="contains(@sc4.working_group,'WG')">
                <xsl:value-of select="normalize-space(substring-after(@sc4.working_group,'WG'))"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="normalize-space(@sc4.working_group)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <td><xsl:value-of select="concat('WG',$wgroup,' N', @wg.number.publication_set)"/></td>
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
      <p>
        <!-- NOTE - not all packages have normref_check file -->
        Normative reference 
        <a href="normref_check{$FILE_EXT}">check</a>
      </p>
      <xsl:apply-templates select="./modules" mode="table_hdr"/>      
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
      <td><b>CVS file revisions</b></td>
      </tr>
      <xsl:apply-templates select="./module" mode="table_row">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>
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
        <xsl:variable name="pub_dir" select="concat($stepmodhome,'/part1000')"/>
        
        <xsl:variable name="mod_dir_name"
          select="concat('iso10303_',$module_node/@part)"/>
        
        <tr>
          <!-- Module -->
          <td>
            <xsl:variable name="mod_xref"
              select="concat($pub_dir,'/data/modules/',@name,'/sys/cover.htm')"/>
            <a href="{$mod_xref}">
              <xsl:value-of select="@name"/>
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
        <!-- <td>
             <xsl:variable name="sc4_xref"
               select="concat($pub_dir,'/data/modules/',@name,'/sys/cover_sc4',$FILE_EXT)"/>
             <a href="{$sc4_xref}">sc4_cover.htm</a>
           </td>
           -->
        
        <xsl:variable name="status"
          select="translate(translate($module_node/@status,$UPPER,$LOWER),'-_ ','')"/>        
  
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
              <xsl:value-of select="concat('Error publication1: ', $module_ok)"/>
            </xsl:with-param>
          </xsl:call-template>
        </td>
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