<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
     $Id: parameters.xsl,v 1.8 2002/06/17 15:48:54 robbod Exp $

  Author: Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep and supplied to NIST under contract.
  Purpose: 
     Used to display the commented XML encoded Express generated 
     from GraphicalExpress 
-->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>

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



  <!-- Every module can display a menubar at the top of the module.
       The default menubar is menubar_default.xml -->
  <!--
  <xsl:param name="menubar_file" select="'menubar_default.xml'"/>
  <xsl:param name="menubar_file" select="'../plcsmod/menubar.xml'"/>
  <xsl:param name="menubar_file" select="'menubar_pdm_ballot.xml'"/>
  -->
  <xsl:param name="menubar_file" select="'menubar_default.xml'"/>


</xsl:stylesheet>