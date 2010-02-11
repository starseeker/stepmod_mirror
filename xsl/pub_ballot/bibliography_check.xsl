<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: bibliography_check.xsl,v 1.2 2010/02/10 15:13:15 robbod Exp $
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
        <h1>Bibliography summary</h1>
        <p>
          Note: Only bibliographies that are NOT the default are output as there is 
          no need to check the others.
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
        
        <xsl:variable name="pub_dir"
          select="concat('../../publication/part1000/',@directory,'/publication_index.xml')"/>
        <xsl:variable name="module_xml" select="document($pub_dir)"/>
        <h2>Index</h2>
        <xsl:apply-templates select="$module_xml//module" mode="bibilio_index">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="$module_xml//module" mode="bibilio">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
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

</xsl:stylesheet>
