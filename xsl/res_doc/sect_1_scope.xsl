<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_1_scope.xsl,v 1.1 2002/10/16 00:43:38 thendrix Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: Output the Scope section as a web page
     
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
  <h1>
    Industrial automation systems and integration &#8212; <br/>
    Product data representation and exchange &#8212;  <br/>
    Part <xsl:value-of select="@part"/>:<br/>
    Integrated generic resource: 
    <xsl:call-template name="res_display_name">
      <xsl:with-param name="res" select="@name"/>
    </xsl:call-template>
  </h1>
  <xsl:apply-templates select="./inscope"/>
  <xsl:apply-templates select="./outscope"/>
</xsl:template>
  
</xsl:stylesheet>




