<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_1_scope.xsl,v 1.10 2003/05/22 14:57:14 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose:     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:import href="application_protocol.xsl"/>
  <xsl:import href="application_protocol_clause.xsl"/>
  <xsl:output method="html"/>
	
  <xsl:template match="application_protocol">

    <xsl:call-template name="annex_header">
      <xsl:with-param name="annex_no" select="'B'"/>
      <xsl:with-param name="heading" select="'AIM short names'"/>
      <xsl:with-param name="aname" select="'annexb'"/>
      <xsl:with-param name="informative" select="'normative'"/>
    </xsl:call-template>
    <p>
      XSL TO BE IMPLEMENTED
    </p>
  </xsl:template> 


</xsl:stylesheet>
