<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_3_defs.xsl,v 1.2 2013/02/06 07:57:42 nigelshaw Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep Limited.
  Purpose: Display definitions for a BOM.     
-->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		xmlns:exslt="http://exslt.org/common"
    exclude-result-prefixes="msxsl exslt"
    version="1.0"
>
  <xsl:import href="business_object_model.xsl"/>
  <xsl:import href="business_object_model_clause_nofooter.xsl"/> 
  <xsl:output method="html"/>
	
  <xsl:template match="business_object_model">
  <!--
       ISO requested:
       - If clause 3 only contains terms and definitions, the title of the
         clause shall be "Terms and definitions". 

       - If clause 3 only contains terms, definitions, and abbreviations,
         the title of the clause shall be "Terms, definitions, and abbreviations". 

       - If clause 3 only contains terms, definitions, and symbols, the
          title of the clause shall be "Terms, definitions, and symbols". 

       - If clause 3 contains terms, definitions, abbreviations, and
         symbols, the title of the clause shall be "Terms, definitions,
         abbreviations, and symbols".  
       -->

    <h2>
      <a name="defns">
        <xsl:choose>
          <xsl:when test="./definition/term">
            3 Terms, definitions and abbreviated terms
          </xsl:when>
          <xsl:otherwise>
          <!-- every AP references Terms defined in other standards,
               and abbreviations hence as per ISO -->
          3 Terms, definitions and abbreviated terms
          </xsl:otherwise>
        </xsl:choose>
      </a>
    </h2>
    
    <xsl:if test="./definition/term">
      <h2>
        <a name="termsdefns">
          3.1 Terms and definitions
        </a>        
      </h2>
    </xsl:if>
    <xsl:apply-templates select="." mode="output_terms"/>
  </xsl:template>
	
<!-- output the normative references, terms, definitions and abbreviated terms -->
<xsl:template match="business_object_model" mode="output_terms">

  <!-- output any issues -->
 <!--<xsl:apply-templates select="." mode="output_clause_issue">
    <xsl:with-param name="clause" select="'definition'"/>
  </xsl:apply-templates>-->

  <!-- get a list of normative references that have terms defined -->
  <xsl:variable name="normrefs">
    <xsl:apply-templates select="." mode="normrefs_terms_list"/>
  </xsl:variable>

<!-- output the included terms -->
  <xsl:call-template name="output_normrefs_terms_rec">
    <xsl:with-param name="normrefs" select="$normrefs"/>
    <xsl:with-param name="normref_ids" select="$normrefs"/>
    <xsl:with-param name="section" select="0"/>
    <xsl:with-param name="model_number" select="./@part"/>
  </xsl:call-template>

<xsl:variable name="def_section">
    <xsl:call-template name="length_normrefs_list">
      <xsl:with-param name="module_number" select="./@part"/>
      <xsl:with-param name="normrefs_list" select="$normrefs"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- output any definitions defined in this ap -->
<!-- abf this section heading needs to print regardless. There are default defs included
abf 20100317 update - looks like these defs will be added to part 1 so put if test back
in -->
  <xsl:if test="./definition"> 
    <!-- output the section head first -->
    <xsl:call-template name="output_module_term_section">
      <xsl:with-param name="module" select="."/>
      <xsl:with-param name="section" select="concat('3.1.',$def_section+1)"/>
    </xsl:call-template>
    <!-- RBN Changed due to request from ISO
    For the purposes of this part of ISO 10303, -->
    For the purposes of this document, 
    the following terms and definitions apply:
  </xsl:if>

  <!-- increment the section number depending on whether a definition
       section has been output 
abf changed so that section number is incremented regardless of whether there are locally defined definitions.  default definitions are included and require a header and incremented section number 
abf 20100317 changing back, default definitions removed -->
  <xsl:variable name="def_section1">
    <xsl:choose>
      <xsl:when test="/business_object_model/definition">
        <xsl:value-of select="$def_section+1"/>
      </xsl:when> 
      <xsl:otherwise>
        <xsl:value-of select="$def_section"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
<!--  definitions originally defined in 1001 and 1017 must have been included in part 1 update, commented out here 
  <xsl:variable name="definitions_common">
    <xsl:element name="definition">
      <xsl:element name="term">
        <xsl:attribute name="id">module_interpreted_model</xsl:attribute>
        module interpreted model
      </xsl:element>
      <xsl:element name="def">
        information model that uses the common resources necessary to satisfy the information requirements and constraints of an application reference model, within an application module
      </xsl:element>
    </xsl:element>

    <xsl:element name="definition">
      <xsl:element name="term">
        <xsl:attribute name="id">application_module</xsl:attribute>
        application module
      </xsl:element>
      <xsl:element name="def">
        reusable collection of a scope statement, information requirements, mappings and module interpreted model that supports a specific usage of product data across multiple application contexts
      </xsl:element>
    </xsl:element>

    <xsl:element name="definition">
      <xsl:element name="term">
        <xsl:attribute name="id">common_resources</xsl:attribute>
        common resources
      </xsl:element>
      <xsl:element name="def">
        a collection of information models, specified in EXPRESS language, that can be reused to specify application specific information models within the domain of industrial data
		<xsl:element name="note">
		  <xsl:attribute name="number">1</xsl:attribute>
		  The resource constructs defined by application modules are those defined in their MIM schema.
		</xsl:element>        
      </xsl:element>
    </xsl:element>
    
  </xsl:variable>
-->
<!--  abf 20100317 removed - common definitions no longer included 
xsl:choose>
    <xsl:when test="function-available('msxsl:node-set')">
      <xsl:variable name="definitions_common_node_set" select="msxsl:node-set($definitions_common)"/> 
      <xsl:variable name="temp" select="/business_object_model|$definitions_common_node_set"/>
	  <xsl:apply-templates select="$temp/definition" >
abf 20100317 replaced above with following statement -->
	  <xsl:apply-templates select="/business_object_model/definition" >
	    <xsl:with-param name="section" select="concat('3.1.',$def_section1)"/>
	    <xsl:sort select="term"/>
	  </xsl:apply-templates>
<!-- abf 20100317 removed - common definitions no longer included
    </xsl:when>
    <xsl:when test="function-available('exslt:node-set')">
      <xsl:variable name="definitions_common_node_set" select="exslt:node-set($definitions_common)"/>
      <xsl:variable name="temp" select="/business_object_model|$definitions_common_node_set"/>
	  <xsl:apply-templates select="$temp/definition" >
	    <xsl:with-param name="section" select="concat('3.1.',$def_section1)"/>
	    <xsl:sort select="term"/>
	  </xsl:apply-templates>
    </xsl:when>
  </xsl:choose>  
-->
  <xsl:call-template name="output_abbreviations">
    <xsl:with-param name="section" select="$def_section1+1"/>
  </xsl:call-template>
  
</xsl:template>

<!-- Given a list of normative references, output any terms from them -->
<xsl:template name="output_normrefs_terms_rec">
  <xsl:param name="normrefs"/>
  <xsl:param name="normref_ids"/>
  <xsl:param name="section"/>
  <xsl:param name="model_number"/>

  <xsl:choose>
    <xsl:when test="$normrefs">

      <xsl:variable name="first" select="substring-before(substring-after($normrefs,','),',')"/>
      <xsl:variable name="section_no" select="$section+1"/>
      <xsl:variable name="rest" select="substring-after(substring-after($normrefs,','),',')"/>      

      <xsl:choose>
        <xsl:when test="contains($first,'normref:')">
          <xsl:variable name="ref" select="substring-after($first,'normref:')"/>
          <xsl:variable name="normref" select="document('../../data/basic/normrefs.xml')/normref.list/normref[@id=$ref]"/>
          <!-- get the number of the standard -->      
          <xsl:variable name="stdnumber" select="concat($normref/stdref/orgname, ' ',$normref/stdref/stdnumber)"/>
          <!-- output the section header for the normative reference that is
               defining terms 
               IGNORE if the normative ref is referring to this module
               -->
          <!-- normref stdnumber are 10303-1107 whereas module numbers are
               1107, so remove the 10303- -->
          <xsl:variable name="part_no" select="substring-after($normref/stdref/stdnumber,'-')"/>
          <xsl:if test="$model_number!=$part_no">
            <h2>
            <xsl:value-of select="concat('3.1.',$section_no, ' Terms defined in ',$stdnumber)"/>
            </h2>
            <p>
              <!-- RBN Changed due to request from ISO
                   For the purposes of this part of ISO 10303, -->
              For the purposes of this document,
              the following terms defined in 
              <xsl:value-of select="$stdnumber"/>
              apply:
            </p>
            <ul>
              <!-- now output the terms -->
              <xsl:apply-templates select="document('../../data/basic/bom_doc/normrefs_default.xml')/normrefs/normref.inc[@normref=$ref]/term.ref" mode="normref"/>
              <!-- check to see if any terms from the same normref are identified in bom -->
              <xsl:apply-templates select="/business_object_model/normrefs/normref.inc[@normref=$ref]/term.ref" mode="normref"/>
              <xsl:apply-templates select="/business_object_model/normrefs/normref.inc" mode="normref_check"/>
            </ul>
          </xsl:if>
        </xsl:when>
          
        <!-- a term defined in another module -->
        <xsl:when test="contains($first,'module:')">
          <xsl:variable 
            name="module" 
            select="substring-after($first,'module:')"/>

          <xsl:variable name="module_dir" 
            select="concat('../../data/modules/',$module)"/>

          <xsl:variable name="module_ok">
            <xsl:call-template name="check_module_exists">
              <xsl:with-param name="module" select="$module"/>
            </xsl:call-template>
          </xsl:variable>

          <xsl:choose>
            <xsl:when test="$module_ok='true'">
              <xsl:variable name="module_xml" 
                select="concat($module_dir,'/module.xml')"/>
              <xsl:variable name="normrefid"
                select="concat('10303-',document($module_xml)/module/@part)"/>
              <!-- check to see if the terms for the module have been output
                   as part of normative references -->
              <xsl:if test="not(contains($normref_ids,$normrefid))">
                <xsl:variable name="module_node" select="document($module_xml)/module"/>
                <xsl:variable name="stdnumber"
                  select="concat('ISO/',$module_node/@status,'&#160;10303-',$module_node/@part)"/>

                
                <!-- output the section header for the normative reference
                     that is defining terms -->              
                <h2>
                  <xsl:value-of select="concat('3.1.',$section_no,
                                        ' Terms defined in ', $stdnumber)"/>
                </h2>
                <p>
                  <!-- RBN Changed due to request from ISO
                  For the purposes of this part of ISO 10303, -->
                  For the purposes of this document,
                  the following terms defined in 
                  <xsl:value-of select="$stdnumber"/>
                  apply:
                </p>
                <ul>
                  <!-- now output the terms -->
                  <xsl:apply-templates 
                    select="/business_object_model/normrefs/normref.inc[@module.name=$module]/term.ref" 
                    mode="module"/>
                </ul>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="error_message">
                <xsl:with-param name="message">
                  <xsl:value-of select="concat('Error ref 2: ',
$module_ok,' Check the normatives references')"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>

        <xsl:when test="contains($first,'resource:')">
          <xsl:variable name="resource" select="substring-after($first,'resource:')"/>
          <!-- should never get here -->
        </xsl:when>
      </xsl:choose>

      <xsl:call-template name="output_normrefs_terms_rec">
        <xsl:with-param name="normrefs" select="$rest"/>
        <xsl:with-param name="normref_ids" select="$normref_ids"/>
        <xsl:with-param name="section" select="$section_no"/>
        <xsl:with-param name="model_number" select="$model_number"/>
      </xsl:call-template>

    </xsl:when>
    <xsl:otherwise>
      <!-- end of recursion -->
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<!-- output the section header for terms defined in a module -->
<xsl:template name="output_module_term_section">
  <xsl:param name="module"/>
  <xsl:param name="section"/>
  
  <xsl:variable name="stdnumber" 
    select="concat('ISO/',$module/@status,'&#160;10303-',$module/@part)"/>


  <h2>
    <xsl:value-of select="concat($section,' Other terms and definitions')"/>
    <!--
    <xsl:value-of select="concat($section,' Terms defined in',$stdnumber)"/>
    -->
</h2>

  </xsl:template>


<!-- return the number of normrefs in the list -->
<xsl:template name="length_normrefs_list">
  <xsl:param name="normrefs_list"/>
  <xsl:param name="module_number"/>
  <!-- check if the current module is included.
       If so, remove the reference -->
  <xsl:variable name="pruned_normrefs_list">
    <xsl:call-template name="remove_module_from_normrefs_list">
      <xsl:with-param name="normrefs_list" select="$normrefs_list"/>
      <xsl:with-param name="module_number" select="$module_number"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="section1">
    <xsl:call-template name="count_substring">
      <xsl:with-param name="substring" select="','"/>
      <xsl:with-param name="string" select="$pruned_normrefs_list"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="floor($section1 div 2)"/>
</xsl:template>


<!-- build a list of normrefs that are used by the module and have terms
     defined in them 
     The list comprises:
     All default normrefs listed in ../data/basic/normrefs.xml
     All normrefs explicitly included in the module by normref.inc
-->
<xsl:template match="business_object_model" mode="normrefs_terms_list">

  <!-- get all default normrefs listed in ../../data/basic/normrefs.xml -->
  <xsl:variable name="normref_list1">
    <xsl:call-template name="get_normref_term">
      <xsl:with-param name="normref_nodes" select="document('../../data/basic/bom_doc/normrefs_default.xml')/normrefs/normref.inc"/>
      <xsl:with-param name="normref_list" select="''"/>
    </xsl:call-template>    
  </xsl:variable>

  <!-- get all normrefs explicitly included in the module by normref.inc -->
  <xsl:variable name="normref_list2">
    <xsl:call-template name="get_normref_term">
      <xsl:with-param name="normref_nodes" select="./normrefs/normref.inc"/>
      <xsl:with-param name="normref_list" select="$normref_list1"/>
    </xsl:call-template>    
  </xsl:variable>

  <xsl:value-of select="concat($normref_list2,',')"/>

</xsl:template>

<!-- given a list of normref nodes, add the ids of the normrefs to the
     normref_list, if not already a member. ids in normref_list are
     separated by a , -->
<xsl:template name="get_normref_term">
  <xsl:param name="normref_nodes"/>
  <xsl:param name="normref_list"/>
  
  <xsl:variable name="normref_list_ret">
    <xsl:choose>
      <xsl:when test="$normref_nodes">
        <xsl:choose>
          <xsl:when test="$normref_nodes[1]/term.ref">
            <!-- only add the normref if it is defining terms -->
            <xsl:variable name="first">
              <xsl:choose>
                <xsl:when test="$normref_nodes[1]/@normref">
                  <xsl:value-of 
                    select="concat('normref:',$normref_nodes[1]/@normref)"/>
                </xsl:when>
                <xsl:when test="$normref_nodes[1]/@module.name">
                  <xsl:value-of 
                    select="concat('module:',$normref_nodes[1]/@module.name)"/>
                </xsl:when>            
                <xsl:when test="$normref_nodes[1]/@resource.name">
                  <xsl:value-of 
                    select="concat('module:',$normref_nodes[1]/@resource.name)"/>
                </xsl:when>            
              </xsl:choose>
            </xsl:variable>
            
            <xsl:variable name="normref_list1">
              <xsl:call-template name="add_normref">
                <xsl:with-param name="normref" select="$first"/>
                <xsl:with-param name="normref_list" select="$normref_list"/>
              </xsl:call-template>
            </xsl:variable>
            
            <xsl:call-template name="get_normref_term">
              <xsl:with-param 
                name="normref_nodes" 
                select="$normref_nodes[position()!=1]"/>
              <xsl:with-param 
                name="normref_list" 
                select="$normref_list1"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="get_normref_term">
              <xsl:with-param 
                name="normref_nodes" 
                select="$normref_nodes[position()!=1]"/>
              <xsl:with-param 
                name="normref_list" 
                select="$normref_list"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!-- end of recursion -->
        <xsl:value-of select="$normref_list"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$normref_list_ret"/>
</xsl:template>

<!-- add a normref id to the set of normref ids. -->
<xsl:template name="add_normref">
  <xsl:param name="normref"/>
  <xsl:param name="normref_list"/>
  <!-- end the list with a , -->
  <xsl:variable name="normref_list_term"
    select="concat($normref_list,',')"/>
  <xsl:variable name="normref_list1">
    <xsl:choose>
      <xsl:when test="contains($normref_list_term, concat(',',$normref,','))">
        <xsl:value-of select="$normref_list"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat($normref_list,',',$normref,',')"/>      
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$normref_list1"/>
</xsl:template>


<!-- Given the name of a module, check if there is a corresponding
     normative reference there. If so, remove it. -->
<xsl:template name="remove_module_from_normrefs_list">
  <xsl:param name="normrefs_list"/>
  <xsl:param name="module_number"/>

  <xsl:variable name="nref" 
    select="concat(',normref:ref10303-',$module_number)"/>

  <xsl:variable name="pruned_normrefs_list">
    <xsl:choose>
      <xsl:when test="contains($normrefs_list,$nref)">
        <xsl:variable 
          name="before" 
          select="substring-before($normrefs_list,$nref)"/>
        <xsl:variable 
          name="after" 
          select="substring-after(substring-after($normrefs_list,$nref),',')"/>
        <xsl:value-of select="concat($before,$after)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$normrefs_list"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$pruned_normrefs_list"/>
</xsl:template>


<!-- Output the standard set of abbreviations and then any added by
     the module
     -->
<xsl:template name="output_abbreviations">
  <xsl:param name="section"/>
  <h2>
    <a name="abbrvterms">3.2 Abbreviated terms</a>
      <!--<xsl:value-of select="concat('3.2.',$section)"/> Abbreviated terms-->
  </h2>

  <!-- output any issues -->
  <!--<xsl:apply-templates select="." mode="output_clause_issue">
    <xsl:with-param name="clause" select="'abbreviations'"/>
  </xsl:apply-templates>-->


  <p>
    <!-- RBN Changed due to request from ISO 
         For the purposes of this part of ISO 10303, -->
    For the purposes of this document,
    the following abbreviated terms apply:
  </p>
  <!-- get the default abbreviations out of the abbreviations_default.xml
       database -->
  <xsl:variable name="abbr_inc" select="document('../../data/basic/bom_doc/abbreviations_default.xml')/abbreviations"/>

  <xsl:variable name="abbrevs">
    <abbrevs>
      <xsl:apply-templates select="$abbr_inc/abbreviation.inc" mode="abbr_node"/>
      <xsl:apply-templates select="/business_object_model/abbreviations" mode="abbr_node"/>  
    </abbrevs>
  </xsl:variable>

  <table width="80%">
    <xsl:choose>
      <xsl:when test="function-available('msxsl:node-set')">
        <xsl:variable name="abbrevs_nodes" select="msxsl:node-set($abbrevs)"/>
        <xsl:apply-templates select="$abbrevs_nodes/abbrevs/*">
          <xsl:sort select="@acronym"/>
        </xsl:apply-templates> 
      </xsl:when>

      <xsl:when test="function-available('exslt:node-set')">
        <xsl:variable name="abbrevs_nodes" select="exslt:node-set($abbrevs)"/>
        <xsl:apply-templates select="$abbrevs_nodes/abbrevs/*">
          <xsl:sort select="@acronym"/>
        </xsl:apply-templates>
      </xsl:when>
    </xsl:choose>
  </table>
</xsl:template>

<xsl:template match="abbreviation.inc"  mode="abbr_node">
  <xsl:variable name="ref" select="@linkend"/>
  <xsl:variable 
    name="abbrev" 
    select="document('../../data/basic/abbreviations.xml')/abbreviation.list/abbreviation[@id=$ref]"/>
  <xsl:if test="$abbrev">
    <abbreviation.inc>
      <xsl:attribute name="acronym">
        <xsl:value-of select="normalize-space($abbrev/acronym)"/>
      </xsl:attribute>
      <xsl:attribute name="linkend">
        <xsl:value-of select="$ref"/>
      </xsl:attribute>
    </abbreviation.inc>
  </xsl:if>
</xsl:template>

<xsl:template match="abbreviation"  mode="abbr_node">
  <abbreviation>
    <xsl:attribute name="acronym">
      <xsl:value-of select="normalize-space(./acronym)"/>
    </xsl:attribute>   
    <xsl:copy-of select="*"/>
  </abbreviation>
</xsl:template>


  <xsl:template match="term.ref"  mode="normref">
    <xsl:variable 
      name="ref"
      select="@linkend"/>
    <xsl:variable 
      name="term"
      select="document('../../data/basic/normrefs.xml')/normref.list/normref/term[@id=$ref]"/>
    <xsl:choose>
      <xsl:when test="$term">
        <xsl:choose>
          <xsl:when test="position()=last()">
            <li><xsl:apply-templates select="$term"/>.</li>
          </xsl:when>
          <xsl:otherwise>
            <li><xsl:apply-templates select="$term"/>;</li>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <li><xsl:call-template name="error_message">
            <xsl:with-param 
              name="message"
              select="concat('Error 12: Can not find term referenced by: ',$ref)"/>
          </xsl:call-template>
        </li>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="term.ref" mode="module">
    <xsl:variable name="module" select="../@module.name"/>

    <xsl:variable name="module_dir" select="concat('../../data/modules/',$module)"/>

    <xsl:variable name="module_ok">
      <xsl:call-template name="check_module_exists">
        <xsl:with-param name="module" select="$module"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="module_xml" 
      select="concat($module_dir,'/module.xml')"/>
    <xsl:choose>
      <xsl:when test="$module_ok='true'">
        <xsl:variable 
          name="ref"
          select="@linkend"/>
        <xsl:variable 
          name="term"
          select="document($module_xml)/module/definition/term[@id=$ref]"/>
        <!-- note any synonym is ignored -->
        <xsl:choose>
          <xsl:when test="$term">
            <xsl:variable name="nterm" select="normalize-space($term)"/>
            <xsl:choose>
              <xsl:when test="position()=last()">
                <li><xsl:value-of select="$nterm"/>.</li>
              </xsl:when>
              <xsl:otherwise>
                <li><xsl:value-of select="$nterm"/>;</li>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <li>
              <xsl:call-template name="error_message">
                <xsl:with-param 
                  name="message"
                  select="concat('Error 11: Can not find term referenced by: ',$ref)"/>
              </xsl:call-template>
            </li>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="error_message">
          <xsl:with-param name="message">
            <xsl:value-of select="concat('Error ref1: ', $module_ok)"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!-- output the abbreviation. The term is defined in the normative
     references -->
<xsl:template match="abbreviation">
  <tr>
    <td>
      <xsl:value-of select="acronym"/>
    </td>
    <td>
      <xsl:apply-templates select="./term" mode="abbreviation"/>
      <xsl:apply-templates select="term.ref" mode="abbreviation"/>
    </td>
  </tr>
</xsl:template>

  <!-- output any terms that are defined in normref.inc that is referring
       to a module through @module.name where the module has the same
       number as module_number -->
  <xsl:template match="normref.inc"  mode="normref_check">
    <xsl:param name="module_number"/>
    <xsl:variable name="module" select="@module.name"/>

    <xsl:if test="string-length($module)>0">
      <xsl:variable name="module_ok">
        <xsl:call-template name="check_module_exists">
          <xsl:with-param name="module" select="$module"/>
        </xsl:call-template>
      </xsl:variable>
      
      <xsl:choose>
        <xsl:when test="$module_ok='true'">
          <xsl:variable name="module_dir" select="concat('../../data/modules/',$module)"/>
          <xsl:variable name="module_xml" 
            select="concat($module_dir,'/module.xml')"/>
          <xsl:variable name="part"
            select="document($module_xml)/module/@part"/>
          <xsl:if test="$part=$module_number">
            <xsl:apply-templates select="term.ref" mode="module"/>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="error_message">
            <xsl:with-param name="message">
              <xsl:value-of select="concat('Error ref 3: ', $module_ok,
                                    'Check the normatives references: ')"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

<!-- Output the standard set of abbreviations and then any added by
     the module
     -->
<xsl:template match="abbreviations" mode="output">
  <!-- output any abbreviations defined in the business_object_model -->
  <xsl:apply-templates select="/business_object_model/abbreviations/abbreviation"/>

  <!-- output any abbreviations defined in the module-->
  <xsl:apply-templates select="/business_object_model/abbreviations/abbreviation.inc"/>
</xsl:template>


<!-- get the abbreviations out of the abbreviations.xml database -->
<xsl:template match="abbreviation.inc">
  <xsl:variable name="ref" select="@linkend"/>
  <xsl:variable 
    name="abbrev" 
    select="document('../../data/basic/abbreviations.xml')/abbreviation.list/abbreviation[@id=$ref]"/>
  <xsl:choose>
    <xsl:when test="$abbrev">
      <xsl:apply-templates select="$abbrev"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="error_message">
        <xsl:with-param name="message">
          <xsl:value-of select="concat('Error 9: abbreviation.inc ',$ref, 'not found: ')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="term">
  <xsl:variable name="nterm" select="normalize-space(.)"/>
  <a name="term-{$nterm}">
    <xsl:value-of select="$nterm"/>
  </a>
  <xsl:apply-templates select="../synonym"/>
</xsl:template>

<xsl:template match="term" mode="abbreviation">
  <xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<xsl:template match="term.ref" mode="abbreviation">
  <xsl:variable name="termref" select="./@linkend"/>
  <xsl:variable name="normref" select="./@normref"/>
  <xsl:variable name="term" select="document('../../data/basic/normrefs.xml')/normref.list/normref/term[@id=$termref]"/>
  <xsl:choose>
    <xsl:when test="$term">
      <xsl:value-of select="normalize-space($term)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="error_message">
        <xsl:with-param name="message">
          <xsl:value-of select="concat('Error 10: term.ref ',$termref, 'not found: ')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

  <xsl:template match="definition">
    <xsl:param name="section"/>
    <h4>
      <!-- <xsl:value-of select="$section"/>.<xsl:number/><br/> -->
      <xsl:value-of select="concat($section,'.',position())"/><br/> 
      <xsl:apply-templates select="term"/>
    </h4>
    <xsl:apply-templates select="def"/>
  </xsl:template>
  
  <xsl:template match="def">
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>



