<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
	$Id: sect_5_main.xsl,v 1.4 2003/05/22 21:27:11 robbod Exp $
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
    <xsl:variable name="module_partno" select="concat('ISO 10303-',$module_xml/module/@part)"/>
    <xsl:variable name="module_href" select="concat('../../../modules/',$module,'/sys/cover',$FILE_EXT)"/>
    <xsl:variable name="module_clause5" select="concat('../../../modules/',$module,'/sys/5_main',$FILE_EXT)"/>

    <xsl:call-template name="clause_header">
      <xsl:with-param name="heading" select="'5 Application interpreted model'"/>
      <xsl:with-param name="aname" select="'mim'"/>
    </xsl:call-template>
    <p>
      The application interpreted model for this AP is the module interpreted
      model in Clause 
      <a href="{$module_clause5}">5</a> of the AP module, 
      <a href="{$module_href}"><xsl:value-of select="$module_partno"/></a>.
    </p>

    <p class="note">
      <small>
        NOTE&#160;1&#160;&#160;
        The application interpreted model consists of the mapping
        specification and the EXPRESS short form.
      </small>
    </p>

    <p class="note">
      <small>
        NOTE&#160;2&#160;&#160;
        The Application object index contains a complete list of the
        mappings of Application objects identified in the information
        requirements in the AP module, 
        <a href="{$module_href}"><xsl:value-of select="$module_partno"/></a>.
      </small>
    </p>

  </xsl:template>
	
</xsl:stylesheet>
