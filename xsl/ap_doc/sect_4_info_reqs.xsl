<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
	$Id: sect_4_info_reqs.xsl,v 1.4 2003/03/06 14:47:57 goset1 Exp $
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
    <xsl:variable name="module_partno" select="concat('ISO 10303-',$module_xml/module/@part)"/>
    <xsl:variable name="module_href" select="concat('../../../modules/',$module,'/sys/cover',$FILE_EXT)"/>

    <p>
      This clause specifies the information requirements addressed by this part of ISO 10303.
    </p>
    <p>
      The information requirements are defined using the terminology of the subject area of this 
      application protocol.
    </p>
    <!--
    <p class="note">
      <small>
        NOTE&#160;1&#160;&#160;A graphical representation of the information requirements is given in 
        Annex <a href="{$f_expg}">G</a>.
        XXXX NEED TO TEST WHETHER THERE IS ANNEX G
      </small>
    </p> -->
  
    <xsl:variable name="e_aam" select="concat('./e_aam',$FILE_EXT)"/>
    <p class="note">
      <small>
        NOTE&#160;&#160;The information requirements correspond to those of the activities 
        identified as being within the scope of this application protocol,
        in Annex <a href="{$e_aam}">E</a>.
      </small>
    </p>
    <!-- RBN do we need this
         <p class="note">
           <small>
             NOTE&#160;3&#160;&#160;The mapping specification is specified in 
             <a href="{$sect51}#mapping">clause 5.1</a>. 
             It shows how the information requirements are met, using common resources and 
             constructs imported into the AIM schema of this application protocol.
           </small>
         </p> -->
     <xsl:apply-templates select="inforeqt/fundamentals"/>

     <h3><a name="42">4.2&#160;Information requirements model</a></h3>
     <xsl:variable name="module_clause4" select="concat('../../../modules/',$module,'/sys/4_info_reqs',$FILE_EXT)"/>
     The detailed information requirements for this AP are defined in
     Clause <a href="{$module_clause4}">4</a> of the AP module, 
     <a href="{$module_href}"><xsl:value-of select="$module_partno"/></a>.
     <p class="note">
       <small>
         NOTE&#160;1&#160;&#160;
         The Application Object index contains a complete list of all
         application objects identified in the information requirements in
         Clause <a href="{$module_clause4}">4</a> of the AP module 
         (<a href="{$module_href}"><xsl:value-of select="$module_partno"/></a>).
       </small>
     </p>
     <p class="note">
       <small>
         NOTE&#160;2&#160;&#160;
         The module index contains a complete list of all the modules used in
         this part of ISO 10303. 
       </small>
     </p>

     <h3><a name="421">4.2.1&#160;Model overview</a></h3>
     The following sub clauses contain a business overview of the
     requirements contained in the AP module 
     (<a href="{$module_href}"><xsl:value-of select="$module_partno"/></a>)
     as represented in the following list of modules.
     <xsl:apply-templates select="inforeqt/reqtover"/>
   </xsl:template>		
		
	
   <xsl:template match="fundamentals">
     <h3><a name="41">4.1&#160;Business concepts and terminology</a></h3>
     <p>
       This subclause describes the fundamental concepts and assumptions
       related to the data structure defined within this part of ISO 10303. 
     </p>
     <xsl:apply-templates/>
   </xsl:template>
 


   <xsl:template match="reqtover">
    <xsl:variable name="module" select="@module"/>
    <xsl:variable name="module_ok">
      <xsl:call-template name="check_module_exists">
        <xsl:with-param name="module" select="$module"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$module_ok!='true'">
      <xsl:call-template name="error_message">
        <xsl:with-param name="message">
          <xsl:value-of select="concat('Error AP421: The module ',$module,' does not exist.',
                                ' Correct &lt;reqtover module=&gt;in application_protocol.xml')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>

    <xsl:variable name="module_dir">
      <xsl:call-template name="ap_module_directory">
        <xsl:with-param name="application_protocol" select="$module"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="module_xml" select="document(concat($module_dir,'/module.xml'))"/>
    <xsl:variable name="module_partno" select="concat('ISO 10303-',$module_xml/module/@part)"/>

    <xsl:variable name="module_name">
      <xsl:call-template name="module_display_name">
        <xsl:with-param name="module" select="$module"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="clause_aname" select="''"/>
    <xsl:variable name="clause_hdr"
      select="concat('4.2.',position()+1,'&#160;',$module_partno,':&#160;',$module_name)"/>
    <h3>
      <a name="{$clause_aname}">
        <xsl:value-of select="$clause_hdr"/>
      </a>
    </h3>
    This application module shall be used to address the following areas of
    scope.
    <xsl:apply-templates select="description"/>

  </xsl:template>





</xsl:stylesheet>
