<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
     $Id: parameters.xsl,v 1.13 2003/05/17 01:01:07 thendrix Exp $

  Author: Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep and supplied to NIST under contract.
  Purpose: 
     Used to set global parameters 
-->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>

  <!--
       Parameters to set the menu bar.
       This may be customized by the user, hence a separate file
       -->
  <xsl:import href="menubar_params.xsl"/>



  <!-- parameters that control the output -->

  <!-- the name of a cascading stylesheet. If no cascading stylesheets
       are required do set the paramter null -->
  <!-- <xsl:param name="output_css" select="'stepmod.css'"/> -->
  <xsl:param name="output_css" select="''"/>

  <!-- When YES the Table of schema table of contents will be output -->
  <xsl:param name="output_toc" select="'YES'"/>

  <!-- When YES the RCS version control information will be output 
       Used by:
       xsl:template match="module" mode="title" in common.xsl
       xsl:template match="module" mode="TOCbannertitle" in common.xsl
       -->
  <xsl:param name="output_rcs" select="'YES'"/>

  <!-- When 
          'yes' the errors will be displayed in the HTML
          'no' the errors will only be reported as messages.
       Used by:
       xsl:template name="error_message" in common.xsl
       -->
  <xsl:param name="INLINE_ERRORS" select="'yes'"/>


  <!-- When 
          'yes' the mapping tables will be checked and errors will be
                displayed in the HTML 
          'no'  NO checking is done 
       Turning off mapping checking will speed up display of mapping
       tables as a list of all mim and integrated resources are loaded into
       global variables.      
       Used by:
       sect5_mapping.xsl
       -->
  <xsl:param name="check_mapping" select="'yes'"/>


  <!-- when YES issues will be read from the issues.xml file stored in the
       module directory -->
  <xsl:param name="output_issues" select="'YES'"/>


  <!-- when YES modules will have a background image  -->
  <xsl:param name="output_background" select="'NO'"/>

  <!-- file containing background image  -->
  <xsl:param name="background_image" select="'refonly.gif'"/>

  <!-- when length is 0, use the rcs date. Otherwise use value of param, as when building -->
  <xsl:param name="coverpage_date" select="''"/>

  <!-- The path to the modules. This will be overwritten from the
       ballot package generation as the ballots html is stored in
       stepmod/ballots/isohtml/<ballot>/data/modules-->
  <xsl:param name="STEPMOD_DATA_MODULES" select="'../../../../../stepmod/data/modules/'"/>

  <!-- The path to the resources. This will be overwritten from the
       ballot package generation as the ballots html is stored in
       stepmod/ballots/isohtml/<ballot>/data/resources-->
  <xsl:param name="STEPMOD_DATA_RESOURCES" select="'../../../../../stepmod/data/resources/'"/>

  <!-- The path to the ap_docs. This will be overwritten from the
       ballot package generation as the ballots html is stored in
       stepmod/ballots/isohtml/<ballot>/data/ap_docs-->
  <xsl:param name="STEPMOD_DATA_APS" select="'../../../../../stepmod/data/application_protocol/'"/>
</xsl:stylesheet>