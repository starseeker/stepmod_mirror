<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
     $Id: error_params.xsl,v 1.3 2004/11/15 14:30:00 robbod Exp $

  Author: Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep.
  Purpose: 
     Used to set global parameters controlling the display of errors


                       DO NOT CHECK THIS FILE IN


     IF YOU MAKE ANY CHANGES TO THIS FILE, PLEASE NOT CHECK IT IN TO
     SOURCEFORGE AS YOU WILL AFFECT EVERYONES COPY

-->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>

  
  <!-- If YES, all items in a list are checked to see if they end in ;
       apart from the last one which should end in .
       If not then and error is flagged -->
  <xsl:param name="ERROR_CHECK_LIST_ITEMS" select="'NO'"/>

  <!-- If YES, will apply checks to attributes -->
  <xsl:param name="ERROR_CHECK_ATTRIBUTES" select="'NO'"/>


  <!-- If YES, will apply checks to ISO cover page -->
  <xsl:param name="ERROR_CHECK_ISOCOVER" select="'NO'"/>




</xsl:stylesheet>