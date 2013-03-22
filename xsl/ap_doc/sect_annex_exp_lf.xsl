<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_annex_exp_lf.xsl,v 1.9 2013/03/21 20:39:01 mikeward Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose:     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:import href="application_protocol.xsl"/>
  <xsl:import href="application_protocol_clause.xsl"/>
  <xsl:output method="html"/>
	
  <xsl:template match="application_protocol">
    
    <!-- BOM -->
    <xsl:variable name="bom_name" select="@business_object_model"/>
    
    
    

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
	     <xsl:choose>
	       <xsl:when test="$module_xml/module/@status='TS'">
	         <xsl:value-of select="concat('ISO/',$module_xml/module/@status,' 10303-',$module_xml/module/@part)"/>
	       </xsl:when>
	       <xsl:otherwise>
	         <xsl:value-of select="concat('ISO 10303-',$module_xml/module/@part)"/>
	       </xsl:otherwise>
	     </xsl:choose>
      </xsl:if>
    </xsl:variable>



    <xsl:call-template name="annex_header">
      <xsl:with-param name="annex_no" select="'A'"/>
      <xsl:with-param name="heading" select="'Listings'"/>
      <xsl:with-param name="aname" select="'annexa_lf'"/>
      <xsl:with-param name="informative" select="'normative'"/>
    </xsl:call-template>

    <xsl:call-template name="clause_header">
      <xsl:with-param name="heading" select="'A.1 ARM EXPRESS expanded listing'"/>
      <xsl:with-param name="aname" select="'annexa1'"/>
    </xsl:call-template>
   <!-- <xsl:variable name="arm_lf_href" 
   select="concat('../../../modules/',$module,'/sys/e_exp_arm_lf',$FILE_EXT)"/>-->
    
    <xsl:variable name="arm_lf_href" 
      select="concat('../../../modules/',$module,'/arm_lf.exp')"/>

    <xsl:variable name="annex_e_href" 
      select="concat('../../../modules/',$module,'/sys/e_exp',$FILE_EXT)"/>

    <p>
      The 
      <a href="{$arm_lf_href}">
        ARM EXPRESS 
      </a>
      expanded listing for this part of ISO 10303 is provided in 
<!--    Annex <a href="{$annex_e_href}">E</a> of  --> 
      the AP module, 
      <a href="{$module_href}"><xsl:value-of select="$module_partno"/></a>.
    </p>

    <xsl:call-template name="clause_header">
      <xsl:with-param name="heading" select="'A.2 MIM  EXPRESS expanded listing'"/>
      <xsl:with-param name="aname" select="'annexa2'"/>
    </xsl:call-template>
    <xsl:variable name="mim_lf_href" 
      select="concat('../../../modules/',$module,'/arm_lf.exp')"/>

    <p>
      The 
      <a href="{$mim_lf_href}">
        MIM EXPRESS 
      </a>
      expanded listing for this part of ISO 10303 is provided in 
<!--     Annex <a href="{$annex_e_href}">E</a> of  --> 
      the AP module, 
      <a href="{$module_href}"><xsl:value-of select="$module_partno"/></a>.
    </p>
    <!-- BOM -->
    <xsl:if test="string-length($bom_name) > 0">
      
      <xsl:variable name="bom_number">
        <xsl:variable name="path_to_bom" select="concat('../../data/business_object_models/', $bom_name, '/business_object_model.xml')"/>
        <xsl:value-of select="document($path_to_bom)//business_object_model/@part"/>
      </xsl:variable>
      
      <xsl:variable name="bom_iso_number" select="concat('ISO/TS 10303-', $bom_number)"/>
      
      <xsl:variable name="path_to_bom_home" select="concat('../../../../data/business_object_models/', $bom_name, '/home', $FILE_EXT)"/>
      
    <!-- BOM exp -->
      
    <xsl:call-template name="clause_header">
      <xsl:with-param name="heading" select="'A.3 BO Model EXPRESS listing'"/>
      <xsl:with-param name="aname" select="'annexa3'"/>
    </xsl:call-template>
      
    <xsl:variable name="bom_exp_href" 
      select="concat('../../../business_object_models/',$bom_name,'/bom.exp')"/>
    <p>
      The 
      <a href="{$bom_exp_href}" target="_blank">
        BO Model EXPRESS 
      </a>
      expanded listing for this part of ISO 10303 is provided in 
      <!--     Annex <a href="{$annex_e_href}">E</a> of  --> 
      the BO Model, 
      <a href="{$path_to_bom_home}" target="_blank"><xsl:value-of select="$bom_iso_number"/></a>.
    </p>
      
      <!-- BOM xsd -->
    
    <xsl:call-template name="clause_header">
      <xsl:with-param name="heading" select="'A.4 BO Model XML Schema listing'"/>
      <xsl:with-param name="aname" select="'annexa4'"/>
    </xsl:call-template>
    <xsl:variable name="bom_xsd_href" 
      select="concat('../../../business_object_models/',$bom_name,'/bom.xsd')"/>
    
    <p>
      The 
      <a href="{$bom_xsd_href}" target="_blank">
        BO Model XML Schema 
      </a>
      listing for this part of ISO 10303 is provided in 
      <!--     Annex <a href="{$annex_e_href}">E</a> of  --> 
      the BO Model, 
      <a href="{$path_to_bom_home}" target="_blank"><xsl:value-of select="$bom_iso_number"/></a>.
    </p>
    
      <!-- BOM config -->
    
    <xsl:call-template name="clause_header">
      <xsl:with-param name="heading" select="'A.5 BO Model XSD Configuration listing'"/>
      <xsl:with-param name="aname" select="'annexa5'"/>
    </xsl:call-template>
      
    <xsl:variable name="bom_config_href" 
      select="concat('../../../business_object_models/',$bom_name,'/p28_config.xml')"/>
    
    <p>
      The 
      <a href="{$bom_config_href}" target="_blank">
        BO Model XSD Configuration
      </a>
      listing for this part of ISO 10303 is provided in 
      <!--     Annex <a href="{$annex_e_href}">E</a> of  --> 
      the BO Model, 
      <a href="{$path_to_bom_home}" target="_blank"><xsl:value-of select="$bom_iso_number"/></a>.
    </p>
    </xsl:if>
    
  </xsl:template> 


</xsl:stylesheet>