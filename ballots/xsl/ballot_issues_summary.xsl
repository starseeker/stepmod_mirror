<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: ballot_issues_table.xsl,v 1.4 2004/09/06 16:15:24 robbod Exp $
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

  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>

  <xsl:variable name="ballot_index_file" 
    select="concat('../ballots/',./ballot/@directory,'/ballot_index.xml')"/>
  
  <xsl:variable name="ballot_index"
    select="document($ballot_index_file)/ballot_index"/>

  <xsl:variable name="ballot_date" 
    select="number(translate(substring-after($ballot_index/@ballot.start.date,'-'),'-',''))"/>

  <!-- force the application of the stylesheet to the file specified in the
       file attribute -->
  <xsl:template match="/">
    <xsl:apply-templates select="$ballot_index" mode="table">
      <xsl:with-param name="content" select="/ballot/@content"/>
      <xsl:with-param name="id_mode" select="/ballot/@id_mode"/>
      <xsl:with-param name="filter_member_body" select="normalize-space(/ballot/@filter_member_body)"/>
      <xsl:with-param name="filter_status" select="normalize-space(/ballot/@filter_status)"/>
      <xsl:with-param name="filter_ballot_comment" select="normalize-space(/ballot/@filter_ballot_comment)"/>
      <xsl:with-param name="filter_seds" select="normalize-space(/ballot/@filter_seds)"/>
      <xsl:with-param name="filter_category" select="normalize-space(/ballot/@filter_category)"/>
      <xsl:with-param name="filter_resolution" select="normalize-space(/ballot/@filter_resolution)"/>
    </xsl:apply-templates>
  </xsl:template>


<xsl:template match="ballot_index" mode="table">
  <xsl:param name="content"/>
  <xsl:param name="id_mode"/>
  <xsl:param name="filter_member_body"/>
  <xsl:param name="filter_status"/>
  <xsl:param name="filter_ballot_comment"/>
  <xsl:param name="filter_seds"/>
  <xsl:param name="filter_category"/>
  <xsl:param name="filter_resolution"/>

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
      Issues against the ballot package<br/>
      <hr/>
      <table>
        <tr>
          <td colspan="3">
            Filtered:
          </td>
        </tr>
        <tr>
          <td>&#160;</td>
          <td>
            filter_member_body:
          </td>
          <td>
            <xsl:choose>
              <xsl:when test="string-length($filter_member_body)=0">
                -
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$filter_member_body"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        
        <tr>
          <td>&#160;</td>
          <td>
            filter_status:
          </td>
          <td>
            <xsl:choose>
              <xsl:when test="string-length($filter_status)=0">
                -
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$filter_status"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td>&#160;</td>
          <td>
            filter_ballot_comment:
          </td>
          <td>
            <xsl:choose>
              <xsl:when test="string-length($filter_ballot_comment)=0">
                -
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$filter_ballot_comment"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td>&#160;</td>
          <td>
            filter_seds:
          </td>
          <td>
            <xsl:choose>
              <xsl:when test="string-length($filter_seds)=0">
                -
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$filter_seds"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td>&#160;</td>
          <td>
            filter_category:
          </td>
          <td>
            <xsl:choose>
              <xsl:when test="string-length($filter_category)=0">
                -
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$filter_category"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td>&#160;</td>
          <td>
            filter_resolution:
          </td>
          <td>
            <xsl:choose>
              <xsl:when test="string-length($filter_resolution)=0">
                -
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$filter_resolution"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
      </table>
      <hr/>

      <table class="MsoNormalTable" border="1" cellspacing="0" cellpadding="0"
        style="'border-collapse:collapse;border:none">
        <tr>
          <th width="38" valign="top" align="center">
            Id
          </th>
          <th width="321" valign="top" align="center">
            Country
          </th>
          <th width="91" valign="top" align="center">
            Part
          </th>
          <th width="91" valign="top" align="center">
            Part name
          </th>
          <th width="83" valign="top" align="center">
            Category
          </th>
          <th width="83" valign="top" align="center">
            Seds
          </th>
          <th width="83" valign="top" align="center">
            Seds Id
          </th>
          <th width="47" valign="top" align="center">
            Ballot Comment
          </th>
          <th width="47" valign="top" align="center">
            Ballot Comment Id
          </th>
          <th width="284" valign="top" align="center">
            Raised by
          </th>
          <th width="40" valign="top" align="center">
            Resolution
          </th>
          <th width="40" valign="top" align="center">
            Status
          </th>
          <th width="170" valign="top" align="center">
            Issue
          </th>
          <th width="170" valign="top" align="center">
            Comments
          </th>
        </tr>

        <xsl:apply-templates select="./*/ap_doc">
          <xsl:with-param name="content" select="$content"/>
          <xsl:with-param name="id_mode" select="$id_mode"/>
          <xsl:with-param name="filter_member_body" select="$filter_member_body"/>
          <xsl:with-param name="filter_status" select="$filter_status"/>
          <xsl:with-param name="filter_ballot_comment" select="$filter_ballot_comment"/>
          <xsl:with-param name="filter_seds" select="$filter_seds"/>
          <xsl:with-param name="filter_category" select="$filter_category"/>
          <xsl:with-param name="filter_resolution" select="$filter_resolution"/>
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="./*/module">
          <xsl:with-param name="content" select="$content"/>
          <xsl:with-param name="id_mode" select="$id_mode"/>
          <xsl:with-param name="filter_member_body" select="$filter_member_body"/>
          <xsl:with-param name="filter_status" select="$filter_status"/>
          <xsl:with-param name="filter_ballot_comment" select="$filter_ballot_comment"/>
          <xsl:with-param name="filter_seds" select="$filter_seds"/>
          <xsl:with-param name="filter_category" select="$filter_category"/>
          <xsl:with-param name="filter_resolution" select="$filter_resolution"/>
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="./*/resource">
          <xsl:with-param name="content" select="$content"/>
          <xsl:with-param name="id_mode" select="$id_mode"/>
          <xsl:with-param name="filter_member_body" select="$filter_member_body"/>
          <xsl:with-param name="filter_status" select="$filter_status"/>
          <xsl:with-param name="filter_ballot_comment" select="$filter_ballot_comment"/>
          <xsl:with-param name="filter_seds" select="$filter_seds"/>
          <xsl:with-param name="filter_category" select="$filter_category"/>
          <xsl:with-param name="filter_resolution" select="$filter_resolution"/>
          <xsl:sort select="@name"/>
        </xsl:apply-templates>

      </table>
      <p/>
    </body>
  </HTML>
</xsl:template>


<xsl:template match="module">
  <xsl:param name="content"/>
  <xsl:param name="id_mode"/>
  <xsl:param name="filter_member_body"/>
  <xsl:param name="filter_status"/>
  <xsl:param name="filter_ballot_comment"/>
  <xsl:param name="filter_seds"/>
  <xsl:param name="filter_category"/>
  <xsl:param name="filter_resolution"/>
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
          <xsl:apply-templates select="$issues/issues/issue" mode="filter">
            <xsl:with-param name="number" select="$module/@part"/>
            <xsl:with-param name="module" select="@name"/>
            <xsl:with-param name="content" select="$content"/>
            <xsl:with-param name="id_mode" select="$id_mode"/>
            <xsl:with-param name="filter_member_body" select="$filter_member_body"/>
            <xsl:with-param name="filter_status" select="$filter_status"/>
            <xsl:with-param name="filter_ballot_comment" select="$filter_ballot_comment"/>
            <xsl:with-param name="filter_seds" select="$filter_seds"/>
            <xsl:with-param name="filter_category" select="$filter_category"/>
            <xsl:with-param name="filter_resolution" select="$filter_resolution"/>
          </xsl:apply-templates>              

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
  <xsl:param name="id_mode"/>
  <xsl:param name="filter_member_body"/>
  <xsl:param name="filter_status"/>
  <xsl:param name="filter_ballot_comment"/>
  <xsl:param name="filter_seds"/>
  <xsl:param name="filter_category"/>
  <xsl:param name="filter_resolution"/>
      
  <xsl:variable name="issues_file" 
    select="concat('../../data/resource_docs/',@name,'/dvlp/issues.xml')"/>
          
  <xsl:variable name="issues"  select="document($issues_file)"/>
  <xsl:variable name="resource"
        select="document(concat('../../data/resource_docs/',@name,'/resource.xml'))/resource"/>

  <xsl:apply-templates select="$issues/issues/issue" mode="filter">
    <xsl:with-param name="number" select="$resource/@part"/>
    <xsl:with-param name="module" select="@name"/>
    <xsl:with-param name="content" select="$content"/>
    <xsl:with-param name="id_mode" select="$id_mode"/>
    <xsl:with-param name="filter_member_body" select="$filter_member_body"/>
    <xsl:with-param name="filter_status" select="$filter_status"/>
    <xsl:with-param name="filter_ballot_comment" select="$filter_ballot_comment"/>
    <xsl:with-param name="filter_seds" select="$filter_seds"/>
    <xsl:with-param name="filter_category" select="$filter_category"/>
    <xsl:with-param name="filter_resolution" select="$filter_resolution"/>
  </xsl:apply-templates>              
      
</xsl:template>


<xsl:template match="ap_doc">
  <xsl:param name="content"/>
  <xsl:param name="id_mode"/>
  <xsl:param name="filter_member_body"/>
  <xsl:param name="filter_status"/>
  <xsl:param name="filter_ballot_comment"/>
  <xsl:param name="filter_seds"/>
  <xsl:param name="filter_category"/>
  <xsl:param name="filter_resolution"/>

      
  <xsl:variable name="issues_file" 
    select="concat('../../data/application_protocols/',@name,'/dvlp/issues.xml')"/>
          
  <xsl:variable name="issues"  select="document($issues_file)"/>
  <xsl:variable name="ap_doc"
        select="document(concat('../../data/application_protocols/',@name,'/application_protocol.xml'))/application_protocol"/>

  <xsl:apply-templates select="$issues/issues/issue" mode="filter">
    <xsl:with-param name="number" select="$ap_doc/@part"/>
    <xsl:with-param name="module" select="@name"/>
    <xsl:with-param name="content" select="$content"/>
    <xsl:with-param name="id_mode" select="$id_mode"/>
    <xsl:with-param name="filter_member_body" select="$filter_member_body"/>
    <xsl:with-param name="filter_status" select="$filter_status"/>
    <xsl:with-param name="filter_ballot_comment" select="$filter_ballot_comment"/>
    <xsl:with-param name="filter_seds" select="$filter_seds"/>
    <xsl:with-param name="filter_category" select="$filter_category"/>
    <xsl:with-param name="filter_resolution" select="$filter_resolution"/>
  </xsl:apply-templates>              
      
</xsl:template>


<xsl:template match="issue" mode="filter">
  <xsl:param name="number"/>
  <xsl:param name="module"/>
  <xsl:param name="content"/>
  <xsl:param name="id_mode"/>
  <xsl:param name="filter_member_body"/>
  <xsl:param name="filter_status"/>
  <xsl:param name="filter_ballot_comment"/>
  <xsl:param name="filter_seds"/>
  <xsl:param name="filter_category"/>
  <xsl:param name="filter_resolution"/>

  <xsl:variable name="issue_date" select="number(translate(substring-after(@date,'-'),'-',''))"/>

  <xsl:variable name="country">
    <xsl:choose>
      <xsl:when test="string-length(normalize-space($filter_member_body))=0">
        <xsl:value-of select="''"/>
      </xsl:when>
      <xsl:when test="string-length(@member_body)=0">
        <xsl:value-of select="'none'"/>
      </xsl:when>
      <xsl:when test="@member_body='GB'">
        <xsl:value-of select="'UK'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@member_body"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="filter_country">
    <xsl:choose>
      <xsl:when test="$filter_member_body='GB'">
        <xsl:value-of select="'UK'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$filter_member_body"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="seds">
    <xsl:choose>
      <xsl:when test="string-length(normalize-space($filter_seds))=0">
        <xsl:value-of select="''"/>
      </xsl:when>
      <xsl:when test="@seds='yes'">
        <xsl:value-of select="'yes'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'no'"/>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:variable>

  <xsl:variable name="status">
    <xsl:choose>

      <xsl:when test="$content='open' and string-length(normalize-space($filter_status))=0">
        <!-- content is deprecated -->
        <xsl:choose>
          <xsl:when test="@status='closed'">
            <xsl:value-of select="'closed'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'open'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="string-length(normalize-space($filter_status))=0">
        <xsl:value-of select="''"/>
      </xsl:when>

      <xsl:when test="@status='closed'">
        <xsl:value-of select="'closed'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'open'"/>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:variable>

  <xsl:variable name="filter_status1">
    <xsl:choose>
      <xsl:when test="string-length(normalize-space($filter_status))=0">
        <!-- content is deprecated -->
        <xsl:choose>
          <xsl:when test="$content='open'">
            <xsl:value-of select="'open'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="''"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$filter_status"/>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:variable>

  <xsl:variable name="resolution">
    <xsl:choose>
      <xsl:when test="string-length(normalize-space($filter_resolution))=0">
        <xsl:value-of select="''"/>
      </xsl:when>
      <xsl:when test="@resolution='reject'">
        <xsl:value-of select="'reject'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'accept'"/>
      </xsl:otherwise>
    </xsl:choose>  
  </xsl:variable>

  <xsl:variable name="ballot_comment">
    <xsl:choose>
      <xsl:when test="string-length(normalize-space($filter_ballot_comment))=0">
        <xsl:value-of select="''"/>
      </xsl:when>
      <xsl:when test="@ballot_comment='no'">
        <xsl:value-of select="'no'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'yes'"/>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:variable>

  <xsl:variable name="category">
    <xsl:choose>
      <xsl:when test="string-length(normalize-space($filter_category))=0">
        <xsl:value-of select="''"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@category"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="$ballot_comment = $filter_ballot_comment and
                $country = $filter_country and
                $seds = $filter_seds and
                $category = $filter_category and
                $status = $filter_status1 and
                $resolution = $filter_resolution">
    <tr>
      <!-- Id -->
      <td valign="top" align="left">
        <xsl:value-of select="@id"/>
      </td>

      <!-- Country -->
      <td valign="top" align="left">
        <xsl:value-of select="@member_body"/>

      </td>

      <!-- Part -->
      <td valign="top" align="left">
        <xsl:value-of select="concat('10303-',$number)"/>
      </td>

      <!-- Part name-->
      <td valign="top" align="left">
        <xsl:value-of select="$module"/>
      </td>

      <!-- Category -->
      <td valign="top" align="left">
        <xsl:value-of select="@category"/>
      </td>

      <!-- Seds-->
      <td valign="top" align="left">
        <xsl:variable name="nseds" select="translate(normalize-space(@seds),$UPPER,$LOWER)"/>
        <xsl:choose>
          <xsl:when test="string-length($nseds)=0">
            no
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$nseds"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>

      <!-- Seds Id-->
      <td valign="top" align="left">
        <xsl:choose>
          <xsl:when test="string-length($nseds)=0 or $nseds='no'">
            &#160;
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@id"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>

      <!-- Ballot Comment -->
      <td valign="top" align="left">
        <xsl:variable name="nbc" select="translate(normalize-space(@ballot_comment),$UPPER,$LOWER)"/>
        <xsl:choose>
          <xsl:when test="string-length($nbc)=0">
            no
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$nbc"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>

      <!-- Ballot Comment Id -->
      <td valign="top" align="left">
        <xsl:choose>
          <xsl:when test="$nbc='no'">
            &#160;
          </xsl:when>
          <xsl:when test="string-length($nbc)=0">
            &#160;
          </xsl:when>
          <xsl:when test="string-length(@ballot_comment_id)=0">
            &#160;
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@ballot_comment_id"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>

      <!-- Raised by -->
      <td valign="top" align="left">
        <xsl:value-of select="@by"/>
      </td>

      <!-- Resolution -->
      <td valign="top" align="left">
        <xsl:choose>
          <xsl:when test="string-length(@resolution)=0">
            TBD
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@resolution"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>

      <!-- Status -->
      <td valign="top" align="left">
        <xsl:value-of select="@status"/>
      </td>

      <!-- Issue -->
      <td valign="top" align="left">
        <xsl:apply-templates select="./description"/>
      </td>

      <!-- Comments -->
      <td valign="top" align="left">
        <xsl:choose>
          <xsl:when test="./comment">
            <xsl:apply-templates select="./comment"/>
          </xsl:when>
          <xsl:otherwise>
            &#160;
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </xsl:if>
</xsl:template>

<xsl:template match="issue" mode="resolution">
  <td valign="top" align="left">
    <xsl:choose>
      <xsl:when test="@resolution='reject'">
        rejected
        <br/>
        <xsl:apply-templates select="comment"/>
      </xsl:when>
      <xsl:otherwise>
        accepted
        <br/>
        <xsl:apply-templates select="comment"/>        
      </xsl:otherwise>
    </xsl:choose>
  </td>
</xsl:template>

<xsl:template match="p">
  <xsl:apply-templates/>
</xsl:template>
<!--
<xsl:template match="comment">
  
</xsl:template>
-->
</xsl:stylesheet>