<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_2_refs.xsl,v 1.5 2003/05/27 07:34:15 robbod Exp $
  Author:  Mike Ward, Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: Display the main set of frames for an AP document.     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!--  <xsl:import href="../sect_2_refs.xsl"/> -->
  <xsl:import href="application_protocol.xsl"/>
  <xsl:import href="application_protocol_clause.xsl"/>
  <xsl:output method="html"/>
	
  
  <xsl:template match="application_protocol">
    <xsl:call-template name="output_normrefs">
      <xsl:with-param name="application_protocol_number" select="./@part"/>
      <xsl:with-param name="current_application_protocol" select="."/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="output_normrefs">
    <xsl:param name="application_protocol_number"/>
    <xsl:param name="current_application_protocol"/>
    <h2>
      2 Normative references
    </h2>
    <p>
      The following normative documents contain provisions which, through
      reference in this text, constitute provisions of this International
      Standard. For dated references, subsequent amendments to, or revisions of,
      any of these publications do not apply. However, parties to agreements
      based on this International Standard are encouraged to investigate the
      possibility of applying the most recent editions of the normative documents
      indicated below. For undated references, the latest edition of the
      normative document referred to applies. Members of ISO and IEC maintain
      registers of currently valid International Standards.
    </p>
    <!--
    <xsl:call-template name="output_default_normrefs">
      <xsl:with-param name="module_number" select="$application_protocol_number"/>
      <xsl:with-param name="current_module" select="$current_application_protocol"/>
    </xsl:call-template>
    -->
  </xsl:template>



	
</xsl:stylesheet>
