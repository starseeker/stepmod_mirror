<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: sect_3_defs.xsl,v 1.2 2001/12/31 08:43:01 robbod Exp $
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
  <!-- Output the terms identified in the normative references -->
  <h3>3 Terms, definitions and abbreviations</h3>
  <xsl:variable name="next_section">

  </xsl:variable>
  <xsl:call-template name="output_terms"/>      
</xsl:template>
  
</xsl:stylesheet>
