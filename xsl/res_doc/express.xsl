<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: express.xsl,v 1.3 2003/03/16 01:26:38 thendrix Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: Display the  express for an Integrated Resource schema
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">


  <!--  <xsl:import href="express_code.xsl"/> -->
  <xsl:import href="../express_code.xsl"/>

  <xsl:output 
    method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    indent="yes"
    />

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
       formatting express.
         sect_4_info.xsl
         sect_5_mim.xsl
         sect_e_exp_arm.xsl
         sect_e_exp_mim.xsl
       build_xref_list is defined in express_link
       -->
  <xsl:variable name="global_xref_list">
    <!-- debug  
    <xsl:message>
      global_xref_list defined in resource_exp.xsl
    </xsl:message> -->
    <xsl:call-template name="build_xref_list">
      <xsl:with-param name="express" select="/express"/>
    </xsl:call-template>
  </xsl:variable>

  
  <!-- A global variable used by the express_file_to_ref template defined
       in express_link.xsl.
       It defines the relative path from the file applying the stylesheet
       to the root of the stepmod repository.
       Express.xsl stylesheet is normally used
         stepmod/data/module/?module?/arm.xml
         stepmod/data/module/?module?/mim.xml
         stepmod/data/module/?module?/mim_lf.xml
         stepmod/data/module/?resource_schema?/?resource_schema?.xml
       Hence the relative root is: ../../../
       -->

  <xsl:variable 
    name="relative_root"
    select="'../../../'"/>

  <!-- this stuff would work if it were in the modules express schema, which seems to be what resdocs use

  <xsl:variable name="schema_name_tmp" select="//schema/@name" />

  <xsl:variable name="repo_index_xml" select="document('../repository_index.xml')" />


    <xsl:variable name="resdoc_number">
      <xsl:choose>
        <xsl:when
          test="$repo_index_xml/repository_index/resources/resource[@name=$schema_name_tmp]">
        <xsl:value-of select="$repo_index_xml/repository_index/resources/resource[@name=$schema_name_tmp]/@part"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of 
            select="concat('ERROR : ', $schema_name_tmp, 
                    ' not found in repository_index as a resource')"/>
      </xsl:otherwise>
    </xsl:choose>        
  </xsl:variable>

    <xsl:variable name="resdoc_part" >
    <xsl:value-of select="substring-after($resdoc_number,'-')"/>
  </xsl:variable>
  
  <xsl:variable name="resdoc_name" >
    <xsl:choose>
      <xsl:when
        test="$repo_index_xml/repository_index/resource_docs/resource_doc[@part=$resdoc_part]">
        <xsl:value-of select="$repo_index_xml/repository_index/resource_docs/resource_doc[@part=$resdoc_part]/@name"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of 
          select="concat('ERROR : ', $resdoc_part, 
                  ' not found in repository index as  a resource doc')"/>
      </xsl:otherwise>
    </xsl:choose>        
  </xsl:variable>
    

<xsl:variable name="resdoc_dir">
    <xsl:call-template name="resdoc_directory">
      <xsl:with-param name="resdoc" select="$resdoc_name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="resdoc">
    <xsl:value-of select="imgfile.content/@module"/>
  </xsl:variable>

 
 
  <xsl:variable name="resdoc_file" select="concat($resdoc_dir,'/resource.xml')"/>


  <xsl:variable name="resdoc_xml" select="document($resdoc_file)"/>    

-->
  <!--  not sure about this <xsl:variable name="resdoc_root" select="concat('../',$resdoc_dir)"/> -->


  <!-- +++++++++++++++++++
         Templates
       +++++++++++++++++++ -->

<!-- overwrites the template declared in module.xsl -->
<xsl:template match="/">
  <HTML>
    <HEAD>
      <!-- stuff commented out above is to add meta tags but I dont think it is needed
since the schema htm files that are actually *in* the standard are in sys dir 
Anyway as mentioned above they need to be in the other express.xsl 
           If try to run from here, the path from xsl to stepmod needs to be ../../
-->
      <xsl:apply-templates select="./application" mode="meta"/>
        <!-- apply a cascading stylesheet.
             the stylesheet will only be applied if the parameter output_css
             is set in parameter.xsl 
             -->
      <xsl:call-template name="output_css">
        <xsl:with-param name="path" select="'../../../css/'"/>
      </xsl:call-template>
      <TITLE>Integrated Resource: <xsl:value-of select="./express/schema/@name"/></TITLE>
    </HEAD>
    <BODY>
  <!-- debug <xsl:value-of select=""/> -->
  <xsl:if test="contains(string(./express/schema/@name),'nut_and_bolt_')">
  
    <h1>NB THIS RESOURCE SCHEMA IS FOR DEMONSTRATION PURPOSES ONLY</h1><h3>Do not copy this xml file to create a new resource schema</h3>

</xsl:if>


    <h2>
      <xsl:value-of select="concat('Schema: ',./express/schema/@name)"/>
    </h2>
  		<xsl:if test="./express/@reference">
	    <p><i>Source : <xsl:value-of select="./express/@reference"/></i></p>
			</xsl:if>

    <xsl:apply-templates select="./express/schema" mode="code"/>
    </BODY>
  </HTML>
</xsl:template>

<xsl:template match="express" >

  <HTML>
    <HEAD>
      <xsl:apply-templates select="./application" mode="meta"/>
        <!-- apply a cascading stylesheet.
             the stylesheet will only be applied if the parameter output_css
             is set in parameter.xsl 
             -->
      <xsl:call-template name="output_css">
        <xsl:with-param name="path" select="'../../../css/'"/>
      </xsl:call-template>
      <TITLE></TITLE>
    </HEAD>
    <BODY>  
    <xsl:apply-templates select="./schema" mode="code"/>
    </BODY>
  </HTML>
</xsl:template>
  
</xsl:stylesheet>
