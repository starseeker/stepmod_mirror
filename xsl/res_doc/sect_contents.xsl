<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_contents.xsl,v 1.2 2002/10/28 04:53:41 thendrix Exp $
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

   <xsl:message >
     resdoc_dir :<xsl:value-of select="$resdoc_dir"/>
   </xsl:message>

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

   <xsl:if test="count(schema)>0" >
     <xsl:for-each select="./schema">          
       <xsl:call-template name="toc_schema_section">
         <xsl:with-param name="clause_no" select="position()+3" />
         <xsl:with-param name="resdoc_root" select="$resdoc_root"/>
       </xsl:call-template>
     </xsl:for-each>
   </xsl:if>

   <!-- use #annexa to link direct -->
   <p class="content">
     <A HREF="./a_short_names{$FILE_EXT}">A Short names of entities
     short names</A>
   </p>
   <!-- use #annexb to link direct -->
   <p class="content">
     <A HREF="./b_obj_reg{$FILE_EXT}">B Information requirements object
     registration</A>
   </p>

   <!-- use #annexc to link direct -->
   <p class="content">
     <A HREF="./c_exp{$FILE_EXT}">C Computer interpretable listings</A>
   </p>

   <!-- use #annexd to link direct -->
   <p class="content">
     <A HREF="./d_expg{$FILE_EXT}">D EXPRESS-G diagrams</A>
   </p>

   <xsl:if test="./usage_guide">
     <!-- use #annexa to link direct -->
     <p class="content">
       <A HREF="./f_guide{$FILE_EXT}">
         F  
       </A>
     </p>
   </xsl:if>
   <A HREF="./biblio{$FILE_EXT}#bibliography">Bibliography</A>

 </xsl:template>

 <xsl:template match="constant|type|entity|subtype.constraint|rule|procedure|function" 
   mode="contents">
   <xsl:param name="clause_no"/>
   <xsl:variable name="node_type" select="name(.)"/>
   <xsl:variable name="schema_name" select="../@name"/>

   <xsl:message>
     schema_name :<xsl:value-of select="$schema_name"/>
   </xsl:message>

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

   <p class="content">
     &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
     <A HREF="{$xref}">
       <xsl:value-of select="concat($clause_number, '.', position(), ' ', @name)"/>
     </A>
   </p>
 </xsl:template>

 <xsl:template match="imgfile" mode="expressg_figure">
   <!--   <xsl:param name="file"/>
   <xsl:if test="$file=@file">  
-->
     <xsl:variable name="number">
       <xsl:number/>
     </xsl:variable>
     <xsl:variable name="fig_no">
       <xsl:choose>
         <xsl:when test="contains(@file,'schema_diag')">
           <xsl:value-of 
             select="concat('Figure',$number, 
                         ' &#8212; Schema interface diagram of schemas specified in this standard')"/>
             </xsl:when>

         <xsl:when test="contains(@file,'schemaexpg')">
           <xsl:variable name="schname" select="substring-before(@file,'expg')" />
           <xsl:choose>
             <xsl:when test="$number=1">
               <xsl:value-of 
                 select="concat('Figure D.',$number, 
                         ' &#8212; Entity level diagram of ', $schname, '( page ', $number,' )' )" />
             </xsl:when>
             <xsl:otherwise>
               <xsl:value-of 
                 select="concat('Figure D.',$number, 
                         ' &#8212; Entity level diagram of ', $schname, ($number - 1)) "/>
             </xsl:otherwise>
           </xsl:choose>
         </xsl:when>
         <xsl:otherwise>
                       <xsl:value-of 
               select="concat('Figure  1. ',
                       ' &#8212; The relationship of schemas of this part to the standard ISO 10303 integration architecture')" />
         </xsl:otherwise>
       </xsl:choose>
     </xsl:variable>
     <xsl:value-of select="$fig_no"/>
     <!--   </xsl:if> -->
 </xsl:template>



 <!-- list an index the tables and figures -->
 <xsl:template match="resource" mode="contents_tables_figures">

   <xsl:variable name="resdoc_dir">
     <xsl:call-template name="resdoc_directory">
       <xsl:with-param name="resdoc" select="@name"/>
     </xsl:call-template>
   </xsl:variable>


   <h3>Tables</h3>
   <xsl:apply-templates select="//table" mode="toc"/>
   <h3>Figures</h3>
   <!-- collect up the figures from the Module -->
   <xsl:apply-templates select="./purpose//figure" mode="toc"/>
   <xsl:apply-templates select="./inscope//figure" mode="toc"/>
   <xsl:apply-templates select="./outscope//figure" mode="toc"/>
   <!-- collect up the EXpressG figures from the schemas -->
   <xsl:apply-templates 
     select="./schema/imgfile" mode="expressg_figure"/>
   <xsl:apply-templates select="./usage_guide//figure" mode="toc"/>
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

   <p class="content">
     <a href="{$href}">      
     <xsl:value-of 
       select="concat($table_or_fig,' ',$number, ' &#8212; ', ./title)"/>
     </a>
   </p>

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

   <xsl:variable name="express_xml">
     <xsl:value-of select="concat($resource_dir,'/',$resource_name,'_schema.xml')" />
   </xsl:variable>

   <!--   <xsl:variable name="clause_no" select="$clause_no"/> -->
   <xsl:variable name="schema_name" select="@name"/>
   <xsl:message >  
     schema_name :<xsl:value-of select="$schema_name" />
 clause_no :<xsl:value-of select="$clause_no" />
     </xsl:message>
   <p class="content">
     <A HREF="./{$clause_no}_schema{$FILE_EXT}"> 
     <xsl:value-of select="concat($clause_no,' ',$resource_display_name)"/></A>
   </p>

   <p>
   &#160;&#160;<A HREF="./{$clause_no}_schema{$FILE_EXT}#intro">
           <xsl:value-of select="concat(string($clause_no),'.1 Introduction')"/>
           </A><BR/>

           <!-- fundamental concepts - seems to always be there -->
           </p><p>
           &#160;&#160;<A HREF="./{$clause_no}_schema{$FILE_EXT}#funcon">
           <xsl:value-of select="concat($clause_no,'.2 Fundamental concepts and assumptions')"/>
           </A><BR/>
 </p>
   <!-- only output if there are interfaces defined and therefore a
        section -->

   <xsl:variable name="interface_clause">
     <xsl:call-template name="express_clause_present">
       <xsl:with-param name="schema_no" select="$clause_no"/>
       <xsl:with-param name="clause" select="'interface'"/>
       <xsl:with-param name="schema_name" select="$schema_name"/>
     </xsl:call-template>
   </xsl:variable>
   <xsl:if test="$interface_clause != 0">
     <p class="content">
       &#160; &#160;

     <A HREF="./{$clause_no}_schema{$FILE_EXT}#interfaces">
         <xsl:value-of select="concat($interface_clause,
                               ' Interfaced schemas')"/>
       </A>
     </p>
   </xsl:if>

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
     <p class="content">
       &#160; &#160;
       <A HREF="./{$clause_no}_schema{$FILE_EXT}#constants">
         <xsl:value-of select="concat($constant_clause,$resource_display_name,
                               ' constant definitions')"/>
       </A>
     </p>
     <xsl:apply-templates 
       select="document($express_xml)/express/schema/constant" mode="contents">
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
     <p class="content">
       &#160; &#160;
       <A HREF="./{$clause_no}_schema{$FILE_EXT}#imported_constant">
         <xsl:value-of select="concat($imported_constant_clause,$resource_display_name,' imported constant modifications')"/>
       </A>
     </p>
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
     <p class="content">
       &#160; &#160;
       <A HREF="./{$clause_no}_schema{$FILE_EXT}#types">
         <xsl:value-of select="concat($type_clause, $resource_display_name,
                               ' type definitions')"/>
       </A>
     </p>    
     <!--    <xsl:apply-templates 
       select="document($express_xml)/express/schema/constant" mode="contents">
       <xsl:with-param name="clause_no" select="$clause_no" />
     </xsl:apply-templates> -->
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
     <p class="content">
       &#160; &#160; 
       <A HREF="./{$clause_no}_schema{$FILE_EXT}#imported_type">
         <xsl:value-of select="concat($imported_type_clause,$resource_display_name,
                               ' imported type modifications')"/>
       </A>
     </p>
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
     <p class="content">
       &#160; &#160;
       <A HREF="./{$clause_no}_schema{$FILE_EXT}#entities">
         <xsl:value-of select="concat($entity_clause,
                               $resource_display_name,
                               ' entity definitions')"/>
       </A>
     </p>
     <!--    <xsl:apply-templates 
       select="document($express_xml)/express/schema/constant" mode="contents">
       <xsl:with-param name="clause_no" select="$clause_no" />
     </xsl:apply-templates>
 -->
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
     <p class="content">
       &#160; &#160;
       <A HREF="./{$clause_no}_schema{$FILE_EXT}#imported_entity">
         <xsl:value-of select="concat($imported_entity_clause,$resource_display_name,
                               ' imported entity modifications')"/>
       </A>
     </p>
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
     <p class="content">
       &#160; &#160;
       <A HREF="./{$clause_no}_schema{$FILE_EXT}#subtype_constraints">
         <xsl:value-of select="concat($subtype_constraint_clause,$resource_display_name,
                               ' subtype constraint definitions')"/>
       </A>
     </p>
     <!--    <xsl:apply-templates 
       select="document($express_xml)/express/schema/constant" mode="contents">
       <xsl:with-param name="clause_no" select="$clause_no" />
     </xsl:apply-templates>
 -->
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
     <p class="content">
       &#160; &#160;
       <A HREF="./{$clause_no}_schema{$FILE_EXT}#functions">
         <xsl:value-of select="concat($function_clause,$resource_display_name,
                               ' function definitions')"/>
       </A>
     </p>
     <!--    <xsl:apply-templates 
       select="document($express_xml)/express/schema/constant" mode="contents">
       <xsl:with-param name="clause_no" select="$clause_no" />
     </xsl:apply-templates>
 -->
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
     <p class="content">
       &#160; &#160;
       <A HREF="./{$clause_no}_schema{$FILE_EXT}#imported_function">
         <xsl:value-of select="concat($imported_function_clause,$resource_display_name,
                               ' imported function modifications')"/>
       </A>
     </p>
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
     <p class="content">
       &#160; &#160;
       <A HREF="./{$clause_no}_schema{$FILE_EXT}#rules">
         <xsl:value-of select="concat($rule_clause,$resource_display_name,
                               ' rule definitions')"/>
       </A>
     </p>
     <!--    <xsl:apply-templates 
       select="document($express_xml)/express/schema/constant" mode="contents">
       <xsl:with-param name="clause_no" select="$clause_no" />
     </xsl:apply-templates>
 -->
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
     <p class="content">
       &#160; &#160;
       <A HREF="./{$clause_no}_schema{$FILE_EXT}#imported_rule">
         <xsl:value-of select="concat($imported_rule_clause,$resource_display_name,
                               ' imported rule modifications')"/>
       </A>
     </p>
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
     <p class="content">
       &#160; &#160;
       <A HREF="./{$clause_no}_schema{$FILE_EXT}#procedures">
         <xsl:value-of select="concat($procedure_clause,$resource_display_name,
                               ' procedure definitions')"/>
       </A>
     </p>
     <xsl:apply-templates 
       select="document($express_xml)/express/schema/constant" mode="contents">
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
     <p class="content">
       &#160; &#160;
       <A HREF="./{$clause_no}_schema{$FILE_EXT}#imported_procedure">
         <xsl:value-of select="concat($imported_procedure_clause,$resource_display_name,
                               ' imported procedure modifications')"/>
       </A>
     </p>
   </xsl:if>
 </xsl:template>


 <xsl:template match="resource" mode="copyright">
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