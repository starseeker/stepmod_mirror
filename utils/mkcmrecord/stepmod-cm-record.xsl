<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- $Id: cm-record.xsl,v 1.4 2007/04/14 03:41:19 radack Exp $ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" indent="yes" doctype-system="..\dtd\stepmod_cm_record.dtd"/>
	<xsl:param name="description">*** FILL IN ***</xsl:param>
	<xsl:param name="release">*** FILL IN ***</xsl:param>
	<xsl:param name="tag">*** FILL IN ***</xsl:param>
	<xsl:param name="edition">*** FILL IN ***</xsl:param>
	<xsl:param name="who">*** FILL IN ***</xsl:param>
	<xsl:param name="when">*** FILL IN ***</xsl:param>
	<xsl:param name="record_exists">false</xsl:param>
	<xsl:template match="/">
		<stepmod_cm_record cvs_revision="{concat('$','Revision: $')}" cvs_date="{concat('$','Date: $')}">
			<xsl:comment> A set of all the releases of STEPmod </xsl:comment>
			<stepmod_cm_releases>
				<xsl:call-template name="release-comment"/>
				<!-- If there is an existing stepmod_cm_record.xml file, copy its stepmod_cm_release elements. -->
				<xsl:if test="$record_exists = 'true'">
					<xsl:apply-templates select="document('stepmod_cm_record.xml',.)/stepmod_cm_record/stepmod_cm_releases/stepmod_cm_release"/>
				</xsl:if>
				<!-- Generate a new cm_release element. -->
				<stepmod_cm_release release="{$release}" tag="{$tag}" who="{$who}" when="{$when}" description="{$description}">
					<xsl:comment> A list of all the issues that have been addressed by this release
           </xsl:comment>
					<issues>
            *** INSERT ISSUE ELEMENTS ***
      </issues>
				</stepmod_cm_release>
			</stepmod_cm_releases>
		</stepmod_cm_record>
	</xsl:template>
	<xsl:template match="stepmod_cm_release">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template name="release-comment">
		<xsl:comment> A relase of the STEPmod framework
         release
           the release identifier
         who
           the person who created the release
         when
           the date when the release was created
         description
           free text description of the release
  </xsl:comment>
	</xsl:template>
</xsl:stylesheet>
