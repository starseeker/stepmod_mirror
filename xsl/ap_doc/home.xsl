<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: home.xsl,v 1.5 2003/07/31 08:57:56 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: Display the main set of frames for an AP document.     
-->
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  version="1.0">

  <xsl:import href="application_protocol.xsl"/>

  <xsl:output method="html"
    doctype-system="http://www.w3.org/TR/html4/frameset.dtd" 
    doctype-public="-//W3C//DTD HTML 4.01 Frameset//EN" indent="yes"/>

  <xsl:template match="/">
    <xsl:apply-templates select="./application_protocol"/>
  </xsl:template>

  <xsl:template match="application_protocol">
    <xsl:variable name="application_protocol_xml_file" 
      select="concat('../../data/application_protocols/',@directory,'/application_protocol.xml')"/>
    <html>
      <head>
        <title>
          <xsl:apply-templates 
            select="document($application_protocol_xml_file)/application_protocol" mode="title"/>
        </title>
        <!-- commented out to avoid using JavaScript as required by HTML guidelines
      <script language="JavaScript"><![CDATA[
       function updateTitleFrame(title) {
         var divTT = top.contenttitle.document.all.DIVtitletext;
         if (divTT) {
          divTT.innerText='title';
         }
       }

       function updateModuleIndexTitleFrame(title) {
         var divTT = top.module_index_title.document.all.DIVmoduleindextitle;
         if (divTT) {
           divTT.innerHTML=title;
         }
       }
      ]]></script> -->
      </head>
    <frameset rows="60,*">
      <frame name="menu" 
        src="./sys/frame_aptitle{$FILE_EXT}"
        frameborder="0"
        marginwidth="2" marginheight="0" scrolling="no"/>
      <frameset cols="20%,80%">
        <frame name="index" 
          src="./sys/frame_toc_short{$FILE_EXT}" 
          frameborder="0"
          marginwidth="2" marginheight="0" scrolling="auto"/>

        <!-- commented out to avoid using JavaScript as required by HTML guidelines
        <frameset rows="48,*">
          <frame name="contenttitle"
            frameborder="0"
            src="./sys/frame_contenttitle{$FILE_EXT}"
            scrolling="no"/>
          <frame name="content"
            onload="updateTitleFrame(top.content.document.title)"  
            frameborder="0"
            src="./sys/cover{$FILE_EXT}"
            scrolling="auto"/>
        </frameset> -->

        <frame name="info"
            src="./sys/cover{$FILE_EXT}" 
            frameborder="0"
            scrolling="auto"/>
      </frameset>

      <noframes>
        <p>This page uses frames, but your browser doesn't support them.</p>
      </noframes>
    </frameset>

    </html>
  </xsl:template>

</xsl:stylesheet>