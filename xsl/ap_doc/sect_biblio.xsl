<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_biblio.xsl,v 1.5 2002-07-16 17:48:54 mwd Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:import href="application_protocol.xsl"/>
	
	<!-- the stylesheet that allows different stylesheets to be applied -->
	
	<xsl:import href="application_protocol_clause.xsl"/>
	
	<xsl:output method="html"/>
	
	<!-- overwrites the template declared in module.xsl -->
	<xsl:template match="application_protocol">
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
				<!-- output the defaults -->
				<xsl:apply-templates select="document('../../data/basic/bibliography_default.xml')/bibliography/bibitem.inc"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	  
</xsl:stylesheet>
