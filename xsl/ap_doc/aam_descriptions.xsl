<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
	$Id: aam_descriptions.xsl,v 1.4 2003/02/19 12:48:44 goset1 Exp $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:output method="html"/>
	
	<xsl:template match="/">
		<html>
			<body bgcolor="#FFFFFF">
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="idef0">
	
		<p>The viewpoint is that of <xsl:value-of select="viewpoint"/>.</p>
		
		<h3>E.1 Application activity model definitions</h3>
		
		<xsl:for-each select="./*/*">
			<xsl:sort select="normalize-space(./name)"/>
			<xsl:variable name="asterisk">
				<xsl:if test="@inscope='no'">
					*
				</xsl:if>
			</xsl:variable>
			<h4>
				E.1.<xsl:value-of select="position()"/>
				<xsl:value-of select="concat(' ', ./name)"/>
				<xsl:value-of select="$asterisk"/>
			</h4>
			<p><xsl:value-of select="./description"/></p>
			<xsl:apply-templates select="note"/>
			<xsl:apply-templates select="example"/>
		</xsl:for-each>
  	
	</xsl:template>
	
</xsl:stylesheet>
