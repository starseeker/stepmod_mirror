<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_schema.xsl,v 1.2 2002/10/23 06:46:56 thendrix Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: Output section 4 Information model as a web page
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="resource.xsl"/>
  <xsl:import href="expressg_icon.xsl"/> 

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
  <xsl:import href="resource_clause.xsl"/>


  <xsl:output method="html"/>

    <!-- global variable - Used by templates in expressg_icon.xsl to
         resolve href for expressg icon -->
    <xsl:variable name="schema_expressg">
      <xsl:call-template name="make_schema_expressg_node_set"/>
    </xsl:variable>    

<!-- overwrites the template declared in resource.xsl -->
<xsl:template match="resource">
  <xsl:param name="pos"/>
  <xsl:apply-templates select="schema[position()=$pos]">
    <xsl:with-param name="pos" select="$pos"/>
  </xsl:apply-templates>
</xsl:template>
  
</xsl:stylesheet>

