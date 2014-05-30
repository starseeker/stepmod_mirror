<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="../document_xsl.xsl" ?>
<!--
     $Id: resource_issues.xsl,v 1.4 2005/01/14 19:29:54 thendrix Exp $

  Author: Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep and supplied to NIST under contract.
  Purpose: 
     Used to display the commented XML encoded Express
     in clause 4 and 5 of a resource doc.
-->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>

  <xsl:output method="html"/>

  <!--  <xsl:import href="resdoc_toc.xsl"/> -->

  <!-- output any issues against the clause identified by type
       general | keywords | contacts | purpose | inscope | outscope
       | normrefs | definition | abbreviations
       | usage_guide | bibliography
       -->
<xsl:template match="resource" mode="output_clause_issue">
  <xsl:param name="clause"/>
  <xsl:if test="$output_issues='YES'">
    <xsl:variable name="resdoc_dir">
      <xsl:call-template name="resdoc_directory">
        <xsl:with-param name="resdoc" select="@name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="dvlp_fldr" select="@development.folder"/>
    <xsl:if test="string-length($dvlp_fldr)>0">
      <xsl:variable name="issue_file" 
        select="concat($resdoc_dir,'/dvlp/issues.xml')"/>
      <xsl:apply-templates
        select="document($issue_file)/issues/issue[@type=$clause]" 
        mode="inline_issue">
        <xsl:sort select="@status" order="descending"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template match="resource" mode="output_schema_clause_issue">
  <xsl:param name="clause"/>
  <xsl:param name="schema"/>
  <xsl:if test="$output_issues='YES'">
    <xsl:variable name="resdoc_dir">
      <xsl:call-template name="resdoc_directory">
        <xsl:with-param name="resdoc" select="@name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="dvlp_fldr" select="@development.folder"/>
    <xsl:if test="string-length($dvlp_fldr)>0">
      <xsl:variable name="issue_file" 
        select="concat($resdoc_dir,'/dvlp/issues.xml')"/>
      <xsl:apply-templates
        select="document($issue_file)/issues/issue[@type=$clause and @linkend=$schema]" 
        mode="inline_issue">
        <xsl:sort select="@status" order="descending"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:if>
</xsl:template>


<xsl:template name="output_express_issue">
  <!--       The name of the resource document 
       Compulsory parameter -->
    <xsl:param name="resdoc_name"/>
  <!--
       The name of the express schema 
       Compulsory parameter -->
  <xsl:param name="schema"/>
  
  <!-- the name of the entity, type, function, rule, procedure, constant 
       Optional parameter -->
  <xsl:param name="entity" select="''"/>
  
  <!-- if an entity, the name of an attribute 
       Optional exclusive parameter -->
  <xsl:param name="attribute" select="''"/>
  
  <!-- if an entity, the name of a where rule 
       Optional exclusive parameter -->
  <xsl:param name="where" select="''"/>

  <!-- if an entity, the name of a unique rule 
       Optional exclusive parameter -->
  <xsl:param name="unique" select="''"/>

  <!-- only proceed if global parameter "output_issues" is YES -->
  <xsl:if test="$output_issues='YES'">

    <xsl:variable name="resdoc">
      <xsl:call-template name="resdoc_name">
        <xsl:with-param name="resdoc" select="$schema"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="resdoc_dir">
      <xsl:call-template name="resdoc_directory">
        <xsl:with-param name="resdoc" select="$schema"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="resdoc_xml"
      select="concat('../../data/resource_docs/',$resdoc_name,'/resource.xml')"/>
    
    <xsl:variable name="dvlp_fldr"
      select="string(document($resdoc_xml)/resource/@development.folder)"/> 

    <xsl:if test="string-length($dvlp_fldr)>0">
    <xsl:variable name="arm_mim_ir">
      <xsl:choose>
        <xsl:when test="contains($schema,'_arm')">
          <xsl:value-of select="'arm'"/>
        </xsl:when>
        <xsl:when test="contains($schema,'_mim')">
          <xsl:value-of select="'mim'"/>
        </xsl:when>
        <xsl:when test="contains($schema,'_schema')">
          <xsl:value-of select="'ir'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'error'"/>
        </xsl:otherwise>
      </xsl:choose>      
    </xsl:variable>
    
    <xsl:variable name="xref">
      <xsl:variable name="return1">
        <xsl:choose>
          <xsl:when test="$entity">
            <xsl:value-of select="concat($schema,'.',$entity)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$schema"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <xsl:variable name="return2">
        <xsl:choose>
          <xsl:when test="$attribute">
            <xsl:value-of select="concat($return1,'.',$attribute)"/>
          </xsl:when>
          <xsl:when test="$where">
            <xsl:value-of select="concat($return1,'.wr:',$where)"/>
          </xsl:when>
          <xsl:when test="$unique">
            <xsl:value-of select="concat($return1,'.ur:',$unique)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$return1"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:value-of select="$return2"/>      
    </xsl:variable>


    <xsl:variable name="issue_file" select="concat('../../data/resource_docs/',$resdoc_name,'/dvlp/issues.xml')"/>

    <xsl:apply-templates
      select="document($issue_file)/issues/issue[@type='ir' and @linkend=$xref]" mode="inline_issue">
      <xsl:sort select="@status" order="descending"/>
    </xsl:apply-templates>

  </xsl:if>
  </xsl:if>
</xsl:template>


<xsl:template match="issue" mode="status_icon">
  <xsl:choose>
    <xsl:when test="@status = 'closed'">
      <img alt="Closed issue" 
        border="0"
        align="middle"
        src="../../../../images/closed.gif"/>
    </xsl:when>
    <xsl:otherwise>
      <img alt="Open issue"
        border="0"
          align="middle"
        src="../../../../images/issues.gif"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="issue" mode="inline_issue">
  <xsl:variable name="issue_target"
    select="translate(
            concat(string(@id), string(@by)),
            '&#xA;', '' ) "/>
  <xsl:variable name="bg_color">
    <xsl:choose>
      <xsl:when test="@status = 'closed'">
        #C0C0C0
      </xsl:when>
      <xsl:otherwise>
        #FFFF99
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="resolution">
    <xsl:choose>
      <xsl:when test="@resolution='reject'">Reject</xsl:when>
      <xsl:otherwise>Accept</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <blockquote>
    <span style="background-color: {$bg_color}">
      <b>
        <a href="../dvlp/issues{$FILE_EXT}#{$issue_target}">
          <xsl:apply-templates select="." mode="status_icon"/>
          Issue:
          <xsl:value-of select="concat(
                                string(@id), 
                                ' by ', string(@by),
                                ' (', string(@date), 
                                ') [', string(@category),', ',string(@status), ', ',$resolution,']')" />
        </a>
      </b>
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
          Registered as a Ballot comment by:
          <xsl:value-of select="@member_body"/>
        </i>
        <br/>
      </xsl:if>      

      <xsl:apply-templates/>
    </span>
  </blockquote>
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

<xsl:template match="issue_management">
  <blockquote>
    <b>Issue Management: </b>
    <xsl:for-each select="@*" >
    <xsl:value-of select="concat(name(),': ', string(.))" /><br/>
    </xsl:for-each>
    <xsl:apply-templates />
  </blockquote>
  </xsl:template>


  <xsl:template name="issue_ae_map_aname">
    <xsl:param name="linkend"/>
    <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>
    <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
    <xsl:value-of 
      select="translate(normalize-space(translate(@linkend,$UPPER,$LOWER)),' :=','')"/>
  </xsl:template>


<xsl:template match="ae"  mode="output_mapping_issue">
  <!-- only proceed if global parameter "output_issues" is YES -->
  <xsl:if test="$output_issues='YES'">
    <xsl:variable name="ae_map_aname">
      <xsl:apply-templates select="." mode="map_attr_aname"/>  
    </xsl:variable>
    <xsl:variable name="dvlp_fldr" select="/module/@development.folder"/>
    <xsl:if test="string-length($dvlp_fldr)>0">
      
      <xsl:variable name="issue_file" select="concat('../../data/modules/',../../@name,'/dvlp/issues.xml')"/>
      <xsl:for-each select="document($issue_file)/issues/issue[@type='mapping_table']">
        <xsl:variable name="linkend">
          <xsl:call-template name="issue_ae_map_aname">
            <xsl:with-param name="linkend" select="@linkend"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="$linkend=$ae_map_aname">
          <xsl:apply-templates select="." mode="inline_issue"/>
        </xsl:if>        
      </xsl:for-each>
    </xsl:if>
  </xsl:if>
</xsl:template>





</xsl:stylesheet>




