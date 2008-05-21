<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_4_info_reqs.xsl,v 1.24 2008/04/23 20:52:04 darla Exp $
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
