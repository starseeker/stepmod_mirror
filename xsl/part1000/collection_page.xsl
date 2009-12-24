<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:output method="html" indent="yes" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" doctype-system="http://www.w3.org/TR/html4/loose.dtd"/>
	<xsl:include href="default.xsl"/>
	<xsl:include href="modules.xsl"/>
	<xsl:include href="index.xsl"/>
	<xsl:template match="collection_page" priority="2.0">
		<html>
			<head>
				<!-- <xsl:call-template name="insert_metadata"/> -->
				<title>ISO/TS 10303-1000</title>
			</head>
			<body>
				<xsl:if test="@page_type = 'main'">
					<xsl:call-template name="top_stuff"/>
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
					<b>ISO/TS 10303-1000</b>
				</td>
			</tr>
		</table>
		<table border="1" cellspacing="1" width="100%">
			<tr>
				<td valign="TOP">
					<p class="toc">
						<a href="../sys/cover.htm">Cover page</a>
						<br/>
						<a href="../sys/contents.htm">Table of contents</a>
						<br/>
						<a href="../sys/cover.htm#copyright">Copyright</a>
						<br/>
					</p>
				</td>
				<td valign="TOP">
					<p class="toc">
						<a href="../sys/foreword.htm">Foreword</a>
						<br/>
						<a href="../sys/introduction.htm">Introduction</a>
						<br/>
						<a href="../sys/1_scope.htm">1 Scope</a>
						<br/>
					</p>
				</td>
				<td valign="TOP">
					<p class="toc">
						<a href="../sys/2_refs.htm">2 Normative references</a>
						<br/>
						<a href="../sys/3_defs.htm">3 Terms, definitions and abbreviated terms</a>
						<br/>
						<a href="../sys/a_obj_reg.htm">A Information object registration</a>
						<br/>
					</p>
				</td>
				<td valign="TOP">
					<p class="toc">
						<a href="../sys/biblio.htm">Bibliography</a>
						<br/>
						<a href="../sys/index_apdoc.htm">Index</a>
						<br/>
					</p>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="bottom_stuff">
		<br/>
		<br/>
		<p>&#169; ISO 2010 &#8212; All rights reserved</p>
	</xsl:template>
	<xsl:template name="insert_metadata">
		<link rel="schema.DC" href="http://www.dublincore.org/documents/2003/02/04/dces/"/>
	</xsl:template>
</xsl:stylesheet>
