<?xml version="1.0"?>
<!--
     $Id: express.xsl,v 1.2 2001/10/05 15:35:00 robbod Exp $

  Author: Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep and supplied to NIST under contract.
  Purpose: 
     Used to establish links (URLs) for entities and types that are
     referenced in a schema 
-->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>

  <xsl:output method="html"/>


<!--
     Given a schema name return the path to the express file.
     It is assumed that every module is stored in a directory which is
     given the name of the module.
     It is also assumed that all short form schema end in _mim or _arm
     If they do not then the schema is an IR.
     All IRs 
     If the entity is interfaced to through the schema interface, 
     this function will set up the URL to the interface - not the original
     entity - which may be accessed through a series of interface objects.
     To set a URL to the entity, rather than the interface object that
     included the entity, use the template top_express_file
-->
<xsl:template name="express_file">
  <xsl:param name="schema_name"/>

  <!-- utility var to make it easier to strip out the schema name -->
  <xsl:variable name="schema_name_tmp"
    select="concat($schema_name,';')"/>

  <xsl:variable name="filepath">
    <xsl:choose>
      <xsl:when test="/express/schema[@name=$schema_name]">
        <!-- The schema is defined in this file, so return nothing 
             This caters for multiple schemas in a single file
             -->
        <xsl:value-of select="''"/>
      </xsl:when>

      <xsl:when test="contains($schema_name_tmp,'_mim;')">
        <xsl:value-of 
          select="concat('../',substring-before($schema_name_tmp,'_mim;'),
                  '/mim',$FILE_EXT)"/>
      </xsl:when>

      <xsl:when test="contains($schema_name_tmp,'_arm;')">
        <xsl:value-of 
          select="concat('../',substring-before($schema_name_tmp,'_arm;'),
                  '/arm',$FILE_EXT)"/>
      </xsl:when>

      <xsl:otherwise>
        <xsl:value-of 
          select="concat('../../resources/',$schema_name,$FILE_EXT)"/>
      </xsl:otherwise>

    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$filepath"/>  
</xsl:template>

<!-- 
     Output a HREF for the schema
     Check to see whether the schema is in the current file, 
     If not, then it is assumed that all short form schema end in _mim or
     _arm 
     If they do not then the schema is an IR.
     -->
<xsl:template name="link_schema">
  <xsl:param name="schema_name"/>
  <xsl:variable name="express_file">
    <xsl:call-template name="express_file">
      <xsl:with-param 
        name="schema_name" 
        select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable 
    name="xref"
    select="concat($express_file,'#','index_',$schema_name)"/>
  <A HREF="{$xref}">
    <xsl:value-of select="$schema_name"/>
  </A>

</xsl:template>

<!--
     Output HREF URL for an Express object (either a TYPE or ENTITY)
     The object may be defined within a schema in the current file,
     or through a USE-FROM or REFERENCE interface.
     If it is a USE-FROM or REFERENCE, the schema defined in the interface
     may be defined in this file or externally
     If it is defined externally, then call link_object_rec to resolve.
-->
<xsl:template name="link_object">
  <xsl:param name="object_name"/>
  <!-- the schema in which the object has been used -->
  <xsl:param name="object_used_in_schema_name"/>

  <xsl:variable name="schema_node" 
    select="//express/schema[@name=$object_used_in_schema_name]"/>

  <xsl:choose>
    <xsl:when
      test="$schema_node/entity|type[@name=$object_name]">
      <!-- the object is defined within the schema it is used, so link to
           this file --> 
      <xsl:variable 
        name="xref"
        select="concat('#',$object_used_in_schema_name,'.',$object_name)"/>
      <A HREF="{$xref}">
        <xsl:value-of select="$object_name"/>
      </A>
    </xsl:when>

    <xsl:otherwise>
      <xsl:call-template name="link_object_rec">
        <xsl:with-param name="object_name" select="$object_name"/>
        <xsl:with-param name="object_used_in_schema_name" 
          select="$object_used_in_schema_name"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
     Called from link_object
     Output HREF URL for an Express object (either a TYPE or ENTITY)
     The object may be defined within a schema in the current file,
     or through a USE-FROM or REFERENCE interface.
     If it is a USE-FROM or REFERENCE, the schema defined in the interface
     may be defined in this file or externally
     If it is defined externally, then call link_object_rec to resolve.

     -->
<xsl:template name="link_object_rec">
  <xsl:param name="object_name"/>
  <!-- the schema in which the object has been used -->
  <xsl:param name="object_used_in_schema_name"/>

  <xsl:variable name="schema_node" 
    select="//express/schema[@name=$object_used_in_schema_name]"/>

  <!--
       [Z:<xsl:value-of
select="concat('Z',$object_used_in_schema_name,':',$schema_node/@name)"/>]
-->
  <xsl:choose>
    <xsl:when
      test="$schema_node/entity|type[@name=$object_name]">
      <!-- the object is defined within the schema it is used, so link to
           this file --> 

      <xsl:variable name="express_file">
        <xsl:call-template name="express_file">
          <xsl:with-param 
            name="schema_name" 
            select="$object_used_in_schema_name"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:variable 
        name="xref"
        select="concat($express_file,'#',$object_used_in_schema_name,'.',$object_name)"/>
              <!--
                   debug
                   [xref:<xsl:value-of select="$xref"/>]
                   -->
      <A HREF="{$xref}">
        <xsl:value-of select="$object_name"/>
      </A>
    </xsl:when>

    <xsl:when
      test="$schema_node/interface/interfaced.item[@name=$object_name]"> 
      <!-- the schema of the object being interfaced has been explicitly
           identified as being interfaced from a schema, now get the file
           that is being interfaced, 
           check that the entity is defined in that file, if not, 
           recurse -->

      <!-- first get the express file for the schema being interfaced to
           -->
      <xsl:variable 
        name="if_schema_name"
        select="$schema_node/interface/@schema"/>

      <xsl:variable name="express_file">
        <xsl:call-template name="express_file">
          <xsl:with-param 
            name="schema_name" 
            select="$schema_node/interface/@schema"/>
        </xsl:call-template>
      </xsl:variable>

        <!--
             debug
             [Q:<xsl:value-of
             select="concat($express_file,':',$if_schema_name)"/>]
             -->
      <!-- check whether the object is in the file -->
      <xsl:for-each
        select="document($express_file)//express/schema[@name=$if_schema_name]">
        <!-- changed focus to the interfaced document - there should only
             be one. Now recurse-->
        <xsl:call-template name="link_object_rec">
          <xsl:with-param name="object_name" select="$object_name"/>
          <xsl:with-param 
            name="object_used_in_schema_name" 
            select="$if_schema_name"/>
        </xsl:call-template>,
      </xsl:for-each>
    </xsl:when>

    <xsl:otherwise>
      <!-- the object being interfaced has not been explicitly
           identified in an interface so must be defined in one of the
           schemas that have been interfaced, so loop through them -->
      <xsl:for-each select="$schema_node/interface">
        <!-- first get the express file for the schema being interfaced to
           -->
        <xsl:variable 
          name="if_schema_name"
          select="$schema_node/interface/@schema"/>

        <xsl:variable name="express_file">
          <xsl:call-template name="express_file">
            <xsl:with-param 
              name="schema_name" 
              select="$if_schema_name"/>
          </xsl:call-template>
        </xsl:variable>
        <!--
             debug
             [PP:<xsl:value-of
select="concat($express_file,':',$if_schema_name)"/>]
             -->
        <!-- check whether the object is in the file -->
        <xsl:for-each
          select="document($express_file)//express/schema[@name=$if_schema_name]">
          <!-- changed focus to the interfaced document - there should only
               be one. Now recurse-->
          <xsl:call-template name="link_object_rec">
            <xsl:with-param name="object_name" select="$object_name"/>
            <xsl:with-param 
              name="object_used_in_schema_name" 
              select="$if_schema_name"/>
          </xsl:call-template>,
        </xsl:for-each>
      </xsl:for-each>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<!-- 
     Recurse through a list of select items and output the list as a set of
     URLS
     prefix and suffix are the prefixes and suffixes to be added to each
     object in the list
-->
<xsl:template name="link_list">
  <xsl:param name="list"/>
  <xsl:param name="object_used_in_schema_name"/>
  <xsl:param name="prefix"/>
  <xsl:param name="suffix"/>


  <xsl:variable name="nlist"
    select="translate(normalize-space($list),' ',',')"/>
  <xsl:choose>
    <xsl:when test="contains($nlist,',')">
      <xsl:variable name="first"
        select="substring-before($nlist,',')"/>
      <xsl:variable name="rest"
        select="substring-after($nlist,',')"/>


      <xsl:call-template name="output-fix">
        <xsl:with-param name="fix" select="$prefix"/>
      </xsl:call-template>
      <xsl:call-template name="link_object">
        <xsl:with-param name="object_name" select="$first"/>
        <xsl:with-param 
          name="object_used_in_schema_name" 
          select="$object_used_in_schema_name"/>
      </xsl:call-template>
      <xsl:call-template name="output-fix">
        <xsl:with-param name="fix" select="$suffix"/>
      </xsl:call-template>

      <xsl:call-template name="link_list">
        <xsl:with-param name="prefix" select="$prefix"/>
        <xsl:with-param name="suffix" select="$suffix"/>
        <xsl:with-param name="list" select="$rest"/>
        <xsl:with-param 
          name="object_used_in_schema_name" 
          select="$object_used_in_schema_name"/>
      </xsl:call-template>

    </xsl:when>
    <xsl:otherwise>
      <!-- end of recursion -->
      <xsl:call-template name="output-fix">
        <xsl:with-param name="fix" select="$prefix"/>
      </xsl:call-template>

      <xsl:call-template name="link_object">
        <xsl:with-param name="object_name" select="$nlist"/>
        <xsl:with-param 
          name="object_used_in_schema_name" 
          select="$object_used_in_schema_name"/>
      </xsl:call-template>
      
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="output-fix">
  <xsl:param name="fix"/>
  <xsl:choose>
    <xsl:when test="$fix='br'">
      <br/>      
    </xsl:when>
    <xsl:when test="$fix='br'">
      <p/>      
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$fix"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



</xsl:stylesheet>
