<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_3_defs.xsl,v 1.4 2006/03/11 01:22:50 thendrix Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="resource.xsl"/>

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
  <xsl:import href="resource_clause.xsl"/>


  <xsl:output method="html"/>

<!-- overwrites the template declared in resource.xsl -->
<xsl:template match="resource">
  <!-- Output the terms identified in the normative references -->
  <h2>
    <a name="defns">
      <!--
      <xsl:choose>
        <xsl:when test="./definition/term">
          3 Terms, definitions and abbreviated terms
        </xsl:when>
        <xsl:otherwise>
          3 Terms and abbreviations
        </xsl:otherwise>
      </xsl:choose>
-->
      <xsl:choose>
        <xsl:when test="./abbreviation">
          3 Terms, definitions and abbreviated terms
        </xsl:when>
        <xsl:otherwise>
          <!-- every module references Terms defined in other standards,
               and abbreviations hence as per ISO -->
          3 Terms, definitions and abbreviated terms
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </h2>
  <xsl:call-template name="output_terms">
    <xsl:with-param name="current_resource" select="."/>
    <xsl:with-param name="resource_number" select="./@part"/>
  </xsl:call-template>
</xsl:template>
  
</xsl:stylesheet>
