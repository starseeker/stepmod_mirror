<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
     $Id: parameters.xsl,v 1.3 2004/01/29 23:55:26 thendrix Exp $

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
  <xsl:import href="../error_params.xsl"/>



  <!-- parameters that control the output -->

  <!-- the name of a cascading stylesheet. If no cascading stylesheets
       are required do set the paramter null -->
  <!-- <xsl:param name="output_css" select="'stepmod.css'"/> -->

  <xsl:param name="output_css" select="''"/>

  <!-- When YES the  table of contents will be output -->
  <xsl:param name="output_toc" select="''"/>

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
  <xsl:param name="INLINE_ERRORS" select="'YES'"/>


  <!-- when YES issues will be read from the issues.xml file stored in the
       resource directory -->
  <xsl:param name="output_issues" select="'YES'"/>

  <!-- when repository then accessing from repository xml 
       when other, then accessing from ballot or publication build -->
  <xsl:param name="view" select="'repository'"/>



</xsl:stylesheet>