<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_resindex.xsl,v 1.5 2003/08/04 07:50:15 robbod Exp $
  Author:  Tom Hendrix, Boeing
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: Output the Scope section as a web page
  Notes: Adapted from sect_modindex.xsl
     
-->
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:exslt="http://exslt.org/common"
  exclude-result-prefixes="msxsl exslt"
  version="1.0">

  <xsl:import href="resource.xsl"/>
  <xsl:import href="expressg_icon.xsl"/> 

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->

  <xsl:import href="resource_clause.xsl"/>

    <!-- global variable - Used by templates in expressg_icon.xsl to
         resolve href for expressg icon -->

<xsl:variable name="schema_expressg">
      <xsl:call-template name="make_schema_expressg_node_set"/>
</xsl:variable>    


  <xsl:output method="html"/>


<!-- overwrites the template declared in resource.xsl -->
<!-- output an index of terms, schema objects -->
<xsl:template match="resource">

  <xsl:variable name="resource_dir">
    <xsl:call-template name="resource_directory">
      <xsl:with-param name="resource" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="definition_section">
    <xsl:apply-templates select="." mode="get_definition_section"/>
  </xsl:variable>

  <xsl:variable name="indexed_objs">
    <xsl:apply-templates select="//definition" mode="get_defn_object">
      <xsl:with-param name="definition_section" select="$definition_section"/>
    </xsl:apply-templates>
    <xsl:for-each select="./schema">

      <xsl:variable name="schema_xml"
        select="document(concat('../../data/resources/',@name,'/',@name,'.xml'))"/>

    <xsl:apply-templates select="$schema_xml/express/schema/*" mode="get_schema_interface_object">
        <xsl:with-param name="pos" select="position()"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="$schema_xml/express/schema/*" mode="get_schema_object">
        <xsl:with-param name="pos" select="position()"/>
      </xsl:apply-templates>
    </xsl:for-each>
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


<xsl:template match="interface" mode="get_schema_interface_object">
  <xsl:param name="pos" />
  <schema_interface_object>
    <xsl:attribute name="name">
      <xsl:value-of select="@schema"/>
    </xsl:attribute>
    <xsl:attribute name="clause_no">
      <xsl:value-of select="concat($pos+3,'.1')"/>
    </xsl:attribute>
    <xsl:attribute name="object_href">
      <xsl:value-of select="concat($pos+3,'_schema',$FILE_EXT,'#interfaces')"/>
    </xsl:attribute>
  </schema_interface_object>
</xsl:template>


<xsl:template
  match="constant|entity|type|rule|function|procedure|subtype.constraint"
  mode="get_schema_object">
  <xsl:param name="pos" />

  <schema_object>
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
      <xsl:value-of select="concat($pos + 3,'_schema',$FILE_EXT,'#',$aname)"/>
    </xsl:attribute>

    <xsl:attribute name="clause_no">
      <xsl:value-of select="$pos + 3"/><xsl:apply-templates select="." mode="clause_no"/>
    </xsl:attribute>

    <xsl:variable name="lentity"
      select="translate(normalize-space(@name),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/> 

    <xsl:attribute name="expg_href">
      <xsl:call-template name="get_schema_expressg_href">
        <xsl:with-param name="object" select="$lentity"/>
      </xsl:call-template>
    </xsl:attribute>

    <xsl:variable name="expg_file1">
      <xsl:call-template name="get_schema_expressg_file">
        <xsl:with-param name="object" select="$lentity"/>
      </xsl:call-template>
    </xsl:variable>


    <xsl:variable name="expg_file" select="concat(substring-before($expg_file1,'.'),'.xml')"/>

    <xsl:variable name="resource_dir">
      <xsl:call-template name="resource_directory">
        <xsl:with-param name="resource" select="../@name"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="resource_expg_file">
      <xsl:call-template name="resource_expg_file">
        <xsl:with-param name="resource" select="../@name"/>
        <xsl:with-param name="expg_file" select="$expg_file1"/>
      </xsl:call-template>
    </xsl:variable>
    <!--
    <xsl:variable name="resdoc_name" select="document($resource_expg_file)/imgfile.content/@module"/>
-->
    <xsl:variable name="resdoc_dir">
      <xsl:call-template name="resdoc_directory">
        <xsl:with-param name="resdoc" select="$resdoc_name"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="resource_xml" select="concat($resdoc_dir,'/resource.xml')"/>

    <xsl:variable name="resdoc_xml" select="document($resource_xml)"/>
    <xsl:variable name="expg_fig_no">
      <xsl:apply-templates select="$resdoc_xml/resource//schema//imgfile"
        mode="expg_figure_no">
        <xsl:with-param name="file" select="$expg_file"/>
      </xsl:apply-templates>
    </xsl:variable>

    <xsl:attribute name="expg_figure">
      <xsl:value-of select="concat('D','.',$expg_fig_no - 1)"/>
    </xsl:attribute>
  </schema_object>
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


<xsl:template match="schema_interface_object" mode="output_index">
  <div>
    <xsl:value-of select="@name"/>
  </div>
  <xsl:variable name="object_href" select="@object_href"/>
  <xsl:variable name="clause_no" select="@clause_no"/>
  <div>
    &#160;&#160;&#160;Schema interface
    <a href="{$object_href}">
      <xsl:value-of select="$clause_no"/>
    </a>
  </div>
</xsl:template>

<xsl:template match="schema_object" mode="output_index">
  <div>
    <xsl:value-of select="@name"/>
  </div>
  <xsl:variable name="object_href" select="@object_href"/>
  <xsl:variable name="clause_no" select="@clause_no"/>
  <xsl:variable name="expg_href" select="@expg_href"/>
  <xsl:variable name="expg_figure" select="@expg_figure"/>
    <div>
    &#160;&#160;&#160;Object definition
    <a href="{$object_href}">
      <xsl:value-of select="$clause_no"/>
    </a>
  </div>
  <div>
    &#160;&#160;&#160;Object EXPRESS-G
    <a href="{$expg_href}">
      <xsl:value-of select="$expg_figure"/>
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
    <xsl:number level="any"/>
  </xsl:if>
</xsl:template>
<xsl:template match="resource" mode="get_definition_section">
  <!-- get a list of normative references that have terms defined -->
  <xsl:variable name="normrefs">
    <xsl:call-template name="normrefs_terms_list"/>
  </xsl:variable>

  <xsl:variable name="def_section">
    <xsl:call-template name="length_normrefs_list">
      <xsl:with-param name="resdoc_number" select="./@part"/>
      <xsl:with-param name="normrefs_list" select="$normrefs"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="concat('3.',$def_section+1)"/>
</xsl:template>

</xsl:stylesheet>
