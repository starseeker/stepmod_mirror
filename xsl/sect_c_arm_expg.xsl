<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_c_arm_expg.xsl,v 1.3 2002/03/04 07:50:08 robbod Exp $
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
    <xsl:with-param name="annex_no" select="'C'"/>
    <xsl:with-param name="heading" 
      select="'ARM EXPRESS-G'"/>
    <xsl:with-param name="aname" select="'annexc'"/>
  </xsl:call-template>

The following diagrams provide a graphical representation of the EXPRESS structure and constructs specified in clause 4.
The diagrams are presented in EXPRESS-G. 
<p>The EXPRESS-G  graphical notation is defined in annex D of ISO 10303-11.</p> 

  <xsl:apply-templates select="arm/express-g"/>
</xsl:template>
  
</xsl:stylesheet>
