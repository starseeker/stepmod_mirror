<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: banner.xsl,v 1.4 2002/09/10 09:49:44 nigelshaw Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: Set up a banner plus menus in the top frame
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="../../xsl/common.xsl"/>


  <xsl:output method="html"/>


  <xsl:template match="/" >
    <xsl:apply-templates select="./stylesheet_application"/>
  </xsl:template>

  <xsl:template match="stylesheet_application">
    <html>
      <head>
        <link rel="stylesheet" type="text/css" href="./css/nav.css"/>
        <title>
          ddd
        </title>
        </head>
        <body>
          <div class="bannerbackground">
          <table width="95%"  border="0" cellspacing="1" height="30">
            <tr>
              <td align="left" valign="top" width="140">
                <p class="bannertitle">
                  <a href="./index{$FILE_EXT}" target="_top">
                    STEPmod
                  </a>
                </p>
                <p class="bannertitleitem">
                  <xsl:choose>
                    <xsl:when test="$FILE_EXT='.xml'">
                      <A HREF="./index.htm" Target="_top">HTML</A>
                    </xsl:when>
                    <xsl:otherwise>
                      <A HREF="./index.xml" Target="_top">XML</A>
                    </xsl:otherwise>
                  </xsl:choose>
                  &#160;&#160;&#160;
                  <a href="../help/index.htm" Target="content">Help</a>
                </p>
              </td>
              <td align="left" valign="top">
                <p class="bannermenu">Modules</p>
                <p class="bannermenuitem">
                  <a href="modules_alpha{$FILE_EXT}" target="index">
                    Alphabetical list
                  </a>
                </p>
                <p class="bannermenuitem">
                  <a href="modules_project{$FILE_EXT}" target="index">
                    Project leader list
                  </a>
                </p>
                <p class="bannermenuitem">
                  <a href="modules_numbers{$FILE_EXT}" target="index">
                    Part number list
                  </a>
                </p>
                <p class="bannermenuitem">
                  <a href="repository_dependencies{$FILE_EXT}" target="content">
                    Module dependencies
                  </a>
                </p>
              </td>

              <td align="left" valign="top">
                <p class="bannermenu">Express</p>
                <p class="bannermenuitem">
                  <a href="arm_objects{$FILE_EXT}" target="index">
                    ARM objects
                  </a>
                </p>
                <p class="bannermenuitem">
                  <a href="mim_objects{$FILE_EXT}" target="index">
                    MIM objects
                  </a>
                </p>
                <p class="bannermenuitem">
                  <a href="resource_objects{$FILE_EXT}" target="index">
                    Resource objects
                  </a>
                </p>
              </td>

              <td align="left" valign="top">
                <p class="bannermenu">Application Protocols</p>
                <p class="bannermenuitem">
                  Alphabetical list
                </p>
                <p class="bannermenuitem">
                  Project leader list
                </p>
                <p class="bannermenuitem">
                  Part number list
                </p>
              </td>

              <td align="left" valign="top">
                <p class="bannermenu">Common resources</p>
                <p class="bannermenuitem">
                  <a href="resource_schema_alpha{$FILE_EXT}" target="index">
                    Alphabetical list
                  </a>
                </p>
                <p class="bannermenuitem">
                  Part number list
                </p>
              </td>


              <td align="left" valign="top">
                <p class="bannermenu">Ballots</p>
                <p class="bannermenuitem">
                  <a href="ballot_modules{$FILE_EXT}" target="index">
                    Ballots
                  </a>
                </p>
              </td>
            </tr>
          </table>
        </div>
        </body>
      </html>
    </xsl:template>

</xsl:stylesheet>
