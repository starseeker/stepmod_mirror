<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
     $Id: projmg.xsl,v 1.5 2002/10/08 16:05:46 mikeward Exp $
-->

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
>

  <!-- need both for resource doc TOC -->
 <xsl:import href="../res_doc/sect_4_express.xsl"/>
  <xsl:import href="../res_doc/res_toc.xsl"/>

  <xsl:output method="html"/>


  
  <xsl:template match="/">
    <HTML>
      <TITLE>
        <xsl:value-of select="concat(/management/@resource,' - status')"/>
      </TITLE>
      <BODY>

        <xsl:apply-templates />
      </BODY>
    </HTML>
  </xsl:template>

  
  <xsl:template match="management">
        <!-- Output a Table of contents -->
        <xsl:variable name="resdoc_name" select="@resource"/>

        TEHTEHTEH resdoc_name:<xsl:value-of select="$resdoc_name" />:resdoc_name

        <xsl:variable name="resdoc_file"
          select="concat('../../data/resource_docs/',@resource,'/resource.xml')"/>

        <xsl:message>
          before in_repo
        </xsl:message>

        <xsl:variable name="in_repo"
          select="document('../../data/resource_docs/resdoc_index.xml')/resource_docs/resource_docs[@name=$resdoc_name]"/>

        <xsl:message>
          in_repo after select
        </xsl:message>

        <xsl:choose>
          <!-- the resource doc is present in the STEP resource doc repository -->
          <xsl:when test="$in_repo">

        <xsl:message>
          in_repo after test in repo
        </xsl:message>

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
                                        ' does not exist in stepmod/resource_docs/resdoc_index.xml')"/>
                </xsl:with-param>
              </xsl:call-template>
            </p>
          </xsl:otherwise>
        </xsl:choose>


    <xsl:variable name="xref" 
      select="concat('../sys/1_scope',$FILE_EXT)"/>
    <table border="1">
      <tr>
        <td colspan="2" valign="middle">
          <h2>
            Integrated generic resource: 
            <a href="{$xref}">
              <xsl:value-of select="@resource"/>
            </a>
          </h2>
        </td>
      </tr>
      <tr>
        <td valign="top">
        <i>Percentage complete: </i>
        <b><xsl:value-of select="string(@percentage_complete)"/>%</b>
        <br/>
        <xsl:if test="@issues">
          <xsl:variable name="no_issues"
            select="count(document(@issues)/issues/issue)"/>
          <i>Total <a href="issues.xml">issues</a>:</i>
          <xsl:value-of select="$no_issues"/>
          <br/>
          <xsl:variable name="closed_issues"
            select="count(document(@issues)/issues/issue[@status = 'closed'])"/>
          <i>Open <a href="issues.xml">issues</a>: </i>
          <xsl:value-of select="$no_issues - $closed_issues"/>
          <br/>
        </xsl:if>
        <xsl:apply-templates select="developers"/> 
      </td>
      <td valign="top">
        <xsl:apply-templates select="resource.milestones"/>
      </td>
      </tr>
    </table>

    <xsl:apply-templates select="resource.checklist"/> 
  </xsl:template>

  <xsl:template match="resource.milestones">
    <b>Milestones:</b>
    <br/>
      <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="milestone">
      &#x20;&#x20;<b><xsl:value-of select="@name"/></b>&#x20;
      <i><xsl:value-of select="@description"/></i>&#x20;&#x20;
      <b><xsl:value-of select="@status"/></b>
      <br/>
      <small>
        &#160;&#160;&#160;&#160;&#160;Planned:
        <xsl:choose>
          <xsl:when test="string-length(@planned_date)!=0">
            <xsl:value-of select="@planned_date"/>
          </xsl:when>
          <xsl:otherwise>-</xsl:otherwise>
        </xsl:choose>

        &#160;&#160;&#160;Predicted
        <xsl:choose>
          <xsl:when test="string-length(@predicted_date)!=0">
            <xsl:value-of select="@predicted_date"/>
          </xsl:when>
          <xsl:otherwise>-</xsl:otherwise>
        </xsl:choose>

        &#160;&#160;&#160;Achieved
        <xsl:choose>
          <xsl:when test="string-length(@achieved_date)!=0">
            <xsl:value-of select="@achieved_date"/>
          </xsl:when>
          <xsl:otherwise>-</xsl:otherwise>
        </xsl:choose>
      <br/>
    </small>
    <xsl:apply-templates select="./status"/>
  </xsl:template>

  <xsl:template match="status">
    <blockquote>
      <small>
      <b>Status update by <xsl:value-of select="concat(string(@by),' on ', string(@date))"/></b>
    <br/>
    <i>Status: </i><b><xsl:value-of select="string(@status)" /></b>
    <br/>
    <i>Comment: </i>
    <xsl:apply-templates select="description"/>
  </small>
  </blockquote>
  </xsl:template>


  <xsl:template match="developers">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="developer">
  <xsl:variable name="ref" select="@ref"/>
  <xsl:variable name="contact"
    select="document('../../data/basic/contacts.xml')/contact.list/contact[@id=$ref]"/>
  <i>Developer: </i>
  <xsl:choose>
    <xsl:when test="$contact">
      <xsl:apply-templates select="$contact"/>      
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="error_message">
        <xsl:with-param name="message">
          Error pm1: No contact provided for developer.
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
  </xsl:template>

<xsl:template match="contact">
  <xsl:apply-templates select="firstname"/>
  &#x20;
  <xsl:apply-templates select="lastname"/>
  &#x20;&#x20;
  <xsl:apply-templates select="email"/>
</xsl:template>

<xsl:template match="firstname | lastname">
  <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="email">
  <xsl:variable name="mailto" select="concat('mailto:',.)"/>
  (<a href="{$mailto}">
    <xsl:value-of select="."/>
  </a>)
  <br/>
</xsl:template>



  <xsl:template match="resource.checklist">
    <xsl:apply-templates select="./status" mode="checklist"/>
  </xsl:template>


  <xsl:template match="status" mode="checklist">
    <b><xsl:value-of select="concat('Check ',position(),' - ',@section)"/></b>
    <xsl:variable name="checklist">
      <xsl:choose>
        <xsl:when test="@section='module.header'">
          check that the module header information is correct:
          Module name, part number, WG number, version, status,
          publication date, keywords, contacts
        </xsl:when>


        <xsl:when test="@section='resource.intro'">
          check that the module:
          purpose, scope, normative references, Units of functionality
        </xsl:when>


        <xsl:when test="substring(@section, string-length(@section)- 10) = '_schema.xml'">
          check that the Express has been documented. 
        </xsl:when>

        <xsl:when test="substring(@section, string-length(@section)- 8) = '_expressg'">
          check that the EXPRESS-G diagram has been drawn. 
        </xsl:when>
        
      </xsl:choose>

    </xsl:variable>
    <xsl:if test="$checklist">
      <br/>
      <small>
        <i>
          <xsl:value-of select="$checklist"/>
        </i>
      </small>
    </xsl:if>
    <blockquote>
    Checked by <xsl:value-of select="concat(string(@by),' on ', string(@date))" />
    <br/>
    <i>Status: </i><b><xsl:value-of select="string(@status)" /></b>
    <br/>
    <i>Comment: </i>
    <xsl:apply-templates select="description"/>
  </blockquote>
  </xsl:template>

  <xsl:template match="description">
    <xsl:apply-templates />
  </xsl:template>

  
</xsl:stylesheet>