<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: sect_a_short_names.xsl,v 1.1 2001/10/22 09:31:59 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="module.xsl"/>

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
  <xsl:import href="module_clause.xsl"/>


  <xsl:output method="html"/>

<!-- overwrites the template declared in module.xsl -->
<xsl:template match="module">
  <xsl:call-template name="annex_header">
    <xsl:with-param name="annex_no" select="'A'"/>
    <xsl:with-param name="heading" select="'MIM short names'"/>
    <xsl:with-param name="aname" select="'annexa'"/>
  </xsl:call-template>

  Entity names in this part of ISO 10303 have been defined in other parts of
  ISO 10303. Requirements on the use of the short names are found in the
  implementation methods included in ISO 10303.  
  
  <blockquote>
    NOTE The EXPRESS entity names are available from Internet:<br/> 

    <xsl:variable name="UPPER"
      select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
    <xsl:variable name="LOWER"
      select="'abcdefghijklmnopqrstuvwxyz'"/>
    <xsl:variable name="mim_schema"
      select="translate(concat(@name,'_mim'),$LOWER, $UPPER)"/>
    
    <xsl:variable name="names_url"
      select="concat('http://www.steptools.com/cgi-bin/getnames.cgi?schema=',
              $mim_schema)"/>
    
    <a href="{$names_url}">
      <xsl:value-of select="$names_url"/>
    </a>
  </blockquote>

</xsl:template>
  
</xsl:stylesheet>
