<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_3_defs.xsl,v 1.8 2003/03/13 19:17:04 robbod Exp $
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
  <!--
       ISO requested:
       - If clause 3 only contains terms and definitions, the title of the
         clause shall be "Terms and definitions". 

       - If clause 3 only contains terms, definitions, and abbreviations,
         the title of the clause shall be "Terms, definitions, and abbreviations". 

       - If clause 3 only contains terms, definitions, and symbols, the
          title of the clause shall be "Terms, definitions, and symbols". 

       - If clause 3 contains terms, definitions, abbreviations, and
         symbols, the title of the clause shall be "Terms, definitions,
         abbreviations, and symbols".  
       -->
  <h2>
    <a name="defns">
      <xsl:choose>
        <xsl:when test="./definition/term">
          3 Terms, definitions and abbreviations
        </xsl:when>
        <xsl:otherwise>
          <!-- every module references Terms defined in other standards,
               and abbreviations hence as per ISO -->
          3 Terms, definitions and abbreviations
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </h2>
  <xsl:call-template name="output_terms">
    <xsl:with-param name="module_number" select="./@part"/>
  </xsl:call-template>
</xsl:template>
  
</xsl:stylesheet>
