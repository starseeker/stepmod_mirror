<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
     $Id: sect_introduction.xsl,v 1.11 2003/06/02 09:26:53 robbod Exp $
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

    <xsl:variable name="module">
      <xsl:call-template name="module_name">
        <xsl:with-param name="module" select="/application_protocol/@module_name"/>
      </xsl:call-template>
    </xsl:variable>

   <xsl:variable name="module_dir">
     <xsl:call-template name="ap_module_directory">
       <xsl:with-param name="application_protocol" select="$module"/>
     </xsl:call-template>
   </xsl:variable>
   <xsl:variable name="module_xml" select="document(concat($module_dir,'/module.xml'))"/>

   <xsl:variable name="module_href" select="concat('../../../modules/',$module,'/sys/')"/>

    
    <h2>
      <a name="introduction">Introduction</a>
    </h2>
    <p>
      ISO 10303 is an International Standard for the computer-interpretable 
      representation of product information and for the exchange of product data.
      The objective is to provide a neutral mechanism capable of describing
      products throughout their life cycle. This mechanism is suitable not only
      for neutral file exchange, but also as a basis for implementing and
      sharing product databases, and as a basis for archiving.
    </p>
                
    <xsl:if test="string-length(normalize-space(/application_protocol/@purpose))=0">
      <xsl:call-template name="error_message">
        <xsl:with-param name="message"
          select="'Error APdoc 41: application_protocol.xml/application_protocol/@purpose not specified'"/>
      </xsl:call-template>
    </xsl:if>

    <p>
      This part of ISO 10303 specifies an application protocol (AP) for
      <xsl:value-of select="normalize-space(/application_protocol/@purpose)"/>.
    </p>

    <xsl:if test="not( string-length(normalize-space(.)) > 85)" >
        <xsl:call-template name="error_message">
	  <xsl:with-param name="inline" select="'yes'"/>
	  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
          <xsl:with-param name="message" 
		            select="'Error P1: Insufficient introduction material provided.'"/>
        </xsl:call-template>    
  </xsl:if>
	
  <xsl:apply-templates select="/application_protocol/changes/change_summary" mode="introduction"/>

  <xsl:if test="./data_plan">
    <p>
      <a name="data_plan"/>
      The data planning model in
      <xsl:apply-templates select="./data_plan/imgfile" mode="data_plan_figures"/>
      provides an overview of the information requirements of this domain.  
    </p>
  </xsl:if>

  <!-- display content of purpose element-->
  <xsl:apply-templates/>
		
  <p>
    Clause 
    <a href="1_scope{$FILE_EXT}">1</a> 
    defines the scope of the application protocol and summarizes the functionality and data covered. 
  </p>
  <p>
    Clause 
    <a href="3_defs{$FILE_EXT}">3</a> 
    lists the words defined in this part of ISO 10303 and refers to words defined elsewhere. 
  </p>
  <p>
    The information requirements of the application are specified in clause 
    <a href="{$module_href}4_info_reqs{$FILE_EXT}">4</a> 
    using terminology appropriate to the application. 
    <xsl:if test="$module_xml/module/arm_lf/express-g">
      A graphical
      representation of the information requirements, referred  
      to as the application reference model, is given in annex 
      <a href="annex_arm_expg{$FILE_EXT}">G</a>.
    </xsl:if>
  </p> 
  <p>
    Resource constructs are interpreted to meet the information
    requirements. This interpretation produces the application  
    interpreted model (AIM). This interpretation, given in 
    <a href="{$module_href}5_mapping{$FILE_EXT}">5.1</a>,
    shows the correspondence between the information requirements and the AIM. 
    The short listing of the AIM specifies 
    the interface to the resources and is given in 
    <a href="{$module_href}5_mim{$FILE_EXT}">5.2</a>.
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

  <xsl:template match="imgfile" mode="data_plan_figures">
    <xsl:if test="position()=1">
      <xsl:choose>
        <xsl:when test="count(../imgfile)>1">
          Figures
        </xsl:when>
        <xsl:otherwise>
          Figure
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:variable name="file_href">
      <xsl:call-template name="set_file_ext">
        <xsl:with-param name="filename" select="concat('../',@file)"/>
      </xsl:call-template>
    </xsl:variable>
    <a href="{$file_href}">
      <xsl:value-of select="position()"/>
    </a>
    <xsl:if test="position()!=last()">,&#160;</xsl:if>
  </xsl:template>


  <xsl:template match="change_summary" mode="introduction">
    <a name="changes"/>
    <xsl:apply-templates select="."/> 

   <xsl:variable name="annex_list">
     <xsl:apply-templates select="/application_protocol" mode="annex_list"/>
   </xsl:variable>

    <xsl:variable name="al_changes">
      <xsl:call-template name="annex_letter">
        <xsl:with-param name="annex_name" select="'changedetail'"/>
        <xsl:with-param name="annex_list" select="$annex_list"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="note">
      <xsl:choose>
        <xsl:when test="//purpose//note">
          NOTE&#160;1&#160;&#160;Detailed description of the changes is provided in Annex
        </xsl:when>
        <xsl:otherwise>
          NOTE&#160;&#160;Detailed description of the changes is provided in Annex
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <p class="note">
      <small>
        <xsl:value-of select="$note"/>
        <a href="./annex_changes{$FILE_EXT}">
          <xsl:value-of select="$al_changes"/>
        </a>
      </small>
    </p>

  </xsl:template>

</xsl:stylesheet>