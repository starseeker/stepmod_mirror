<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:import href="../common.xsl"/>
	<xsl:import href="../elt_list.xsl"/>
	<xsl:include href="biblio.xsl"/>
	<xsl:include href="cover.xsl"/>
	<xsl:include href="default.xsl"/>
	<xsl:include href="index.xsl"/>
	<xsl:include href="nav.xsl"/>
	<xsl:include href="ref.xsl"/>
	<xsl:output method="html" indent="yes" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" doctype-system="http://www.w3.org/TR/html4/loose.dtd"/>
	<xsl:param name="links">html</xsl:param>
	<xsl:variable name="extension">
	  <xsl:choose>
	    <xsl:when test="$links = 'html'">
	      <xsl:text>.html</xsl:text>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:text>.xml</xsl:text>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:variable>
	<xsl:variable name="bibliography_path">../../../basic/bibliography.xml</xsl:variable>
	<xsl:variable name="desig" select="document('../part.xml',.)/part/designator"/>
	<xsl:variable name="pub_year_mo" select="document('../part.xml',.)/part/@publication.year"/>
	<xsl:variable name="pub_year" select="fn:substring-before($pub_year_mo,'-')"/>
	<xsl:variable name="version_number" select="document('../part.xml',.)/part/@version.number"/>
	<xsl:template match="space" priority="2.0">
	  <xsl:text> </xsl:text>
	</xsl:template>
	<xsl:template match="collection_page" priority="2.0">
		<html>
			<head>
				<!-- <xsl:call-template name="insert_metadata"/> -->
				<title><xsl:value-of select="$desig"/></title>
			</head>
			<body>
				<xsl:if test="@page_type = 'main'">
					<!--
					<xsl:call-template name="top_stuff"/>
					-->
				</xsl:if>
				<xsl:apply-templates/>
				<xsl:if test="@page_type = 'main'">
					<xsl:call-template name="bottom_stuff"/>
				</xsl:if>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="top_stuff">
		<table cellspacing="0" border="0" width="100%">
			<tr>
				<td valign="MIDDLE">
					<b>Application modules</b>
				</td>
				<td valign="MIDDLE" align="RIGHT">
					<b><xsl:value-of select="$desig"/></b>
				</td>
			</tr>
		</table>
		<xsl:call-template name="top_nav"/>
	</xsl:template>
	<xsl:template match="p[@class='note' or @class='example']">
	  <xsl:copy>
	    <small>
	      <xsl:apply-templates/>
	    </small>
	  </xsl:copy>
	</xsl:template>
	<xsl:template match="footnotes" priority="2.0">
	  <table width="200">
            <tr>
              <td>
		<hr/>
	      </td>
	    </tr>
	  </table>
	  <xsl:apply-templates/>
	</xsl:template>
	<xsl:template name="bottom_stuff">
	  <br/>
	  <br/>
	  <p>&#169; ISO <xsl:value-of select="$pub_year"/> &#8212; All rights reserved</p>
	</xsl:template>
	<xsl:template name="insert_metadata">
		<link rel="schema.DC" href="http://www.dublincore.org/documents/2003/02/04/dces/"/>
	</xsl:template>
	<xsl:template match="link">
	  <xsl:call-template name="link">
	    <xsl:with-param name="ref" select="@ref"/>
	  </xsl:call-template>
	</xsl:template>
	<xsl:template name="link">
	  <xsl:param name="ref"/>
	  <xsl:variable name="href">
	    <xsl:choose>
	      <xsl:when test="starts-with($ref,'#')">
		<xsl:value-of select="$ref"/>
	      </xsl:when>
	      <xsl:when test="contains($ref,'#')">
		<xsl:variable name="file_part" select="substring-before($ref,'#')"/>
		<xsl:variable name="internal_part" select="substring-after($ref,'#')"/>
		<xsl:value-of select="concat($file_part,$extension,'#',$internal_part)"/>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:value-of select="concat($ref,$extension)"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:variable>
	  <a href="{$href}">
	    <xsl:apply-templates/>
	  </a>
	</xsl:template>
	<xsl:template match="publication-year" priority="2.0">
	  <xsl:value-of select="$pub_year"/>
	</xsl:template>
	<xsl:template match="publication-year-month" priority="2.0">
	  <xsl:value-of select="$pub_year_mo"/>
	</xsl:template>
	<xsl:template match="version-number" priority="2.0">
	  <xsl:value-of select="$version_number"/>
	</xsl:template>
</xsl:stylesheet>
