<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: module_toc.xsl,v 1.43 2006/05/18 16:17:23 dmprice Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     Templates that are common to most other stylesheets
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">


<!--
     Output the Table of contents banner for a module where all clauses are 
     displayed on separate pages
-->
<xsl:template match="module" mode="TOCmultiplePage">
  <!-- the entry that has been selected -->
  <xsl:param name="selected"/>
  <xsl:param name="module_root" select="'..'"/>
  <xsl:apply-templates select="." mode="TOCbannertitle">
    <xsl:with-param name="module_root" select="$module_root"/>
  </xsl:apply-templates>

  <xsl:apply-templates select="." mode="test_module_name"/>


  <xsl:variable name="arm_schema_name" select="concat(@name,'_arm')"/>
  <xsl:variable name="mim_schema_name" select="concat(@name,'_mim')"/>
  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="/module/@name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="arm_schema_xml"
    select="document(concat($module_dir,'/arm.xml'))/express/schema"/>
  <xsl:variable name="mim_schema_xml" 
    select="document(concat($module_dir,'/mim.xml'))/express/schema"/>
  

  <TABLE border="1" cellspacing="1" width="100%">
    <TR>
      <TD valign="TOP">
        <p class="toc">
          <A HREF="{$module_root}/sys/cover{$FILE_EXT}">Cover page</A><BR/>
          <A HREF="{$module_root}/sys/contents{$FILE_EXT}">Table of contents</A><BR/>
                    <A HREF="{$module_root}/sys/cover{$FILE_EXT}#copyright">Copyright</A><BR/>
        
          <!-- use #foreword to link direct -->
          <A HREF="{$module_root}/sys/foreword{$FILE_EXT}">Foreword</A><BR/>

          <!-- use #intro to link direct -->
          <A HREF="{$module_root}/sys/introduction{$FILE_EXT}">Introduction</A><BR/>
          
          <!-- use #scope to link direct -->
          <A HREF="{$module_root}/sys/1_scope{$FILE_EXT}">1 Scope</A><BR/>
          
          <!-- use #nref to link direct -->
          <A HREF="{$module_root}/sys/2_refs{$FILE_EXT}">2 Normative references</A><BR/>


        <!-- Assumption that every module use a set of terms and
             abbreviations from the normref.inc so only check for local
             definitions aka terms -->
        <xsl:choose>
          <xsl:when test="./definition/term">
            <!-- use #defns to link direct -->
            <A HREF="{$module_root}/sys/3_defs{$FILE_EXT}">
              3 Terms, definitions and abbreviations
            </A>
          </xsl:when>
          <xsl:otherwise>
            <!-- use #defns to link direct -->
            <A HREF="{$module_root}/sys/3_defs{$FILE_EXT}">
              <!-- every module references Terms defined in other standards,
                   and abbreviations hence as per ISO -->
              3 Terms, definitions and abbreviations
            </A>            
          </xsl:otherwise>
        </xsl:choose>
      </p>
      </TD>
      <TD valign="TOP">
        <p class="toc">
        <!-- Output Section 4. Only set up the index to express clauses that
             exist. 
             use #ARM to link direct 
             -->
        <A HREF="{$module_root}/sys/4_info_reqs{$FILE_EXT}">4 Information requirements</A><BR/>
        <small>
          <!-- no longer have units of functionality
          &#160;&#160;<A HREF="{$module_root}/sys/4_info_reqs{$FILE_EXT}#uof">
            4.1 Unit of functionality
          </A><BR/>
          -->

          <!-- only output if there are interfaces defined and therefore a
               section -->
          <xsl:variable name="interface_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'interface'"/>
              <xsl:with-param name="schema_name" select="$arm_schema_name"/>
            </xsl:call-template>
          </xsl:variable>

          <xsl:if test="normalize-space($interface_clause) != '0'">
          <xsl:choose>
            <xsl:when test="count($arm_schema_xml/interface)>1">          
              &#160; &#160;<A HREF="{$module_root}/sys/4_info_reqs{$FILE_EXT}#interfaces">
              <xsl:value-of select="concat($interface_clause,
                                    ' Required AM ARMs')"/>
            </A><BR/>
            </xsl:when>
            <xsl:otherwise>
              &#160; &#160;<A HREF="{$module_root}/sys/4_info_reqs{$FILE_EXT}#interfaces">
              <xsl:value-of select="concat($interface_clause,
                                    ' Required AM ARM')"/>
            </A><BR/>              
            </xsl:otherwise>
          </xsl:choose>
          </xsl:if>
          
          <!-- only output if there are constants defined and therefore a
               section -->
          <xsl:variable name="constant_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'constant'"/>
              <xsl:with-param name="schema_name" select="$arm_schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="normalize-space($constant_clause) != '0'">
            <xsl:choose>
              <xsl:when test="count($arm_schema_xml/constant)>1">
                &#160; &#160;<A HREF="{$module_root}/sys/4_info_reqs{$FILE_EXT}#constants">
                <xsl:value-of select="concat($constant_clause,
                                      ' ARM constant definitions')"/>
              </A><BR/>
              </xsl:when>
              <xsl:otherwise>
                &#160; &#160;<A HREF="{$module_root}/sys/4_info_reqs{$FILE_EXT}#constants">
                <xsl:value-of select="concat($constant_clause,
                                      ' ARM constant definition')"/>
              </A><BR/>              
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>

          <!-- only output if there are imported constants defined and 
               therefore a section -->
          <xsl:variable name="imported_constant_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'imported_constant'"/>
              <xsl:with-param name="schema_name" select="$arm_schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="normalize-space($imported_constant_clause) != '0'">
            &#160; &#160;<A HREF="{$module_root}/sys/4_info_reqs{$FILE_EXT}#imported_constant">
              <xsl:value-of select="concat($imported_constant_clause,
                                    ' ARM imported constant modifications')"/>
            </A><BR/>
          </xsl:if>


          <!-- only output if there are types defined and therefore a
               section -->
          <xsl:variable name="type_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'type'"/>
              <xsl:with-param name="schema_name" select="$arm_schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="normalize-space($type_clause) != '0'">
            <xsl:choose>
              <xsl:when test="count($arm_schema_xml/type)>1">
                &#160; &#160;<A HREF="{$module_root}/sys/4_info_reqs{$FILE_EXT}#types">
                <xsl:value-of select="concat($type_clause,
                                      ' ARM type definitions')"/>
              </A><BR/>
              </xsl:when>
              <xsl:otherwise>
                &#160; &#160;<A HREF="{$module_root}/sys/4_info_reqs{$FILE_EXT}#types">
                <xsl:value-of select="concat($type_clause,
                                      ' ARM type definition')"/>
              </A><BR/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>

          <!-- only output if there are imported types defined and 
               therefore a section -->
          <xsl:variable name="imported_type_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'imported_type'"/>
              <xsl:with-param name="schema_name" select="$arm_schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="normalize-space($imported_type_clause) != '0'">
            &#160; &#160;<A HREF="{$module_root}/sys/4_info_reqs{$FILE_EXT}#imported_type">
              <xsl:value-of select="concat($imported_type_clause,
                                    ' ARM imported type modifications')"/>
            </A><BR/>
          </xsl:if>


          <!-- only output if there are entitys defined and therefore a
               section -->
          <xsl:variable name="entity_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'entity'"/>
              <xsl:with-param name="schema_name" select="$arm_schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="normalize-space($entity_clause) != '0'">
            <xsl:choose>
              <xsl:when test="count($arm_schema_xml/entity)>1">
                &#160; &#160;<A HREF="{$module_root}/sys/4_info_reqs{$FILE_EXT}#entities">
                <xsl:value-of select="concat($entity_clause,
                                      ' ARM entity definitions')"/>
              </A><BR/>
              </xsl:when>
              <xsl:otherwise>
                &#160; &#160;<A HREF="{$module_root}/sys/4_info_reqs{$FILE_EXT}#entities">
              <xsl:value-of select="concat($entity_clause,
                                    ' ARM entity definition')"/>
            </A><BR/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>

         
          <!-- only output if there are imported entitys defined and 
               therefore a section -->
          <xsl:variable name="imported_entity_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'imported_entity'"/>
              <xsl:with-param name="schema_name" select="$arm_schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="normalize-space($imported_entity_clause) != '0'">
            &#160; &#160;
            <A HREF="{$module_root}/sys/4_info_reqs{$FILE_EXT}#imported_entity">
              <xsl:value-of select="concat($imported_entity_clause,
                                    ' ARM imported entity modifications')"/>
            </A><BR/>
          </xsl:if>


          <!-- only output if there are subtype.constraint defined and 
               therefore a section -->
          <xsl:variable name="subtype_constraint_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'subtype.constraint'"/>
              <xsl:with-param name="schema_name" select="$arm_schema_name"/>
            </xsl:call-template>
          </xsl:variable>          
          <xsl:if test="normalize-space($subtype_constraint_clause) != '0'">
            <xsl:choose>
              <xsl:when test="count($arm_schema_xml/subtype.constraint)>1">
                &#160; &#160;<A HREF="{$module_root}/sys/4_info_reqs{$FILE_EXT}#subtype_constraints">
                <xsl:value-of select="concat($subtype_constraint_clause,
                                      ' ARM subtype constraint definitions')"/>
              </A><BR/>
              </xsl:when>
              <xsl:otherwise>
                &#160; &#160;<A HREF="{$module_root}/sys/4_info_reqs{$FILE_EXT}#subtype_constraints">
                <xsl:value-of select="concat($subtype_constraint_clause,
                                      ' ARM subtype constraint definition')"/>
              </A><BR/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>

          <!-- only output if there are functions defined and therefore a
               section -->
          <xsl:variable name="function_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'function'"/>
              <xsl:with-param name="schema_name" select="$arm_schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="normalize-space($function_clause) !=0">
            <xsl:choose>
              <xsl:when test="count($arm_schema_xml/function)>1">
                &#160; &#160;<A HREF="{$module_root}/sys/4_info_reqs{$FILE_EXT}#functions">
                <xsl:value-of select="concat($function_clause,
                                      ' ARM function definitions')"/>
              </A><BR/>
              </xsl:when>
              <xsl:otherwise>
                &#160; &#160;<A HREF="{$module_root}/sys/4_info_reqs{$FILE_EXT}#functions">
                <xsl:value-of select="concat($function_clause,
                                      ' ARM function definition')"/>
              </A><BR/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
          <!-- only output if there are imported functions defined and 
               therefore a section -->
          <xsl:variable name="imported_function_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'imported_function'"/>
              <xsl:with-param name="schema_name" select="$arm_schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="normalize-space($imported_function_clause) != '0'">
            &#160; &#160;<A HREF="{$module_root}/sys/4_info_reqs{$FILE_EXT}#imported_function">
              <xsl:value-of select="concat($imported_function_clause,
                                    ' ARM imported function modifications')"/>
            </A><BR/>
          </xsl:if>

          <!-- only output if there are rules defined and therefore a
               section -->
          <xsl:variable name="rule_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'rule'"/>
              <xsl:with-param name="schema_name" select="$arm_schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="normalize-space($rule_clause) !=0">
            <xsl:choose>
              <xsl:when test="count($arm_schema_xml/rule)>1">
                &#160; &#160;<A HREF="{$module_root}/sys/4_info_reqs{$FILE_EXT}#rules">
                <xsl:value-of select="concat($rule_clause,
                                      ' ARM rule definitions')"/>
              </A><BR/>
              </xsl:when>
              <xsl:otherwise>
                &#160; &#160;<A HREF="{$module_root}/sys/4_info_reqs{$FILE_EXT}#rules">
                <xsl:value-of select="concat($rule_clause,
                                      ' ARM rule definition')"/>
              </A><BR/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
          <!-- only output if there are imported rules defined and 
               therefore a section -->
          <xsl:variable name="imported_rule_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'imported_rule'"/>
              <xsl:with-param name="schema_name" select="$arm_schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="normalize-space($imported_rule_clause) != '0'">
            &#160; &#160;<A HREF="{$module_root}/sys/4_info_reqs{$FILE_EXT}#imported_rule">
              <xsl:value-of select="concat($imported_rule_clause,
                                    ' ARM imported rule modifications')"/>
            </A><BR/>
          </xsl:if>

          <!-- only output if there are procedures defined and therefore a
               section -->
          <xsl:variable name="procedure_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'procedure'"/>
              <xsl:with-param name="schema_name" select="$arm_schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="normalize-space($procedure_clause) != '0'">
            <xsl:choose>
              <xsl:when test="count($arm_schema_xml/procedure)>1">
                &#160; &#160;<A HREF="{$module_root}/sys/4_info_reqs{$FILE_EXT}#procedures">
                <xsl:value-of select="concat($procedure_clause,
                                      ' ARM procedure definitions')"/>
              </A><BR/>
              </xsl:when>
              <xsl:otherwise>
                &#160; &#160;<A HREF="{$module_root}/sys/4_info_reqs{$FILE_EXT}#procedures">
                <xsl:value-of select="concat($procedure_clause,
                                      ' ARM procedure definition')"/>
              </A><BR/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
          <!-- only output if there are imported procedures defined and 
               therefore a section -->
          <xsl:variable name="imported_procedure_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'imported_procedure'"/>
              <xsl:with-param name="schema_name" select="$arm_schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="normalize-space($imported_procedure_clause) != '0'">
            &#160; &#160;<A HREF="{$module_root}/sys/4_info_reqs{$FILE_EXT}#imported_procedure">
              <xsl:value-of select="concat($imported_procedure_clause,
                                    ' ARM imported procedure modifications')"/>
            </A><BR/>
          </xsl:if>

        </small>

        <!-- Output clause 5 index -->
        <!-- use #mim to link direct -->
        <A HREF="{$module_root}/sys/5_main{$FILE_EXT}">5 Module interpreted model</A><BR/>
        <small>
          &#160; &#160;<A HREF="{$module_root}/sys/5_mapping{$FILE_EXT}#mapping">5.1 Mapping specification</A><BR/>
        &#160; &#160;<A HREF="{$module_root}/sys/5_mim{$FILE_EXT}#mim_express">5.2 MIM EXPRESS short listing</A><BR/>
          <!-- only output if there are constants defined and therefore a
               section -->
          <xsl:variable name="constant_mim_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'constant'"/>
              <xsl:with-param name="schema_name" select="$mim_schema_name"/>
            </xsl:call-template>
          </xsl:variable>

          <xsl:if test="normalize-space($constant_mim_clause) != '0'">
            <xsl:choose>
              <xsl:when test="count($mim_schema_xml/constant)>1">
                &#160; &#160; &#160;<A HREF="{$module_root}/sys/5_mim{$FILE_EXT}#constants">
                <xsl:value-of select="concat($constant_mim_clause,
                                      ' MIM constant definitions')"/>
              </A><BR/>
              </xsl:when>
              <xsl:otherwise>
                &#160; &#160; &#160;<A HREF="{$module_root}/sys/5_mim{$FILE_EXT}#constants">
                <xsl:value-of select="concat($constant_mim_clause,
                                      ' MIM constant definition')"/>
              </A><BR/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>          
          <!-- only output if there are imported constants defined and 
               therefore a section -->
          <xsl:variable name="imported_constant_mim_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'imported_constant'"/>
              <xsl:with-param name="schema_name" select="$mim_schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="normalize-space($imported_constant_mim_clause) != '0'">
            &#160; &#160; &#160;<A HREF="{$module_root}/sys/5_mim{$FILE_EXT}#imported_constant">
              <xsl:value-of select="concat($imported_constant_mim_clause,
                                    ' MIM imported constant modifications')"/>
            </A><BR/>
          </xsl:if>


          <!-- only output if there are types defined and therefore a
               section -->
          <xsl:variable name="type_mim_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'type'"/>
              <xsl:with-param name="schema_name" select="$mim_schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="normalize-space($type_mim_clause) != '0'">
            <xsl:choose>
              <xsl:when test="count($mim_schema_xml/type)>1">
                &#160; &#160; &#160;<A HREF="{$module_root}/sys/5_mim{$FILE_EXT}#types">
                <xsl:value-of select="concat($type_mim_clause,
                                      ' MIM type definitions')"/>
              </A><BR/>
              </xsl:when>
              <xsl:otherwise>
                &#160; &#160; &#160;<A HREF="{$module_root}/sys/5_mim{$FILE_EXT}#types">
                <xsl:value-of select="concat($type_mim_clause,
                                      ' MIM type definition')"/>
              </A><BR/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>          
          <!-- only output if there are imported types defined and 
               therefore a section -->
          <xsl:variable name="imported_mim_type_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'imported_type'"/>
              <xsl:with-param name="schema_name" select="$mim_schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="normalize-space($imported_mim_type_clause) != '0'">
            &#160; &#160; &#160;<A HREF="{$module_root}/sys/5_mim{$FILE_EXT}#imported_type">
              <xsl:value-of select="concat($imported_mim_type_clause,
                                    ' MIM imported type modifications')"/>
            </A><BR/>
          </xsl:if>

          <!-- only output if there are entitys defined and therefore a
               section -->
          <xsl:variable name="entity_mim_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'entity'"/>
              <xsl:with-param name="schema_name" select="$mim_schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="normalize-space($entity_mim_clause) != '0'">
            <xsl:choose>
              <xsl:when test="count($mim_schema_xml/entity)>1">
                &#160; &#160; &#160;<A HREF="{$module_root}/sys/5_mim{$FILE_EXT}#entities">
                <xsl:value-of select="concat($entity_mim_clause,
                                      ' MIM entity definitions')"/>
              </A><BR/>
              </xsl:when>
              <xsl:otherwise>
                &#160; &#160; &#160;<A HREF="{$module_root}/sys/5_mim{$FILE_EXT}#entities">
                <xsl:value-of select="concat($entity_mim_clause,
                                      ' MIM entity definition')"/>
              </A><BR/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>          

          <!-- only output if there are imported entitys defined and 
               therefore a section -->
          <xsl:variable name="imported_mim_entity_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'imported_entity'"/>
              <xsl:with-param name="schema_name" select="$mim_schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="normalize-space($imported_mim_entity_clause) != '0'">
            &#160; &#160; &#160;<A HREF="{$module_root}/sys/5_mim{$FILE_EXT}#imported_entity">
              <xsl:value-of select="concat($imported_mim_entity_clause,
                                    ' MIM imported entity modifications')"/>
            </A><BR/>
          </xsl:if>
          

          <!-- only output if there are subtype.constraint defined and 
               therefore a section -->
          <xsl:variable name="subtype_constraint_mim_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'subtype.constraint'"/>
              <xsl:with-param name="schema_name" select="$mim_schema_name"/>
            </xsl:call-template>
          </xsl:variable>          
          <xsl:if test="normalize-space($subtype_constraint_mim_clause) != '0'">
            <xsl:choose>
              <xsl:when test="count($mim_schema_xml/subtype.constraint)>1">
                &#160; &#160; &#160;<A HREF="{$module_root}/sys/5_mim{$FILE_EXT}#subtype_constraints">
                <xsl:value-of select="concat($subtype_constraint_mim_clause,
                                      ' MIM subtype constraint definitions')"/>
              </A><BR/>
              </xsl:when>
              <xsl:otherwise>
                &#160; &#160; &#160;<A HREF="{$module_root}/sys/5_mim{$FILE_EXT}#subtype_constraints">
                <xsl:value-of select="concat($subtype_constraint_mim_clause,
                                      ' MIM subtype constraint definition')"/>
              </A><BR/>
            </xsl:otherwise>
            </xsl:choose>
          </xsl:if>


          <!-- only output if there are functions defined and therefore a
               section -->
          <xsl:variable name="function_mim_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'function'"/>
              <xsl:with-param name="schema_name" select="$mim_schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="normalize-space($function_mim_clause) != '0'">
            <xsl:choose>
              <xsl:when test="count($mim_schema_xml/function)>1">
                &#160; &#160; &#160;<A HREF="{$module_root}/sys/5_mim{$FILE_EXT}#functions">
                <xsl:value-of select="concat($function_mim_clause,
                                      ' MIM function definitions')"/>
              </A><BR/>
              </xsl:when>
              <xsl:otherwise>
                &#160; &#160; &#160;<A HREF="{$module_root}/sys/5_mim{$FILE_EXT}#functions">
                <xsl:value-of select="concat($function_mim_clause,
                                      ' MIM function definition')"/>
              </A><BR/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>          
          <!-- only output if there are imported functions defined and 
               therefore a section -->
          <xsl:variable name="imported_mim_function_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'imported_function'"/>
              <xsl:with-param name="schema_name" select="$mim_schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="normalize-space($imported_mim_function_clause) != '0'">
            &#160; &#160; &#160;<A HREF="{$module_root}/sys/5_mim{$FILE_EXT}#imported_function">
              <xsl:value-of select="concat($imported_mim_function_clause,
                                    ' MIM imported function modifications')"/>
            </A><BR/>
          </xsl:if>



          <!-- only output if there are rules defined and therefore a
               section -->
          <xsl:variable name="rule_mim_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'rule'"/>
              <xsl:with-param name="schema_name" select="$mim_schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="normalize-space($rule_mim_clause) != '0'">
            <xsl:choose>
              <xsl:when test="count($mim_schema_xml/rule)>1">
                &#160; &#160; &#160;<A HREF="{$module_root}/sys/5_mim{$FILE_EXT}#rules">
                <xsl:value-of select="concat($rule_mim_clause,
                                      ' MIM rule definitions')"/>
              </A><BR/>
              </xsl:when>
              <xsl:otherwise>
                &#160; &#160; &#160;<A HREF="{$module_root}/sys/5_mim{$FILE_EXT}#rules">
                <xsl:value-of select="concat($rule_mim_clause,
                                      ' MIM rule definition')"/>
              </A><BR/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>          
          <!-- only output if there are imported rules defined and 
               therefore a section -->
          <xsl:variable name="imported_mim_rule_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'imported_rule'"/>
              <xsl:with-param name="schema_name" select="$mim_schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="normalize-space($imported_mim_rule_clause) != '0'">
            &#160; &#160; &#160;<A HREF="{$module_root}/sys/5_mim{$FILE_EXT}#imported_rule">
              <xsl:value-of select="concat($imported_mim_rule_clause,
                                    ' MIM imported rule modifications')"/>
            </A><BR/>
          </xsl:if>

          <!-- only output if there are procedures defined and therefore a
               section -->
          <xsl:variable name="procedure_mim_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'procedure'"/>
              <xsl:with-param name="schema_name" select="$mim_schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="normalize-space($procedure_mim_clause) != '0'">
            <xsl:choose>
              <xsl:when test="count($mim_schema_xml/procedure)>1">
                &#160; &#160; &#160;<A HREF="{$module_root}/sys/5_mim{$FILE_EXT}#procedures">
                <xsl:value-of select="concat($procedure_mim_clause,
                                      ' MIM procedure definitions')"/>
              </A><BR/>
              </xsl:when>
              <xsl:otherwise>
                &#160; &#160; &#160;<A HREF="{$module_root}/sys/5_mim{$FILE_EXT}#procedures">
                <xsl:value-of select="concat($procedure_mim_clause,
                                      ' MIM procedure definition')"/>
            </A><BR/>
              </xsl:otherwise>
            </xsl:choose>            
          </xsl:if>          
          <!-- only output if there are imported procedures defined and 
               therefore a section -->
          <xsl:variable name="imported_mim_procedure_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'imported_procedure'"/>
              <xsl:with-param name="schema_name" select="$mim_schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="normalize-space($imported_mim_procedure_clause) != '0'">
            &#160; &#160; &#160;<A HREF="{$module_root}/sys/5_mim{$FILE_EXT}#imported_procedure">
              <xsl:value-of select="concat($imported_mim_procedure_clause,
                                    ' MIM imported procedure modifications')"/>
            </A><BR/>
          </xsl:if>

 					

        </small>
				       <xsl:if test="./refdata">
        <!-- use #annexa to link direct -->
          <A HREF="{$module_root}/sys/6_refdata{$FILE_EXT}">
            6 Module reference data</A><BR/>
        </xsl:if>

      </p>
      </TD>
      <TD valign="TOP">
        <p class="toc">
        <!-- use #annexa to link direct -->
        <A HREF="{$module_root}/sys/a_short_names{$FILE_EXT}">A MIM short names</A><BR/>
        <!-- use #annexb to link direct -->
        <A HREF="{$module_root}/sys/b_obj_reg{$FILE_EXT}">B Information object
        registration</A><BR/>
        <!-- use #annexc to link direct -->
        <A HREF="{$module_root}/sys/c_arm_expg{$FILE_EXT}">
          C ARM EXPRESS-G
        </A>
        <!-- This will output links to the ExpresG diagrams (1 2) 
             not however allowed in ISO 
        <xsl:apply-templates select="arm/express-g/imgfile" mode="page_number">
          <xsl:with-param name="module_root" select="$module_root"/>
        </xsl:apply-templates>
        -->
        <xsl:call-template name="expressg_icon">
          <xsl:with-param name="schema" select="concat(./@name,'_arm')"/>
          <xsl:with-param name="module_root" select="$module_root"/>
        </xsl:call-template>
        <br/>

        <!-- use #annexd to link direct -->
        <A HREF="{$module_root}/sys/d_mim_expg{$FILE_EXT}">
          D MIM EXPRESS-G
        </A>
        <!-- This will output links to the ExpresG diagrams (1 2) 
             not however allowed in ISO 
             <xsl:apply-templates select="mim/express-g/imgfile" mode="page_number">
               <xsl:with-param name="module_root" select="$module_root"/>
             </xsl:apply-templates>
           -->
        <xsl:call-template name="expressg_icon">
          <xsl:with-param name="schema" select="concat(./@name,'_mim')"/>
          <xsl:with-param name="module_root" select="$module_root"/>
        </xsl:call-template>
        <BR/>

        <!-- use #annexe to link direct -->
        <A HREF="{$module_root}/sys/e_exp{$FILE_EXT}">E Computer interpretable listings</A><BR/>
        <xsl:if test="./usage_guide">
        <!-- use #annexa to link direct -->
          <A HREF="{$module_root}/sys/f_guide{$FILE_EXT}">
            F Application module implementation and usage guide</A><BR/>
        </xsl:if>
        <A HREF="{$module_root}/sys/biblio{$FILE_EXT}#bibliography">Bibliography</A><BR/>
        <A HREF="{$module_root}/sys/modindex{$FILE_EXT}">Index</A><BR/>
      </p>
      </TD>
    </TR>
  </TABLE>
</xsl:template>

<!--
     Output the Table of contents banner for a module where all clauses are 
     displayed on a single page
-->
<xsl:template match="module" mode="TOCsinglePage">
  <xsl:param name="module_root" select="'..'"/>
  <xsl:apply-templates select="." mode="TOCbannertitle">
    <xsl:with-param name="module_root" select="$module_root"/>
  </xsl:apply-templates>
  <TABLE border="1" cellspacing="1" width="100%">
    <TR>
      <TD valign="TOP">
        <A HREF="{$module_root}/sys/module{$FILE_EXT}#cover_page">Cover page</A><BR/>
        <A HREF="{$module_root}/sys/module{$FILE_EXT}#foreword">Foreword</A><BR/>
        <A HREF="{$module_root}/sys/module{$FILE_EXT}#intro">Introduction</A><BR/>
        <A HREF="{$module_root}/sys/module{$FILE_EXT}#scope">1 Scope</A><BR/>
        <A HREF="{$module_root}/sys/module{$FILE_EXT}#nref">2 Normative references</A><BR/>
        <A HREF="{$module_root}/sys/module{$FILE_EXT}#defns">3 Definitions and abbreviations</A>
      </TD>
      <TD valign="TOP">
        <A HREF="{$module_root}/sys/module{$FILE_EXT}#arm">4 Information requirements</A><BR/>
        <A HREF="{$module_root}/sys/module{$FILE_EXT}#mim">5 Module interpreted model</A><BR/>
        <A HREF="{$module_root}/sys/module{$FILE_EXT}#annexa">A MIM short names</A><BR/>
        <A HREF="{$module_root}/sys/module{$FILE_EXT}#annexb">B Information object registration</A><BR/>
        <A HREF="{$module_root}/sys/module{$FILE_EXT}#annexc">C ARM EXPRESS-G</A><BR/>
        <A HREF="{$module_root}/sys/module{$FILE_EXT}#annexd">D MIM EXPRESS-G</A>
      </TD>
      <TD valign="TOP">
        <A HREF="{$module_root}/sys/module{$FILE_EXT}#annexe">E Computer interpretable listings</A><BR/>
        <xsl:if test="./usage_guide">
          <!-- use #annexf to link direct -->
          <A HREF="{$module_root}/sys/module{$FILE_EXT}">
            F Application module implementation and usage guide</A><BR/>
        </xsl:if>
        <!-- use #biblio to link direct -->
        <A HREF="{$module_root}/sys/module{$FILE_EXT}">Bibliography</A>
      </TD>
    </TR>
  </TABLE>
</xsl:template>


<xsl:template match="module" mode="test_module_name">
  <xsl:variable name="test">
    <xsl:call-template name="check_all_lower_case">
      <xsl:with-param name="str" select="@name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$test = -1">
    <xsl:call-template name="error_message">
      <xsl:with-param 
        name="message" 
        select="concat('Error m1: the module name ',@name,' is incorrectly
                named in module.xml &lt;module name=&quot;',@name,'&quot;. Should be all lower case')"/>
    </xsl:call-template>    
  </xsl:if>
</xsl:template>



<xsl:template match="imgfile" mode="page_number">
  <xsl:param name="module_root" select="'..'"/>

  <xsl:variable name="href">
    <xsl:call-template name="set_file_ext">
      <xsl:with-param name="filename" select="concat($module_root,'/',@file)"/>
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
