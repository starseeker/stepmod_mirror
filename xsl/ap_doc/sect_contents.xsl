<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_contents.xsl,v 1.2 2002-07-17 14:41:39 mwd Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: Output the refs section as a web page
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:import href="application_protocol.xsl"/>
	
	<!-- the stylesheet that allows different stylesheets to be applied -->
	
	<xsl:import href="application_protocol_clause.xsl"/>
	
	<xsl:output method="html"/>
	
	<!-- overwrites the template declared in module.xsl -->
	
	<xsl:template match="application_protocol">
		<xsl:apply-templates select="../application_protocol" mode="contents"/>
		<xsl:apply-templates select="../application_protocol" mode="contents_tables_figures"/>
		<xsl:apply-templates select="../application_protocol" mode="copyright"/>
	</xsl:template>
	
	<xsl:template match="application_protocol" mode="contents">
		<xsl:variable name="arm_schema_name" select="concat(@name,'_arm')"/>
		<xsl:variable name="aim_schema_name" select="concat(@name,'_aim')"/>
		
		<xsl:variable name="application_protocol_dir">
			<xsl:call-template name="application_protocol_directory">
      				<xsl:with-param name="application_protocol" select="@name"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="module_dir">
			<xsl:call-template name="module_directory">
      				<xsl:with-param name="application_protocol" select="@name"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="arm_xml" select="concat($module_dir,'/arm.xml')"/>
		<xsl:variable name="aim_xml" select="concat($application_protocol_dir,'/aim.xml')"/>
		
		<h3>Contents</h3>
		<p class="content"><A HREF="./1_scope{$FILE_EXT}">1 Scope</A></p>
		<p class="content"><A HREF="./2_refs{$FILE_EXT}">2 Normative references</A></p>
		<xsl:choose>
			<xsl:when test="./definition/term">
				<p class="content">
					<A HREF="./3_defs{$FILE_EXT}">
						3 Terms, definitions and abbreviations
					</A>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<p class="content">
					<A HREF="./3_defs{$FILE_EXT}">
						3 Terms and abbreviations
					</A>
				</p>
			</xsl:otherwise>
		</xsl:choose>
		<p class="content">
			<A HREF="./4_info_reqs{$FILE_EXT}">4 Information requirements</A>
		</p>
		<p class="content">
			<A HREF="./4_info_reqs{$FILE_EXT}#uof">
				<xsl:value-of select="concat('&#160;&#160;',' 4.1 Units of functionality')"/>
			</A>
		</p>
		<xsl:variable name="interface_clause">
			<xsl:call-template name="express_clause_present">
				<xsl:with-param name="clause" select="'interface'"/>
				<xsl:with-param name="schema_name" select="$arm_schema_name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="$interface_clause != 0">
			<p class="content">
				<A HREF="./4_info_reqs{$FILE_EXT}#interfaces">
					<xsl:value-of select="concat('&#160; &#160;', $interface_clause, ' Required AM ARMs')"/>
				</A>
			</p>
		</xsl:if>
		<xsl:variable name="constant_clause">
			<xsl:call-template name="express_clause_present">
				<xsl:with-param name="clause" select="'constant'"/>
				<xsl:with-param name="schema_name" select="$arm_schema_name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="$constant_clause != 0">
			<p class="content">
				<A HREF="./4_info_reqs{$FILE_EXT}#constants">
					<xsl:value-of select="concat('&#160; &#160;', $constant_clause, ' ARM constant definitions')"/>
				</A>
			</p>
			<xsl:apply-templates select="document($arm_xml)/express/schema/constant" mode="contents"/>
		</xsl:if>
		
		<xsl:variable name="imported_constant_clause">
			<xsl:call-template name="express_clause_present">
				<xsl:with-param name="clause" select="'imported_constant'"/>
				<xsl:with-param name="schema_name" select="$arm_schema_name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="$imported_constant_clause != 0">
			<p class="content">
				<A HREF="./4_info_reqs{$FILE_EXT}#imported_constant">
					<xsl:value-of select="concat('&#160; &#160;', $imported_constant_clause, ' ARM imported constant modifications')"/>
				</A>
			</p>
		</xsl:if>
		
		<xsl:variable name="type_clause">
			<xsl:call-template name="express_clause_present">
				<xsl:with-param name="clause" select="'type'"/>
				<xsl:with-param name="schema_name" select="$arm_schema_name"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:if test="$type_clause != 0">
			<p class="content">
				<A HREF="./4_info_reqs{$FILE_EXT}#types">
					<xsl:value-of select="concat('&#160; &#160;', $type_clause, ' ARM type definitions')"/>
				</A>
			</p>
			<xsl:apply-templates select="document($arm_xml)/express/schema/type" mode="contents"/>
		</xsl:if>
		
		<xsl:variable name="imported_type_clause">
			<xsl:call-template name="express_clause_present">
				<xsl:with-param name="clause" select="'imported_type'"/>
				<xsl:with-param name="schema_name" select="$arm_schema_name"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:if test="$imported_type_clause != 0">
			<p class="content">
				<A HREF="./4_info_reqs{$FILE_EXT}#imported_type">
					<xsl:value-of select="concat('&#160; &#160;', $imported_type_clause, ' ARM imported type modifications')"/>
				</A>
			</p>
		</xsl:if>
		
		<xsl:variable name="entity_clause">
			<xsl:call-template name="express_clause_present">
				<xsl:with-param name="clause" select="'entity'"/>
				<xsl:with-param name="schema_name" select="$arm_schema_name"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:if test="$entity_clause != 0">
			<p class="content">
				<A HREF="./4_info_reqs{$FILE_EXT}#entities">
					<xsl:value-of select="concat('&#160; &#160;', $entity_clause, ' ARM entity definitions')"/>
				</A>
			</p>
			<xsl:apply-templates select="document($arm_xml)/express/schema/entity" mode="contents"/>
		</xsl:if>
		
		<xsl:variable name="imported_entity_clause">
			<xsl:call-template name="express_clause_present">
				<xsl:with-param name="clause" select="'imported_entity'"/>
				<xsl:with-param name="schema_name" select="$arm_schema_name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="$imported_entity_clause != 0">
			<p class="content">
				<A HREF="./4_info_reqs{$FILE_EXT}#imported_entity">
					<xsl:value-of select="concat('&#160; &#160;', $imported_entity_clause, ' ARM imported entity modifications')"/>
				</A>
			</p>
		</xsl:if>
		
		<xsl:variable name="function_clause">
			<xsl:call-template name="express_clause_present">
				<xsl:with-param name="clause" select="'function'"/>
				<xsl:with-param name="schema_name" select="$arm_schema_name"/>
			</xsl:call-template>
		</xsl:variable>
  <xsl:if test="$function_clause !=0">
    <p class="content">
      <A HREF="./4_info_reqs{$FILE_EXT}#functions">
        <xsl:value-of select="concat('&#160; &#160;', $function_clause,
                              ' ARM function definitions')"/>
      </A>
    </p>
    <xsl:apply-templates 
      select="document($arm_xml)/express/schema/function" mode="contents"/>
  </xsl:if>
  <!-- only output if there are imported functions defined and 
       therefore a section -->
  <xsl:variable name="imported_function_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'imported_function'"/>
      <xsl:with-param name="schema_name" select="$arm_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$imported_function_clause != 0">
    <p class="content">
      <A HREF="./4_info_reqs{$FILE_EXT}#imported_function">
        <xsl:value-of select="concat('&#160; &#160;', 
                              $imported_function_clause,
                              ' ARM imported function modifications')"/>
      </A>
    </p>
  </xsl:if>
  
  <!-- only output if there are rules defined and therefore a
       section -->
  <xsl:variable name="rule_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'rule'"/>
      <xsl:with-param name="schema_name" select="$arm_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$rule_clause !=0">
    <p class="content">
      <A HREF="./4_info_reqs{$FILE_EXT}#rules">
        <xsl:value-of select="concat('&#160; &#160;', $rule_clause,
                              'ARM rule definitions')"/>
      </A>
    </p>
    <xsl:apply-templates 
      select="document($arm_xml)/express/schema/rule" mode="contents"/>
  </xsl:if>
  <!-- only output if there are imported rules defined and 
       therefore a section -->
  <xsl:variable name="imported_rule_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'imported_rule'"/>
      <xsl:with-param name="schema_name" select="$arm_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$imported_rule_clause != 0">
    <p class="content">
      <A HREF="./4_info_reqs{$FILE_EXT}#imported_rule">
        <xsl:value-of select="concat('&#160; &#160;', 
                              $imported_rule_clause,
                              ' ARM imported rule modifications')"/>
      </A>
    </p>
  </xsl:if>
  
  <!-- only output if there are procedures defined and therefore a
       section -->
  <xsl:variable name="procedure_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'procedure'"/>
      <xsl:with-param name="schema_name" select="$arm_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$procedure_clause != 0">
    <p class="content">
      <A HREF="./4_info_reqs{$FILE_EXT}#procedures">
        <xsl:value-of select="concat('&#160; &#160;', $procedure_clause,
                              ' ARM procedure definitions')"/>
      </A>
    </p>
    <xsl:apply-templates 
      select="document($arm_xml)/express/schema/procedure" mode="contents"/>
  </xsl:if>
  <!-- only output if there are imported procedures defined and 
       therefore a section -->
  <xsl:variable name="imported_procedure_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'imported_procedure'"/>
      <xsl:with-param name="schema_name" select="$arm_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$imported_procedure_clause != 0">
    <p class="content">
      <A HREF="./4_info_reqs{$FILE_EXT}#imported_procedure">
        <xsl:value-of select="concat('&#160; &#160;', 
                              $imported_procedure_clause,
                              ' ARM imported procedure modifications')"/>
      </A>
    </p>
  </xsl:if>
  
  <!-- Output clause 5 index -->
  <!-- use #aim to link direct -->

	<p class="content">
		<A HREF="./5_aim{$FILE_EXT}">5 Application interpreted model</A>
	</p>
	<p class="content">
		<A HREF="./5_aim{$FILE_EXT}#aim_express">&#160; &#160;5.2 AIM EXPRESS short listing</A>
	</p>
	
	<xsl:variable name="constant_aim_clause">
		<xsl:call-template name="express_clause_present">
			<xsl:with-param name="clause" select="'constant'"/>
			<xsl:with-param name="schema_name" select="$aim_schema_name"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:if test="$constant_aim_clause != 0">
		<p class="content">
			<A HREF="./5_aim{$FILE_EXT}#constants">
				<xsl:value-of select="concat('&#160; &#160; &#160;', $constant_aim_clause, ' AIM constant definitions')"/>
			</A>
		</p>
		<xsl:apply-templates select="document($arm_xml)/express/schema/constant" mode="contents"/>
	</xsl:if>
	
	<xsl:variable name="imported_constant_aim_clause">
		<xsl:call-template name="express_clause_present">
			<xsl:with-param name="clause" select="'imported_constant'"/>
			<xsl:with-param name="schema_name" select="$aim_schema_name"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:if test="$imported_constant_aim_clause != 0">
		<p class="content">
			<A HREF="./5_aim{$FILE_EXT}#imported_constant">
				<xsl:value-of select="concat('&#160; &#160; &#160;', $imported_constant_aim_clause, ' AIM imported constant modifications')"/>
			</A>
		</p>
	</xsl:if>
	
	<xsl:variable name="type_aim_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'type'"/>
      <xsl:with-param name="schema_name" select="$aim_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$type_aim_clause != 0">
    <p class="content">
      <A HREF="./5_aim{$FILE_EXT}#types">
        <xsl:value-of select="concat('&#160; &#160; &#160;', $type_aim_clause,
                              ' AIM type definitions')"/>
      </A>
    </p>
    <xsl:apply-templates 
      select="document($aim_xml)/express/schema/type" mode="contents"/>
  </xsl:if>          
  <!-- only output if there are imported types defined and 
       therefore a section -->
  <xsl:variable name="imported_aim_type_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'imported_type'"/>
      <xsl:with-param name="schema_name" select="$aim_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$imported_aim_type_clause != 0">
    <p class="content">
      <A HREF="./5_aim{$FILE_EXT}#imported_type">
        <xsl:value-of select="concat('&#160; &#160; &#160;', 
                              $imported_aim_type_clause,
                              ' AIM imported type modifications')"/>
      </A>
    </p>
  </xsl:if>
  
  <!-- only output if there are entitys defined and therefore a
       section -->
  <xsl:variable name="entity_aim_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'entity'"/>
      <xsl:with-param name="schema_name" select="$aim_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$entity_aim_clause != 0">
    <p class="content">
      <A HREF="./5_aim{$FILE_EXT}#entities">
        <xsl:value-of select="concat('&#160; &#160; &#160;', $entity_aim_clause,
                              ' AIM entity definitions')"/>
      </A>
    </p>
    <xsl:apply-templates 
      select="document($aim_xml)/express/schema/entity" mode="contents"/>
  </xsl:if>          
  
  <!-- only output if there are imported entitys defined and 
       therefore a section -->
  <xsl:variable name="imported_aim_entity_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'imported_entity'"/>
      <xsl:with-param name="schema_name" select="$aim_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$imported_aim_entity_clause != 0">
    <p class="content">
      <A HREF="./5_aim{$FILE_EXT}#imported_entity">
        <xsl:value-of select="concat('&#160; &#160; &#160;', 
                              $imported_aim_entity_clause,
                              ' AIM imported entity modifications')"/>
      </A>
    </p>
  </xsl:if>
  
  
  <!-- only output if there are functions defined and therefore a
       section -->
  <xsl:variable name="function_aim_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'function'"/>
      <xsl:with-param name="schema_name" select="$aim_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$function_aim_clause != 0">
    <p class="content">
      <A HREF="./5_aim{$FILE_EXT}#functions">
        <xsl:value-of select="concat('&#160; &#160; &#160;', $function_aim_clause,
                              ' AIM function definitions')"/>
      </A>
    </p>
  </xsl:if>          
  <!-- only output if there are imported functions defined and 
       therefore a section -->
  <xsl:variable name="imported_aim_function_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'imported_function'"/>
      <xsl:with-param name="schema_name" select="$aim_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$imported_aim_function_clause != 0">
    <p class="content">
      <A HREF="./5_aim{$FILE_EXT}#imported_function">
        <xsl:value-of select="concat('&#160; &#160; &#160;', 
                              $imported_aim_function_clause,
                              ' AIM imported function modifications')"/>
      </A>
    </p>
  </xsl:if>
  
  
  <!-- only output if there are rules defined and therefore a
       section -->
  <xsl:variable name="rule_aim_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'rule'"/>
      <xsl:with-param name="schema_name" select="$aim_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$rule_aim_clause != 0">
    <p class="content">
      <A HREF="./5_aim{$FILE_EXT}#rules">
        <xsl:value-of select="concat('&#160; &#160; &#160;', $rule_aim_clause,
                              ' AIM rule definitions')"/>
      </A>
    </p>
  </xsl:if>          
  <!-- only output if there are imported rules defined and 
       therefore a section -->
  <xsl:variable name="imported_aim_rule_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'imported_rule'"/>
      <xsl:with-param name="schema_name" select="$aim_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$imported_aim_rule_clause != 0">
    <p class="content">
      <A HREF="./5_aim{$FILE_EXT}#imported_rule">
        <xsl:value-of select="concat('&#160; &#160; &#160;', 
                              $imported_aim_rule_clause,
                              ' AIM imported rule modifications')"/>
      </A>
    </p>
  </xsl:if>
  
  <!-- only output if there are procedures defined and therefore a
       section -->
  <xsl:variable name="procedure_aim_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'procedure'"/>
      <xsl:with-param name="schema_name" select="$aim_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$procedure_aim_clause != 0">
    <p class="content">
      <A HREF="./5_aim{$FILE_EXT}#procedures">
        <xsl:value-of select="concat('&#160; &#160; &#160;', $procedure_aim_clause,
                              ' AIM procedure definitions')"/>
      </A>
    </p>
  </xsl:if>          
  <!-- only output if there are imported procedures defined and 
       therefore a section -->
  <xsl:variable name="imported_aim_procedure_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'imported_procedure'"/>
      <xsl:with-param name="schema_name" select="$aim_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$imported_aim_procedure_clause != 0">
    <p class="content">
      <A HREF="./5_aim{$FILE_EXT}#imported_procedure">
        <xsl:value-of select="concat('&#160; &#160; &#160;', 
                              $imported_aim_procedure_clause,
                              ' AIM imported procedure modifications')"/>
      </A>
    </p>
  </xsl:if>
  
  <!-- use #annexa to link direct -->
  <p class="content">
    <A HREF="./a_exp_aim{$FILE_EXT}">A AIM EXPRESS expanded listing</A>
  </p>
  <!-- use #annexb to link direct -->
  <p class="content">
    <A HREF="./b_imp_meth{$FILE_EXT}">B Implementation method specific requirements</A>
  </p>
  
  <!-- use #annexc to link direct -->
  <p class="content">
    <A HREF="./c_pics{$FILE_EXT}">C Protocol Implementation Conformance Statement (PICS) form</A>
  </p>
  
  <!-- use #annexd to link direct -->
  <p class="content">
    <A HREF="./d_obj_reg{$FILE_EXT}">D Information object registration</A>
  </p>
  
  <!-- use #annexe to link direct -->
  <p class="content">
    <A HREF="./e_aam{$FILE_EXT}">E Application activity model</A>
  </p>

	<p class="content">
		<A HREF="./f_arm_expg{$FILE_EXT}">F Application reference model (EXPRESS-G)</A>
	</p>
	
	<p class="content">
		<A HREF="./g_exp_aim{$FILE_EXT}">G Computer interpretable listing</A>
	</p>
	
	<xsl:if test="./usage_guide">
		<p class="content">
			<A HREF="./h_guide{$FILE_EXT}">H Application protocol implementation and usage guide</A>
		</p>
	</xsl:if>
	
	<xsl:if test="./tech_disc">
		<p class="content">
			<A HREF="./j_tech_disc{$FILE_EXT}">J Technical discussions</A>
		</p>
	</xsl:if>
	
	<A HREF="./biblio{$FILE_EXT}#biblio">Bibliography</A>
  
</xsl:template>




<xsl:template match="constant|type|entity|rule|procedure|function" 
  mode="contents">
  <xsl:variable name="node_type" select="name(.)"/>
  <xsl:variable name="schema_name" select="../@name"/>
  <xsl:variable name="clause_number">
    <xsl:call-template name="express_clause_number">
      <xsl:with-param name="clause" select="$node_type"/>
      <xsl:with-param name="schema_name" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>    

  <xsl:variable name="xref">
    <xsl:choose>
      <xsl:when test="substring($schema_name, string-length($schema_name)-3)= '_arm'">
        <xsl:value-of select="concat('./4_info_reqs',$FILE_EXT,'#',$aname)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('./5_aim',$FILE_EXT,'#',$aname)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <p class="content">
    <A HREF="{$xref}">
      <xsl:value-of select="concat('&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;',$clause_number, '.', position(), ' ', @name)"/>
    </A>
  </p>
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
            <xsl:value-of 
              select="concat('Figure C.',$number, 
                      ' - ARM Schema level EXPRESS-G diagram ',$number)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of 
              select="concat('Figure C.',$number, 
                      ' - ARM Entity level EXPRESS-G diagram ',($number - 1))"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="name(../..)='aim'">
        <xsl:choose>
          <xsl:when test="$number=1">
            <xsl:value-of 
              select="concat('Figure D.',$number, 
                      ' - AIM Schema level EXPRESS-G diagram ',$number)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of 
              select="concat('Figure D.',$number, 
                      ' - AIM Entity level EXPRESS-G diagram ',($number - 1))"/>
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
  <p class="content">
    <a href="{$href}"><xsl:value-of select="$fig_no"/></a>
  </p>
</xsl:template>


<!-- list an index the tables and figures -->
<xsl:template match="application_protocol" mode="contents_tables_figures">

  <xsl:variable name="application_protocol_dir">
    <xsl:call-template name="application_protocol_directory">
      <xsl:with-param name="application_protocol" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

<xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="application_protocol" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

 <xsl:variable name="arm_xml" select="concat($module_dir,'/arm.xml')"/>
  <xsl:variable name="arm_desc_xml" select="document($arm_xml)/express/@description.file"/>
  <xsl:variable name="aim_xml" select="concat($application_protocol_dir,'/aim.xml')"/>
  <xsl:variable name="aim_desc_xml" select="document($aim_xml)/express/@description.file"/>

  <h3>Tables</h3>
  <xsl:apply-templates select="//table" mode="toc"/>
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
  <a href="./e_exp{$FILE_EXT}#table_e1">
    Table E.1 &#8212; ARM to AIM EXPRESS short and long form listing.
  </a>

  <h3>Figures</h3>
  <!-- collect up the figures from the Module -->
  <xsl:apply-templates select="//figure" mode="toc"/>
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

  <!-- collect up the EXpressG figures from the ARM -->
  <xsl:apply-templates 
    select="./arm/express-g/imgfile" mode="expressg_figure"/>
  <!-- collect up the EXpressG figures from the AIM -->
  <xsl:apply-templates 
    select="./aim/express-g/imgfile" mode="expressg_figure"/>

</xsl:template>


<xsl:template match="table|figure" mode="toc">
  <xsl:variable name="href">
    <xsl:call-template name="table_href">
      <xsl:with-param name="table" select="."/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="table_or_fig" select="name(.)"/>
  <p class="content">
    <a href="{$href}">      
    <xsl:value-of 
      select="concat($table_or_fig,' ',@number, '&#8212;', @caption)"/>
    </a>
  </p>

</xsl:template>


<xsl:template match="module" mode="copyright">
  <p>
    &#169;ISO
    <xsl:value-of select="@publication.year"/>
  </p>
  <p>
    All rights reserved. Unless otherwise specified, no part of this
    publication may be reproduced or utilized in any form or by any means,
    electronic or mechanical, including photocopying and microfilm, 
    without permission in writing from either ISO at the address below or
    ISO's member body in the 
    country of the requester.
  </p>
  <p>
    <blockquote>
      ISO copyright office<br/>
      Case postale 56. CH-1211 Geneva 20<br/>
      Tel. + 41 22 749 01 11<br/>
      Fax + 41 22 734 10 79<br/>
      E-mail copyright@iso.ch<br/>
      Web www.iso.ch<br/>
    </blockquote>
  </p>
</xsl:template>



<xsl:template match="ae" mode="toc">
  <xsl:variable name="sect_no">
    <xsl:number/>
  </xsl:variable>
  <xsl:variable name="aname" select="@entity"/>
  <p class="content">
    <a href="#{$aname}">
      <xsl:value-of
        select="concat('&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;5.1.',$sect_no,' ',$aname)"/>
    </a>
  </p>

  <xsl:apply-templates select="aa" mode="toc">
    <xsl:with-param name="sect" select="concat('5.1.',$sect_no)"/>
  </xsl:apply-templates>

</xsl:template>

<xsl:template match="aa" mode="toc">
  <xsl:param name="sect"/>
  <xsl:variable 
    name="schema_name" 
    select="concat(../../../../module/@name,'_arm')"/>

  <xsl:variable name="aa_aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="../@entity"/>
      <xsl:with-param name="section3" select="@attribute"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable 
    name="aa_xref"
    select="concat('./4_info_reqs',$FILE_EXT,'#',$aa_aname)"/>

  <xsl:variable name="sect_no" select="concat($sect,'.',position())"/>
  <p class="content">
    <xsl:text>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</xsl:text>
    <xsl:choose>
      <xsl:when test="@assertion_to">
        <a href="./5_mapping{$FILE_EXT}#{$aa_aname}">
          <xsl:value-of 
            select="concat($sect_no,' ',
                    ../@entity, ' to ', ./@assertion_to, ' (as ',@attribute,')')"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <a href="./5_mapping{$FILE_EXT}#{$aa_aname}">
          <xsl:value-of select="concat($sect_no,' ',@attribute)"/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </p>
</xsl:template>

</xsl:stylesheet>