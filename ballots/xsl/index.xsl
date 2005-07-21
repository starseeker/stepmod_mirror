<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="../../xsl/document_xsl.xsl" ?>
<!--
$Id: index.xsl,v 1.5 2002/08/29 07:01:42 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited http://www.eurostep.com
  Purpose: To display the ballot packages
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="../../xsl/common.xsl"/>


  <xsl:output 
    method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    indent="yes"
    />


  <xsl:template match="/">
    <HTML>
      <head>
        <title>
          Module Ballots
        </title>
      </head>
      <body>
        <h2>Module ballots</h2>
       <xsl:call-template name="output_menubar">
	  <xsl:with-param name="new_menubar_file" select="'ballots/menubar_ballot_index.xml'" />
          <xsl:with-param name="module_root" select="'..'"/>
        </xsl:call-template>
        <hr/>

        <p>
          The modules have been balloted according to the following ballot
          cycles. 
        </p>
        <ul>
          <xsl:apply-templates select="./ballots/ballot"/>
        </ul>
      </body>
    </HTML>
  </xsl:template>

  <xsl:template match="ballot">
    <li>
      <xsl:variable name="xref" 
        select="concat('./ballots/',@name,'/start',$FILE_EXT)"/>
      <a href="{$xref}">
        <xsl:value-of select="@name"/>
      </a>
      <xsl:variable name="bhome" 
        select="concat('./ballots/',@name,'/')"/>
      <ul>
        <li>
          <a href="{$bhome}ballot_list{$FILE_EXT}">
            Ballot list
          </a>
        </li>
        <li>
          <a
            href="{$bhome}ballot_checklist{$FILE_EXT}">
            Ballot checklist
          </a>
        </li>
        <li>
          <a
            href="{$bhome}ballot_shortnames{$FILE_EXT}">
            Shortnames in ballot.
          </a>
        </li>
        <li>
          <a href="{$bhome}ballot_summary{$FILE_EXT}">
            ISO summary
          </a>
        </li>
      </ul>
    </li>
  </xsl:template>

</xsl:stylesheet>