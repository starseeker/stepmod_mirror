<?xml version="1.0" ?>
<!--
     Stylesheet to show mappings that use each resource schema 
	Nigel Shaw 
-->

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:saxon="http://icl.com/saxon"
  version="1.0"
  >

  <xsl:import href="../../xsl/common.xsl"/>
  <xsl:import href="mapping_parse.xsl"/>


  <xsl:variable name="rep_index"
    select="document('../../repository_index.xml')"/>

  <xsl:variable name="DETAILS"
    select="'TRUE'"/>


<!--  <xsl:variable name="mappings"
    select="document('../bigmap.xml')"/>
-->

<!--  <xsl:variable name="mappings-result">
              <xsl:apply-templates select="$rep_index//modules/module" mode="mapping-full"/>
  </xsl:variable>
-->
<!--
  <xsl:variable name="mappings2"
    select="msxsl:node-set($mappings-result)"/>
-->

<!-- the following does not work! variable with select= has to be empty 
    <xsl:variable name="mappings"
    select="msxsl:node-set($mappings-result)">
    <xsl:fallback>
    <xsl:copy-of select="saxon:node-set($mappings-result)" />
    </xsl:fallback></xsl:variable>
-->

<xsl:output method="html" />

<xsl:template match="/" >

  <HTML>
    <HEAD>
      <!-- apply a cascading stylesheet.
           the stylesheet will only be applied if the parameter output_css
           is set in parameter.xsl 
           -->
      <xsl:call-template name="output_css">
        <xsl:with-param name="override_css" select="'stepmod.css'"/>
        <xsl:with-param name="path" select="'./css/'"/>
      </xsl:call-template>
      <TITLE>Module repository - mappings</TITLE>
    </HEAD>
    <BODY>

	<H1>Resource Mappings Viewer</H1>
	<p>
	Shows a list of resource schemas. Following the link for a schema will open a page showing
	a table that is ordered by entity 
	and shows those Arm elements (and their respective modules) that use each resource entity in their mapping.
	<br/>
	Where entries appear above the line, the resource entity is directly referenced as an MIM element. 
	<br/>
	Where entries appear below the line, the resource entity is referenced in the reference path.
	</p>
	<p>Beware: Mapping pages may be slow to load.
	</p>
	<blockquote>
              <xsl:apply-templates select="$rep_index//resources/resource" mode="index">
                 <xsl:sort select="@name"/>
              </xsl:apply-templates>
	</blockquote>

    </BODY>
  </HTML>
</xsl:template>

<xsl:template match="resource" mode="index">
			<b>
				<a href="../data/resources/{@name}/resource_map{$FILE_EXT}"><xsl:value-of select="@name" /></a>
			</b>
			<br/>

</xsl:template>


</xsl:stylesheet>

