<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: mapping.xsl,v 1.3 2002/05/21 16:26:24 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: Display a mapping table that is stored in a stand alone file
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
  <xsl:import href="sect_5_mapping.xsl"/>

  <xsl:template match="/">
    <html>
      <body bgcolor="#FFFFFF">
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>


  <xsl:template match="ext_mapping_table">
    <xsl:apply-templates select="./module/mapping_table/ae" mode="table"/>
  </xsl:template>

</xsl:stylesheet>