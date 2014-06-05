<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: bibliography_check.xsl,v 1.5 2011/08/25 12:59:49 robbod Exp $
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

  <xsl:import href="../sect_biblio.xsl"/>
  
  
  
  <xsl:output method="html"/>
  
  <xsl:output 
    method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    indent="yes"
  />
  
  <xsl:template match="/" >
    <xsl:apply-templates select="//publication" />
  </xsl:template>
  
  <xsl:template match="publication">
    <html>
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
        <h1><xsl:value-of select="concat('CR ',$publication_index_xml/part1000.publication_index/@name,':- Bibliography summary')"/></h1>
        <p><a href="{$index_file}">CR index</a></p>
        <p>
          Note: Only bibliographies that are NOT the default are output as there is 
          no need to check the defaults.
        </p>
        <p>
          The Supplementary Directives states that references should be in the following
          order:
        </p>
        <ol>  
          <li>ISO standards, ordered by their standard number</li>
          <li>IEC standards, ordered by their standard number</li>
          <li>ISO/IEC standards, ordered by their standard number</li>
          <li>other standards, ordered alphabetically by their standard designation and
          standard number</li>
        </ol>
        
        <h2>Index</h2>
        <xsl:apply-templates select="$publication_index_xml//modules/module" mode="bibilio_index">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="$publication_index_xml//modules/module" mode="bibilio">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
        <!-- MWD START -->
        <xsl:apply-templates select="$publication_index_xml//resource_docs/resource_doc" mode="bibilio_index">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="$publication_index_xml//resource_docs/resource_doc" mode="bibilio">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
        <!-- MWD END -->
      </body>
    </html>
  </xsl:template>
  
  
  <xsl:template match="module" mode="bibilio_index">    
    <xsl:variable name="module_name" select="@name"/>
    <xsl:variable name="module_dir">
      <xsl:call-template name="module_directory">
        <xsl:with-param name="module" select="@name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="module_xml" select="document(concat('../',$module_dir, '/module.xml'))"/>
    <xsl:choose>
      <xsl:when test="$module_xml/module/bibliography">
        <a name="index_{@name}"></a>
        <a href="#{@name}"><xsl:value-of select="@name"/></a><br/>        
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="@name"/> (default bibliography)<br/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- MWD START -->
  <xsl:template match="resource_doc" mode="bibilio_index">    
    <xsl:variable name="resource_name" select="@name"/>
    <xsl:variable name="resource_doc_dir">
      <xsl:call-template name="resdoc_directory">
        <xsl:with-param name="resdoc" select="$resource_name"/>
      </xsl:call-template>
    </xsl:variable>
   
    <xsl:variable name="resource_doc_xml" select="document(concat($resource_doc_dir, '/resource.xml'))"/>
    <xsl:choose>
      <xsl:when test="$resource_doc_xml//resource/bibliography">
        <a name="index_{@name}"></a>
        <a href="#{@name}"><xsl:value-of select="@name"/></a><br/>        
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="@name"/> (default bibliography) <xsl:value-of select="$resource_doc_dir"/><br/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- MWD END -->
  
  <xsl:template match="module" mode="bibilio">
    <xsl:variable name="module_name" select="@name"/>
    <xsl:variable name="module_dir">
      <xsl:call-template name="module_directory">
        <xsl:with-param name="module" select="@name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="module_xml" select="document(concat('../',$module_dir, '/module.xml'))"/>
    <xsl:choose>
      <xsl:when test="$module_xml/module/bibliography">
        <hr/>
        <h1>
          <a name="{$module_name}">
            <xsl:value-of select="@name"/>
          </a>
        </h1>
        <a href="#index_{$module_name}">index</a>
        <xsl:apply-templates select="$module_xml//module"/>
      </xsl:when>
      <!--<xsl:otherwise> <p>Default bibliography so not output</p> </xsl:otherwise>-->
    </xsl:choose>
  </xsl:template>
  
  <!-- MWD START -->
  <xsl:template match="resource_doc" mode="bibilio">
    <xsl:variable name="resource_doc_name" select="@name"/>
    <xsl:variable name="resource_doc_dir">
      <xsl:call-template name="resdoc_directory">
        <xsl:with-param name="resdoc" select="@name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="resource_doc_xml" select="document(concat($resource_doc_dir, '/resource.xml'))"/>
    <xsl:choose>
      <xsl:when test="$resource_doc_xml/resource/bibliography">
        <hr/>
        <h1>
          <a name="{$resource_doc_name}">
            <xsl:value-of select="@name"/>
          </a>
        </h1>
        <a href="#index_{resource_doc_name}">index</a>
        <xsl:apply-templates select="$resource_doc_xml//resource" mode="bibiliog"/>
      </xsl:when>
      <!--<xsl:otherwise> <p>Default bibliography so not output</p> </xsl:otherwise>-->
    </xsl:choose>
  </xsl:template>
  <!-- MWD END -->
  
</xsl:stylesheet>
