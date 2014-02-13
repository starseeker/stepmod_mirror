<?xml version="1.0" encoding="utf-8"?>
<!--
Ant project to run update tasks:
FilePurpose - extract data from resource.xml
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.1">

	<xsl:import href="lsmCaseUtil.xsl"/>
	<xsl:include href="lsmCopyrightBoilerplate.xsl"/>

	<xsl:param name="output_dir"/>
	<xsl:output method="text"/>

	<xsl:variable name="theStdNum">ISO 10303</xsl:variable>
	<xsl:variable name="theFullWGNum">TC184/SC4/WG12</xsl:variable>

	<!-- force the application of the stylesheet  -->
	<xsl:template match="/resource">
	<xsl:value-of select="system-property('xsl:vendor')"/>
		<xsl:text>&#xA;</xsl:text>
		<xsl:variable name="theDocTitle">
			<xsl:call-template name="ucfirst">
				<xsl:with-param name="value" select="normalize-space(@name)"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="theName" select="./@name"/>
		<xsl:variable name="thePath" select="concat('../../../', ./@name)"/>
		<xsl:variable name="thePart" select="./@part"/>
		<xsl:variable name="theEdition" select="./@version"/>
		<xsl:variable name="theWgNum" select="./@wg.number"/>
		<xsl:variable name="theWgNumExp" select="./@wg.number.express"/>

		<xsl:variable name="ISOTagAndNum" select="concat($theStdNum, ' ',  $theFullWGNum, ' N', $theWgNumExp)"/>

		<xsl:variable name="schemaCount" select="count(./schema)"/>

		<xsl:text>--------------------------------------------------------</xsl:text>
		<xsl:text>&#xA;</xsl:text>
		<xsl:value-of select="$ISOTagAndNum"/>
		<xsl:text>&#xA;</xsl:text>
		<xsl:value-of select="$theName"/><xsl:value-of select="concat('  [Ref Schema], ', $schemaCount)"/>
		<xsl:text>&#xA;</xsl:text>
		<xsl:text>--------------------------------------------------------</xsl:text>

			<xsl:apply-templates select="schema">
				<xsl:with-param name="ISOTagAndNum" select="$ISOTagAndNum"/>
				<xsl:with-param name="theFullName">
					<xsl:value-of select="concat($theStdNum, '-', $thePart, ' ed', $theEdition, ' ', $theDocTitle)"/>
				</xsl:with-param>
			</xsl:apply-templates>

		<xsl:text>&#xA;</xsl:text>
	</xsl:template>

	<xsl:template match="schema">
		<xsl:param name="ISOTagAndNum"/>
		<xsl:param name="theFullName"/>
		<xsl:variable name="theSchemaTitle">
			<xsl:call-template name="ucfirst">
				<xsl:with-param name="value" select="normalize-space(@name)"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="outfile" select="concat($output_dir, '/', @name, '/', '_copyright.txt')"/>

		<xsl:text>&#xA;</xsl:text>
		<xsl:value-of select="$outfile"/>

		<!-- trying to output multiple files from source tree using extension function for 1.1 -->
		<xsl:document href="{$outfile}" method="text">
			<xsl:value-of select="$ISOTagAndNum"/>
			<xsl:text>&#xA;</xsl:text>
			<xsl:call-template name="theCopyrightExpressSchemaHeader">
				<xsl:with-param name="theFullNameAndSchemaTitle" select="concat($theFullName, ' - ', $theSchemaTitle)"/>
			</xsl:call-template>
		</xsl:document>

	</xsl:template>

</xsl:stylesheet>
