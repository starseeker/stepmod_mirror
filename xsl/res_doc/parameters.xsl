<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
     $Id: parameters.xsl,v 1.6 2004/02/11 23:48:02 thendrix Exp $

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
<xsl:import href="../parameters.xsl"/>

  <!-- when repository then accessing from repository xml 
       when other, then accessing from ballot or publication build -->
  <xsl:param name="view" select="'repository'"/>


</xsl:stylesheet>