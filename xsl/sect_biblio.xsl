<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_biblio.xsl,v 1.7 2002/09/13 08:33:25 robbod Exp $
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

  <xsl:import href="projmg/issues.xsl"/> 

  <xsl:output method="html"/>

<!-- overwrites the template declared in module.xsl -->
<xsl:template match="module">
  <div align="left">
    <h2>
      <A NAME="bibliography">Bibliography</A>
    </h2>
  </div>
  
  <!-- output any issues -->
  <xsl:apply-templates select="." mode="output_clause_issue">
    <xsl:with-param name="clause" select="'bibliography'"/>
  </xsl:apply-templates>


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
