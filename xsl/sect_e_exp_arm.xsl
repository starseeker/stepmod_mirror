<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_e_exp_arm.xsl,v 1.8 2003/10/01 07:49:01 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: Display the ARM short form express 
     
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
        
        <xsl:variable name="express_xml" select="concat($module_dir,'/arm.xml')"/>
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
        
        <xsl:variable name="express_xml" select="concat($module_dir,'/arm.xml')"/>
        <xsl:call-template name="build_xref_list">
          <xsl:with-param name="express" select="document($express_xml)/express"/>
        </xsl:call-template>        
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <!-- A global variable used by the express_file_to_ref template defined
       in express_link.xsl.
       It defines the relative path from the file applying the stylesheet
       to the root of the stepmod repository.
       sect_e_exp_arm.xsl stylesheet is normally used
         stepmod/data/module/?module?/sys/e_exp_arm.xml
       Hence the relative root is: ../../../
       -->
  <xsl:variable 
    name="relative_root"
    select="'../../../../'"/>

  <!-- +++++++++++++++++++
         Templates
       +++++++++++++++++++ -->

<!-- overwrites the template declared in module.xsl -->
<xsl:template match="module">
  <!-- debug <xsl:value-of select="$global_xref_list"/> -->
  <xsl:call-template name="clause_header">
    <xsl:with-param name="heading" select="''"/>
    <xsl:with-param name="aname" select="'annexe-arm-express'"/>
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

  <xsl:variable name="wg_group">
    <xsl:call-template name="get_module_wg_group"/>
  </xsl:variable>

  <xsl:call-template name="test_module_wg_group">
    <xsl:with-param name="module" select="."/>
  </xsl:call-template>

  <code>
  (*<br/>
    <xsl:value-of 
      select="concat('ISO/TC 184/SC 4/WG ',$wg_group,'&#160;N',@wg.number.arm, ' - ',
              $stdnumber,' ', $module_name, ' - EXPRESS ARM')"/>
    <xsl:if test="string-length(normalize-space(@wg.number.arm.supersedes))>0">
      <br/>Supersedes 
      <xsl:value-of 
        select="concat('ISO/TC 184/SC 4/WG ',$wg_group,'&#160;N',@wg.number.arm.supersedes)"/>
    </xsl:if>
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
    name="arm_xml"
    select="concat($module_dir,'/arm.xml')"/>
  <!-- get the express and display using the express_code.xsl stylesheet that
       has been imported.
       -->
  <xsl:apply-templates select="document($arm_xml)/express/schema" mode="code"/>

</xsl:template>



  
</xsl:stylesheet>
