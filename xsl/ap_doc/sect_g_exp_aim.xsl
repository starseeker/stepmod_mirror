<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
     $Id: $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="application_protocol.xsl"/>
	<xsl:import href="express_code.xsl"/>
	<xsl:import href="application_protocol_clause.xsl"/>
	<xsl:output method="html"/>
	<xsl:variable name="global_xref_list">
		<xsl:choose>
			<xsl:when test="/application_protocol_clause">
				<xsl:variable name="ap_module_dir">
					<xsl:call-template name="ap_module_directory">
						<xsl:with-param name="application_protocol" select="/application_protocol_clause/@directory"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="express_xml" select="concat($ap_module_dir,'/mim.xml')"/>
				<xsl:call-template name="build_xref_list">
					<xsl:with-param name="express" select="document($express_xml)/express"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="/application_protocol">
				<xsl:variable name="ap_module_dir">
					<xsl:call-template name="ap_module_directory">
						<xsl:with-param name="application_protocol" select="/application_protocol/@name"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="express_xml" select="concat($ap_module_dir,'/arm.xml')"/>
				<xsl:call-template name="build_xref_list">
					<xsl:with-param name="express" select="document($express_xml)/express"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:variable>
  	<xsl:template match="application_protocol">
		<xsl:call-template name="clause_header">
			<xsl:with-param name="heading" select="'Annex G - Computer interpretable listing'"/>
			<xsl:with-param name="aname" select="'annexg-mim-express'"/>
		</xsl:call-template>
		<xsl:variable name="ap_module_dir">
			<xsl:call-template name="ap_module_directory">
				<xsl:with-param name="application_protocol" select="/application_protocol/@name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="aim_xml" select="concat($ap_module_dir,'/mim.xml')"/>
		<xsl:apply-templates select="document($aim_xml)/express/schema" mode="code"/>
	</xsl:template>
</xsl:stylesheet>