<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
	$Id: sect_index_apdoc.xsl,v 1.1 2003/09/16 17:21:57 robbod Exp $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:exslt="http://exslt.org/common"
  exclude-result-prefixes="msxsl exslt"
  version="1.0">
  <xsl:import href="sect_3_defs.xsl"/>
  <xsl:import href="application_protocol.xsl"/>
  <xsl:import href="application_protocol_clause.xsl"/>

  
  <xsl:output method="html"/>
  
  <xsl:template match="application_protocol">
    <!-- get a list of normative references that have terms defined -->
    <xsl:variable name="normrefs">
      <xsl:apply-templates select="." mode="normrefs_terms_list"/>
    </xsl:variable>

    <xsl:variable name="def_section">
      <xsl:call-template name="length_normrefs_list">
        <xsl:with-param name="module_number" select="./@module_name"/>
        <xsl:with-param name="normrefs_list" select="$normrefs"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="application_protocol_dir">
      <xsl:call-template name="application_protocol_directory">
        <xsl:with-param name="application_protocol" select="@name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="aam_xml" select="document(concat($application_protocol_dir, '/aam.xml'))"/>

    <xsl:variable name="indexed_objs">
      <xsl:apply-templates select="//definition" mode="get_defn_object">
        <xsl:with-param name="definition_section" select="concat('3.',$def_section+1)"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="//purpose//module_ref" mode="get_modref_object">
        <xsl:with-param name="section" select="'Introduction'"/>
        <xsl:with-param name="href" select="concat('Introduction',$FILE_EXT)"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="//fundamentals//module_ref" mode="get_modref_object">
        <xsl:with-param name="section" select="'4.1'"/>
        <xsl:with-param name="href" select="concat('4_info_reqs',$FILE_EXT,'#41')"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="//reqtover" mode="get_modref_object">
        <xsl:with-param name="section" select="'4.2'"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="$aam_xml//activity|$aam_xml//icom"
        mode="get_aam_defn_object">
        <xsl:sort select="normalize-space(./name)"/>
      </xsl:apply-templates>

      <!-- not yet implemented - you need to get the section 
      <xsl:apply-templates select="//usage_guide" mode="get_modref_object">
        <xsl:with-param name="section" select="''"/>
        <xsl:with-param name="href" select="concat('annex_guide',$FILE_EXT)"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="//tech_disc" mode="get_modref_object">
        <xsl:with-param name="section" select="'4.2'"/>
      </xsl:apply-templates> -->
    </xsl:variable>

    <h2>
      <A NAME="index">Index</A>
    </h2>

    <xsl:choose>
      <xsl:when test="function-available('msxsl:node-set')">
        <xsl:variable name="indexed_objs_node_set" select="msxsl:node-set($indexed_objs)"/>
        <xsl:apply-templates select="$indexed_objs_node_set/*" mode="output_index_name">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
      </xsl:when>
      
      <xsl:when test="function-available('exslt:node-set')">
        <xsl:variable name="indexed_objs_node_set" select="exslt:node-set($indexed_objs)"/>
        <xsl:apply-templates select="$indexed_objs_node_set/*" mode="output_index_name">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
      </xsl:when>
      
      <xsl:otherwise>
        <xsl:message>
          Only support SAXON and MXSL XSL parsers.
        </xsl:message>
      </xsl:otherwise>    
    </xsl:choose>

  </xsl:template>

  <xsl:template match="definition" mode="get_defn_object">
    <xsl:param name="definition_section"/>
    <xsl:variable name="nterm" select="normalize-space(./term)"/>
    <xsl:variable name="element_name" 
      select="translate($nterm,' ','_')"/>

    <xsl:element name="{$element_name}">
      <xsl:attribute name="name">
        <xsl:value-of select="$nterm"/>
      </xsl:attribute>
      
      <xsl:attribute name="object_href">
        <xsl:value-of select="concat('3_defs',$FILE_EXT,'#term-',$nterm)"/>
      </xsl:attribute>
      
      <xsl:attribute name="clause_no">
        <xsl:value-of select="concat($definition_section,'.',position())"/>
      </xsl:attribute>      
    </xsl:element>
  </xsl:template>

  <xsl:template match="activity" mode="get_aam_defn_object">
    <xsl:variable name="nterm" select="normalize-space(@identifier)"/>
    <xsl:variable name="element_name"  select="translate($nterm,' ','_')"/>
    <xsl:element name="{$element_name}">
      <xsl:attribute name="name">
        <xsl:value-of select="normalize-space(./name)"/>
      </xsl:attribute>
      <xsl:attribute name="object_href">
        <xsl:value-of select="concat('annex_aam',$FILE_EXT,'#',$nterm)"/>
      </xsl:attribute>
      <xsl:attribute name="clause_no">
        <xsl:value-of select="concat('F.1.',position())"/>
      </xsl:attribute>      
    </xsl:element>
  </xsl:template>
  

  <!-- not yet implemented -->
  <xsl:template match="express_ref" mode="get_expref_object">
    <xsl:param name="section"/>
    <xsl:param name="href"/>
    <expref_object>
      <xsl:attribute name="name"/>
      <xsl:attribute name="object_href">
        <xsl:value-of select="$href"/>
      </xsl:attribute>
      <xsl:attribute name="clause_no">
        <xsl:value-of select="$section"/>
      </xsl:attribute>
    </expref_object>
  </xsl:template>

  <xsl:template match="module_ref" mode="get_modref_object">
    <xsl:param name="section"/>
    <xsl:param name="href"/>
    <xsl:variable name="module_name">
      <xsl:call-template name="module_display_name">
        <xsl:with-param name="module" select="substring-before(@linkend,':')"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="element_name" 
      select="translate(normalize-space($module_name),' ','_')"/>

    <xsl:element name="{$element_name}">
      <xsl:attribute name="name">
        <xsl:value-of select="$module_name"/>
      </xsl:attribute>
      <xsl:attribute name="object_href">
        <xsl:value-of select="$href"/>
      </xsl:attribute>
      <xsl:attribute name="clause_no">
        <xsl:value-of select="$section"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>


  <xsl:template match="reqtover" mode="get_modref_object">
    <xsl:variable name="module_name">
      <xsl:call-template name="module_display_name">
        <xsl:with-param name="module" select="@module"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="element_name" select="translate(normalize-space($module_name),' ','_')"/>

    <xsl:variable name="href" select="concat('4_info_reqs',$FILE_EXT,'#42',$module_name)"/>
    <xsl:variable name="section" select="concat('4.2.',position()+1)"/>
    <xsl:element name="{$element_name}">
      <xsl:attribute name="name">
        <xsl:value-of select="$module_name"/>
      </xsl:attribute>
      <xsl:attribute name="object_href">
        <xsl:value-of select="$href"/>
      </xsl:attribute>
      <xsl:attribute name="clause_no">
        <xsl:value-of select="$section"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="*" mode="output_index_name">
    <xsl:variable name="object_href" select="@object_href"/>
    <xsl:variable name="clause_no" select="@clause_no"/>
    <xsl:variable name="element" select="name()"/>
    <xsl:if test="count(preceding-sibling::*[name() = $element])=0">
      <!-- first one found -->
      <div>
        <xsl:value-of select="@name"/>        
      </div>
      <div>
        &#160;&#160;&#160;
        <xsl:apply-templates select="." mode="output_index_links"/>
        <xsl:apply-templates select="following-sibling::*[name() = $element]" mode="output_index_links"/>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*" mode="output_index_links">
    <xsl:variable name="object_href" select="@object_href"/>
    <xsl:variable name="clause_no" select="@clause_no"/>
    <xsl:variable name="element" select="name()"/>
    <xsl:variable name="position"
      select="count(following-sibling::*[name()=$element])"/>

    <xsl:if test="count(preceding-sibling::*[name() = $element][@clause_no=$clause_no])=0">
      <!-- only output if new clause no -->
      <xsl:choose>
        <xsl:when test="$position!=0">
          <a href="{$object_href}"><xsl:value-of select="$clause_no"/></a>,&#160;       
        </xsl:when>
        <xsl:otherwise>
          <a href="{$object_href}"><xsl:value-of select="$clause_no"/></a>        
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
