<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
     $Id: application_protocol_toc.xsl,v 1.17 2003/05/22 21:27:11 robbod Exp $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:template match="module" mode="TOCmultiplePage"/>
	
  <xsl:template match="application_protocol" mode="TOCmultiplePage">
    <xsl:param name="selected"/>
    <xsl:param name="application_protocol_root" select="'..'"/>

    <xsl:if test="@name='nut_and_bolt'">
      <h1>NB THIS AP IS FOR DEMONSTRATION PURPOSES ONLY</h1>
    </xsl:if>		

    <xsl:apply-templates select="." mode="TOCbannertitle">
      <xsl:with-param name="module_root" select="$application_protocol_root"/>
    </xsl:apply-templates> 

    <xsl:variable name="arm_schema_name" select="concat(@name,'_arm')"/>
    <xsl:variable name="aim_schema_name" select="concat(@name,'_mim')"/>
    <xsl:variable name="ap_name" select="./@name"/>
    <table border="1" cellspacing="1" width="100%">
      <tr>
        <td valign="TOP">
          <p class="toc">
            <a href="{$application_protocol_root}/sys/cover{$FILE_EXT}">Cover page</a>
            <br/>
            <a href="{$application_protocol_root}/sys/foreword{$FILE_EXT}">Foreword</a>
            <br/>
            <a href="{$application_protocol_root}/sys/contents{$FILE_EXT}">Table of contents</a>
            <br/>
            <a href="{$application_protocol_root}/sys/introduction{$FILE_EXT}">Introduction</a>
            <br/>
            <a href="{$application_protocol_root}/sys/1_scope{$FILE_EXT}">1 Scope</a>
            <br/>
            <a href="{$application_protocol_root}/sys/2_refs{$FILE_EXT}">2 Normative references</a>
            <br/>
            <xsl:choose>
              <xsl:when test="./definition/term">
                <a href="{$application_protocol_root}/sys/3_defs{$FILE_EXT}">
                  3 Terms, definitions and abbreviations
                </a>
              </xsl:when>
              <xsl:otherwise>
                <a href="{$application_protocol_root}/sys/3_defs{$FILE_EXT}">
                  3 Terms and abbreviations</a>
                </xsl:otherwise>
              </xsl:choose>
            </p>
          </td>
          <td valign="TOP">
            <p class="toc">
              <a href="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}">4 Information requirements</a>
              <br/>
              <small>
                &#160;&#160;<a href="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#41">4.1 Business concepts and terminology</a>
              </small>
              <br/>
              <small>
                &#160;&#160;<a href="{$application_protocol_root}/sys/4_info_reqs{$FILE_EXT}#42">4.2 Information requirements model</a>
              </small>
              <br/>
						
              <a href="{$application_protocol_root}/sys/5_main{$FILE_EXT}">5 Application interpreted model</a>
              <br/>
              <a href="{$application_protocol_root}/sys/6_ccs{$FILE_EXT}">6 Conformance requirements</a>
              <br/>
            </p>
          </td>
		
          <td valign="TOP">
					<p class="toc">
						<a href="{$application_protocol_root}/sys/a_exp_aim_lf{$FILE_EXT}">
							A AIM EXPRESS expanded listing
							
						</a>
						<xsl:call-template name="ap_expressg_icon">
							<xsl:with-param name="schema" select="$aim_schema_name"/>
							<xsl:with-param name="module_root" select="$application_protocol_root"/>
							<xsl:with-param name="mod" select="$ap_name"/>
						</xsl:call-template>
						<br/>
						<a href="{$application_protocol_root}/sys/b_imp_meth{$FILE_EXT}">
							B Implementation method specific requirements
						</a>
						<br/>
						<a href="{$application_protocol_root}/sys/c_pics{$FILE_EXT}">
							C Protocol Implementation Conformance Statement (PICS) form
						</a>
						<br/>
						<a href="{$application_protocol_root}/sys/d_obj_reg{$FILE_EXT}">
							D Information object registration
						</a>
						<br/>
						<a href="{$application_protocol_root}/sys/e_aam{$FILE_EXT}">
							E Application activity model
						</a>
						<xsl:call-template name="idef0_icon">
							<xsl:with-param name="schema" select="concat(./@name,'_arm')"/>
							<xsl:with-param name="application_protocol_root" select="$application_protocol_root"/>
						</xsl:call-template>
						<br/>
						<a href="{$application_protocol_root}/sys/f_arm_expg{$FILE_EXT}">
							F Application reference model
						</a>
						<xsl:call-template name="ap_expressg_icon">
							<xsl:with-param name="schema" select="$arm_schema_name"/>
							<xsl:with-param name="module_root" select="$application_protocol_root"/>
							<xsl:with-param name="mod" select="$ap_name"/>
						</xsl:call-template>
						<br/>
						<a href="{$application_protocol_root}/sys/g_exp{$FILE_EXT}">
							G Computer interpretable listing
						</a>
						<br/>
						<xsl:if test="./usage_guide">
							<a href="{$application_protocol_root}/sys/h_guide{$FILE_EXT}">
								H Application protocol implementation and usage guide
							</a>
							<br/>
						</xsl:if>
						<xsl:if test="./tech_disc">
							<a href="{$application_protocol_root}/sys/j_tech_disc{$FILE_EXT}">
								J Technical discussions
							</a>
							<br/>
						</xsl:if>
						<a href="{$application_protocol_root}/sys/k_ae_index{$FILE_EXT}">
							K Application object index
						</a>
						<br/>
						<a href="{$application_protocol_root}/sys/biblio{$FILE_EXT}#biblio">
							Bibliography
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
<xsl:template match="application_protocol" mode="TOCsinglePage">
  <xsl:param name="application_protocol_root" select="'..'"/>
  <xsl:apply-templates select="." mode="TOCbannertitle">
    <xsl:with-param name="module_root" select="$application_protocol_root"/>
  </xsl:apply-templates>
  <table border="1" cellspacing="1" width="100%">
    <tr>
      <td valign="TOP">
        <a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#cover_page">Cover page</a><br/>
        <a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#foreword">Foreword</a><br/>
        <a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#intro">Introduction</a><br/>
        <a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#scope">1 Scope</a><br/>
        <a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#nref">2 Normative references</a><br/>
        <a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#defns">3 Definitions and abbreviations</a>
      </td>
      <td valign="TOP">
        <a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#arm">4 Information requirements</a><br/>
        <a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#aim">5 Application interpreted model</a><br/>
	 <a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#ccs">6 Conformance classes</a><br/>
        <a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#annexa">A AIM EXPRESS expanded listing</a><br/>
        <a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#annexb">B Implementation method specific requirements</a><br/>
        <a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#annexc">C Protocol Implementation Conformance Statement (PICS) form.</a><br/>
        <a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#annexd">D Information object registration</a>
      </td>
      <td valign="TOP">
        <a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#annexe">E Application activity model</a><br/>
		<a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#annexf">F Application reference model</a><br/>
	<a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#annexg">G Computer interpretable listing</a><br/>
	<xsl:if test="./usage_guide">
		<!-- use #annexh to link direct -->
		<a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#annexh">
			H Application protocol implementation and usage guide
		</a>
		<br/>
	</xsl:if>
	<xsl:if test="./tech_disc">
		<!-- use #annexj to link direct -->
		<a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}#annexj">
			J Technical discussions
		</a>
		<br/>
	</xsl:if>
	<a href="{$application_protocol_root}/sys/k_ae_index{$FILE_EXT}">
		K Application object index
	</a>
	<br/>
	<!-- use #biblio to link direct -->
	<a href="{$application_protocol_root}/sys/application_protocol{$FILE_EXT}">Bibliography</a>
      </td>
    </tr>
  </table>
</xsl:template>

<xsl:template match="application_protocol" mode="test_application_protocol_name">
  <xsl:variable name="test">
    <xsl:call-template name="check_all_lower_case">
      <xsl:with-param name="str" select="@name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$test = -1">
    <xsl:call-template name="error_message">
      <xsl:with-param 
        name="message" 
        select="concat('Error m1: the application protocol name ',@name,' is incorrectly
                named in application_protocol.xml &lt;application protocol name=&quot;',@name,'&quot;. Should be all lower case')"/>
    </xsl:call-template>    
  </xsl:if>
</xsl:template>

	<xsl:template match="imgfile" mode="page_number">
		<xsl:param name="application_protocol_root" select="'..'"/>
		<xsl:variable name="href">
			<xsl:call-template name="set_file_ext">
				<xsl:with-param name="filename" select="concat($application_protocol_root,'/',@file)"/>
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
	</xsl:template>
	
</xsl:stylesheet>
