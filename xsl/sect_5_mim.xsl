<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_5_mim.xsl,v 1.4 2002/03/04 07:50:08 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="module.xsl"/>
  <xsl:import href="expressg_icon.xsl"/> 

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
  <xsl:import href="module_clause.xsl"/>


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

  <!-- 
       Global variable used in express_link.xsl by:
         link_object
         link_list
       Provides a lookup table of all the references for the entities and
       types indexed through all the interface specifications in the
       express.
       Note:  This variable must defined in each XSL that is used for
       formatting express.
         sect_4_info.xsl
         sect_5_mim.xsl
         sect_e_exp_arm.xsl
         sect_e_exp_mim.xsl
       build_xref_list is defined in express_link
       -->
  <xsl:variable name="global_xref_list">
    <!-- debug 
    <xsl:message>
      global_xref_list defined in sect_5_mim.xsl
    </xsl:message> -->
    <xsl:choose>
      <xsl:when test="/module_clause">
        <xsl:variable name="module_dir">
          <xsl:call-template name="module_directory">
            <xsl:with-param name="module" select="/module_clause/@directory"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="express_xml" select="concat($module_dir,'/mim.xml')"/>
        <xsl:call-template name="build_xref_list">
          <xsl:with-param name="express" select="document($express_xml)/express"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="/module">
        <xsl:variable name="module_dir">
          <xsl:call-template name="module_directory">
            <xsl:with-param name="module" select="/module/@name"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="express_xml" select="concat($module_dir,'/mim.xml')"/>
        <xsl:call-template name="build_xref_list">
          <xsl:with-param name="express" select="document($express_xml)/express"/>
        </xsl:call-template>        
      </xsl:when>
    </xsl:choose>
  </xsl:variable>





<!-- overwrites the template declared in module.xsl -->
<xsl:template match="module">
  <xsl:apply-templates select="mim"/>
</xsl:template>
  
</xsl:stylesheet>
