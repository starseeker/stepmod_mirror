<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
     $Id: menubar_params.xsl,v 1.5 2002/08/07 12:09:14 mikeward Exp $

  Author: Mike Ward, Eurostep Limited
  Owner:  Developed by Eurostep
  Purpose: 
     Used to identify the menubar displayed at the top of business object modules.
     ONLY menubar_default.xml should be checked in
-->

<!-- BOM -->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>

  <xsl:param name="menubar_file" select="'menubar_default.xml'"/>


</xsl:stylesheet>