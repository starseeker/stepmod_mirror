<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: developer.xsl,v 1.2 2002/09/17 07:04:33 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: 
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="../../xsl/module.xsl"/>


  <xsl:template match="/" >
    <xsl:apply-templates select="./stylesheet_application"/>
  </xsl:template>

  <xsl:template match="stylesheet_application">
    <xsl:variable 
      name="module_xml_file"
      select="concat('../../data/modules/',@directory,'/module.xml')"/>

    <html>
      <link rel="stylesheet" type="text/css"
        href="../../../../nav/css/developer.css"/> 
      <xsl:variable name="title">
        <xsl:apply-templates select="document($module_xml_file)/module"
          mode="title"/>        
      </xsl:variable>
      <title>
        <xsl:value-of select="concat('Development view: ',$title)"/>
      </title>
      <body>
        <xsl:apply-templates select="document($module_xml_file)/module"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="module">
    <xsl:apply-templates select="." mode="banner"/>
    <xsl:apply-templates select="." mode="cover"/>
    <xsl:apply-templates select="./purpose"/>
    <xsl:apply-templates select="./inscope"/>
    <xsl:apply-templates select="./outscope"/>

  </xsl:template>

  <xsl:template match="module" mode="banner">
    <div class="toc">
      <!-- output the Table of contents banner -->
      <xsl:apply-templates 
        select="."
        mode="TOCmultiplePage">
        <xsl:with-param name="module_root" select="'..'"/>
      </xsl:apply-templates>
    </div>
  </xsl:template>

  <xsl:template match="module" mode="cover">
    <xsl:variable name="n_number"
      select="concat('ISO TC184/SC4/WG12&#160;N',./@wg.number)"/>
    <xsl:variable name="test_wg_number">
      <xsl:call-template name="test_wg_number">
        <xsl:with-param name="wgnumber" select="./@wg.number"/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="module_name">
      <xsl:call-template name="module_display_name">
        <xsl:with-param name="module" select="./@name"/>
      </xsl:call-template>           
    </xsl:variable>
    
    <xsl:variable name="stdnumber">
      <xsl:call-template name="get_module_pageheader">
        <xsl:with-param name="module" select="."/>
      </xsl:call-template>
    </xsl:variable>

    <h3>       
      <xsl:value-of select="concat('Module: ',$module_name,'&#160;&#160;&#160;',$stdnumber)"/>
    </h3>
    <div class="summarytable">
      <table border="1">
        <tr>
          <td valign="top">WG12 Module number:</td>
          <td valign="top">
            <xsl:value-of select="$n_number"/>
            <xsl:if test="contains($test_wg_number,'Error')">
              <br/>
              <xsl:call-template name="error_message">
                <xsl:with-param name="message">
                  <xsl:value-of select="concat('Error in
                                        module.xml/module/@wg.number - ',
                                        $test_wg_number)"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:if>
          </td>
          
          <xsl:if test="@wg.number.supersedes">
            <td valign="top">Supersedes</td>
            <td valign="top">
              <xsl:choose>
                <xsl:when test="contains(@wg.number.supersedes, 'ISO')">
                  <xsl:value-of select="@wg.number.supersedes"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of 
                    select="concat('ISO&#160;TC184/SC4/WG12&#160;N',@wg.number.supersedes)"/>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:variable name="test_wg_number_supersedes">
                <xsl:call-template name="test_wg_number">
                  <xsl:with-param name="wgnumber" select="./@wg.number.supersedes"/>
                </xsl:call-template>
              </xsl:variable>
              
              <xsl:if test="contains($test_wg_number_supersedes,'Error')">
                <br/>
                <xsl:call-template name="error_message">
                  <xsl:with-param name="message">
                    <xsl:value-of 
                      select="concat('Error in
                              module.xml/module/@wg.number.supersedes - ',
                              $test_wg_number_supersedes)"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:if>
              
              <xsl:if test="@wg.number.supersedes = @wg.number">
                <br/>
                <xsl:call-template name="error_message">
                  <xsl:with-param name="message">
                    Error in module.xml/module/@wg.number.supersedes - 
                    Error WG-16: New WG number is the same as superseded WG number.
                  </xsl:with-param>
                </xsl:call-template>            
              </xsl:if>
            </td>
          </xsl:if>
        </tr>
        
        <tr>
          <td valign="top">WG12 ARM number:</td>
          <td valign="top">
            <xsl:value-of
              select="concat('ISO&#160;TC184/SC4/WG12&#160;N',@wg.number.arm)"/>
          </td>
        </tr>
        
        <tr>
          <td valign="top">WG12 MIM number:</td>
          <td valign="top">
            <xsl:value-of 
              select="concat('ISO&#160;TC184/SC4/WG12&#160;N',@wg.number.mim)"/>
          </td>
        </tr>
        
        <tr>
          <td valign="top">
            <b>Publication date:&#x20;</b>
          </td>
          <td valign="top">
            <xsl:choose>
              <xsl:when test="string-length(@publication.year)>0">
                <xsl:value-of select="@publication.year"/>
              </xsl:when>
              <xsl:otherwise>
                -
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        
        <tr>
          <td width="50%" valign="TOP" height="88">
            <a name="contacts"/>
            <xsl:apply-templates select="./contacts/projlead"/>
          </td>
          <td width="50%" valign="TOP" height="88">
            <xsl:apply-templates select="./contacts/editor"/>
          </td>
        </tr>
      </table>
    </div>
  </xsl:template>
    
<xsl:template match="purpose">
  <h3>
    <a name="introduction">
      Introduction
    </a>
  </h3>

  <!-- output any issues -->
  <xsl:apply-templates select=".." mode="output_clause_issue">
    <xsl:with-param name="clause" select="'purpose'"/>
  </xsl:apply-templates>

  <!-- output the introduction -->
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="inscope">
  <xsl:variable name="module_name">
    <xsl:call-template name="module_display_name">
      <xsl:with-param name="module" select="../@name"/>
    </xsl:call-template>           
  </xsl:variable>
  <h3>In scope</h3>
  <p>
    The following are within the scope of 
    <xsl:value-of select="$module_name"/>.
    <a name="inscope"/>
  </p>

  <!-- output any issues -->
  <xsl:apply-templates select=".." mode="output_clause_issue">
    <xsl:with-param name="clause" select="'inscope'"/>
  </xsl:apply-templates>

  <ul>
    <xsl:apply-templates/>
  </ul>
</xsl:template>


<xsl:template match="outscope">
  <h3>Out of scope</h3>
  <xsl:variable name="module_name">
    <xsl:call-template name="module_display_name">
      <xsl:with-param name="module" select="../@name"/>
    </xsl:call-template>           
  </xsl:variable>
  <p>
    <a name="outscope"/>
    The following are outside the scope of 
    <xsl:value-of select="$module_name"/>.
  </p>
  <!-- output any issues -->
  <xsl:apply-templates select=".." mode="output_clause_issue">
    <xsl:with-param name="clause" select="'outscope'"/>
  </xsl:apply-templates>

  <ul>
    <xsl:apply-templates/>
  </ul>
</xsl:template>


</xsl:stylesheet>