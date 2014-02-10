<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
$Id:  $
  Author:  J Chris Johnson, Lockheed Martin
  Owner:   StepMod
  Purpose:
     Generic util to manipulate ascii text case.
-->

	<xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz '"/>
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ_'"/>

	<xsl:template name="uppercase">
		<xsl:param name="value"/>
		<xsl:value-of select="translate($value, $lowercase, $uppercase)"/>
	</xsl:template>
	
	<xsl:template name="lowercase">
		<xsl:param name="value"/>
		<xsl:value-of select="translate($value, $uppercase, $lowercase)"/>
	</xsl:template>
	
	<xsl:template name="ucfirst">
		<xsl:param name="value"/>
		<xsl:call-template name="uppercase">
			<xsl:with-param name="value" select="substring($value, 1, 1)"/>
		</xsl:call-template>
		
		<xsl:call-template name="lowercase">
			<xsl:with-param name="value" select="substring($value, 2)"/>
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>
