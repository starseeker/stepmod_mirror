<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: ballot_shortnames.xsl,v 1.2 2003/01/22 01:50:49 thendrix Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited http://www.eurostep.com
  Purpose: To display a table summarising the modules in a ballot package
     including all the WG numbers

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="./common.xsl"/>
  <xsl:import href="../../xsl/res_doc/common.xsl"/>
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
        <xsl:with-param name="new_menubar_file" 
          select="concat('./ballots/ballots/',@name,'/menubar_ballot.xml')"/>
      </xsl:call-template>
      <hr/>
      <xsl:call-template name="ballot_header"/>
      <h2>Shortnames</h2>
      <p>
        The following shortnames have been declared in the modules
        submitted for ballot and must be registered.
      </p>
      <table border="1">
        <tr>
          <td><b>Part</b></td>
          <td><b>Number</b></td>
          <td><b>Entity</b></td>
          <td><b>Shortname</b></td>
        </tr>
        <xsl:choose>
          <xsl:when test="./*/module">
            <xsl:apply-templates select="./*/module">
              <xsl:sort select="@name"/>
            </xsl:apply-templates>        
          </xsl:when>
          <xsl:when test="./*/resource">
            <xsl:apply-templates select="./*/res_doc">
              <xsl:sort select="@name"/>
            </xsl:apply-templates>        
          </xsl:when>        
        </xsl:choose>
      </table>
    </body>
  </HTML>
</xsl:template>

<xsl:template match="module">
  <xsl:variable name="module_ok">
    <xsl:call-template name="check_module_exists">
      <xsl:with-param name="module" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$module_ok='true'">

      <xsl:variable name="module_file"
        select="concat('../../data/modules/',@name,'/module.xml')"/>
      <xsl:apply-templates 
        select="document($module_file)/module/mim/shortnames/shortname">
        <xsl:sort select="@entity"/>
      </xsl:apply-templates>
    </xsl:when>

    <!-- module does not exist in repository index -->
    <xsl:otherwise>
      <tr>
        <td>
          <xsl:value-of select="../@name"/>
        </td>
        <td>
          <xsl:value-of select="@name"/>
          <xsl:call-template name="error_message">
            <xsl:with-param name="message">
              <xsl:value-of select="concat('Error ballot1: ', $module_ok)"/>
            </xsl:with-param>
          </xsl:call-template>
        </td>
        <td>&#160;</td>
        <td>&#160;</td>
      </tr>      
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="res_doc">

  <xsl:variable name="resdoc_ok">
    <xsl:call-template name="check_resdoc_exists">
      <xsl:with-param name="resdoc" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$resdoc_ok='true'">
      <xsl:variable name="resdoc_file"
        select="concat('../../data/resource_docs/',@name,'/resource.xml')"/>
      <xsl:apply-templates 
        select="document($resdoc_file)/resource/shortnames/shortname">
        <xsl:sort select="@entity"/>
      </xsl:apply-templates>
    </xsl:when>

    <!-- resource does not exist in repository index -->
    <xsl:otherwise>
      <tr>
        <td>
          <xsl:value-of select="../@name"/>
        </td>
        <td>
          <xsl:value-of select="@name"/>
          <xsl:call-template name="error_message">
            <xsl:with-param name="message">
              <xsl:value-of select="concat('Error ballot1: ', $resdoc_ok)"/>
            </xsl:with-param>
          </xsl:call-template>
        </td>
        <td>&#160;</td>
        <td>&#160;</td>
      </tr>      
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="shortname">
  <tr>
    <!-- Module -->
    <td>
      <xsl:value-of select="../../../@part"/>
    </td>
    <td>
      <xsl:value-of select="../../../@name"/>
    </td>
    
    <!-- Shortnames -->
    <td>
      <xsl:value-of select="@entity"/>
    </td>
    <td>
      <xsl:value-of select="@name"/>
    </td>
  </tr>
</xsl:template>


</xsl:stylesheet>