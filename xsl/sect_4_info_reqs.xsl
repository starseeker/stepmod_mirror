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

  <xsl:import href="module.xsl"/>

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
  <xsl:import href="module_clause.xsl"/>
  <xsl:import href="expressg_icon.xsl"/> 


  <xsl:output method="html"/>

    <!-- global variable - Used by templates in expressg_icon.xsl to
         resolve href for expressg icon -->
    <xsl:variable name="arm_expressg">
      <xsl:call-template name="make_arm_expressg_node_set"/>
    </xsl:variable>
    
    <!-- global variable - Used by templates in expressg_icon.xsl to
         resolve href for expressg icon -->
    <xsl:variable name="mim_expressg">
      <xsl:call-template name="make_mim_expressg_node_set"/>
    </xsl:variable>


<!-- overwrites the template declared in module.xsl -->
<xsl:template match="module">
  <xsl:apply-templates select="arm"/>
</xsl:template>
  
</xsl:stylesheet>
