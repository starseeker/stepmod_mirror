<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_3_defs.xsl,v 1.4 2002/03/04 07:50:08 robbod Exp $
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
  <a name="defns">
    <h3>
      <xsl:choose>
        <xsl:when test="./definition/term">
          3 Terms, definitions and abbreviations
        </xsl:when>
        <xsl:otherwise>
          3 Terms and abbreviations
        </xsl:otherwise>
      </xsl:choose>
    </h3>
  </a>
  <xsl:call-template name="output_terms"/>      
</xsl:template>
  
</xsl:stylesheet>
