<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
     $Id: sect_1_scope.xsl,v 1.5 2002/10/08 10:19:07 mikeward Exp $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="../sect_1_scope.xsl"/>
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
		</xsl:template>
		
	<xsl:template match="module">
		<xsl:apply-templates select="./inscope"/>
		<xsl:apply-templates select="./outscope"/>
	</xsl:template>
	
</xsl:stylesheet>
