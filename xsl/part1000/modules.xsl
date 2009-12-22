<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:output method="html"/>
	<xsl:template match="modules_table" priority="2.0">
		<xsl:apply-templates select="document('../docs.xml',.)/docs"/>
	</xsl:template>
	<xsl:template match="docs" priority="2.0">
		<table border="1">
			<tr>
				<td>
					<b>Module name</b>
				</td>
				<td>
					<b>Module number</b>
				</td>
				<td>
					<b>Edition</b>
				</td>
				<!--
				<td>
					<b>Registration status</b>
				</td>
				-->
				<td>
					<b>Year of publication</b>
				</td>
			</tr>
			<xsl:apply-templates select="doc[@type = 'module']">
				<xsl:sort select="fn:lower-case(@name)"/>
			</xsl:apply-templates>
		</table>
	</xsl:template>
	<xsl:template match="doc" priority="2.0">
		<tr>
			<td>
				<a href="../../modules/{@name}/sys/cover.htm">
					<xsl:value-of select="@name"/>
				</a>
			</td>
			<td>
				<xsl:value-of select="@part"/>
			</td>
			<td>
				<xsl:value-of select="@edition"/>
			</td>
			<!--
			<td>
				<xsl:value-of select="@status"/>
			</td>
			-->
			<td>
				<xsl:value-of select="fn:substring(@publication,1,4)"/>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>
