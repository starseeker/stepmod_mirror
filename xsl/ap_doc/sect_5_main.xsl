<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_5_main.xsl,v 1.12 2008/04/23 20:52:04 darla Exp $
  Author:  Mike Ward, Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: Display the main set of frames for an AP document.     
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="application_protocol.xsl"/>
  <xsl:import href="application_protocol_clause.xsl"/>	

  <xsl:output method="html"/>
	
  
  <xsl:template match="application_protocol">

    <xsl:variable name="module" select="/application_protocol/@module_name"/>
    <xsl:variable name="module_ok">
      <xsl:call-template name="check_module_exists">
        <xsl:with-param name="module" select="$module"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$module_ok!='true'">
      <xsl:call-template name="error_message">
        <xsl:with-param name="message">
          <xsl:value-of select="concat('Error AP1: The module ',$module,' does not exist.',
                                '  Correct application_protocol module_name in application_protocol.xml')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <xsl:variable name="module_dir">
      <xsl:call-template name="ap_module_directory">
        <xsl:with-param name="application_protocol" select="$module"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="module_xml" select="document(concat($module_dir,'/module.xml'))"/>
    <xsl:variable name="module_partno">
     <xsl:choose>
       <xsl:when test="$module_xml/module/@status='TS'">
         <xsl:value-of select="concat('ISO/',$module_xml/module/@status,' 10303-',$module_xml/module/@part)"/>
       </xsl:when>
       <xsl:otherwise>
         <xsl:value-of select="concat('ISO 10303-',$module_xml/module/@part)"/>
       </xsl:otherwise>
     </xsl:choose>
    </xsl:variable>
    <xsl:variable name="module_href" select="concat('../../../modules/',$module,'/sys/cover',$FILE_EXT)"/>
    <xsl:variable name="module_clause5" select="concat('../../../modules/',$module,'/sys/5_main',$FILE_EXT)"/>
    <xsl:variable name="module_clause51" 
      select="concat('../../../modules/',$module,'/sys/5_mapping',$FILE_EXT,'#mapping')"/>
    <xsl:variable name="module_clause52" 
      select="concat('../../../modules/',$module,'/sys/5_mim',$FILE_EXT,'#mim_express')"/>
    <xsl:call-template name="clause_header">
      <xsl:with-param name="heading" select="'5 Module interpreted model'"/>
      <xsl:with-param name="aname" select="'mim'"/>
    </xsl:call-template>
    <p>
      The module interpreted model for this AP is the module interpreted
      model (MIM) specified in 
<!--     Clause <a href="{$module_clause5}">5</a> of  --> 
      the AP module, 
      <a href="{$module_href}"><xsl:value-of select="$module_partno"/></a>,
      which consists of the mapping specification and the EXPRESS short form.
    </p>

    <p>
      The mapping specification found in 
<!--     Clause <a href="{$module_clause51}">5.1</a> of  --> 
      the AP module, 
      <a href="{$module_href}"><xsl:value-of select="$module_partno"/></a>,
      shows (through inclusion or reference) how each application object maps
      to one or more MIM constructs. 
    </p>

    <p class="note">
      <small>
        NOTE&#160;1&#160;&#160;
        The ARM entity mapping
        <a href="index_arm_mappings{$FILE_EXT}" target="index">index</a>
        contains a complete list of the
        mappings of ARM entities identified (through inclusion or
        reference) in the information requirements in the AP module 
        (<a href="{$module_href}"><xsl:value-of select="$module_partno"/></a>).
      </small>
    </p>

    <p>
      The EXPRESS schema that uses elements from the integrated resources and
      other application modules and contains the types, entity
      specializations, rules and functions that are specific to this part of
      ISO 10303 are specified in 
<!--     Clause <a href="{$module_clause52}">5.2</a> of  --> 
      the AP module,  
      <a href="{$module_href}"><xsl:value-of select="$module_partno"/></a>.
    </p>

    <p class="note">
      <small>
        NOTE&#160;2&#160;&#160;
        The MIM EXPRESS
        <a href="index_mim_express{$FILE_EXT}" target="index">index</a>
        contains a complete list of MIM
        objects identified in 
<!--        Clause <a href="{$module_clause5}">5.2</a> of  --> 
        the AP module 
         (<a href="{$module_href}"><xsl:value-of select="$module_partno"/></a>).
      </small>
    </p>

  </xsl:template>
	
</xsl:stylesheet>
