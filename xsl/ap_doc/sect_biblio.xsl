<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
	$Id: sect_biblio.xsl,v 1.4 2003/02/20 09:11:46 goset1 Exp $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<!-- xsl:import href="../sect_biblio.xsl"/ -->
	<xsl:import href="application_protocol.xsl"/>
	<xsl:import href="application_protocol_clause.xsl"/>
	<xsl:import href="projmg/issues.xsl"/>

	<xsl:output method="html"/>
	
	 	<xsl:template match="module"/>
		
	<xsl:template match="application_protocol">
	
<!--	<xsl:template match="module"> -->
		<div align="center">
			<h3>
				<A NAME="bibliography">Bibliography</A>
			</h3>
		</div>
		<xsl:choose>
			<xsl:when test="./bibliography">
				<xsl:apply-templates select="./bibliography"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="document('../../data/basic/bibliography_default.xml')/bibliography/bibitem.inc"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	  <!--  -->
</xsl:stylesheet>
