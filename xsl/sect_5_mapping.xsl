<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: sect_5_mapping.xsl,v 1.2 2001/11/14 17:58:47 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="module.xsl"/>

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
  <xsl:import href="module_clause.xsl"/>


  <xsl:output method="html"/>

<!-- overwrites the template declared in module.xsl -->
<xsl:template match="module">
  <xsl:apply-templates select="./mapping_table" mode="toc"/>
  <xsl:apply-templates select="./mapping_table/ae" mode="table"/>
</xsl:template>

<xsl:template match="mapping_table" mode="toc">
  <xsl:variable name="table_count" select="(count(./ae)+1) div 2"/>
  <blockquote>
    <table width="90%" cellspacing="0" cellpadding="4">
      <tr>
        <td>
          <xsl:apply-templates 
            select="./ae[not(position() > $table_count)]"
            mode="toc">
            <xsl:sort select="@entity"/>
          </xsl:apply-templates>
        </td>
        <td>
          <xsl:apply-templates 
            select="./ae[position() > $table_count]"
            mode="toc">
            <xsl:sort select="@entity"/>
          </xsl:apply-templates>
        </td>
      </tr>
    </table>
  </blockquote>
  <hr/>
</xsl:template>

<xsl:template match="ae" mode="toc">
  <xsl:variable name="aname" select="@entity"/>
  <a href="#{$aname}">
    <xsl:value-of select="concat('Table: ', $aname)"/>
  </a>
  <br/>
</xsl:template>

<xsl:template match="ae" mode="table">
  <xsl:variable name="aname" select="@entity"/>
  <a name="{$aname}">
    <h3>
      <a href="../../../basic/mapping.htm">Mapping specification</a>
    </h3>
  </a>
  <h3>
      <xsl:value-of select="concat('Table ',position(),' - ', @entity)"/>
  </h3>
  <table border="1" width="622">
    <tr>
      <td VALIGN="TOP" width="21%">
        <font size="-1"><b>Application element</b></font>
      </td>
      <td VALIGN="TOP" width="21%">
        <font size="-1"><b>MIM element</b></font>
      </td>
      <td VALIGN="TOP" width="6%">
        <font size="-1"><b>Source</b></font>
      </td>
      <td VALIGN="TOP" width="5%">
        <font size="-1"><b>Rules</b></font>
      </td>
      <td VALIGN="TOP" width="47%">
        <font size="-1"><b>Reference path</b></font>
      </td>
    </tr>

    <tr>
      <td VALIGN="TOP" width="21%">
        <font size="-1">
          <a href="">
            <xsl:value-of select="@entity"/>
          </a>
        </font>
      </td>

      <xsl:apply-templates select="./aimelt"/>
      <xsl:apply-templates select="./source"/>

      <!-- no rules -->
      <td VALIGN="TOP" width="5%">&#160;</td>
      
      <!-- ref path-->
      <td VALIGN="TOP" width="47%">&#160;</td>
    </tr>
    
    <!-- now do the attributes rows -->
    <xsl:apply-templates select="./aa"/>
  </table>
</xsl:template>

<xsl:template match="aa">
  <tr>
    <td VALIGN="TOP" width="21%">
      <font size="-1">
        <a href="">
          <xsl:value-of select="@attribute"/>
        </a>
      </font>
    </td>
    
    <xsl:apply-templates select="./aimelt"/>
    <xsl:apply-templates select="./source"/>
    
    <!-- no rules -->
    <td VALIGN="TOP" width="5%">&#160;</td>
    
    <!-- ref path-->
    <td VALIGN="TOP" width="47%">&#160;</td>    
  </tr>
</xsl:template>

<xsl:template match="aimelt">
  <td VALIGN="TOP" width="21%">
    <font size="-1">
      <a href="">
        <xsl:value-of select="string(.)"/>
      </a>
    </font>
  </td>
</xsl:template>

<xsl:template match="source">
  <td VALIGN="TOP" width="6%">
    <font size="-1">
      <xsl:value-of select="string(.)"/>
    </font>
  </td>        
</xsl:template>

 
</xsl:stylesheet>
