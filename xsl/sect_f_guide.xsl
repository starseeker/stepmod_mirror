<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_f_guide.xsl,v 1.4 2002/09/02 09:09:57 robbod Exp $
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
    <xsl:with-param name="annex_no" select="'F'"/>
    <xsl:with-param name="heading" 
      select="'Application module implementation and usage guide'"/>
    <xsl:with-param name="aname" select="'annexf'"/>
  </xsl:call-template>

  <xsl:choose>
    <xsl:when test="usage_guide">
      <xsl:apply-templates select="usage_guide"/>
    </xsl:when>
    <xsl:otherwise>
      <p>
        An Application module implementation and usage guide has not been
        provided.
      </p>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
