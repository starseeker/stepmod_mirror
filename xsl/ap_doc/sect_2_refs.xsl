<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_2_refs.xsl,v 1.13 2003/08/11 07:00:23 robbod Exp $
  Author:  Mike Ward, Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: Display the main set of frames for an AP document.     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!--  <xsl:import href="../sect_2_refs.xsl"/> -->
  <xsl:import href="application_protocol.xsl"/>
  <xsl:import href="application_protocol_clause.xsl"/>
  <xsl:output method="html"/>
	
  
  <xsl:template match="application_protocol">
    <h2>
      2 Normative references
    </h2>
    <p>
      The following normative documents contain provisions which, through
      reference in this text, constitute provisions of this International
      Standard. For dated references, subsequent amendments to, or revisions of,
      any of these publications do not apply. However, parties to agreements
      based on this International Standard are encouraged to investigate the
      possibility of applying the most recent editions of the normative documents
      indicated below. For undated references, the latest edition of the
      normative document referred to applies. Members of ISO and IEC maintain
      registers of currently valid International Standards.
    </p>

    <xsl:apply-templates select="." mode="output_default_normrefs"/>
  </xsl:template>

<!-- output the default normative reference  -->
<xsl:template match="application_protocol" mode="output_default_normrefs">
  <xsl:variable name="normrefs">
    <xsl:apply-templates select="." mode="normrefs_list"/>
  </xsl:variable>

  <xsl:variable name="pruned_normrefs">
    <xsl:call-template name="prune_normrefs_list">
      <xsl:with-param name="normrefs_list" select="$normrefs"/>
    </xsl:call-template>  
  </xsl:variable>
  <xsl:call-template name="output_normrefs_rec">
    <xsl:with-param name="normrefs" select="$pruned_normrefs"/>
    <xsl:with-param name="application_protocol_number" select="./@part"/>
  </xsl:call-template>  
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


<xsl:template match="application_protocol" mode="normrefs_list">

  <xsl:variable name="normref_list1">    
    <xsl:call-template name="get_normref">
      <xsl:with-param name="normref_nodes" 
        select="document('../../data/basic/ap_doc/normrefs_default.xml')/normrefs/normref.inc"/>
      <xsl:with-param name="normref_list" select="''"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="normref_list2">
    <xsl:call-template name="get_normref">
      <xsl:with-param name="normref_nodes" select="/application_protocol/normrefs/normref.inc"/>
      <xsl:with-param name="normref_list" select="$normref_list1"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="normref_list3">
    <xsl:call-template name="get_normrefs_from_abbr">
      <xsl:with-param name="abbrvinc_nodes" select="document('../../data/basic/ap_doc/abbreviations_default.xml')/abbreviations/abbreviation.inc"/>
      <xsl:with-param name="normref_list" select="$normref_list2"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- add the modules identified as having conformance classes against
       them -->
  <xsl:variable name="cc_nodes" 
    select="document(concat('../../data/application_protocols/',@name,'/ccs.xml'))/conformance/cc"/>
  <xsl:variable name="normref_list4">
    <xsl:call-template name="get_cc_normrefs_list">
      <xsl:with-param name="cc_nodes" select="$cc_nodes"/>
      <xsl:with-param name="normref_list" select="$normref_list3"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="concat($normref_list4,',')"/>
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
<xsl:template name="get_normrefs_from_abbr">
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
</xsl:template>


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
            
            <xsl:if test="$application_protocol_number!=$part_no">
              <xsl:apply-templates 
                select="document('../../data/basic/normrefs.xml')/normref.list/normref[@id=$normref]"/>
            </xsl:if>
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
        <!-- output the normative reference derived from the module -->
        <xsl:apply-templates 
          select="document($module_xml)/module" mode="normref">
        </xsl:apply-templates>
      </xsl:when>
      
      <xsl:when test="contains($first, 'application_protocol:')">
        <xsl:variable name="application_protocol" select="substring-after($first, 'application_protocol:')"/>
        <xsl:variable name="application_protocol_dir">
          <xsl:call-template name="application_protocol_directory">
            <xsl:with-param name="application_protocol" select="$application_protocol"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="application_protocol_xml" select="concat($application_protocol_dir,'/application_protocol.xml')"/>
        
        <xsl:apply-templates select="document($application_protocol_xml)/application_protocol" mode="normref"/>
      </xsl:when>
      <xsl:when test="contains($first,'resource:')">
        <xsl:variable name="resource" select="substring-after($first,'resource:')"/>
        <xsl:call-template name="output_resource_normref">
          <xsl:with-param name="resource_schema" select="$resource"/>
        </xsl:call-template>
      </xsl:when>
      
    </xsl:choose>
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
              <xsl:call-template name="application_protocol_directory">
                <xsl:with-param name="application_protocol" select="$application_protocol"/>
              </xsl:call-template>
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
              <xsl:call-template name="module_directory">
                <xsl:with-param name="module" select="$module"/>
              </xsl:call-template>
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
              <xsl:call-template name="ap_module_directory">
                <xsl:with-param name="application_protocol" select="$module"/>
              </xsl:call-template>
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
              <xsl:call-template name="application_protocol_directory">
                <xsl:with-param name="application_protocol" select="$application_protocol"/>
              </xsl:call-template>
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
    <xsl:choose>
      <xsl:when test="stdref/pubdate">
        <xsl:value-of select="concat(stdref/orgname,'&#160;',stdref/stdnumber,':',stdref/pubdate)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat(stdref/orgname,'&#160;',stdref/stdnumber,':&#8212;&#160;')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <p>
    <xsl:value-of select="$stdnumber"/>
    <xsl:if test="stdref[@published='n']">
      <sup>
        <a href="#tobepub">
          1
        </a>)
      </sup>
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
      <xsl:call-template name="get_module_stdnumber">
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
    

    <xsl:value-of select="$stdnumber"/>&#160;

    <xsl:choose>
      <!-- if the module is a TS or IS module and is referring to a 
           CD or CD-TS module -->
      <xsl:when 
        test="( string(./@status)='TS' or 
              string(./@status)='IS') and
              ( string(./@status)='CD' or string(./@status)='CD-TS')">
        <sup>
          <a href="#derogation">
            2
          </a>)
        </sup>
      </xsl:when>
      <xsl:when test="@published='n'">
        <sup>
          <a href="#tobepub">
            1
          </a>)
        </sup>
      </xsl:when>
    </xsl:choose>,&#160;
    <i>
      <xsl:value-of select="$stdtitle"/>
      <xsl:value-of select="$subtitle"/>
    </i>
  </p>
</xsl:template>


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
  </xsl:variable>
  <xsl:value-of select="$normref_list_ret"/>
</xsl:template>


</xsl:stylesheet>
