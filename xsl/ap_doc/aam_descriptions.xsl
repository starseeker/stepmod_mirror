<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_1_scope.xsl,v 1.10 2003/05/22 14:57:14 robbod Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose:     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:output method="html"/>
	
        <!-- RBN not sure why this is needed
	<xsl:template match="/">
		<html>
			<body bgcolor="#FFFFFF">
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template> -->
	
	<xsl:template match="idef0">
	
		<p>The viewpoint is that of <xsl:value-of select="viewpoint"/>.</p>
		
		<h2>F.1 Application activity model definitions</h2>
		
		<xsl:for-each select="./*/*">
			<xsl:sort select="normalize-space(./name)"/>
			<xsl:variable name="asterisk">
				<xsl:if test="@inscope='no'">
					*
				</xsl:if>
			</xsl:variable>
			<h2>
				F.1.<xsl:value-of select="position()"/>
				<xsl:value-of select="concat(' ', ./name)"/>
				<xsl:value-of select="$asterisk"/>
			</h2>
			<p><xsl:value-of select="./description"/></p>
			<xsl:apply-templates select="note"/>
			<xsl:apply-templates select="example"/>
		</xsl:for-each>
  	
	</xsl:template>
	
</xsl:stylesheet>
