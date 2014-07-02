<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
	$Id: sect_biblio.xsl,v 1.1 2012/10/24 06:29:18 mikeward Exp $
	Author:  Mike Ward, Eurostep Limited
	Owner:   Developed by Eurostep.
	Purpose: Display bibliography for a BOM document.     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:exslt="http://exslt.org/common" exclude-result-prefixes="msxsl exslt" version="1.0">
	<xsl:import href="../elt_list.xsl"/>
	<xsl:import href="business_object_model.xsl"/>
	<xsl:import href="business_object_model_clause_nofooter.xsl"/> 
	<xsl:include href="../common/biblio.xsl"/>
	<xsl:output method="html"/>
	<xsl:template match="module"/>
	<xsl:template match="business_object_model">
		<div align="center">
			<h2>
				<A NAME="biblio">Bibliography</A>
			</h2>
		</div>
		<xsl:choose>
			<xsl:when test="./bibliography">
				<xsl:apply-templates select="./bibliography">
					<xsl:with-param name="doc_type">BOM</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<!-- output the defaults -->
				<xsl:apply-templates select="document('../../basic/ap_doc/bibliography_default.xml',.)/bibliography">
					<xsl:with-param name="doc_type">BOM</xsl:with-param>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
		<!-- check that all bibitems have been published, if not output
         footnote -->
		<xsl:apply-templates select="./bibliography" mode="unpublished_bibitems_footnote">
			<xsl:with-param name="doc_type">BOM</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>
