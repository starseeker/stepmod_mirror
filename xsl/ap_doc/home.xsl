<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: home.xsl,v 1.3 2003/07/28 17:12:49 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: Display the main set of frames for an AP document.     
-->
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  version="1.0">

  <xsl:import href="application_protocol.xsl"/>

  <xsl:output method="html"/>

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
    <frameset framespacing="1" border="0" rows="60,*" frameborder="0">
      <frame name="aptitle" 
        src="./sys/frame_aptitle{$FILE_EXT}"
        marginwidth="2" marginheight="0" scrolling="no"/>
      <frameset cols="20%,80%">
        <frame name="toc" 
          src="./sys/frame_toc_short{$FILE_EXT}"
          marginwidth="2" marginheight="0" scrolling="auto"/>

        <!-- commented out to avoid using JavaScript as required by HTML guidelines
        <frameset framespacing="1" border="0" rows="48,*" frameborder="0">
          <frame name="contenttitle"
            src="./sys/frame_contenttitle{$FILE_EXT}"
            scrolling="no"/>
          <frame name="content"
            onload="updateTitleFrame(top.content.document.title)"  
            src="./sys/cover{$FILE_EXT}"
            scrolling="auto"/>
        </frameset> -->
        <frame name="content"
            src="./sys/cover{$FILE_EXT}"
            scrolling="auto"/>
      </frameset>
    </frameset>

    <noframes>
      <body>
        <p>This page uses frames, but your browser doesn't support them.</p>
      </body>
    </noframes>
    </html>
  </xsl:template>

</xsl:stylesheet>