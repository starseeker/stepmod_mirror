<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
	$Id: sect_a_exp_aim_lf.xsl,v 1.5 2002/11/11 19:20:53 mikeward Exp $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<!-- 	<xsl:import href="../sect_e_exp_mim_lf.xsl"/> -->
	<xsl:import href="application_protocol.xsl"/>
	<xsl:import href="../express_code.xsl"/>
	<xsl:import href="application_protocol_clause.xsl"/>
	
	<xsl:output method="html"/>
	
<!-- 	<xsl:variable name="global_xref_list">
		<xsl:choose>
			<xsl:when test="/application_protocol_clause">
				<xsl:variable name="ap_module_dir">
					<xsl:call-template name="ap_module_directory">
						<xsl:with-param name="application_protocol" select="/application_protocol_clause/@directory"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="express_xml" select="concat($ap_module_dir,'/mim_lf.xml')"/>
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
				<xsl:variable name="express_xml" select="concat($ap_module_dir,'/mim_lf.xml')"/>
				<xsl:call-template name="build_xref_list">
					<xsl:with-param name="express" select="document($express_xml)/express"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:variable> -->
	
<!-- 	<xsl:template match="module"/> -->
	
	<xsl:template match="application_protocol">
				<xsl:call-template name="annex_header">
    			<xsl:with-param name="annex_no" select="'A'"/>
    			<xsl:with-param name="heading" select="'AIM EXPRESS expanded listing'"/>
    			<xsl:with-param name="aname" select="'annexa-aim_lf'"/>
			<xsl:with-param name="informative" select="'normative'"/>
		</xsl:call-template>
		
<!-- 		<xsl:variable name="ap_module_dir">
			<xsl:call-template name="ap_module_directory">
				<xsl:with-param name="application_protocol" select="@module_name"/>
			</xsl:call-template>
		</xsl:variable>-->
		<xsl:variable name="ap_dir">
			<xsl:call-template name="ap_module_directory">
				<xsl:with-param name="application_protocol" select="@name"/>
			</xsl:call-template>
		</xsl:variable> 
		
<!-- 		<xsl:variable name="aim_lf" select="concat($ap_module_dir,'/aim_lf',$FILE_EXT)"/> -->
 		<xsl:variable name="aim_lf" select="concat('../../data/application_protocols/', @name,'/aim_lf.xml')"/> 

			<xsl:apply-templates select="document(string($aim_lf))/express/schema" mode="code"/>

 	</xsl:template>
	<xsl:template match="module"/>
</xsl:stylesheet>