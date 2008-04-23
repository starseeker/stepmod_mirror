<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
	$Id: normrefs.xsl,v 1.4 2003/08/13 08:08:33 robbod Exp $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html" doctype-system="http://www.w3.org/TR/html4/loose.dtd" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" indent="yes"/>
	<xsl:template match="/">
		<html>
			<head>
				<title>
				</title>
			</head>
			<body>
				<xsl:apply-templates select="./normref.list/normref" />
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="normref">
		<xsl:variable name="stdnumber">
<!-- 			<xsl:choose>
				<xsl:when test="stdref/pubdate">
					<xsl:value-of select="concat(stdref/orgname,'&#160;',stdref/stdnumber,':',stdref/pubdate)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat(stdref/orgname,'&#160;',stdref/stdnumber,':&#8212;&#160;')"/>
				</xsl:otherwise>
			</xsl:choose> -->
	  		<xsl:value-of 
	    		select="concat(stdref/orgname,'&#160;xx',stdref/stdnumber)"/>
		</xsl:variable>
		<p>
			<xsl:value-of select="$stdnumber"/>
			<xsl:if test="stdref[@published='n']">
				<sup>
                                  <a href="#tobepub">1)x</a>
				</sup>
			</xsl:if>,&#160;
			<i>
				<xsl:value-of select="stdref/stdtitle"/>
				<xsl:variable name="subtitle" select="normalize-space(stdref/subtitle)"/>
				<xsl:choose>
					<xsl:when test="substring($subtitle, string-length($subtitle)) != '.'">
						<xsl:value-of select="concat($subtitle,'.')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$subtitle"/>
					</xsl:otherwise>
				</xsl:choose>
			</i>
		</p>
	</xsl:template>
	
</xsl:stylesheet>