<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
    $Id: sect_biblio.xsl,v 1.30 2010/09/04 17:59:41 radack Exp $
  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:exslt="http://exslt.org/common" exclude-result-prefixes="msxsl exslt" version="1.0">
	<xsl:import href="../elt_list.xsl"/>
	<xsl:import href="application_protocol.xsl"/>
	<xsl:import href="application_protocol_clause.xsl"/>
	<xsl:include href="../common/biblio.xsl"/>
	<xsl:output method="html"/>
	<xsl:template match="module"/>
	<xsl:template match="application_protocol">
		<div align="center">
			<h2>
				<A NAME="biblio">Bibliography</A>
			</h2>
		</div>
		<xsl:choose>
			<xsl:when test="./bibliography">
				<xsl:apply-templates select="./bibliography">
					<xsl:with-param name="doc_type">AP</xsl:with-param>
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
							<xsl:with-param name="doc_type">AP</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="function-available('exslt:node-set')">
						<xsl:variable name="bibliography_dummy_nodes" select="exslt:node-set($bibliography_dummy)"/>
						<xsl:apply-templates select="$bibliography_dummy_nodes/bibliography">
							<xsl:with-param name="doc_type">AP</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:message>Only support SAXON and MXSL XSL parsers.</xsl:message>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		<!-- check that all bibitems have been published, if not output
         footnote -->
		<xsl:apply-templates select="./bibliography" mode="unpublished_bibitems_footnote">
			<xsl:with-param name="doc_type">AP</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>
