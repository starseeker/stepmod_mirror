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
    indent="yes"/>

  <!-- force the application of the stylesheet to the file specified in the
       file attribute -->
  <xsl:template match="/">
    <xsl:variable name="ballot_index" 
      select="concat('../ballots/',./ballot/@directory,'/ballot_index.xml')"/>
    <xsl:apply-templates select="document($ballot_index)/ballot_index">
      <xsl:with-param name="content" select="/ballot/@content"/>
    </xsl:apply-templates>
  </xsl:template>

<xsl:template match="ballot_index">
  <xsl:param name="content"/>
  <HTML>
    <head>
      <title>
        <xsl:value-of select="@name"/>
      </title>

      <style>
        body { font-family: Verdana, Arial, Helvetica;
		font-weight: normal;
		font-size: 9pt;  
		font-style: normal  }

        p.ISOParagraph, li.ISOParagraph, div.ISOParagraph
        {margin-top:10.5pt;
	margin-right:0cm;
	margin-bottom:0cm;
	margin-left:0cm;
	margin-bottom:.0001pt;
	line-height:10.5pt;
	font-size:9.0pt;
	font-family:Arial;}
      </style>
    </head>
    <body>
      <xsl:call-template name="output_menubar">
        <xsl:with-param name="module_root" select="'.'"/>
        <xsl:with-param name="module_name" select="@name"/>
        <xsl:with-param name="new_menubar_file" 
          select="concat('./ballots/ballots/',@name,'/menubar_ballot.xml')"/>
      </xsl:call-template>
      <hr/>
      ISO-TC184SC4-Comment-Form-2003-04 - Template for comments and secretariat observations
      <hr/>
      <table class="MsoNormalTable" border="1" cellspacing="0" cellpadding="0"
        style="'border-collapse:collapse;border:none">
        <tr>
          <td width="38" valign="top" align="center">
            1
          </td>
          <td width="91" valign="top" align="center">
            2
          </td>
          <td width="91" valign="top" align="center">
            (3)
          </td>
          <td width="83" valign="top" align="center">
            4
          </td>
          <td width="47" valign="top" align="center">
            5
          </td>
          <td width="321" valign="top" align="center">
            6
          </td>
          <td width="284" valign="top" align="center">
            (7)
          </td>
          <td width="170" valign="top" align="center">
            (8)
          </td>
        </tr>
        <tr>
          <td width="38" valign="top" align="center">
            <b>MB1</b>
          </td>
          <td width="91" valign="top" align="center">
            <p>
              <b>SC4 Part no</b>
            </p>
            <p>
              (nnnnn-pppp)
            </p>
          </td>
          <td width="91" valign="top" align="center">
           <b> Clause No./
            Subclause No./
            Annex</b>
           <br/>
            (e.g. 3.1)
          </td>
          <td width="83" valign="top" align="center">
            <b>Paragraph/
            Figure/Table/Note</b>
           <br/>
            (e.g. Table 1)
          </td>
          <td width="47" valign="top" align="center">
            <b>Type of comment<sup>2</sup></b>
          </td>
          <td width="321" valign="top" align="center">
            <b>Comment (justification for change) by the MB</b>
          </td>
          <td width="284" valign="top" align="center">
            <b>Proposed change by the MB</b>
          </td>
          <td width="170" valign="top" align="center">
            <b>Secretariat observations
            on each comment submitted</b>
          </td>
        </tr>
        <xsl:apply-templates select="./*/module">
      <xsl:with-param name="content" select="$content"/>
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
      </table>

    </body>
  </HTML>
</xsl:template>

<xsl:template match="module">
  <xsl:param name="content"/>
  <xsl:variable name="module_ok">
    <xsl:call-template name="check_module_exists">
      <xsl:with-param name="module" select="@name"/>
    </xsl:call-template>
  </xsl:variable>
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
          
          <xsl:variable name="issues_file" 
            select="concat('../../data/modules/',$module/@name,'/',$module/@development.folder,'/issues.xml')"/>
          
          <xsl:variable name="issues"  select="document($issues_file)"/>
          <xsl:choose>
            <xsl:when test="$content='all'">
              <xsl:apply-templates select="$issues/issues/issue">
                <xsl:with-param name="number" select="$module/@part"/>
                <xsl:with-param name="module" select="@name"/>
              </xsl:apply-templates>              
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="$issues/issues/issue[@status='open']">
                <xsl:with-param name="number" select="$module/@part"/>
                <xsl:with-param name="module" select="@name"/>
              </xsl:apply-templates>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <td>no issue log</td>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <!-- module does not exist in repository index -->
    <xsl:otherwise>
      <tr>
        <td>-</td>
        <td>-</td>
        <td>
          <xsl:value-of select="../@name"/>
          <xsl:call-template name="error_message">
            <xsl:with-param name="message">
              <xsl:value-of select="concat('Error ballot1: ', $module_ok)"/>
            </xsl:with-param>
          </xsl:call-template>
        </td>
        <td>-</td>
        <td>-</td>
        <td>-</td>
        <td>-</td>
      </tr>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<xsl:template match="issue">
  <xsl:param name="number"/>
  <xsl:param name="module"/>

  <tr>
  <!-- 1 -->
  <td valign="top" align="left">
    <!-- <xsl:value-of select="@by"/> -->
    <xsl:value-of select="concat('UK-',$number,'-',position())"/>
  </td>
  

  <td valign="top" align="left">
    <xsl:value-of select="concat('103030-',$number)"/>
    <br/>
    <xsl:value-of select="$module"/>
  </td>

  <td valign="top" align="center">
    <xsl:value-of select="@type"/>
  </td>

  <td valign="top" align="center">&#160;</td>

  <td valign="top" align="center">
    <xsl:value-of select="@category"/>
  </td>

  <td align="left">
    <xsl:choose>
      <xsl:when test="description">
        <xsl:if test="string-length(@linkend)!=0">
          <xsl:value-of select="@linkend"/><br/>
        </xsl:if>
        <xsl:apply-templates select="description"/>
      </xsl:when>
      <xsl:otherwise>
        <td valign="top" align="center">&#160;</td>
      </xsl:otherwise>
    </xsl:choose>
  </td>


  <td valign="top" align="center">&#160;</td>
  <td valign="top" align="center">&#160;</td>
</tr>
</xsl:template>


</xsl:stylesheet>