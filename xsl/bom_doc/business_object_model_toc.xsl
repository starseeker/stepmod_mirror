<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
  $Id: business_object_model_toc.xsl,v 1.4 2014/07/02 17:11:42 mikeward Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep Limited.
  Purpose: Display the main set of frames for an BOM document.     
-->

<!-- BOM -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
 
  
	
  <xsl:template match="business_object_model" mode="TOCmultiplePage">
    <xsl:param name="selected"/>
    <xsl:param name="business_object_model_root" select="'..'"/>

    
   <xsl:variable name="annex_list">
     <xsl:apply-templates select="." mode="annex_list"/>
   </xsl:variable>
   

    <xsl:apply-templates select="." mode="TOCbannertitle">
      <xsl:with-param name="module_root" select="$business_object_model_root"/>
    </xsl:apply-templates>

    <xsl:variable name="arm_schema_name" select="concat(@name,'_arm')"/>
    <xsl:variable name="aim_schema_name" select="concat(@name,'_mim')"/>
    <xsl:variable name="bom_name" select="./@name"/>
    <table border="1" cellspacing="1" width="100%">
      <tr>
        <td valign="TOP">
          <p class="toc">
            <a href="{$business_object_model_root}/sys/cover{$FILE_EXT}">Cover page</a>
            <br/>
            <a href="{$business_object_model_root}/sys/contents{$FILE_EXT}">Table of contents</a>
            <br/>
            <a href="{$business_object_model_root}/sys/cover{$FILE_EXT}#copyright">Copyright</a>
            <br/>
            <a href="{$business_object_model_root}/sys/foreword{$FILE_EXT}">Foreword</a>
            <br/>
            <a href="{$business_object_model_root}/sys/introduction{$FILE_EXT}">Introduction</a>
            <br/>
            <a href="{$business_object_model_root}/sys/1_scope{$FILE_EXT}">1 Scope</a>
            <br/>
            <a href="{$business_object_model_root}/sys/2_refs{$FILE_EXT}">2 Normative references</a>
            <br/>
            
            <a href="{$business_object_model_root}/sys/3_defs{$FILE_EXT}">
              3 Terms, definitions and abbreviated terms
            </a>
            <br/>
            <small>
              &#160;&#160;<a href="{$business_object_model_root}/sys/3_defs{$FILE_EXT}#termsdefns">3.1 Terms and definitions </a>
            </small>            
            <br/>
            <small>
              &#160;&#160;<a href="{$business_object_model_root}/sys/3_defs{$FILE_EXT}#abbrvterms">3.2 Abbreviated terms</a>
            </small>
            </p>
          </td>
          <td valign="TOP">
            <p class="toc">
              <a href="{$business_object_model_root}/sys/4_info_reqs{$FILE_EXT}">4 Business object model requirements</a>
              <br/>
              <small>
                &#160;&#160;<a href="{$business_object_model_root}/sys/4_info_reqs{$FILE_EXT}#general">4.1 General</a>
              </small>
              <br/>
              <small>
                &#160;&#160;<a href="{$business_object_model_root}/sys/4_info_reqs{$FILE_EXT}#capabilities">4.2 Business object model capabilities</a>
              </small>
              <br/>
              <small>
                &#160;&#160;<a href="{$business_object_model_root}/sys/4_info_reqs{$FILE_EXT}#fundamentals">4.3 Fundamental concepts and assumptions</a>
              </small>
              <br/>
              <small>
                &#160;&#160;<a href="{$business_object_model_root}/sys/4_info_reqs{$FILE_EXT}#constants">4.4 Business object model constant definition</a>
              </small>
              <br/>
              <small>
                &#160;&#160;<a href="{$business_object_model_root}/sys/4_info_reqs{$FILE_EXT}#types">4.5 Business object model type definitions</a>
              </small>
              <br/>
              <small>
                &#160;&#160;<a href="{$business_object_model_root}/sys/4_info_reqs{$FILE_EXT}#entities">4.6 Business object model entity definitions</a>
              </small>
              <br/>
						
              <a href="{$business_object_model_root}/sys/5_main{$FILE_EXT}">5 Business object model mapping</a>
              <br/>
             
            </p>
          </td>
		
          <td valign="TOP">
            <p class="toc">
              <a href="{$business_object_model_root}/sys/annex_obj_reg{$FILE_EXT}">
                A Information object registration
              </a>
              <br/>
              <a href="{$business_object_model_root}/sys/annex_xsd_der{$FILE_EXT}">
                B Derivation of XML schema
              </a>
              <br/>
              <a href="{$business_object_model_root}/sys/annex_bom_expg{$FILE_EXT}">
                C BO model EXPRESS-G
              </a>
              <br/>
              <a href="{$business_object_model_root}/sys/annex_comp_int{$FILE_EXT}">
                D Computer interpretable listings
              </a>
              <br/>
             
              <a href="{$business_object_model_root}/sys/biblio{$FILE_EXT}#biblio">
                Bibliography
              </a>
              <br/>
              <a href="{$business_object_model_root}/sys/index_bomdoc{$FILE_EXT}">
                Index
              </a>
            </p>
          </td>
        </tr>
      </table>
  </xsl:template>


<!--
     Output the Table of contents banner for a module where all clauses are 
     displayed on a single page
-->
<!--<xsl:template match="business_object_model" mode="TOCsinglePage">
  <xsl:param name="business_object_model_root" select="'..'"/>
  <xsl:apply-templates select="." mode="TOCbannertitle">
    <xsl:with-param name="module_root" select="$business_object_model_root"/>
  </xsl:apply-templates>
  <table border="1" cellspacing="1" width="100%">
    <tr>
      <td valign="TOP">
        <a href="{$business_object_model_root}/sys/business_object_model{$FILE_EXT}#cover_page">Cover page</a><br/>
        <a href="{$business_object_model_root}/sys/business_object_model{$FILE_EXT}#foreword">Foreword</a><br/>
        <a href="{$business_object_model_root}/sys/business_object_model{$FILE_EXT}#intro">Introduction</a><br/>
        <a href="{$business_object_model_root}/sys/business_object_model{$FILE_EXT}#scope">1 Scope</a><br/>
        <a href="{$business_object_model_root}/sys/business_object_model{$FILE_EXT}#nref">2 Normative references</a><br/>
        <a href="{$business_object_model_root}/sys/business_object_model{$FILE_EXT}#defns">3 Definitions and abbreviations</a>
      </td>
      <td valign="TOP">
        <a href="{$business_object_model_root}/sys/business_object_model{$FILE_EXT}#arm">4 Information requirements</a><br/>
        <a href="{$business_object_model_root}/sys/business_object_model{$FILE_EXT}#aim">5 Module interpreted model</a><br/>
	 <a href="{$business_object_model_root}/sys/business_object_model{$FILE_EXT}#ccs">6 Conformance classes</a><br/>
        <a href="{$business_object_model_root}/sys/business_object_model{$FILE_EXT}#annexa">A MIM EXPRESS expanded listing</a><br/>
        <a href="{$business_object_model_root}/sys/business_object_model{$FILE_EXT}#annexb">B Implementation method specific requirements</a><br/>
        <a href="{$business_object_model_root}/sys/business_object_model{$FILE_EXT}#annexc">C Protocol Implementation Conformance Statement (PICS) proforma.</a><br/>
        <a href="{$business_object_model_root}/sys/business_object_model{$FILE_EXT}#annexd">D Information object registration</a>
      </td>
      <td valign="TOP">
        <a href="{$business_object_model_root}/sys/business_object_model{$FILE_EXT}#annexe">E Application activity model</a><br/>
		<a href="{$business_object_model_root}/sys/business_object_model{$FILE_EXT}#annexf">F Application reference model</a><br/>
	<a href="{$business_object_model_root}/sys/business_object_model{$FILE_EXT}#annexg">G Computer interpretable listing</a><br/>
	<xsl:if test="./usage_guide">
		<!-\- use #annexh to link direct -\->
		<a href="{$business_object_model_root}/sys/business_object_model{$FILE_EXT}#annexh">
		  H Business Object Model implementation and usage guide
		</a>
		<br/>
	</xsl:if>
	<xsl:if test="./tech_disc">
		<!-\- use #annexj to link direct -\->
		<a href="{$business_object_model_root}/sys/business_object_model{$FILE_EXT}#annexj">
			J Technical discussions
		</a>
		<br/>
	</xsl:if>
	<a href="{$business_object_model_root}/sys/k_ae_index{$FILE_EXT}">
		K Application object index
	</a>
	<br/>
	<!-\- use #biblio to link direct -\->
	<a href="{$business_object_model_root}/sys/business_object_model{$FILE_EXT}">Bibliography</a>
      </td>
    </tr>
  </table>
</xsl:template>

<xsl:template match="business_object_model" mode="test_business_object_model_name">
  <xsl:variable name="test">
    <xsl:call-template name="check_all_lower_case">
      <xsl:with-param name="str" select="@name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$test = -1">
    <xsl:call-template name="error_message">
      <xsl:with-param 
        name="message" 
        select="concat('Error m1: the business object model name ',@name,' is incorrectly
        named in business_object_model.xml &lt;business object model name=&quot;',@name,'&quot;. Should be all lower case')"/>
    </xsl:call-template>    
  </xsl:if>
</xsl:template>

	<xsl:template match="imgfile" mode="page_number">
		<xsl:param name="business_object_model_root" select="'..'"/>
		<xsl:variable name="href">
			<xsl:call-template name="set_file_ext">
				<xsl:with-param name="filename" select="concat($business_object_model_root,'/',@file)"/>
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
	</xsl:template>-->
	
</xsl:stylesheet>
