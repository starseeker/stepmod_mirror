<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: common.xsl,v 1.138 2004/11/08 12:49:49 robbod Exp $
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


  <xsl:import href="../module.xsl"/>

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
    <xsl:apply-templates select="ballot"/>
    <xsl:apply-templates select="publication"/>
  </xsl:template>

  <xsl:template match="ballot">
    <xsl:variable name="ballot_index" 
      select="concat('../../ballots/ballots/',@directory,'/ballot_index.xml')"/>
    <xsl:apply-templates select="document($ballot_index)/ballot_index" mode="html_body"/>
  </xsl:template>

  <xsl:template match="ballot_index" mode="html_body">
    <HTML>
      <head>
        <title></title>
      </head>
      <body>
        <xsl:apply-templates select="/" mode="process_modules"/>
      </body>
    </HTML>
  </xsl:template>

  <xsl:template match="publication">
    <xsl:variable name="publication_index" 
      select="concat('../../publication/publication/',@directory,'/publication_index.xml')"/>
    <xsl:apply-templates select="document($publication_index)/publication_index" mode="html_body"/>
  </xsl:template>

  <xsl:template match="publication_index" mode="html_body">
    <HTML>
      <head>
        <title></title>
      </head>
      <body>
        <xsl:apply-templates select="/" mode="process_modules"/>
      </body>
    </HTML>
  </xsl:template>
  
  
  <xsl:template match="/" mode="process_modules">
    <xsl:variable name="normrefs">
      <xsl:if test="//module">
        <xsl:apply-templates
          select="document('../../data/basic/normrefs_default.xml')/normrefs/normref.inc"
          mode="generate_normref_node">
          <xsl:with-param name="type" select="'normrefs_default.xml'"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="//module" mode="read_normref">
          <xsl:with-param name="type" select="'Module'"/>
        </xsl:apply-templates>
      </xsl:if>
      <xsl:if test="//ap_doc">
        <xsl:apply-templates
          select="document('../../data/basic/ap_doc/normrefs_default.xml')/normrefs/normref.inc" 
          mode="generate_normref_node">
          <xsl:with-param name="type" select="'ap_doc/normrefs_default.xml'"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="//ap_doc" mode="read_normref">
          <xsl:with-param name="type" select="'AP'"/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="function-available('msxsl:node-set')">
        <xsl:variable name="normrefs_nodes" select="msxsl:node-set($normrefs)"/>
        <xsl:apply-templates select="$normrefs_nodes/normref_node" mode="display_normref"/>
      </xsl:when>
      <xsl:when test="function-available('exslt:node-set')">
        <xsl:variable name="normrefs_nodes" select="exslt:node-set($normrefs)"/>
        <xsl:apply-templates select="$normrefs_nodes/normref_node" mode="display_normref"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- applies to ap_doc in ballot_publication_index -->
  <xsl:template match="ap_doc" mode="read_normref">
    <xsl:variable name="ap_path" select="concat('../../data/application_protocols/',@name,'/application_protocol.xml')"/>
    <xsl:apply-templates select="document($ap_path)/application_protocol/normrefs/normref.inc" mode="generate_normref_node"/>
  </xsl:template>


  <!-- applies to module in ballot_publication_index -->
  <xsl:template match="module" mode="read_normref">
    <xsl:variable name="mod_path" select="concat('../../data/modules/',@name,'/module.xml')"/>
    <xsl:apply-templates select="document($mod_path)/module/normrefs/normref.inc" mode="generate_normref_node"/>
  </xsl:template>

  <!-- applies to module.xml -->
  <xsl:template match="normref.inc" mode="generate_normref_node">
    <xsl:param name="type"/>
    <xsl:variable name="root" select="/*"/>
    <xsl:if test="string-length(@normref)!=0">
      <xsl:element name="normref_node">
        <xsl:attribute name="normref.inc">
          <xsl:value-of select="@normref"/>
        </xsl:attribute>
        <xsl:element name="module">
          <xsl:attribute name="name">
            <xsl:value-of  select="//@name"/>
          </xsl:attribute>
          <xsl:attribute name="type">
            <xsl:value-of select="$type"/>
          </xsl:attribute>
        </xsl:element>
      </xsl:element>
  </xsl:if>
  </xsl:template>


  <xsl:template match="normref_node" mode="display_normref">
    <xsl:variable name="this_normref_inc" select="@normref.inc"/>
    <xsl:if test="count(preceding-sibling::*[@normref.inc = $this_normref_inc])=0">
      <hr/>
      <h3>
        Normref.inc: <xsl:value-of select="@normref.inc"/>
      </h3>
      <p>Normative reference</p>
      <xsl:apply-templates select="$normref_doc/normref.list/normref[@id=$this_normref_inc]">
        <xsl:with-param name="current_module" select="./module/@name"/>
      </xsl:apply-templates>
      <p>Parts:</p>
      <ul>
        <!-- now output the rest -->
        <xsl:apply-templates select="../normref_node[@normref.inc = $this_normref_inc]" mode="display_normref_modules"/>
      </ul>
    </xsl:if> 
    
  </xsl:template>
  
  <xsl:template match="normref_node" mode="display_normref_modules">
    <li>
      <xsl:value-of select="concat(./module/@type,' ',./module/@name,'=',@normref.inc)"/>
    </li>
  </xsl:template>




</xsl:stylesheet>
