<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_2_refs.xsl,v 1.6 2002/08/05 16:20:48 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: Output the refs section as a web page
     
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
  <xsl:call-template name="output_normrefs">
    <xsl:with-param name="resource_number" select="./@part"/>
    <xsl:with-param name="current_resource" select="."/>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>




