<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_e_exp_mim_lf.xsl,v 1.9 2003/10/01 07:49:01 robbod Exp $
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

  <!-- because this is a long form load express_link_lf.xsl which
       overwrites link_object -->
  <xsl:import href="express_link_lf.xsl"/>


  <xsl:output method="html"/>

<!-- overwrites the template declared in module.xsl -->
<xsl:template match="module">
  <!-- debug <xsl:value-of select="$global_xref_list"/> -->
  <xsl:call-template name="clause_header">
    <xsl:with-param name="heading" select="''"/>
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

  <xsl:variable name="wg_group">
    <xsl:call-template name="get_module_wg_group"/>
  </xsl:variable>

  <xsl:call-template name="test_module_wg_group">
    <xsl:with-param name="module" select="."/>
  </xsl:call-template>

  <code>
  (*<br/>
    <xsl:value-of 
      select="concat('ISO/TC 184/SC 4/WG ',$wg_group,'&#160;N',@wg.number.mim_lf, ' - ',
              $stdnumber,' ', $module_name, ' - EXPRESS MIM Long form')"/>
    <xsl:if test="string-length(normalize-space(@wg.number.mim_lf.supersedes))>0">
      <br/>Supersedes 
      <xsl:value-of 
        select="concat('ISO/TC 184/SC 4/WG ',$wg_group,'&#160;N',@wg.number.mim_lf.supersedes)"/>
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
    name="mim_lf_xml"
    select="concat($module_dir,'/mim_lf.xml')"/>

  <!-- get the express and display using the annex_express.xsl stylesheet that
       has been imported.
       -->
  <xsl:apply-templates select="document($mim_lf_xml)/express/schema" mode="code"/>

</xsl:template>



  
</xsl:stylesheet>
