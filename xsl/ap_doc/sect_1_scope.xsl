<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: common.xsl,v 1.92 2003/05/06 10:26:57 robbod Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose:     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:import href="application_protocol.xsl"/>
	<xsl:import href="application_protocol_clause.xsl"/>
	<xsl:output method="html"/>
	
	<xsl:template match="application_protocol">
		<h2>
    			Industrial automation systems and integration &#8212; <br/>
    			Product data representation and exchange &#8212;  <br/>
    			Part <xsl:value-of select="@part"/>:<br/>
    			Application protocol:
			<xsl:call-template name="protocol_display_name">
      				<xsl:with-param name="application_protocol" select="@title"/>
    			</xsl:call-template>
  		</h2>

			<xsl:call-template name="clause_header">
				<xsl:with-param name="heading" select="'1 Scope'"/>
				<xsl:with-param name="aname" select="'scope'"/>
			</xsl:call-template>
			<xsl:variable name="application_protocol_name">
				<xsl:call-template name="module_display_name">
					<xsl:with-param name="module" select="@title"/>
				</xsl:call-template>
			</xsl:variable>
			<p>
This part of ISO 10303 specifies an application protocol for the exchange of information between the applications that support 
				<xsl:value-of select="$application_protocol_name"/>.
			</p>	
</xsl:template>

	<xsl:template match="module">
		<xsl:apply-templates select="./inscope"/>
		<xsl:apply-templates select="./outscope"/>
	</xsl:template>

</xsl:stylesheet>
