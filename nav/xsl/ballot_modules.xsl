<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: ballot_modules.xsl,v 1.3 2003/01/20 13:07:45 robbod Exp $
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
    <xsl:apply-templates select="document('../../ballots/index.xml')/ballots"/>
  </xsl:template>

  
<xsl:template match="ballots">
  <html>
    <head>
      <link rel="stylesheet" type="text/css" href="./css/nav.css"/>
      <title>
        <xsl:value-of select="Ballots" />
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
      <xsl:apply-templates select="ballot"/>
    </body>
  </html>
</xsl:template>


<xsl:template match="ballot">
  <xsl:variable name="href" 
    select="concat('../ballots/modules/',@name,'/sys/introduction',$FILE_EXT)"/>
  <xsl:variable name="Menu" select="concat('Menu',@name)"/>
  <xsl:variable name="NoMenu" select="concat('NoMenu',@name)"/>

  <xsl:variable name="bhome" 
    select="concat('../ballots/ballots/',@name,'/')"/>
  <div id="{$Menu}" style="display:none">
    <p class="menulist">
      <a href="javascript:swap({$NoMenu}, {$Menu});">
        <img src="../images/minus.gif" alt="Close menu" 
          border="false" align="middle"/>    
      </a>
      <a href="{$bhome}ballot_list{$FILE_EXT}" target="content">
        <xsl:value-of select="@name"/>
      </a>
    </p>
    
    <p class="menuitem1">
      <a href="{$bhome}ballot_list{$FILE_EXT}" target="content">
        Ballot list
      </a>
    </p>
    
    <p class="menuitem1">
      <a href="{$bhome}ballot_summary{$FILE_EXT}" target="content">
        ISO index
      </a>
    </p>

    <p class="menuitem1">
      <a href="{$bhome}ballot_checklist{$FILE_EXT}" target="content">
        Ballot checklist
      </a>
    </p>
    
    <p class="menuitem1">
      <a href="{$bhome}ballot_shortnames{$FILE_EXT}" target="content">
        Shortnames in ballot.
      </a>
    </p>

    <p class="menuitem1">
      <a href="{$bhome}ballot_issues{$FILE_EXT}" target="content">
        Issues against ballot.
      </a>
    </p>

    <p class="menuitem1">
      <a href="{$bhome}ballot_issues_form_all{$FILE_EXT}" target="content">
        Ballot issue form - all.
      </a>
    </p>
    <p class="menuitem1">
      <a href="{$bhome}ballot_issues_form_open{$FILE_EXT}" target="content">
        Ballot issue form - open.
      </a>
    </p>



    <p class="menuitem1">
      <a href="{$bhome}ballot_cvs_tags{$FILE_EXT}" target="content">
        CVS tags for ballot.xxx
      </a>
    </p>
  </div>
  
  <div id="{$NoMenu}">
    <p class="menulist">
      <a href="javascript:swap({$Menu}, {$NoMenu});">
        <img src="../images/plus.gif" alt="Open menu" 
          border="false" align="middle"/> 
      </a>      
      <a href="{$bhome}ballot_list{$FILE_EXT}" target="content">
        <xsl:value-of select="@name"/>
      </a>
    </p>
  </div>
</xsl:template>

</xsl:stylesheet>