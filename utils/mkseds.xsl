<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: sect_5_main.xsl,v 1.11 2003/08/11 16:48:03 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep
  Purpose: Generate a SEDS report
-->

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  version="1.0">

  <xsl:import href="../xsl/common.xsl"/>


  <xsl:output method="text"/>

  
  <xsl:param name="issue_id" select="'ISSUE_ID NOT SET'"/>
  <xsl:param name="seds_author_name" select="'seds_author_name  NOT SET'"/>
  <xsl:param name="seds_author_email" select="'seds_author_email NOT SET'"/>
  <xsl:param name="seds_date" select="'seds_date NOT SET'"/>
  <xsl:param name="seds_by" select="'seds_by NOT SET'"/>


  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="$issue_id='ISSUE ID NOT SET'">
        <xsl:message>
          ISSUE ID NOT SET
        </xsl:message>
      </xsl:when>
      <xsl:when test="/issues/issue[@id=$issue_id]">
        <xsl:message>
          <xsl:value-of select="concat('Issue: ',$issue_id,' found')"/>
        </xsl:message>
        <xsl:apply-templates select="/issues/issue[@id=$issue_id]" mode="seds"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>
          <xsl:value-of select="concat('Issue: ',$issue_id,' not found')"/>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="issues" mode="get_part">
    <xsl:variable name="part">
      <xsl:choose>
        <xsl:when test="string-length(@module)>0">
          <xsl:call-template name="get_module_iso_number">
            <xsl:with-param name="module"
              select="document(concat('../data/modules/',@module,'/module.xml'))/module/@name"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="string-length(@ap_doc)>0">
          <xsl:call-template name="get_protocol_iso_number">
            <xsl:with-param name="module"
              select="document(concat('../data/application_protocols/',@ap_doc,'/application_protocol.xml'))/application_protocol/@name"/>
          </xsl:call-template>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:value-of select="translate($part,'&#160;',' ')"/>
  </xsl:template>

  <xsl:template match="issue"  mode="seds">
    <xsl:variable name="part">
      <xsl:apply-templates select="/issues" mode="get_part"/>
    </xsl:variable>
    
Section 1. GENERAL INFORMATION (completed by SEDS Coordinator):
SEDS Report Issue Number: 
Date Submitted: <xsl:value-of select="$seds_date"/>
Status and date: 
SEDS Team Leader: 
SEDS Team Members: 

Section 2. ENHANCEMENT AND DISCREPANCY INFORMATION (completed by author of SEDS Report):
Author: <xsl:value-of select="concat($seds_author_name,' (',$seds_author_email,')')"/>
Submitted by: <xsl:value-of select="$seds_date"/>
Part/Clause Affected by the Issue: <xsl:value-of select="$part"/>
Other Parts Affected by the Issue: 
Problem Description:
<xsl:apply-templates select="."/>
Proposed Solution (Optional):

Additional Notes:

Section 3. RESPONSE INFORMATION (completed by SEDS Team Leader):
Accepted/Rejected (date): 
If Accepted, Resolution: 

If Rejected, Reason:
Solution:
Comments:

Section 4. FOLLOW-UP INFORMATION (completed by WG Convener):
Class: 
Priority: 
Impact of Change: 
Further Action Required: 
Action Required by SEDS Coordinator/WG Conveners/QC/SC4:
  </xsl:template>
</xsl:stylesheet>
