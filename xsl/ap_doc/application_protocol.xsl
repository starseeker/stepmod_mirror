<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: application_protocol.xsl,v 1.25 2003/06/06 09:07:12 robbod Exp $
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
 

  <!-- returns a list of annexes with content as a string with each annex name as a single word(no spaces)
       separated by spaces -->
  <xsl:template match="application_protocol" mode="annex_list" >
    <xsl:variable name="module_dir">
      <xsl:call-template name="ap_module_directory">
        <xsl:with-param name="application_protocol" select="@module_name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="annex_list">
      <xsl:if
        test="document(concat($module_dir,'/module.xml'))/module/arm_lf/express-g">
        <xsl:value-of select="' ARMexpressG '"/>
      </xsl:if>
      <xsl:if
        test="document(concat($module_dir,'/module.xml'))/module/mim_lf/express-g">
        <xsl:value-of select="' MIMexpressG '"/>
      </xsl:if>
      <xsl:value-of select="' computerinterpretablelisting '"/>
      <xsl:if test="./usage_guide">
        <xsl:value-of select="' usageguide '"/>
      </xsl:if>
      <xsl:if test="./tech_disc">
        <xsl:value-of select="' techdisc '"/>
      </xsl:if>
      <xsl:if test="./changes/change_detail">
        <xsl:value-of select="' changedetail '"/>
      </xsl:if>
    </xsl:variable>
    <xsl:value-of select="concat(' ',normalize-space($annex_list),' ')"/>
  </xsl:template>


<xsl:template name="annex_letter" >
  <xsl:param name="annex_name"/>
  <xsl:param name="annex_list"/>
  <!-- returns integer count of position of named annex in list of annexes -->
  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>

  <xsl:variable name="annex" select="concat(translate($annex_name,' ',''),' ')"/>

  <xsl:variable name="pos"
    select="string-length(translate(substring-before($annex_list,$annex),concat($UPPER,$LOWER),''))"/>

  <xsl:value-of select="substring('GHIJK',$pos,1)"/> 
</xsl:template>

  <xsl:template match="application_protocol" mode="abstract">
    <xsl:choose>
      <xsl:when test="./abstract">
        <xsl:apply-templates select="./abstract/*"/>
      </xsl:when>
      <xsl:otherwise>
        <P>
          This part of ISO 10303 specifies the application protocol
          <xsl:value-of select="@name"/>.
      </P>
      <P>
        The following are within the scope of this part of ISO 10303:
      </P>

      <UL>
        <xsl:apply-templates select="./inscope/li"/>
      </UL>
    </xsl:otherwise>
  </xsl:choose>
  </xsl:template>


</xsl:stylesheet>
