<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: frame_index.xsl,v 1.2 2003/05/22 22:30:38 nigelshaw Exp $
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
  </xsl:template>
	
  <xsl:template match="application_protocol" mode="contents">
    <xsl:param name="target" select="'_self'"/>
    <!-- if complete is yes then display the introduction foreword etc -->
    <xsl:param name="complete" select="'no'"/>

    <xsl:variable name="arm_schema_name" select="concat(@name,'_arm')"/>
    <xsl:variable name="aim_schema_name" select="concat(@name,'_mim')"/>
	
    <xsl:variable name="application_protocol_dir">
      <xsl:call-template name="application_protocol_directory">
        <xsl:with-param name="application_protocol" select="@name"/>
      </xsl:call-template>
    </xsl:variable>
		
    <xsl:variable name="ap_module_dir">
      <xsl:call-template name="ap_module_directory">
        <xsl:with-param name="application_protocol" select="@name"/>
      </xsl:call-template>
    </xsl:variable>
		
    <xsl:variable name="arm_xml" select="concat($ap_module_dir,'/arm.xml')"/>
    <xsl:variable name="aim_xml" select="concat($ap_module_dir,'/mim.xml')"/>


    <h2>Contents</h2>
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
    <xsl:apply-templates select="inforeqt/reqtover" mode="toc"/>
    <a href="./5_main{$FILE_EXT}" target="{$target}">5 Application interpreted model</a>
    <br/>
    <a href="./sys/6_ccs{$FILE_EXT}" target="{$target}">6 Conformance requirements</a>
    <br/>
    <a href="./a_exp_lf{$FILE_EXT}" target="{$target}">A EXPRESS expanded listing</a>
    <br/>
    <a href="./b_shortnames{$FILE_EXT}">
      B AIM short names
    </a>
    <br/>
    <a href="./c_imp_meth{$FILE_EXT}" target="{$target}">
      C Implementation method specific requirements
    </a>
    <br/>
    <a href="./d_pics{$FILE_EXT}" target="{$target}">
      D Protocol Implementation Conformance Statement (PICS) form
    </a>
    <br/>
    <a href="./e_obj_reg{$FILE_EXT}" target="{$target}">
      E Information object registration
    </a>
    <br/>
    <a href="./f_aam{$FILE_EXT}" target="{$target}">
      F Application activity model
    </a>
    <br/>
    <a href="./g_exp_aim{$FILE_EXT}" target="{$target}">G Computer interpretable listing</a>
    <br/>
    <a href="./f_arm_expg{$FILE_EXT}" target="{$target}">F Application reference model (EXPRESS-G)</a>
    <br/>
    <xsl:if test="./usage_guide">
      <a href="./h_guide{$FILE_EXT}" target="{$target}">H Application protocol implementation and usage guide</a>
      <br/>
    </xsl:if>
    <xsl:if test="./tech_disc">
      <a href="./j_tech_disc{$FILE_EXT}" target="{$target}">J Technical discussions</a>
      <br/>
    </xsl:if>
    <a href="./k_ae_index{$FILE_EXT}#k_ae_index" target="{$target}">K Application object index</a>
    <br/>			
    <a href="./biblio{$FILE_EXT}#biblio"
      target="{$target}">Bibliography</a>
    <xsl:apply-templates select="." mode="copyright"/>
  </xsl:template>
  
  <xsl:template match="imgfile" mode="expressg_figure">
		<xsl:variable name="number">
                  <xsl:number/>
                </xsl:variable>
                <xsl:variable name="fig_no">
                  <xsl:choose>
                    <xsl:when test="name(../..)='arm'">
                      <xsl:choose>
                        <xsl:when test="$number=1">
                          <xsl:value-of select="concat('Figure F.',$number, ' - ARM Schema level EXPRESS-G diagram ',$number)"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="concat('Figure F.',$number, ' - ARM Entity level EXPRESS-G diagram ',($number - 1))"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:when test="name(../..)='mim'">
                      <xsl:choose>
                        <xsl:when test="$number=1">
                          <xsl:value-of select="concat('Figure A.',$number, ' - AIM Schema level EXPRESS-G diagram ',$number)"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="concat('Figure A.',$number, ' - AIM Entity level EXPRESS-G diagram ',($number - 1))"/>
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

	<xsl:template match="module" mode="contents_tables_figures">
          <xsl:param name="target" select="'_self'"/>
		<xsl:variable name="ap_module_dir">
			<xsl:call-template name="ap_module_directory">
				<xsl:with-param name="application_protocol" select="@name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="arm_xml" select="concat($ap_module_dir,'/arm.xml')"/>
		<xsl:variable name="arm_desc_xml" select="document($arm_xml)/express/@description.file"/>
		<xsl:variable name="aim_xml" select="concat($ap_module_dir,'/mim.xml')"/>
		<xsl:variable name="aim_desc_xml" select="document($aim_xml)/express/@description.file"/>
		<h3>Tables</h3>
		<xsl:apply-templates select="//table" mode="toc"/>
                <a href="./6_ccs{$FILE_EXT}#table_1" target="{$target}">
                  Table 1 &#8212; Conformance classes per UOF
                </a>
                <br/>
                <a href="./6_ccs{$FILE_EXT}#table_2" target="{$target}">
                  Table 2 &#8212; Conformance classes per ARM entity
                </a>
                <br/>
                <a href="./6_ccs{$FILE_EXT}#table_3">
                  Table 3 &#8212; Conformance classes per MIM entity
                </a>
                <br/>
                <xsl:choose>
			<xsl:when test="$arm_desc_xml">
				<xsl:apply-templates select="document($arm_desc_xml)//table" mode="toc"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="document($arm_xml)//table" mode="toc"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="$aim_desc_xml">
				<xsl:apply-templates select="document($aim_desc_xml)//table" mode="toc"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="document($aim_xml)//table" mode="toc"/>
			</xsl:otherwise>
		</xsl:choose>
		<a href="./g_exp{$FILE_EXT}#table_g1">
			Table G.1 &#8212; ARM to AIM EXPRESS short and long form listing.
		</a>
		<h3>Figures</h3>
		<xsl:apply-templates select="./purpose//figure" mode="toc"/>
		<xsl:apply-templates select="./inscope//figure" mode="toc"/>
		<xsl:apply-templates select="./outscope//figure" mode="toc"/>
		<xsl:choose>
			<xsl:when test="$arm_desc_xml">
				<xsl:apply-templates select="document($arm_desc_xml)//figure" mode="toc"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="document($arm_xml)//figure" mode="toc"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="$aim_desc_xml">
				<xsl:apply-templates select="document($aim_desc_xml)//figure" mode="toc"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="document($aim_xml)//figure" mode="toc"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="./arm/express-g/imgfile" mode="expressg_figure"/>
		<xsl:apply-templates select="./mim/express-g/imgfile" mode="expressg_figure"/>
		<xsl:apply-templates select="./usage_guide//figure" mode="toc"/>
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
      <a href="./4_info_reqs{$FILE_EXT}#{$clause_aname}">
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
      <a href="./4_info_reqs{$FILE_EXT}#{$clause_aname}">
        <xsl:value-of select="$clause_hdr"/>
      </a>
      <br/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>