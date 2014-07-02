<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: frame_aptitle.xsl,v 1.12 2012/10/29 14:42:09 mikeward Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: Display the main set of frames for an AP document.     
-->
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  version="1.0">

  <xsl:import href="common.xsl"/>

  <xsl:output method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" indent="yes"/> 
 
  <xsl:template match="/">
    <xsl:apply-templates select="./application_protocol"/>
  </xsl:template>

  <xsl:template match="application_protocol">
    <xsl:variable name="application_protocol_xml_file" 
      select="document(concat('../../data/application_protocols/',@directory,'/application_protocol.xml'))"/>
    
    <html>
      <head>
        <xsl:apply-templates select="$application_protocol_xml_file/application_protocol" mode="meta_data"/>
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
		      <xsl:if test="$application_protocol_xml_file/application_protocol/@business_object_model" >
			      <a 
	      href="../../../business_object_models/{$application_protocol_xml_file/application_protocol/@business_object_model}/sys/cover{$FILE_EXT}" 
				      target="info">Business Object Model</a>
                		&#160;|&#160;
		      </xsl:if>
                <a href="1_scope{$FILE_EXT}" target="info">AP scope</a>
                &#160;|&#160;
                <a
                  href="../../../modules/{$application_protocol_xml_file/application_protocol/@module_name}/sys/cover{$FILE_EXT}"
                  target="info">AP module</a>
                &#160;|&#160;
                <a href="help{$FILE_EXT}" target="info">Help</a>
                <br/>
                <a href="frame_toc_short{$FILE_EXT}" target="index">AP contents (short)</a>
                &#160;|&#160;
                <a href="frame_toc{$FILE_EXT}" target="index">AP contents (expanded)</a>
                &#160;|&#160;
		<a href="frame_index{$FILE_EXT}" target="index">AP navigation indices</a>
              </small>
            </td>
            <td align="right">
              <b>
                &#169;ISO&#160;
                <!-- <xsl:value-of
                     select="$application_protocol_xml_file/application_protocol/@publication.year"/> 
                     -->
              </b>
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
      <xsl:value-of select="$stdnumber"/>
      <br/>
      Application protocol: 
      <xsl:call-template name="protocol_display_name">
        <xsl:with-param name="application_protocol" select="@title"/>
      </xsl:call-template>
    </b>
  </xsl:template>

</xsl:stylesheet>
