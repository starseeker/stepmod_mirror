<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_abstract.xsl,v 1.1 2003/03/10 20:56:28 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="resource.xsl"/>


  <xsl:output 
    method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    indent="yes"
    />

  <xsl:template match="/" >
    <xsl:apply-templates select="./resource_clause" />
  </xsl:template>
  
  <xsl:template match="resource_clause">
    <xsl:variable 
      name="resource_xml_file"
      select="concat('../../data/resource_docs/',@directory,'/resource.xml')"/>

    <HTML>
      <HEAD>
      </HEAD>
      <BODY>
        <xsl:apply-templates 
          select="document($resource_xml_file)/resource"
          mode="abstract"/>
      </BODY>
    </HTML>
  </xsl:template>

</xsl:stylesheet>