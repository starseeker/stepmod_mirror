<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
     $Id: issues.xsl,v 1.3 2002/09/10 08:54:11 robbod Exp $

  Author: Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep and supplied to NIST under contract.
  Purpose: 
     Used to display the commented XML encoded Express
     in clause 4 and 5 of a module.
-->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>

  <xsl:output method="html"/>

  <!--  <xsl:import href="module_toc.xsl"/> -->
  

<xsl:template name="output_express_issue">
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

    <xsl:variable name="module">
      <xsl:call-template name="module_name">
        <xsl:with-param name="module" select="$schema"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="module_dir">
      <xsl:call-template name="module_directory">
        <xsl:with-param name="module" select="$schema"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="module_xml"
      select="concat('../',$module_dir,'/module.xml')"/>
    
    <xsl:variable name="dvlp_fldr"
      select="string(document($module_xml)/module/@development.folder)"/> 

    <xsl:if test="string-length($dvlp_fldr)>0">
    <xsl:variable name="arm_mim">
      <xsl:choose>
        <xsl:when test="contains($schema,'_arm')">
          <xsl:value-of select="'arm'"/>
        </xsl:when>
        <xsl:when test="contains($schema,'_mim')">
          <xsl:value-of select="'mim'"/>
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


    <xsl:variable name="issue_file" select="concat('../',$module_dir,'/dvlp/issues.xml')"/>

    <xsl:apply-templates
      select="document($issue_file)/issues/issue[@type='arm' and @linkend=$xref]" mode="inline_issue">
      <xsl:sort select="@status" order="descending"/>
    </xsl:apply-templates>

    <xsl:apply-templates
      select="document($issue_file)/issues/issue[@type='mim' and @linkend=$xref]" mode="inline_issue">
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
                                ') [', string(@status),']')" />
        </a>
      </b>
      <br/>
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




<xsl:template match="aa" mode="output_mapping_issue">
  <!-- only proceed if global parameter "output_issues" is YES -->
  <xsl:if test="$output_issues='YES'">
    <xsl:variable name="aa_map_aname">
      <xsl:apply-templates select="." mode="map_attr_aname"/>  
    </xsl:variable>
    <xsl:variable name="dvlp_fldr" select="/module/@development.folder"/>
    <xsl:if test="string-length($dvlp_fldr)>0">      
      <xsl:variable name="issue_file"
        select="concat('../../data/modules/',../../../@name,'/dvlp/issues.xml')"/>

      <xsl:for-each select="document($issue_file)/issues/issue[@type='mapping_table']">
        <xsl:variable name="linkend">
          <xsl:call-template name="issue_ae_map_aname">
            <xsl:with-param name="linkend" select="@linkend"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="$linkend=$aa_map_aname">
          <xsl:apply-templates select="." mode="inline_issue"/>
        </xsl:if>        
      </xsl:for-each>
    </xsl:if>
  </xsl:if>
  </xsl:template>

</xsl:stylesheet>