<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="../document_xsl.xsl" ?>

<!--
$Id: frame_aptitle.xsl,v 1.4 2003/05/22 16:55:08 robbod Exp $
  Author:  Mike Ward, Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: Display the main set of frames for an AP document.     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	
  <xsl:import href="issues.xsl"/>
  <xsl:output method="html"/>


  <!-- output any issues against the clause identified by 
       general | keywords | contacts | purpose | inscope | outscope
       | normrefs | definition | abbreviations
       | usage_guide | bibliography
       -->
<xsl:template match="application_protocol" mode="output_clause_issue">
  <xsl:param name="clause"/>
  <xsl:if test="$output_issues='YES'">
    <xsl:variable name="dvlp_fldr" select="@development.folder"/>
    <xsl:if test="string-length($dvlp_fldr)>0">
      <xsl:variable name="issue_file" 
        select="concat('../../data/application_protocols/',@name,'/dvlp/issues.xml')"/>
      <xsl:apply-templates
        select="document($issue_file)/issues/issue[@type=$clause]" 
        mode="inline_issue">
        <xsl:sort select="@status" order="descending"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:if>
</xsl:template>


</xsl:stylesheet>