<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_1_scope.xsl,v 1.5 2003/03/13 19:17:01 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep.
  Purpose: Provides the main entry page to the module.
     Just a forward to the cover page.
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <!--
       Template to determine whether the output is XML or HTML
       Sets variable global FILE_EXT
       -->
  <xsl:import href="file_ext.xsl"/>

  <xsl:output method="html"/>


  <xsl:template match="module_clause">
    <xsl:variable name="new_page" select="concat('./sys/cover',$FILE_EXT)"/>
    <html>
      <head>
          <xsl:element name="meta">
            <xsl:attribute name="http-equiv">Refresh</xsl:attribute>
            <xsl:attribute name="content">
              <xsl:value-of select="concat('5; URL=',$new_page)"/>
            </xsl:attribute>
          </xsl:element>
      </head>
      <body>
        <xsl:value-of select="concat('You will be redirected to ',$new_page,' in 5 seconds')"/><br/>
        If not select 
        <a href="{$new_page}">
          <xsl:value-of select="$new_page"/>
        </a>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>