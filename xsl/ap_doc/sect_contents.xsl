<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_contents.xsl,v 1.9 2003/05/21 13:18:32 robbod Exp $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="../sect_contents.xsl"/>
	<xsl:import href="application_protocol.xsl"/>
	<xsl:import href="application_protocol_clause.xsl"/>
	<xsl:output method="html"/>
	
	<xsl:template match="application_protocol">
		<xsl:apply-templates select="../application_protocol" mode="contents"/>
	</xsl:template>
	
	<xsl:template match="module">
		<xsl:apply-templates select="../module" mode="contents_tables_figures"/>
		<xsl:apply-templates select="../module" mode="copyright"/>
	</xsl:template>
	
	<xsl:template match="application_protocol" mode="contents">
          <xsl:param name="target" select="'_self'"/>
		<xsl:variable name="arm_schema_name" select="concat(@name,'_arm')"/>
		<xsl:variable name="aim_schema_name" select="concat(@name,'_mim')"/>
		<xsl:variable name="application_protocol_dir">
			<xsl:call-template name="application_protocol_directory">
      				<xsl:with-param name="application_protocol" select="@name"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="ap_module_dir">
			<xsl:call-template name="ap_module_directory">
      				<xsl:with-param name="application_protocol" select="@name"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="arm_xml" select="concat($ap_module_dir,'/arm.xml')"/>
		<xsl:variable name="aim_xml" select="concat($ap_module_dir,'/mim.xml')"/>
		
		<h2>Contents</h2>
		<a href="./1_scope{$FILE_EXT}" target="{$target}">1 Scope</a><br/>
		<a href="./2_refs{$FILE_EXT}" target="{$target}">2 Normative references</a><br/>
		<xsl:choose>
			<xsl:when test="./definition/term">
                          <a href="./3_defs{$FILE_EXT}" target="{$target}">
                            3 Terms, definitions and abbreviations
                          </a>
                          <br/>
			</xsl:when>
			<xsl:otherwise>
                          <a href="./3_defs{$FILE_EXT}" target="{$target}">
                            3 Terms and abbreviations
                          </a>
                          <br/>
			</xsl:otherwise>
		</xsl:choose>
                <a href="./4_info_reqs{$FILE_EXT}" target="{$target}">4 Information requirements</a>
		<br/>
		&#160;&#160;<a href="./4_info_reqs{$FILE_EXT}#41" target="{$target}">4.1 Business concepts and terminology</a>
                <br/>
                &#160;&#160;<a href="./4_info_reqs{$FILE_EXT}#42" target="{$target}">4.2 Information requirements model</a>
                <br/>
                <a href="./5_main{$FILE_EXT}" target="{$target}">5 Application interpreted model</a>
		<br/>
                <a href="./sys/6_ccs{$FILE_EXT}" target="{$target}">6 Conformance requirements</a>
                <br/>
                <a href="./a_exp_aim{$FILE_EXT}" target="{$target}">A AIM EXPRESS expanded listing</a>
		<br/>
                <a href="./b_imp_meth{$FILE_EXT}" target="{$target}">B Implementation method specific requirements</a>
		<br/>
					<a href="./c_pics{$FILE_EXT}" target="{$target}">C Protocol Implementation Conformance Statement (PICS) form</a>
		<br/>
					<a href="./d_obj_reg{$FILE_EXT}" target="{$target}">D Information object registration</a>
		<br/>
					<a href="./e_aam{$FILE_EXT}" target="{$target}">E Application activity model</a>
		<br/>
					<a href="./f_arm_expg{$FILE_EXT}" target="{$target}">F Application reference model (EXPRESS-G)</a>
		<br/>
					<a href="./g_exp_aim{$FILE_EXT}" target="{$target}">G Computer interpretable listing</a>
		<br/>
		<xsl:if test="./usage_guide">
							<a href="./h_guide{$FILE_EXT}" target="{$target}">H Application protocol implementation and usage guide</a>
			<br/>
		</xsl:if>
		<xsl:if test="./tech_disc">
							<a href="./j_tech_disc{$FILE_EXT}" target="{$target}">J Technical discussions</a>
			<br/>
		</xsl:if>
					<a href="./k_ae_index{$FILE_EXT}#k_ae_index" target="{$target}">K Application object index</a>
		<br/>			
		<a href="./biblio{$FILE_EXT}#biblio" target="{$target}">Bibliography</a>
	</xsl:template>
	
	<xsl:template match="imgfile" mode="expressg_figure">
		<xsl:variable name="number">
			<xsl:number/>
		</xsl:variable>
		<xsl:variable name="fig_no">
			<xsl:choose>
				<xsl:when test="name(../..)='arm'">
					<xsl:choose>
						<xsl:when test="$number=1">
							<xsl:value-of select="concat('Figure F.',$number, ' - ARM Schema level EXPRESS-G diagram ',$number)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat('Figure F.',$number, ' - ARM Entity level EXPRESS-G diagram ',($number - 1))"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="name(../..)='mim'">
					<xsl:choose>
						<xsl:when test="$number=1">
							<xsl:value-of select="concat('Figure A.',$number, ' - AIM Schema level EXPRESS-G diagram ',$number)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat('Figure A.',$number, ' - AIM Entity level EXPRESS-G diagram ',($number - 1))"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="file">
			<xsl:call-template name="set_file_ext">
				<xsl:with-param name="filename" select="@file"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="href" select="concat('../',$file)"/>
					<a href="{$href}"><xsl:value-of select="$fig_no"/></a>
		<br/>
	</xsl:template>

	<xsl:template match="module" mode="contents_tables_figures">
          <xsl:param name="target" select="'_self'"/>
		<xsl:variable name="ap_module_dir">
			<xsl:call-template name="ap_module_directory">
				<xsl:with-param name="application_protocol" select="@name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="arm_xml" select="concat($ap_module_dir,'/arm.xml')"/>
		<xsl:variable name="arm_desc_xml" select="document($arm_xml)/express/@description.file"/>
		<xsl:variable name="aim_xml" select="concat($ap_module_dir,'/mim.xml')"/>
		<xsl:variable name="aim_desc_xml" select="document($aim_xml)/express/@description.file"/>
		<h3>Tables</h3>
		<xsl:apply-templates select="//table" mode="toc"/>
                <a href="./6_ccs{$FILE_EXT}#table_1" target="{$target}">
                  Table 1 &#8212; Conformance classes per UOF
                </a>
                <br/>
                <a href="./6_ccs{$FILE_EXT}#table_2" target="{$target}">
                  Table 2 &#8212; Conformance classes per ARM entity
                </a>
                <br/>
                <a href="./6_ccs{$FILE_EXT}#table_3">
                  Table 3 &#8212; Conformance classes per MIM entity
                </a>
                <br/>
                <xsl:choose>
			<xsl:when test="$arm_desc_xml">
				<xsl:apply-templates select="document($arm_desc_xml)//table" mode="toc"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="document($arm_xml)//table" mode="toc"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="$aim_desc_xml">
				<xsl:apply-templates select="document($aim_desc_xml)//table" mode="toc"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="document($aim_xml)//table" mode="toc"/>
			</xsl:otherwise>
		</xsl:choose>
		<a href="./g_exp{$FILE_EXT}#table_g1">
			Table G.1 &#8212; ARM to AIM EXPRESS short and long form listing.
		</a>
		<h3>Figures</h3>
		<xsl:apply-templates select="./purpose//figure" mode="toc"/>
		<xsl:apply-templates select="./inscope//figure" mode="toc"/>
		<xsl:apply-templates select="./outscope//figure" mode="toc"/>
		<xsl:choose>
			<xsl:when test="$arm_desc_xml">
				<xsl:apply-templates select="document($arm_desc_xml)//figure" mode="toc"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="document($arm_xml)//figure" mode="toc"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="$aim_desc_xml">
				<xsl:apply-templates select="document($aim_desc_xml)//figure" mode="toc"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="document($aim_xml)//figure" mode="toc"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="./arm/express-g/imgfile" mode="expressg_figure"/>
		<xsl:apply-templates select="./mim/express-g/imgfile" mode="expressg_figure"/>
		<xsl:apply-templates select="./usage_guide//figure" mode="toc"/>
	</xsl:template>
	
</xsl:stylesheet>