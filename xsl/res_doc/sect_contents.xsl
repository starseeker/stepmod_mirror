<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_contents.xsl,v 1.14 2003/02/26 21:47:07 thendrix Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: Output the refs section as a web page
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">


  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
  <!--  <xsl:import href="sect_4_express.xsl" /> -->



  <xsl:import href="resource.xsl"/>
  <xsl:import href="resource_clause.xsl"/>
  <!--  <xsl:import href="common.xsl"/> -->


   <xsl:output method="html"/>

 <!-- overwrites the template declared in resource.xsl -->
 <xsl:template match="resource">
   <xsl:apply-templates select="../resource" mode="contents"/>
   <xsl:apply-templates select="../resource" mode="contents_tables_figures"/>
   <xsl:apply-templates select="../resource" mode="copyright"/>
 </xsl:template>
 <xsl:template match="resource" mode="contents">

   <xsl:variable name="resdoc_dir">
     <xsl:call-template name="resdoc_directory">
       <xsl:with-param name="resdoc" select="@name"/>
     </xsl:call-template>
   </xsl:variable>


   <xsl:variable name="resdoc_root">
     <xsl:choose>
       <xsl:when test="contains(@file,'schema_diag')">
         <xsl:value-of select="'.'"/>                  
       </xsl:when>
       <xsl:otherwise>
         <xsl:value-of select="$resdoc_dir"/>                  
       </xsl:otherwise>
     </xsl:choose>           
   </xsl:variable>

   <xsl:variable name="annex_list">
     <xsl:apply-templates select="." mode="annex_list" />
   </xsl:variable>

   <!--
   <xsl:message >
     resdoc_dir :<xsl:value-of select="$resdoc_dir"/>
   </xsl:message>
-->
   <h2>Contents</h2>
   <A HREF="./1_scope{$FILE_EXT}">1 Scope</A><br/>
   <A HREF="./2_refs{$FILE_EXT}">2 Normative references</A><br/>

   <xsl:choose>
     <xsl:when test="./definition/term">
       <!-- use #defns to link direct -->
         <A HREF="./3_defs{$FILE_EXT}">
           3 Terms, definitions and abbreviations
         </A>
       <br/>
     </xsl:when>
     <xsl:otherwise>
       <!-- use #defns to link direct -->
         <A HREF="./3_defs{$FILE_EXT}">
           3 Terms and abbreviations
         </A>
       <br/>
     </xsl:otherwise>
   </xsl:choose>

   <xsl:if test="count(schema)>0" >
     <xsl:for-each select="./schema">          
       <xsl:call-template name="toc_schema_section">
         <xsl:with-param name="clause_no" select="position()+3" />
         <xsl:with-param name="resdoc_root" select="$resdoc_root"/>
       </xsl:call-template>
     </xsl:for-each>
   </xsl:if>

   <!-- use #annexa to link direct -->
     <A HREF="./a_short_names{$FILE_EXT}">A Short names of entities</A>
   <br/>
   <!-- use #annexb to link direct -->
     <A HREF="./b_obj_reg{$FILE_EXT}">B Information requirements object
     registration</A>
     <br/>

   <!-- use #annexc to link direct -->
     <A HREF="./c_exp{$FILE_EXT}">C Computer interpretable listings</A>
     <br/>

   <!-- use #annexd to link direct -->
     <A HREF="./d_expg{$FILE_EXT}">D EXPRESS-G diagrams</A>
     <br/>

        <xsl:if test="string-length(./tech_discussion) > 10">
        <!-- use #annexa to link direct -->
		<xsl:variable name="pos" >
			<xsl:call-template name="annex_position" >
				<xsl:with-param name="annex_name" select="'Technical discussion'"/>
				<xsl:with-param name="annex_list" select="$annex_list" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="annex_letter" select="substring('EFGH',$pos,1)" />

   		<A HREF="./tech_discussion{$FILE_EXT}#tech_discssion">
            	<xsl:value-of select="$annex_letter"/>  Technical discussion</A>
                <br/>
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
   		<A HREF="./examples{$FILE_EXT}">
	            <xsl:value-of select="$annex_letter"/>  Examples</A>
		<br/>
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

	
		<A HREF="./add_scope{$FILE_EXT}">
	            <xsl:value-of select="$annex_letter"/>  Additional scope</A>
                    <br/>
        </xsl:if>


   <xsl:if test="./bibliography/*">
	      <A HREF="./biblio{$FILE_EXT}#bibliography">Bibliography</A>
	      <br/>
   </xsl:if>


  </xsl:template>

 <xsl:template match="constant|type|entity|subtype.constraint|rule|procedure|function" 
   mode="contents">
   <xsl:param name="clause_no"/>
   <xsl:variable name="node_type" select="name(.)"/>
   <xsl:variable name="schema_name" select="../@name"/>
   <!--
   <xsl:message>
     schema_name :<xsl:value-of select="$schema_name"/>
   </xsl:message>
-->
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
     <xsl:value-of select="concat('./',$clause_no,'_schema',$FILE_EXT,'#',$aname)"/>
   </xsl:variable>

     &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
     <A HREF="{$xref}">
       <xsl:value-of select="concat($clause_no,$clause_number, '.', position(), ' ', @name)"/>
     </A>
   <br/>
 </xsl:template>

 <xsl:template match="imgfile" mode="expressg_figure">
   <xsl:variable name="file">
     <xsl:value-of select ="@file"/>
   </xsl:variable>
     <xsl:variable name="number">
       <xsl:number level="any"/>
     </xsl:variable>
       <xsl:choose>
         <xsl:when test="contains(@file,'schema_diag')">
           <xsl:variable name="figtext" >
             <xsl:if test="string-length(@title) > 3" >
               <xsl:value-of 
                 select="concat('Figure ',$number, 
                         ' &#8212; ',@title)" />
               </xsl:if>       
             </xsl:variable>
             <xsl:variable name="expg_path">
               <xsl:value-of select="substring-before($file,'.xml')"/>
             </xsl:variable>

             <xsl:variable name="schema_url">
               <xsl:choose>
                 <xsl:when test="$FILE_EXT='.xml'">
                   <xsl:value-of select="concat('../',$expg_path,'.xml')"/>
                 </xsl:when>
                 <xsl:otherwise>
                   <xsl:value-of select="concat('../',$expg_path,'.htm')"/>
                 </xsl:otherwise>
               </xsl:choose>
             </xsl:variable>
        
             <xsl:variable name="href" select="$schema_url"/>
           

             <a href="{$href}"><xsl:value-of select="$figtext"/></a>
             <br/>

         </xsl:when>

         <xsl:when test="contains(@file,'schemaexpg')">
             <xsl:variable name="schname" select="substring-before(@file,'expg')" />
             <xsl:variable name="diagno" >
               <xsl:variable name="trail" select="substring-after(@file,'expg')" />
               <xsl:value-of select="substring-before($trail,'.xml')"/>
             </xsl:variable>

             <xsl:variable name="figtext" >
               <xsl:value-of 
                 select="concat('Figure D.',($number - 1), 
                         ' &#8212; EXPRESS-G diagram of the ', $schname, ' diagram ', $diagno)"/>
             </xsl:variable>

             <xsl:variable name="resource_dir">
               <xsl:call-template name="resource_directory">
                 <xsl:with-param name="resource" select="$schname"/>
               </xsl:call-template>
             </xsl:variable>
             <!--
             <xsl:message>
               resource_dir in sect_cont :<xsl:value-of select="$resource_dir"/>
             </xsl:message>
-->
             <xsl:variable name="expg_path" select="concat('../../',$resource_dir,'/',$schname,'expg',$diagno)"/>

             <xsl:variable name="schema_url">
               <xsl:choose>
                 <xsl:when test="$FILE_EXT='.xml'">
                   <xsl:value-of select="concat($expg_path,'.xml')"/>
                 </xsl:when>
                 <xsl:otherwise>
                   <xsl:value-of select="concat($expg_path,'.htm')"/>
                 </xsl:otherwise>
               </xsl:choose>
             </xsl:variable>
        
             <xsl:variable name="href" select="$schema_url"/>
               <a href="{$href}"><xsl:value-of select="$figtext"/></a>
               <br/>

           </xsl:when>
         </xsl:choose>
       </xsl:template>



 <!-- list an index the tables and figures -->
 <xsl:template match="resource" mode="contents_tables_figures">

   <xsl:variable name="resdoc_dir">
     <xsl:call-template name="resdoc_directory">
       <xsl:with-param name="resdoc" select="@name"/>
     </xsl:call-template>
   </xsl:variable>


   <h2>Tables</h2>

   <!-- collect any tables from each section- must do this to get shortname in sequence -->
   <xsl:apply-templates select="./purpose//table" mode="toc"/>

   <xsl:apply-templates select="./inscope//table" mode="toc"/>
   <xsl:apply-templates select="./outscope//table" mode="toc"/>
   <xsl:apply-templates select="./schema//table" mode="toc"/>
   <!-- collect up the EXpressG figures from the schemas -->

   <xsl:apply-templates select="//shortnames" mode="toc" />

   <!-- collect up the figures from the annexes --> 
   <xsl:apply-templates select="./tech_discussion//table" mode="toc"/>
   <xsl:apply-templates select="./example//table" mode="toc"/>
   <xsl:apply-templates select="./add_scope//table" mode="toc"/>


   <h2>Figures</h2>
   <!-- collect any figures from the introduction -->
   <xsl:apply-templates select="./purpose//figure" mode="toc"/>
   <!-- collect interface diagram figures from the introduction -->
   <xsl:apply-templates 
     select="./schema_diag//imgfile" mode="expressg_figure"/>

   <xsl:apply-templates select="./inscope//figure" mode="toc"/>
   <xsl:apply-templates select="./outscope//figure" mode="toc"/>
   <!-- collect up the EXpressG figures from the schemas -->
   <xsl:apply-templates 
     select="./schema//imgfile" mode="expressg_figure"/>
   <!-- collect up the figures from the remaining annexes --> 
   <xsl:apply-templates select="./tech_discussion//figure" mode="toc"/>
   <xsl:apply-templates select="./examples//figure" mode="toc"/>
   <xsl:apply-templates select="./add_scope//figure" mode="toc"/>
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
       select="concat($table_or_fig,' ',$number, ' &#8212; ', ./title, ./@caption)"/>
     </a>
     <br/>


 </xsl:template>

 <xsl:template match="shortnames" mode="toc">


       <a href="a_short_names{$FILE_EXT}">      
       <xsl:value-of 
         select="'Table A.1 Short names of entities'" />
     </a>
     <br/>
   


 </xsl:template>
 

 <xsl:template name="toc_schema_section" > 
   <xsl:param name="clause_no" />

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

   <xsl:variable name="express_xml" select="document(concat($resource_dir,'/',$resource_name,'_schema.xml'))" />

   <xsl:variable name="schema_name" select="@name"/>

     <A HREF="./{$clause_no}_schema{$FILE_EXT}"> 
     <xsl:value-of select="concat($clause_no,' ',$resource_display_name)"/></A>
     <br/>

   &#160;&#160;<A HREF="./{$clause_no}_schema{$FILE_EXT}#intro">
           <xsl:value-of select="concat(string($clause_no),'.1 Introduction')"/>
           </A><BR/>

           <!-- fundamental concepts - seems to always be there -->

           &#160;&#160;<A HREF="./{$clause_no}_schema{$FILE_EXT}#funcon">
           <xsl:value-of select="concat($clause_no,'.2 Fundamental concepts and assumptions')"/>
           </A>
 <br/>
   <!-- only output if there are interfaces defined and therefore a
        section -->

<!-- commented out as not required for resource docs -->
<!--
   <xsl:variable name="interface_clause">
     <xsl:call-template name="express_clause_present">
       <xsl:with-param name="schema_no" select="$clause_no"/>
       <xsl:with-param name="clause" select="'interface'"/>
       <xsl:with-param name="schema_name" select="$schema_name"/>
     </xsl:call-template>
   </xsl:variable>

   
   <xsl:if test="$interface_clause != 0">
       &#160; &#160;

     <A HREF="./{$clause_no}_schema{$FILE_EXT}#interfaces">
         <xsl:value-of select="concat($clause_no,$interface_clause,
                               ' Interfaced schemas')"/>
       </A>
     <br/>
   </xsl:if>
-->
<!-- end of commented out section -->

   <!-- only output if there are constants defined and therefore a
        section -->
   <xsl:variable name="constant_clause">
     <xsl:call-template name="express_clause_present">
       <xsl:with-param name="schema_no" select="$clause_no"/>

       <xsl:with-param name="clause" select="'constant'"/>
       <xsl:with-param name="schema_name" select="$schema_name"/>
     </xsl:call-template>
   </xsl:variable>
   <xsl:if test="$constant_clause != 0">
       &#160; &#160;<A HREF="./{$clause_no}_schema{$FILE_EXT}#constants">
         <xsl:value-of select="concat($clause_no,$constant_clause,' ',$resource_display_name,
                               ' constant definitions')"/>
       </A>
     <br/>
     <xsl:apply-templates 
       select="$express_xml/express/schema/constant" mode="contents">
       <xsl:with-param name="clause_no" select="$clause_no" />
     </xsl:apply-templates>

   </xsl:if>

   <!-- only output if there are imported constants defined and 
        therefore a section -->
   <xsl:variable name="imported_constant_clause">
     <xsl:call-template name="express_clause_present">
       <xsl:with-param name="schema_no" select="$clause_no"/>

       <xsl:with-param name="clause" select="'imported_constant'"/>
       <xsl:with-param name="schema_name" select="$schema_name"/>
     </xsl:call-template>
   </xsl:variable>
   <xsl:if test="$imported_constant_clause != 0">
       &#160; &#160;<A HREF="./{$clause_no}_schema{$FILE_EXT}#imported_constant">
         <xsl:value-of select="concat($clause_no,$imported_constant_clause,' ',$resource_display_name,' imported constant modifications')"/>
       </A>
       <br/>
   </xsl:if>


   <!-- only output if there are types defined and therefore a
        section -->
   <xsl:variable name="type_clause">
     <xsl:call-template name="express_clause_present">
       <xsl:with-param name="schema_no" select="$clause_no"/>

       <xsl:with-param name="clause" select="'type'"/>
       <xsl:with-param name="schema_name" select="$schema_name"/>
     </xsl:call-template>
   </xsl:variable>

   <xsl:if test="$type_clause != 0">
       &#160; &#160;<A HREF="./{$clause_no}_schema{$FILE_EXT}#types">
         <xsl:value-of select="concat($clause_no,$type_clause,' ', $resource_display_name,
                               ' type definitions')"/>
       </A>
     <br/>    
     <xsl:apply-templates 
       select="$express_xml/express/schema/type" mode="contents">
       <xsl:with-param name="clause_no" select="$clause_no" />
     </xsl:apply-templates> 
   </xsl:if>

   <!-- only output if there are imported types defined and 
        therefore a section -->
   <xsl:variable name="imported_type_clause">
     <xsl:call-template name="express_clause_present">
       <xsl:with-param name="schema_no" select="$clause_no"/>

       <xsl:with-param name="clause" select="'imported_type'"/>
       <xsl:with-param name="schema_name" select="$schema_name"/>
     </xsl:call-template>
   </xsl:variable>
   <xsl:if test="$imported_type_clause != 0">
       &#160; &#160;<A HREF="./{$clause_no}_schema{$FILE_EXT}#imported_type">
         <xsl:value-of select="concat($clause_no,$imported_type_clause,' ',$resource_display_name,
                               ' imported type modifications')"/>
       </A>
       <br/>
   </xsl:if>


   <!-- only output if there are entitys defined and therefore a
        section -->
   <xsl:variable name="entity_clause">
     <xsl:call-template name="express_clause_present">
       <xsl:with-param name="schema_no" select="$clause_no"/>

       <xsl:with-param name="clause" select="'entity'"/>
       <xsl:with-param name="schema_name" select="$schema_name"/>
     </xsl:call-template>
   </xsl:variable>
   <xsl:if test="$entity_clause != 0">
       &#160; &#160;<A HREF="./{$clause_no}_schema{$FILE_EXT}#entities">
         <xsl:value-of select="concat($clause_no,$entity_clause,' ',
                               $resource_display_name,
                               ' entity definitions')"/>
       </A>
       <br/>

    <xsl:apply-templates 
       select="$express_xml/express/schema/entity" mode="contents">
       <xsl:with-param name="clause_no" select="$clause_no" />
     </xsl:apply-templates>

   </xsl:if>

   <!-- only output if there are imported entitys defined and 
        therefore a section -->
   <xsl:variable name="imported_entity_clause">
     <xsl:call-template name="express_clause_present">
       <xsl:with-param name="schema_no" select="$clause_no"/>

       <xsl:with-param name="clause" select="'imported_entity'"/>
       <xsl:with-param name="schema_name" select="$schema_name"/>
     </xsl:call-template>
   </xsl:variable>
   <xsl:if test="$imported_entity_clause != 0">
       &#160; &#160;<A HREF="./{$clause_no}_schema{$FILE_EXT}#imported_entity">
         <xsl:value-of select="concat($clause_no,$imported_entity_clause,' ',$resource_display_name,
                               ' imported entity modifications')"/>
       </A>
     <br/>
   </xsl:if>


   <!-- only output if there are subtype_constraints defined and therefore a
        section -->
   <xsl:variable name="subtype_constraint_clause">
     <xsl:call-template name="express_clause_present">
       <xsl:with-param name="schema_no" select="$clause_no"/>

       <xsl:with-param name="clause" select="'subtype.constraint'"/>
       <xsl:with-param name="schema_name" select="$schema_name"/>
     </xsl:call-template>
   </xsl:variable>
   <xsl:if test="$subtype_constraint_clause != 0">
       &#160; &#160;<A HREF="./{$clause_no}_schema{$FILE_EXT}#subtype_constraints">
         <xsl:value-of select="concat($clause_no,$subtype_constraint_clause,' ',$resource_display_name,
                               ' subtype constraint definitions')"/>
       </A>
       <br/>
    <xsl:apply-templates 
       select="$express_xml/express/schema/subtype.constraint" mode="contents">
       <xsl:with-param name="clause_no" select="$clause_no" />
     </xsl:apply-templates>
   </xsl:if>


   <!-- only output if there are functions defined and therefore a
        section -->
   <xsl:variable name="function_clause">
     <xsl:call-template name="express_clause_present">
       <xsl:with-param name="schema_no" select="$clause_no"/>

       <xsl:with-param name="clause" select="'function'"/>
       <xsl:with-param name="schema_name" select="$schema_name"/>
     </xsl:call-template>
   </xsl:variable>
   <xsl:if test="$function_clause !=0">
       &#160; &#160;<A HREF="./{$clause_no}_schema{$FILE_EXT}#functions">
         <xsl:value-of select="concat($clause_no,$function_clause,' ',$resource_display_name,
                               ' function definitions')"/>
       </A>
     <br/>
     <xsl:apply-templates 
       select="$express_xml/express/schema/function" mode="contents">
       <xsl:with-param name="clause_no" select="$clause_no" />
     </xsl:apply-templates>

   </xsl:if>
   <!-- only output if there are imported functions defined and 
        therefore a section -->
   <xsl:variable name="imported_function_clause">
     <xsl:call-template name="express_clause_present">
       <xsl:with-param name="schema_no" select="$clause_no"/>

       <xsl:with-param name="clause" select="'imported_function'"/>
       <xsl:with-param name="schema_name" select="$schema_name"/>
     </xsl:call-template>
   </xsl:variable>
   <xsl:if test="$imported_function_clause != 0">
       &#160; &#160;<A HREF="./{$clause_no}_schema{$FILE_EXT}#imported_function">
         <xsl:value-of select="concat($clause_no,$imported_function_clause,' ',$resource_display_name,
                               ' imported function modifications')"/>
       </A>
     <br/>
   </xsl:if>

   <!-- only output if there are rules defined and therefore a
        section -->
   <xsl:variable name="rule_clause">
     <xsl:call-template name="express_clause_present">
       <xsl:with-param name="schema_no" select="$clause_no"/>

       <xsl:with-param name="clause" select="'rule'"/>
       <xsl:with-param name="schema_name" select="$schema_name"/>
     </xsl:call-template>
   </xsl:variable>
   <xsl:if test="$rule_clause !=0">
       &#160; &#160;<A HREF="./{$clause_no}_schema{$FILE_EXT}#rules">
         <xsl:value-of select="concat($clause_no,$rule_clause,' ',$resource_display_name,
                               ' rule definitions')"/>
       </A>
       <br/>
    <xsl:apply-templates 
       select="$express_xml/express/schema/rule" mode="contents">
       <xsl:with-param name="clause_no" select="$clause_no" />
     </xsl:apply-templates>
   </xsl:if>
   <!-- only output if there are imported rules defined and 
        therefore a section -->
   <xsl:variable name="imported_rule_clause">
     <xsl:call-template name="express_clause_present">
       <xsl:with-param name="schema_no" select="$clause_no"/>

       <xsl:with-param name="clause" select="'imported_rule'"/>
       <xsl:with-param name="schema_name" select="$schema_name"/>
     </xsl:call-template>
   </xsl:variable>
   <xsl:if test="$imported_rule_clause != 0">
       &#160; &#160;<A HREF="./{$clause_no}_schema{$FILE_EXT}#imported_rule">
         <xsl:value-of select="concat($clause_no,$imported_rule_clause,' ',$resource_display_name,
                               ' imported rule modifications')"/>
       </A>
       <br/>
   </xsl:if>

   <!-- only output if there are procedures defined and therefore a
        section -->
   <xsl:variable name="procedure_clause">
     <xsl:call-template name="express_clause_present">
       <xsl:with-param name="schema_no" select="$clause_no"/>

       <xsl:with-param name="clause" select="'procedure'"/>
       <xsl:with-param name="schema_name" select="$schema_name"/>
     </xsl:call-template>
   </xsl:variable>
   <xsl:if test="$procedure_clause != 0">
       &#160; &#160;<A HREF="./{$clause_no}_schema{$FILE_EXT}#procedures">
         <xsl:value-of select="concat($clause_no,$procedure_clause,' ',$resource_display_name,
                               ' procedure definitions')"/>
       </A>
     <br/>
     <xsl:apply-templates 
       select="$express_xml/express/schema/procedure" mode="contents">
       <xsl:with-param name="clause_no" select="$clause_no" />
     </xsl:apply-templates>
   </xsl:if>
   <!-- only output if there are imported procedures defined and 
        therefore a section -->
   <xsl:variable name="imported_procedure_clause">
     <xsl:call-template name="express_clause_present">
       <xsl:with-param name="schema_no" select="$clause_no"/>
       <xsl:with-param name="clause" select="'imported_procedure'"/>
       <xsl:with-param name="schema_name" select="$schema_name"/>
     </xsl:call-template>
   </xsl:variable>
   <xsl:if test="$imported_procedure_clause != 0">
       &#160; &#160;<A HREF="./{$clause_no}_schema{$FILE_EXT}#imported_procedure">
         <xsl:value-of select="concat($clause_no,$imported_procedure_clause,' ',$resource_display_name,
                               ' imported procedure modifications')"/>
       </A>
     <br/>
   </xsl:if>
 </xsl:template>


 <xsl:template match="resource" mode="copyright">
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

</xsl:stylesheet>
