<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_4_info_reqs.xsl,v 1.3 2002/03/04 07:50:08 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: Output section 4 Information model as a web page
     
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
  <xsl:apply-templates select="schema[position()=5]"/>
</xsl:template>
  
</xsl:stylesheet>

