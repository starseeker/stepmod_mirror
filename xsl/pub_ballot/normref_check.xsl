<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: normref_check.xsl,v 1.9 2011/08/25 12:59:49 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep.
  Purpose:
     Display a list of all the normative references for easy checking.
-->
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:exslt="http://exslt.org/common"
  exclude-result-prefixes="msxsl exslt"
  version="1.0">


  <xsl:import href="../sect_2_refs.xsl"/>
  <!-- MWD START -->
  <xsl:import href="../res_doc/sect_2_refs.xsl"/>
  <!-- MWD END -->
  <xsl:output 
    method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    indent="yes"
    />

    <xsl:variable name="normref_doc" select="document('../../data/basic/normrefs.xml')"/>

  <!-- force the application of the stylesheet to the file specified in the
       file attribute -->
  <xsl:template match="/">
    <!-- the file will contain either -->
    <xsl:apply-templates select="//publication" />
  </xsl:template>


  <xsl:template match="publication">
    <HTML>
      <head>
        <title>Normative reference check</title>
      </head>
      <body>       
        <xsl:variable name="pub_dir"
        select="concat('../../publication/part1000/',@directory,'/publication_index.xml')"/>
        <xsl:variable name="publication_index_xml" select="document($pub_dir)"/>
        <xsl:variable name="index_file">
          <xsl:choose>
            <xsl:when test="$FILE_EXT='.xml'">
              <xsl:value-of select="concat('publication_summary',$FILE_EXT)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="'index.htm'"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <h1>
          Normative reference check: 
          <xsl:value-of select="concat('WG', @sc4.working_group, 
                                ' N',@wg.number.publication_set, ' (',@name,')')"/> 
        </h1>
        <p><a href="{$index_file}">CR index</a></p>
        <p>
          This provides a summary of all the normative references used in
          the package of parts. 
          It should be used to check that the normative references are correct.
        </p>
        
        <!--
        <xsl:apply-templates select="/" mode="process_modules"/>

        <!-\- to avoid a link error,  output a footnote to say that the normative reference has not been
             published -\->
        <xsl:call-template name="output_unpublished_normrefs_footnote"/>-->
        
        <h2>Index</h2>
        <xsl:apply-templates select="$publication_index_xml//modules/module" mode="normref_index">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="$publication_index_xml//modules/module" mode="normref_output">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
        <!-- MWD START -->
        <xsl:apply-templates select="$publication_index_xml//resource_docs/resource_doc" mode="normref_index">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="$publication_index_xml//resource_docs/resource_doc" mode="normref_output">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
        <!-- MWD END -->
      </body>
    </HTML>
  </xsl:template>

  
  <xsl:template match="module" mode="normref_index">
    <xsl:variable name="module_name" select="@name"/>
    <xsl:variable name="module_dir">
      <xsl:call-template name="module_directory">
        <xsl:with-param name="module" select="@name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="module_xml" select="document(concat('../',$module_dir, '/module.xml'))"/>
    <a name="index_{@name}"/>
    <a href="#{@name}">
      <xsl:value-of select="@name"/>
    </a>
    <br/>
  </xsl:template>
  
  <!-- MWD START -->
  <xsl:template match="resource_doc" mode="normref_index">
    <xsl:variable name="resource_doc_name" select="@name"/>
    <!--<xsl:variable name="resource_doc_dir">
      <xsl:call-template name="resdoc_directory">
        <xsl:with-param name="resdoc" select="$resource_doc_name"/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="resource_doc_xml" select="document(concat($resource_doc_dir, '/resource.xml'))"/>-->
    <a name="index_{$resource_doc_name}"/>
    <a href="#{$resource_doc_name}">
      <xsl:value-of select="$resource_doc_name"/>
    </a>
    <br/>
  </xsl:template>
  <!-- MWD END -->
  
  <xsl:template match="module" mode="normref_output">
    <xsl:variable name="module_name" select="@name"/>
    <xsl:variable name="module_dir">
      <xsl:call-template name="module_directory">
        <xsl:with-param name="module" select="@name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="module_xml" select="document(concat('../',$module_dir, '/module.xml'))"/>
    <hr/>
    <h1>
      <a name="{$module_name}">
        <xsl:value-of select="@name"/>
      </a>
    </h1>
    <a href="#index_{$module_name}">index</a>
    <xsl:apply-templates select="$module_xml//module"/>
  </xsl:template>
  
  <!-- MWD START -->
  <xsl:template match="resource_doc" mode="normref_output">
    <xsl:variable name="resource_doc_name" select="@name"/>
    <xsl:variable name="resource_doc_dir">
      <xsl:call-template name="resdoc_directory">
        <xsl:with-param name="resdoc" select="$resource_doc_name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="resource_doc_xml" select="document(concat($resource_doc_dir, '/resource.xml'))"/>
    <hr/>
    <h1>
      <a name="{$resource_doc_name}">
        <xsl:value-of select="$resource_doc_name"/>
      </a>
    </h1>
    <a href="#index_{$resource_doc_name}">index</a>
    <xsl:apply-templates select="$resource_doc_xml//resource"/>
  </xsl:template>
  <!-- MWD END -->
  


</xsl:stylesheet>
