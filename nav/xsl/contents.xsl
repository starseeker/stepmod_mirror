<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: common.xsl,v 1.23 2002/02/14 16:47:52 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: Set up the contents frame along the top
     The contents are defined in the index.xml file
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="../../xsl/common.xsl"/>


  <xsl:output method="html"/>


  <xsl:template match="/" >
    <xsl:apply-templates select="./stylesheet_application"/>
  </xsl:template>

  <xsl:template match="stylesheet_application">
    <xsl:apply-templates select="document(@file)/contentsindex"/>
  </xsl:template>

<xsl:template match="contentsindex">
   <xsl:variable name="title" 
    select="string(@title)" />

   <xsl:variable name="icon" 
    select="string(@icon)" />

  <xsl:variable name="icon_href" 
    select="string(@icon_href)" />


   <xsl:variable 
     name="cols"
     select="count(./IndexItem)+2" />

  <xsl:variable name="col_break">
    <xsl:choose>
      <xsl:when test="@columns">
        <xsl:value-of select="@columns"/>
      </xsl:when>
      <xsl:when test="count(./IndexItem) > 14">
        12
      </xsl:when>
      <xsl:otherwise>
         <xsl:value-of select="count(./IndexItem)"/>
       </xsl:otherwise>
     </xsl:choose>     
   </xsl:variable>



  <HTML>
    <head>
      <link rel="stylesheet" type="text/css" href="../css/stepmod.css"/>
      <title>
        <xsl:value-of select="$title" />
      </title>
    </head>
    <body>       
    <center> 

    <table width="95%"  border="0" cellspacing="1" height="30">
      <tr>
        <td align="left"  valign="top" width="80">
          <xsl:if test="@icon">
            <a HREF="{$icon_href}" Target="_top">
              <IMG SRC="{$icon}" border="0"/>
            </a>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="$FILE_EXT='.xml'">
              <A HREF="../html/module.htm" Target="_top">.</A>
            </xsl:when>
            <xsl:otherwise>
              <A HREF="../model/module.xml" Target="_top">.</A>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td align="left" valign="top" width="200">
          <h3><xsl:value-of select="$title"/></h3>
        </td>
          
        <td align="left" valign="top" >
          <table>
            <tr align="center">
              <!-- only output if within the range of start to end -->
              
              <xsl:apply-templates select="./indexitem[$col_break >= position()]"/>
            </tr>
            <tr align="center">
              <xsl:apply-templates select="./indexitem[position()>$col_break]"/> 
             </tr>
           </table>
         </td>
         
        </tr>
        <tr>
          <td colspan="3" valign="top"><hr size="3" color="#000080" /></td>
        </tr>
      </table>
    </center>
  </body>
  </HTML>
</xsl:template>


<xsl:template match="indexitem">
  <xsl:variable name="f_ext" >
    <xsl:choose>
      <xsl:when test="@ext">
        <xsl:value-of select="@ext" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$FILE_EXT" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <td height="16" valign="top">        
  <a href="{@href}{$f_ext}" target="{@target}">
    <font face="Arial Narrow" size="2">
      <xsl:value-of select="@entry" /> &#160;&#124;&#160;
      </font>
    </a>
  </td>
</xsl:template>

</xsl:stylesheet>
