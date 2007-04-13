<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" indent="yes" doctype-system="..\..\..\dtd\cm_record.dtd"/>

<xsl:param name="release">*** MY RELEASE ***</xsl:param>

<xsl:template match="/">
  <xsl:apply-templates select="module"/>
</xsl:template>

<xsl:template match="module">
  <xsl:comment> $Id: $ </xsl:comment>

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
<cm_record
  part_name="{@name}"
  part_type="module"
  part_number="{@part}"
  cvs_revision="$Revision: $"
  cvs_date="$Date: $">
<cm_releases>
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
   <cm_release
      release="{$release}"
      stepmod_release="*** FILL IN ***"
      release_sequence="*** FILL IN ***"
      edition="{@version}"
      who="*** FILL IN ***"
      when="*** FILL IN ***"
      description="*** FILL IN ***">
      status="{@status}"
    <dependencies>
      <sources>
      </sources>
      <xsl:apply-templates select="document('mim.xml',.)/express"/>
    </dependencies>
   </cm_release>
</cm_releases>
</cm_record>
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


</xsl:stylesheet>