<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: sect_biblio.xsl,v 1.2 2002/01/03 12:22:13 robbod Exp $
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
  <center>
    <h3>
      <A NAME="bibliography">Bibliography</A>
    </h3>
  </center>
  
  <xsl:choose>
    <xsl:when test="./bibliography">
      <xsl:apply-templates select="./bibliography"/>
    </xsl:when>
    <xsl:otherwise>
      <!-- output the defaults -->
      <xsl:apply-templates 
        select="document('../data/basic/bibliography_default.xml')/bibliography/bibitem.inc"/>      
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>
  
</xsl:stylesheet>
