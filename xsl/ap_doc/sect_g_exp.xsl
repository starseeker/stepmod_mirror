<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_g_exp.xsl,v 1.7 2003/05/23 15:52:57 robbod Exp $
  Author:  Mike Ward, Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: 
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:import href="../sect_e_exp.xsl"/>
  <xsl:import href="application_protocol.xsl"/>

  <xsl:import href="application_protocol_clause.xsl"/>
  <xsl:output method="html"/>
	
  <xsl:template match="application_protocol">
    <xsl:apply-templates select="." mode="annexg"/>	
  </xsl:template>
  

<!-- Annex G -->
<xsl:template match="application_protocol" mode="annexg">
  <xsl:call-template name="annex_header">
    <xsl:with-param name="annex_no" select="'G'"/>
    <xsl:with-param name="heading" select="'Computer interpretable listings'"/>
    <xsl:with-param name="aname" select="'annexg'"/>
  </xsl:call-template>
  
  <xsl:variable name="ap_mod_dir">
    <xsl:value-of select="concat('../../../modules/',@module_name)"/>
  </xsl:variable>
  <xsl:variable name="arm">
    <xsl:value-of select="concat($ap_mod_dir,'/arm',$FILE_EXT)"/>
  </xsl:variable>
		
  <!--
  <xsl:variable name="arm_lf">
    <xsl:choose>
      <xsl:when test="$FILE_EXT='.xml'">
        <xsl:value-of select="'g_exp_arm_lf.xml'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'g_exp_arm_lf.htm'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable> -->

  <xsl:variable name="mim">
    <xsl:value-of select="concat($ap_mod_dir,'/mim',$FILE_EXT)"/>
  </xsl:variable>
		
<!-- 		<xsl:variable name="aim_lf">
			<xsl:choose>
				<xsl:when test="$FILE_EXT='.xml'">
					<xsl:value-of select="'g_exp_aim_lf.xml'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'g_exp_aim_lf.htm'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable> -->

  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="aim_schema" select="translate(concat(@name,'_mim'),$LOWER, $UPPER)"/>
  <xsl:variable name="ap" select="translate(@name, $UPPER, $LOWER)"/>
  <xsl:variable name="names_url" select="'http://www.tc184-sc4.org/Short_Names/'"/>
  <xsl:variable name="parts_url" select="'http://www.tc184-sc4.org/EXPRESS/'"/>
  <p>
    This annex references a listing of the EXPRESS entity names and
    corresponding short names as specified or referenced in this part of ISO
    10303.  
    This listing can also be found at the following URL:
  </p>
  <blockquote>
    Short names:&lt;
    <a href="{$names_url}">
      <xsl:value-of select="$names_url"/>
    </a>&gt;<br/>
  </blockquote>
  <p>
    This annex also provides a listing of the EXPRESS schemas, ARM and MIM
    short-form, that specify in a modular form, the data structures
    standardized within this part of ISO 10303.  
    These listings are available in computer-interpretable form from Table G.1
    and can be found at the following URLs: 
  </p>
  <blockquote>
    EXPRESS:&lt;
    <a href="{$parts_url}">
      <xsl:value-of select="$parts_url"/>
    </a>&gt;
  </blockquote>
  
  <div align="center">
    <a name="table_g1">
      <b>
<!-- 					<xsl:choose>
						<xsl:when test="./mim_lf or ./arm_lf">
							Table G.1 &#8212; ARM to AIM EXPRESS short and long form listings
						</xsl:when>
						<xsl:otherwise>
							Table G.1 &#8212; ARM and MIM EXPRESS listings
						</xsl:otherwise>
					</xsl:choose>
 -->
							Table G.1 &#8212; ARM and MIM EXPRESS listings
				</b>
			</a>
		</div>
			
		<br/>
		
		<div align="center">
			<table border="1" cellspacing="1">
				<tr>
					<td>
						<b>
							Description
						</b>
					</td>
					<td>
						<b>
							File
						</b>
					</td>
					<td>
						<b>
							File
						</b>
					</td>
					<td>
						<b>
							Identifier
						</b>
					</td>
				</tr>
				<tr>
					<td>EXPRESS ARM short form </td>
					<td>
						<a href="{$arm}">
							<xsl:value-of select="concat('arm',$FILE_EXT)"/>
						</a>
					</td>
					<xsl:call-template name="output_express_links">
						<xsl:with-param name="wgnumber" select="./@wg.number.arm"/>
						<xsl:with-param name="file" select="'arm.exp'"/>
						<xsl:with-param name="file_name" select="'arm.exp'"/>
						<xsl:with-param name="ap_module" select="@module_name"/>
					</xsl:call-template>
				</tr>
				<tr>
					<xsl:apply-templates select="arm_lf" mode="annexg"/>
				</tr>
				<tr>
					<td>EXPRESS MIM short form
					</td>

					<td>
						<a href="{$mim}">
							<xsl:value-of select="concat('mim',$FILE_EXT)"/>
						</a>
					</td>
					<xsl:call-template name="output_express_links">
						<xsl:with-param name="wgnumber" select="./@wg.number.mim"/>
						<xsl:with-param name="file" select="'mim.exp'"/>
						<xsl:with-param name="file_name" select="'mim.exp'"/>
						<xsl:with-param name="ap_module" select="@module_name"/>
					</xsl:call-template>
				</tr>
				<tr>
					<xsl:apply-templates select="." mode="annexg_aim_lf"/>
				</tr>
			</table>
		</div>
		<p>
			If there is difficulty accessing these sites, contact ISO Central Secretariat or contact the ISO TC184/SC4 Secretariat directly at: 
			<a href="mailto:sc4sec@tc184-sc4.org">
				sc4sec@tc184-sc4.org
			</a>.
		</p>
		<p class="note">
			<small>
				NOTE&#160;&#160;The information provided in computer-interpretable form at the above URLs is informative. The information that is contained in the body of this part of ISO 10303 is normative.
			</small>
		</p>
	</xsl:template>

	
</xsl:stylesheet>
