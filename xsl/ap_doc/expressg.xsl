<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!-- last edited mwd 2002-08-19 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:output method="html"/>
	
	<xsl:template match="/">
		<xsl:apply-templates select="expressg"/>
	</xsl:template>
	
	<xsl:template match="expressg">
		<HTML>
			<HEAD>
			</HEAD>
			<BODY bgcolor="#FFFFFF" link="#0000FF" vlink="#800080">
				<xsl:apply-templates select="expressg.page"/>
			</BODY>
		</HTML>
	</xsl:template>
	
	<xsl:template match="expressg.page">
		<xsl:variable name="img" select="@image"/>
		<xsl:variable name="title" select="@title"/>
		<h3><xsl:value-of select="$title"/></h3>
		<img src="{$img}" usemap="#arm"/>
		<map name="arm">
			<xsl:apply-templates select="expressg.element"/>
		</map>
	</xsl:template>
	
	<xsl:template match="expressg.element">
		<xsl:variable name="coords" select="@coords"/>
		<xsl:variable name="shape" select="@shape"/>
		<xsl:variable name="href" select="@reference"/>
		<area coords="{$coords}" shape="{$shape}" href="{$href}"/>
	</xsl:template>
	
</xsl:stylesheet>