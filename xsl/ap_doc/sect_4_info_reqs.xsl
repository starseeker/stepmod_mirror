<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_4_info_reqs.xsl,v 1.27 2013/01/17 09:38:29 ungerer Exp $
  Author:  Rob Bodington, Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: Display the main set of frames for an AP document.     
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!-- <xsl:import href="../sect_4_info_reqs.xsl"/> -->
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

    <xsl:variable name="BOM_number" >
	    <!-- 
	    value set to the number of document if a BOM exists and BOM xml file can be read, 0 if exists but file cannot be read, -1 if does not exist
	    -->
	    <xsl:choose>
		    <xsl:when test="/application_protocol/@business_object_model">
		      <xsl:variable name="BOM_file" 
				    select="concat('../../data/business_object_models/',@business_object_model,'/business_object_model.xml')" />
			    <xsl:variable name="BOM_part" select="document($BOM_file)/business_object_model/@part" /> 
		      <xsl:choose>
				    <xsl:when test="$BOM_part"><xsl:value-of select="$BOM_part" /></xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			     </xsl:choose>
		     </xsl:when>
		     <xsl:otherwise>-1</xsl:otherwise>
	    </xsl:choose>
    </xsl:variable>
  

    <xsl:variable name="module" select="/application_protocol/@module_name"/>
    <xsl:variable name="module_ok">
      <xsl:call-template name="check_module_exists">
        <xsl:with-param name="module" select="$module"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$module_ok!='true'">
      <xsl:call-template name="error_message">
        <xsl:with-param name="message">
          <xsl:value-of select="concat('Error AP1: The module ',$module,' does not exist.',
                                '  Correct application_protocol module_name in application_protocol.xml')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <xsl:variable name="module_dir">
      <xsl:call-template name="ap_module_directory">
        <xsl:with-param name="application_protocol" select="$module"/>
      </xsl:call-template>
    </xsl:variable>

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
    <xsl:variable name="module_href" select="concat('../../../modules/',$module,'/sys/cover',$FILE_EXT)"/>

    <xsl:if test="string-length(normalize-space(@purpose))=0">
      <xsl:call-template name="error_message">
        <xsl:with-param name="message"
          select="'Error APdoc 41: application_protocol.xml/application_protocol/@purpose not specified'"/>
      </xsl:call-template>
    </xsl:if>

    <p>
      This clause specifies the information required for 
      <xsl:value-of select="normalize-space(@purpose)"/>.
    </p>
    <p>
      The information requirements are defined using the terminology of the
      subject area of this application protocol. 
    </p>

    <xsl:variable name="annex_aam" select="concat('./annex_aam',$FILE_EXT)"/>
    <p class="note">
      <small>
        NOTE&#160;&#160;The information requirements correspond to those of the activities 
        identified as being within the scope of this application protocol
        in Annex <a href="{$annex_aam}">F</a>.
      </small>
    </p>

    <!--
    <p class="note">
      <small>
        NOTE&#160;2&#160;&#160;A graphical representation of the information requirements is given in 
        Annex <a href="{$f_expg}">G</a>.
        XXXX NEED TO TEST WHETHER THERE IS ANNEX G
      </small>
    </p> -->
  
    <xsl:apply-templates select="inforeqt/fundamentals"/>

     <h2><a name="42">4.2&#160;Information requirements model</a></h2>
     <xsl:variable name="module_clause4" select="concat('../../../modules/',$module,'/sys/4_info_reqs',$FILE_EXT)"/>
     The detailed information requirements for this AP are defined in
<!--     Clause <a href="{$module_clause4}">4</a> of  --> 
     the AP module 
     (<a href="{$module_href}"><xsl:value-of select="$module_partno"/>)</a>.
     <p class="note">
       <small>
         NOTE&#160;1&#160;&#160;
         The ARM EXPRESS 
         <a href="index_arm_express{$FILE_EXT}" target="index">index</a>
         contains a complete list of all
         ARM objects identified in the information requirements in
<!--         Clause <a href="{$module_clause4}">4</a> of  --> 
         the AP module 
         (<a href="{$module_href}"><xsl:value-of select="$module_partno"/></a>).
       </small>
     </p>
     <p class="note">
       <small>
         NOTE&#160;2&#160;&#160;
         The module 
         <a href="index_arm_modules{$FILE_EXT}" target="index">index</a>
         contains a complete list of all the modules used in the ARM of
         this part of ISO 10303. 
       </small>
     </p>

     <h2><a name="421">4.2.1&#160;Model overview</a></h2>
     The following subclauses contain a business overview of the
     requirements contained in the AP module 
     (<a href="{$module_href}"><xsl:value-of select="$module_partno"/></a>)
     as represented in the following list of modules.
     <xsl:apply-templates select="inforeqt/reqtover"/>
     <xsl:choose>
        <xsl:when test="$BOM_number>0" >
		<xsl:variable name="BOM_ref1" select="concat('../../../business_object_models/',@business_object_model, '/sys/4_info_reqs', $FILE_EXT,'#capabilities')"/>
		<xsl:variable name="BOM_ref2" select="concat('../../../business_object_models/',@business_object_model, '/sys/annex_comp_int', $FILE_EXT)"/>
		<xsl:variable name="BOM_ref3" select="concat('../../../business_object_models/',@business_object_model, '/sys/4_info_reqs', $FILE_EXT)"/>
        <h2><a name="43">4.3&#160;Business object model</a></h2>
		<p>The Business Object Model (in the following just Business Object Model or BO 
			Model) is an information model which is on a high level of granularity and thus is suited for the 
			communication with and understandability by domains experts. 
			It consists of Business Objects (BO) representing major concepts and information requirements of 
			<xsl:value-of select="@title"/> and uses the vocabulary of the STEP modules where this vocabulary 
			reflects the terminology of the domain experts. For example, in the Business Object Model you find the 
			BO Activity with explicit attributes actualStartDate, actualEndDate, or ConcernedOrganizations. A domain expert directly understands that he can define a start and an end for an activity, or specify the organizations involved in the activity. 
			The STEP modules provide this capability, too. However, it is not obvious when looking on the application object Activity in module ISO 10303-1047. This object does not have explicit attributes for dates and organizations. The functionality described above has to be realized by generic assignments of dates with role names "actual start" and "actual end", or by generic assignments of organizations with role name "concerned organization".</p>
<p>			The relationship between
the Business Object model and the ARM of this part of ISO 10303 is
explained in the Business Object Model  <a href="{$BOM_ref1}" target="info">ISO/TS 10303-<xsl:value-of select="$BOM_number"/></a>.
</p>
<p>The Business Object Model is complemented by a Business Object XML Schema for SOA applications. 
This XML schema is derived from the Business Object Model EXPRESS by an XML configuration specification 
according to ISO 10303-28 that drives the generation of the Business Object XML Schema. There is 
exactly one configuration specification defined in business object model  
          (<a href="{$BOM_ref2}" target="info">ISO/TS 10303-<xsl:value-of select="$BOM_number"/></a>) to avoid different variations of the 
Business Object XML Schema. </p>

<p>A technical discussion of the business object model is contained in
Annex H of this part of ISO 10303.
</p>
        <p>The business objects for this application protocol are defined in the business object model  
          (<a href="{$BOM_ref3}" target="info">ISO/TS 10303-<xsl:value-of select="$BOM_number"/></a>).
        </p>
       </xsl:when>
       <xsl:when test="$BOM_number = 0" >
	    <xsl:call-template name="error_message">
        	  <xsl:with-param name="message">
			  <xsl:value-of select="concat('Error AP43: The business object model ',/application_protocol/@business_object_model,
				  ' does not exist. Correct or delete business_object_model attribute in application_protocol.xml')"/>
          </xsl:with-param>
        </xsl:call-template>        
       </xsl:when>
     </xsl:choose>
   </xsl:template>		
		
	
   <xsl:template match="fundamentals">
     <h2><a name="41">4.1&#160;Business concepts and terminology</a></h2>

    <xsl:if test="string-length(normalize-space(/application_protocol/@purpose))=0">
      <xsl:call-template name="error_message">
        <xsl:with-param name="message"
          select="'Error APdoc 41: application_protocol.xml/application_protocol/@purpose not specified'"/>
      </xsl:call-template>
    </xsl:if>

     <p>
       This subclause describes the business context for the information
       required for 
       <xsl:value-of select="normalize-space(/application_protocol/@purpose)"/>.
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
       <xsl:when test="/application_protocol/purpose/data_plan">
         <p> 
           The data planning model in
           <xsl:apply-templates select="/application_protocol/purpose/data_plan/imgfile" mode="data_plan_figures"/>
           provides an overview of the information requirements of this domain.  
         </p>
       </xsl:when>
     </xsl:choose>

     <xsl:if test="/application_protocol/terminology_map">
       <p> 
       <a name="terminology"/>
       xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx<br/>
       XSLe1: XSL INCOMPLETE - XSL for terminology map not implented
         The application module that provides the detailed information
         requirements for this AP may be shared across multiple domains and the
         terminology used therein may differ from that of the business users of this
         AP.  This subclause provides the correlation between the different terms in
         Table .  (if terminology mapping 
         provided)
       xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx<br/>
       </p>
     </xsl:if>

     <xsl:apply-templates/>
   </xsl:template>
 


   <xsl:template match="reqtover">
     <xsl:variable name="module" select="@module"/>
     <xsl:variable name="module_ok">
       <xsl:call-template name="check_module_exists">
         <xsl:with-param name="module" select="$module"/>
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
                                  ' Correct &lt;reqtover module=&gt;in application_protocol.xml')"/>
          </xsl:with-param>
        </xsl:call-template>        
        <h2>
          <xsl:variable name="clause_hdr"
            select="concat('4.2.',position()+1,'&#160;XXXXX:&#160;',$module_name)"/>
        </h2>
      </xsl:when>
      
      <xsl:otherwise>
        <xsl:variable name="module_dir">
          <xsl:call-template name="ap_module_directory">
            <xsl:with-param name="application_protocol" select="$module"/>
          </xsl:call-template>
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


</xsl:stylesheet>
