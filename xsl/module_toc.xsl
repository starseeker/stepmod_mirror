<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: module_toc.xsl,v 1.10 2002/05/13 16:54:08 robbod Exp $
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
  <xsl:apply-templates select="." mode="TOCbannertitle"/>  
  <xsl:variable name="arm_schema_name" select="concat(@name,'_arm')"/>
  <xsl:variable name="mim_schema_name" select="concat(@name,'_mim')"/>
  <TABLE border="1" cellspacing="1" width="100%">
    <TR>
      <TD valign="TOP">
        <!-- RBN - this xref is here to aid navigation, it may need to be
             removed for the ISO process -->
        <A HREF="../../../../repository_index{$FILE_EXT}">
          Module repository
        </A><BR/>
        <A HREF="cover{$FILE_EXT}">Cover page</A><BR/>
        <A HREF="foreword{$FILE_EXT}#foreword">Foreword</A><BR/>
        <A HREF="introduction{$FILE_EXT}#intro">Introduction</A><BR/>
        <A HREF="1_scope{$FILE_EXT}#scope">1 Scope</A><BR/>
        <A HREF="2_refs{$FILE_EXT}#nref">2 Normative references</A><BR/>
        <A HREF="3_defs{$FILE_EXT}#defns">3 Definitions and abbreviations</A>
      </TD>
      <TD valign="TOP">
        <!-- Output Section 4. Only set up the index to express clauses that
             exist. -->
        <A HREF="4_info_reqs{$FILE_EXT}#arm">4 Information requirements</A><BR/>
        <small>
          <A HREF="4_info_reqs{$FILE_EXT}#uof">
            <xsl:value-of select="concat('&#160;&#160;',' 4.1 Units of functionality')"/>
          </A><BR/>

          <!-- only output if there are interfaces defined and therefore a
               section -->
          <xsl:variable name="interface_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'interface'"/>
              <xsl:with-param name="schema_name" select="$arm_schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="$interface_clause != 0">
            <A HREF="4_info_reqs{$FILE_EXT}#interfaces">
              <xsl:value-of select="concat('&#160; &#160;', $interface_clause,
                                    ' Required AM ARMs')"/>
            </A><BR/>
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
            <A HREF="4_info_reqs{$FILE_EXT}#constants">
              <xsl:value-of select="concat('&#160; &#160;', $constant_clause,
                                    ' ARM constant definitions')"/>
            </A><BR/>
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
            <A HREF="4_info_reqs{$FILE_EXT}#imported_constant">
              <xsl:value-of select="concat('&#160; &#160;', 
                                    $imported_constant_clause,
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
          <xsl:if test="$type_clause != 0">
            <A HREF="4_info_reqs{$FILE_EXT}#types">
              <xsl:value-of select="concat('&#160; &#160;', $type_clause,
                                    ' ARM type definitions')"/>
            </A><BR/>
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
            <A HREF="4_info_reqs{$FILE_EXT}#imported_type">
              <xsl:value-of select="concat('&#160; &#160;', 
                                    $imported_type_clause,
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
          <xsl:if test="$entity_clause != 0">
            <A HREF="4_info_reqs{$FILE_EXT}#entities">
              <xsl:value-of select="concat('&#160; &#160;', $entity_clause,
                                    ' ARM entity definitions')"/>
            </A><BR/>
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
            <A HREF="4_info_reqs{$FILE_EXT}#imported_entity">
              <xsl:value-of select="concat('&#160; &#160;', 
                                    $imported_entity_clause,
                                    ' ARM imported entity modifications')"/>
            </A><BR/>
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
            <A HREF="4_info_reqs{$FILE_EXT}#functions">
              <xsl:value-of select="concat('&#160; &#160;', $function_clause,
                                    ' ARM function definitions')"/>
            </A><BR/>
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
            <A HREF="4_info_reqs{$FILE_EXT}#imported_function">
              <xsl:value-of select="concat('&#160; &#160;', 
                                    $imported_function_clause,
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
          <xsl:if test="$rule_clause !=0">
            <A HREF="4_info_reqs{$FILE_EXT}#rules">
              <xsl:value-of select="concat('&#160; &#160;', $rule_clause,
                                    'ARM rule definitions')"/>
            </A><BR/>
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
            <A HREF="4_info_reqs{$FILE_EXT}#imported_rule">
              <xsl:value-of select="concat('&#160; &#160;', 
                                    $imported_rule_clause,
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
          <xsl:if test="$procedure_clause != 0">
            <A HREF="4_info_reqs{$FILE_EXT}#procedures">
              <xsl:value-of select="concat('&#160; &#160;', $procedure_clause,
                                    ' ARM procedure definitions')"/>
            </A><BR/>
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
            <A HREF="4_info_reqs{$FILE_EXT}#imported_procedure">
              <xsl:value-of select="concat('&#160; &#160;', 
                                    $imported_procedure_clause,
                                    ' ARM imported procedure modifications')"/>
            </A><BR/>
          </xsl:if>

        </small>

        <!-- Output clause 5 index -->
        <A HREF="5_mim{$FILE_EXT}#mim">5 Module interpreted model</A><BR/>
        <small>
          <A HREF="5_mim{$FILE_EXT}#mapping">&#160; &#160;5.1 Mapping specification</A><BR/>
          <A HREF="5_mim{$FILE_EXT}#mim_express">&#160; &#160;5.2 MIM EXPRESS short listing</A><BR/>
          <!-- only output if there are constants defined and therefore a
               section -->
          <xsl:variable name="constant_mim_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'constant'"/>
              <xsl:with-param name="schema_name" select="$mim_schema_name"/>
            </xsl:call-template>
          </xsl:variable>

          <xsl:if test="$constant_mim_clause != 0">
            <A HREF="5_mim{$FILE_EXT}#constants">
              <xsl:value-of select="concat('&#160; &#160; &#160;', $constant_mim_clause,
                                    ' MIM constant definitions')"/>
            </A><BR/>
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
            <A HREF="5_mim{$FILE_EXT}#imported_constant">
              <xsl:value-of select="concat('&#160; &#160; &#160;', 
                                    $imported_constant_mim_clause,
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
          <xsl:if test="$type_mim_clause != 0">
            <A HREF="5_mim{$FILE_EXT}#types">
              <xsl:value-of select="concat('&#160; &#160; &#160;', $type_mim_clause,
                                    ' MIM type definitions')"/>
            </A><BR/>
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
            <A HREF="5_mim{$FILE_EXT}#imported_type">
              <xsl:value-of select="concat('&#160; &#160; &#160;', 
                                    $imported_mim_type_clause,
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
          <xsl:if test="$entity_mim_clause != 0">
            <A HREF="5_mim{$FILE_EXT}#entities">
              <xsl:value-of select="concat('&#160; &#160; &#160;', $entity_mim_clause,
                                    ' MIM entity definitions')"/>
            </A><BR/>
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
            <A HREF="5_mim{$FILE_EXT}#imported_entity">
              <xsl:value-of select="concat('&#160; &#160; &#160;', 
                                    $imported_mim_entity_clause,
                                    ' MIM imported entity modifications')"/>
            </A><BR/>
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
            <A HREF="5_mim{$FILE_EXT}#functions">
              <xsl:value-of select="concat('&#160; &#160; &#160;', $function_mim_clause,
                                    ' MIM function definitions')"/>
            </A><BR/>
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
            <A HREF="5_mim{$FILE_EXT}#imported_function">
              <xsl:value-of select="concat('&#160; &#160; &#160;', 
                                    $imported_mim_function_clause,
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
          <xsl:if test="$rule_mim_clause != 0">
            <A HREF="5_mim{$FILE_EXT}#rules">
              <xsl:value-of select="concat('&#160; &#160; &#160;', $rule_mim_clause,
                                    ' MIM rule definitions')"/>
            </A><BR/>
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
            <A HREF="5_mim{$FILE_EXT}#imported_rule">
              <xsl:value-of select="concat('&#160; &#160; &#160;', 
                                    $imported_mim_rule_clause,
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
          <xsl:if test="$procedure_mim_clause != 0">
            <A HREF="5_mim{$FILE_EXT}#procedures">
              <xsl:value-of select="concat('&#160; &#160; &#160;', $procedure_mim_clause,
                                    ' MIM procedure definitions')"/>
            </A><BR/>
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
            <A HREF="5_mim{$FILE_EXT}#imported_procedure">
              <xsl:value-of select="concat('&#160; &#160; &#160;', 
                                    $imported_mim_procedure_clause,
                                    ' MIM imported procedure modifications')"/>
            </A><BR/>
          </xsl:if>


        </small>
      </TD>
      <TD valign="TOP">
        <A HREF="a_short_names{$FILE_EXT}#annexa">A AM MIM short names</A><BR/>
        <A HREF="b_obj_reg{$FILE_EXT}#annexb">B Information requirements object
        registration</A><BR/>
        <A HREF="c_arm_expg{$FILE_EXT}#annexc">C ARM EXPRESS-G</A>
        <xsl:apply-templates 
          select="arm/express-g/imgfile" mode="page_number"/>
        <BR/>

        <A HREF="d_mim_expg{$FILE_EXT}#annexd">D MIM EXPRESS-G</A>
        <xsl:apply-templates 
          select="mim/express-g/imgfile" mode="page_number"/>
        <BR/>
        <A HREF="e_exp{$FILE_EXT}#annexe">E AM ARM and MIM EXPRESS
listings</A><BR/>
        <xsl:if test="./usage_guide">
          <A HREF="f_guide{$FILE_EXT}#annexf">
            F Application module implementation and usage guide</A><BR/>
        </xsl:if>
        <A HREF="biblio{$FILE_EXT}#biblio">Bibliography</A>
      </TD>
    </TR>
  </TABLE>
</xsl:template>

<!--
     Output the Table of contents banner for a module where all clauses are 
     displayed on a single page
-->
<xsl:template match="module" mode="TOCsinglePage">
  <xsl:apply-templates select="." mode="TOCbannertitle"/>  
  <TABLE border="1" cellspacing="1" width="100%">
    <TR>
      <TD valign="TOP">
        <A HREF="module{$FILE_EXT}#cover_page">Cover page</A><BR/>
        <A HREF="module{$FILE_EXT}#foreword">Foreword</A><BR/>
        <A HREF="module{$FILE_EXT}#intro">Introduction</A><BR/>
        <A HREF="module{$FILE_EXT}#scope">1 Scope</A><BR/>
        <A HREF="module{$FILE_EXT}#nref">2 Normative references</A><BR/>
        <A HREF="module{$FILE_EXT}#defns">3 Definitions and abbreviations</A>
      </TD>
      <TD valign="TOP">
        <A HREF="module{$FILE_EXT}#arm">4 Information requirements</A><BR/>
        <A HREF="module{$FILE_EXT}#mim">5 Module interpreted model</A><BR/>
        <A HREF="module{$FILE_EXT}#annexa">A AM MIM short names</A><BR/>
        <A HREF="module{$FILE_EXT}#annexb">B Information requirements object
        registration</A><BR/>
        <A HREF="module{$FILE_EXT}#annexc">C ARM EXPRESS-G</A><BR/>
        <A HREF="module{$FILE_EXT}#annexd">D MIM EXPRESS-G</A>
      </TD>
      <TD valign="TOP">
        <A HREF="module{$FILE_EXT}#annexe">E AM ARM and MIM EXPRESS listings</A><BR/>
        <xsl:if test="./usage_guide">
          <A HREF="module{$FILE_EXT}#annexf">
            F Application module implementation and usage guide</A><BR/>
        </xsl:if>
        <A HREF="module{$FILE_EXT}#biblio">Bibliography</A>
      </TD>
    </TR>
  </TABLE>
</xsl:template>

<xsl:template match="imgfile" mode="page_number">
  <xsl:variable name="href">
    <xsl:call-template name="set_file_ext">
      <xsl:with-param name="filename" select="concat('../',@file)"/>
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
