<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: imgfile.xsl,v 1.2 2002/01/21 14:22:10 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: To display an imgfile as an imagemap
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="common.xsl"/>

  <xsl:output 
    method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    indent="yes"
    />


<xsl:template match="imgfile.content">
  <xsl:variable name="module" select="@module"/>
  <HTML>
    <HEAD>
      <TITLE>
        <xsl:value-of select="concat(@module,' : ',@title)"/>
      </TITLE>
    </HEAD>

    <BODY>

      <xsl:variable name="href"  select="concat('./sys/1_scope',$FILE_EXT)"/>
      <h3>
        <a href="{$href}">application module: <xsl:value-of select="@module"/></a><br/>
      </h3>

      <xsl:apply-templates select="img"/>
      <center><h3><xsl:value-of select="@title"/></h3></center>

    </BODY>
  </HTML>
</xsl:template>


</xsl:stylesheet>

