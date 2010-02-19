<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: ballot_modules.xsl,v 1.5 2003/08/15 16:21:41 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: Display a list of ballot packages.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="modules_list.xsl"/>

  <xsl:output method="html"/>

  <xsl:template match="/" >
    <xsl:apply-templates select="./stylesheet_application"/>
  </xsl:template>

  <xsl:template match="stylesheet_application">
    <xsl:apply-templates select="document('../../publication/part1000/cr_index.xml')/part1000.change_requests"/>
  </xsl:template>

  
  <xsl:template match="part1000.change_requests">
  <html>
    <head>
      <link rel="stylesheet" type="text/css" href="./css/nav.css"/>
      <title>
        SMRL change requests
      </title>
      <script language="JavaScript"><![CDATA[

          function swap(ShowDiv, HideDiv) {
            show(ShowDiv) ;
            hide(HideDiv) ;
          }

          function show(DivID) {
            DivID.style.display="block";
          }

          function hide(DivID) {
            DivID.style.display="none";
          }
      ]]></script>
    </head>
    <body>
      <xsl:apply-templates select="part1000.change_request"/>
    </body>
  </html>
</xsl:template>


  <xsl:template match="part1000.change_request">
  <xsl:variable name="Menu" select="concat('Menu',@name)"/>
  <xsl:variable name="NoMenu" select="concat('NoMenu',@name)"/>

  <xsl:variable name="crhome" 
    select="concat('../publication/part1000/',@name,'/')"/>
  <div id="{$Menu}" style="display:none">
    <p class="menulist">
      <a href="javascript:swap({$NoMenu}, {$Menu});">
        <img src="../images/minus.gif" alt="Close menu" 
          border="false" align="middle"/>    
      </a>
      <a href="{$crhome}sys/publication_summary{$FILE_EXT}" target="content">
        <xsl:value-of select="@name"/>
      </a>
    </p>
    
    <p class="menuitem1">
      <a href="{$crhome}sys/publication_summary{$FILE_EXT}" target="content">
        Change request summary
      </a>
    </p>
    
    <p class="menuitem1">
      <a href="{$crhome}sys/bibliography_check{$FILE_EXT}" target="content">
        Bibliography check
      </a>
    </p>

    <p class="menuitem1">
      <a href="{$crhome}sys/modules_check{$FILE_EXT}" target="content">
        Modules error check 
      </a>
    </p>
  </div>
  
  <div id="{$NoMenu}">
    <p class="menulist">
      <a href="javascript:swap({$Menu}, {$NoMenu});">
        <img src="../images/plus.gif" alt="Open menu" 
          border="false" align="middle"/> 
      </a>      
      <a href="{$crhome}sys/publication_summary{$FILE_EXT}" target="content">
        <xsl:value-of select="@name"/>
      </a>
    </p>
  </div>
</xsl:template>

</xsl:stylesheet>