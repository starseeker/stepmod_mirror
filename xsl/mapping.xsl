<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: mapping.xsl,v 1.9 2003/07/30 11:42:04 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: Display a mapping table that is stored in a stand alone file
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
  <xsl:import href="sect_5_mapping.xsl"/>

  <xsl:param name="check_mapping" select="'no'"/>

  <xsl:template match="/">
    <html>
    <xsl:element name="body">
      <xsl:if test="$output_background='YES'">
        <xsl:attribute name="background">
          <xsl:value-of select="concat('../../../../images/',$background_image)"/>
        </xsl:attribute>
          <!-- can only use this for Internet explorer, so not valid HTML
        <xsl:attribute name="bgproperties" >
          <xsl:value-of select="'fixed'" />
          </xsl:attribute> -->
        </xsl:if>
        <xsl:apply-templates select="//module/mapping_table/ae" mode="specification"/>
      </xsl:element>
    </html>
  </xsl:template>


  <xsl:template match="ext_mapping_table">
    <xsl:apply-templates select="./ae" mode="specification"/>
  </xsl:template>

</xsl:stylesheet>