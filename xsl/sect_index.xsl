<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_1_scope.xsl,v 1.6 2003/07/15 14:02:51 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: Output the Scope section as a web page
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		xmlns:exslt="http://exslt.org/common"
                version="1.0">

  <xsl:import href="module.xsl"/>
  <xsl:import href="expressg_icon.xsl"/> 

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
  <xsl:import href="module_clause.xsl"/>

    <!-- global variable - Used by templates in expressg_icon.xsl to
         resolve href for expressg icon -->
    <xsl:variable name="arm_expressg">
      <xsl:call-template name="make_arm_expressg_node_set"/>
    </xsl:variable>
    
    <!-- global variable - Used by templates in expressg_icon.xsl to
         resolve href for expressg icon -->
    <xsl:variable name="mim_expressg">
      <xsl:call-template name="make_mim_expressg_node_set"/>
    </xsl:variable>

  <xsl:output method="html"/>


<!-- overwrites the template declared in module.xsl -->
<!-- output an index of terms, arm objects, mim objects -->
<xsl:template match="module">
  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="arm_xml"
    select="document(concat($module_dir,'/arm.xml'))"/>

  <xsl:variable name="mim_xml"
    select="document(concat($module_dir,'/mim.xml'))"/>

  <xsl:variable name="definition_section">
    <xsl:apply-templates select="." mode="get_definition_section"/>
  </xsl:variable>

  <xsl:variable name="indexed_objs">
    <xsl:apply-templates select="//definition" mode="get_defn_object">
      <xsl:with-param name="definition_section" select="$definition_section"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="$arm_xml/express/schema/*" mode="get_arm_interface_object"/>
    <xsl:apply-templates select="$arm_xml/express/schema/*" mode="get_arm_object"/>
    <xsl:apply-templates select="$mim_xml/express/schema/*" mode="get_mim_interface_object"/>
    <xsl:apply-templates select="$mim_xml/express/schema/*" mode="get_mim_object"/>
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

<xsl:template match="interface" mode="get_mim_interface_object">
  <mim_interface_object>
    <xsl:attribute name="name">
      <xsl:value-of select="@schema"/>
    </xsl:attribute>
    <xsl:attribute name="clause_no">
      <xsl:value-of select="'5.2'"/>
    </xsl:attribute>
    <xsl:attribute name="object_href">
      <xsl:value-of select="concat('5_mim',$FILE_EXT,'#mim_express')"/>
    </xsl:attribute>
  </mim_interface_object>
</xsl:template>



<xsl:template
  match="constant|entity|type|rule|function|procedure|subtype.constraint"
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
      <xsl:call-template name="get_arm_expressg_href">
        <xsl:with-param name="object" select="$lentity"/>
      </xsl:call-template>
    </xsl:attribute>

    <xsl:variable name="expg_file">
      <xsl:call-template name="get_arm_expressg_file">
        <xsl:with-param name="object" select="$lentity"/>
      </xsl:call-template>
    </xsl:variable>

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

    <xsl:attribute name="map_href">
      <xsl:value-of select="concat('5_mapping',$FILE_EXT,'#',$aname)"/>
    </xsl:attribute>

    <xsl:attribute name="map_clause_no">
      <xsl:apply-templates select="." mode="clause_no"/>
    </xsl:attribute>
  </arm_object>
</xsl:template>


<xsl:template
  match="constant|entity|type|rule|function|procedure|subtype.constraint"
  mode="get_mim_object">
  <mim_object>
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
      <xsl:value-of select="concat('5_mim',$FILE_EXT,'#',$aname)"/>
    </xsl:attribute>

    <xsl:attribute name="clause_no">
      <xsl:apply-templates select="." mode="clause_no"/>
    </xsl:attribute>

    <xsl:variable name="lentity"
      select="translate(normalize-space(@name),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/> 

    <xsl:attribute name="expg_href">
      <xsl:call-template name="get_mim_expressg_href">
        <xsl:with-param name="object" select="$lentity"/>
      </xsl:call-template>
    </xsl:attribute>

    <xsl:variable name="expg_file">
      <xsl:call-template name="get_mim_expressg_file">
        <xsl:with-param name="object" select="$lentity"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="module_dir">
      <xsl:call-template name="module_directory">
        <xsl:with-param name="module" select="/express/schema/@name"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="module" select="document(concat($module_dir,'/module.xml'))"/>


    <xsl:variable name="expg_fig_no">
      <xsl:apply-templates select="$module/module/mim/express-g/imgfile"
        mode="expg_figure_no">
        <xsl:with-param name="file" select="$expg_file"/>
      </xsl:apply-templates>
    </xsl:variable>

    <xsl:attribute name="expg_figure">
      <xsl:value-of select="concat('D','.',$expg_fig_no)"/>
    </xsl:attribute>
  </mim_object>
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

<xsl:template match="mim_interface_object" mode="output_index">
  <div>
    <xsl:value-of select="@name"/>
  </div>
  <xsl:variable name="object_href" select="@object_href"/>
  <xsl:variable name="clause_no" select="@clause_no"/>
  <div>
    &#160;&#160;&#160;MIM interface
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
  <div>
    &#160;&#160;&#160;ARM EXPRESS-G
    <a href="{$expg_href}">
      <xsl:value-of select="$expg_figure"/>
    </a>
  </div>
  <div>
    &#160;&#160;&#160;mapping specification
    <a href="{$map_href}">
      <xsl:value-of select="$map_clause_no"/>
    </a>
  </div>
</xsl:template>

<xsl:template match="mim_object" mode="output_index">
  <div>
    <xsl:value-of select="@name"/>
  </div>
  <xsl:variable name="object_href" select="@object_href"/>
  <xsl:variable name="clause_no" select="@clause_no"/>
  <xsl:variable name="expg_href" select="@expg_href"/>
  <xsl:variable name="expg_figure" select="@expg_figure"/>
    <div>
    &#160;&#160;&#160;MIM object definition
    <a href="{$object_href}">
      <xsl:value-of select="$clause_no"/>
    </a>
  </div>
  <div>
    &#160;&#160;&#160;MIM EXPRESS-G
    <a href="{$expg_href}">
      <xsl:value-of select="$expg_figure"/>
    </a>
  </div>
</xsl:template>





<xsl:template match="constant|entity|type|rule|function|procedure|subtype.constraint" mode="index_arm">
  
  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="../@name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>    

  <div>
    <xsl:value-of select="@name"/>
  </div>
  
  <div>
    <xsl:variable name="object_href" select="concat('4_info_reqs',$FILE_EXT,'#',$aname)"/>

    <xsl:variable name="object_clause_no">
      <xsl:apply-templates select="." mode="clause_no"/>
    </xsl:variable>
    
    &#160;&#160;&#160;ARM object definition
    <a href="{$object_href}">
      <xsl:value-of select="$object_clause_no"/>
    </a>
  </div>

  <div>
    <xsl:variable name="lentity"
      select="translate(normalize-space(@name),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/> 

    <xsl:variable name="expg_href">
      <xsl:call-template name="get_arm_expressg_href">
        <xsl:with-param name="object" select="$lentity"/>
      </xsl:call-template>
    </xsl:variable>

    &#160;&#160;&#160;ARM diagrams 
    <a href="{$expg_href}">
      C
    </a>
  </div>

  <div>
    <xsl:variable name="map_href" select="concat('5_mapping',$FILE_EXT,'#',$aname)"/>
    &#160;&#160;&#160;mapping specification 
    <a href="{$map_href}">
      
    </a>
  </div>
</xsl:template>

    

<xsl:template match="constant|entity|type|rule|function|procedure|subtype.constraint" mode="index_mim">  
  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="../@name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>    

  <xsl:variable name="schema" select="/express/schema/@name"/>

  <xsl:variable name="href" select="concat('5_mim',$FILE_EXT,'#',$aname)"/>

  <div>
    <xsl:apply-templates select="." mode="expressg_icon"/>
    <a href="{$href}">
      <xsl:value-of select="@name"/>
    </a>
  </div>
</xsl:template>

<xsl:template match="constant|entity|type|rule|function|procedure|subtype.constraint" mode="clause_no">
  <xsl:variable name="schema" select="/express/schema/@name"/>
  <xsl:variable name="object_clause_no1">
    <xsl:call-template name="express_clause_number">
      <xsl:with-param name="clause" select="name()"/>
      <xsl:with-param name="schema_name" select="$schema"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="(position() = 1) and (count(following-sibling::*) > 0)">
      <xsl:value-of select="concat($object_clause_no1,'.',position())"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$object_clause_no1"/>
    </xsl:otherwise>
  </xsl:choose>  
</xsl:template>

<xsl:template match="ae" mode="clause_no">
  <xsl:variable name="sect_no">
    <xsl:number/>
  </xsl:variable>
  <xsl:value-of select="$sect_no"/>
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
    <xsl:call-template name="normrefs_terms_list"/>
  </xsl:variable>

  <xsl:variable name="def_section">
    <xsl:call-template name="length_normrefs_list">
      <xsl:with-param name="module_number" select="./@part"/>
      <xsl:with-param name="normrefs_list" select="$normrefs"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="concat('3.',$def_section+1)"/>
</xsl:template>


</xsl:stylesheet>
