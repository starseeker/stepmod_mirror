<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
     $Id: application_protocol_toc.xsl,v 1.14 2002/12/13 09:48:41 goset1 Exp $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template match="module" mode="TOCmultiplePage"/>
	
	<xsl:template match="application_protocol" mode="TOCmultiplePage">
		<xsl:param name="selected"/>
		<xsl:param name="application_protocol_root" select="'..'"/>
						<xsl:if test="@name='nut_and_bolt'">
		<h1>NB THIS AP IS FOR DEMONSTRATION PURPOSES ONLY</h1>
						</xsl:if>		

		<xsl:apply-templates select="." mode="TOCbannertitle">
			<xsl:with-param name="module_root" select="$application_protocol_root"/>
		</xsl:apply-templates>
		<xsl:variable name="arm_schema_name" select="concat(@name,'_arm')"/>
		<xsl:variable name="aim_schema_name" select="concat(@name,'_mim')"/>
		<xsl:variable name="ap_name" select="./@name"/>
		<table border="1" cellspacing="1" width="100%">
			<tr>
				<td valign="TOP">
					<p class="toc">
						<a href="{$application_protocol_root}/sys/cover{$FILE_EXT}">Cover page</a>
						<br/>
						<a href="{$application_protocol_root}/sys/foreword{$FILE_EXT}">Foreword</a>
						<br/>
						<a href="{$application_protocol_root}/sys/contents{$FILE_EXT}">Table of contents</a>
						<br/>
						<a href="{$application_protocol_root}/sys/introduction{$FILE_EXT}">Introduction</a>
						<br/>
						<a href="{$application_protocol_root}/sys/1_scope{$FILE_EXT}">1 Scope</a>
						<br/>
						<a href="{$application_protocol_root}/sys/2_refs{$FILE_EXT}">2 Normative references</a>
						<br/>
						<xsl:choose>
							<xsl:when test="./definition/term">
								<a href="{$application_protocol_root}/sys/3_defs{$FILE_EXT}">
									3 Terms, definitions and abbreviations
								</a>
							</xsl:when>
							<xsl:otherwise>
								<a href="{$application_protocol_root}/sys/3_defs{$FILE_EXT}">
									3 Terms and abbreviations</a>
							</xsl:otherwise>
						</xsl:choose>
					</p>
				</td>
				<td valign="TOP">
					<p class="toc">
						<a href="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}">4 Information requirements</a>
						<br/>
						<a href="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#41">4.1 Fundamentals concepts and assumptions</a>
						<br/>
						<a href="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#42">4.2 Information requirements model</a>
						<br/>
						
<!--
						<a href="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#uof">
							<xsl:value-of select="concat('&#160;&#160;',' 4.1 Units of functionality')"/>
						</a>
						<br/>
						<xsl:variable name="interface_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'interface'"/>
								<xsl:with-param name="schema_name" select="$arm_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$interface_clause != 0">
							<a href="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#interfaces">
								<xsl:value-of select="concat('&#160; &#160;', $interface_clause, ' Required AM ARMs')"/>
							</a>
							<br/>
						</xsl:if>
						<xsl:variable name="constant_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'constant'"/>
								<xsl:with-param name="schema_name" select="$arm_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$constant_clause != 0">
							<a href="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#constants">
								<xsl:value-of select="concat('&#160; &#160;', $constant_clause, ' ARM constant definitions')"/>
							</a>
							<br/>
						</xsl:if>
						<xsl:variable name="imported_constant_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'imported_constant'"/>
								<xsl:with-param name="schema_name" select="$arm_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$imported_constant_clause != 0">
							<a href="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#imported_constant">
								<xsl:value-of select="concat('&#160; &#160;', $imported_constant_clause, ' ARM imported constant modifications')"/>
							</a>
							<br/>
						</xsl:if>
						<xsl:variable name="type_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'type'"/>
								<xsl:with-param name="schema_name" select="$arm_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$type_clause != 0">
							<a href="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#types">
								<xsl:value-of select="concat('&#160; &#160;', $type_clause, ' ARM type definitions')"/>
							</a>
							<br/>
						</xsl:if>
						<xsl:variable name="imported_type_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'imported_type'"/>
								<xsl:with-param name="schema_name" select="$arm_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$imported_type_clause != 0">
							<a href="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#imported_type">
								<xsl:value-of select="concat('&#160; &#160;', $imported_type_clause, ' ARM imported type modifications')"/>
							</a>
							<br/>
						</xsl:if>
						<xsl:variable name="entity_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'entity'"/>
								<xsl:with-param name="schema_name" select="$arm_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$entity_clause != 0">
							<a href="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#entities">
								<xsl:value-of select="concat('&#160; &#160;', $entity_clause, ' ARM entity definitions')"/>
							</a>
							<br/>
						</xsl:if>
						<xsl:variable name="imported_entity_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'imported_entity'"/>
								<xsl:with-param name="schema_name" select="$arm_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$imported_entity_clause != 0">
							<a href="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#imported_entity">
								<xsl:value-of select="concat('&#160; &#160;', $imported_entity_clause, ' ARM imported entity modifications')"/>
							</a>
							<br/>
						</xsl:if>
						<xsl:variable name="function_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'function'"/>
								<xsl:with-param name="schema_name" select="$arm_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$function_clause !=0">
							<a href="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#functions">
								<xsl:value-of select="concat('&#160; &#160;', $function_clause, ' ARM function definitions')"/>
							</a>
							<br/>
						</xsl:if>
						<xsl:variable name="imported_function_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'imported_function'"/>
								<xsl:with-param name="schema_name" select="$arm_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$imported_function_clause != 0">
							<a href="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#imported_function">
								<xsl:value-of select="concat('&#160; &#160;', $imported_function_clause, ' ARM imported function modifications')"/>
							</a>
							<br/>
						</xsl:if>
						<xsl:variable name="rule_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'rule'"/>
								<xsl:with-param name="schema_name" select="$arm_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$rule_clause !=0">
							<a href="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#rules">
								<xsl:value-of select="concat('&#160; &#160;', $rule_clause, ' ARM rule definitions')"/>
							</a>
							<br/>
						</xsl:if>
						<xsl:variable name="imported_rule_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'imported_rule'"/>
								<xsl:with-param name="schema_name" select="$arm_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$imported_rule_clause != 0">
							<a href="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#imported_rule">
								<xsl:value-of select="concat('&#160; &#160;', $imported_rule_clause, ' ARM imported rule modifications')"/>
							</a>
							<br/>
						</xsl:if>
						<xsl:variable name="procedure_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'procedure'"/>
								<xsl:with-param name="schema_name" select="$arm_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$procedure_clause != 0">
							<a href="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#procedures">
								<xsl:value-of select="concat('&#160; &#160;', $procedure_clause, ' ARM procedure definitions')"/>
							</a>
							<br/>
						</xsl:if>
						<xsl:variable name="imported_procedure_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'imported_procedure'"/>
								<xsl:with-param name="schema_name" select="$arm_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$imported_procedure_clause != 0">
							<a href="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#imported_procedure">
									<xsl:value-of select="concat('&#160; &#160;', $imported_procedure_clause, ' ARM imported procedure modifications')"/>
							</a>
							<br/>
						</xsl:if>

-->
						
					<a href="{$application_protocol_root}/sys/5_main{$FILE_EXT}">5 Application interpreted model</a>
					<br/>
					<small>
						<a href="{$application_protocol_root}/sys/5_mapping{$FILE_EXT}">&#160;&#160;5.1 Mapping specification</a>
						<br/>
						<a href="{$application_protocol_root}/sys/5_aim{$FILE_EXT}#aim_express">&#160;&#160;5.2 AIM EXPRESS short listing</a>
						<br/>
						<xsl:variable name="constant_aim_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'constant'"/>
								<xsl:with-param name="schema_name" select="$aim_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$constant_aim_clause != 0">
							<a href="{$application_protocol_root}/sys/5_aim{$FILE_EXT}#constants">
								<xsl:value-of select="concat('&#160; &#160; &#160;', $constant_aim_clause, ' AIM constant definitions')"/>
							</a>
							<br/>
						</xsl:if>
						<xsl:variable name="imported_constant_aim_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'imported_constant'"/>
								<xsl:with-param name="schema_name" select="$aim_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$imported_constant_aim_clause != 0">
							<a href="{$application_protocol_root}/sys/5_aim{$FILE_EXT}#imported_constant">
								<xsl:value-of select="concat('&#160; &#160; &#160;', $imported_constant_aim_clause, ' AIM imported constant modifications')"/>
							</a>
							<br/>
						</xsl:if>
						<xsl:variable name="type_aim_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'type'"/>
								<xsl:with-param name="schema_name" select="$aim_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$type_aim_clause != 0">
							<a href="{$application_protocol_root}/sys/5_aim{$FILE_EXT}#types">
								<xsl:value-of select="concat('&#160; &#160; &#160;', $type_aim_clause, ' AIM type definitions')"/>
							</a>
							<br/>
						</xsl:if>
						<xsl:variable name="imported_aim_type_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'imported_type'"/>
								<xsl:with-param name="schema_name" select="$aim_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
							<xsl:if test="$imported_aim_type_clause != 0">
								<a href="{$application_protocol_root}/sys/5_aim{$FILE_EXT}#imported_type">
									<xsl:value-of select="concat('&#160; &#160; &#160;', $imported_aim_type_clause, ' AIM imported type modifications')"/>
								</a>
								<br/>
							</xsl:if>
							<xsl:variable name="entity_aim_clause">
								<xsl:call-template name="express_clause_present">
									<xsl:with-param name="clause" select="'entity'"/>
									<xsl:with-param name="schema_name" select="$aim_schema_name"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:if test="$entity_aim_clause != 0">
								<a href="{$application_protocol_root}/sys/5_aim{$FILE_EXT}#entities">
									<xsl:value-of select="concat('&#160; &#160; &#160;', $entity_aim_clause, ' AIM entity definitions')"/>
								</a>
								<br/>
							</xsl:if>
							<xsl:variable name="imported_aim_entity_clause">
								<xsl:call-template name="express_clause_present">
									<xsl:with-param name="clause" select="'imported_entity'"/>
									<xsl:with-param name="schema_name" select="$aim_schema_name"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:if test="$imported_aim_entity_clause != 0">
								<a href="{$application_protocol_root}/sys/5_aim{$FILE_EXT}#imported_entity">
									<xsl:value-of select="concat('&#160; &#160; &#160;', $imported_aim_entity_clause, ' AIM imported entity modifications')"/>
								</a>
								<br/>
							</xsl:if>
							<xsl:variable name="function_aim_clause">
								<xsl:call-template name="express_clause_present">
									<xsl:with-param name="clause" select="'function'"/>
									<xsl:with-param name="schema_name" select="$aim_schema_name"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:if test="$function_aim_clause != 0">
								<a href="{$application_protocol_root}/sys/5_aim{$FILE_EXT}#functions">
									<xsl:value-of select="concat('&#160; &#160; &#160;', $function_aim_clause, ' AIM function definitions')"/>
								</a>
								<br/>
							</xsl:if>
							<xsl:variable name="imported_aim_function_clause">
								<xsl:call-template name="express_clause_present">
									<xsl:with-param name="clause" select="'imported_function'"/>
									<xsl:with-param name="schema_name" select="$aim_schema_name"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:if test="$imported_aim_function_clause != 0">
								<a href="{$application_protocol_root}/sys/5_aim{$FILE_EXT}#imported_function">
									<xsl:value-of select="concat('&#160; &#160; &#160;', $imported_aim_function_clause, ' AIM imported function modifications')"/>
								</a>
								<br/>
							</xsl:if>
							<xsl:variable name="rule_aim_clause">
								<xsl:call-template name="express_clause_present">
									<xsl:with-param name="clause" select="'rule'"/>
									<xsl:with-param name="schema_name" select="$aim_schema_name"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:if test="$rule_aim_clause != 0">
								<a href="{$application_protocol_root}/sys/5_aim{$FILE_EXT}#rules">
									<xsl:value-of select="concat('&#160; &#160; &#160;', $rule_aim_clause, ' AIM rule definitions')"/>
								</a>
								<br/>
							</xsl:if>
							<xsl:variable name="imported_aim_rule_clause">
								<xsl:call-template name="express_clause_present">
									<xsl:with-param name="clause" select="'imported_rule'"/>
									<xsl:with-param name="schema_name" select="$aim_schema_name"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:if test="$imported_aim_rule_clause != 0">
								<a href="{$application_protocol_root}/sys/5_aim{$FILE_EXT}#imported_rule">
							<xsl:value-of select="concat('&#160; &#160; &#160;', $imported_aim_rule_clause, ' AIM imported rule modifications')"/>
								</a>
								<br/>
							</xsl:if>
							<xsl:variable name="procedure_aim_clause">
								<xsl:call-template name="express_clause_present">
									<xsl:with-param name="clause" select="'procedure'"/>
									<xsl:with-param name="schema_name" select="$aim_schema_name"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:if test="$procedure_aim_clause != 0">
								<a href="{$application_protocol_root}/sys/5_aim{$FILE_EXT}#procedures">
									<xsl:value-of select="concat('&#160; &#160; &#160;', $procedure_aim_clause, ' AIM procedure definitions')"/>
								</a>
								<br/>
							</xsl:if>
							<xsl:variable name="imported_aim_procedure_clause">
								<xsl:call-template name="express_clause_present">
									<xsl:with-param name="clause" select="'imported_procedure'"/>
									<xsl:with-param name="schema_name" select="$aim_schema_name"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:if test="$imported_aim_procedure_clause != 0">
								<a href="{$application_protocol_root}/sys/5_aim{$FILE_EXT}#imported_procedure">
									<xsl:value-of select="concat('&#160; &#160; &#160;', $imported_aim_procedure_clause, ' AIM imported procedure modifications')"/>
								</a>
								<br/>
							</xsl:if>
						</small>
						<a href="{$application_protocol_root}/sys/6_ccs{$FILE_EXT}">6 Conformance requirements</a>
						<br/>
					</p>
				</td>
				<td valign="TOP">
					<p class="toc">
						<a href="{$application_protocol_root}/sys/a_exp_aim_lf{$FILE_EXT}">
							A AIM EXPRESS expanded listing
							
						</a>
						<xsl:call-template name="ap_expressg_icon">
							<xsl:with-param name="schema" select="$aim_schema_name"/>
							<xsl:with-param name="module_root" select="$application_protocol_root"/>
							<xsl:with-param name="mod" select="$ap_name"/>
						</xsl:call-template>
						<br/>
						<a href="{$application_protocol_root}/sys/b_imp_meth{$FILE_EXT}">
							B Implementation method specific requirements
						</a>
						<br/>
						<a href="{$application_protocol_root}/sys/c_pics{$FILE_EXT}">
							C Protocol Implementation Conformance Statement (PICS) form
						</a>
						<br/>
						<a href="{$application_protocol_root}/sys/d_obj_reg{$FILE_EXT}">
							D Information object registration
						</a>
						<br/>
						<a href="{$application_protocol_root}/sys/e_aam{$FILE_EXT}">
							E Application activity model
						</a>
						<xsl:call-template name="idef0_icon">
							<xsl:with-param name="schema" select="concat(./@name,'_arm')"/>
							<xsl:with-param name="application_protocol_root" select="$application_protocol_root"/>
						</xsl:call-template>
						<br/>
						<a href="{$application_protocol_root}/sys/f_arm_expg{$FILE_EXT}">
							F Application reference model
						</a>
						<xsl:call-template name="ap_expressg_icon">
							<xsl:with-param name="schema" select="$arm_schema_name"/>
							<xsl:with-param name="module_root" select="$application_protocol_root"/>
							<xsl:with-param name="mod" select="$ap_name"/>
						</xsl:call-template>
						<br/>
						<a href="{$application_protocol_root}/sys/g_exp{$FILE_EXT}">
							G Computer interpretable listing
						</a>
						<br/>
						<xsl:if test="./usage_guide">
							<a href="{$application_protocol_root}/sys/h_guide{$FILE_EXT}">
								H Application protocol implementation and usage guide
							</a>
							<br/>
						</xsl:if>
						<xsl:if test="./tech_disc">
							<a href="{$application_protocol_root}/sys/j_tech_disc{$FILE_EXT}">
								J Technical discussions
							</a>
							<br/>
						</xsl:if>
						<a href="{$application_protocol_root}/sys/k_ae_index{$FILE_EXT}">
							K Application object index
						</a>
						<br/>
						<a href="{$application_protocol_root}/sys/biblio{$FILE_EXT}#biblio">
							Bibliography
						</a>
					</p>
				</td>
			</tr>
		</table>
	</xsl:template>

<!--
     Output the Table of contents banner for a module where all clauses are 
     displayed on a single page
-->
<xsl:template match="application_protocol" mode="TOCsinglePage">
  <xsl:param name="application_protocol_root" select="'..'"/>
  <xsl:apply-templates select="." mode="TOCbannertitle">
    <xsl:with-param name="module_root" select="$application_protocol_root"/>
  </xsl:apply-templates>
  <table border="1" cellspacing="1" width="100%">
    <tr>
      <td valign="TOP">
        <a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#cover_page">Cover page</a><br/>
        <a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#foreword">Foreword</a><br/>
        <a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#intro">Introduction</a><br/>
        <a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#scope">1 Scope</a><br/>
        <a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#nref">2 Normative references</a><br/>
        <a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#defns">3 Definitions and abbreviations</a>
      </td>
      <td valign="TOP">
        <a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#arm">4 Information requirements</a><br/>
        <a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#aim">5 Application interpreted model</a><br/>
	 <a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#ccs">6 Conformance classes</a><br/>
        <a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#annexa">A AIM EXPRESS expanded listing</a><br/>
        <a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#annexb">B Implementation method specific requirements</a><br/>
        <a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#annexc">C Protocol Implementation Conformance Statement (PICS) form.</a><br/>
        <a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#annexd">D Information object registration</a>
      </td>
      <td valign="TOP">
        <a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#annexe">E Application activity model</a><br/>
		<a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#annexf">F Application reference model</a><br/>
	<a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#annexg">G Computer interpretable listing</a><br/>
	<xsl:if test="./usage_guide">
		<!-- use #annexh to link direct -->
		<a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#annexh">
			H Application protocol implementation and usage guide
		</a>
		<br/>
	</xsl:if>
	<xsl:if test="./tech_disc">
		<!-- use #annexj to link direct -->
		<a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#annexj">
			J Technical discussions
		</a>
		<br/>
	</xsl:if>
	<a href="{$application_protocol_root}/sys/k_ae_index{$FILE_EXT}">
		K Application object index
	</a>
	<br/>
	<!-- use #biblio to link direct -->
	<a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}">Bibliography</a>
      </td>
    </tr>
  </table>
</xsl:template>

<xsl:template match="application_protocol" mode="test_application_protocol_name">
  <xsl:variable name="test">
    <xsl:call-template name="check_all_lower_case">
      <xsl:with-param name="str" select="@name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$test = -1">
    <xsl:call-template name="error_message">
      <xsl:with-param 
        name="message" 
        select="concat('Error m1: the application protocol name ',@name,' is incorrectly
                named in application_protocol.xml &lt;application protocol name=&quot;',@name,'&quot;. Should be all lower case')"/>
    </xsl:call-template>    
  </xsl:if>
</xsl:template>

	<xsl:template match="imgfile" mode="page_number">
		<xsl:param name="application_protocol_root" select="'..'"/>
		<xsl:variable name="href">
			<xsl:call-template name="set_file_ext">
				<xsl:with-param name="filename" select="concat($application_protocol_root,'/',@file)"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="position()=1">
			&#x20;(
		</xsl:if>
		<small>
			<a href="{$href}">
				<xsl:value-of select="position()"/>
			</a>
		</small>
		<xsl:choose>
			<xsl:when test="position()=last()">
				)
			</xsl:when>
			<xsl:otherwise>
				,&#x20;
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
