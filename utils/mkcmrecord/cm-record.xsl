<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- $Id: $ -->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" indent="yes" doctype-system="..\..\..\dtd\cm_record.dtd"/>

<xsl:param name="release">*** FILL IN ***</xsl:param>
<xsl:param name="stepmod_release">*** FILL IN ***</xsl:param>
<xsl:param name="release_sequence">*** FILL IN ***</xsl:param>
<xsl:param name="edition">*** FILL IN ***</xsl:param>
<xsl:param name="who">*** FILL IN ***</xsl:param>
<xsl:param name="when">*** FILL IN ***</xsl:param>
<xsl:param name="description">*** FILL IN ***</xsl:param>
<xsl:param name="status">*** FILL IN ***</xsl:param>
<xsl:param name="record_exists">true</xsl:param>

<xsl:template match="/">
  <xsl:apply-templates select="module"/>
</xsl:template>

<xsl:template match="module">
  <xsl:comment> <xsl:value-of select="concat('$','Id: $')"/> </xsl:comment>

<xsl:call-template name="cm-record-comment"/>
<cm_record
  part_name="{@name}"
  part_type="module"
  part_number="{@part}"
  cvs_revision="{concat('$','Revision: $')}"
  cvs_date="{concat('$','Date: $')}">
<cm_releases>
   <xsl:call-template name="release-comment"/>
   <!-- If there is an existing cm_record.xml file, copy its cm_release elements. -->
   <xsl:if test="$record_exists = 'true'">
     <xsl:for-each select="document('cm_record.xml',.)/cm_record/cm_releases/cm_release">
       <xsl:copy-of select="."/>
     </xsl:for-each>
   </xsl:if>
   <!-- Generate a new cm_release element corresponding to the versions of the files
        in the current directory. -->
   <xsl:call-template name="new-cm-release"/>
</cm_releases>
</cm_record>
</xsl:template>

<xsl:template name="new-cm-release">
   <cm_release
      release="{$release}"
      stepmod_release="{$stepmod_release}"
      release_sequence="{$release_sequence}"
      edition="{$edition}"
      who="{$who}"
      when="{$when}"
      description="{$description}"
      status="{$status}">
    <dependencies>
      <sources>
      </sources>
      <xsl:apply-templates select="document('mim.xml',.)/express"/>
    </dependencies>
   </cm_release>
</xsl:template>

<xsl:template match="express">
  <xsl:variable name="resource">
    <xsl:apply-templates select="schema/interface">
      <xsl:with-param name="visited">|</xsl:with-param>
    </xsl:apply-templates>
  </xsl:variable>
  <resource_schemas>
    <xsl:for-each select="$resource/resource[not(@name = preceding-sibling::resource/@name)]">
      <xsl:sort select="@name"/>
      <xsl:copy-of select="."/>
    </xsl:for-each>
  </resource_schemas>
</xsl:template>

<xsl:template match="interface">
  <xsl:param name="visited"/>
  <xsl:variable name="schema" select="@schema"/>
  <xsl:if test="not(contains($visited,concat('|',$schema,'|')))">
    <xsl:if test="document('../../repository_index.xml')/repository_index/resources/resource[@name = $schema]">
      <xsl:apply-templates select="document(concat('../../data/resources/',$schema,'/',$schema,'.xml'))/express/schema" mode="resource">
        <xsl:with-param name="visited" select="$visited"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template match="schema" mode="resource">
  <xsl:param name="visited"/>
  <!-- <p>Visited = <xsl:value-of select="$visited"/></p> -->
  <resource name="{@name}" part="{../@reference}" release="{$release}"/>
  <xsl:apply-templates select="interface">
    <xsl:with-param name="visited" select="concat($visited,@name,'|')"/>
  </xsl:apply-templates>
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