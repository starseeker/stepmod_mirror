<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: application_protocol.xsl,v 1.22 2003/05/23 15:52:56 robbod Exp $
  Author:  Mike Ward, Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: Display the main set of frames for an AP document.     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!-- <xsl:import href="../module.xsl"/> -->
  <xsl:import href="application_protocol_toc.xsl"/>
  <!-- <xsl:import href="sect_4_express.xsl"/> -->
  <xsl:import href="common.xsl"/>
  <xsl:import href="../projmg/apdoc_issues.xsl"/>
  
  <xsl:output method="html" doctype-system="http://www.w3.org/TR/html4/loose.dtd" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" indent="yes"/>

  <xsl:template match="/">
    <HTML>
      <HEAD>
        <TITLE>
          <xsl:apply-templates select="./application_protocol" mode="title"/>
        </TITLE>
      </HEAD>
      <BODY>
        <xsl:apply-templates select="./application_protocol" mode="TOCsinglePage"/>
        <xsl:apply-templates select="./application_protocol"/>
      </BODY>
    </HTML>
  </xsl:template>
  
  <!-- The templates for the display of each clause are partly in the files sect_xxx.xsl 
       The concept of priority between homonym templates is used to display either the application protocol
       file content or the ap module file content -->
  
  <xsl:template match="application_protocol" mode="title">
    <xsl:variable name="lpart">
      <xsl:choose>
        <xsl:when test="string-length(@part)>0">
          <xsl:value-of select="@part"/>
        </xsl:when>
        <xsl:otherwise>
          XXXX
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="stdnumber">
      <xsl:call-template name="get_protocol_stdnumber">
        <xsl:with-param name="application_protocol" select="."/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="protocol_name">
      <xsl:call-template name="protocol_display_name">
        <xsl:with-param name="application_protocol" select="@name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="concat($stdnumber,' ',$protocol_name)"/>                
  </xsl:template>

</xsl:stylesheet>
