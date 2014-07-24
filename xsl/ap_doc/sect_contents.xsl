<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_contents.xsl,v 1.56 2013/03/21 20:39:24 mikeward Exp $
  Author:  Mike Ward, Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: Display the main set of frames for an AP document.     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../sect_contents.xsl"/>
  <xsl:import href="application_protocol.xsl"/>
  <xsl:import href="application_protocol_clause_nofooter.xsl"/>
  <xsl:output method="html"/>
	
  <xsl:template match="application_protocol">
    <xsl:apply-templates select="../application_protocol" mode="contents"/>
    <xsl:apply-templates select="../application_protocol" mode="contents_tables_figures"/>
    <!-- no longer required by ISO
       <xsl:apply-templates select="../application_protocol" mode="copyright"/>
       -->
    <br/><br/>
    <p>&#169; ISO <xsl:value-of select="@publication.year"/> &#8212; All rights reserved</p>
  </xsl:template>
	
  <xsl:template match="application_protocol" mode="contents">
    <xsl:param name="target" select="'_self'"/>
    <!-- if complete is yes then display the introduction foreword etc -->
    <xsl:param name="complete" select="'no'"/>
    <!-- if short is yes then display level 3 entries -->
    <xsl:param name="short" select="'yes'"/>

    <!-- BOM -->
    <xsl:variable name="bom_name" select="@business_object_model"/>

    <xsl:variable name="annex_list">
      <xsl:apply-templates select="." mode="annex_list"/>
    </xsl:variable>

    <xsl:variable name="arm_schema_name" select="concat(@name,'_arm')"/>
    <xsl:variable name="aim_schema_name" select="concat(@name,'_mim')"/>
	
    <xsl:variable name="application_protocol_dir">
      <xsl:call-template name="application_protocol_directory">
        <xsl:with-param name="application_protocol" select="@name"/>
      </xsl:call-template>
    </xsl:variable>
		
    <xsl:variable name="ap_module_dir">
      <xsl:call-template name="ap_module_directory">
        <xsl:with-param name="application_protocol" select="@module_name"/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="module_xml" select="document(concat($ap_module_dir,'/module.xml'))"/>		
    <xsl:variable name="ccs_xml" select="document(concat($application_protocol_dir, '/ccs.xml'))"/>
    <xsl:variable name="aam_xml" select="document(concat($application_protocol_dir, '/aam.xml'))"/>
    <xsl:variable name="arm_xml" select="document(concat($ap_module_dir,'/arm.xml'))"/>		
    <xsl:variable name="mim_xml" select="document(concat($ap_module_dir,'/mim.xml'))"/>		
    <h2><a name="contents"></a>Contents</h2>
    <small>
    <xsl:if test="$complete='yes'">
      <a href="./cover{$FILE_EXT}" target="{$target}">Cover page</a>
      <br/>
      <a href="./contents{$FILE_EXT}" target="{$target}">Table of contents</a>
      <br/>
      <a href="./cover{$FILE_EXT}#copyright" target="{$target}">Copyright</a>
      <br/>
      <a href="./foreword{$FILE_EXT}" target="{$target}">Foreword</a>
      <br/>
      <a href="./introduction{$FILE_EXT}" target="{$target}">Introduction</a><br/>      
    </xsl:if>

    <a href="./1_scope{$FILE_EXT}" target="{$target}">1 Scope</a><br/>
    <a href="./2_refs{$FILE_EXT}" target="{$target}">2 Normative references</a><br/>
      <!-- Assume that every AP has terms definitions and abbreviations
    <xsl:choose>
      <xsl:when test="./definition/term">
        <a href="./3_defs{$FILE_EXT}" target="{$target}">
          3 Terms, definitions and abbreviated terms
        </a>
        <br/>
      </xsl:when>
      <xsl:otherwise>
        <a href="./3_defs{$FILE_EXT}" target="{$target}">
          <!-\- every AP references Terms defined in other standards,
               and abbreviations hence as per ISO -\->
          3 Terms, definitions and abbreviated terms
        </a>
        <br/>
      </xsl:otherwise>
    </xsl:choose>     --> 
      <a href="./3_defs{$FILE_EXT}" target="{$target}">
        3 Terms, definitions and abbreviated terms
      </a>  
      <br/>
      &#160;&#160;&#160;&#160;&#160;
      <a href="./3_defs{$FILE_EXT}#termsdefns" target="{$target}">3.1 Terms and definitions</a>
      <br/>
      &#160;&#160;&#160;&#160;&#160;
      <a href="./3_defs{$FILE_EXT}#abbrvterms" target="{$target}">3.2 Abbreviated terms</a>
      <br/>
      
    <a href="./4_info_reqs{$FILE_EXT}" target="{$target}">4 Information requirements</a>
    <br/>
    &#160;&#160;&#160;&#160;&#160;
    <a href="./4_info_reqs{$FILE_EXT}#41" target="{$target}">4.1 Business concepts and terminology</a>
    <br/>

    &#160;&#160;&#160;&#160;&#160;
    <a href="./4_info_reqs{$FILE_EXT}#42" target="{$target}">4.2 Information requirements model</a>
    <br/>
    <xsl:if test="$short='no'">
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
      <a href="./4_info_reqs{$FILE_EXT}#421" target="{$target}">4.2.1 Model overview</a>
      <br/>
      <xsl:apply-templates select="inforeqt/reqtover" mode="toc">
        <xsl:with-param name="target" select="$target"/>
      </xsl:apply-templates>
    </xsl:if>
      <xsl:if test="@business_object_model">
          &#160;&#160;&#160;&#160;&#160;
        <a href="./4_info_reqs{$FILE_EXT}#43" target="{$target}">4.3 Business object model</a>
        <br/>
      </xsl:if>
    <a href="./5_main{$FILE_EXT}" target="{$target}">5 Module interpreted model</a>
    <br/>
    <a href="./6_ccs{$FILE_EXT}" target="{$target}">6 Conformance requirements</a><br/>
    <xsl:apply-templates select="$ccs_xml/conformance/cc" mode="toc">
      <xsl:with-param name="target" select="$target"/>
    </xsl:apply-templates>
    <a href="./annex_exp_lf{$FILE_EXT}" target="{$target}">Annex A Listings</a>
    <br/>
    &#160;&#160;&#160;&#160;&#160;
    <a href="./annex_exp_lf{$FILE_EXT}#annexa1" target="{$target}">A.1 ARM EXPRESS expanded listing</a><br/>
    &#160;&#160;&#160;&#160;&#160;
    <a href="./annex_exp_lf{$FILE_EXT}#annexa2" target="{$target}">A.2 MIM EXPRESS expanded listing</a><br/>


      <!-- BOM -->
      <xsl:if test="string-length($bom_name) > 0">
        &#160;&#160;&#160;&#160;&#160;
        <a href="./annex_exp_lf{$FILE_EXT}#annexa3" target="{$target}">A.3 BO Model EXPRESS listing</a><br/>
        &#160;&#160;&#160;&#160;&#160;
        <a href="./annex_exp_lf{$FILE_EXT}#annexa4" target="{$target}">A.4 BO Model XML Schema listing</a><br/>
        &#160;&#160;&#160;&#160;&#160;
        <a href="./annex_exp_lf{$FILE_EXT}#annexa5" target="{$target}">A.5 BO Model XSD Configuration listing</a><br/>
        
      </xsl:if>



    <a href="./annex_shortnames{$FILE_EXT}" target="{$target}">
      Annex B MIM short names
    </a>
    <br/>
    <a href="./annex_imp_meth{$FILE_EXT}" target="{$target}">
      Annex C Implementation method specific requirements
    </a>
    <br/>
    <xsl:for-each select="imp_meths/imp_meth">
      <xsl:variable name="sect_no">
        <xsl:number/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="@general='y'">
          &#160;&#160;&#160;&#160;&#160;
          <a href="./annex_imp_meth{$FILE_EXT}#c{$sect_no}" target="{$target}">
            <xsl:value-of select="concat('C.',$sect_no,' ')"/>
            General requirements
          </a>
          <br/>
        </xsl:when>
        <xsl:otherwise>
          &#160;&#160;&#160;&#160;&#160;
          <a href="./annex_imp_meth{$FILE_EXT}#c{$sect_no}" target="{$target}">
            <xsl:value-of select="concat('C.',$sect_no,' ')"/>
            Requirements specific to the implementation method defined in 
            <xsl:value-of select="concat('ISO 10303-', @part)"/>
          </a>
          <br/>
        </xsl:otherwise>
      </xsl:choose>			

    </xsl:for-each>

    <a href="./annex_pics{$FILE_EXT}" target="{$target}">
      Annex D Protocol Implementation Conformance Statement (PICS) proforma
    </a>
    <br/>
    &#160;&#160;&#160;&#160;&#160;
    <a href="./annex_pics{$FILE_EXT}#d1" target="{$target}">
      D.1 Protocol implementation identification
    </a><br/>
    &#160;&#160;&#160;&#160;&#160;
    <a href="./annex_pics{$FILE_EXT}#d2" target="{$target}">
      D.2 Implementation method
    </a><br/>
    &#160;&#160;&#160;&#160;&#160;
    <a href="./annex_pics{$FILE_EXT}#d3" target="{$target}">
      D.3 Implemented conformance classes
    </a><br/>

    <a href="./annex_obj_reg{$FILE_EXT}" target="{$target}">
      Annex E Information object registration
    </a><br/>
<!--
    &#160;&#160;&#160;&#160;&#160;<A HREF="./annex_obj_reg{$FILE_EXT}#e1" target="{$target}">E.1 Document identification</A><br/>
    &#160;&#160;&#160;&#160;&#160;<A HREF="./annex_obj_reg{$FILE_EXT}#e2" target="{$target}">E.2 Schema identification</A><br/>
    <xsl:if test="$short='no'">
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
      <A HREF="./annex_obj_reg{$FILE_EXT}#e21" target="{$target}">E.2.1 <xsl:value-of select="$arm_xml/@name"/> schema identification</A><br/>    
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
      <A HREF="./annex_obj_reg{$FILE_EXT}#e22" target="{$target}">E.2.2 <xsl:value-of select="$mim_xml/@name"/> schema identification</A><br/>
      <xsl:if test="$module_xml//arm_lf">
        <xsl:variable name="arm_lf_xml" select="concat($ap_module_dir,'/arm_lf.xml')"/>
        <xsl:variable name="arm_schema_lf"  select="document($arm_lf_xml)/express/schema/@name"/>
        &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
        <A HREF="./annex_obj_reg{$FILE_EXT}#e23" target="{$target}">E.2.3 <xsl:value-of select="$arm_schema_lf"/> schema identification</A><br/>     
      </xsl:if>
      <xsl:if test="$module_xml//mim_lf">
        <xsl:variable name="mim_lf_xml" select="concat($ap_module_dir,'/mim_lf.xml')"/>
        <xsl:variable name="mim_schema_lf" select="document($mim_lf_xml)/express/schema/@name"/>
        &#160;&#160;&#160;&#160;&#160;
        <A HREF="./annex_obj_reg{$FILE_EXT}#e24" target="{$target}">E.2.4 <xsl:value-of select="$mim_schema_lf"/> schema identification</A><br/>       
      </xsl:if>
    </xsl:if>
-->
    <a href="./annex_aam{$FILE_EXT}" target="{$target}">
      Annex F Application activity model
    </a>
    <br/>
    <xsl:apply-templates select="$aam_xml/idef0" mode="toc">
      <xsl:with-param name="target" select="$target"/>
      <xsl:with-param name="short" select="$short"/>
    </xsl:apply-templates>

    <xsl:if test="$module_xml/module/arm_lf/express-g">
      <xsl:variable name="al_armexpressg">
        <xsl:call-template name="annex_letter" >
          <xsl:with-param name="annex_name" select="'ARMexpressG'"/>
          <xsl:with-param name="annex_list" select="$annex_list"/>
        </xsl:call-template>
      </xsl:variable>
      <a
        href="./annex_arm_expg{$FILE_EXT}" target="{$target}">
        <xsl:value-of select="$al_armexpressg"/> ARM EXPRESS-G diagrams
      </a>
      <br/>
    </xsl:if>

    <xsl:if test="$module_xml/module/mim_lf/express-g">
      <xsl:variable name="al_armexpressg">
        <xsl:call-template name="annex_letter" >
          <xsl:with-param name="annex_name" select="'MIMexpressG'"/>
          <xsl:with-param name="annex_list" select="$annex_list"/>
        </xsl:call-template>
      </xsl:variable>
      <a
        href="./annex_arm_expg{$FILE_EXT}" target="{$target}">
        Annex <xsl:value-of select="$al_armexpressg"/> MIM EXPRESS-G diagrams
      </a>
      <br/>
    </xsl:if>

    <xsl:variable name="al_com_int">
      <xsl:call-template name="annex_letter" >
        <xsl:with-param name="annex_name" select="'computerinterpretablelisting'"/>
        <xsl:with-param name="annex_list" select="$annex_list"/>
      </xsl:call-template>
    </xsl:variable>
    <a href="./annex_comp_int{$FILE_EXT}" target="{$target}">
      Annex <xsl:value-of select="$al_com_int"/> Computer interpretable listing
    </a>
    <br/>

    <xsl:if test="./usage_guide">
      <xsl:variable name="al_uguide">
        <xsl:call-template name="annex_letter" >
          <xsl:with-param name="annex_name" select="'usageguide'"/>
          <xsl:with-param name="annex_list" select="$annex_list"/>
        </xsl:call-template>
      </xsl:variable>
      <a href="./annex_guide{$FILE_EXT}" target="{$target}">
        Annex <xsl:value-of select="$al_uguide"/> Application protocol implementation and usage guide
      </a>
      <br/>
      <xsl:apply-templates select="./usage_guide/annex_clause" mode="toc">
        <xsl:with-param name="target" select="$target"/>
        <xsl:with-param name="short" select="$short"/>
        <xsl:with-param name="annex_file"  select="'annex_guide'"/>
        <xsl:with-param name="annex_letter"  select="$al_uguide"/>
      </xsl:apply-templates>
    </xsl:if>

    <xsl:if test="./tech_disc">
      <xsl:variable name="al_tech_disc">
        <xsl:call-template name="annex_letter">
          <xsl:with-param name="annex_name" select="'techdisc'"/>
          <xsl:with-param name="annex_list" select="$annex_list"/>
        </xsl:call-template>
      </xsl:variable>
      <a href="./annex_tech_disc{$FILE_EXT}" target="{$target}">
        Annex <xsl:value-of select="$al_tech_disc"/> Technical discussions
      </a>
      <br/>
      <xsl:apply-templates select="./tech_disc/annex_clause" mode="toc">
        <xsl:with-param name="target" select="$target"/>
        <xsl:with-param name="short" select="$short"/>
        <xsl:with-param name="annex_file"  select="'annex_tech_disc'"/>
        <xsl:with-param name="annex_letter"  select="$al_tech_disc"/>
      <xsl:with-param name="max-depth" select="2"/>
      <xsl:with-param name="current-depth" select="0"/>
      </xsl:apply-templates>
    </xsl:if>
    
    <xsl:if test="./changes/change_detail">
      <xsl:variable name="al_changes">
        <xsl:call-template name="annex_letter" >
          <xsl:with-param name="annex_name" select="'changedetail'"/>
          <xsl:with-param name="annex_list" select="$annex_list"/>
        </xsl:call-template>
      </xsl:variable>
      <a href="./annex_changes{$FILE_EXT}" target="{$target}">
        Annex <xsl:value-of select="$al_changes"/> Detailed changes
      </a>
      <br/>
      <xsl:apply-templates select="./changes/change_detail/annex_clause" mode="toc">
        <xsl:with-param name="target" select="$target"/>
        <xsl:with-param name="short" select="$short"/>
        <xsl:with-param name="annex_file"  select="'annex_changes'"/>
        <xsl:with-param name="annex_letter"  select="$al_changes"/>
      <xsl:with-param name="max-depth" select="2"/>
      <xsl:with-param name="current-depth" select="0"/>

      </xsl:apply-templates>
    </xsl:if>

    <a href="./biblio{$FILE_EXT}#biblio" target="{$target}">Bibliography</a>
    <br/>
    <a href="./index_apdoc{$FILE_EXT}#index" target="{$target}">Index</a>
  </small>
  </xsl:template>
  
  <xsl:template match="application_protocol" mode="contents_tables_figures">
    <xsl:param name="target" select="'_self'"/>
    <xsl:variable name="ap_module_dir">
      <xsl:call-template name="ap_module_directory">
        <xsl:with-param name="application_protocol" select="@name"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="count(//figure|//data_plan)!=0">
      <h2>Figures</h2>
      <small>
      <xsl:apply-templates select="//changes/change_summary//figure" mode="toc">
        <xsl:with-param name="target" select="$target"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="//purpose" mode="data_plan_figure">
        <xsl:with-param name="target" select="$target"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="//purpose//figure" mode="toc">
        <xsl:with-param name="target" select="$target"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="//fundamentals" mode="data_plan_figure">
        <xsl:with-param name="target" select="$target"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="//inscope//figure" mode="toc">
        <xsl:with-param name="target" select="$target"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="//outscope//figure" mode="toc">
        <xsl:with-param name="target" select="$target"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="//inforeqt//figure" mode="toc">
        <xsl:with-param name="target" select="$target"/>
      </xsl:apply-templates>


      <xsl:apply-templates select="//aam/idef0/imgfile" mode="aam_figure">
        <xsl:with-param name="target" select="$target"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="//usage_guide//figure" mode="toc">
        <xsl:with-param name="target" select="$target"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="//tech_disc//figure" mode="toc">
        <xsl:with-param name="target" select="$target"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="//changes/change_detail//figure" mode="toc">
        <xsl:with-param name="target" select="$target"/>
      </xsl:apply-templates>
    </small>
    </xsl:if>

    <h2><a name="tables">Tables</a></h2>
    <small>
    <xsl:apply-templates select="//changes/change_summary//table" mode="toc">
      <xsl:with-param name="target" select="$target"/>
    </xsl:apply-templates>

    <xsl:apply-templates select="//purpose//table" mode="toc">
      <xsl:with-param name="target" select="$target"/>
    </xsl:apply-templates>

    <xsl:apply-templates select="//inscope//table" mode="toc">
      <xsl:with-param name="target" select="$target"/>
    </xsl:apply-templates>
    
    <xsl:apply-templates select="//outscope//table" mode="toc">
      <xsl:with-param name="target" select="$target"/>
    </xsl:apply-templates>

    <xsl:apply-templates select="//inforeqt//table" mode="toc">
      <xsl:with-param name="target" select="$target"/>
    </xsl:apply-templates>

    <!-- not yet implemented terminology map -->
    <xsl:apply-templates select="//terminology_map//table" mode="toc"> 
      <xsl:with-param name="target" select="$target"/>
    </xsl:apply-templates>

    <xsl:variable name="table_count_cc">
      <xsl:apply-templates select="." mode="table_count_cc"/>
    </xsl:variable>
    
    <a href="./6_ccs{$FILE_EXT}#cc_arm_table" target="{$target}">
      Table 
      <xsl:value-of select="$table_count_cc+1"/>
      &#8212; Conformance class ARM elements
    </a>
    <br/>

    <a href="./6_ccs{$FILE_EXT}#cc_mim_table" target="{$target}">
      Table 
      <xsl:value-of select="$table_count_cc+2"/> 
      &#8212; Conformance class MIM elements
    </a>
    <br/>

    <a href="./annex_shortnames{$FILE_EXT}#table_b1" target="{$target}">
      Table B.1 &#8212; MIM short names of entities 
    </a>
    <br/>


    <xsl:variable name="annex_list">
      <xsl:apply-templates select="." mode="annex_list"/>
    </xsl:variable>
    <xsl:variable name="annex_no">
      <xsl:call-template name="annex_letter" >
        <xsl:with-param name="annex_name" select="'computerinterpretablelisting'"/>
        <xsl:with-param name="annex_list" select="$annex_list"/>
      </xsl:call-template>
    </xsl:variable>
  <xsl:variable name="module" select="@module_name"/>
  <xsl:variable name="module_ok">
    <xsl:call-template name="check_module_exists">
      <xsl:with-param name="module" select="$module"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$module_ok!='true'">
    <xsl:call-template name="error_message">
      <xsl:with-param name="message">
        <xsl:value-of select="concat('Error AP1: The module ',$module,' does not exist.',
                              '  Correct application_protocol module_name in application_protocol.xml')"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:if>
  <xsl:variable name="module_dir">
    <xsl:call-template name="ap_module_directory">
      <xsl:with-param name="application_protocol" select="$module"/>
    </xsl:call-template>
  </xsl:variable>  
  <xsl:variable name="module_xml" select="document(concat($module_dir,'/module.xml'))"/>

    <xsl:choose>
      <xsl:when test="$module_xml/module/mim_lf or $module_xml/module/arm_lf">
        <a href="./annex_comp_int{$FILE_EXT}#table_e1" target="{$target}">
          Table <xsl:value-of select="$annex_no"/>.1 &#8212; ARM and MIM EXPRESS short and long form listings
        </a>
      </xsl:when>
      <xsl:otherwise>
        <a href="./annex_comp_int{$FILE_EXT}#table_e1" target="{$target}">
          Table <xsl:value-of select="$annex_no"/>.1 &#8212; ARM and MIM EXPRESS listings
        </a>
      </xsl:otherwise>
    </xsl:choose>
    <br/>

    <xsl:apply-templates select="//usage_guide//table" mode="toc">
      <xsl:with-param name="target" select="$target"/>
    </xsl:apply-templates>

    <xsl:apply-templates select="//tech_disc//table" mode="toc">
      <xsl:with-param name="target" select="$target"/>
    </xsl:apply-templates>

    <xsl:apply-templates select="//changes/change_detail//table" mode="toc">
      <xsl:with-param name="target" select="$target"/>
    </xsl:apply-templates>
  </small>


    <!--
    <h2><a name="index">Index</a></h2>
    <a href="index_arm_modules{$FILE_EXT}">ARM modules</a><br/>
    <a href="index_mim_modules{$FILE_EXT}">MIM modules</a><br/>
    <a href="index_resources{$FILE_EXT}">Resource schemas</a><br/>
    <a href="index_arm_express{$FILE_EXT}">ARM EXPRESS</a><br/>
    <a href="index_mim_express{$FILE_EXT}">MIM EXPRESS</a><br/>
    <a href="index_arm_mappings{$FILE_EXT}">ARM Entity Mappings</a><br/>
    <a href="index_arm_express_nav{$FILE_EXT}">ARM EXPRESS Navigation</a><br/>
    -->
  </xsl:template>
	

<xsl:template match="table|figure" mode="toc">
  <xsl:param name="target" select="'_self'"/>
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

  <xsl:variable name="file">
    <xsl:choose>
      <xsl:when test="./ancestor::purpose[1]">
        <xsl:value-of select="concat('introduction',$FILE_EXT)"/>
      </xsl:when>

      <xsl:when test="./ancestor::change_summary[1]">
        <xsl:value-of select="concat('introduction',$FILE_EXT)"/>
      </xsl:when>

      <xsl:when test="./ancestor::inscope[1]|./ancestor::outscope[1]">
        <xsl:value-of select="concat('1_scope',$FILE_EXT)"/>
      </xsl:when>

      <xsl:when test="./ancestor::inforeqt[1]">
        <xsl:value-of select="concat('4_info_reqs',$FILE_EXT)"/>
      </xsl:when>

      <xsl:when test="./ancestor::usage_guide[1]">
        <xsl:value-of select="concat('annex_guide',$FILE_EXT)"/>
      </xsl:when>

      <xsl:when test="./ancestor::tech_disc[1]">
        <xsl:value-of select="concat('annex_tech_disc',$FILE_EXT)"/>
      </xsl:when>

      <xsl:when test="./ancestor::change_detail[1]">
        <xsl:value-of select="concat('annex_changes',$FILE_EXT)"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="aname">
    <xsl:call-template name="table_aname"/>
  </xsl:variable>

  <xsl:variable name="href" select="concat($file,'#',$aname)"/>

  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>

  <xsl:variable name="table_or_fig">
    <xsl:call-template name="first_uppercase">
      <xsl:with-param name="string" select="name(.)"/>
    </xsl:call-template>
  </xsl:variable>

  <a href="{$href}" target="{$target}">
    <xsl:value-of 
      select="concat($table_or_fig,' ',$number, ' &#8212; ', @caption, ./title)"/>
  </a>
  <br/>
</xsl:template>




<xsl:template match="arms_in_ccs" mode="toc">
  <xsl:param name="table_number" select="0"/>
  <xsl:param name="target" select="'_self'"/>
  <a href="./6_ccs{$FILE_EXT}#cc_arm_table" target="{$target}">
    Table 
    <xsl:value-of select="$table_number"/>
    &#8212; Conformance class ARM elements
  </a>
  <br/>
</xsl:template>

<xsl:template match="mims_in_ccs" mode="toc">
  <xsl:param name="target" select="'_self'"/>
  <xsl:param name="table_number" select="0"/>
  <a href="./6_ccs{$FILE_EXT}#cc_mim_table" target="{$target}">
    Table 
    <xsl:value-of select="$table_number"/> 
    &#8212; Conformance class MIM elements
  </a>
  <br/>
</xsl:template>

<!-- Note - this is no longer required on the contents page by ISO -->
<xsl:template match="application_protocol" mode="copyright">
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


<xsl:template match="cc" mode="toc">
  <xsl:param name="target" select="'_self'"/>
  <xsl:variable name="clause_aname" select="concat('cc_',@id)"/>
  <xsl:variable name="clause_hdr"
    select="concat('6.',position(),' Conformance class for ',@name,' (',@id,')')"/> 
  &#160;&#160;&#160;&#160;&#160;
  <a href="./6_ccs{$FILE_EXT}#{$clause_aname}" target="{$target}">
    <xsl:value-of select="$clause_hdr"/>
  </a>
  <br/>
  <!-- 
  <a name="cc_arm_table">
	<a href="6_ccs_arm_table{$FILE_EXT}">          
      Table 1 &#8212; Conformance class(es) and option(s) ARM elements
    </a>  
  </a>
  <br/>
  <a name="cc_mim_table">
    <a href="6_ccs_mim_table{$FILE_EXT}">
      Table 2 &#8212; Conformance class(es) and option(s) MIM elements
    </a>  
  </a>
  <br/> -->
</xsl:template>

<xsl:template match="idef0" mode="toc">
  <xsl:param name="target" select="'_self'"/>
  <xsl:param name="short" select="'no'"/>
  &#160;&#160;&#160;&#160;&#160;
  <a href="./annex_aam{$FILE_EXT}#activity_defn" target="{$target}">
    F.1 Application activity model definitions
  </a>
  <br/>
  <xsl:if test="$short='no'">
    <xsl:for-each select="./page/activity|./icoms/icom">
      <xsl:sort select="normalize-space(./name)"/>
      <xsl:variable name="clause_aname">
        <xsl:choose>
          <!-- only use the name if no identifier provided -->
          <xsl:when test="string-length(normalize-space(@identifier))=0">
            <xsl:value-of select="translate(normalize-space(./name),' ','_')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="translate(normalize-space(@identifier),' ','_')"/>
          </xsl:otherwise>
        </xsl:choose>        
      </xsl:variable>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
      <a href="./annex_aam{$FILE_EXT}#{$clause_aname}" target="{$target}">
        <xsl:value-of select="concat('F.1.',position(),' ',normalize-space(./name))"/>
      </a>
      <br/>
    </xsl:for-each>
  </xsl:if>
  &#160;&#160;&#160;&#160;&#160;
  <a href="./annex_aam{$FILE_EXT}#activity_diags" target="{$target}">
      F.2 Application activity model diagrams 
  </a>
  <br/>

</xsl:template>

<xsl:template match="reqtover" mode="toc">
  <xsl:param name="target" select="'_self'"/>
  <xsl:variable name="module" select="@module"/>
  <xsl:variable name="module_ok">
    <xsl:call-template name="check_module_exists">
      <xsl:with-param name="module" select="$module"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="module_name">
    <xsl:call-template name="module_display_name">
      <xsl:with-param name="module" select="$module"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$module_ok!='true'">
      <xsl:variable name="clause_aname" select="concat('42',$module_name)"/>
      <xsl:variable name="clause_hdr"
        select="concat('4.2.',position()+1,'&#160;XXXXX:&#160;',$module_name)"/>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
      <a href="./4_info_reqs{$FILE_EXT}#{$clause_aname}" target="{$target}">
        <xsl:value-of select="$clause_hdr"/>
      </a>
      <br/>
    </xsl:when>
      
    <xsl:otherwise>
      <xsl:variable name="module_dir">
        <xsl:call-template name="ap_module_directory">
          <xsl:with-param name="application_protocol" select="$module"/>
        </xsl:call-template>
      </xsl:variable>
        
      <xsl:variable name="module_xml" select="document(concat($module_dir,'/module.xml'))"/>
      <xsl:variable name="module_partno" select="concat('ISO 10303-',$module_xml/module/@part)"/>
      
      <xsl:variable name="clause_aname" select="concat('42',$module_name)"/>
      <xsl:variable name="clause_hdr"
        select="concat('4.2.',position()+1,'&#160;',$module_partno,':&#160;',$module_name)"/>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
      <a href="./4_info_reqs{$FILE_EXT}#{$clause_aname}" target="{$target}">
        <xsl:value-of select="$clause_hdr"/>
      </a>
      <br/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="purpose" mode="data_plan_figure">
  <xsl:param name="target" select="'_self'"/>
  <xsl:apply-templates select="./data_plan/imgfile" mode="data_plan_figure">
    <xsl:with-param name="target" select="$target"/>
  </xsl:apply-templates>
</xsl:template>


<xsl:template match="fundamentals" mode="data_plan_figure">
  <xsl:param name="target" select="'_self'"/>
  <xsl:variable name="figure_count">
    <xsl:call-template name="count_figures_from_fundamentals"/>
  </xsl:variable>  
  <xsl:apply-templates select="./data_plan/imgfile" mode="data_plan_figure">
    <xsl:with-param name="target" select="$target"/>
    <xsl:with-param name="number" select="$figure_count"/>
  </xsl:apply-templates> 
</xsl:template>


<xsl:template match="imgfile" mode="data_plan_figure">
  <xsl:param name="number" select="0"/>
  <xsl:param name="target" select="'_self'"/>
  <xsl:variable name="fig_count" select="position()"/>
  <xsl:variable name="fig_title" 
    select="concat('Figure ', $number+$fig_count, ' &#8212; Data planning model')"/>
  <xsl:variable name="file_href">
    <xsl:call-template name="set_file_ext">
      <xsl:with-param name="filename" select="concat('../',@file)"/>
    </xsl:call-template>
  </xsl:variable>
  <a href="{$file_href}" target="{$target}">
    <xsl:value-of select="$fig_title"/>
  </a>
  <br/>
</xsl:template>


<xsl:template match="imgfile" mode="aam_figure">
  <xsl:param name="target" select="'_self'"/>
  <xsl:variable name="ap_dir">
    <xsl:value-of select="/application_protocol/@name"/>
  </xsl:variable>

  <xsl:variable name="aam_href">
	  <xsl:call-template name="set_file_ext">
      <xsl:with-param name="filename" select="concat('../',./@file)"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="aam_path">
    <xsl:value-of select="concat('../../data/application_protocols/', $ap_dir, '/aam.xml')"/>
  </xsl:variable>

  <xsl:variable name="fig_no" select="position()"/>
  <xsl:variable name="aam_xml" select="document(string($aam_path))"/>
  <xsl:variable name="fig_title" select="$aam_xml/idef0/page[position() = $fig_no]/@title"/>
  <xsl:variable name="node" select="$aam_xml/idef0/page[position() = $fig_no]/@node"/>

  <a href="{$aam_href}" target="{$target}">
    Figure F.<xsl:value-of select="$fig_no"/> &#8212; <xsl:value-of select="$node"/> <xsl:value-of select="concat(' ', $fig_title)"/>
  </a>
  <br/>
</xsl:template>


<xsl:template match="annex_clause" mode="toc">
  <xsl:param name="target" select="'_self'"/>
  <xsl:param name="short" select="'no'"/>
  <xsl:param name="annex_letter"/>
  <xsl:param name="annex_file"/>
  <xsl:param name="indentation"/>
  <xsl:param name="max-depth"/>
  <xsl:param name="current-depth"/>
  <xsl:if test="$short = 'no' and $max-depth != $current-depth" >
    <xsl:variable name="annex_no">
      <xsl:apply-templates select="." mode="number"/>
    </xsl:variable>
    <xsl:variable name="new_indentation" select="concat('&#160;&#160;&#160;&#160;&#160;',$indentation)"/>
    <xsl:value-of select="$new_indentation"/>
    <a href="./{$annex_file}{$FILE_EXT}#{@title}" target="{$target}">
      <xsl:value-of select="concat($annex_letter,'.',$annex_no,' ',@title)"/>
    </a>
    <br/>
    <xsl:apply-templates select="./annex_clause" mode="toc">
      <xsl:with-param name="target" select="$target"/>
      <xsl:with-param name="short" select="$short"/>
        <xsl:with-param name="annex_file"  select="$annex_file"/>
      <xsl:with-param name="annex_letter"  select="$annex_letter"/>
      <xsl:with-param name="indentation" select="$new_indentation"/>
      <xsl:with-param name="max-depth" select="$max-depth"/>
      <xsl:with-param name="current-depth" select="$current-depth + 1"/>
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>


</xsl:stylesheet>
