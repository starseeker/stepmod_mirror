<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- $Id: cm-record.xsl,v 1.6 2008/02/20 02:25:37 radack Exp $ -->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" indent="yes" doctype-system="..\..\..\dtd\cm_record.dtd"/>

<xsl:param name="part_name">*** FILL IN ***</xsl:param>
<xsl:param name="release">*** FILL IN ***</xsl:param>
<xsl:param name="release_status">*** FILL IN ***</xsl:param>
<xsl:param name="stepmod_common_release">*** FILL IN ***</xsl:param>
<xsl:param name="stepmod_framework_release">*** FILL IN ***</xsl:param>
<xsl:param name="release_sequence">*** FILL IN ***</xsl:param>
<xsl:param name="edition">*** FILL IN ***</xsl:param>
<xsl:param name="who">*** FILL IN ***</xsl:param>
<xsl:param name="when">*** FILL IN ***</xsl:param>
<xsl:param name="description">*** FILL IN ***</xsl:param>
<xsl:param name="status">*** FILL IN ***</xsl:param>
<xsl:param name="existing_record_url"/>

<xsl:template match="/">
  <xsl:comment>
    <xsl:text> </xsl:text>
    <xsl:value-of select="concat('$','Id: $')"/>
    <xsl:text> </xsl:text>
  </xsl:comment>
  <xsl:apply-templates select="module|express"/>
</xsl:template>

<xsl:template match="module">
  <xsl:call-template name="cm-record">
    <xsl:with-param name="part_number" select="@part"/>
    <xsl:with-param name="part_type">module</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="express">
  <xsl:call-template name="cm-record">
    <xsl:with-param name="part_number" select="@reference"/>
    <xsl:with-param name="part_type">resource</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="cm-record">
  <xsl:param name="part_number"/>
  <xsl:param name="part_type"/>
  <xsl:call-template name="cm-record-comment"/>
  <cm_record
      part_name="{$part_name}"
      part_type="{$part_type}"
      part_number="{$part_number}"
      cvs_revision="{concat('$','Revision: $')}"
      cvs_date="{concat('$','Date: $')}">
    <cm_releases>
       <xsl:call-template name="release-comment"/>
       <!-- If there is an existing cm_record.xml file, copy its cm_release elements. -->
      <xsl:if test="$existing_record_url">
        <xsl:apply-templates select="document($existing_record_url,.)/cm_record/cm_releases/cm_release"/>
      </xsl:if>
      <!-- Generate a new cm_release element corresponding to the versions of the files
            in the current directory. -->
      <cm_release
          release="{$release}"
          release_status="{$release_status}"
          stepmod_common_release="{$stepmod_common_release}"
          stepmod_framework_release="{$stepmod_framework_release}"
          release_sequence="{$release_sequence}"
          edition="{$edition}"
          who="{$who}"
          when="{$when}"
          description="{$description}"
          iso_status="{$status}">
        <dependencies>
          <sources>
            *** INSERT DIRECTORY ELEMENTS ***
          </sources>
	  <resource_schemas>
            <!-- <xsl:apply-templates select="document('mim.xml',.)/express"/> -->
	  </resource_schemas>
        </dependencies>
      </cm_release>
    </cm_releases>
  </cm_record>
</xsl:template>

<!--
<xsl:template match="express">
  <xsl:variable name="resource">
    <xsl:apply-templates select="schema/interface">
      <xsl:with-param name="visited">|</xsl:with-param>
    </xsl:apply-templates>
  </xsl:variable>
  <xsl:for-each select="$resource/resource[not(@name = preceding-sibling::resource/@name)]">
    <xsl:sort select="@name"/>
    <xsl:copy-of select="."/>
  </xsl:for-each>
</xsl:template>
-->

<xsl:template match="cm_release">
  <xsl:copy-of select="."/>
</xsl:template>

<xsl:template name="release-comment">
   <xsl:comment> A relase of the part
         release
           the release identifier
         stepmod_release
           the release of STEPmod used to create HTML for the release
         edition
           the edition of the part that has been released
         who
           the person who created the release
         when
           the date when the release was created
         description
           free text description of the release
         status
           A record of the status of the release. The status of the release
           will only change if it passes a review with no changes. If there
           are any changes required during the review, then a new release will be
           created. The following statuses are allowed:
            - Team review - the release distributed for Team review
            - Convener review - the release distributed for Convener review
            - Secretariat review - the release distributed for Secretariat review
            - ISO review - the release distributed for Team review
            - Ballot - the release distributed for ballot
            - ISO publication - the release has been published by ISO
   </xsl:comment>
</xsl:template>

<xsl:template name="cm-record-comment">
  <xsl:comment> A configuration management record
     part_name
       The name of the STEP part
     part_type
       The type of the STEP part. Either module, application_protocol or resource_doc
     part_number
       The ISO part number
     cvs_revision
       The file revision of the cm record. (RCS keyword Revision)
     cvs_date
       The date of the file revision. (RCS keyword Date)
  </xsl:comment>
</xsl:template>

</xsl:stylesheet>
