<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: ballot_start.xsl,v 1.1 2002/06/20 12:49:08 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited http://www.eurostep.com
  Purpose: To display a the modules order according to ballot packages

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


  <!-- force the application of the stylesheet to the file specified in the
       file attribute -->
  <xsl:template match="/">
    <xsl:variable name="ballot_index" 
      select="concat('../ballots/',./ballot/@directory,'/ballot_index.xml')"/>
    <xsl:apply-templates select="document($ballot_index)/ballot_index"/>
  </xsl:template>



<xsl:template match="ballot_index">
  <HTML>
    <head>
      <title>
        <xsl:value-of select="@name"/>
      </title>
    </head>
    <body>
      <xsl:call-template name="output_menubar">
        <xsl:with-param name="module_root" select="'.'"/>
        <xsl:with-param name="module_name" select="@name"/>
      </xsl:call-template>
      <hr/>

      <h2>
        Ballot: <xsl:value-of select="@name"/>
      </h2>
      Comprises the following ballot packages:      
      <ul>
        <xsl:apply-templates select="./ballot_package"/>
      </ul>
    </body>
  </HTML>
</xsl:template>


<xsl:template match="ballot_package">
  <xsl:variable name="xref"
    select="concat('./ballot_list',$FILE_EXT,'#',@id,'-',@name)"/>
  <li>
    <a href="{$xref}">
      <xsl:choose>
        <xsl:when test="@id">
          <xsl:value-of select="concat(@id,' - ',@name)"/>    
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@name"/> 
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </li>
</xsl:template>

</xsl:stylesheet>