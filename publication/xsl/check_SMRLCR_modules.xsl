<?xml version="1.0" encoding="utf-8"?>
<!--
$ Id: build.xsl,v 1.9 2003/02/26 02:12:17 thendrix Exp $
   Author:  Rob Bodington, Eurostep Limited
   Owner:   Developed by Eurostep Limited http://www.eurostep.com and supplied to NIST under contract.
   Purpose: Perform checks on the modules in a SMRL publication. 
-->

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exslt="http://exslt.org/common"
  exclude-result-prefixes="exslt"
  version="1.0">
  
  <xsl:import href="../../xsl/common.xsl"/>

  <xsl:output method="text" indent="yes"/>
  

  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>
  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  
  <xsl:template match="part1000.publication_index">    
    <xsl:variable name="iso_publication_date" select="normalize-space(@date.iso_publication)"/>
    <xsl:variable name="iso_publication_year" select="substring-before($iso_publication_date,'-')"/>
    
    <xsl:if test="string-length($iso_publication_date)=0">      
      <xsl:message>ERROR X: publication_index.xml the @date.iso_publication attribute has not been set</xsl:message>
    </xsl:if>
    
    <xsl:for-each select="modules/module">
      <!-- check module exists -->
      <xsl:variable name="module_ok">
        <xsl:call-template name="check_module_exists">
          <xsl:with-param name="module" select="@name"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="$module_ok!='true'">
        <xsl:message>
          <xsl:value-of select="concat('ERROR A: Module ', @name,' module does not exist in repository_index.xml.')"/>
        </xsl:message>
      </xsl:if>
      
      <!-- check the publication years -->
      <xsl:variable name="module_path" select="concat('../../data/modules/',@name,'/module.xml')"/>
      <xsl:variable name="module" select="document($module_path)"/>
      <xsl:if test="$module/module/@published!='y'">        
        <xsl:message>
          <xsl:value-of select="concat('ERROR B: Module ', @name,' - module/@published is: ',$module/module/@published,' should be y.')"/>
        </xsl:message>
      </xsl:if>      
      <xsl:if test="$module/module/@publication.year!=$iso_publication_year">        
        <xsl:message>
          <xsl:value-of select="concat('ERROR C: Module ', @name,' - module/@publication.year is: ',$module/module/@publication.year,' should be ',$iso_publication_year)"/>
        </xsl:message>
      </xsl:if>     
      <xsl:if test="$module/module/@publication.date!=$iso_publication_date">      
        <xsl:message>
          <xsl:value-of select="concat('ERROR D: Module ', @name,' - module/@publication.date is: ',$module/module/@publication.date,' should be ',$iso_publication_date)"/>
        </xsl:message>
      </xsl:if>
      
      <xsl:if test="$module/module/@status!='TS'">      
        <xsl:message>
          <xsl:value-of select="concat('ERROR E: Module ', @name,' - module/@status is: ',$module/module/@status,' should be TS')"/>
        </xsl:message>
      </xsl:if>      
      <xsl:if test="$module/module/@language!='E'">      
        <xsl:message>
          <xsl:value-of select="concat('ERROR F: Module ', @name,' - module/@language is: ',$module/module/@language,' should be E')"/>
        </xsl:message>
      </xsl:if>   
    </xsl:for-each>
  </xsl:template>


</xsl:stylesheet>
