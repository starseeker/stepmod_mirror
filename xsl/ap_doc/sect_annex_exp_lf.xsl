<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_a_exp_lf.xsl,v 1.1 2003/05/23 15:50:29 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose:     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:import href="application_protocol.xsl"/>
  <xsl:import href="application_protocol_clause.xsl"/>
  <xsl:output method="html"/>
	
  <xsl:template match="application_protocol">

    <xsl:variable name="module" select="@module_name"/>
    <xsl:variable name="module_ok">
      <xsl:call-template name="check_module_exists">
        <xsl:with-param name="module" select="$module"/>
      </xsl:call-template>
    </xsl:variable>
     
    <xsl:variable name="module_name">
      <xsl:call-template name="module_display_name">
        <xsl:with-param name="module" select="$module"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="$module_ok!='true'">
      <xsl:call-template name="error_message">
        <xsl:with-param name="message">
          <xsl:value-of select="concat('Error APA1: The AP module ',$module,' does not exist.',
                                ' Correct &lt;reqtover module=&gt;in application_protocol.xml')"/>
        </xsl:with-param>
      </xsl:call-template> 
    </xsl:if>

    <xsl:variable name="module_href"
      select="concat('../../../modules/',$module,'/sys/cover',$FILE_EXT)"/>

    <xsl:variable name="module_dir">
      <xsl:call-template name="ap_module_directory">
        <xsl:with-param name="application_protocol" select="$module"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="module_partno">
      <xsl:if test="$module_ok='true'">

        <xsl:variable name="module_xml" select="document(concat($module_dir,'/module.xml'))"/>
        <xsl:value-of select="concat('ISO 10303-',$module_xml/module/@part)"/>
      </xsl:if>
    </xsl:variable>



    <xsl:call-template name="annex_header">
      <xsl:with-param name="annex_no" select="'A'"/>
      <xsl:with-param name="heading" select="'EXPRESS expanded listing'"/>
      <xsl:with-param name="aname" select="'annexa_lf'"/>
      <xsl:with-param name="informative" select="'normative'"/>
    </xsl:call-template>

    <xsl:call-template name="clause_header">
      <xsl:with-param name="heading" select="'A.1 ARM EXPRESS expanded listing'"/>
      <xsl:with-param name="aname" select="'annexa1'"/>
    </xsl:call-template>
    <xsl:variable name="arm_lf_href" 
      select="concat('../../../modules/',$module,'/sys/e_exp_arm_lf',$FILE_EXT)"/>
    <p>
      The EXPRESS expanded listing provided in      
      Annex <a href="{$arm_lf_href}">E</a> of the AP module, 
    <a href="{$module_href}"><xsl:value-of select="$module_partno"/></a>
      shall be used as the expanded listing for this part of
      ISO-10303. 
    </p>

    <xsl:call-template name="clause_header">
      <xsl:with-param name="heading" select="'A.2 AIM  EXPRESS expanded listing'"/>
      <xsl:with-param name="aname" select="'annexa2'"/>
    </xsl:call-template>
    <xsl:variable name="mim_lf_href" 
      select="concat('../../../modules/',$module,'/sys/e_exp_mim_lf',$FILE_EXT)"/>
    <p>
      The EXPRESS expanded listing provided in      
      Annex <a href="{$mim_lf_href}">E</a> of the AP module, 
    <a href="{$module_href}"><xsl:value-of select="$module_partno"/></a>
      shall be used as the expanded listing for this part of
      ISO-10303. 
    </p>
  </xsl:template> 


</xsl:stylesheet>
