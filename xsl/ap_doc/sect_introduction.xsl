<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
     $Id: sect_introduction.xsl,v 1.3 2002/10/08 10:13:15 mikeward Exp $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="application_protocol.xsl"/>
	<xsl:import href="application_protocol_clause.xsl"/>
	<xsl:output method="html"/>
	
	 	<xsl:template match="module"/>
		
	<xsl:template match="application_protocol">
  <xsl:apply-templates select="purpose"/>
	</xsl:template>
	
	<xsl:template match="purpose">
		<h3>
			<a name="introduction">Introduction</a>
		</h3>
		<p>
		    ISO 10303 is an International Standard for the computer-interpretable 
		    representation of product information and for the exchange of product data.
		    The objective is to provide a neutral mechanism capable of describing
		    products throughout their life cycle. This mechanism is suitable not only
		    for neutral file exchange, but also as a basis for implementing and
		    sharing product databases, and as a basis for archiving.
		</p>

 <xsl:if test="not( string-length(normalize-space(.)) > 85)" >
        <xsl:call-template name="error_message">
	  <xsl:with-param name="inline" select="'yes'"/>
	  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
          <xsl:with-param name="message" 
		            select="'Error P1: Insufficient introduction material provided.'"/>
        </xsl:call-template>    
  </xsl:if>
  <xsl:if test="not(substring-after(.,'This part of ISO 10303 specifies'))" >
        <xsl:call-template name="error_message">
	  <xsl:with-param name="inline" select="'yes'"/>
	  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
          <xsl:with-param 
		            name="message" 
		            select="'Error P2: Introduction does not start with required text: This part of ISO 10303 specifies .'"/>
        </xsl:call-template>    
  </xsl:if>	
	
		<!-- display content of purpose element-->
  <xsl:apply-templates/>
		
		<p>
			Clause 
			<a href="1_scope{$FILE_EXT}">1</a> 
			defines the scope of the application protocol and summarizes the functionality and data covered. 
			</p>
			<p>Clause <a href="3_defs{$FILE_EXT}">3</a> 
			lists the words defined in this part of ISO 10303 and refers to words defined elsewhere. 
</p>
<p>			The information 
			requirements of the application are specified in clause 
			<a href="4_info_reqs{$FILE_EXT}">4</a> 
			using terminology appropriate to the application. A graphical representation of the information requirements, referred 
			to as the application reference model, is given in annex 
			<a href="f_arm_expg{$FILE_EXT}">F</a>.</p> 
<p>Resource constructs are interpreted to meet the information requirements. This interpretation produces the application 
			interpreted model (AIM). This interpretation, given in 
			<a href="5_mapping{$FILE_EXT}">5.1</a>
			, shows the correspondence between the information requirements and the AIM. 
			The short listing of the AIM specifies 
			the interface to the resources and is given in 
			<a href="5_aim{$FILE_EXT}">5.2</a>.
			</p>
			<p>
				In this International Standard, the same English language words may be
				    used to refer to an object in the real world or concept, and as the
				    name of an EXPRESS data type that represents this object or concept.
			</p>
			<p>
				The following typographical convention is used to distinguish between
				    these. If a word or phrase occurs in the same typeface as narrative
				    text, the referent is the object or concept. If the word or phrase
				    occurs in a bold typeface or as a hyperlink, the referent is the
				    EXPRESS data type.
			</p>
			<p>
				The name of an EXPRESS data type may be used to refer to the data type
				    itself, or to an instance of the data type. The distinction between
				    these uses is normally clear from the context. If there is a likelihood
				    of ambiguity, either the phrase "entity data type" or "instance(s) of" is
				    included in the text.
			</p>
			<p>
				Double quotation marks " " denote quoted text. Single quotation marks ' ' denote particular text string values.
			</p>
		</xsl:template>

</xsl:stylesheet>