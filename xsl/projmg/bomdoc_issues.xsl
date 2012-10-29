<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="../document_xsl.xsl" ?>

<!--
$Id: apdoc_issues.xsl,v 1.1 2003/05/23 07:53:02 robbod Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep.
  Purpose: Display the main set of frames for a BOM document.     
-->

<!-- BOM -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	
  <xsl:import href="issues.xsl"/>
  <xsl:output method="html"/>


  <!-- output any issues against the clause identified by 
       general | keywords | contacts | purpose | inscope | outscope
       | normrefs | definition | abbreviations
       | usage_guide | bibliography
       -->
  <xsl:template match="business_object_model" mode="output_clause_issue">
  <xsl:param name="clause"/>
  <xsl:if test="$output_issues='YES'">
    <xsl:variable name="dvlp_fldr" select="@development.folder"/>
    <xsl:if test="string-length($dvlp_fldr)>0">
      <xsl:variable name="issue_file" 
        select="concat('../../data/business_object_model/',@name,'/dvlp/issues.xml')"/>
      <xsl:apply-templates
        select="document($issue_file)/issues/issue[@type=$clause]" 
        mode="inline_issue">
        <xsl:sort select="@status" order="descending"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:if>
</xsl:template>


</xsl:stylesheet>