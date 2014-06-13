<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: frame_title.xsl,v 1.1 2012/10/24 06:29:18 mikeward Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep.
  Purpose: Display the title frame for a BOM.     
-->

<!-- BOM -->

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:import href="common.xsl"/>
    
 
  <xsl:output method="html" doctype-system="http://www.w3.org/TR/html4/loose.dtd" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" indent="yes"/> 
 
  <xsl:template match="/">
    <xsl:apply-templates select="./business_object_model_clause"/>
  </xsl:template>

  <xsl:template match="business_object_model_clause">
    <xsl:variable name="directory" select="./@directory"></xsl:variable>
    <xsl:variable name="business_object_model_xml_file" select="document(concat('../../data/business_object_models/',$directory,'/business_object_model.xml'))"/>
    <xsl:variable name="ap" select="$business_object_model_xml_file/business_object_model/@ap_name"/>
    <html>
      <head>
        <xsl:apply-templates select="$business_object_model_xml_file/business_object_model" mode="meta_data"/>
        <title>
          Title bar
        </title>
      </head>
      <body>
        <table align="left" width="100%">
          <tr align="left">
            <td>
              <small>
                <a href="../../../application_protocols/{$directory}/home{$FILE_EXT}" target="_blank">AP</a>
                &#160;|&#160;
                <a href="../../../modules/{$ap}/sys/cover{$FILE_EXT}" target="_blank">AP module</a>
              </small>
            </td>
           </tr>
          <xsl:apply-templates select="$business_object_model_xml_file/business_object_model" mode="title"/>
        </table>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="business_object_model" mode="title">
    <tr>
      <td align="left">
        <b>
          Business object model: <xsl:value-of select="./@title"/>
        </b>
      </td>
      <td align="right">
        <b>
          <xsl:call-template name="get_model_stdnumber">
            <xsl:with-param name="model" select="."/>
          </xsl:call-template>
        </b>
      </td>
    </tr>    
  </xsl:template>

</xsl:stylesheet>
