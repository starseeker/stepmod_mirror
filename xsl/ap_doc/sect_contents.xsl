<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_contents.xsl,v 1.18 2003/06/04 09:50:16 robbod Exp $
  Author:  Mike Ward, Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: Display the main set of frames for an AP document.     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../sect_contents.xsl"/>
  <xsl:import href="application_protocol.xsl"/>
  <xsl:import href="application_protocol_clause.xsl"/>
  <xsl:output method="html"/>
	
  <xsl:template match="application_protocol">
    <xsl:apply-templates select="../application_protocol" mode="contents"/>
    <xsl:apply-templates select="../application_protocol" mode="contents_tables_figures"/>
    <xsl:apply-templates select="../application_protocol" mode="copyright"/>
  </xsl:template>
	
  <xsl:template match="application_protocol" mode="contents">
    <xsl:param name="target" select="'_self'"/>
    <!-- if complete is yes then display the introduction foreword etc -->
    <xsl:param name="complete" select="'no'"/>

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
    <xsl:variable name="arm_xml" select="concat($ap_module_dir,'/arm.xml')"/>
    <xsl:variable name="aim_xml" select="concat($ap_module_dir,'/mim.xml')"/>

    <h2><a name="contents"></a>Contents</h2>
    <xsl:if test="$complete='yes'">
      <a href="./cover{$FILE_EXT}" target="{$target}">Cover page</a>
      <br/>
      <a href="./foreword{$FILE_EXT}" target="{$target}">Foreword</a>
      <br/>
      <a href="./contents{$FILE_EXT}" target="{$target}">Table of contents</a>
      <br/>
      <a href="./contents{$FILE_EXT}#copyright" target="{$target}">Copyright</a>
      <br/>
      <a href="./introduction{$FILE_EXT}" target="{$target}">Introduction</a><br/>      
    </xsl:if>

    <a href="./1_scope{$FILE_EXT}" target="{$target}">1 Scope</a><br/>
    <a href="./2_refs{$FILE_EXT}" target="{$target}">2 Normative references</a><br/>
    <xsl:choose>
      <xsl:when test="./definition/term">
        <a href="./3_defs{$FILE_EXT}" target="{$target}">
          3 Terms, definitions and abbreviations
        </a>
        <br/>
      </xsl:when>
      <xsl:otherwise>
        <a href="./3_defs{$FILE_EXT}" target="{$target}">
          3 Terms and abbreviations
        </a>
        <br/>
      </xsl:otherwise>
    </xsl:choose>
    
    <a href="./4_info_reqs{$FILE_EXT}" target="{$target}">4 Information requirements</a>
    <br/>
    &#160;&#160;&#160;&#160;&#160;
    <a href="./4_info_reqs{$FILE_EXT}#41" target="{$target}">4.1 Business concepts and terminology</a>
    <br/>
    &#160;&#160;&#160;&#160;&#160;
    <a href="./4_info_reqs{$FILE_EXT}#42" target="{$target}">4.2 Information requirements model</a>
    <br/>
    &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
    <a href="./4_info_reqs{$FILE_EXT}#421" target="{$target}">4.2.1 Model overview</a>
    <br/>
    <xsl:apply-templates select="inforeqt/reqtover" mode="toc">
      <xsl:with-param name="target" select="$target"/>
    </xsl:apply-templates>
    <a href="./5_main{$FILE_EXT}" target="{$target}">5 Application interpreted model</a>
    <br/>
    <a href="./6_ccs{$FILE_EXT}" target="{$target}">6 Conformance requirements</a>
    <br/>
    <a href="./annex_exp_lf{$FILE_EXT}" target="{$target}">A EXPRESS expanded listing</a>
    <br/>
    <a href="./annex_shortnames{$FILE_EXT}" target="{$target}">
      B AIM short names
    </a>
    <br/>
    <a href="./annex_imp_meth{$FILE_EXT}" target="{$target}">
      C Implementation method specific requirements
    </a>
    <br/>
    <a href="./annex_pics{$FILE_EXT}" target="{$target}">
      D Protocol Implementation Conformance Statement (PICS) form
    </a>
    <br/>
    <a href="./annex_obj_reg{$FILE_EXT}" target="{$target}">
      E Information object registration
    </a>
    <br/>
    <a href="./annex_aam{$FILE_EXT}" target="{$target}">
      F Application activity model
    </a>
    <br/>

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
        <xsl:value-of select="$al_armexpressg"/> MIM EXPRESS-G diagrams
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
      <xsl:value-of select="$al_com_int"/> Computer interpretable listing
    </a>
    <br/>

    <xsl:if test="$module_xml/module/usage_guide">
      <xsl:variable name="al_uguide">
        <xsl:call-template name="annex_letter" >
          <xsl:with-param name="annex_name" select="'usageguide'"/>
          <xsl:with-param name="annex_list" select="$annex_list"/>
        </xsl:call-template>
      </xsl:variable>
      <a href="./annex_guide{$FILE_EXT}" target="{$target}">
        <xsl:value-of select="$al_uguide"/> Application protocol implementation and usage guide
      </a>
      <br/>
    </xsl:if>

    <xsl:if test="$module_xml/module/tech_disc">
      <xsl:variable name="al_tech_disc">
        <xsl:call-template name="annex_letter" >
          <xsl:with-param name="annex_name" select="'techdisc'"/>
          <xsl:with-param name="annex_list" select="$annex_list"/>
        </xsl:call-template>
      </xsl:variable>
      <a href="./annex_tech_disc{$FILE_EXT}" target="{$target}">
        <xsl:value-of select="$al_tech_disc"/> Technical discussions
      </a>
      <br/>
    </xsl:if>
    
    <xsl:if test="$module_xml/module/changes/change_detail">
      <xsl:variable name="al_changes">
        <xsl:call-template name="annex_letter" >
          <xsl:with-param name="annex_name" select="'changedetail'"/>
          <xsl:with-param name="annex_list" select="$annex_list"/>
        </xsl:call-template>
      </xsl:variable>
      <a href="./annex_changes{$FILE_EXT}" target="{$target}">
        <xsl:value-of select="$al_changes"/> Detailed changes
      </a>
      <br/>
    </xsl:if>

    <a href="./biblio{$FILE_EXT}#biblio" target="{$target}">Bibliography</a>
  </xsl:template>
  
  <xsl:template match="application_protocol" mode="contents_tables_figures">
    <xsl:param name="target" select="'_self'"/>
    <xsl:variable name="ap_module_dir">
      <xsl:call-template name="ap_module_directory">
        <xsl:with-param name="application_protocol" select="@name"/>
      </xsl:call-template>
    </xsl:variable>

    <h2><a name="tables">Tables</a></h2>
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
    <xsl:variable name="ccs_path"
      select="concat('../../data/application_protocols/', @name, '/ccs.xml')"/>
    <xsl:variable name="ccs_xml" select="document(string($ccs_path))"/>
    <xsl:apply-templates select="$ccs_xml/conformance/arms_in_ccs" mode="toc">
      <xsl:with-param name="target" select="$target"/>
      <xsl:with-param name="table_number" select="$table_count_cc+1"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="$ccs_xml/conformance/mims_in_ccs" mode="toc">
      <xsl:with-param name="target" select="$target"/>
      <xsl:with-param name="table_number" select="$table_count_cc+2"/>
    </xsl:apply-templates>

    <a href="./annex_shortnames{$FILE_EXT}#table_b1">
      Table B.1 &#8212; ARM to AIM EXPRESS short and long form listing.
    </a>
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


    <xsl:if test="count(//figure)!=0">
      <h2>Figures</h2>
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
    </xsl:if>

    <h2><a name="index">Index</a></h2>
    <a href="index_arm_modules{$FILE_EXT}">ARM modules</a><br/>
    <a href="index_mim_modules{$FILE_EXT}">MIM modules</a><br/>
    <a href="index_resources{$FILE_EXT}">Resource schemas</a><br/>
    <a href="index_arm_express{$FILE_EXT}">ARM EXPRESS</a><br/>
    <a href="index_mim_express{$FILE_EXT}">MIM EXPRESS</a><br/>
    <a href="index_arm_mappings{$FILE_EXT}">ARM Entity Mappings</a><br/>

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
    &#8212; Conformance classes per ARM entity
  </a>
  <br/>
</xsl:template>

<xsl:template match="mims_in_ccs" mode="toc">
  <xsl:param name="target" select="'_self'"/>
  <xsl:param name="table_number" select="0"/>
  <a href="./6_ccs{$FILE_EXT}#cc_mim_table" target="{$target}">
    Table 
    <xsl:value-of select="$table_number"/> 
    &#8212; Conformance classes per MIM entity
  </a>
  <br/>
</xsl:template>


<xsl:template match="application_protocol" mode="copyright">
  <!-- the copyright is already at the bottom of the page from
       module_clause.xsl 
  <p>
    &#169;ISO
    <xsl:value-of select="@publication.year"/>
  </p>
  -->
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

</xsl:stylesheet>