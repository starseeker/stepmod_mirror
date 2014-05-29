<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_c_exp_schema.xsl,v 1.6 2005/05/16 20:44:07 thendrix Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: Display the ARM short form express 
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="resource.xsl"/>
  <xsl:import href="express_code.xsl"/>


  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
  <xsl:import href="resource_clause.xsl"/>


  <xsl:output method="html"/>

  <!-- +++++++++++++++++++
         Global variables
       +++++++++++++++++++ -->

  <!-- 
       Global variable used in express_link.xsl by:
         link_object
         link_list
       Provides a lookup table of all the references for the entities and
       types indexed through all the interface specifications in the
       express.
       Note:  This variable must defined in each XSL that is used for
       formatting express. (TEH guessing here at the list)
         sect_4_schema.xsl
         sect_e_exp.xsl
         sect_e_exp_1.xsl
       build_xref_list is defined in express_link
       -->
  <xsl:variable name="global_xref_list">
    <!-- debug 
    <xsl:message>
      global_xref_list defined in sect_4_express.xsl
    </xsl:message> -->
    <xsl:choose>
      <xsl:when test="/resource_clause">
        <xsl:variable name="resdoc_dir">
          <xsl:call-template name="resdoc_directory">
            <xsl:with-param name="resdoc" select="/resource_clause/@directory"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="resdoc_name">
          <xsl:value-of select="/resource_clause/@directory" />
        </xsl:variable>
        <!--
        <xsl:message>
          resdoc_dir  :<xsl:value-of select="$resdoc_dir"/>: resdoc_dir
        </xsl:message>
-->
        <xsl:variable name="resdoc_xml" select="concat($resdoc_dir,'/','resource.xml')"/>
        <!-- <xsl:message>
          resdoc_xml  :<xsl:value-of select="$resdoc_xml"/>
        count schemas: <xsl:value-of select="count(document($resdoc_xml)/resource/schema)"/> : sdfasd
        </xsl:message> -->

        <xsl:variable name="resdoc_node" select="document($resdoc_xml)"/>
                
        <!-- <xsl:for-each select="document($resdoc_xml)/resource/schema"> -->
        <xsl:for-each select="$resdoc_node/resource/schema">
          <xsl:variable name="resource_dir">
            <xsl:call-template name="resource_directory">
              <xsl:with-param name="resource" select="./@name"/>            
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="express_xml" select="concat($resource_dir,'/',@name,'.xml')"/>
          <xsl:call-template name="build_xref_list">
            <xsl:with-param name="express" select="document($express_xml)/express"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="/resource">
        <xsl:variable name="resdoc_dir">
          <xsl:call-template name="resdoc_directory">
            <xsl:with-param name="resource" select="/resource/@name"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="resdoc_name">
          <xsl:value-of select="/resource_clause/@directory" />
        </xsl:variable>
        <!--
        <xsl:message>
          resdoc_dir  :<xsl:value-of select="$resdoc_dir"/>: resdoc_dir
        </xsl:message>
        -->
        <xsl:variable name="resdoc_xml" select="concat($resdoc_dir,'/','resource.xml')"/>
        <!--
        <xsl:message>
          resdoc_xml  :<xsl:value-of select="$resdoc_xml"/>
        count schemas: <xsl:value-of select="count(document($resdoc_xml)/resource/schema)"/> 
        </xsl:message>
-->
        <xsl:variable name="resdoc_node" select="document($resdoc_xml)"/>
                
        <!-- <xsl:for-each select="document($resdoc_xml)/resource/schema"> -->
        <xsl:for-each select="$resdoc_node/resource/schema">
          <xsl:variable name="resource_dir">
            <xsl:call-template name="resource_directory">
              <xsl:with-param name="resource" select="./@name"/>
            
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="express_xml" select="concat($resource_dir,'/',$resource_dir,'.xml')"/>
          <xsl:call-template name="build_xref_list">
            <xsl:with-param name="express" select="document($express_xml)/express"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>


  <!-- A global variable used by the express_file_to_ref template defined
       in express_link.xsl.
       It defines the relative path from the file applying the stylesheet
       to the root of the stepmod repository.
       sect_e_exp_arm.xsl stylesheet is normally used
         stepmod/data/module/?module?/sys/e_exp_arm.xml
       Hence the relative root is: ../../../
       -->

  <xsl:variable 
    name="relative_root"
    select="'../../../../'"/>

  <!-- +++++++++++++++++++
         Templates
       +++++++++++++++++++ -->

<!-- overwrites the template declared in resource.xsl -->
<xsl:template match="resource">
  <xsl:param name="pos" />
  <!-- debug <xsl:value-of select="$global_xref_list"/> -->
  <xsl:call-template name="clause_header">
    <xsl:with-param name="heading" select="''"/>
    <xsl:with-param name="aname" select="'annexc-express'"/>
  </xsl:call-template>
  
  <xsl:variable name="stdnumber">
    <xsl:call-template name="get_resdoc_iso_number">
      <xsl:with-param name="resdoc" select="./@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="resource_name">
    <xsl:call-template name="res_display_name">
      <xsl:with-param name="res" select="./@name"/>
    </xsl:call-template>
  </xsl:variable>


    <xsl:message>
      <xsl:value-of select="'&#010;___________________________________________________________'"/>
      <xsl:value-of select="concat('&#010;Processing: data/resource_docs/',./@name,'/sys/c_exp_schema_',$pos+3,'.xml','&#010;')"/>
    </xsl:message>



  <code>
  (*<br/>
    <xsl:value-of 
      select="concat('ISO/TC 184/SC 4/WG 12 N',@wg.number.express, ' - ',
              $stdnumber,' ', $resource_name, ' - EXPRESS')"/>
    <xsl:if test="string-length(normalize-space(@wg.number.express.supersedes))>0">
      <br/>Supersedes 
      <xsl:value-of 
	      select="concat('ISO/TC 184/SC 4/WG 12','&#160;N',@wg.number.express.supersedes)"/>
    </xsl:if>
    <br/>*)
  </code>

  <br/>

  <!-- output all the EXPRESS specifications -->
  <xsl:variable name="schema_name" select="./schema[number($pos)]/@name"/>

    <!--  <xsl:variable name="schema_name" select="./schema[2]/@name" /> -->

    <!--    <xsl:message>
    schema_name :<xsl:value-of select="$schema_name" />: schema_name
  </xsl:message>
  <xsl:message>
    pos :<xsl:value-of select="$pos" />: pos
  </xsl:message>
-->
<xsl:variable name="resource_dir">
    <xsl:call-template name="resource_directory">
      <xsl:with-param name="resource" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable 
    name="express_xml"
    select="concat($resource_dir,'/',$schema_name,'.xml')"/>
  <!-- get the express and display using the express_code.xsl stylesheet that
       has been imported.
       -->
  <!--
  <xsl:message>
    express_xml :<xsl:value-of select="$express_xml" />: express_xml
  </xsl:message>
-->
  <xsl:apply-templates select="document($express_xml)/express/schema" mode="code"/>

    <xsl:message>
      <xsl:value-of select="'&#010;___________________________________________________________'"/>
      <xsl:value-of select="concat('&#010;EndProcessing: data/resource_docs/',./@name,'/sys/c_exp_schema_',$pos+3,'.xml','&#010;')"/>
    </xsl:message>

</xsl:template>

</xsl:stylesheet>
