<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: res_toc.xsl,v 1.35 2017/06/30 15:48:18 thomasrthurman Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     Templates that are common to most other stylesheets
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">


   
<xsl:template name="schema_section">
  <xsl:param name="schema_no" />
  <xsl:param name="resdoc_root" select="'..'"/>
  <xsl:variable name="resource_name">
   <xsl:call-template name="resource_name">
              <xsl:with-param name="resource" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="resource_display_name">
    <xsl:call-template name="res_display_name">
      <xsl:with-param name="res" select="$resource_name"/>
    </xsl:call-template>
  </xsl:variable>


   <xsl:variable name="resource_dir">
     <xsl:call-template name="resource_directory">
       <xsl:with-param name="resource" select="@name"/>
     </xsl:call-template>
   </xsl:variable>



  <!--
  <xsl:message>
    schema_section template
    resource_name :<xsl:value-of select="$resource_name"/>
    schema_no :<xsl:value-of select="$schema_no"/>
  </xsl:message>
  <xsl:message>
    resource_display_name :<xsl:value-of select="$resource_display_name"/>
  </xsl:message>
-->
    <xsl:variable name="doctype">
      <xsl:apply-templates select="./ancestor::resource" mode="doctype"/>
    </xsl:variable>

  <xsl:variable name="file_name">
    <xsl:choose>
      <xsl:when test="$doctype='aic'">
        <xsl:value-of select="concat('aic_', $resource_name)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat($resource_name,'_schema.xml')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="express_xml_ir" select="document(concat($resource_dir,'/',$file_name, '.xml'))"/>
  
   <!--<xsl:variable name="express_xml_ir" select="document(concat($resource_dir,'/',$resource_name,'_schema.xml'))"/>-->

  <xsl:variable name="schema_name" select="@name"/>

  <!--  <xsl:variable name="clauseno" select="3+position()"/> -->
  <xsl:variable name="clauseno" select="$schema_no"/>

        <!-- Output a Schema clause TOC -->
        <xsl:choose>
          <xsl:when test="$doctype='aic'">
            <A HREF="{$resdoc_root}/sys/{$clauseno}_schema{$FILE_EXT}">
              <xsl:value-of select="concat($clauseno,' ', 'EXPRESS short listing')"/>
            </A>
          </xsl:when>
          <xsl:otherwise>
            <A HREF="{$resdoc_root}/sys/{$clauseno}_schema{$FILE_EXT}">
              <xsl:value-of select="concat($clauseno,' ', $resource_display_name,' schema')"/>
            </A>
          </xsl:otherwise>
        </xsl:choose>

        <BR/>
        <small>
          &#160; &#160;<A HREF="{$resdoc_root}/sys/{$clauseno}_schema{$FILE_EXT}#gen">
          <xsl:value-of select="concat($clauseno,'.1 General')"/>
          </A><BR/>

          <!-- fundamental concepts - seems to always be there -->
          &#160; &#160;<A HREF="{$resdoc_root}/sys/{$clauseno}_schema{$FILE_EXT}#funcon">
          <xsl:value-of select="concat($clauseno,'.2 Fundamental concepts and assumptions')"/>
          </A><BR/>
          
          <!-- only output if there are constants defined and therefore a
               section -->
          <xsl:variable name="constant_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="main_clause" select="$schema_no"/>
              <xsl:with-param name="clause" select="'constant'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="$constant_clause != 0">
            <xsl:variable name="constant_count">
			 	<xsl:choose>
			      <xsl:when test="not($doctype='aic')">
			        <xsl:value-of select="count($express_xml_ir/express/schema/constant)"/>
	              </xsl:when>
	              <xsl:otherwise>
   			<xsl:variable name="express_xml_aic" select="document(concat($resource_dir,'/aic_',$resource_name,'.xml'))"/>
	                <xsl:value-of select="count($express_xml_aic/express/schema/constant)"/>
	              </xsl:otherwise>
	            </xsl:choose> 
            </xsl:variable> 
			<xsl:choose>
			  <xsl:when test="$constant_count>1">
				&#160; &#160;<A HREF="{$resdoc_root}/sys/{$clauseno}_schema{$FILE_EXT}#constants">
				<xsl:value-of select="concat($clauseno, $constant_clause, ' ',
									  $resource_display_name, ' constant definitions')"/>
			  </A>
			  </xsl:when>
			  <xsl:otherwise>
				&#160; &#160;<A HREF="{$resdoc_root}/sys/{$clauseno}_schema{$FILE_EXT}#constants">
				<xsl:value-of select="concat($clauseno, $constant_clause, ' ',
									  $resource_display_name, ' constant definition')"/>
			  </A>
			  </xsl:otherwise>
			</xsl:choose>
			<BR/>
		  </xsl:if>
          <!-- only output if there are imported constants defined and 
               therefore a section -->
          <xsl:variable name="imported_constant_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="main_clause" select="$schema_no"/>
              <xsl:with-param name="clause" select="'imported_constant'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="$imported_constant_clause != 0">
            &#160; &#160;<A HREF="{$resdoc_root}/sys/{$clauseno}_schema{$FILE_EXT}#imported_constant">
              <xsl:value-of select="concat($clauseno, $imported_constant_clause, ' ',
                                    $resource_display_name,' imported constant modifications')"/>
            </A><BR/>
          </xsl:if>

          <!-- only output if there are types defined and therefore a
               section -->
          <xsl:variable name="type_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="main_clause" select="$schema_no"/>
              <xsl:with-param name="clause" select="'type'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="$type_clause != 0">
            <xsl:variable name="type_count">
			 	<xsl:choose>
			      <xsl:when test="not($doctype='aic')">
			        <xsl:value-of select="count($express_xml_ir/express/schema/type)"/>
	              </xsl:when>
	              <xsl:otherwise>
   			<xsl:variable name="express_xml_aic" select="document(concat($resource_dir,'/aic_',$resource_name,'.xml'))"/>
	                <xsl:value-of select="count($express_xml_aic/express/schema/constant)"/>
	              </xsl:otherwise>
	            </xsl:choose> 
            </xsl:variable> 
			<xsl:choose>
			  <xsl:when test="$type_count>1">
				&#160; &#160;<A HREF="{$resdoc_root}/sys/{$clauseno}_schema{$FILE_EXT}#types">
				<xsl:value-of select="concat($clauseno, $type_clause, ' ',
									  $resource_display_name, ' type definitions')"/>
			  </A>
			  </xsl:when>
			  <xsl:otherwise>
				&#160; &#160;<A HREF="{$resdoc_root}/sys/{$clauseno}_schema{$FILE_EXT}#types">
				<xsl:value-of select="concat($clauseno, $type_clause, ' ',
									  $resource_display_name, ' type definition')"/>
			  </A>
			  </xsl:otherwise>
			</xsl:choose>
			<BR/>
          </xsl:if>
          <!-- only output if there are imported types defined and 
               therefore a section -->
          <xsl:variable name="imported_type_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="main_clause" select="$schema_no"/>
              <xsl:with-param name="clause" select="'imported_type'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="$imported_type_clause != 0">
            &#160; &#160;<A HREF="{$resdoc_root}/sys/{$clauseno}_schema{$FILE_EXT}#imported_type">
              <xsl:value-of select="concat($clauseno, ' ', $imported_type_clause,
                                   $resource_display_name, ' imported type modifications')"/>
            </A><BR/>
          </xsl:if>

          <!-- only output if there are entitys defined and therefore a
               section -->
          <xsl:variable name="entity_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="main_clause" select="$schema_no"/>
              <xsl:with-param name="clause" select="'entity'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>
          </xsl:variable>

          <xsl:if test="$entity_clause != 0">
            <xsl:variable name="entity_count">
			 	<xsl:choose>
			      <xsl:when test="not($doctype='aic')">
			        <xsl:value-of select="count($express_xml_ir/express/schema/entity)"/>
	              </xsl:when>
	              <xsl:otherwise>
   			<xsl:variable name="express_xml_aic" select="document(concat($resource_dir,'/aic_',$resource_name,'.xml'))"/>
	                <xsl:value-of select="count($express_xml_aic/express/schema/entity)"/>
	              </xsl:otherwise>
	            </xsl:choose> 
            </xsl:variable> 
          
			<xsl:choose>
			  <xsl:when test="$entity_count>1">
				&#160; &#160;<A HREF="{$resdoc_root}/sys/{$clauseno}_schema{$FILE_EXT}#entities">
				<xsl:value-of select="concat($clauseno, $entity_clause, ' ',
									  $resource_display_name, ' entity definitions')"/>
			  </A>
			  </xsl:when>
			  <xsl:otherwise>
				&#160; &#160;<A HREF="{$resdoc_root}/sys/{$clauseno}_schema{$FILE_EXT}#entities">
				<xsl:value-of select="concat($clauseno, $entity_clause, ' ',
									  $resource_display_name, ' entity definition')"/>
			  </A>
			  </xsl:otherwise>
			</xsl:choose>
			<BR/>
          </xsl:if>
          <!--
          <xsl:message>
            entity_clause :<xsl:value-of select="$entity_clause"/>:
          </xsl:message>
-->
         
          <!-- only output if there are imported entitys defined and 
               therefore a section -->
          <xsl:variable name="imported_entity_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="main_clause" select="$schema_no"/>
              <xsl:with-param name="clause" select="'imported_entity'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="$imported_entity_clause != 0">
            &#160; &#160;
            <A HREF="{$resdoc_root}/sys/{$clauseno}_schema{$FILE_EXT}#imported_entity">
              <xsl:value-of select="concat($clauseno, $imported_entity_clause, ' ',
                                   $resource_display_name, ' imported entity modifications')"/>
            </A><BR/>
          </xsl:if>

          <!-- only output if there are subtype.constraint defined and 
               therefore a section -->
          <xsl:variable name="subtype_constraint_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="main_clause" select="$schema_no"/>
              <xsl:with-param name="clause" select="'subtype.constraint'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>
          </xsl:variable>          
          <xsl:if test="$subtype_constraint_clause != 0">
            <xsl:variable name="subtype_constraint_count">
			 	<xsl:choose>
			      <xsl:when test="not($doctype='aic')">
			        <xsl:value-of select="count($express_xml_ir/express/schema/subtype.constraint)"/>
	              </xsl:when>
		      <xsl:otherwise>
   			<xsl:variable name="express_xml_aic" select="document(concat($resource_dir,'/aic_',$resource_name,'.xml'))"/>
		        <xsl:value-of select="count($express_xml_aic/express/schema/subtype.constraint)"/>
	              </xsl:otherwise>
	            </xsl:choose> 
            </xsl:variable> 
			<xsl:choose>
			  <xsl:when test="$subtype_constraint_count>1">
				&#160; &#160;<A HREF="{$resdoc_root}/sys/{$clauseno}_schema{$FILE_EXT}#subtype_constraints">
				<xsl:value-of select="concat($clauseno, $subtype_constraint_clause, ' ',
									  $resource_display_name, ' subtype constraint definitions')"/>
			  </A>
			  </xsl:when>
			  <xsl:otherwise>
				&#160; &#160;<A HREF="{$resdoc_root}/sys/{$clauseno}_schema{$FILE_EXT}#subtype_constraints">
				<xsl:value-of select="concat($clauseno, $subtype_constraint_clause, ' ',
									  $resource_display_name, ' subtype constraint definition')"/>
			  </A>
			  </xsl:otherwise>
			</xsl:choose>
			<BR/>
          </xsl:if>

          <!-- only output if there are functions defined and therefore a
               section -->
          <xsl:variable name="function_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'function'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="$function_clause !=0">
            &#160; &#160;<A HREF="{$resdoc_root}/sys/{$clauseno}_schema{$FILE_EXT}#functions">
              <xsl:value-of select="concat($clauseno, $function_clause, ' ',
                                   $resource_display_name, ' function definitions')"/>
            </A><BR/>
          </xsl:if>
          <!-- only output if there are imported functions defined and 
               therefore a section -->
          <xsl:variable name="imported_function_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'imported_function'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="$imported_function_clause != 0">
            &#160; &#160;<A HREF="{$resdoc_root}/sys/{$clauseno}_schema{$FILE_EXT}#imported_function">
              <xsl:value-of select="concat($clauseno, $imported_function_clause, ' ',
                                   $resource_display_name, ' imported function modifications')"/>
            </A><BR/>
          </xsl:if>

          <!-- only output if there are rules defined and therefore a
               section -->
          <xsl:variable name="rule_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'rule'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="$rule_clause !=0">
            &#160; &#160;<A HREF="{$resdoc_root}/sys/{$clauseno}_schema{$FILE_EXT}#rules">
              <xsl:value-of select="concat($clauseno,  $rule_clause, ' ',
                                   $resource_display_name, ' rule definitions')"/>
            </A><BR/>
          </xsl:if>
          <!-- only output if there are imported rules defined and 
               therefore a section -->
          <xsl:variable name="imported_rule_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'imported_rule'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="$imported_rule_clause != 0">
            &#160; &#160;<A HREF="{$resdoc_root}/sys/{$clauseno}_schema{$FILE_EXT}#imported_rule">
              <xsl:value-of select="concat($clauseno, ' ',$imported_rule_clause,
                                   $resource_display_name, ' imported rule modifications')"/>
            </A><BR/>
          </xsl:if>

          <!-- only output if there are procedures defined and therefore a
               section -->
          <xsl:variable name="procedure_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'procedure'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="$procedure_clause != 0">
            &#160; &#160;<A HREF="{$resdoc_root}/sys/{$clauseno}_schema{$FILE_EXT}#procedures">
              <xsl:value-of select="concat($clauseno, $procedure_clause, ' ',
                                   $resource_display_name, ' procedure definitions')"/>
            </A><BR/>
          </xsl:if>
          <!-- only output if there are imported procedures defined and 
               therefore a section -->
          <xsl:variable name="imported_procedure_clause">
            <xsl:call-template name="express_clause_present">
              <xsl:with-param name="clause" select="'imported_procedure'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="$imported_procedure_clause != 0">
            &#160; &#160;<A HREF="{$resdoc_root}/sys/{$clauseno}_schema{$FILE_EXT}#imported_procedure">
              <xsl:value-of select="concat($clauseno, $imported_procedure_clause, ' ',
                                   $resource_display_name, ' imported procedure modifications')"/>
            </A><BR/>
          </xsl:if>
        </small>

</xsl:template>

<!--
     Output the Table of contents banner for a resource document where all clauses are 
     displayed on separate pages
-->

<xsl:template match="resource" mode="TOCmultiplePage">
  <!-- the entry that has been selected -->
  <xsl:param name="selected"/>
  <xsl:param name="resdoc_root" select="'..'"/>

  <xsl:variable name="n" > 
    <xsl:value-of select="count(schema)"/>
  </xsl:variable>
  
  <xsl:variable name="col1" > 
    <xsl:choose>
      <xsl:when test="$n &gt; 4" >
        <xsl:value-of select="ceiling(($n - 3 ) div 3 )"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="0"/>    
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="col2" > 
    <xsl:choose>
      <xsl:when test="$n &gt; 4" >
        <xsl:value-of select="$col1 + $col1 + 1"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$n"/>    
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>



  <xsl:apply-templates select="." mode="TOCbannertitle">
    <xsl:with-param name="resdoc_root" select="$resdoc_root"/>
  </xsl:apply-templates>

  <xsl:apply-templates select="." mode="test_resdoc_name"/>  

   <xsl:variable name="annex_list">
     <xsl:apply-templates select="." mode="annex_list" />
   </xsl:variable>


  <TABLE border="1" cellspacing="1" width="100%">
    <TR>
      <TD valign="TOP">
        <p class="toc">
          <A HREF="{$resdoc_root}/sys/cover{$FILE_EXT}">Cover page</A><BR/>
          <A HREF="{$resdoc_root}/sys/contents{$FILE_EXT}">Table of contents</A><BR/>
          
          <A HREF="{$resdoc_root}/sys/cover{$FILE_EXT}#copyright">Copyright</A><BR/>

          <!-- use #foreword to link direct -->
          <A HREF="{$resdoc_root}/sys/foreword{$FILE_EXT}">Foreword</A><BR/>
        
          <!-- use #intro to link direct -->
          <A HREF="{$resdoc_root}/sys/introduction{$FILE_EXT}">Introduction</A><BR/>
          
          <!-- use #scope to link direct -->
          <A HREF="{$resdoc_root}/sys/1_scope{$FILE_EXT}">1 Scope</A><BR/>
          
          <!-- use #nref to link direct -->
          <A HREF="{$resdoc_root}/sys/2_refs{$FILE_EXT}">2 Normative references</A><BR/>


        <!-- Assumption that every resdoc use a set of terms and
             abbreviations from the normref.inc so only check for local
             definitions aka terms -->
<!--        <xsl:choose>
          <xsl:when test="./definition/term">
            <!-\- use #defns to link direct -\->
            <A HREF="{$resdoc_root}/sys/3_defs{$FILE_EXT}">
              3 Terms, definitions and abbreviated terms
            </A>
          </xsl:when>
          <xsl:otherwise>
            <!-\- use #defns to link direct -\->
            <A HREF="{$resdoc_root}/sys/3_defs{$FILE_EXT}">
              3 Terms and abbreviated terms
            </A>            
          </xsl:otherwise>
        </xsl:choose> -->
        <A HREF="{$resdoc_root}/sys/3_defs{$FILE_EXT}">
          3 Terms, definitions and abbreviated terms
        </A>

          <br/>
          &#160; &#160;
          <a href="{$resdoc_root}/sys/3_defs{$FILE_EXT}#termsdefns">3.1 Terms and definitions</a>
          <br/>
          &#160; &#160;
          <a href="{$resdoc_root}/sys/3_defs{$FILE_EXT}#abbrv">3.2 Abbreviated terms</a>
          <br/> 

     <xsl:if test="$col1 &gt; 0 ">
        <xsl:for-each select="./schema[position() &lt;= $col1 ]">          
          <xsl:call-template name="schema_section">
            <xsl:with-param name="schema_no" select="position()+ 3" />
            <xsl:with-param name="resdoc_root" select="$resdoc_root"/>
          </xsl:call-template>
        </xsl:for-each>
     </xsl:if>
 
     </p> 

   </TD>


      <TD valign="TOP">
        <p class="toc">

        <xsl:for-each select="./schema[(position() &gt;= ($col1 + 1 )) and ( position() &lt;= $col2)]">          
        <xsl:call-template name="schema_section">
          <xsl:with-param name="schema_no" select="position()+ 3 + $col1" />
          <xsl:with-param name="resdoc_root" select="$resdoc_root"/>
        </xsl:call-template>
        </xsl:for-each>
      </p>
      </TD>

      <TD valign="TOP">

        <p class="toc">

        <xsl:if test="$col2 &lt; $n" >
                      
            <xsl:for-each select="./schema[(position() &gt; $col2) and (position() &lt;= $n)]">          
            <xsl:call-template name="schema_section">
              <xsl:with-param name="schema_no" select="position()+ 3 + $col2" />
                <xsl:with-param name="resdoc_root" select="$resdoc_root"/>
              </xsl:call-template>
            </xsl:for-each>
    
    </xsl:if>
  

        <!-- use #annexa to link direct -->
        <A HREF="{$resdoc_root}/sys/a_short_names{$FILE_EXT}">A Short names of entities</A><BR/>
        <!-- use #annexb to link direct -->
        <A HREF="{$resdoc_root}/sys/b_obj_reg{$FILE_EXT}">B Information object
        registration</A><BR/>

        <!-- use #annexd to link direct -->
        <A HREF="{$resdoc_root}/sys/c_exp{$FILE_EXT}">C Computer interpretable listings</A><BR/>

        <!-- use #annexd to link direct -->
        <A HREF="{$resdoc_root}/sys/d_expg{$FILE_EXT}">
          D EXPRESS-G diagrams
        </A>
        <!-- This will output links to the Express-G diagrams (1 2) 
             not however allowed in ISO 
             <xsl:apply-templates select="mim/express-g/imgfile" mode="page_number">
               <xsl:with-param name="resdoc_root" select="$resdoc_root"/>
             </xsl:apply-templates>
           -->
<!--       <xsl:call-template name="expressg_icon">
          <xsl:with-param name="schema" select="concat(./@name,'_schema')"/>
          <xsl:with-param name="resdoc_root" select="$resdoc_root"/>
        </xsl:call-template>
-->
        <BR/>

        <xsl:if test="string-length(./tech_discussion) > 10">
        <!-- use #annexa to link direct -->
		<xsl:variable name="pos" >
			<xsl:call-template name="annex_position" >
				<xsl:with-param name="annex_name" select="'Technical discussion'"/>
				<xsl:with-param name="annex_list" select="$annex_list" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="annex_letter" select="substring('EFGH',$pos,1)" />

	<A HREF="{$resdoc_root}/sys/tech_discussion{$FILE_EXT}#tech_discssion">
            <xsl:value-of select="$annex_letter"/> Technical discussion</A><BR/>
        </xsl:if>
        <xsl:if test="string-length(./examples) > 10">
        <!-- use #annexa to link direct -->
		<xsl:variable name="pos" >
			<xsl:call-template name="annex_position" >
				<xsl:with-param name="annex_name" select="'Examples'"/>
				<xsl:with-param name="annex_list" select="$annex_list" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="annex_letter" select="substring('EFGH',$pos,1)" />
          <A HREF="{$resdoc_root}/sys/examples{$FILE_EXT}">
            <xsl:value-of select="$annex_letter"/>  Examples</A><BR/>
        </xsl:if>
        <xsl:if test="string-length(./add_scope) > 10">
        <!-- use #annexa to link direct -->
		<xsl:variable name="pos" >
			<xsl:call-template name="annex_position" >
				<xsl:with-param name="annex_name" select="'Additional scope'"/>
				<xsl:with-param name="annex_list" select="$annex_list" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="annex_letter" select="substring('EFGH',$pos,1)" />
		
          <A HREF="{$resdoc_root}/sys/add_scope{$FILE_EXT}">
            <xsl:value-of select="$annex_letter"/>  Additional scope</A><BR/>
        </xsl:if>

          <xsl:variable name="annex_letter">
            <xsl:choose>
              <xsl:when test="./examples and ./tech_discussion">G</xsl:when>
              <xsl:when test="./examples or ./tech_discussion">F</xsl:when>
              <xsl:otherwise>E</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:if test="./changes">
            <A HREF="{$resdoc_root}/sys/g_change{$FILE_EXT}">
              <xsl:value-of select="$annex_letter"/> Change history</A><BR/>
          </xsl:if>
        

        <xsl:if test="./bibliography/*">
	        <A HREF="{$resdoc_root}/sys/biblio{$FILE_EXT}#bibliography">Bibliography</A><BR/>
	</xsl:if>
        <A HREF="{$resdoc_root}/sys/resdocindex{$FILE_EXT}">Index</A><BR/>
      </p>
      </TD>
    </TR>
  </TABLE>

</xsl:template>


<!--
     Output the Table of contents banner for a resource where all clauses are 
     displayed on a single page
-->
<xsl:template match="resource" mode="TOCsinglePage">
  <xsl:param name="resdoc_root" select="'..'"/>
  <xsl:apply-templates select="." mode="TOCbannertitle">
    <xsl:with-param name="resdoc_root" select="$resdoc_root"/>
  </xsl:apply-templates>
  <TABLE border="1" cellspacing="1" width="100%">
    <TR>
      <TD valign="TOP">
        <A HREF="{$resdoc_root}/sys/resource{$FILE_EXT}#cover_page">Cover page</A><BR/>
        <A HREF="{$resdoc_root}/sys/resource{$FILE_EXT}#foreword">Foreword</A><BR/>
        <A HREF="{$resdoc_root}/sys/resource{$FILE_EXT}#intro">Introduction</A><BR/>
        <A HREF="{$resdoc_root}/sys/resource{$FILE_EXT}#scope">1 Scope</A><BR/>
        <A HREF="{$resdoc_root}/sys/resource{$FILE_EXT}#nref">2 Normative references</A><BR/>
        <A HREF="{$resdoc_root}/sys/resource{$FILE_EXT}#defns">3 Definitions and abbreviations</A>
      </TD>
      <TD valign="TOP">
        <A HREF="{$resdoc_root}/sys/resource{$FILE_EXT}#arm">4 Schema 1 FIX</A><BR/>
        <A HREF="{$resdoc_root}/sys/resource{$FILE_EXT}#mim">5 Schema 2 FIX </A><BR/>
        <A HREF="{$resdoc_root}/sys/resource{$FILE_EXT}#annexa">A Short names of entities</A><BR/>
        <A HREF="{$resdoc_root}/sys/resource{$FILE_EXT}#annexb">B Information object registration</A><BR/>
        <A HREF="{$resdoc_root}/sys/resource{$FILE_EXT}#annexc">C EXPRESS-G diagrams</A><BR/>
        <A HREF="{$resdoc_root}/sys/resource{$FILE_EXT}#annexd">D Computer interpretable listings</A>
      </TD>
      <TD valign="TOP">
        <xsl:if test="string-length(./tech_discussion) > 10">
          <!-- use #annexf to link direct -->
          <A HREF="{$resdoc_root}/sys/resource{$FILE_EXT}">
            E Technical discussions</A><BR/>
        </xsl:if>
        <xsl:if test="string-length(./examples) > 10">
          <!-- use #annexf to link direct -->
          <A HREF="{$resdoc_root}/sys/resource{$FILE_EXT}">
            F Examples</A><BR/>
        </xsl:if>
        <xsl:if test="string-length(./add_scope) > 10">
          <!-- use #annexf to link direct -->
          <A HREF="{$resdoc_root}/sys/resource{$FILE_EXT}">
            G Additional scope</A><BR/>
        </xsl:if>
        
        <!-- use #biblio to link direct -->
	<xsl:if test="./bibliography/*" >
	        <A HREF="{$resdoc_root}/sys/resource{$FILE_EXT}">Bibliography</A>
	</xsl:if>
      </TD>
    </TR>
  </TABLE>
</xsl:template>


<xsl:template match="resource" mode="test_resdoc_name">
  <xsl:variable name="test">
    <xsl:call-template name="check_all_lower_case">
      <xsl:with-param name="str" select="@name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$test = -1">
    <xsl:call-template name="error_message">
      <xsl:with-param 
        name="message" 
        select="concat('Error m1: the resource document name ',@name,' is incorrectly
                named in resource.xml &lt;resource name=&quot;',@name,'&quot;. Should be all lower case')"/>
    </xsl:call-template>    
  </xsl:if>
  <xsl:if test="string(@name)='nutty_bolts'">
  
		<h1>NB THIS INTEGRATED RESOURCE IS FOR DEMONSTRATION PURPOSES ONLY</h1>

</xsl:if>
</xsl:template>


<xsl:template match="imgfile" mode="page_number">
  <xsl:param name="resdoc_root" select="'..'"/>

  <xsl:variable name="href">
    <xsl:call-template name="set_file_ext">
      <xsl:with-param name="filename" select="concat($resdoc_root,'/',@file)"/>
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

