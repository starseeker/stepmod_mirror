<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_contents.xsl,v 1.11 2014/01/24 17:46:32 nigelshaw Exp $
  Author:  Mike Ward, Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: Display the main set of frames for an AP document.     
-->

<!-- BOM -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!--<xsl:import href="../sect_contents.xsl"/>-->
  <xsl:import href="business_object_model.xsl"/>
  <!-- <xsl:import href="business_object_model_clause_nofooter.xsl"/> -->
  <xsl:import href="business_object_model_clause.xsl"/>
  <xsl:output method="html"/>
  
  <xsl:variable name="bom_xml" select="document(concat('../../data/business_object_models/',/business_object_model_clause/@directory , '/bom.xml'))"/>

	
  <xsl:template match="business_object_model">
    <xsl:apply-templates select="." mode="linear"/>
    <xsl:apply-templates select="." mode="contents_tables_figures"/>
    <!--
    <xsl:apply-templates select="../business_object_model" mode="contents_tables_figures"/>
    <!-\- no longer required by ISO
       <xsl:apply-templates select="../business_object_model" mode="copyright"/>
       -\->
      
    <br/><br/>
    <p>&#169; ISO <xsl:value-of select="@publication.year"/> &#8212; All rights reserved</p>
    -->
  </xsl:template>
	
  <xsl:template match="business_object_model" mode="contents">
    <xsl:param name="target" select="'_self'"/>
   <!-- if complete is yes then display the introduction foreword etc -->
    <xsl:param name="complete" select="'yes'"/>
   
   <!-- <xsl:variable name="annex_list">
      <xsl:apply-templates select="." mode="annex_list"/>
    </xsl:variable>

    <xsl:variable name="arm_schema_name" select="concat(@name,'_arm')"/>
    <xsl:variable name="aim_schema_name" select="concat(@name,'_mim')"/>
	
    <xsl:variable name="business_object_model_dir">
      <xsl:call-template name="business_object_model_directory">
        <xsl:with-param name="business_object_model" select="@name"/>
      </xsl:call-template>
    </xsl:variable>
   		
    <xsl:variable name="ccs_xml" select="document(concat($business_object_model_dir, '/ccs.xml'))"/>-->
    <small>
      <table width="100%" border="1">
        <tr>
          <td valign="top">
            <xsl:if test="$complete='yes'">
              <a href="./cover{$FILE_EXT}" target="{$target}">Cover page</a>
              <br/>
              <a href="./contents{$FILE_EXT}" target="{$target}">Table of contents</a>
              <br/>
              <a href="./cover{$FILE_EXT}#copyright" target="{$target}">Copyright</a>
              <br/>
              <a href="./foreword{$FILE_EXT}" target="{$target}">Foreword</a>
              <br/>
              <a href="./introduction{$FILE_EXT}" target="{$target}">Introduction</a>
              <br/>
              <a href="./1_scope{$FILE_EXT}" target="{$target}">1 Scope</a>
              <br/>
              <a href="./2_refs{$FILE_EXT}" target="{$target}">2 Normative references</a>
              <br/> 
              <a href="./3_defs{$FILE_EXT}" target="{$target}">3 Terms, definitions and abbreviated terms</a>  
              <br/>
               &#160;&#160;&#160;&#160;&#160;
              <a href="./3_defs{$FILE_EXT}#termsdefns" target="{$target}">3.1 Terms and definitions</a>
              <br/>
              &#160;&#160;&#160;&#160;&#160;
              <a href="./3_defs{$FILE_EXT}#abbrvterms" target="{$target}">3.2 Abbreviated terms</a>
            </xsl:if>
          </td>
          <td valign="top">
            <a href="./4_info_reqs{$FILE_EXT}" target="{$target}">4 Business object model requirements</a>
            <br/>
            &#160;&#160;&#160;&#160;&#160;
            <a href="./4_info_reqs{$FILE_EXT}#general" target="{$target}">4.1 General</a>
            <br/>
            &#160;&#160;&#160;&#160;&#160;
            <a href="./4_info_reqs{$FILE_EXT}#capabilities" target="{$target}">4.2 Business object model capabilities</a>
            <br/>
            &#160;&#160;&#160;&#160;&#160;
            <a href="./4_info_reqs{$FILE_EXT}#fundamentals" target="{$target}">4.3 Fundamental concepts and assumptions</a>
            <br/>
	    <xsl:choose>
		    <xsl:when test="$bom_xml//constant" >
            &#160;&#160;&#160;&#160;&#160;
	    <a href="./4_info_reqs{$FILE_EXT}#constants" target="{$target}">4.4 Business object model constant 
		    definition<xsl:if test="count($bom_xml//constant)>1">s</xsl:if></a>
            <br/>
            &#160;&#160;&#160;&#160;&#160;
            <a href="./4_info_reqs{$FILE_EXT}#types" target="{$target}">4.5 Business object model type definitions</a>
            <br/>
            &#160;&#160;&#160;&#160;&#160;
            <a href="./4_info_reqs{$FILE_EXT}#entities" target="{$target}">4.6 Business object model entity definitions</a>
	    <br/>
	    	</xsl:when>
		<xsl:otherwise>
            &#160;&#160;&#160;&#160;&#160;
	    <a href="./4_info_reqs{$FILE_EXT}#types" target="{$target}">4.4 Business object model type definitions</a>
            <br/>
            &#160;&#160;&#160;&#160;&#160;
            <a href="./4_info_reqs{$FILE_EXT}#entities" target="{$target}">4.5 Business object model entity definitions</a>
            <br/>
		</xsl:otherwise>
	     </xsl:choose>
            <a href="./5_main{$FILE_EXT}#mappings" target="{$target}">5 Business object model mapping</a>
          </td>
          <td valign="top">
            <a href="./annex_obj_reg{$FILE_EXT}" target="{$target}">Annex A Information object registration</a>
            <br/>
            <a href="./annex_xsd_der{$FILE_EXT}" target="{$target}">Annex B Derivation of XML schema</a>
            <br/>
            <a href="./annex_bom_expg{$FILE_EXT}" target="{$target}">Annex C BO model EXPRESS-G</a>&#160;&#160;<img align="middle" border="0" alt="EXPRESS-G" src="../../../../images/expg.gif"/>
            <br/>
            <a href="./annex_comp_int{$FILE_EXT}" target="{$target}">Annex D Computer interpretable listings</a>
            <br/>
            <a href="./biblio{$FILE_EXT}#biblio" target="{$target}">Bibliography</a>
            <br/>
            <a href="./index_bomdoc{$FILE_EXT}#index" target="{$target}">Index</a>
          </td>
        </tr>
      </table>
</small>
  </xsl:template>

  <xsl:template match="business_object_model" mode="linear">
    <xsl:param name="target" select="'_self'"/>
   <!-- if complete is yes then display the introduction foreword etc -->
    <xsl:param name="complete" select="'yes'"/>
   
   <!-- <xsl:variable name="annex_list">
      <xsl:apply-templates select="." mode="annex_list"/>
    </xsl:variable>

    <xsl:variable name="arm_schema_name" select="concat(@name,'_arm')"/>
    <xsl:variable name="aim_schema_name" select="concat(@name,'_mim')"/>
	
    <xsl:variable name="business_object_model_dir">
      <xsl:call-template name="business_object_model_directory">
        <xsl:with-param name="business_object_model" select="@name"/>
      </xsl:call-template>
    </xsl:variable>
   		
    <xsl:variable name="ccs_xml" select="document(concat($business_object_model_dir, '/ccs.xml'))"/>-->
            <xsl:if test="$complete='yes'">
              <a href="./cover{$FILE_EXT}" target="{$target}">Cover page</a>
              <br/>
              <a href="./contents{$FILE_EXT}" target="{$target}">Table of contents</a>
              <br/>
              <a href="./cover{$FILE_EXT}#copyright" target="{$target}">Copyright</a>
              <br/>
              <a href="./foreword{$FILE_EXT}" target="{$target}">Foreword</a>
              <br/>
              <a href="./introduction{$FILE_EXT}" target="{$target}">Introduction</a>
              <br/>
              <a href="./1_scope{$FILE_EXT}" target="{$target}">1 Scope</a>
              <br/>
              <a href="./2_refs{$FILE_EXT}" target="{$target}">2 Normative references</a>
              <br/>
            </xsl:if>
            <a href="./3_defs{$FILE_EXT}" target="{$target}">3 Terms, definitions and abbreviated terms</a>  
            <br/>
            &#160;&#160;&#160;&#160;&#160;
            <a href="./3_defs{$FILE_EXT}#termsdefns" target="{$target}">3.1 Terms and definitions</a>
            <br/>
            &#160;&#160;&#160;&#160;&#160;
            <a href="./3_defs{$FILE_EXT}#abbrvterms" target="{$target}">3.2 Abbreviated terms</a>
            <br/>
            <a href="./4_info_reqs{$FILE_EXT}" target="{$target}">4 Business object model requirements</a>
            <br/>
            &#160;&#160;&#160;&#160;&#160;
            <a href="./4_info_reqs{$FILE_EXT}#general" target="{$target}">4.1 General</a>
            <br/>
            &#160;&#160;&#160;&#160;&#160;
            <a href="./4_info_reqs{$FILE_EXT}#capabilities" target="{$target}">4.2 Business object model capabilities</a>
            <br/>
            &#160;&#160;&#160;&#160;&#160;
            <a href="./4_info_reqs{$FILE_EXT}#fundamentals" target="{$target}">4.3 Fundamental concepts and assumptions</a>
            <br/>
	    <xsl:choose>
		    <xsl:when test="$bom_xml//constant" >
            &#160;&#160;&#160;&#160;&#160;
	    <a href="./4_info_reqs{$FILE_EXT}#constants" target="{$target}">4.4 Business object model constant 
		    definition<xsl:if test="count($bom_xml//constant)>1">s</xsl:if></a>
            <br/>
            &#160;&#160;&#160;&#160;&#160;
            <a href="./4_info_reqs{$FILE_EXT}#types" target="{$target}">4.5 Business object model type definitions</a>
            <br/>
            &#160;&#160;&#160;&#160;&#160;
            <a href="./4_info_reqs{$FILE_EXT}#entities" target="{$target}">4.6 Business object model entity definitions</a>
	    <br/>
	    	</xsl:when>
		<xsl:otherwise>
            &#160;&#160;&#160;&#160;&#160;
	    <a href="./4_info_reqs{$FILE_EXT}#types" target="{$target}">4.4 Business object model type definitions</a>
            <br/>
            &#160;&#160;&#160;&#160;&#160;
            <a href="./4_info_reqs{$FILE_EXT}#entities" target="{$target}">4.5 Business object model entity definitions</a>
            <br/>
		</xsl:otherwise>
	     </xsl:choose>
            <a href="./5_main{$FILE_EXT}" target="{$target}">5 Business object model mapping</a>
            <br/>
            <a href="./annex_obj_reg{$FILE_EXT}" target="{$target}">Annex A Information object registration</a>
            <br/>
            <a href="./annex_xsd_der{$FILE_EXT}" target="{$target}">Annex B Derivation of XML schema</a>
            <br/>
            <a href="./annex_bom_expg{$FILE_EXT}" target="{$target}">Annex C BO model EXPRESS-G</a>&#160;&#160;<img align="middle" border="0" alt="EXPRESS-G" src="../../../../images/expg.gif"/>
            <br/>
            <a href="./annex_comp_int{$FILE_EXT}" target="{$target}">Annex D Computer interpretable listings</a>
            <br/>
            <a href="./biblio{$FILE_EXT}#biblio" target="{$target}">Bibliography</a>
            <br/>
            <a href="./index_apdoc{$FILE_EXT}#index" target="{$target}">Index</a>
  </xsl:template>

<xsl:template match="business_object_model" mode="contents_tables_figures">
    <xsl:param name="target" select="'_self'"/>
    <xsl:variable name="bom_desc_dir">
      <xsl:call-template name="business_object_model_directory">
        <xsl:with-param name="business_object_model" select="@name"/>
      </xsl:call-template>
    </xsl:variable>
     <xsl:variable name="bom_desc" select="document(concat($bom_desc_dir,'/bom_descriptions.xml'))"/>

    <xsl:if test="count(//figure)!=0">
      <h2>Figures</h2>
      <small>
      <xsl:apply-templates select="//changes/change_summary//figure" mode="toc">
        <xsl:with-param name="target" select="$target"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="//purpose//figure" mode="toc">
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
     <!-- included figures in BOM_descriptions file -->

     <xsl:apply-templates select="$bom_desc//figure" mode="toc">
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

     <xsl:apply-templates select="$bom_desc//table" mode="toc">
        <xsl:with-param name="target" select="$target"/>
      </xsl:apply-templates>

    <!-- not yet implemented terminology map -->
    <xsl:apply-templates select="//terminology_map//table" mode="toc"> 
      <xsl:with-param name="target" select="$target"/>
    </xsl:apply-templates>

    <xsl:variable name="table_count_cc">
      <xsl:apply-templates select="." mode="table_count_cc"/>
    </xsl:variable>
    


    <xsl:variable name="annex_list">
      <xsl:apply-templates select="." mode="annex_list"/>
    </xsl:variable>
    <xsl:variable name="annex_no">
      <xsl:call-template name="annex_letter" >
        <xsl:with-param name="annex_name" select="'computerinterpretablelisting'"/>
        <xsl:with-param name="annex_list" select="$annex_list"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- <xsl:variable name="module" select="@module_name"/>
  <xsl:variable name="module_ok">
    <xsl:call-template name="check_module_exists">
      <xsl:with-param name="module" select="$module"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$module_ok!='true'">
    <xsl:call-template name="error_message">
      <xsl:with-param name="message">
        <xsl:value-of select="concat('Error AP1: The module ',$module,' does not exist.',
                              '  Correct business_object_model module_name in business_object_model.xml')"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:if>
  -->
  <!-- <xsl:variable name="module_dir">
    <xsl:call-template name="business_object_model_directory">
      <xsl:with-param name="business_object_model" select="$module"/>
    </xsl:call-template>
  </xsl:variable>  
  <xsl:variable name="module_xml" select="document(concat($module_dir,'/module.xml'))"/>

    <xsl:choose>
      <xsl:when test="$module_xml/module/mim_lf or $module_xml/module/arm_lf">
        <a href="./annex_comp_int{$FILE_EXT}#table_e1" target="{$target}">
          Table <xsl:value-of select="$annex_no"/>.1 &#8212; ARM and MIM EXPRESS short and long form listings
        </a>
      </xsl:when>
      <xsl:otherwise> -->
        <a href="./annex_comp_int{$FILE_EXT}#table_e1" target="{$target}">
          Table <xsl:value-of select="$annex_no"/>.1 &#8212; ARM and MIM EXPRESS listings
  </a>
  <!--
      </xsl:otherwise>
    </xsl:choose>
    -->
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
      
      <xsl:when test="./ancestor::ext_description">
        <xsl:value-of select="concat('4_info_reqs',$FILE_EXT)"/>
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





<!-- Note - this is no longer required on the contents page by ISO -->
<xsl:template match="business_object_model" mode="copyright">
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
      
      
      
      <xsl:variable name="clause_aname" select="concat('42',$module_name)"/>
      
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
      <a href="./4_info_reqs{$FILE_EXT}#{$clause_aname}" target="{$target}">
        <!--<xsl:value-of select="$clause_hdr"/>-->
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
    <xsl:value-of select="/business_object_model/@name"/>
  </xsl:variable>

  <xsl:variable name="aam_href">
    <xsl:call-template name="set_file_ext">
      <xsl:with-param name="filename" select="concat('../',./@file)"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="aam_path">
    <xsl:value-of select="concat('../../data/business_object_models/', $ap_dir, '/aam.xml')"/>
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
