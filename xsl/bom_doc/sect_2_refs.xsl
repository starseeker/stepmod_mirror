<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_2_refs.xsl,v 1.2 2012/11/01 19:04:31 mikeward Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep.
  Purpose: Display normative references clause for a BOM.
-->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		xmlns:exslt="http://exslt.org/common"
    exclude-result-prefixes="msxsl exslt"
    version="1.0"
>


  <!--  <xsl:import href="../sect_2_refs.xsl"/> -->
  <xsl:import href="business_object_model.xsl"/>
  <xsl:import href="business_object_model_clause_nofooter.xsl"/>
  <xsl:output method="html"/>
	
  
  <xsl:template match="business_object_model">
    <h2>
      2 Normative references
    </h2>
    <p>
      The following referenced documents are indispensable for the application of
      this document. For dated references, only the edition cited applies. For
      undated references, the latest edition of the referenced document
      (including any amendments) applies.
    </p>
    <xsl:apply-templates select="." mode="output_default_normrefs"/>
  </xsl:template>

<!-- output the default normative reference  -->
  <xsl:template match="business_object_model" mode="output_default_normrefs">
  <xsl:variable name="normrefs">
    <xsl:apply-templates select="." mode="normrefs_list"/>
  </xsl:variable>
    
  <xsl:variable name="pruned_normrefs">
    <xsl:call-template name="prune_normrefs_list">
      <xsl:with-param name="normrefs_list" select="$normrefs"/>
    </xsl:call-template>  
  </xsl:variable>
  <xsl:variable name="normrefs_to_be_sorted"> 
    <xsl:call-template name="output_normrefs_rec">
      <xsl:with-param name="normrefs" select="$pruned_normrefs"/>
      <xsl:with-param name="application_protocol_number" select="./@part"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="function-available('msxsl:node-set')">
      <xsl:variable name="normrefs_to_be_sorted_set" select="msxsl:node-set($normrefs_to_be_sorted)"/>
      <xsl:for-each select="$normrefs_to_be_sorted_set/normref">
        <!-- sorting basis is special normalized string, consisting of organization, series and part number all of equal lengths per each element -->
        <xsl:sort select="part"/>
        <xsl:for-each select="string/*">
         <xsl:copy-of select="."/>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:when>
    <xsl:when test="function-available('exslt:node-set')">    
      <xsl:variable name="normrefs_to_be_sorted_set" select="exslt:node-set($normrefs_to_be_sorted)"/>
      <xsl:for-each select="$normrefs_to_be_sorted_set/normref">
        <!-- sorting basis is special normalized string, consisting of organization, series and part number all of equal lengths per each element -->
        <xsl:sort select="part"/>
        <xsl:for-each select="string/*">
         <xsl:copy-of select="."/>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:when>
  </xsl:choose>
  <!-- output a footnote to say that the normative reference has not been
       published -->
  <xsl:call-template name="output_unpublished_normrefs">
    <xsl:with-param name="normrefs" select="$normrefs"/>
  </xsl:call-template>
  <!-- output a footnote to say that the normative reference has not been
       published -->
  <xsl:call-template name="output_derogated_normrefs">
    <xsl:with-param name="normrefs" select="$normrefs"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="business_object_model" mode="normrefs_list">
  <xsl:variable name="normref_list1">    
    <xsl:call-template name="get_normref">
      <xsl:with-param name="normref_nodes" select="document('../../data/basic/bom_doc/normrefs_default.xml')/normrefs/normref.inc"/>
      <xsl:with-param name="normref_list" select="''"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="normref_list2">
    <xsl:call-template name="get_normref">
      <xsl:with-param name="normref_nodes" select="/business_object_model/normrefs/normref.inc"/>
      <xsl:with-param name="normref_list" select="$normref_list1"/>
    </xsl:call-template>
  </xsl:variable>
    <xsl:value-of select="$normref_list2"/>
</xsl:template>

<xsl:template name="get_normref">
  <xsl:param name="normref_nodes"/>
  <xsl:param name="normref_list"/>
  <xsl:variable name="normref_list_ret">
    <xsl:choose>
      <xsl:when test="$normref_nodes">
        <xsl:variable name="first">
          <xsl:choose>
            <xsl:when test="$normref_nodes[1]/@normref">
              <xsl:value-of select="concat('normref:',$normref_nodes[1]/@normref)"/>
            </xsl:when>
            <xsl:when test="$normref_nodes[1]/@module.name">
              <xsl:value-of select="concat('module:',$normref_nodes[1]/@module.name)"/>
            </xsl:when>
            <xsl:when test="$normref_nodes[1]/@resource.name">
              <xsl:value-of select="concat('resource:',$normref_nodes[1]/@resource.name)"/>
            </xsl:when>
            <xsl:when test="$normref_nodes[1]/@application_protocol.name">
              <xsl:value-of select="concat('application_protocol:',$normref_nodes[1]/@application_protocol.name)"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="normref_list1">
          <xsl:call-template name="add_normref">
            <xsl:with-param name="normref" select="$first"/>
            <xsl:with-param name="normref_list" select="$normref_list"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:call-template name="get_normref">
          <xsl:with-param name="normref_nodes" select="$normref_nodes[position()!=1]"/>
          <xsl:with-param name="normref_list" select="$normref_list1"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$normref_list"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$normref_list_ret"/>
</xsl:template>


<!-- given a list of abbreviation.inc nodes, add the ids of the normrefs to the
     normref_list, if not already a member. ids in normref_list are
     separated by a , -->
<!--<xsl:template name="get_normrefs_from_abbr">
  <xsl:param name="abbrvinc_nodes"/>
  <xsl:param name="normref_list"/>
  <xsl:variable name="normref_list_ret">
    <xsl:choose>
      <xsl:when test="$abbrvinc_nodes">
        <xsl:variable name="abbr.inc" select="$abbrvinc_nodes[1]/@linkend"/>
        <xsl:variable name="abbr" select="document('../../data/basic/abbreviations.xml')/abbreviation.list/abbreviation[@id=$abbr.inc]"/>
        <xsl:variable name="first">
          <xsl:choose>
            <xsl:when test="$abbr/term.ref/@normref">
              <xsl:value-of select="concat('normref:',$abbr/term.ref/@normref)"/>
            </xsl:when>
            <xsl:when test="$abbr/term.ref/@module.name">
              <xsl:value-of select="concat('module:',$abbr/term.ref/@module.name)"/>
            </xsl:when> 
            <xsl:when test="$abbr/term.ref/@application_protocol.name">
              <xsl:value-of select="concat('application_protocol:',$abbr/term.ref/@application_protocol.name)"/>
            </xsl:when>
            <xsl:when test="$abbr/term.ref/@resource.name">
              <xsl:value-of select="concat('resource:',$abbr/term.ref/@resource.name)"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="normref_list1">
          <xsl:call-template name="add_normref">
            <xsl:with-param name="normref" select="$first"/>
            <xsl:with-param name="normref_list" select="$normref_list"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:call-template name="get_normrefs_from_abbr">
          <xsl:with-param name="abbrvinc_nodes" select="$abbrvinc_nodes[position()!=1]"/>
          <xsl:with-param name="normref_list" select="$normref_list1"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$normref_list"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$normref_list_ret"/>
</xsl:template>-->


<xsl:template name="output_normrefs_rec">
  <xsl:param name="application_protocol_number"/>
  <xsl:param name="normrefs"/>
  
  <xsl:choose>
    <xsl:when test="$normrefs">
      <xsl:variable name="first" select="substring-before(substring-after($normrefs,','),',')"/>
      <xsl:variable name="rest" select="substring-after(substring-after($normrefs,','),',')"/>
      <xsl:choose>
      <xsl:when test="contains($first, 'normref:')">
        <xsl:variable name="normref" select="substring-after($first, 'normref:')"/>
        <xsl:variable name="normref_node" select="document('../../data/basic/normrefs.xml')/normref.list/normref[@id=$normref]"/>
        <xsl:choose>
          <xsl:when test="$normref_node">

            <xsl:variable name="part_no" select="substring-after($normref_node/stdref/stdnumber,'-')"/>
            <xsl:element name="normref">
              <xsl:element name="string">
                <xsl:if test="$application_protocol_number!=$part_no">
                  <!-- OOUTPUT from normative references -->
                    <xsl:apply-templates 
                      select="document('../../data/basic/normrefs.xml')/normref.list/normref[@id=$normref]"/>
                </xsl:if>
              </xsl:element>
              <xsl:variable name="part">
                <xsl:value-of select="document('../../data/basic/normrefs.xml')/normref.list/normref[@id=$normref]/stdref/stdnumber"/>
              </xsl:variable>
              <xsl:variable name="orgname">
				<xsl:value-of select="document('../../data/basic/normrefs.xml')/normref.list/normref[@id=$normref]/stdref/orgname"/>
              </xsl:variable>
              <!-- eliminate status info like TS, CD-TS, etc -->
              <xsl:variable name="orgname_cleaned">
                <xsl:choose>
                  <xsl:when test="$orgname='ISO'">AISO</xsl:when>
                  <xsl:when test="$orgname='ISO/TS'">AISO</xsl:when>
                  <xsl:when test="$orgname='ISO/IEC'">BIEC</xsl:when>
                  <xsl:when test="$orgname='IEC'">CIEC</xsl:when>
                  <xsl:otherwise>D<xsl:value-of select="$orgname"/></xsl:otherwise>
                </xsl:choose>  
              </xsl:variable>
                <!-- Try to 'normalize' part and subpart numbers -->
                <xsl:variable name="series" select="substring-before($part,'-')"/>
                <!-- normalize with longest possible series (10303) -->                    
                <xsl:variable name="series_norm">
                <xsl:choose>
                  <xsl:when test="string-length($series)=1">0000<xsl:value-of select="$series"/></xsl:when>
                  <xsl:when test="string-length($series)=2">000<xsl:value-of select="$series"/></xsl:when>
                  <xsl:when test="string-length($series)=3">00<xsl:value-of select="$series"/></xsl:when>
                  <xsl:when test="string-length($series)=4">0<xsl:value-of select="$series"/></xsl:when>
                  <xsl:when test="string-length($series)=5"><xsl:value-of select="$series"/></xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="error_message">
                      <xsl:with-param name="message">
                        <xsl:value-of select="concat('Unsupported length of series number: ', $series, 'length: ', string-length($series))"/>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
                </xsl:variable>
                <!-- normalize with longest possible part (4 digits) -->                    
                <xsl:variable name="part_norm">
                <xsl:choose>
                  <xsl:when test="string-length($part_no)=1">-000<xsl:value-of select="$part_no"/></xsl:when>
                  <xsl:when test="string-length($part_no)=2">-00<xsl:value-of select="$part_no"/></xsl:when>
                  <xsl:when test="string-length($part_no)=3">-0<xsl:value-of select="$part_no"/></xsl:when>
                  <xsl:when test="string-length($part_no)=4">-<xsl:value-of select="$part_no"/></xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="error_message">
                      <xsl:with-param name="message">
                        <xsl:value-of select="concat('Unsupported length of part number: ', $part_no, 'length: ', string-length($part_no))"/>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
                </xsl:variable>
                <xsl:element name="part">
                <!-- Organization name -->
                  <xsl:value-of select="$orgname_cleaned"/>-<xsl:value-of select="$series_norm"/><xsl:value-of select="$part_norm"/>
                </xsl:element>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="error_message">
              <xsl:with-param name="message">
                <xsl:value-of select="concat('Error 7: ', $normref, 'not found')"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      
      <xsl:when test="contains($first,'module:')">
        <xsl:variable name="module" select="substring-after($first,'module:')"/>
        <xsl:variable name="module_xml" select="concat('../../data/modules/',$module,'/module.xml')"/>
        <!-- OUTPUT the normative reference derived from the module -->
        <xsl:element name="normref">
            <xsl:apply-templates 
              select="document($module_xml)/module" mode="normref">
            </xsl:apply-templates>
        </xsl:element>
      </xsl:when>
      
      <xsl:when test="contains($first, 'application_protocol:')">
        <xsl:variable name="application_protocol" select="substring-after($first, 'application_protocol:')"/>
        <xsl:variable name="application_protocol_dir">
          <!--<xsl:call-template name="application_protocol_directory">
            <xsl:with-param name="application_protocol" select="$application_protocol"/>
          </xsl:call-template>-->
        </xsl:variable>
        <xsl:variable name="application_protocol_xml" select="concat($application_protocol_dir,'/application_protocol.xml')"/>
        <!-- OUTPUT from application protocol -->
        <!-- GL: sorting is not implemented for this one as there is not a single example AND I failed to found this function, which is called here -->
        <!-- GL: add here element'normref' and subelements 'part' and 'string' if needed to implement it -->
          {<xsl:apply-templates select="document($application_protocol_xml)/application_protocol" mode="normref"/>}
      </xsl:when>
      <xsl:when test="contains($first,'resource:')">
        <xsl:variable name="resource" select="substring-after($first,'resource:')"/>
        <!-- OOUTPUT from resource -->
        <!-- GL: sorting is not implemented for this one as there is not a single example AND it looks like this would anyway result into error message, if this 'code' is reached -->
        <!-- GL: add here element'normref' and subelements 'part' and 'string' if needed to implement it -->
          <xsl:call-template name="output_resource_normref">
            <xsl:with-param name="resource_schema" select="$resource"/>
          </xsl:call-template>
      </xsl:when>
      
    </xsl:choose>
    <!-- Go cyclic with remaining part of the string -->
    <xsl:call-template name="output_normrefs_rec">
      <xsl:with-param name="normrefs" select="$rest"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise/>
</xsl:choose>
</xsl:template>

<xsl:template name="prune_normrefs_list">
  <xsl:param name="normrefs_list"/>
  <xsl:param name="pruned_normrefs_list" select="''"/>
  <xsl:param name="pruned_normrefs_ids" select="''"/>
		
  <xsl:choose>
    <xsl:when test="$normrefs_list">
      <xsl:variable name="first" select="substring-before(substring-after($normrefs_list,','),',')"/>
      <xsl:variable name="rest" select="substring-after(substring-after($normrefs_list,','),',')"/>
      <xsl:variable name="add_to_pruned_normrefs_ids">
        <xsl:choose>
          <xsl:when test="contains($first,'normref:')">
            <xsl:variable name="id" select="substring-after($first,'normref:')"/>
            <xsl:variable name="normref">
              <xsl:apply-templates select="document('../../data/basic/normrefs.xml')/normref.list/normref[@id=$id]" 	mode="prune_normrefs_list"/>
            </xsl:variable>
            <xsl:value-of select="$normref"/>
          </xsl:when>
          <xsl:when test="contains($first,'module:')">
            <xsl:variable name="module" select="substring-after($first, 'module:')"/>
            
            <xsl:variable name="module_xml"
              select="concat('../../data/modules/',$module,'/module.xml')"/>
            <xsl:variable name="normref">
              <xsl:apply-templates select="document($module_xml)/module" mode="prune_normrefs_list"/>
            </xsl:variable>
            <xsl:if test="not(contains($pruned_normrefs_ids,$normref))">
              <xsl:value-of select="$normref"/>
            </xsl:if>
          </xsl:when>
          
          <xsl:when test="contains($first, 'application_protocol:')">
            <xsl:variable name="application_protocol" select="substring-after($first, 'application_protocol:')"/>
            <xsl:variable name="ap_mod_dir">
              <!--<xsl:call-template name="application_protocol_directory">
                <xsl:with-param name="application_protocol" select="$application_protocol"/>
              </xsl:call-template>-->
            </xsl:variable>
            <xsl:variable name="ap_xml" select="concat($ap_mod_dir,'/application_protocol.xml')"/>
            <xsl:variable name="normref">
              <xsl:apply-templates select="document($ap_xml)/application_protocol" mode="prune_normrefs_list"/>
            </xsl:variable>
            <xsl:if test="not(contains($pruned_normrefs_ids,$normref))">
              <xsl:value-of select="$normref"/>
            </xsl:if>
          </xsl:when>
          
          <xsl:when test="contains($first,'resource:')">
            <xsl:variable name="resource" select="substring-after($first,'resource:')"/>
            <xsl:value-of select="$resource"/>
          </xsl:when>
          
          <xsl:otherwise/>
          
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="new_pruned_normrefs_ids">
        <xsl:choose>
          <xsl:when test="string-length($add_to_pruned_normrefs_ids)>0">
            <xsl:value-of select="concat($pruned_normrefs_ids,',',$add_to_pruned_normrefs_ids,',')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$pruned_normrefs_ids"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="new_pruned_normrefs_list">
        <xsl:choose>
          <xsl:when test="string-length($add_to_pruned_normrefs_ids)>0">
            <xsl:value-of select="concat($pruned_normrefs_list,',',$first,',')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$pruned_normrefs_list"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:call-template name="prune_normrefs_list">
        <xsl:with-param name="normrefs_list" select="$rest"/>
        <xsl:with-param name="pruned_normrefs_list" select="$new_pruned_normrefs_list"/>
        <xsl:with-param name="pruned_normrefs_ids" select="$new_pruned_normrefs_ids"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$pruned_normrefs_list"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="output_resource_normref">
  <xsl:param name="resource_schema"/>
  <xsl:variable name="ir_ok">
    <xsl:call-template name="check_resource_exists">
      <xsl:with-param name="schema" select="$resource_schema"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="ir_ref">
    <xsl:if test="$ir_ok='true'">
      <xsl:value-of 
        select="document(concat('../../data/resources/',
                $resource_schema,'/',$resource_schema,'.xml'))/express/@reference"/>
    </xsl:if>
  </xsl:variable>

  <p>
    <xsl:call-template name="error_message">
      <xsl:with-param name="message">
        <xsl:value-of 
          select="concat('Warning 8: MIM uses schema ', 
                  $resource_schema, 
                  '#  Make sure you include Integrated resource (',
                  $ir_ref,
                  ') that defines it as a normative reference. ',
                  '#  Use: normref.inc')"/>
      </xsl:with-param>
      <xsl:with-param name="inline" select="'no'"/>
    </xsl:call-template>
  </p>
</xsl:template>

 <!--add a normref id to the set of normref ids. -->
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


<!-- output a footnote to say that the normative reference has been
     derogated 
     Check the normative references in the nodule, then all the auto
     generated normrefs. These should be passed as a parameter the value of
     which is deduced by: template name="normrefs_list"
-->
<xsl:template name="output_derogated_normrefs">
  <xsl:param name="normrefs"/>

  <xsl:variable name="footnote">
    <xsl:choose>
      <xsl:when 
        test="( string(./@status)='TS' or 
                string(./@status)='IS') and
              ( string(./@status)='CD' or string(./@status)='CD-TS')">
        <xsl:value-of select="'y'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="( string(./@status)='TS' or 
                      string(./@status)='IS')">
          <xsl:call-template name="output_derogated_normrefs_rec">
            <xsl:with-param name="normrefs" select="$normrefs"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="$footnote='y'">
    <p>
      <a name="derogation">
        <sup>2)</sup> Reference applicable during ballot or review period.
      </a>      
    </p>
  </xsl:if>
</xsl:template>

<xsl:template name="output_derogated_normrefs_rec">
  <xsl:param name="normrefs"/>

  <xsl:choose>
    <xsl:when test="$normrefs">
      <xsl:variable 
        name="first"
        select="substring-before(substring-after($normrefs,','),',')"/>
      <xsl:variable 
        name="rest"
        select="substring-after(substring-after($normrefs,','),',')"/>      
      
      <xsl:variable name="footnote">
        <xsl:choose>
    <!-- ASSUMING THAT ALL NORMREFS IN normrefs.xml ARE
         PUBLISHED THERE FORE CANNOT BE DEROGATED 

          <xsl:when test="contains($first,'normref:')">
            <xsl:variable 
              name="normref" 
              select="substring-after($first,'normref:')"/>
            <xsl:choose>
              <xsl:when
                test="document('../data/basic/normrefs.xml')/normref.list/normref[@id=$normref]/stdref[@published='n']">
                <xsl:value-of select="'y'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'n'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          -->

          <xsl:when test="contains($first,'module:')">
            <xsl:variable 
              name="module" 
              select="substring-after($first,'module:')"/>
            
            <xsl:variable name="module_dir">
              <!--<xsl:call-template name="ap_module_directory">
                <xsl:with-param name="application_protocol" select="$module"/>
              </xsl:call-template>-->
            </xsl:variable>

            <xsl:variable name="module_xml" 
              select="concat($module_dir,'/module.xml')"/>
            <xsl:variable name="module_status" 
              select="string(document($module_xml)/module/@status)"/>
            <xsl:choose>
              <xsl:when test="$module_status='CD-TS' or $module_status='CD'">
                <xsl:value-of select="'y'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'n'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>

          <xsl:otherwise>
            <xsl:value-of select="'n'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="$footnote='n'">
          <!-- only recurse if no unpublished standard found -->      
          <xsl:call-template name="output_derogated_normrefs_rec">
            <xsl:with-param name="normrefs" select="$rest"/>
          </xsl:call-template>        
        </xsl:when>
        <xsl:otherwise>
          <!-- footnote found so stop -->
          <xsl:value-of select="'y'"/>
        </xsl:otherwise>
      </xsl:choose>
      
    </xsl:when>
    <xsl:otherwise>
      <!-- end of recursion -->
      <!-- <xsl:value-of select="$footnote"/> -->
      <xsl:value-of select="'n'"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- output a footnote to say that the normative reference has not been
     published 
     Check the normative references in the nodule, then all the auto
     generated normrefs. These should be passed as a parameter the value of
     which is deduced by: template name="normrefs_list"
-->
<xsl:template name="output_unpublished_normrefs">
  <xsl:param name="normrefs"/>
  <xsl:variable name="footnote">
    <xsl:choose>
      <xsl:when test="/application_protocol/normrefs/normref/stdref[@published='n']">
        <xsl:value-of select="'y'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="output_unpublished_normrefs_rec">
          <xsl:with-param name="normrefs" select="$normrefs"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:if test="$footnote='y'">
    <p>
      <a name="tobepub">
        1) To be published.
      </a>
    </p>
  </xsl:if>
</xsl:template>

<xsl:template name="output_unpublished_normrefs_rec">
  <xsl:param name="normrefs"/>
  <xsl:choose>
    <xsl:when test="$normrefs">
      <xsl:variable name="first" select="substring-before(substring-after($normrefs,','),',')"/>
      <xsl:variable name="rest" select="substring-after(substring-after($normrefs,','),',')"/>
      <xsl:variable name="footnote">
        <xsl:choose>
          <xsl:when test="contains($first,'normref:')">
            <xsl:variable name="normref" select="substring-after($first,'normref:')"/>
            <xsl:choose>
              <xsl:when test="document('../../data/basic/normrefs.xml')/normref.list/normref[@id=$normref]/stdref[@published='n']">
                <xsl:value-of select="'y'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'n'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          
          <xsl:when test="contains($first,'module:')">
            <xsl:variable name="module" select="substring-after($first,'module:')"/>
            <xsl:variable name="ap_module_dir">
              <!--<xsl:call-template name="ap_module_directory">
                <xsl:with-param name="application_protocol" select="$module"/>
              </xsl:call-template>-->
            </xsl:variable>
            <xsl:variable name="module_xml" select="concat($ap_module_dir,'/module.xml')"/>
            <xsl:choose>
              <xsl:when test="document($module_xml)/module[@published='n']">
                <xsl:value-of select="'y'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'n'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          
          <xsl:when test="contains($first, 'application_protocol:')">
            <xsl:variable name="application_protocol" select="substring-after($first, 'application_protocol:')"/>
            <xsl:variable name="application_protocol_dir">
              <!--<xsl:call-template name="application_protocol_directory">
                <xsl:with-param name="application_protocol" select="$application_protocol"/>
              </xsl:call-template>-->
            </xsl:variable>
            <xsl:variable name="application_protocol_xml" select="concat($application_protocol_dir,'/application_protocol.xml')"/>
            <xsl:choose>
              <xsl:when test="document($application_protocol_xml)/application_protocol[@published='n']">
                <xsl:value-of select="'y'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'n'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'n'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$footnote='n'">
          <xsl:call-template name="output_unpublished_normrefs_rec">
            <xsl:with-param name="normrefs" select="$rest"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'y'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="'n'"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="normref">
  <xsl:variable name="stdnumber">
<!--    <xsl:choose>
      <xsl:when test="stdref/pubdate">
        <xsl:value-of select="concat(stdref/orgname,'&#160;',stdref/stdnumber,':',stdref/pubdate)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat(stdref/orgname,'&#160;',stdref/stdnumber,':&#8212;&#160;')"/>
      </xsl:otherwise>
    </xsl:choose> -->
	  <xsl:value-of 
	    select="concat(stdref/orgname,'&#160;',stdref/stdnumber)"/>
  </xsl:variable>
  <p>
    <xsl:value-of select="$stdnumber"/>
    <xsl:if test="stdref[@published='n']">
      <sup><a href="#tobepub">1</a>)</sup>
    </xsl:if>,&#160;
    <i>
      <xsl:value-of select="stdref/stdtitle"/>
      <xsl:variable name="subtitle" select="normalize-space(stdref/subtitle)"/>
      <xsl:choose>
        <xsl:when test="substring($subtitle, string-length($subtitle)) != '.'">
          <xsl:value-of select="concat($subtitle,'.')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$subtitle"/>
        </xsl:otherwise>
      </xsl:choose>
    </i>
  </p>
</xsl:template>

<xsl:template match="module" mode="prune_normrefs_list">
  <xsl:value-of select="concat('10303-',./@part,./@publication.year)"/>
</xsl:template>

	
<xsl:template match="application_protocol" mode="prune_normrefs_list">
  <xsl:value-of select="concat('10303-',./@part,./@publication.year)"/>
</xsl:template>


<xsl:template match="module" mode="normref">
  <xsl:element name="string">
  <p>
    <xsl:variable name="part">
      <xsl:choose>
        <xsl:when test="string-length(@part)>0">
          <xsl:value-of select="@part"/>
        </xsl:when>
        <xsl:otherwise>
          &lt;part&gt;
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="stdnumber">
      <xsl:call-template name="get_module_stdnumber_undated">
        <xsl:with-param name="module" select="."/>
      </xsl:call-template>
    </xsl:variable>

    
    <xsl:variable name="stdtitle"
      select="concat('Industrial automation systems and integration ',
              '&#8212; Product data representation and exchange ')"/>

    <xsl:variable name="module_name">
      <xsl:call-template name="module_display_name">
        <xsl:with-param name="module" select="@name"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="subtitle"
      select="concat('&#8212; Part ',$part,': Application module: ', $module_name,'.')"/>
    
    <!-- Printing of standard line starts here -->
    <xsl:value-of select="$stdnumber"/>
    <xsl:choose><!-- if the module is a TS or IS module and is referring to a CD or CD-TS module -->
      <xsl:when 
        test="( string(./@status)='TS' or 
              string(./@status)='IS') and
              ( string(./@status)='CD' or string(./@status)='CD-TS')">
        &#160;<sup><a href="#derogation">2</a>)</sup>
      </xsl:when>
      <xsl:when test="@published='n'">&#160;<sup><a href="#tobepub">1</a>)</sup>
      </xsl:when>
    </xsl:choose>,&#160;
    <i>
      <xsl:value-of select="$stdtitle"/>
      <xsl:value-of select="$subtitle"/>
    </i>
  </p>
  </xsl:element>    
  <xsl:element name="part">
  <!-- Need to 'normalize' the length so that we can easier sort it -->
    <xsl:choose>
      <xsl:when test="string-length(@part)=1">ISO-10303-000<xsl:value-of select="@part"/></xsl:when>
      <xsl:when test="string-length(@part)=2">ISO-10303-00<xsl:value-of select="@part"/></xsl:when>
      <xsl:when test="string-length(@part)=3">ISO-10303-0<xsl:value-of select="@part"/></xsl:when>
      <xsl:when test="string-length(@part)=4">ISO-10303-<xsl:value-of select="@part"/></xsl:when>      
      <xsl:otherwise>
            <xsl:call-template name="error_message">
              <xsl:with-param name="message">
                <xsl:value-of select="concat('Unsupported length of part number: ', @part, 'length: ', string-length(@part))"/>
              </xsl:with-param>
            </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:element>
</xsl:template> 

<!-- Extended for CO as well, due to the same child structure -->
<xsl:template name="get_cc_normrefs_list">
  <xsl:param name="cc_nodes"/> 
  <xsl:param name="normref_list"/>
  <xsl:variable name="normref_list_ret">
    <xsl:choose>
      <xsl:when test="$cc_nodes">
          <xsl:choose>
            <xsl:when test="$cc_nodes[1]/@module">
              <xsl:variable name="first" select="concat('module:',$cc_nodes[1]/@module)"/>
              <xsl:variable name="normref_list1">
                <xsl:call-template name="add_normref">
                  <xsl:with-param name="normref" select="$first"/>
                  <xsl:with-param name="normref_list" select="$normref_list"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:call-template name="get_cc_normrefs_list">
                <xsl:with-param name="cc_nodes" select="$cc_nodes[position()!=1]"/>
                <xsl:with-param name="normref_list" select="$normref_list1"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="get_cc_normrefs_list">
                <xsl:with-param name="cc_nodes" select="$cc_nodes[position()!=1]"/>
                <xsl:with-param name="normref_list" select="$normref_list"/>
              </xsl:call-template>              
            </xsl:otherwise>
          </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$normref_list"/>
      </xsl:otherwise>
    </xsl:choose>
    <!-- NEW stuff -->
    <xsl:variable name="normref_list2">
	   <xsl:for-each select="$cc_nodes">                
		   <xsl:for-each select="module">                
		      <xsl:variable name="one_module" select="concat(',module:',@name,',')"/>
		      <xsl:value-of select="$one_module"/> 
		   </xsl:for-each>
	   </xsl:for-each> 
     </xsl:variable>		      
	 <xsl:value-of select="$normref_list2"/>      
	 <!-- ENDOF NEW stuff -->
  </xsl:variable>
  <xsl:value-of select="$normref_list_ret"/>
</xsl:template>


</xsl:stylesheet>
