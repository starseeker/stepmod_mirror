<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
     $Id: menubar_params.xsl,v 1.4 2002/07/31 07:58:37 robbod Exp $

  Author: Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep
  Purpose: 
     Used to identify the menubar displayed at the top of modules.
     ONLY menubar_default.xml should be checked in
-->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>


  <!-- Every module can display a menubar at the top of the module.
       The default menubar is menubar_default.xml -->


  <!--   -->
  <xsl:param name="menubar_file" select="'menubar_default.xml'"/>


  <!-- 
  <xsl:param name="menubar_file" select="'../plcsmod/menubar.xml'"/>
  -->

  <!--
  <xsl:param name="menubar_file" select="'./ballots/ballots/pdm_ballot_072002/menubar_iso.xml'"/>
-->

</xsl:stylesheet>