<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: banner.xsl,v 1.17 2003/04/17 12:30:41 robbod Exp $
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
          Banner
        </title>
      <script language="JavaScript"><![CDATA[
     function closeModuleIndexFrame() {
	var oFramesets=window.parent.document.getElementsByTagName("frameset");
     	oFramesets.item(1).cols="15%,0%,*";
        closed_menu.style.display="block";
        open_menu.style.display="none";
      }
      function openModuleIndexFrame() {
	var oFramesets=window.parent.document.getElementsByTagName("frameset");
     	oFramesets.item(1).cols="15%,15%,70%";
        closed_menu.style.display="none";
        open_menu.style.display="block";
      }
      ]]></script>
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
                <p class="bannermenuitem">&#160;</p>
                <p class="bannermenuitem">
                  <xsl:choose>
                    <xsl:when test="$FILE_EXT='.xml'">
                      <A HREF="./index.htm" Target="_top">HTML</A>
                    </xsl:when>
                    <xsl:otherwise>
                      <A HREF="./index.xml" Target="_top">XML</A>
                    </xsl:otherwise>
                  </xsl:choose>
                  &#160;&#160;&#160;
                  <a href="../help/index.htm"
                    Target="content">Help</a><br/>
                  <div id="closed_menu">
                    <p class="bannermenuitem">
                      Module menu
                      <a href="javascript:openModuleIndexFrame();">
                        <img src="../images/nocross.gif" alt="Open Module menu" 
                          border="false" align="middle"/> 
                      </a>
                    </p>
                  </div>
                  <div id="open_menu" style="display:none">
                    <p class="bannermenuitem">
                      Module menu
                      <a href="javascript:closeModuleIndexFrame();">
                        <img src="../images/cross.gif" alt="Close module menu" 
                          border="false" align="middle"/> 
                      </a>
                    </p>
                  </div>
                </p>
              </td>
              <td align="left" valign="top">
                <p class="bannermenu">Modules</p>
                <p class="bannermenuitem">
                  <a href="modules_alpha{$FILE_EXT}" target="index">
                    Alphabetical,
                  </a>
                  <a href="modules_project{$FILE_EXT}" target="index">
                    Project
                  </a>
                </p>
                <p class="bannermenuitem">
                  <a href="modules_numbers{$FILE_EXT}" target="index">
                    Parts,
                  </a>
                  <a href="modules_project_lead{$FILE_EXT}" target="index">
                    Leader,
                  </a>
                  <a href="modules_status{$FILE_EXT}" target="index">
                    Status,
                  </a>
                  <a href="keywords{$FILE_EXT}" target="index">
                    Keywords,
                  </a>
                </p>
                <p class="bannermenuitem">
                  <a href="definitions{$FILE_EXT}" target="index">
                    Definitions,
                  </a>
                  <a href="repository_dependencies{$FILE_EXT}" target="content">
                    Dependencies
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
                  <a href="ap_alpha{$FILE_EXT}" target="index">
                    Alphabetical,
                  </a>
                  Project,
                </p>
                <p class="bannermenuitem">
                  Parts,
                  Leader
                </p>
              </td>

              <td align="left" valign="top">
                <p class="bannermenu">Resource parts</p>
                <p class="bannermenuitem">
                  <a href="resource_part_alpha{$FILE_EXT}" target="index">
                    Alphabetical,
                  </a>
                </p>
              </td>


              <td align="left" valign="top">
                <p class="bannermenu">Resource schemas</p>
                <p class="bannermenuitem">
                  <a href="resource_schema_alpha{$FILE_EXT}" target="index">
                    Alphabetical,
                  </a>
                  <a href="resources_numbers{$FILE_EXT}" target="index">
                    Parts,
                  </a>
                </p>
                <p class="bannermenuitem">
                  <a href="resource_mappings{$FILE_EXT}" target="_blank">
                  Mappings
		  </a>
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
