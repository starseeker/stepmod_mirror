<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_f_aam.xsl,v 1.1 2003/05/23 15:50:29 robbod Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose:     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="application_protocol.xsl"/>
	<xsl:import href="application_protocol_clause.xsl"/>
	<xsl:import href="aam_descriptions.xsl"/>
	 <xsl:output method="html"/>
	
	<xsl:template match="module"/>
	
	<xsl:template match="application_protocol">
		<xsl:call-template name="annex_header">
    			<xsl:with-param name="annex_no" select="'F'"/>
    			<xsl:with-param name="heading" select="'Application activity model'"/>
    			<xsl:with-param name="aname" select="'annexf'"/>
		</xsl:call-template>
 		The application activity model (AAM) is provided as an aid to understanding the scope and information requirements defined in this part of ISO 10303.  The model is presented as a set of figures that contain the activity diagrams and a set of definitions of the activities and their data. Activities and data flows that are out of scope are marked with an asterisk.
		<xsl:variable name="ap_dir">
			<xsl:value-of select="@name"/>
		</xsl:variable>
		
		<xsl:variable name="aam_path">
			<xsl:value-of select="concat('../../data/application_protocols/', $ap_dir, '/aam.xml')"/>
		</xsl:variable>
		
		<xsl:apply-templates select="document(string($aam_path))/idef0"/>
		<h2>F.2 Application activity model diagrams</h2>
		<xsl:apply-templates select="aam"/>
	</xsl:template>
	<xsl:template match="aam">
		<xsl:apply-templates select="idef0" mode="fig_no"/>	
	</xsl:template>
	<xsl:template match="idef0" mode="fig_no">
		<xsl:variable name="ap_dir">
			<xsl:value-of select="../../@name"/>
		</xsl:variable>
		<xsl:variable name="aam_path">
			<xsl:value-of select="concat('../../data/application_protocols/', $ap_dir, '/aam.xml')"/>
		</xsl:variable>
		<xsl:variable name="no_of_diagrams" select="count(imgfile)"/>
		The AAM is presented in Figures E.1 to E.<xsl:value-of select="$no_of_diagrams"/>. Activities and data flows which are out of scope are marked with asterisks.
		<xsl:for-each select="imgfile">
			<xsl:variable name="aam_filename" select="./@file"/>
			<xsl:variable name="aam_href" select="concat('../', $aam_filename)"/>
			<xsl:variable name="fig_no" select="position()"/>
			<xsl:variable name="node" select="document(string($aam_path))/idef0/page[position() = $fig_no]/@node"/>
			<xsl:variable name="fig_title" select="document(string($aam_path))/idef0/page[position() = $fig_no]/@title"/>
			<p>
				<a href="{$aam_href}">
					Figure E.<xsl:value-of select="$fig_no"/> - <xsl:value-of select="$node"/> <xsl:value-of select="concat(' ', $fig_title)"/>
				</a>
			</p>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
