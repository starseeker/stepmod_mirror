<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
  $Id: sect_bomindex.xsl,v 1.26 2011/03/02 05:41:50 mikeward Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep.
  Purpose: Display index for a BOM document.     
-->

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:exslt="http://exslt.org/common"
  exclude-result-prefixes="msxsl exslt"
  version="1.0">

  <!--<xsl:import href="expressg_icon.xsl"/>--> 

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
  <xsl:import href="business_object_model_clause.xsl"/>
  <xsl:import href="business_object_model.xsl"/>

    <!-- global variable - Used by templates in expressg_icon.xsl to
         resolve href for expressg icon -->
    <xsl:variable name="arm_expressg">
     <!-- <xsl:call-template name="make_arm_expressg_node_set"/>-->
    </xsl:variable>
   
  <xsl:output method="html"/>


<!-- overwrites the template declared in module.xsl -->
<!-- output an index of terms, bom objects -->
  <xsl:template match="business_object_model">
   <xsl:variable name="model_dir" select="./@name"/>
   <xsl:variable name="bom_xml" select="document(concat('../../data/business_object_models', $model_dir,'/bom.xml'))"/>
   <xsl:variable name="business_object_model_xml" select="document(concat('../../data/business_object_models', $model_dir, '/business_object_model.xml'))"/>
 
   <xsl:variable name="definition_section">
     <xsl:apply-templates select="." mode="get_definition_section"/>
   </xsl:variable>

  <xsl:variable name="indexed_objs">
    <xsl:apply-templates select="//definition" mode="get_defn_object">
      <xsl:with-param name="definition_section" select="$definition_section"/>
    </xsl:apply-templates>
    <!--<xsl:apply-templates select="$arm_xml/express/schema/*" mode="get_arm_interface_object"/>
    <xsl:apply-templates select="$arm_xml/express/schema/*" mode="get_arm_object"/>    
    <xsl:apply-templates select="mapping_table/ae" mode="get_arm_object">
      <xsl:with-param name="arm_xml" select="$arm_xml" />
    </xsl:apply-templates>
    <xsl:apply-templates select="$arm_xml/express/schema/*" mode="get_arm_entity"/>-->
    
  </xsl:variable>

  <h2>
    Index
  </h2>

  <xsl:choose>
    <xsl:when test="function-available('msxsl:node-set')">
      <xsl:variable name="indexed_objs_node_set"
        select="msxsl:node-set($indexed_objs)"/>
      <xsl:apply-templates select="$indexed_objs_node_set/*" mode="output_index">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>
    </xsl:when>

    <xsl:when test="function-available('exslt:node-set')">
      <xsl:variable name="indexed_objs_node_set"
        select="exslt:node-set($indexed_objs)"/>
      <xsl:apply-templates select="$indexed_objs_node_set/*" mode="output_index">
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

<!-- not yet implemented -->
<xsl:template match="express_ref" mode="get_expref_object">
  <expref_object>
    <xsl:attribute name="name"/>
    <xsl:attribute name="object_href"/>
    <xsl:attribute name="clause_no"/>
  </expref_object>
</xsl:template>

<xsl:template match="definition" mode="get_defn_object">
  <xsl:param name="definition_section"/>
  <xsl:variable name="nterm" select="normalize-space(./term)"/>
  <defn_object>
    <xsl:attribute name="name">
      <xsl:value-of select="$nterm"/>
    </xsl:attribute>

    <xsl:attribute name="object_href">
      <xsl:value-of select="concat('3_defs',$FILE_EXT,'#term-',$nterm)"/>
    </xsl:attribute>

    <xsl:attribute name="clause_no">
      <xsl:value-of select="concat($definition_section,'.',position())"/>
    </xsl:attribute>

  </defn_object>
</xsl:template>


<xsl:template match="interface" mode="get_arm_interface_object">
  <arm_interface_object>
    <xsl:attribute name="name">
      <xsl:value-of select="@schema"/>
    </xsl:attribute>
    <xsl:attribute name="clause_no">
      <xsl:value-of select="'4.1'"/>
    </xsl:attribute>
    <xsl:attribute name="object_href">
      <xsl:value-of select="concat('4_info_reqs',$FILE_EXT,'#interfaces')"/>
    </xsl:attribute>
  </arm_interface_object>
</xsl:template>

<xsl:template
  match="constant|type|rule|function|procedure|subtype.constraint"
  mode="get_arm_object">
  <arm_object>
    <xsl:variable name="aname">
      <xsl:call-template name="express_a_name">
        <xsl:with-param name="section1" select="../@name"/>
        <xsl:with-param name="section2" select="@name"/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:attribute name="name">
      <xsl:value-of select="@name"/>
    </xsl:attribute>

    <xsl:attribute name="object_href">
      <xsl:value-of select="concat('4_info_reqs',$FILE_EXT,'#',$aname)"/>
    </xsl:attribute>

    <xsl:attribute name="clause_no">
      <xsl:apply-templates select="." mode="clause_no"/>
    </xsl:attribute>

    <xsl:variable name="lentity"
      select="translate(normalize-space(@name),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/> 

    <xsl:attribute name="expg_href">
      <!--<xsl:call-template name="get_arm_expressg_href">
        <xsl:with-param name="object" select="$lentity"/>
      </xsl:call-template>-->
    </xsl:attribute>

    <xsl:variable name="expg_file1">
      <!--<xsl:call-template name="get_arm_expressg_file">
        <xsl:with-param name="object" select="$lentity"/>
      </xsl:call-template>-->
    </xsl:variable>
    <xsl:variable name="expg_file" select="concat(substring-before($expg_file1,'.'),'.xml')"/>
      
    <xsl:variable name="module_dir">
      <xsl:call-template name="module_directory">
        <xsl:with-param name="module" select="/express/schema/@name"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="module" select="document(concat($module_dir,'/module.xml'))"/>


    <xsl:variable name="expg_fig_no">
      <xsl:apply-templates select="$module/module/arm/express-g/imgfile"
        mode="expg_figure_no">
        <xsl:with-param name="file" select="$expg_file"/>
      </xsl:apply-templates>
    </xsl:variable>

    <xsl:attribute name="expg_figure">
      <xsl:value-of select="concat('C','.',$expg_fig_no)"/>
    </xsl:attribute>

  </arm_object>
</xsl:template>

<xsl:template
  match="entity"
  mode="get_arm_object">
  <arm_entity>
    <xsl:variable name="aname">
      <xsl:call-template name="express_a_name">
        <xsl:with-param name="section1" select="../@name"/>
        <xsl:with-param name="section2" select="@name"/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="name" select="@name"/>

    <xsl:attribute name="name">
      <xsl:value-of select="$name"/>
    </xsl:attribute>

    <xsl:attribute name="object_href">
      <xsl:value-of select="concat('4_info_reqs',$FILE_EXT,'#',$aname)"/>
    </xsl:attribute>

    <xsl:attribute name="clause_no">
      <xsl:apply-templates select="." mode="clause_no"/>
    </xsl:attribute>

    <xsl:variable name="lentity"
      select="translate(normalize-space(@name),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/> 

    <xsl:attribute name="expg_href">
      <!--<xsl:call-template name="get_arm_expressg_href">
        <xsl:with-param name="object" select="$lentity"/>
      </xsl:call-template>-->
    </xsl:attribute>

    <xsl:variable name="expg_file1">
      <!--<xsl:call-template name="get_arm_expressg_file">
        <xsl:with-param name="object" select="$lentity"/>
      </xsl:call-template>-->
    </xsl:variable>
    <xsl:variable name="expg_file" select="concat(substring-before($expg_file1,'.'),'.xml')"/>

    <xsl:variable name="module_dir">
      <xsl:call-template name="module_directory">
        <xsl:with-param name="module" select="/express/schema/@name"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="module" select="document(concat($module_dir,'/module.xml'))"/>

    <xsl:variable name="expg_fig_no">
      <xsl:apply-templates select="$module/module/arm/express-g/imgfile"
        mode="expg_figure_no">
        <xsl:with-param name="file" select="$expg_file"/>
      </xsl:apply-templates>
    </xsl:variable>

    <xsl:attribute name="expg_figure">

      <xsl:value-of select="concat('C','.',$expg_fig_no)"/>
    </xsl:attribute>

    <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>
    <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
    <xsl:variable name="map_aname">
      <xsl:choose>
        <xsl:when test="name()='entity'">
          <xsl:value-of select="translate(concat('aeentity',@name),$UPPER,$LOWER)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="translate(concat('scconstraint',@name),$UPPER,$LOWER)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:attribute name="map_href">
      <xsl:value-of select="concat('5_mapping',$FILE_EXT,'#',$map_aname)"/>
    </xsl:attribute>

    <xsl:attribute name="map_clause_no">
      <xsl:apply-templates select="$module//ae[@entity=$name]|$module//sc[@constraint=$name]" mode="clause_no"/>
    </xsl:attribute>
  </arm_entity>
</xsl:template>

<xsl:template
  match="ae"
  mode="get_arm_object">
  <xsl:param name="arm_xml"/>

  <xsl:variable name="name" select="@entity"/>

  <xsl:if test="not($arm_xml/express/schema/entity[@name=$name])">
    
  <arm_entity>

    <xsl:attribute name="name">
      <xsl:value-of select="$name"/>
    </xsl:attribute>

    <xsl:variable name="lentity"
      select="translate(normalize-space(@name),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/> 

    <xsl:variable name="module_dir">
      <xsl:call-template name="module_directory">
        <xsl:with-param name="module" select="../../@name"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="module" select="document(concat($module_dir,'/module.xml'))"/>

    <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>
    <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
    <xsl:variable name="map_aname">
          <xsl:value-of select="translate(concat('aeentity',@entity),$UPPER,$LOWER)"/>
    </xsl:variable>

    <xsl:attribute name="map_href">
      <xsl:value-of select="concat('5_mapping',$FILE_EXT,'#',$map_aname)"/>
    </xsl:attribute>

    <xsl:attribute name="map_clause_no">
      <xsl:apply-templates select="$module//ae[@entity=$name]|$module//sc[@constraint=$name]" mode="clause_no"/>
    </xsl:attribute>
  </arm_entity>
</xsl:if>
</xsl:template>




<xsl:template match="defn_object" mode="output_index">
  <xsl:variable name="object_href" select="@object_href"/>
  <xsl:variable name="clause_no" select="@clause_no"/>
  <div>
    <xsl:value-of select="@name"/>
  </div>  
  <div>
    &#160;&#160;&#160;term
    <a href="{$object_href}">
      <xsl:value-of select="$clause_no"/>
    </a>
  </div>
</xsl:template>

<xsl:template match="arm_interface_object" mode="output_index">
  <div>
    <xsl:value-of select="@name"/>
  </div>
  <xsl:variable name="object_href" select="@object_href"/>
  <xsl:variable name="clause_no" select="@clause_no"/>
  <div>
    &#160;&#160;&#160;ARM interface
    <a href="{$object_href}">
      <xsl:value-of select="$clause_no"/>
    </a>
  </div>
</xsl:template>



<xsl:template match="arm_object" mode="output_index">
  <div>
    <xsl:value-of select="@name"/>
  </div>
  <xsl:variable name="object_href" select="@object_href"/>
  <xsl:variable name="clause_no" select="@clause_no"/>
  <xsl:variable name="expg_href" select="@expg_href"/>
  <xsl:variable name="expg_figure" select="@expg_figure"/>
  <xsl:variable name="map_href" select="@map_href"/>
  <xsl:variable name="map_clause_no" select="@map_clause_no"/>
  <div>
    &#160;&#160;&#160;ARM object definition
    <a href="{$object_href}">
      <xsl:value-of select="$clause_no"/>
    </a>
  </div>
  <xsl:if test="string-length(@expg_href)>0">
    <div>
      &#160;&#160;&#160;ARM EXPRESS-G
      <a href="{$expg_href}">
        <xsl:value-of select="$expg_figure"/>
      </a>
    </div>
  </xsl:if>
</xsl:template>

<xsl:template match="arm_entity" mode="output_index">
  <div>
    <xsl:value-of select="@name"/>
  </div>
  <xsl:variable name="object_href" select="@object_href"/>
  <xsl:variable name="clause_no" select="@clause_no"/>
  <xsl:variable name="expg_href" select="@expg_href"/>
  <xsl:variable name="expg_figure" select="@expg_figure"/>
  <xsl:variable name="map_href" select="@map_href"/>
  <xsl:variable name="map_clause_no" select="@map_clause_no"/>
  <xsl:if test="$clause_no">
    
  <div>
    &#160;&#160;&#160;ARM object definition
    <a href="{$object_href}">
      <xsl:value-of select="$clause_no"/>
    </a>
  </div>
  </xsl:if>
  <xsl:if test="$expg_figure">
  <div>
    &#160;&#160;&#160;ARM EXPRESS-G
    <a href="{$expg_href}">
      <xsl:value-of select="$expg_figure"/>
    </a>
  </div>
  </xsl:if>
  <div>
    &#160;&#160;&#160;mapping specification
    <a href="{$map_href}">
      <xsl:value-of select="$map_clause_no"/>
    </a>
  </div>
</xsl:template>


<xsl:template match="constant|entity|type|rule|function|procedure|subtype.constraint" mode="clause_no">
  <xsl:variable name="schema" select="/express/schema/@name"/>
  <xsl:variable name="object_clause_no1">
    <!--<xsl:call-template name="express_clause_number">
      <xsl:with-param name="clause" select="name()"/>
      <xsl:with-param name="schema_name" select="$schema"/>
    </xsl:call-template>-->
  </xsl:variable>

  <xsl:variable name="position">
    <xsl:number/>
  </xsl:variable>

  <xsl:value-of select="concat($object_clause_no1,'.',$position)"/>
</xsl:template>

<xsl:template match="ae" mode="clause_no">
  <xsl:variable name="sect_no">
    <xsl:number/>
  </xsl:variable>
  <xsl:value-of select="concat('5.1.',$sect_no)"/>
</xsl:template>

<xsl:template match="sc" mode="clause_no">
  <xsl:variable name="sect_no">
    <xsl:number/>
  </xsl:variable>
  <xsl:variable name="ae_count" select="count(//ae)" />
  <xsl:value-of select="concat('5.1.',$sect_no+$ae_count)"/>
</xsl:template>


<xsl:template match="imgfile" mode="expg_figure_no">
  <xsl:param name="file"/>
  <xsl:if test="$file=@file">
    <xsl:number/>
  </xsl:if>
</xsl:template>



<xsl:template match="module" mode="get_definition_section">
  <!-- get a list of normative references that have terms defined -->
  <xsl:variable name="normrefs">
    <!--<xsl:call-template name="normrefs_terms_list"/>-->
  </xsl:variable>

  <xsl:variable name="def_section">
   <!-- <xsl:call-template name="length_normrefs_list">
      <xsl:with-param name="module_number" select="./@part"/>
      <xsl:with-param name="normrefs_list" select="$normrefs"/>
    </xsl:call-template>-->
  </xsl:variable>
  <xsl:value-of select="concat('3.',$def_section+1)"/>
</xsl:template>


</xsl:stylesheet>
