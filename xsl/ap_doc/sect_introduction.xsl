<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
     $Id: sect_introduction.xsl,v 1.29 2010/10/20 07:44:26 robbod Exp $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="application_protocol.xsl"/>
  <xsl:import href="application_protocol_clause.xsl"/>
  <xsl:import href="common.xsl"/>
  <xsl:output method="html"/>

  <xsl:template match="module"/>
		
  <xsl:template match="application_protocol">
    <xsl:apply-templates select="purpose"/>
  </xsl:template>
	
  <xsl:template match="purpose">
   <xsl:variable name="annex_list">
     <xsl:apply-templates select=".." mode="annex_list"/>
   </xsl:variable>
	
    <xsl:variable name="purpose" select="normalize-space(/application_protocol/@purpose)"/>
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
   <xsl:variable name="module_xml" 
     select="document(concat($module_dir,'/module.xml'))"/>

   <xsl:variable name="module_href"
     select="concat('../../../modules/',$module,'/sys/')"/>

   <xsl:variable name="module_cover" 
     select="concat($module_href, 'cover', $FILE_EXT)"/>
   
   <xsl:variable name="module_no">
     <xsl:call-template name="get_module_iso_number">
       <xsl:with-param name="module" select="$module"/>
     </xsl:call-template>
   </xsl:variable>

    
   <h2>
     <a name="introduction">Introduction</a>
   </h2>
   <p>
     ISO 10303 is an International Standard for the computer-interpretable 
     representation of product information and for the exchange of product data.
     The objective is to provide a neutral mechanism capable of describing
     products throughout their life cycle. This mechanism is suitable not only
      for neutral file exchange, but also as a basis for implementing and
      sharing product databases, and as a basis for retention and archiving.
   </p>
   
   <xsl:if test="string-length($purpose)=0">
     <xsl:call-template name="error_message">
        <xsl:with-param name="message"
          select="'Error APdoc 41: application_protocol.xml/application_protocol/@purpose not specified'"/>
      </xsl:call-template>
    </xsl:if>
    
    <p>
      This part of ISO 10303 is a member of the application protocol series.
      This part of ISO 10303 specifies an application protocol (AP) for 
      <xsl:value-of select="$purpose"/>.
    </p>
    
    <p>
      This part of ISO 10303 defines the context and scope for 
      <xsl:value-of select="$purpose"/>,
      and references the AP module 
      (<a href="{$module_cover}"><xsl:value-of select="$module_no"/></a>)
      that specifies the information  requirements for 
      <xsl:value-of select="$purpose"/>
      and the integrated resources necessary to
      satisfy those requirements.
    </p>

    <p>
      Application protocols provide the basis for developing implementations
      of ISO 10303 and abstract test suites for the conformance testing of AP
      implementations.
    </p>

    <p>
      Clause 
      <a href="1_scope{$FILE_EXT}">1</a> 
      defines the scope of the application protocol and summarizes the functionality and data covered. 
    </p>
    
    <p>
      An application activity model that is the basis for the definition of
      the scope is provided in Annex 
      <a href="annex_aam{$FILE_EXT}">F</a>.
    </p>

    <p>
      Clause 
      <a href="3_defs{$FILE_EXT}">3</a> 
      lists the terms defined in this part of ISO 10303 and refers to terms
      defined elsewhere.  
    </p>
    
    
    <p>
      This part of ISO 10303 describes the high level business concepts and
    terminology of the application and specifies the implementation conformance
    options. 
    Clause <a href="4_info_reqs{$FILE_EXT}#41">4.1</a>
    presents the business context for the information
    requirements.
    It also contains a data planning model, which provides an
    overview of the information requirements of this domain in domain terminology.
     Clause <a href="4_info_reqs{$FILE_EXT}#42">4.2</a> includes a reference to the AP module 
    (<a href="{$module_cover}"><xsl:value-of select="$module_no"/></a>), which
    specifies the details of the information requirements of the application.
    

    
    <!--   See: http://locke.dcnicn.com/bugzilla/iso10303/show_bug.cgi?id=3201
   <p>
      This document specifies the high level business concepts and
      terminology of the application protocol and the details of the implementation
      conformance options. 
      The detailed information requirements of the application protocol are
      specified in the AP module
       (<a href="{$module_cover}"><xsl:value-of select="$module_no"/></a>)
      that is referenced in Clause <a href="4_info_reqs{$FILE_EXT}#arm">4</a>. 
      Specifically clause <a href="4_info_reqs{$FILE_EXT}#41">4.1</a>
      presents the business context for the
      information required for the exchange of 
    <xsl:value-of select="$purpose"/> data.
      <xsl:choose>
        <xsl:when test="./data_plan and //inforeqt/fundamentals/data_plan">
          <xsl:apply-templates select="./data_plan/imgfile"
            mode="data_plan_figures"/>
          <xsl:choose>
            <xsl:when test="count(./data_plan/imgfile)=1">
              provides
            </xsl:when>
            <xsl:otherwise>
              provide
            </xsl:otherwise>
          </xsl:choose>
          a data planning model that provides an overview
          of the information requirements of this domain in domain
          terminology. A more detailed data planning model is provided in
          <a href="4_info_reqs{$FILE_EXT}#41">4.1</a>.
        </xsl:when>
        <xsl:when test="./data_plan">
          <!-\- output Figure 1 -\->
          <xsl:apply-templates select="./data_plan/imgfile"
            mode="data_plan_figures"/>
          <xsl:choose>
            <xsl:when test="count(./data_plan/imgfile)=1">
              provides
            </xsl:when>
            <xsl:otherwise>
              provide
            </xsl:otherwise>
          </xsl:choose>
          a data planning model that provides an overview
          of the information requirements of this domain in domain
          terminology. 
        </xsl:when>
        <xsl:when test="//inforeqt/fundamentals/data_plan">
          Clause <a href="4_info_reqs{$FILE_EXT}#41">4.1</a>
          provides a data planning model that provides an overview
          of the information requirements of this domain in domain
          terminology. 
        </xsl:when>
      </xsl:choose>
    -->  
      
      <xsl:if test="/application_protocol/terminology_map">
        A table correlating the terminology used in the AP module
        (<a href="{$module_cover}"><xsl:value-of select="$module_no"/></a>)
        to the terminology of the domain is provided in 
        <a href="4_info_reqs{$FILE_EXT}#terminology">4.1</a>.
      </xsl:if>

      <xsl:if test="$module_xml/module/arm_lf/express-g">
        A graphical
        representation of the information requirements, referred  
        to as the application reference model, is given in Annex 
        <a href="annex_arm_expg{$FILE_EXT}">
          <xsl:call-template name="annex_letter" >
            <xsl:with-param name="annex_name" select="'ARMexpressG'"/>
            <xsl:with-param name="annex_list" select="$annex_list"/>
          </xsl:call-template>
        </a>.
      </xsl:if>
    </p> 

    <p>
      Resource constructs are interpreted to meet the information
      requirements.  The interpretation is specified in the AP module 
      (<a href="{$module_cover}"><xsl:value-of select="$module_no"/></a>)
      that is referenced in Clause 
      <a href="5_main{$FILE_EXT}">5</a>.
      This interpretation shows the correspondence between the 
      information requirements and the module interpreted model (MIM).  
      The short listing of
      the MIM that specifies the interface to the integrated resources  is
      included by reference from the AP module.   The expanded listing of the
      MIM that is referenced in Annex 
      <a href="annex_exp_lf{$FILE_EXT}">A</a>
      contains the complete EXPRESS for the MIM without annotation.  
      
      <xsl:if test="$module_xml/module/mim_lf/express-g">
        A graphical presentation of the MIM is provided in Annex
        <a href="annex_mim_expg{$FILE_EXT}">
          <xsl:call-template name="annex_letter" >
            <xsl:with-param name="annex_name" select="'MIMexpressG'"/>
            <xsl:with-param name="annex_list" select="$annex_list"/>
          </xsl:call-template>
        </a>.
      </xsl:if>

    </p>
    <p>
      Clause 
      <a href="6_ccs{$FILE_EXT}">6</a>
      specifies subsets of the AP against which conformance can be
      claimed.
    </p>
    <p>
      Additional requirements for specific implementation methods are given in
      Annex 
      <a href="annex_imp_meth{$FILE_EXT}">C</a>.
    </p>

    <xsl:if test="not( string-length(normalize-space(.)) > 85)" >
      <xsl:call-template name="error_message">
        <xsl:with-param name="inline" select="'yes'"/>
        <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
        <xsl:with-param name="message" 
		            select="'Error P1: Insufficient introduction material provided.'"/>
      </xsl:call-template>    
    </xsl:if>
    
    <!-- display content of purpose element-->
    <xsl:apply-templates/>

    <!-- display the change summary -->
    <xsl:apply-templates select="/application_protocol/changes/change_summary" mode="introduction"/>
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
<!--     <xsl:variable name="this_edition">
      <xsl:apply-templates select="/application_protocol" mode="this_edition"/>
    </xsl:variable>
    
    <xsl:variable name="prev_edition">
      <xsl:apply-templates select="/application_protocol" mode="previous_edition"/>
    </xsl:variable>

    <xsl:variable name="part_no">
      <xsl:call-template name="get_protocol_iso_number">
        <xsl:with-param name="application_protocol" select="/application_protocol"/>
      </xsl:call-template>
    </xsl:variable>
    <p>
      This <xsl:value-of select="$this_edition"/> edition of <xsl:value-of select="$part_no"/> 
      contains the following significant changes from the <xsl:value-of select="$prev_edition"/> 
      edition:
    </p> -->
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
<!-- ISO states that introduction is not informative so should not have notes. -->
    <xsl:variable name="note">
      <xsl:choose>
        <xsl:when test="//purpose//note">
	  <xsl:call-template name="error_message">
	    <xsl:with-param name="message"
          select="'Warning APdoc Intro_note: purpose is informative, so no need for notes'"/>
      </xsl:call-template>
          NOTE&#160;1&#160;&#160;A detailed description of the changes is provided in Annex
        </xsl:when>
        <xsl:otherwise>
          <!--          NOTE&#160;&#160;A detailed description of the changes is provided in Annex-->
A detailed description of the changes is provided in Annex
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
<!--    <p class="note">
      <small>
        <xsl:value-of select="$note"/>
        <a href="./annex_changes{$FILE_EXT}">
          <xsl:value-of select="$al_changes"/>
        </a>
      </small>
    </p>
-->
    <p>
        <xsl:value-of select="$note"/>
        <a href="./annex_changes{$FILE_EXT}">
          <xsl:value-of select="$al_changes"/>
        </a>.
    </p>
  </xsl:template>

</xsl:stylesheet>