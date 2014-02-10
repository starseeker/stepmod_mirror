<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template match="/">
	 <html>
	 	<body>
	 		<hl>Stylesheet Modular Structure</hl>
			<ul>
				<xsl:apply-templates select="*/xsl:include | */xsl:import"/>
			</ul>	
		</body>
	</html>
	</xsl:template>
	
	<xsl:template match="xsl:include | xsl:import">
		<li><xsl:value-of select="concat(local-name(), 's ', @href)"/>
			<xsl:variable name="module" select="document(@href)"/>
			<ul>
			<xsl:apply-templates select="$module/*/xsl:include | $module/*/xsl:import"/>
			</ul>
		</li>
	</xsl:template>
	
	<xsl:template match="@*|node()"/>
</xsl:stylesheet>
