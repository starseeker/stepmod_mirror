<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_4_info_reqs.xsl,v 1.4 2012/11/06 09:39:48 mikeward Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep Limited.
  Purpose: Display clause 4 for a BOM     
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="business_object_model.xsl"/>
  <xsl:import href="business_object_model_clause.xsl"/>
  
  <xsl:output method="html"/>
  
  <xsl:variable name="annex_c" select="concat('./annex_bom_expg',$FILE_EXT)"/>
  
  <xsl:template match="business_object_model">
    <xsl:variable name="model" select="./@name"/>
    <xsl:variable name="purpose" select="normalize-space(./@purpose)"/>
    <xsl:variable name="ap_doc" select="./@ap_name"/>
    <xsl:variable name="ap_number" select="substring-after(substring-before($ap_doc, '_'), 'ap')"/>
    <xsl:variable name="model_title" select="./@title"/>
    <xsl:variable name="model_ok">
      <xsl:call-template name="check_model_exists">
        <xsl:with-param name="model" select="$model"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$model_ok!='true'">
      <xsl:call-template name="error_message">
        <xsl:with-param name="message">
          <xsl:value-of select="concat('Error BOM1: The business object model ',$model_title,' does not exist.',
                                ' Correct business object model ', $model, ' in business_object_model.xml')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    
    <xsl:variable name="model_dir" select="./@name"/>
    <xsl:variable name="model_no" select="/business_object_model/@part"/>
    <xsl:variable name="model_xml" select="document(concat('../../data/business_object_models/', $model_dir, '/business_object_model.xml'))"/>
    
    <xsl:variable name="model_partno">
     <xsl:choose>
       <xsl:when test="$model_xml/business_object_model/@status='TS'">
         <xsl:value-of select="concat('ISO/TS 10303-', $model_no)"/>
       </xsl:when>
       <xsl:otherwise>
         <xsl:value-of select="concat('ISO 10303-', $model_no)"/>
       </xsl:otherwise>
     </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="model_href" select="concat('../../../business_object_models/',$model_dir,'/sys/cover',$FILE_EXT)"/>

    <xsl:if test="string-length(normalize-space(@purpose))=0">
      <xsl:call-template name="error_message">
        <xsl:with-param name="message"
          select="'Error BOMdoc 41: business_object_model.xml/business_object_model/@purpose not specified'"/>
      </xsl:call-template>
    </xsl:if>


    <xsl:apply-templates select="inforeqt">
      <xsl:with-param name="model_param" select="$model"/>
      <xsl:with-param name="purpose_param" select="$purpose"/>
      <xsl:with-param name="ap_number_param" select="$ap_number"/>
    </xsl:apply-templates>

    <!--<xsl:variable name="model_clause4" select="concat('../../../business_object_models/',$model,'/sys/4_info_reqs',$FILE_EXT)"/>
     The detailed information requirements for this BO model are defined in
     Clause <a href="{$module_clause4}">4</a> of   
     the BO model  
     (<a href="{$model_href}"><xsl:value-of select="$model_partno"/>)</a>.-->
     <!--<p class="note">
       <small>
         NOTE&#160;1&#160;&#160;
         The BO model EXPRESS 
         <a href="index_arm_express{$FILE_EXT}" target="index">index</a>
         contains a complete list of all BO model objects identified in the information requirements in
          Clause <a href="{$module_clause4}">4</a> of   
         the BO model  
         (<a href="{$model_href}"><xsl:value-of select="$model_partno"/></a>).
       </small>
     </p>-->
  
  </xsl:template>
  
  <xsl:template match="inforeqt">
    <xsl:param name="model_param"/>
    <xsl:param name="purpose_param"/>
    <xsl:param name="ap_number_param"/>
    
    <xsl:call-template name="clause_header">
      <xsl:with-param name="heading" select="'4 Business object model information requirements'"/>
      <xsl:with-param name="aname" select="'bom'"/>
    </xsl:call-template>
    <h2><a name="general">4.1&#160;General</a></h2>
    
    <p>
      This clause specifies the information required for <xsl:value-of select="$purpose_param"/>.
    </p>
    <p>
      This clause specifies the information requirements for the business object model of ISO 10303-<xsl:value-of select="$ap_number_param"/>.
      The information requirements are specified as a set of capabilities, and application objects.
    </p>
    <p class="note">
      <small>
        NOTE&#160;&#160;A graphical representation of the information requirements is given in Annex <a href="{$annex_c}">C</a>.
      </small>
    </p>
    <p class="note">
      <small>
        NOTE&#160;&#160;The mapping specification is specified in 5.1. It shows how the business objects are mapped to the Application Reference Model (ARM) of ISO 10303-<xsl:value-of select="$ap_number_param"/>.
      </small>
    </p>
    <p>
      This clause defines the information requirements to which business object model implementations shall conform using the EXPRESS language as defined in ISO 10303-11. <!--The following begins the AP<xsl:value-of select="$ap_number_param"/> business object model schema.
      EXPRESS specification:-->
    </p>
    <!--<p>
      <u>EXPRESS specification:</u><br/>
      (*<br/>
      SCHEMA <xsl:value-of select="concat($model_param, '_bom')"/>;<br/>
      *)
    </p>-->
    
    
    <xsl:apply-templates select="capabilities"/>
    <xsl:apply-templates select="fundamentals"/>
    <xsl:apply-templates select="bom"/>
  </xsl:template>
  
  
  
  <xsl:template match="capabilities">
    <h2><a name="capabilities">4.2&#160;Business object model capabilities</a></h2>
    
    <p>
      This subclause specifies the capabilities for the business object model. The capabilities and their definitions are specified below.
    </p>
    <xsl:apply-templates select="description"/>
    <xsl:apply-templates select="capability"/>
  </xsl:template>
		
	<xsl:template match="capability">
	   
	  <h3><a name="41x">4.1.<xsl:value-of select="position()"/>&#160;<xsl:value-of select="./@title"/></a></h3>
	  <xsl:apply-templates select="description"/>
	</xsl:template>
	
   <xsl:template match="fundamentals">
     <h2><a name="fundamentals">4.3&#160;Fundamental concepts and assumptions</a></h2>

    
     <p>
       This subclause describes the business context for the information
       required for 
       <xsl:value-of select="normalize-space(/business_object_model/@purpose)"/>.
     </p>

     <xsl:choose>
       <xsl:when test="./data_plan">
         <p>
           <a name="data_plan"/>
           The data planning model in
           <xsl:apply-templates select="./data_plan/imgfile" mode="data_plan_figures"/>
           provides an overview of the information requirements of this domain.  
         </p>
       </xsl:when>
       <xsl:when test="/business_object_model/purpose/data_plan">
         <p> 
           The data planning model in
           <xsl:apply-templates select="/business_object_model/purpose/data_plan/imgfile" mode="data_plan_figures"/>
           provides an overview of the information requirements of this domain.  
         </p>
       </xsl:when>
     </xsl:choose>

     <xsl:if test="/business_object_model/terminology_map">
       <p> 
       <a name="terminology"/>
      <!-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx<br/>
       XSLe1: XSL INCOMPLETE - XSL for terminology map not implented
         The application module that provides the detailed information
         requirements for this BOM may be shared across multiple domains and the
         terminology used therein may differ from that of the business users of this
         BOM.  This subclause provides the correlation between the different terms in
         Table .  (if terminology mapping 
         provided)
       xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx<br/>-->
       </p>
     </xsl:if>

     <xsl:apply-templates/>
   </xsl:template>
 
  <!--<xsl:template match="types">
    <h2><a name="43">4.3&#160;Business object model type definitions</a></h2>
  </xsl:template>
  
  <xsl:template match="entities">
    <h2><a name="44">4.4&#160;Business object model entity definitions</a></h2>
  </xsl:template>
  -->

  <!-- <xsl:template match="reqtover">
     <xsl:variable name="model" select="@module"/>
     <xsl:variable name="module_ok">
       <xsl:call-template name="check_model_exists">
         <xsl:with-param name="model" select="$model"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="module_name">
      <xsl:call-template name="module_display_name">
        <xsl:with-param name="module" select="$module"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$module_ok!='true'">
        <xsl:call-template name="error_message">
          <xsl:with-param name="message">
            <xsl:value-of select="concat('Error AP421: The module ',$module,' does not exist.',
                                  ' Correct &lt;reqtover module=&gt;in business_object_model.xml')"/>
          </xsl:with-param>
        </xsl:call-template>        
        <h2>
          <xsl:variable name="clause_hdr"
            select="concat('4.2.',position()+1,'&#160;XXXXX:&#160;',$module_name)"/>
        </h2>
      </xsl:when>
      
      <xsl:otherwise>
        <xsl:variable name="module_dir">
          <!-\-<xsl:call-template name="ap_module_directory">
            <xsl:with-param name="business_object_model" select="$module"/>
          </xsl:call-template>-\->
        </xsl:variable>

        <xsl:variable name="module1">
          <xsl:call-template name="module_name">
            <xsl:with-param name="module" select="$module"/>
          </xsl:call-template>
        </xsl:variable>

        
        <xsl:variable name="href" select="concat('../../../modules/',$module1,'/sys/introduction',$FILE_EXT)"/>
        <xsl:variable name="module_xml" select="document(concat($module_dir,'/module.xml'))"/>
	    <xsl:variable name="module_partno">
	     <xsl:choose>
	       <xsl:when test="$module_xml/module/@status='TS'">
	         <xsl:value-of select="concat('ISO/',$module_xml/module/@status,' 10303-',$module_xml/module/@part)"/>
	       </xsl:when>
	       <xsl:otherwise>
	         <xsl:value-of select="concat('ISO 10303-',$module_xml/module/@part)"/>
	       </xsl:otherwise>
	     </xsl:choose>
	    </xsl:variable>
                
        <xsl:variable name="clause_aname" select="concat('42',$module_name)"/>
        <xsl:variable name="clause_hdr"
          select="concat('4.2.',position()+1,'&#160;',$module_partno,':&#160;')"/>

        <h2>
          <a name="{$clause_aname}">
            <xsl:value-of select="$clause_hdr"/>
          </a>
          <a href="{$href}">
            <xsl:value-of select="$module_name"/>
          </a>
        </h2>
        This application module shall be used to address the following areas of
        scope.
        <xsl:apply-templates select="description"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>-->


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
    <xsl:variable name="figure_count">
      <xsl:call-template name="count_figures_from_fundamentals"/>
    </xsl:variable>
    <a href="{$file_href}">
      <xsl:value-of select="position()+$figure_count"/> 
    </a>
    <xsl:choose>
      <xsl:when test="position()=last()-1 and count(../imgfile)>1">
        and
      </xsl:when>
      <xsl:when test="position()=last()"/>
      <xsl:otherwise>
        <xsl:text/>,&#160;
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

 
  <!-- overwrites the template declared in business_object_model.xsl -->
 <!-- <xsl:template match="business_object_model">
    <xsl:apply-templates select="bom"/>
  </xsl:template>-->

</xsl:stylesheet>
