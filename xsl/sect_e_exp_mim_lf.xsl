<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_e_exp_mim_lf.xsl,v 1.3 2002/03/04 07:50:08 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: Display the MIM long form express 
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="module.xsl"/>
  <xsl:import href="express_code.xsl"/>

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
  <xsl:import href="module_clause.xsl"/>


  <xsl:output method="html"/>

  <!-- +++++++++++++++++++
         Global variables
       +++++++++++++++++++ -->

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
      global_xref_list defined in sect_e_exp_arm.xsl
    </xsl:message> -->
    <xsl:choose>
      <xsl:when test="/module_clause">
        <xsl:variable name="module_dir">
          <xsl:call-template name="module_directory">
            <xsl:with-param name="module" select="/module_clause/@directory"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="express_xml" select="concat($module_dir,'/mim_lf.xml')"/>
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
        
        <xsl:variable name="express_xml" select="concat($module_dir,'/mim_lf.xml')"/>
        <xsl:call-template name="build_xref_list">
          <xsl:with-param name="express" select="document($express_xml)/express"/>
        </xsl:call-template>        
      </xsl:when>
    </xsl:choose>
  </xsl:variable>


  <!-- +++++++++++++++++++
         Templates
       +++++++++++++++++++ -->

<!-- overwrites the template declared in module.xsl -->
<xsl:template match="module">
  <!-- debug <xsl:value-of select="$global_xref_list"/> -->
  <xsl:call-template name="clause_header">
    <xsl:with-param name="heading" select="'Annex E - MIM Long form EXPRESS'"/>
    <xsl:with-param name="aname" select="'annexe-mim_lf-express'"/>
  </xsl:call-template>
  
  <xsl:variable name="stdnumber">
    <xsl:call-template name="get_module_iso_number">
      <xsl:with-param name="module" select="./@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="module_name">
    <xsl:call-template name="module_display_name">
      <xsl:with-param name="module" select="./@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="test_module_wg_group">
    <xsl:with-param name="module" select="."/>
  </xsl:call-template>

  <code>
  (*<br/>
    <xsl:value-of 
      select="concat($stdnumber,' ', $module_name, ' - EXPRESS MIM')"/>
    <br/>*)
  </code>
  <br/>

  <!-- output all the EXPRESS specifications -->
  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable 
    name="mim_lf_xml"
    select="concat($module_dir,'/mim_lf.xml')"/>

  <!-- get the express and display using the annex_express.xsl stylesheet that
       has been imported.
       -->
  <xsl:apply-templates select="document($mim_lf_xml)/express/schema" mode="code"/>

</xsl:template>



  
</xsl:stylesheet>
