<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: ballot_issues_table.xsl,v 1.1 2003/09/10 11:53:22 robbod Exp $
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


  <xsl:variable name="ballot_index_file" 
    select="concat('../ballots/',./ballot/@directory,'/ballot_index.xml')"/>
  
  <xsl:variable name="ballot_index"
    select="document($ballot_index_file)/ballot_index"/>

  <xsl:variable name="ballot_date" 
    select="number(translate(substring-after($ballot_index/@ballot.start.date,'-'),'-',''))"/>

  <!-- force the application of the stylesheet to the file specified in the
       file attribute -->
  <xsl:template match="/">
    <xsl:apply-templates select="$ballot_index" mode="eight_col">
      <xsl:with-param name="content" select="/ballot/@content"/>
    </xsl:apply-templates>
  </xsl:template>


<xsl:template match="ballot_index" mode="eight_col">
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
        <xsl:apply-templates select="./*/resource">
          <xsl:with-param name="content" select="$content"/>
          <xsl:sort select="@name"/>
        </xsl:apply-templates>

      </table>
      <p/>
    </body>
  </HTML>
</xsl:template>



<xsl:template match="ballot_index" mode="seven_col">
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
            (6)
          </td>
          <td width="284" valign="top" align="center">
            (7)
          </td>
        </tr>
        <tr>
          <td width="38" valign="top" align="center">
            <b>MB1</b>
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
        <xsl:apply-templates select="./*/resource">
          <xsl:with-param name="content" select="$content"/>
          <xsl:sort select="@name"/>
        </xsl:apply-templates>

      </table>
      <p/>
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
            <xsl:when test="$content='open'">
              <xsl:apply-templates select="$issues/issues/issue[@status='open']">
                <xsl:with-param name="number" select="$module/@part"/>
                <xsl:with-param name="module" select="@name"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="$content='postballot'">
              <xsl:apply-templates select="$issues/issues/issue" mode="postballot">
                <xsl:with-param name="number" select="$module/@part"/>
                <xsl:with-param name="module" select="@name"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="$content='results'">
            </xsl:when>
            <xsl:when test="$content='ballot'">
              <!-- display all ballot comments + resolution -->
              <xsl:apply-templates select="$issues/issues/issue" mode="ballot">
                <xsl:with-param name="number" select="$module/@part"/>
                <xsl:with-param name="module" select="@name"/>
              </xsl:apply-templates>              
            </xsl:when>
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


<xsl:template match="resource">
  <xsl:param name="content"/>
      
  <xsl:variable name="issues_file" 
    select="concat('../../data/resource_docs/',@name,'/dvlp/issues.xml')"/>
          
  <xsl:variable name="issues"  select="document($issues_file)"/>
  <xsl:variable name="resource"
        select="document(concat('../../data/resource_docs/',@name,'/resource.xml'))/resource"/>
      
  <xsl:choose>
    <xsl:when test="$content='all'">
      <xsl:apply-templates select="$issues/issues/issue">
        <xsl:with-param name="number" select="$resource/@part"/>
        <xsl:with-param name="module" select="@name"/>
      </xsl:apply-templates>              
    </xsl:when>
    <xsl:when test="$content='open'">
      <xsl:apply-templates select="$issues/issues/issue[@status='open']">
        <xsl:with-param name="number" select="$resource/@part"/>
        <xsl:with-param name="module" select="@name"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="$content='postballot'">
      <xsl:apply-templates select="$issues/issues/issue" mode="postballot">
        <xsl:with-param name="number" select="$resource/@part"/>
        <xsl:with-param name="module" select="@name"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="$content='results'">
    </xsl:when>
    <xsl:when test="$content='ballot'">
      <!-- display all ballot comments + resolution -->
      <xsl:apply-templates select="$issues/issues/issue" mode="ballot">
        <xsl:with-param name="number" select="$resource/@part"/>
        <xsl:with-param name="module" select="@name"/>
      </xsl:apply-templates>              
    </xsl:when>
  </xsl:choose>
</xsl:template>



<xsl:template match="issue">
  <xsl:param name="number"/>
  <xsl:param name="module"/>

  <tr>
  <!-- 1 -->
  <td valign="top" align="left">
    <xsl:value-of select="@by"/>
    <!-- <xsl:value-of select="concat('UK-',$number,'-',position())"/> -->
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


<!-- All issues AFTER the start of the ballot OR that are ballot issues  -->
<xsl:template match="issue" mode="postballot">
  <xsl:param name="number"/>
  <xsl:param name="module"/>

  <xsl:variable name="issue_date" select="number(translate(substring-after(@date,'-'),'-',''))"/>

  <xsl:variable name="country">
    <xsl:choose>
      <xsl:when test="string-length(@member_body)=0">
        <xsl:value-of select="'none'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@member_body"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="raised_as_ballot">
    <xsl:choose>
      <xsl:when test="@ballot_comment='yes'">
        <xsl:value-of select="'yes'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'no'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


  <!-- used to generate UK comments -->
  <!--
  <xsl:if test="(@ballot_comment='yes' and $country='GB')
                or ($issue_date>$ballot_date and
    contains(substring-before(@date,'-'),'03') and $country='none')">

-->
    <xsl:if test="contains(@id,'RNTRILS')">

    <!--
  <xsl:if test="(@ballot_comment='yes')">
-->
    <tr>
      <!-- 1 -->
      <td valign="top" align="left">
      <!--
      <xsl:value-of select="concat('UK-',$number,'-',position())"/> <br/>
      -->
      Issue: <xsl:value-of select="concat($module,'.',@id)"/><br/>



      <xsl:if test="@ballot_comment!='yes'"></xsl:if>
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
      
      <td  valign="top" align="left">
        <xsl:choose>
          <xsl:when test="description">
            <xsl:if test="string-length(@linkend)!=0">
              <xsl:value-of select="@linkend"/><br/>
            </xsl:if>
            <xsl:apply-templates select="description"/>
            <p>
              <small>
                Note registered as issue: 
                <xsl:value-of select="concat(/issues/@module,' ',./@id)"/>
              </small>
            </p>
          </xsl:when>
          <xsl:otherwise>
            <td valign="top" align="center">&#160;</td>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      
      
      <td valign="top" align="center">&#160;</td>
      <td valign="top" align="center">&#160;</td>
    </tr>
  </xsl:if>
</xsl:template>


<!-- All issues that are ballot issues  -->
<xsl:template match="issue" mode="ballot">
  <xsl:param name="number"/>
  <xsl:param name="module"/>

  <xsl:variable name="issue_date" select="number(translate(substring-after(@date,'-'),'-',''))"/>

  <xsl:variable name="country">
    <xsl:choose>
      <xsl:when test="string-length(@member_body)=0">
        <xsl:value-of select="'none'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@member_body"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="raised_as_ballot">
    <xsl:choose>
      <xsl:when test="@ballot_comment='yes'">
        <xsl:value-of select="'yes'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'no'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


  <xsl:if test="$raised_as_ballot='yes' and $country='NO'">

    <tr>
      <!-- MB -->
      <td valign="top" align="left">
        <xsl:value-of select="$country"/><br/>
      </td>
           
      <!-- SC4 part no -->
      <td valign="top" align="left">
        <xsl:value-of select="concat('103030-',$number)"/>
        <br/>
        <xsl:value-of select="$module"/>
      </td>

      <!-- Clause -->
      <td valign="top" align="left">        
        <xsl:value-of select="@type"/>
        <xsl:if test="string-length(@linkend)!=0">
          <br/>
          <xsl:value-of select="@linkend"/>
        </xsl:if>
      </td>

      <!-- para figure -->
      <td valign="top" align="center">&#160;</td>
            
      <td valign="top" align="center">
        <xsl:choose>
          <xsl:when test="contains(@category,'technical')">
            te
          </xsl:when>
          <xsl:when test="@category='editorial'">
            ed
          </xsl:when>
          <xsl:otherwise>
            ge
          </xsl:otherwise>
        </xsl:choose>
      </td>
      
      <td  valign="top" align="left">
        <xsl:choose>
          <xsl:when test="description">
            <xsl:apply-templates select="description"/>
            <p>
              <small>
                Note registered as issue: 
                <xsl:value-of select="concat(/issues/@module,' ',./@id)"/>
              </small>
            </p>
          </xsl:when>
          <xsl:otherwise>
            <td valign="top" align="center">&#160;</td>
          </xsl:otherwise>
        </xsl:choose>
      </td>

      <td valign="top" align="center">&#160;</td>

            
      <xsl:apply-templates select="." mode="resolution"/>
    </tr>
  </xsl:if>
</xsl:template>

<xsl:template match="issue" mode="resolution">
  <td valign="top" align="left">
    <xsl:choose>
      <xsl:when test="@resolution='reject'">
        Comment rejected
        <br/>
        <xsl:apply-templates select="comment"/>
      </xsl:when>
      <xsl:otherwise>
        Comment accepted
        <br/>
        <xsl:apply-templates select="comment"/>        
      </xsl:otherwise>
    </xsl:choose>
  </td>
</xsl:template>

<!--
<xsl:template match="comemnt">
  
</xsl:template>
-->
</xsl:stylesheet>