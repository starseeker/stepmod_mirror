<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_e_exp.xsl,v 1.2 2002/03/04 07:50:08 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="module.xsl"/>


  <xsl:output 
    method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    indent="yes"
    />

  <xsl:template match="/" >
    <xsl:apply-templates select="./module_clause" />
  </xsl:template>
  
  <xsl:template match="module_clause">
    <xsl:variable 
      name="module_xml_file"
      select="concat('../data/modules/',@directory,'/module.xml')"/>

    <HTML>
      <HEAD>
      </HEAD>
      <BODY>
        <xsl:apply-templates 
          select="document($module_xml_file)/module"
          mode="abstract"/>
      </BODY>
    </HTML>
  </xsl:template>

</xsl:stylesheet>