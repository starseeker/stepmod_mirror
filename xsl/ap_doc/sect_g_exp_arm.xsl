<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
	$Id: $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="../sect_e_exp_arm.xsl"/>
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
				<xsl:variable name="express_xml" select="concat($ap_module_dir,'/arm.xml')"/>
        			<xsl:call-template name="build_xref_list">
					<xsl:with-param name="express" select="document($express_xml)/express"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="/application_protocol">
				<xsl:variable name="ap_module_dir">
					<xsl:call-template name="application_protocol_directory">
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
	
	<xsl:variable name="relative_root" select="'../../../../'"/>
	
	<xsl:template match="module"/>
	
  	<xsl:template match="application_protocol">
		<xsl:call-template name="clause_header">
			<xsl:with-param name="heading" select="'Annex G - ARM EXPRESS'"/>
			<xsl:with-param name="aname" select="'annexg-arm-express'"/>
		</xsl:call-template>
		<xsl:variable name="stdnumber">
			<xsl:call-template name="get_module_iso_number">
				<xsl:with-param name="module" select="./@name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="module_name">
			<xsl:call-template name="module_display_name">
				<xsl:with-param name="module" select="./@name"/>
			</xsl:call-template>
		</xsl:variable>
		<code>
			(*<br/>
			<xsl:value-of select="concat('ISO TC184/SC4/WG12 N',@wg.number.arm, ' - ', $stdnumber,' ', $module_name, ' - EXPRESS ARM')"/>
			<br/>*)
		</code>
		<br/>
		<xsl:variable name="ap_module_dir">
			<xsl:call-template name="ap_module_directory">
				<xsl:with-param name="application_protocol" select="@name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="arm_xml" select="concat($ap_module_dir,'/arm.xml')"/>
		<xsl:apply-templates select="document($arm_xml)/express/schema" mode="code"/>
	</xsl:template>
	
</xsl:stylesheet>
