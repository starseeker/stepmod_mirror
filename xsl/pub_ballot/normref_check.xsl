<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: normref_check.xsl,v 1.2 2004/11/18 15:46:08 robbod Exp $
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

  <xsl:template match="ballot_index|publication_index" mode="html_body">
    <HTML>
      <head>
        <title>Normative reference check</title>
      </head>
      <body>
        <h2>
          Normative reference check: 
          <xsl:value-of select="concat('WG', @sc4.working_group, 
                                ' N',@wg.number.publication_set, ' (',@name,')')"/> 
        </h2>
        <p>
          This provides a summary of all the normative references used in
          the package of parts. 
          It should be used to check that the normative references are correct.
        </p>
        <xsl:apply-templates select="/" mode="process_modules"/>
      </body>
    </HTML>
  </xsl:template>

  <xsl:template match="publication">
    <xsl:variable name="publication_index" 
      select="concat('../../publication/publication/',@directory,'/publication_index.xml')"/>
    <xsl:apply-templates select="document($publication_index)/publication_index" mode="html_body"/>
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
    <xsl:param name="type"/>
    <xsl:variable name="mod_path" select="concat('../../data/modules/',@name,'/module.xml')"/>
    <xsl:apply-templates
      select="document($mod_path)/module/normrefs/normref.inc" 
      mode="generate_normref_node">
      <xsl:with-param name="type" select="$type"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- applies to module.xml -->
  <xsl:template match="normref.inc" mode="generate_normref_node">
    <xsl:param name="type"/>
    <xsl:variable name="root" select="/*"/>
    <xsl:element name="normref_node">
      <xsl:attribute name="normref">
        <xsl:value-of select="@normref"/>
      </xsl:attribute>
      <xsl:attribute name="module.name">
        <xsl:value-of select="@module.name"/>
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
  </xsl:template>


  <xsl:template match="normref_node" mode="display_normref">
    <xsl:choose>
      <xsl:when test="string-length(@normref)!=0">
        <xsl:variable name="this_normref_inc" select="@normref"/>
        <xsl:if test="count(preceding-sibling::*[@normref = $this_normref_inc])=0">
          <hr/>
          <h3>
            <xsl:value-of select="concat('&lt;normref.inc normref=&quot;',@normref,'&quot;/>')"/>
          </h3>
        <p>Normative reference</p>
        <xsl:apply-templates select="$normref_doc/normref.list/normref[@id=$this_normref_inc]">
          <xsl:with-param name="current_module" select="./module/@name"/>
        </xsl:apply-templates>
        <p>Referenced from the following parts:</p>
        <ul>
          <!-- now output the rest -->
          <xsl:apply-templates select="../normref_node[@normref = $this_normref_inc]" mode="display_normref_modules"/>
        </ul>
      </xsl:if> 
    </xsl:when>
    <xsl:when test="string-length(@module.name)!=0">
      <xsl:variable name="this_normref_inc" select="@module.name"/>
      <xsl:if test="count(preceding-sibling::*[@module.name = $this_normref_inc])=0">
          <hr/>
          <h3>
            <xsl:value-of select="concat('&lt;normref.inc module.name=&quot;',@module.name,'&quot;/>')"/>
        </h3>
        <p>Normative reference</p>
        <xsl:variable name="module_xml" select="concat('../../data/modules/',@module.name,'/module.xml')"/>
        <xsl:apply-templates select="document($module_xml)/module" mode="normref">
          <xsl:with-param name="current_module" select="./module/@name"/>
        </xsl:apply-templates>
        <p>Referenced from the following parts:</p>
        <ul>
          <!-- now output the rest -->
          <xsl:apply-templates select="../normref_node[@module.name = $this_normref_inc]" mode="display_normref_modules"/>
        </ul>
      </xsl:if> 
    </xsl:when>
  </xsl:choose>
  </xsl:template>
  
  <xsl:template match="normref_node" mode="display_normref_modules">
    <li>
      <xsl:choose>
        <xsl:when test="string-length(@normref)!=0">
          <xsl:value-of select="concat(./module/@type,' ',./module/@name,' = ',@normref)"/>
        </xsl:when>
        <xsl:when test="string-length(@module.name)!=0">
          <xsl:value-of select="concat(./module/@type,' ',./module/@name,' = ',@module.name)"/>
        </xsl:when>
      </xsl:choose>
    </li>
  </xsl:template>




</xsl:stylesheet>
