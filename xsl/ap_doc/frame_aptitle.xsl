<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: frame_aptitle.xsl,v 1.4 2003/05/22 16:55:08 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: Display the main set of frames for an AP document.     
-->
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  version="1.0">

  <xsl:import href="../common.xsl"/>

  <xsl:output method="html"/>

  <xsl:template match="/">
    <xsl:apply-templates select="./application_protocol"/>
  </xsl:template>

  <xsl:template match="application_protocol">
    <xsl:variable name="application_protocol_xml_file" 
      select="document(concat('../../data/application_protocols/',@directory,'/application_protocol.xml'))"/>
    
    <html>
      <head>
        <title>
          Title bar
        </title>
      </head>
      <body>
        <table align="left" width="100%">
          <tr align="left">
            <td>
            <xsl:apply-templates
              select="$application_protocol_xml_file/application_protocol"
              mode="title"/>
          </td>
          <td align="right">
            <small>
              <a href="1_scope{$FILE_EXT}" target="content">AP scope</a>
              &#160;|&#160;
              <a href="../../../modules/{$application_protocol_xml_file/application_protocol/@module_name}/sys/cover{$FILE_EXT}" target="content">AP module</a>
              &#160;|&#160;
              <a href="frame_toc{$FILE_EXT}" target="toc">AP contents</a>
              &#160;|&#160;
              <a href="frame_index{$FILE_EXT}" target="toc">AP index</a>
            </small>
          </td>
        </tr>
        </table>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="application_protocol" mode="title">
    <xsl:variable name="stdnumber">
      <xsl:call-template name="get_protocol_stdnumber">
        <xsl:with-param name="application_protocol" select="."/>
      </xsl:call-template>
    </xsl:variable>
    <b>
      <xsl:value-of select="$stdnumber"/>&#160;
      <xsl:call-template name="protocol_display_name">
        <xsl:with-param name="application_protocol" select="@name"/>
      </xsl:call-template>
    </b>
  </xsl:template>

</xsl:stylesheet>