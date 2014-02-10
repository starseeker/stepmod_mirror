<?xml version="1.0" encoding="utf-8"?>
<!--
Ant project to run update tasks:
FilePurpose - delete names from CVS id tag
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="text"/>
	<!-- force the application of the stylesheet  -->
	<xsl:template match="/exp">
		<xsl:variable name="normalizetext" select="normalize-space(text())"/>
		<xsl:variable name="normalizelength" select="string-length($normalizetext)"/>
		<xsl:variable name="delim" select="':'" />
		<xsl:variable name="commentstart" select="'(*'" />
		
		<!-- handle leading comment chars -->
		<xsl:variable name="trimtext">
			<xsl:choose>
				<xsl:when test="contains($normalizetext, $commentstart)">
					<xsl:value-of select="normalize-space(substring($normalizetext, 3, $normalizelength))" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$normalizetext" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="totalLength" select="string-length($trimtext)"/>
		
		<xsl:variable name="indexOfLastDelim">
			<xsl:call-template name="last-index-of">
				<xsl:with-param name="txt" select="$trimtext"/>
				<xsl:with-param name="delimiter" select="$delim"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$indexOfLastDelim &gt; 4">
				<xsl:value-of select="substring($trimtext, 1,  $indexOfLastDelim + 3)"/>
				<xsl:text>Exp $</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$trimtext"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="last-index-of">
		<xsl:param name="txt"/>
		<xsl:param name="remainder" select="$txt"/>
		<xsl:param name="delimiter" select="' '"/>
		<xsl:choose>
			<xsl:when test="contains($remainder, $delimiter)">
				<xsl:call-template name="last-index-of">
					<xsl:with-param name="txt" select="$txt"/>
					<xsl:with-param name="remainder" select="substring-after($remainder, $delimiter)"/>
					<xsl:with-param name="delimiter" select="$delimiter"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="lastIndex" select="string-length(substring($txt, 1, string-length($txt)-string-length($remainder)))+1"/>
				<xsl:choose>
					<xsl:when test="string-length($remainder)=0">
						<xsl:value-of select="string-length($txt)"/>
					</xsl:when>
					<xsl:when test="$lastIndex>0">
						<xsl:value-of select="($lastIndex - string-length($delimiter))"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="0"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
