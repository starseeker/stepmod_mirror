<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_2_refs.xsl,v 1.4 2002/03/04 07:50:08 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: Output the refs section as a web page
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="module.xsl"/>

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
  <xsl:import href="module_clause.xsl"/>


  <xsl:output method="html"/>

<!-- overwrites the template declared in module.xsl -->
<xsl:template match="module">
  <xsl:apply-templates select="../module" mode="contents"/>
  <xsl:apply-templates select="../module" mode="contents_tables"/>
  <xsl:apply-templates select="../module" mode="contents_figures"/>
  <xsl:apply-templates select="../module" mode="copyright"/>
</xsl:template>

<xsl:template match="module" mode="contents">
  <xsl:variable name="arm_schema_name" select="concat(@name,'_arm')"/>
  <xsl:variable name="mim_schema_name" select="concat(@name,'_mim')"/>

  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="arm_xml" select="concat($module_dir,'/arm.xml')"/>
  <xsl:variable name="mim_xml" select="concat($module_dir,'/mim.xml')"/>

  <h3>Contents</h3>
    <!-- Don't think these are required
  <p class="content"><A HREF="./cover{$FILE_EXT}">Cover page</A></p>
  <p class="content"><A HREF="./foreword{$FILE_EXT}">Foreword</A></p>
  <p class="content"><A
  HREF="./introduction{$FILE_EXT}">Introduction</A></p>
-->
  <p class="content"><A HREF="./1_scope{$FILE_EXT}">1 Scope</A></p>
  <p class="content"><A HREF="./2_refs{$FILE_EXT}">2 Normative references</A></p>

  <xsl:choose>
    <xsl:when test="./definition/term">
      <!-- use #defns to link direct -->
      <p class="content">
        <A HREF="./3_defs{$FILE_EXT}">
          3 Terms, definitions and abbreviations
        </A>
      </p>
    </xsl:when>
    <xsl:otherwise>
      <!-- use #defns to link direct -->
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

  <!-- only output if there are interfaces defined and therefore a
       section -->
  <xsl:variable name="interface_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'interface'"/>
      <xsl:with-param name="schema_name" select="$arm_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$interface_clause != 0">
    <p class="content">
      <A HREF="./4_info_reqs{$FILE_EXT}#interfaces">
        <xsl:value-of select="concat('&#160; &#160;', $interface_clause,
                              ' Required AM ARMs')"/>
      </A>
    </p>
  </xsl:if>

  <!-- only output if there are constants defined and therefore a
       section -->
  <xsl:variable name="constant_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'constant'"/>
      <xsl:with-param name="schema_name" select="$arm_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$constant_clause != 0">
    <p class="content">
      <A HREF="./4_info_reqs{$FILE_EXT}#constants">
        <xsl:value-of select="concat('&#160; &#160;', $constant_clause,
                              ' ARM constant definitions')"/>
      </A>
    </p>
    <xsl:apply-templates 
      select="document($arm_xml)/express/schema/constant" mode="contents"/>
  </xsl:if>

  <!-- only output if there are imported constants defined and 
       therefore a section -->
  <xsl:variable name="imported_constant_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'imported_constant'"/>
      <xsl:with-param name="schema_name" select="$arm_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$imported_constant_clause != 0">
    <p class="content">
      <A HREF="./4_info_reqs{$FILE_EXT}#imported_constant">
        <xsl:value-of select="concat('&#160; &#160;', 
                              $imported_constant_clause,
                              ' ARM imported constant modifications')"/>
      </A>
    </p>
  </xsl:if>


  <!-- only output if there are types defined and therefore a
       section -->
  <xsl:variable name="type_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'type'"/>
      <xsl:with-param name="schema_name" select="$arm_schema_name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="$type_clause != 0">
    <p class="content">
      <A HREF="./4_info_reqs{$FILE_EXT}#types">
        <xsl:value-of select="concat('&#160; &#160;', $type_clause,
                              ' ARM type definitions')"/>
      </A>
    </p>    
    <xsl:apply-templates 
      select="document($arm_xml)/express/schema/type" mode="contents"/>
  </xsl:if>

  <!-- only output if there are imported types defined and 
       therefore a section -->
  <xsl:variable name="imported_type_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'imported_type'"/>
      <xsl:with-param name="schema_name" select="$arm_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$imported_type_clause != 0">
    <p class="content">
      <A HREF="./4_info_reqs{$FILE_EXT}#imported_type">
        <xsl:value-of select="concat('&#160; &#160;', 
                              $imported_type_clause,
                              ' ARM imported type modifications')"/>
      </A>
    </p>
  </xsl:if>


  <!-- only output if there are entitys defined and therefore a
       section -->
  <xsl:variable name="entity_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'entity'"/>
      <xsl:with-param name="schema_name" select="$arm_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$entity_clause != 0">
    <p class="content">
      <A HREF="./4_info_reqs{$FILE_EXT}#entities">
        <xsl:value-of select="concat('&#160; &#160;', $entity_clause,
                              ' ARM entity definitions')"/>
      </A>
    </p>
    <xsl:apply-templates 
      select="document($arm_xml)/express/schema/entity" mode="contents"/>
  </xsl:if>
  
  <!-- only output if there are imported entitys defined and 
       therefore a section -->
  <xsl:variable name="imported_entity_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'imported_entity'"/>
      <xsl:with-param name="schema_name" select="$arm_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$imported_entity_clause != 0">
    <p class="content">
      <A HREF="./4_info_reqs{$FILE_EXT}#imported_entity">
        <xsl:value-of select="concat('&#160; &#160;', 
                              $imported_entity_clause,
                              ' ARM imported entity modifications')"/>
      </A>
    </p>
  </xsl:if>
  
  <!-- only output if there are functions defined and therefore a
       section -->
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
  <!-- use #mim to link direct -->
  <p class="content">
    <A HREF="./5_mim{$FILE_EXT}">5 Module interpreted
    model</A>
  </p>
  <p class="content">
    <A HREF="./5_mapping{$FILE_EXT}">&#160; &#160;5.1
    Mapping specification</A>
  </p>
  <p class="content">
    <A HREF="./5_mim{$FILE_EXT}#mim_express">&#160; &#160;5.2 MIM EXPRESS short listing</A>
  </p>
  
  <!-- only output if there are constants defined and therefore a
       section -->
  <xsl:variable name="constant_mim_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'constant'"/>
      <xsl:with-param name="schema_name" select="$mim_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:if test="$constant_mim_clause != 0">
    <p class="content">
      <A HREF="./5_mim{$FILE_EXT}#constants">
        <xsl:value-of select="concat('&#160; &#160; &#160;', $constant_mim_clause,
                              ' MIM constant definitions')"/>
      </A>
    </p>
    <xsl:apply-templates 
      select="document($arm_xml)/express/schema/constant" mode="contents"/>
  </xsl:if>          
  <!-- only output if there are imported constants defined and 
       therefore a section -->
  <xsl:variable name="imported_constant_mim_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'imported_constant'"/>
      <xsl:with-param name="schema_name" select="$mim_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$imported_constant_mim_clause != 0">
    <p class="content">
      <A HREF="./5_mim{$FILE_EXT}#imported_constant">
        <xsl:value-of select="concat('&#160; &#160; &#160;', 
                              $imported_constant_mim_clause,
                              ' MIM imported constant modifications')"/>
      </A>
    </p>
  </xsl:if>
  
  
  <!-- only output if there are types defined and therefore a
       section -->
  <xsl:variable name="type_mim_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'type'"/>
      <xsl:with-param name="schema_name" select="$mim_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$type_mim_clause != 0">
    <p class="content">
      <A HREF="./5_mim{$FILE_EXT}#types">
        <xsl:value-of select="concat('&#160; &#160; &#160;', $type_mim_clause,
                              ' MIM type definitions')"/>
      </A>
    </p>
    <xsl:apply-templates 
      select="document($mim_xml)/express/schema/type" mode="contents"/>
  </xsl:if>          
  <!-- only output if there are imported types defined and 
       therefore a section -->
  <xsl:variable name="imported_mim_type_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'imported_type'"/>
      <xsl:with-param name="schema_name" select="$mim_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$imported_mim_type_clause != 0">
    <p class="content">
      <A HREF="./5_mim{$FILE_EXT}#imported_type">
        <xsl:value-of select="concat('&#160; &#160; &#160;', 
                              $imported_mim_type_clause,
                              ' MIM imported type modifications')"/>
      </A>
    </p>
  </xsl:if>
  
  <!-- only output if there are entitys defined and therefore a
       section -->
  <xsl:variable name="entity_mim_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'entity'"/>
      <xsl:with-param name="schema_name" select="$mim_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$entity_mim_clause != 0">
    <p class="content">
      <A HREF="./5_mim{$FILE_EXT}#entities">
        <xsl:value-of select="concat('&#160; &#160; &#160;', $entity_mim_clause,
                              ' MIM entity definitions')"/>
      </A>
    </p>
    <xsl:apply-templates 
      select="document($mim_xml)/express/schema/entity" mode="contents"/>
  </xsl:if>          
  
  <!-- only output if there are imported entitys defined and 
       therefore a section -->
  <xsl:variable name="imported_mim_entity_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'imported_entity'"/>
      <xsl:with-param name="schema_name" select="$mim_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$imported_mim_entity_clause != 0">
    <p class="content">
      <A HREF="./5_mim{$FILE_EXT}#imported_entity">
        <xsl:value-of select="concat('&#160; &#160; &#160;', 
                              $imported_mim_entity_clause,
                              ' MIM imported entity modifications')"/>
      </A>
    </p>
  </xsl:if>
  
  
  <!-- only output if there are functions defined and therefore a
       section -->
  <xsl:variable name="function_mim_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'function'"/>
      <xsl:with-param name="schema_name" select="$mim_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$function_mim_clause != 0">
    <p class="content">
      <A HREF="./5_mim{$FILE_EXT}#functions">
        <xsl:value-of select="concat('&#160; &#160; &#160;', $function_mim_clause,
                              ' MIM function definitions')"/>
      </A>
    </p>
  </xsl:if>          
  <!-- only output if there are imported functions defined and 
       therefore a section -->
  <xsl:variable name="imported_mim_function_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'imported_function'"/>
      <xsl:with-param name="schema_name" select="$mim_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$imported_mim_function_clause != 0">
    <p class="content">
      <A HREF="./5_mim{$FILE_EXT}#imported_function">
        <xsl:value-of select="concat('&#160; &#160; &#160;', 
                              $imported_mim_function_clause,
                              ' MIM imported function modifications')"/>
      </A>
    </p>
  </xsl:if>
  
  
  <!-- only output if there are rules defined and therefore a
       section -->
  <xsl:variable name="rule_mim_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'rule'"/>
      <xsl:with-param name="schema_name" select="$mim_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$rule_mim_clause != 0">
    <p class="content">
      <A HREF="./5_mim{$FILE_EXT}#rules">
        <xsl:value-of select="concat('&#160; &#160; &#160;', $rule_mim_clause,
                              ' MIM rule definitions')"/>
      </A>
    </p>
  </xsl:if>          
  <!-- only output if there are imported rules defined and 
       therefore a section -->
  <xsl:variable name="imported_mim_rule_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'imported_rule'"/>
      <xsl:with-param name="schema_name" select="$mim_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$imported_mim_rule_clause != 0">
    <p class="content">
      <A HREF="./5_mim{$FILE_EXT}#imported_rule">
        <xsl:value-of select="concat('&#160; &#160; &#160;', 
                              $imported_mim_rule_clause,
                              ' MIM imported rule modifications')"/>
      </A>
    </p>
  </xsl:if>
  
  <!-- only output if there are procedures defined and therefore a
       section -->
  <xsl:variable name="procedure_mim_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'procedure'"/>
      <xsl:with-param name="schema_name" select="$mim_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$procedure_mim_clause != 0">
    <p class="content">
      <A HREF="./5_mim{$FILE_EXT}#procedures">
        <xsl:value-of select="concat('&#160; &#160; &#160;', $procedure_mim_clause,
                              ' MIM procedure definitions')"/>
      </A>
    </p>
  </xsl:if>          
  <!-- only output if there are imported procedures defined and 
       therefore a section -->
  <xsl:variable name="imported_mim_procedure_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'imported_procedure'"/>
      <xsl:with-param name="schema_name" select="$mim_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$imported_mim_procedure_clause != 0">
    <p class="content">
      <A HREF="./5_mim{$FILE_EXT}#imported_procedure">
        <xsl:value-of select="concat('&#160; &#160; &#160;', 
                              $imported_mim_procedure_clause,
                              ' MIM imported procedure modifications')"/>
      </A>
    </p>
  </xsl:if>
  
  <!-- use #annexa to link direct -->
  <p class="content">
    <A HREF="./a_short_names{$FILE_EXT}">A AM MIM
    short names</A>
  </p>
  <!-- use #annexb to link direct -->
  <p class="content">
    <A HREF="./b_obj_reg{$FILE_EXT}">B Information requirements object
    registration</A>
  </p>
  
  <!-- use #annexc to link direct -->
  <p class="content">
    <A HREF="./c_arm_expg{$FILE_EXT}">C ARM EXPRESS-G</A>
  </p>
  
  <!-- use #annexd to link direct -->
  <p class="content">
    <A HREF="./d_mim_expg{$FILE_EXT}">D MIM EXPRESS-G</A>
  </p>
  
  <!-- use #annexe to link direct -->
  <p class="content">
    <A HREF="./e_exp{$FILE_EXT}">E AM ARM and MIM EXPRESS
    listings</A>
  </p>
  <xsl:if test="./usage_guide">
    <!-- use #annexa to link direct -->
    <p class="content">
      <A HREF="./f_guide{$FILE_EXT}">
        F Application module implementation and usage guide
      </A>
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
        <xsl:value-of select="concat('./5_mim',$FILE_EXT,'#',$aname)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <p class="content">
    <A HREF="{$xref}">
      <xsl:value-of select="concat('&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;',$clause_number, '.', position(), ' ', @name)"/>
    </A>
  </p>
</xsl:template>

<xsl:template match="module" mode="contents_figures">
  <h3>Figures</h3>
  <!-- collect up the figures from the Module -->
  
  <!-- collect up the figures from the ARM -->
  <xsl:apply-templates 
    select="./arm/express-g/imgfile" mode="expressg_figure"/>
  <!-- collect up the figures from the MIM -->
  <xsl:apply-templates 
    select="./mim/express-g/imgfile" mode="expressg_figure"/>
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
      <xsl:when test="name(../..)='mim'">
        <xsl:choose>
          <xsl:when test="$number=1">
            <xsl:value-of 
              select="concat('Figure D.',$number, 
                      ' - MIM Schema level EXPRESS-G diagram ',$number)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of 
              select="concat('Figure D.',$number, 
                      ' - MIM Entity level EXPRESS-G diagram ',($number - 1))"/>
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


<xsl:template match="module" mode="contents_tables">
  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="arm_xml" select="concat($module_dir,'/arm.xml')"/>
  <xsl:variable name="arm_desc_xml" select="document($arm_xml)/express/@description.file"/>
  <xsl:variable name="mim_xml" select="concat($module_dir,'/mim.xml')"/>
  <xsl:variable name="mim_desc_xml" select="document($mim_xml)/express/@description.file"/>
  <h3>Tables</h3>
  <!-- collect up the mapping tables -->
  <xsl:apply-templates select="*//table" mode="toc"/>
  <xsl:choose>
    <xsl:when test="$arm_desc_xml">
      <xsl:apply-templates select="document($arm_desc_xml)//table" mode="toc"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="document($arm_xml)//table" mode="toc"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:choose>
    <xsl:when test="$mim_desc_xml">
      <xsl:apply-templates select="document($mim_desc_xml)//table" mode="toc"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="document($mim_xml)//table" mode="toc"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates select="./mapping_table/ae" mode="toc"/>
</xsl:template>


<xsl:template match="table" mode="toc">
  <xsl:variable name="file">
    
  </xsl:variable>
  <xsl:variable name="href">
    <xsl:call-template name="table_href">
      <xsl:with-param name="table" select="."/>
    </xsl:call-template>
  </xsl:variable>

  <p class="content">
    <a href="{$href}">
      Table 
      <xsl:value-of select="@number"/> &#8212; <xsl:value-of
select="@caption"/>
    </a>
  </p>

</xsl:template>

<xsl:template match="ae" mode="toc">
  <xsl:variable name="sect_no">
    <xsl:number/>
  </xsl:variable>
  <xsl:variable name="aname" select="@entity"/>
  <a href="#{$aname}">
    <xsl:value-of select="concat('Table ', $sect_no,'  &#8212; ',$aname)"/> 
  </a>
  <br/>
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

</xsl:stylesheet>