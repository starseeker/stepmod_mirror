<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
	$Id: sect_4_info_reqs.xsl,v 1.3 2002/10/08 10:19:07 mikeward Exp $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="../sect_4_info_reqs.xsl"/>
	<xsl:import href="application_protocol.xsl"/>
	<xsl:import href="application_protocol_clause.xsl"/>
	<xsl:output method="html"/>
	
	<xsl:template match="application_protocol">
		<xsl:call-template name="clause_header">
			<xsl:with-param name="heading" select="'4 Information requirements'"/>
			<xsl:with-param name="aname" select="'arm'"/>
		</xsl:call-template>
		<xsl:variable name="f_expg" select="concat('./f_arm_expg',$FILE_EXT)"/>
		<xsl:variable name="sect51" select="concat('./5_mim',$FILE_EXT)"/>

		<p>
			This clause specifies the information requirements addressed by this part of ISO 10303.
		</p>
		<p>
			The information requirements are defined using the terminology of the subject area of this 
			application protocol.
		</p>
		
		<p class="note">
			<small>
				NOTE&#160;1&#160;&#160;A graphical representation of the information requirements is given in 
				<a href="{$f_expg}">annex F</a>.
			</small>
		</p>
		
		<xsl:variable name="e_aam" select="concat('./e_aam',$FILE_EXT)"/>
		<p class="note">
			<small>
				NOTE&#160;2&#160;&#160;The information requirements correspond to those of the activities 
				identified as being within the scope of this application protocol, in <a href="{$e_aam}">annex E</a>.
			</small>
		</p>
		
		<p class="note">
			<small>
				NOTE&#160;3&#160;&#160;The mapping specification is specified in 
				<a href="{$sect51}#mapping">clause 5.1</a>. 
				It shows how the information requirements are met, using common resources and 
				constructs imported into the AIM schema of this application protocol.
			</small>
		</p>

		<xsl:apply-templates select="fundamentals"/>
		<xsl:apply-templates select="arm"/>
	</xsl:template>		
		
	<xsl:template match="module">
	</xsl:template>
	
	<xsl:template match="fundamentals">
		<h3><a name="#41">4.1&#160;Fundamental concepts and assumptions</a></h3>
		<p>This subclause describes the fundamental concepts and assumptions related to the data structure defined within this part of ISO 10303.
</p>
		<xsl:apply-templates/>
	</xsl:template>
</xsl:stylesheet>
