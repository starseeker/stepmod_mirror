<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: ballot_issues.xsl,v 1.1 2003/01/20 12:08:11 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited http://www.eurostep.com
  Purpose: 

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
      <h2>Ballot Issues</h2>
      <table border="1">
        <tr>
          <td><b>Part</b></td>
          <td><b>Number</b></td>
          <td><b>Total issues</b></td>
          <td><b>Open issues</b></td>
          <td><b>Project leader</b></td>
          <td><b>Editor</b></td>
          <td><b>Developer</b></td>
        </tr>
        <xsl:apply-templates select="./*/module">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
      </table>
    </body>
  </HTML>
</xsl:template>

<xsl:template match="module">
  <xsl:variable name="module_ok">
    <xsl:call-template name="check_module_exists">
      <xsl:with-param name="module" select="@name"/>
    </xsl:call-template>
  </xsl:variable>
  <tr>
    <xsl:choose>
      <xsl:when test="$module_ok='true'">
        
        <xsl:variable name="mod_dir">
          <xsl:call-template name="module_directory">
            <xsl:with-param name="module" select="@name"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="module"
          select="document(concat('../../data/modules/',@name,'/module.xml'))/module"/>

        <xsl:choose>
          <xsl:when test="$module/@development.folder">

            <xsl:variable name="projmg_file" 
              select="concat('../../data/modules/',$module/@name,'/',$module/@development.folder,'/projmg.xml')"/>
            
            <xsl:variable name="developer" 
              select="document($projmg_file)/management/developers/developer[1]"/>

            <xsl:variable name="issues_file" 
              select="concat('../../data/modules/',$module/@name,'/',$module/@development.folder,'/issues.xml')"/>
            
            <xsl:variable name="issue_href"
              select="concat('../../../data/modules/',$module/@name,'/',$module/@development.folder,'/issues',$FILE_EXT)"/>

            <xsl:variable name="open_issues"
              select="count(document($issues_file)/issues/issue[@status!='closed'])"/>
            
            <xsl:variable name="total_issues"
              select="count(document($issues_file)/issues/issue)"/>
            <xsl:choose>
              <xsl:when test="$open_issues>0">
                <td bgcolor="#FFFF99">
                  <xsl:value-of select="$module/@part"/>
                </td>
                <td bgcolor="#FFFF99">
                  <a href="../../../data/modules/{$module/@name}/sys/introduction{$FILE_EXT}">
                    <xsl:value-of select="$module/@name"/>
                  </a>
                </td>           
                <td bgcolor="#FFFF99">
                  <a href="{$issue_href}">
                    <xsl:value-of select="$total_issues"/>
                  </a>
                </td>
                <td bgcolor="#FFFF99">
                  <a href="{$issue_href}">
                    <xsl:value-of select="$open_issues"/>
                  </a>
                </td>          
                <td bgcolor="#FFFF99">
                  <xsl:apply-templates select="$module/contacts/projlead" mode="name"/>
                </td>
                <td bgcolor="#FFFF99">
                  <xsl:apply-templates select="$module/contacts/editor" mode="name"/> 
                </td>
                <td bgcolor="#FFFF99">
                  <xsl:apply-templates select="$developer" mode="name"/>
                </td>
              </xsl:when>

              <xsl:otherwise>
                <td>
                  <xsl:value-of select="$module/@part"/>
                </td>
                <td>
                  <a href="../../../data/modules/{$module/@name}/sys/introduction{$FILE_EXT}">
                    <xsl:value-of select="$module/@name"/>
                  </a>
                </td>           
                <td>
                  <a href="{$issue_href}">
                    <xsl:value-of select="$total_issues"/>
                  </a>
                </td>
                <td>
                  <a href="{$issue_href}">
                    <xsl:value-of select="$open_issues"/>
                  </a>
                </td>
                <td>
                  <xsl:apply-templates select="$module/contacts/projlead" mode="name"/> 
                </td>
                <td>
                  <xsl:apply-templates select="$module/contacts/editor" mode="name"/>
                </td>
                <td>
                  <xsl:apply-templates select="$developer" mode="name"/>
                </td>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <td>no issue log</td>
            <td>no issue log</td>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <!-- module does not exist in repository index -->
      <xsl:otherwise>
        <td>-</td>
        <td>
          <xsl:value-of select="../@name"/>
          <xsl:call-template name="error_message">
            <xsl:with-param name="message">
              <xsl:value-of select="concat('Error ballot1: ', $module_ok)"/>
            </xsl:with-param>
          </xsl:call-template>
        </td>
      </xsl:otherwise>
    </xsl:choose>
  </tr>

</xsl:template>


</xsl:stylesheet>