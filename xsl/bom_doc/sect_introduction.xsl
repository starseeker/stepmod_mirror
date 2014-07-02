<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
  $Id: sect_introduction.xsl,v 1.3 2013/02/19 17:52:07 ungerer Exp $
  Author:  Mike Ward, Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: Display the introduction for a BOM document.     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="business_object_model.xsl"/>
  <xsl:import href="business_object_model_clause_nofooter.xsl"/>
  <xsl:output method="html"/>

  <xsl:template match="business_object_model">
    <xsl:variable name="purpose" select="./@purpose"/>
    <xsl:variable name="model_dir" select="./@name"/>
    <xsl:variable name="model_no" select="./@part"/>
    <xsl:variable name="model_title" select="./@title"/>
    <h2>
      <a name="introduction">Introduction</a>
    </h2>
    <p>
      ISO 10303 is an International Standard for the computer-interpretable representation of
      product information and for the exchange of product data. The objective is to provide a
      neutral mechanism capable of describing products throughout their life cycle. This mechanism
      is suitable not only for neutral file exchange, but also as a basis for implementing and
      sharing product databases, and as a basis for retention and archiving.
    </p>
    <xsl:if test="string-length($purpose)=0">
      <xsl:call-template name="error_message">
        <xsl:with-param name="message" select="'Error BOMdoc 41: business_object_model.xml/business_object_model/@purpose not specified'"/>
      </xsl:call-template>
    </xsl:if>
    <!-- display content of purpose element-->
    <p>
      <xsl:value-of select="./purpose"/>
    </p>
    <p>
      Clause <a href="1_scope{$FILE_EXT}">1</a> defines the scope of the business object model and
      summarizes the functionality and data covered. Clause <a href="3_defs{$FILE_EXT}">3</a> lists
      the terms defined in this part of ISO 10303 and provides pointers to words to terms defined
      elsewhere. The BO Model of the application is specified in Clause 
      <a href="4_info_reqs{$FILE_EXT}">4</a> using terminology appropriate to the application. A
      graphical representation of the information requirements, referred to as the BO model, is
      given in Annex <a href="annex_bom_expg{$FILE_EXT}">C</a>. A mapping of the BO model to the to xml schema
      is given in Annex <a href="annex_xsd_der{$FILE_EXT}">B</a>.
    </p>
    <p>
      In ISO 10303, the same English language words can be used to refer to an object in the real
      world or concept, and as the name of an EXPRESS data type that represents this object or
      concept.
    </p>
    <p>
      The following typographical convention is used to distinguish between these. If a word or
      phrase occurs in the same typeface as narrative text, the referent is the object or concept.
      If the word or phrase occurs in a bold typeface or as a hyperlink, the referent is the EXPRESS
      data type.
    </p>
    <p>
      The name of an EXPRESS data type can be used to refer to the data type itself, or to an
      instance of the data type. The distinction between these uses is normally clear from the
      context. If there is a likelihood of ambiguity, either the phrase "entity data type" or
      "instance(s) of" is included in the text.
    </p>
    <p>
      Double quotation marks " " denote quoted text. Single quotation marks ' ' denote particular
      text string values.
    </p>
    <xsl:if test="not( string-length(normalize-space(.)) > 85)">
      <xsl:call-template name="error_message">
        <xsl:with-param name="inline" select="'yes'"/>
        <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
        <xsl:with-param name="message" select="'Error P1: Insufficient introduction material provided.'"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
