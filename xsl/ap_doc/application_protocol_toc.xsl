<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!-- last edited mwd 2002-08-20 -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	
	<xsl:template match="application_protocol" mode="TOCmultiplePage">
		<!-- the entry that has been selected -->
		<xsl:param name="selected"/>
		<xsl:param name="application_protocol_root" select="'..'"/>
		<xsl:apply-templates select="." mode="TOCbannertitle">
			<xsl:with-param name="application_protocol_root" select="$application_protocol_root"/>
		</xsl:apply-templates>

		<xsl:variable name="arm_schema_name" select="concat(@name,'_arm')"/>
		<xsl:variable name="aim_schema_name" select="concat(@name,'_mim')"/>
		<TABLE border="1" cellspacing="1" width="100%">
			<TR>
				<TD valign="TOP">
					<p class="toc">
						<A HREF="{$application_protocol_root}/sys/cover{$FILE_EXT}">Cover page</A>
						<BR/>
						<!-- use #foreword to link direct -->
						<A HREF="{$application_protocol_root}/sys/foreword{$FILE_EXT}">Foreword</A>
						<BR/>
						<A HREF="{$application_protocol_root}/sys/contents{$FILE_EXT}">Table of contents</A>
						<BR/>
						<!-- use #intro to link direct -->
						<A HREF="{$application_protocol_root}/sys/introduction{$FILE_EXT}">Introduction</A>
						<BR/>
						<!-- use #scope to link direct -->
						<A HREF="{$application_protocol_root}/sys/1_scope{$FILE_EXT}">1 Scope</A>
						<BR/>
						<!-- use #nref to link direct -->
						<A HREF="{$application_protocol_root}/sys/2_refs{$FILE_EXT}">2 Normative references</A>
						<BR/>
						<!-- Assumption that every ap uses a set of terms and abbreviations from the normref.inc so only check for local definitions aka terms -->
						<xsl:choose>
							<xsl:when test="./definition/term">
								<!-- use #defns to link direct -->
								<A HREF="{$application_protocol_root}/sys/3_defs{$FILE_EXT}">
									3 Terms, definitions and abbreviations
								</A>
							</xsl:when>
							<xsl:otherwise>
								<!-- use #defns to link direct -->
								<A HREF="{$application_protocol_root}/sys/3_defs{$FILE_EXT}">
									3 Terms and abbreviations
								</A>
							</xsl:otherwise>
						</xsl:choose>
					</p>
				</TD>
				<TD valign="TOP">
					<p class="toc">
						<!-- Output Section 4. Only set up the index to express clauses that exist. use #ARM to link direct -->
						<A HREF="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}">4 Information requirements</A>
						<BR/>
						<small>
						<A HREF="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#uof">
							<xsl:value-of select="concat('&#160;&#160;',' 4.1 Units of functionality')"/>
						</A>
						<BR/>
						<!-- only output if there are interfaces defined and therefore a section -->
						<xsl:variable name="interface_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'interface'"/>
								<xsl:with-param name="schema_name" select="$arm_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$interface_clause != 0">
							<A HREF="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#interfaces">
								<xsl:value-of select="concat('&#160; &#160;', $interface_clause, ' Required AM ARMs')"/>
							</A>
							<BR/>
						</xsl:if>
						<!-- only output if there are constants defined and therefore a section -->
						<xsl:variable name="constant_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'constant'"/>
								<xsl:with-param name="schema_name" select="$arm_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$constant_clause != 0">
							<A HREF="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#constants">
								<xsl:value-of select="concat('&#160; &#160;', $constant_clause, ' ARM constant definitions')"/>
							</A>
							<BR/>
						</xsl:if>
						<!-- only output if there are imported constants defined and therefore a section -->
						<xsl:variable name="imported_constant_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'imported_constant'"/>
								<xsl:with-param name="schema_name" select="$arm_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$imported_constant_clause != 0">
							<A HREF="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#imported_constant">
								<xsl:value-of select="concat('&#160; &#160;', $imported_constant_clause, ' ARM imported constant modifications')"/>
							</A>
							<BR/>
						</xsl:if>
						<!-- only output if there are types defined and therefore a section -->
						<xsl:variable name="type_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'type'"/>
								<xsl:with-param name="schema_name" select="$arm_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$type_clause != 0">
							<A HREF="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#types">
								<xsl:value-of select="concat('&#160; &#160;', $type_clause, ' ARM type definitions')"/>
							</A>
							<BR/>
						</xsl:if>
						<!-- only output if there are imported types defined and therefore a section -->
						<xsl:variable name="imported_type_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'imported_type'"/>
								<xsl:with-param name="schema_name" select="$arm_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$imported_type_clause != 0">
							<A HREF="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#imported_type">
								<xsl:value-of select="concat('&#160; &#160;', $imported_type_clause, ' ARM imported type modifications')"/>
							</A>
							<BR/>
						</xsl:if>
						<!-- only output if there are entitys defined and therefore a section -->
						<xsl:variable name="entity_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'entity'"/>
								<xsl:with-param name="schema_name" select="$arm_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$entity_clause != 0">
							<A HREF="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#entities">
								<xsl:value-of select="concat('&#160; &#160;', $entity_clause, ' ARM entity definitions')"/>
							</A>
							<BR/>
						</xsl:if>
						<!-- only output if there are imported entitys defined and therefore a section -->
						<xsl:variable name="imported_entity_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'imported_entity'"/>
								<xsl:with-param name="schema_name" select="$arm_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$imported_entity_clause != 0">
							<A HREF="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#imported_entity">
								<xsl:value-of select="concat('&#160; &#160;', $imported_entity_clause, ' ARM imported entity modifications')"/>
							</A>
							<BR/>
						</xsl:if>
						<!-- only output if there are functions defined and therefore a section -->
						<xsl:variable name="function_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'function'"/>
								<xsl:with-param name="schema_name" select="$arm_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$function_clause !=0">
							<A HREF="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#functions">
								<xsl:value-of select="concat('&#160; &#160;', $function_clause, ' ARM function definitions')"/>
							</A>
							<BR/>
						</xsl:if>
						<!-- only output if there are imported functions defined and therefore a section -->
						<xsl:variable name="imported_function_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'imported_function'"/>
								<xsl:with-param name="schema_name" select="$arm_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$imported_function_clause != 0">
							<A HREF="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#imported_function">
								<xsl:value-of select="concat('&#160; &#160;', $imported_function_clause, ' ARM imported function modifications')"/>
							</A>
							<BR/>
						</xsl:if>
						<!-- only output if there are rules defined and therefore a section -->
						<xsl:variable name="rule_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'rule'"/>
								<xsl:with-param name="schema_name" select="$arm_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$rule_clause !=0">
							<A HREF="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#rules">
								<xsl:value-of select="concat('&#160; &#160;', $rule_clause, 'ARM rule definitions')"/>
							</A>
							<BR/>
						</xsl:if>
						<!-- only output if there are imported rules defined and therefore a section -->
						<xsl:variable name="imported_rule_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'imported_rule'"/>
								<xsl:with-param name="schema_name" select="$arm_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$imported_rule_clause != 0">
							<A HREF="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#imported_rule">
								<xsl:value-of select="concat('&#160; &#160;', $imported_rule_clause, ' ARM imported rule modifications')"/>
							</A>
							<BR/>
						</xsl:if>
						<!-- only output if there are procedures defined and therefore a section -->
						<xsl:variable name="procedure_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'procedure'"/>
								<xsl:with-param name="schema_name" select="$arm_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$procedure_clause != 0">
							<A HREF="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#procedures">
								<xsl:value-of select="concat('&#160; &#160;', $procedure_clause, ' ARM procedure definitions')"/>
							</A>
							<BR/>
						</xsl:if>
						<!-- only output if there are imported procedures defined and therefore a section -->
						<xsl:variable name="imported_procedure_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'imported_procedure'"/>
								<xsl:with-param name="schema_name" select="$arm_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$imported_procedure_clause != 0">
							<A HREF="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#imported_procedure">
									<xsl:value-of select="concat('&#160; &#160;', $imported_procedure_clause, ' ARM imported procedure modifications')"/>
							</A>
							<BR/>
						</xsl:if>
					</small>
					<!-- Output clause 5 index -->
					<!-- use #aim to link direct -->
					<A HREF="{$application_protocol_root}/sys/5_main{$FILE_EXT}">5 Application interpreted model</A>
					<BR/>
					<small>
						<A HREF="{$application_protocol_root}/sys/5_mapping{$FILE_EXT}">&#160; &#160;5.1 Mapping specification</A>
						<BR/>
						<A HREF="{$application_protocol_root}/sys/5_aim{$FILE_EXT}#aim_express">&#160; &#160;5.2 AIM EXPRESS short listing</A>
						<BR/>
						<!-- only output if there are constants defined and therefore a section -->
						<xsl:variable name="constant_aim_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'constant'"/>
								<xsl:with-param name="schema_name" select="$aim_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$constant_aim_clause != 0">
							<A HREF="{$application_protocol_root}/sys/5_aim{$FILE_EXT}#constants">
								<xsl:value-of select="concat('&#160; &#160; &#160;', $constant_aim_clause, ' AIM constant definitions')"/>
							</A>
							<BR/>
						</xsl:if>
						<!-- only output if there are imported constants defined and therefore a section -->
						<xsl:variable name="imported_constant_aim_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'imported_constant'"/>
								<xsl:with-param name="schema_name" select="$aim_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$imported_constant_aim_clause != 0">
							<A HREF="{$application_protocol_root}/sys/5_aim{$FILE_EXT}#imported_constant">
								<xsl:value-of select="concat('&#160; &#160; &#160;', $imported_constant_aim_clause, ' AIM imported constant modifications')"/>
							</A>
							<BR/>
						</xsl:if>
						<!-- only output if there are types defined and therefore a section -->
						<xsl:variable name="type_aim_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'type'"/>
								<xsl:with-param name="schema_name" select="$aim_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$type_aim_clause != 0">
							<A HREF="{$application_protocol_root}/sys/5_aim{$FILE_EXT}#types">
								<xsl:value-of select="concat('&#160; &#160; &#160;', $type_aim_clause, ' AIM type definitions')"/>
							</A>
							<BR/>
						</xsl:if>
						<!-- only output if there are imported types defined and therefore a section -->
						<xsl:variable name="imported_aim_type_clause">
							<xsl:call-template name="express_clause_present">
								<xsl:with-param name="clause" select="'imported_type'"/>
								<xsl:with-param name="schema_name" select="$aim_schema_name"/>
							</xsl:call-template>
						</xsl:variable>
							<xsl:if test="$imported_aim_type_clause != 0">
								<A HREF="{$application_protocol_root}/sys/5_aim{$FILE_EXT}#imported_type">
									<xsl:value-of select="concat('&#160; &#160; &#160;', $imported_aim_type_clause, ' AIM imported type modifications')"/>
								</A>
								<BR/>
							</xsl:if>
							<!-- only output if there are entitys defined and therefore a section -->
							<xsl:variable name="entity_aim_clause">
								<xsl:call-template name="express_clause_present">
									<xsl:with-param name="clause" select="'entity'"/>
									<xsl:with-param name="schema_name" select="$aim_schema_name"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:if test="$entity_aim_clause != 0">
								<A HREF="{$application_protocol_root}/sys/5_aim{$FILE_EXT}#entities">
									<xsl:value-of select="concat('&#160; &#160; &#160;', $entity_aim_clause, ' AIM entity definitions')"/>
								</A>
								<BR/>
							</xsl:if>
							<!-- only output if there are imported entitys defined and therefore a section -->
							<xsl:variable name="imported_aim_entity_clause">
								<xsl:call-template name="express_clause_present">
									<xsl:with-param name="clause" select="'imported_entity'"/>
									<xsl:with-param name="schema_name" select="$aim_schema_name"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:if test="$imported_aim_entity_clause != 0">
								<A HREF="{$application_protocol_root}/sys/5_aim{$FILE_EXT}#imported_entity">
									<xsl:value-of select="concat('&#160; &#160; &#160;', $imported_aim_entity_clause, ' AIM imported entity modifications')"/>
								</A>
								<BR/>
							</xsl:if>
							<!-- only output if there are functions defined and therefore a section -->
							<xsl:variable name="function_aim_clause">
								<xsl:call-template name="express_clause_present">
									<xsl:with-param name="clause" select="'function'"/>
									<xsl:with-param name="schema_name" select="$aim_schema_name"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:if test="$function_aim_clause != 0">
								<A HREF="{$application_protocol_root}/sys/5_aim{$FILE_EXT}#functions">
									<xsl:value-of select="concat('&#160; &#160; &#160;', $function_aim_clause, ' AIM function definitions')"/>
								</A>
								<BR/>
							</xsl:if>
							<!-- only output if there are imported functions defined and therefore a section -->
							<xsl:variable name="imported_aim_function_clause">
								<xsl:call-template name="express_clause_present">
									<xsl:with-param name="clause" select="'imported_function'"/>
									<xsl:with-param name="schema_name" select="$aim_schema_name"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:if test="$imported_aim_function_clause != 0">
								<A HREF="{$application_protocol_root}/sys/5_aim{$FILE_EXT}#imported_function">
									<xsl:value-of select="concat('&#160; &#160; &#160;', $imported_aim_function_clause, ' AIM imported function modifications')"/>
								</A>
								<BR/>
							</xsl:if>
							<!-- only output if there are rules defined and therefore a section -->
							<xsl:variable name="rule_aim_clause">
								<xsl:call-template name="express_clause_present">
									<xsl:with-param name="clause" select="'rule'"/>
									<xsl:with-param name="schema_name" select="$aim_schema_name"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:if test="$rule_aim_clause != 0">
								<A HREF="{$application_protocol_root}/sys/5_aim{$FILE_EXT}#rules">
									<xsl:value-of select="concat('&#160; &#160; &#160;', $rule_aim_clause, ' AIM rule definitions')"/>
								</A>
								<BR/>
							</xsl:if>
							<!-- only output if there are imported rules defined and therefore a section -->
							<xsl:variable name="imported_aim_rule_clause">
								<xsl:call-template name="express_clause_present">
									<xsl:with-param name="clause" select="'imported_rule'"/>
									<xsl:with-param name="schema_name" select="$aim_schema_name"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:if test="$imported_aim_rule_clause != 0">
								<A HREF="{$application_protocol_root}/sys/5_aim{$FILE_EXT}#imported_rule">
							<xsl:value-of select="concat('&#160; &#160; &#160;', $imported_aim_rule_clause, ' AIM imported rule modifications')"/>
								</A>
								<BR/>
							</xsl:if>
							<!-- only output if there are procedures defined and therefore a section -->
							<xsl:variable name="procedure_aim_clause">
								<xsl:call-template name="express_clause_present">
									<xsl:with-param name="clause" select="'procedure'"/>
									<xsl:with-param name="schema_name" select="$aim_schema_name"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:if test="$procedure_aim_clause != 0">
								<A HREF="{$application_protocol_root}/sys/5_aim{$FILE_EXT}#procedures">
									<xsl:value-of select="concat('&#160; &#160; &#160;', $procedure_aim_clause, ' AIM procedure definitions')"/>
								</A>
								<BR/>
							</xsl:if>
							<!-- only output if there are imported procedures defined and therefore a section -->
							<xsl:variable name="imported_aim_procedure_clause">
								<xsl:call-template name="express_clause_present">
									<xsl:with-param name="clause" select="'imported_procedure'"/>
									<xsl:with-param name="schema_name" select="$aim_schema_name"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:if test="$imported_aim_procedure_clause != 0">
								<A HREF="{$application_protocol_root}/sys/5_aim{$FILE_EXT}#imported_procedure">
									<xsl:value-of select="concat('&#160; &#160; &#160;', $imported_aim_procedure_clause, ' AIM imported procedure modifications')"/>
								</A>
								<BR/>
							</xsl:if>
						</small>
					</p>
				</TD>
				<TD valign="TOP">
					<p class="toc">
						<!-- use #annexa to link direct -->
						<A HREF="{$application_protocol_root}/sys/a_exp_aim_lf{$FILE_EXT}">
							A AIM EXPRESS expanded listing
						</A>
						<xsl:call-template name="expressg_icon">
							<xsl:with-param name="schema" select="concat(./@name,'_mim')"/>
							<xsl:with-param name="application_protocol_root" select="$application_protocol_root"/>
						</xsl:call-template>
						<BR/>
						<!-- use #annexb to link direct -->
						<A HREF="{$application_protocol_root}/sys/b_imp_meth{$FILE_EXT}">
							B Implementation method specific requirements
						</A>
						<BR/>
						<!-- use #annexc to link direct -->
						<A HREF="{$application_protocol_root}/sys/c_pics{$FILE_EXT}">
							C Protocol Implementation Conformance Statement (PICS) form
						</A>
						<br/>
						<!-- use #annexd to link direct -->
						<A HREF="{$application_protocol_root}/sys/d_obj_reg{$FILE_EXT}">
							D Information object registration
						</A>
						<BR/>
						<!-- use #annexe to link direct -->
						<A HREF="{$application_protocol_root}/sys/e_aam{$FILE_EXT}">
							E Application activity model
						</A>
						<xsl:call-template name="idef0_icon">
							<xsl:with-param name="schema" select="concat(./@name,'_arm')"/>
							<xsl:with-param name="application_protocol_root" select="$application_protocol_root"/>
						</xsl:call-template>

						<BR/>
						<!-- use #annexf to link direct -->
						<A HREF="{$application_protocol_root}/sys/f_arm_expg{$FILE_EXT}">
							F Application reference model
						</A>
						<xsl:call-template name="expressg_icon">
							<xsl:with-param name="schema" select="concat(./@name,'_arm')"/>
							<xsl:with-param name="application_protocol_root" select="$application_protocol_root"/>
						</xsl:call-template>
						<BR/>
						<!-- use #annexg to link direct -->
						<A HREF="{$application_protocol_root}/sys/g_exp_aim{$FILE_EXT}">
							G Computer interpretable listing
						</A>
						<BR/>
						<!-- use #annexh to link direct -->
						<xsl:if test="./usage_guide">
							<A HREF="{$application_protocol_root}/sys/h_guide{$FILE_EXT}">
								H Computer interpretable listing
							</A>
							<BR/>
						</xsl:if>
						<!-- use #annexj to link direct -->
						<xsl:if test="./tech_disc">
							<A HREF="{$application_protocol_root}/sys/j_tech_disc{$FILE_EXT}">
								J Technical discussions
							</A>
							<BR/>
						</xsl:if>
						<A HREF="{$application_protocol_root}/sys/biblio{$FILE_EXT}#biblio">
						Bibliography
						</A>
					</p>
				</TD>
			</TR>
		</TABLE>
	</xsl:template>

<!--
     Output the Table of contents banner for a module where all clauses are 
     displayed on a single page
-->
<xsl:template match="application_protocol" mode="TOCsinglePage">
  <xsl:param name="application_protocol_root" select="'..'"/>
  <xsl:apply-templates select="." mode="TOCbannertitle">
    <xsl:with-param name="application_protocol_root" select="$application_protocol_root"/>
  </xsl:apply-templates>
  <TABLE border="1" cellspacing="1" width="100%">
    <TR>
      <TD valign="TOP">
        <A HREF="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#cover_page">Cover page</A><BR/>
        <A HREF="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#foreword">Foreword</A><BR/>
        <A HREF="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#intro">Introduction</A><BR/>
        <A HREF="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#scope">1 Scope</A><BR/>
        <A HREF="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#nref">2 Normative references</A><BR/>
        <A HREF="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#defns">3 Definitions and abbreviations</A>
      </TD>
      <TD valign="TOP">
        <A HREF="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#arm">4 Information requirements</A><BR/>
        <A HREF="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#aim">5 Application interpreted model</A><BR/>
	 <A HREF="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#ccs">6 Conformance classes</A><BR/>
        <A HREF="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#annexa">A AIM EXPRESS expanded listing</A><BR/>
        <A HREF="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#annexb">B Implementation method specific requirements</A><BR/>
        <A HREF="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#annexc">C Protocol Implementation Conformance Statement (PICS) form.</A><BR/>
        <A HREF="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#annexd">D Information object registration</A>
      </TD>
      <TD valign="TOP">
        <A HREF="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#annexe">E Application activity model</A><BR/>
		<A HREF="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#annexe">F Application reference model</A><BR/>
	<A HREF="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#annexe">G Computer interpretable listing</A><BR/>
	<xsl:if test="./usage_guide">
		<!-- use #annexh to link direct -->
		<A HREF="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}">
			H Application protocol implementation and usage guide
		</A>
		<BR/>
	</xsl:if>
	<xsl:if test="./tech_disc">
		<!-- use #annexj to link direct -->
		<A HREF="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}">
			J Technical discussions
		</A>
		<BR/>
	</xsl:if>
	
	<!-- use #biblio to link direct -->
	<A HREF="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}">Bibliography</A>
      </TD>
    </TR>
  </TABLE>
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
