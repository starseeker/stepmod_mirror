<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
	$Id: expressg.xsl,v 1.2 2002/10/08 10:20:08 mikeward Exp $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:import href="../expressg.xsl"/>
	
	<xsl:output method="html"/>
	
	<xsl:template match="/">
		<xsl:apply-templates select="expressg"/>
	</xsl:template>
	
	<xsl:template match="expressg">
		<html>
			<head>
			</head>
			<body bgcolor="#FFFFFF" link="#0000FF" vlink="#800080">
				<xsl:apply-templates select="expressg.page"/>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="expressg.page">
		<xsl:variable name="img" select="@image"/>
		<xsl:variable name="title" select="@title"/>
		<h3><xsl:value-of select="$title"/></h3>
		<img src="{$img}" usemap="#arm"/>
		<map id="arm" name="arm">
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