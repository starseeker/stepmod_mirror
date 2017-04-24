<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_contents.xsl,v 1.49 2011/03/11 13:51:20 lothartklein Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: Output the refs section as a web page
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <!-- just imported for 
    <xsl:apply-templates select="." mode="map_attr_aname"/>  
    -->
  <xsl:import href="sect_5_mapping.xsl"/>

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       with no copyright footer
       -->
  <xsl:import href="module_clause_nofooter.xsl"/>


  <xsl:output method="html"/>

<!-- overwrites the template declared in module.xsl -->
<xsl:template match="module">
  <xsl:apply-templates select="../module" mode="contents"/>
  <xsl:apply-templates select="../module" mode="contents_tables_figures"/>
  <!-- no longer required by ISO
       <xsl:apply-templates select="../module" mode="copyright"/>
       -->
  <br/><br/>
  <p>&#169; ISO <xsl:value-of select="substring(@publication.year,1,4)"/> &#8212; All rights reserved</p>
</xsl:template>

<xsl:template match="module" mode="contents">
  <xsl:variable name="arm_schema_name" select="concat(@name,'_arm')"/>
  <xsl:variable name="mim_schema_name" select="concat(@name,'_mim')"/>

  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="arm_schema_xml"
    select="document(concat($module_dir,'/arm.xml'))/express/schema"/>
  <xsl:variable name="mim_schema_xml" 
    select="document(concat($module_dir,'/mim.xml'))/express/schema"/>

  <xsl:variable name="arm_xml" select="concat($module_dir,'/arm.xml')"/>
  <xsl:variable name="mim_xml" select="concat($module_dir,'/mim.xml')"/>

  <h2>Contents</h2>
    <!-- Don't think these are required
  <p class="content"><A HREF="./cover{$FILE_EXT}">Cover page</A></p>
  <p class="content"><A HREF="./foreword{$FILE_EXT}">Foreword</A></p>
  <p class="content"><A
  HREF="./introduction{$FILE_EXT}">Introduction</A></p>
-->
  <A HREF="./1_scope{$FILE_EXT}">1 Scope</A><br/>
  <A HREF="./2_refs{$FILE_EXT}">2 Normative references</A><br/>

<!--  <xsl:choose>
    <xsl:when test="./definition/term">
      <!-\- use #defns to link direct -\->
          <A HREF="./3_defs{$FILE_EXT}">
          3 Terms, definitions and abbreviated terms
        </A>
        <br/>
    </xsl:when>
    <xsl:otherwise>
      <!-\- use #defns to link direct -\->
         <A HREF="./3_defs{$FILE_EXT}">
           <!-\- every module references Terms defined in other standards,
                and abbreviations hence as per ISO -\->
           3 Terms, definitions and abbreviated terms
        </A>
        <br/>
    </xsl:otherwise>
  </xsl:choose>-->
  <a HREF="./3_defs{$FILE_EXT}">
    3 Terms, definitions and abbreviated terms
  </a>
  <br/>
  &#160; &#160;
  <a href="./3_defs{$FILE_EXT}#termsdefns">3.1 Terms and definitions</a>
  <br/>
  &#160; &#160;
  <a href="./3_defs{$FILE_EXT}#abbrv">3.2 Abbreviated terms</a>
  <br/>
  
    <A HREF="./4_info_reqs{$FILE_EXT}">4 Information requirements</A>
    <br/>
  
  <!-- no longer have UoFs
  <p class="content">
    &#160;&#160;
    <A HREF="./4_info_reqs{$FILE_EXT}#uof">4.1 Units of functionality</A>
  </p> -->

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
        &#160; &#160;
          <A HREF="./4_info_reqs{$FILE_EXT}#interfaces">
            <xsl:value-of select="concat($interface_clause,
                                  ' Required AM ARMs')"/>
          </A>
          <br/>
      </xsl:when>
      <xsl:otherwise>
          &#160; &#160;
          <A HREF="./4_info_reqs{$FILE_EXT}#interfaces">
            <xsl:value-of select="concat($interface_clause,
                                  ' Required AM ARM')"/>
          </A>
          <br/>
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
          &#160; &#160;
          <A HREF="./4_info_reqs{$FILE_EXT}#constants">
            <xsl:value-of select="concat($constant_clause,
                                  ' ARM constant definitions')"/>
          </A>
        <br/>
      </xsl:when>
      <xsl:otherwise>
          &#160; &#160;
          <A HREF="./4_info_reqs{$FILE_EXT}#constants">
            <xsl:value-of select="concat($constant_clause,
                                  ' ARM constant definition')"/>
          </A>
            <br/>
          </xsl:otherwise>
    </xsl:choose>

    <xsl:apply-templates 
      select="$arm_schema_xml/constant" mode="contents"/>
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
      &#160; &#160;
      <A HREF="./4_info_reqs{$FILE_EXT}#imported_constant">
        <xsl:value-of select="concat($imported_constant_clause,
                              ' ARM imported constant modifications')"/>
      </A>
      <br/>
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
          &#160; &#160;
          <A HREF="./4_info_reqs{$FILE_EXT}#types">
            <xsl:value-of select="concat($type_clause,
                                  ' ARM type definitions')"/>
          </A>
        <br/>
      </xsl:when>
      <xsl:otherwise>
          &#160; &#160;
          <A HREF="./4_info_reqs{$FILE_EXT}#types">
            <xsl:value-of select="concat($type_clause,
                                  ' ARM type definition')"/>
          </A>
        <br/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates 
      select="$arm_schema_xml/type" mode="contents"/>
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
      &#160; &#160; 
      <A HREF="./4_info_reqs{$FILE_EXT}#imported_type">
        <xsl:value-of select="concat($imported_type_clause,
                              ' ARM imported type modifications')"/>
      </A>
    <br/>
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
          &#160; &#160;
          <A HREF="./4_info_reqs{$FILE_EXT}#entities">
            <xsl:value-of select="concat($entity_clause,
                                  ' ARM entity definitions')"/>
          </A>
          <br/>
      </xsl:when>
      <xsl:otherwise>
          &#160; &#160;
          <A HREF="./4_info_reqs{$FILE_EXT}#entities">
            <xsl:value-of select="concat($entity_clause,
                                  ' ARM entity definition')"/>
          </A>
        <br/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates 
      select="$arm_schema_xml/entity" mode="contents"/>
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
      <A HREF="./4_info_reqs{$FILE_EXT}#imported_entity">
        <xsl:value-of select="concat($imported_entity_clause,
                              ' ARM imported entity modifications')"/>
      </A>
    <br/>
  </xsl:if>
  

  <!-- only output if there are subtype_constraints defined and therefore a
       section -->
  <xsl:variable name="subtype_constraint_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'subtype.constraint'"/>
      <xsl:with-param name="schema_name" select="$arm_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="normalize-space($subtype_constraint_clause) != '0'">
    <xsl:choose>
      <xsl:when test="count($arm_schema_xml/subtype.constraint)>1">
          &#160; &#160;
          <A HREF="./4_info_reqs{$FILE_EXT}#subtype_constraints">
            <xsl:value-of select="concat($subtype_constraint_clause,
                                  ' ARM subtype constraint definitions')"/>
          </A>
        <br/>
      </xsl:when>
      <xsl:otherwise>
          &#160; &#160;
          <A HREF="./4_info_reqs{$FILE_EXT}#subtype_constraints">
            <xsl:value-of select="concat($subtype_constraint_clause,
                                  ' ARM subtype constraint definition')"/>
          </A>
        <br/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates 
      select="$arm_schema_xml/subtype.constraint" mode="contents"/>
  </xsl:if>


  <!-- only output if there are functions defined and therefore a
       section -->
  <xsl:variable name="function_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'function'"/>
      <xsl:with-param name="schema_name" select="$arm_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="normalize-space($function_clause) != '0'">
    <xsl:choose>
      <xsl:when test="count($arm_schema_xml/function)>1">
          &#160; &#160;
          <A HREF="./4_info_reqs{$FILE_EXT}#functions">
            <xsl:value-of select="concat($function_clause,
                                  ' ARM function definitions')"/>
          </A>
        <br/>
      </xsl:when>
      <xsl:otherwise>
          &#160; &#160;
          <A HREF="./4_info_reqs{$FILE_EXT}#functions">
            <xsl:value-of select="concat($function_clause,
                                  ' ARM function definition')"/>
          </A>
        <br/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates 
      select="$arm_schema_xml/function" mode="contents"/>
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
      &#160; &#160;
      <A HREF="./4_info_reqs{$FILE_EXT}#imported_function">
        <xsl:value-of select="concat($imported_function_clause,
                              ' ARM imported function modifications')"/>
      </A>
    <br/>
  </xsl:if>
  
  <!-- only output if there are rules defined and therefore a
       section -->
  <xsl:variable name="rule_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'rule'"/>
      <xsl:with-param name="schema_name" select="$arm_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="normalize-space($rule_clause) != '0'">
    <xsl:choose>
      <xsl:when test="count($arm_schema_xml/rule)>1">
          &#160; &#160;
          <A HREF="./4_info_reqs{$FILE_EXT}#rules">
            <xsl:value-of select="concat($rule_clause,
                                  'ARM rule definitions')"/>
          </A>
        <br/>
      </xsl:when>
      <xsl:otherwise>
          &#160; &#160;
          <A HREF="./4_info_reqs{$FILE_EXT}#rules">
            <xsl:value-of select="concat($rule_clause,
                                  'ARM rule definition')"/>
          </A>
        <p/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates 
      select="$arm_schema_xml/rule" mode="contents"/>
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
      &#160; &#160;
      <A HREF="./4_info_reqs{$FILE_EXT}#imported_rule">
        <xsl:value-of select="concat($imported_rule_clause,
                              ' ARM imported rule modifications')"/>
      </A>
    <br/>
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
          &#160; &#160;
          <A HREF="./4_info_reqs{$FILE_EXT}#procedures">
            <xsl:value-of select="concat($procedure_clause,
                                  ' ARM procedure definitions')"/>
          </A>
        <br/>
      </xsl:when>
      <xsl:otherwise>
          &#160; &#160;
          <A HREF="./4_info_reqs{$FILE_EXT}#procedures">
            <xsl:value-of select="concat($procedure_clause,
                                  ' ARM procedure definition')"/>
          </A>
        <br/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates 
      select="$arm_schema_xml/procedure" mode="contents"/>
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
      &#160; &#160;
      <A HREF="./4_info_reqs{$FILE_EXT}#imported_procedure">
        <xsl:value-of select="concat($imported_procedure_clause,
                              ' ARM imported procedure modifications')"/>
      </A>
    <br/>
  </xsl:if>
  
  <!-- Output clause 5 index -->
  <!-- use #mim to link direct -->
    <A HREF="./5_main{$FILE_EXT}">5 Module interpreted model</A>
  <br/>
    &#160; &#160;
    <A HREF="./5_mapping{$FILE_EXT}#mapping">5.1 Mapping specification</A>
  <br/>
  <xsl:apply-templates select="./mapping_table/ae" mode="toc"/>
  <xsl:apply-templates select="./mapping_table/sc" mode="toc"/>

    &#160; &#160;
    <A HREF="./5_mim{$FILE_EXT}#mim_express">5.2 MIM EXPRESS short listing</A>
  <br/>
  
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
          &#160; &#160; &#160;
          <A HREF="./5_mim{$FILE_EXT}#constants">
            <xsl:value-of select="concat($constant_mim_clause,
                                  ' MIM constant definitions')"/>
          </A>
        <br/>
      </xsl:when>
      <xsl:otherwise>
          &#160; &#160; &#160;
          <A HREF="./5_mim{$FILE_EXT}#constants">
            <xsl:value-of select="concat($constant_mim_clause,
                                  ' MIM constant definition')"/>
          </A>
        <br/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates 
      select="$arm_schema_xml/constant" mode="contents"/>
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
      &#160; &#160; &#160;
      <A HREF="./5_mim{$FILE_EXT}#imported_constant">
        <xsl:value-of select="concat($imported_constant_mim_clause,
                              ' MIM imported constant modifications')"/>
      </A>
    <vr/>
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
          &#160; &#160; &#160;
          <A HREF="./5_mim{$FILE_EXT}#types">
            <xsl:value-of select="concat($type_mim_clause,
                                  ' MIM type definitions')"/>
          </A>
          <br/>
      </xsl:when>
      <xsl:otherwise>
                  &#160; &#160; &#160;
          <A HREF="./5_mim{$FILE_EXT}#types">
            <xsl:value-of select="concat($type_mim_clause,
                                  ' MIM type definition')"/>
          </A>
        <br/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates 
      select="$mim_schema_xml/type" mode="contents"/>
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
      &#160; &#160; &#160;                              
      <A HREF="./5_mim{$FILE_EXT}#imported_type">
        <xsl:value-of select="concat($imported_mim_type_clause,
                              ' MIM imported type modifications')"/>
      </A>
    <br/>
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
          &#160; &#160; &#160;
          <A HREF="./5_mim{$FILE_EXT}#entities">
            <xsl:value-of select="concat($entity_mim_clause,
                                  ' MIM entity definitions')"/>
          </A>
        <br/>
      </xsl:when>
      <xsl:otherwise>
          &#160; &#160; &#160;
          <A HREF="./5_mim{$FILE_EXT}#entities">
            <xsl:value-of select="concat($entity_mim_clause,
                                  ' MIM entity definition')"/>
          </A>
        <br/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates 
      select="$mim_schema_xml/entity" mode="contents"/>
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
      &#160; &#160; &#160;
      <A HREF="./5_mim{$FILE_EXT}#imported_entity">
        <xsl:value-of select="concat($imported_mim_entity_clause,
                              ' MIM imported entity modifications')"/>
      </A>
    <br/>
  </xsl:if>
  
    <!-- only output if there are subtype_constraints defined and therefore a
       section -->
  <xsl:variable name="subtype_constraint_mim_clause">
    <xsl:call-template name="express_clause_present">
      <xsl:with-param name="clause" select="'subtype.constraint'"/>
      <xsl:with-param name="schema_name" select="$mim_schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="normalize-space($subtype_constraint_mim_clause) != '0'">
    <xsl:choose>
      <xsl:when test="count($mim_schema_xml/subtype.constraint)>1">
          &#160; &#160; &#160;
          <A HREF="./5_mim{$FILE_EXT}#subtype_constraints">
            <xsl:value-of select="concat($subtype_constraint_mim_clause,
                                  ' MIM subtype constraint definitions')"/>
          </A>
        <br/>
      </xsl:when>
      <xsl:otherwise>
          &#160; &#160; &#160;
          <A HREF="./5_mim{$FILE_EXT}#subtype_constraints">
            <xsl:value-of select="concat($subtype_constraint_mim_clause,
                                  ' MIM subtype constraint definition')"/>
          </A>
        <br/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates 
      select="$mim_schema_xml/subtype.constraint" mode="contents"/>
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
          &#160; &#160; &#160;
          <A HREF="./5_mim{$FILE_EXT}#functions">
            <xsl:value-of select="concat($function_mim_clause,
                                  ' MIM function definitions')"/>
          </A>
        <br/>
      </xsl:when>
      <xsl:otherwise>
          &#160; &#160; &#160;
          <A HREF="./5_mim{$FILE_EXT}#functions">
            <xsl:value-of select="concat($function_mim_clause,
                                  ' MIM function definition')"/>
          </A>
        <br/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates 
      select="$mim_schema_xml/function" mode="contents"/>
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
      &#160; &#160; &#160;
      <A HREF="./5_mim{$FILE_EXT}#imported_function">
        <xsl:value-of select="concat($imported_mim_function_clause,
                              ' MIM imported function modifications')"/>
      </A>
    <br/>
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
          &#160; &#160; &#160;
          <A HREF="./5_mim{$FILE_EXT}#rules">
            <xsl:value-of select="concat($rule_mim_clause,
                                  ' MIM rule definitions')"/>
          </A>
        <br/>
      </xsl:when>
      <xsl:otherwise>
          &#160; &#160; &#160;
          <A HREF="./5_mim{$FILE_EXT}#rules">
            <xsl:value-of select="concat($rule_mim_clause,
                                  ' MIM rule definition')"/>
          </A>
        <br/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates 
      select="$mim_schema_xml/rule" mode="contents"/>
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
      &#160; &#160; &#160;
      <A HREF="./5_mim{$FILE_EXT}#imported_rule">
        <xsl:value-of select="concat($imported_mim_rule_clause,
                              ' MIM imported rule modifications')"/>
      </A>
    <br/>
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
          &#160; &#160; &#160;
          <A HREF="./5_mim{$FILE_EXT}#procedures">
            <xsl:value-of select="concat($procedure_mim_clause,
                                  ' MIM procedure definitions')"/>
          </A>
        <br/>
      </xsl:when>
      <xsl:otherwise>
          &#160; &#160; &#160;
          <A HREF="./5_mim{$FILE_EXT}#procedures">
            <xsl:value-of select="concat($procedure_mim_clause,
                                  ' MIM procedure definition')"/>
          </A>
        <br/>
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
      &#160; &#160; &#160;
      <A HREF="./5_mim{$FILE_EXT}#imported_procedure">
        <xsl:value-of select="concat($imported_mim_procedure_clause,
                              ' MIM imported procedure modifications')"/>
      </A>
    <br/>
  </xsl:if>

	 <xsl:if test="./refdata">
          <A HREF="./6_refdata{$FILE_EXT}">
          6 Module reference data
        </A>
        <br/>
		    <xsl:apply-templates 
      select="./refdata/refdata_subclause" mode="contents"/>		
    </xsl:if>

  <!-- use #annexa to link direct -->
    <A HREF="./a_short_names{$FILE_EXT}">
      Annex A MIM short names</A>
  <br/>
  <!-- use #annexb to link direct -->
    <A HREF="./b_obj_reg{$FILE_EXT}">Annex B Information object registration</A><br/>
    &#160;&#160;&#160;<A HREF="./b_obj_reg{$FILE_EXT}#b1">B.1 Document identification</A><br/>
    &#160;&#160;&#160;<A HREF="./b_obj_reg{$FILE_EXT}#b2">B.2 Schema identification</A><br/>

    <!-- RBN 2004-11-02
         according to the sup dirs the TOC shall contain entries to the
         second level (the first subclause level).
         Hence this is commented out.

    &#160;&#160;&#160;&#160;&#160;&#160;<A HREF="./b_obj_reg{$FILE_EXT}#b21">B.2.1 <xsl:value-of select="$arm_schema_xml/@name"/> schema identification</A><br/>
    
    &#160;&#160;&#160;&#160;&#160;&#160;<A HREF="./b_obj_reg{$FILE_EXT}#b22">B.2.2 <xsl:value-of select="$mim_schema_xml/@name"/> schema identification</A><br/>
    <xsl:if test="./arm_lf">
      <xsl:variable name="arm_lf_xml"
        select="concat($module_dir,'/arm_lf.xml')"/>
      <xsl:variable name="arm_schema_lf" 
        select="document($arm_lf_xml)/express/schema/@name"/>
      &#160;&#160;&#160;&#160;&#160;&#160;<A HREF="./b_obj_reg{$FILE_EXT}#b23">B.2.3 <xsl:value-of select="$arm_schema_lf"/> schema identification</A><br/>     
    </xsl:if>
    <xsl:if test="./mim_lf">
      <xsl:variable name="mim_lf_xml"
        select="concat($module_dir,'/mim_lf.xml')"/>
      <xsl:variable name="mim_schema_lf" 
      select="document($mim_lf_xml)/express/schema/@name"/>
      &#160;&#160;&#160;&#160;&#160;&#160;<A HREF="./b_obj_reg{$FILE_EXT}#b24">B.2.4 <xsl:value-of select="$mim_schema_lf"/> schema identification</A><br/>       
    </xsl:if>
    RBN 2004-11-02 -->


  <!-- use #annexc to link direct -->
    <A HREF="./c_arm_expg{$FILE_EXT}">Annex C ARM EXPRESS-G</A>
    <br/>
  
  <!-- use #annexd to link direct -->
    <A HREF="./d_mim_expg{$FILE_EXT}">Annex D MIM EXPRESS-G</A>
    <br/>
  
  <!-- use #annexe to link direct -->
    <A HREF="./e_exp{$FILE_EXT}">Annex E Computer interpretable listings</A>
  <br/>
  <xsl:if test="./usage_guide">
    <!-- use #annexa to link direct -->
      <A HREF="./f_guide{$FILE_EXT}">
        Annex F Application module implementation and usage guide
      </A>
    <br/>
    <xsl:apply-templates 
      select="./usage_guide/guide_subclause" mode="contents"/>
  </xsl:if>
  <xsl:variable name="annex_letter">
    <xsl:choose>
      <xsl:when test="./changes and ./usage_guide">G</xsl:when>
      <xsl:when test="./changes">F</xsl:when>
    </xsl:choose>
  </xsl:variable>
    <xsl:if test="./changes">
      <A HREF="./g_change{$FILE_EXT}"> Annex <xsl:value-of select="$annex_letter"/> Change
        history</A>
      <BR/>      
      &#160; &#160; &#160; 
      <A HREF="./g_change{$FILE_EXT}#general"><xsl:value-of select="concat($annex_letter,'.1 General')"/></A>
      <BR/>
      <xsl:for-each select="./changes/change">
        <xsl:sort select="@version"/>
        <xsl:variable name="annex_no" select="concat($annex_letter,' ',position()+1)"/>
        <xsl:variable name="ahref" select="concat('change_',@version)"/> &#160; &#160;
        &#160; <A HREF="./g_change{$FILE_EXT}#{$ahref}">
          <xsl:value-of select="concat($annex_no,' Changes made in edition ',@version)"/>
        </A>
        <BR/> &#160; &#160; &#160; &#160; &#160; &#160; <A
          HREF="./g_change{$FILE_EXT}#summary{@version}">
          <xsl:value-of select="concat($annex_no,'.1 Summary of changes ')"/>
        </A>
        <BR/>
        <xsl:for-each select="./node()">
          <xsl:variable name="aahref" select="concat(name(),../@version)"/>
          <xsl:choose>
            <xsl:when test="name()='arm.changes'">   
              <xsl:variable name="aannex_no" select="concat($annex_no,'.2')"/>
              &#160; &#160; &#160; &#160;
              &#160; &#160; <A HREF="./g_change{$FILE_EXT}#{$aahref}">
                <xsl:value-of select="concat($aannex_no,' Changes made to the ARM')"/>
              </A>
              <BR/>
            </xsl:when>
            <xsl:when test="name()='mapping.changes'">               
              <xsl:variable name="section_number" select="count(../arm.changes)+2"/>              
              <xsl:variable name="aannex_no" select="concat($annex_no,'.',$section_number)"/>
              &#160; &#160; &#160; &#160;
              &#160; &#160; <A HREF="./g_change{$FILE_EXT}#{$aahref}">
                <xsl:value-of
                  select="concat($aannex_no,' Changes made to the mapping')"/>
              </A>
              <BR/>
            </xsl:when>
            <xsl:when test="name()='mim.changes'">               
              <xsl:variable name="section_number" select="count(../arm.changes)+count(../mapping.changes)+2"/>              
              <xsl:variable name="aannex_no" select="concat($annex_no,'.',$section_number)"/>
              &#160; &#160; &#160; &#160;
              &#160; &#160; <A HREF="./g_change{$FILE_EXT}#{$aahref}">
                <xsl:value-of select="concat($aannex_no,' Changes made to the MIM')"/>
              </A>
              <BR/>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:if>
  
  <A HREF="./biblio{$FILE_EXT}#bibliography">Bibliography</A><br/>
  <A HREF="./modindex{$FILE_EXT}">Index</A>
  
</xsl:template>


<xsl:template match="constant" mode="count">
  <xsl:value-of select="count(../constant)"/>
</xsl:template>

<xsl:template match="type" mode="count">
  <xsl:value-of select="count(../type)"/>
</xsl:template>

<xsl:template match="entity" mode="count">
  <xsl:value-of select="count(../entity)"/>
</xsl:template>

<xsl:template match="subtype.constraint" mode="count">
  <xsl:value-of select="count(../subtype.constraint)"/>
</xsl:template>

<xsl:template match="rule" mode="count">
  <xsl:value-of select="count(../rule)"/>
</xsl:template>

<xsl:template match="procedure" mode="count">
  <xsl:value-of select="count(../procedure)"/>
</xsl:template>

<xsl:template match="function" mode="count">
  <xsl:value-of select="count(../function)"/>
</xsl:template>


<xsl:template match="constant|type|entity|subtype.constraint|rule|procedure|function" 
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
  
  <!-- removed at request of convener

  <xsl:variable name="no_nodes">
    <xsl:apply-templates select="." mode="count"/>
  </xsl:variable>

    &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    <xsl:choose>
      <xsl:when test="$no_nodes > 1">
        <a href="{$xref}">
          <xsl:value-of select="concat($clause_number, '.', position(), ' ', @name)"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <a href="{$xref}">
          <xsl:value-of select="@name"/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
-->

    &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;

        <a href="{$xref}">
          <xsl:value-of select="concat($clause_number, '.', position(), ' ', @name)"/>
        </a>

  <br/>
</xsl:template>

<xsl:template match="refdata_subclause" mode="contents">
  <xsl:variable name="xref">
       <xsl:value-of select="concat('./6_refdata',$FILE_EXT,'#',@title)"/>
    </xsl:variable>

    &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    <A HREF="{$xref}">
      <xsl:value-of select="concat('6.', position(), ' ', @title)"/>
    </A>
  <br/>
</xsl:template>

<xsl:template match="guide_subclause" mode="contents">
  <xsl:variable name="xref">
       <xsl:value-of select="concat('./f_guide',$FILE_EXT,'#',@title)"/>
    </xsl:variable>

    &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    <A HREF="{$xref}">
      <xsl:value-of select="concat('F.', position(), ' ', @title)"/>
    </A>
  <br/>
</xsl:template>

<xsl:template match="imgfile" mode="expressg_figure">
  <xsl:variable name="number">
    <xsl:number/>
  </xsl:variable>
  <xsl:variable name="total">
    <xsl:value-of select="count(../imgfile)-1"/>
  </xsl:variable>
  <xsl:variable name="fig_no">
    <xsl:choose>
      <xsl:when test="name(../..)='arm'">
        <xsl:choose>
          <xsl:when test="$number=1">
            <xsl:value-of 
              select="concat('Figure C.',$number, 
                      ' &#8212; ARM schema level EXPRESS-G diagram ',$number, ' of 1')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of 
              select="concat('Figure C.',$number, 
                      ' &#8212; ARM entity level EXPRESS-G diagram ',($number - 1),' of ',$total)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="name(../..)='mim'">
        <xsl:choose>
          <xsl:when test="$number=1">
            <xsl:value-of 
              select="concat('Figure D.',$number, 
                      ' &#8212; MIM schema level EXPRESS-G diagram ',$number,' of 1')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of 
              select="concat('Figure D.',$number, 
                      ' &#8212; MIM entity level EXPRESS-G diagram ',($number - 1),' of ',$total)"/>
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


<!-- list an index the tables and figures -->
<xsl:template match="module" mode="contents_tables_figures">
  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="arm_xml" select="concat($module_dir,'/arm.xml')"/>
  <xsl:variable name="arm_desc_xml" select="document($arm_xml)/express/@description.file"/>
  <xsl:variable name="mim_xml" select="concat($module_dir,'/mim.xml')"/>
  <xsl:variable name="mim_desc_xml" select="document($mim_xml)/express/@description.file"/>

 <h2>Figures</h2>
  <!-- collect up the figures from the Module -->
  <xsl:apply-templates select="./purpose//figure" mode="toc"/>
  <xsl:apply-templates select="./inscope//figure" mode="toc"/>
  <xsl:apply-templates select="./outscope//figure" mode="toc"/>
  <xsl:apply-templates select="./refdata//figure" mode="toc"/>
  <xsl:choose>
    <xsl:when test="$arm_desc_xml">
	    <xsl:apply-templates select="document($arm_desc_xml)//figure" mode="toc">
		    <xsl:sort select="@number" data-type="number" /><!-- added 2017-04-24 NSW -->
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="document($arm_xml)//figure" mode="toc"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:choose>
    <xsl:when test="$mim_desc_xml">
      <xsl:apply-templates select="document($mim_desc_xml)//figure" mode="toc">
		    <xsl:sort select="@number" data-type="number" /><!-- added 2017-04-24 NSW -->
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="document($mim_xml)//figure" mode="toc"/>
    </xsl:otherwise>
  </xsl:choose>
  <!-- collect up the EXpressG figures from the ARM -->
  <xsl:apply-templates 
    select="./arm/express-g/imgfile" mode="expressg_figure"/>
  <!-- collect up the EXpressG figures from the MIM -->
  <xsl:apply-templates 
    select="./mim/express-g/imgfile" mode="expressg_figure"/>

  <xsl:apply-templates select="./usage_guide//figure" mode="toc"/>

  <h2>Tables</h2>
  <xsl:apply-templates select="./purpose//table" mode="toc"/>
  <xsl:apply-templates select="./inscope//table" mode="toc"/>
  <xsl:apply-templates select="./outscope//table" mode="toc"/>
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
	
	<xsl:apply-templates select="./refdata//table" mode="toc"/>
	
  <xsl:apply-templates select="./mim/shortnames" mode="toc"/>
    <a href="./e_exp{$FILE_EXT}#table_e1">
      Table E.1 &#8212; ARM and MIM EXPRESS listings
    </a>
  <br/>
  <xsl:apply-templates select="./usage_guide//table" mode="toc"/>
 </xsl:template>


<xsl:template match="table|figure" mode="toc">
  <xsl:variable name="number">
    <xsl:choose>
      <xsl:when test="@number">
        <xsl:value-of select="@number"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:number/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="href">
    <xsl:call-template name="table_href">
      <xsl:with-param name="table" select="."/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>

  <xsl:variable name="table_or_fig">
    <xsl:call-template name="first_uppercase">
      <xsl:with-param name="string" select="name(.)"/>
    </xsl:call-template>
  </xsl:variable>

    <a href="{$href}">      
    <xsl:value-of 
      select="concat($table_or_fig,' ',$number, ' &#8212; ', @caption, ./title)"/>
    </a>
  <br/>

</xsl:template>


<!-- Note - this is no longer required on the contents page by ISO -->
<xsl:template match="module" mode="copyright">
  <!-- the copyright is already at the bottom of the page from
       module_clause.xsl -->
  <p>
    &#169;ISO
    <xsl:value-of select="@publication.year"/>
  </p>

  <a name="copyright"/>
  <p>
    All rights reserved. Unless otherwise specified, no part of this
    publication may be reproduced or utilized in any form or by any means,
    electronic or mechanical, including photocopying and microfilm, 
    without permission in writing from either ISO at the address below or
    ISO's member body in the 
    country of the requester.
  </p>
    <blockquote>
      ISO copyright office<br/>
      Case postale 56. CH-1211 Geneva 20<br/>
      Tel. + 41 22 749 01 11<br/>
      Fax + 41 22 734 10 79<br/>
      E-mail copyright@iso.ch<br/>
      Web www.iso.ch<br/>
    </blockquote>
</xsl:template>


<xsl:template match="sc" mode="toc">
  <xsl:variable name="ae_aname" select="@constraint"/>

  <xsl:variable name="ae_map_aname">
    <xsl:apply-templates select="." mode="map_attr_aname"/>  
  </xsl:variable>

  <xsl:variable 
    name="ae_xref"
    select="concat('../sys/5_mapping',$FILE_EXT,'#',$ae_map_aname)"/>


  <xsl:variable name="ae_count" select="count(//ae)" />
  <xsl:variable name="sect_no">
    <xsl:value-of select="$ae_count+position()"/>
  </xsl:variable>

    &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    <a href="{$ae_xref}">
      <xsl:value-of
        select="concat('5.1.',$sect_no,' ',$ae_aname)"/>
    </a>
  <br/>
</xsl:template>

<xsl:template match="ae" mode="toc">
  <xsl:variable name="ae_aname" select="@entity"/>

  <xsl:variable name="ae_map_aname">
    <xsl:apply-templates select="." mode="map_attr_aname"/>  
  </xsl:variable>

  <xsl:variable 
    name="ae_xref"
    select="concat('./5_mapping',$FILE_EXT,'#',$ae_map_aname)"/>

  <xsl:variable name="sect_no">
    <xsl:number/>
  </xsl:variable>

    &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    <a href="{$ae_xref}">
      <xsl:value-of
        select="concat('5.1.',$sect_no,' ',$ae_aname)"/>
    </a>
  <br/>

  <!-- no need to go to this depth - there is a bug in the link with
       inherited attributes as well 
  <xsl:apply-templates select="aa" mode="toc">
    <xsl:with-param name="sect" select="concat('5.1.',$sect_no)"/>
  </xsl:apply-templates>
  -->
</xsl:template>

<!-- no need to go to this depth - there is a bug in the link with
       inherited attributes as well 
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
  <br/>
</xsl:template>
-->


<xsl:template match="shortnames" mode="toc">
    <a href="./a_short_names{$FILE_EXT}#table_a1">
      Table A.1 &#8212; MIM short names of entities
    </a>
  <br/>
</xsl:template>

</xsl:stylesheet>