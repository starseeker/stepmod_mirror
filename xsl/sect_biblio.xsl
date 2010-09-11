<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_biblio.xsl,v 1.10 2010/09/04 17:59:41 radack Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:exslt="http://exslt.org/common">
	<xsl:import href="module.xsl"/>
	<!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
	<xsl:import href="module_clause.xsl"/>
	<xsl:import href="projmg/issues.xsl"/>
	<xsl:import href="elt_list.xsl"/>
	<xsl:include href="common/biblio.xsl"/>
	<xsl:output method="html"/>
	<!-- overwrites the template declared in module.xsl -->
	<xsl:template match="module">
		<div align="left">
			<h2>
				<A NAME="bibliography">Bibliography</A>
			</h2>
		</div>
		<!-- output any issues -->
		<xsl:apply-templates select="." mode="output_clause_issue">
			<xsl:with-param name="clause" select="'bibliography'"/>
		</xsl:apply-templates>
		<xsl:choose>
			<xsl:when test="./bibliography">
				<xsl:apply-templates select="./bibliography">
					<xsl:with-param name="doc_type">module</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<!-- output the defaults -->
				<xsl:variable name="bibliography_dummy">
					<bibliography/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="function-available('msxsl:node-set')">
						<xsl:variable name="bibliography_dummy_nodes" select="msxsl:node-set($bibliography_dummy)"/>
						<xsl:apply-templates select="$bibliography_dummy_nodes/bibliography">
							<xsl:with-param name="doc_type">module</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="function-available('exslt:node-set')">
						<xsl:variable name="bibliography_dummy_nodes" select="exslt:node-set($bibliography_dummy)"/>
						<xsl:apply-templates select="$bibliography_dummy_nodes/bibliography">
							<xsl:with-param name="doc_type">module</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:message>Only support SAXON and MXSL XSL parsers.</xsl:message>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		<!-- check that all bibitems have been published, if not output footnote -->
		<xsl:apply-templates select="./bibliography" mode="unpublished_bibitems_footnote">
			<xsl:with-param name="doc_type">module</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>
