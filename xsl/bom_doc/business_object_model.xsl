<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: business_object_model.xsl,v 1.6 2014/06/13 12:57:13 nigelshaw Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep Limited.
  Purpose: Display the main set of frames for a BOM document.     
-->

<!-- BOM -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!-- <xsl:import href="../module.xsl"/> -->
  <xsl:import href="business_object_model_toc.xsl"/>
  <xsl:import href="../express_code.xsl"/>
  <xsl:import href="common.xsl"/>
  <xsl:import href="sect_4_express.xsl"/>
  <!--<xsl:import href="../projmg/bomdoc_issues.xsl"/>
-->
  <xsl:variable name="global_xref_list">
    
    <xsl:choose>
      <xsl:when test="/business_object_model_clause">
        <xsl:variable name="business_object_model_dir">
          <xsl:call-template name="business_object_model_directory">
            <xsl:with-param name="business_object_model" select="/business_object_model_clause/@directory"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="express_xml" select="concat($business_object_model_dir,'/bom.xml')"/>
        <xsl:call-template name="build_xref_list">
          <xsl:with-param name="express" select="document($express_xml)/express"/>
        </xsl:call-template>
        <!--<xsl:call-template name="build_xref_list">
          <xsl:with-param name="express" select="document($express_xml)/express"/>
        </xsl:call-template>
      </xsl:when>-->
      <!--<xsl:when test="/module">
        <xsl:variable name="module_dir">
          <xsl:call-template name="module_directory">
            <xsl:with-param name="module" select="/module/@name"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="express_xml" select="concat($module_dir,'/arm.xml')"/>
        <xsl:call-template name="build_xref_list">
          <xsl:with-param name="express" select="document($express_xml)/express"/>
        </xsl:call-template> -->       
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <!-- A global variable used by the express_file_to_ref template defined
       in express_link.xsl.
       It defines the relative path from the file applying the stylesheet
       to the root of the stepmod repository.
       sect_4_express.xsl stylesheet is normally applied from file in:
         stepmod/data/module/?module?/sys/
       Hence the relative root is: ../../../
       -->
  <xsl:variable 
    name="relative_root"
    select="'../../../../'"/>


  
  <xsl:output method="html" doctype-system="http://www.w3.org/TR/html4/loose.dtd" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" indent="yes"/>

  <xsl:template match="/">
    <HTML>
      <HEAD>
        <TITLE>
          <xsl:apply-templates select="./business_object_model" mode="title"/>
        </TITLE>
      </HEAD>
      <BODY>
        <xsl:apply-templates select="./business_object_model" mode="TOCsinglePage"/>
        <xsl:apply-templates select="./business_object_model"/>
      </BODY>
    </HTML>
  </xsl:template>
  
  <xsl:template match="business_object_model" mode="title">
    
    <xsl:variable name="wg_group" select="./@wg"/>
    <xsl:variable name="wg_number" select="./@wg.number"/>
    <xsl:variable name="stdnumber" select="concat('ISO/TC 184/SC 4/WG ',$wg_group,'&#160;N',./@wg.number)"/>
    <xsl:value-of select="$stdnumber"/>                
  </xsl:template>
 

  <!-- returns a list of annexes with content as a string with each annex name as a single word(no spaces)
       separated by spaces -->
  <xsl:template match="business_object_model" mode="annex_list" >
    <xsl:variable name="business_object_model_dir" select="./@name"/>
     
    <xsl:variable name="annex_list">
	    <!--
      <xsl:if
        test="document(concat($business_object_model_dir,'/business_object_model.xml'))/business_object_model/arm_lf/express-g">
        <xsl:value-of select="' BOMexpressG '"/>
</xsl:if>
-->
        <xsl:value-of select="' BOMexpressG '"/>
      <xsl:value-of select="' computerinterpretablelisting '"/>
      <!--
      <xsl:if test="./usage_guide">
        <xsl:value-of select="' usageguide '"/>
      </xsl:if>
      <xsl:if test="./tech_disc">
        <xsl:value-of select="' techdisc '"/>
      </xsl:if>
      <xsl:if test="./changes/change_detail">
        <xsl:value-of select="' changedetail '"/>
      </xsl:if>-->
    </xsl:variable>
    <xsl:value-of select="concat(' ',normalize-space($annex_list),' ')"/>
  </xsl:template>


<xsl:template name="annex_letter" >
  <xsl:param name="annex_name"/>
  <xsl:param name="annex_list"/>
  <!-- returns integer count of position of named annex in list of annexes -->
  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>

  <xsl:variable name="annex" select="concat(translate($annex_name,' ',''),' ')"/>

  <xsl:variable name="pos"
    select="string-length(translate(substring-before($annex_list,$annex),concat($UPPER,$LOWER),''))"/>

  <xsl:value-of select="substring('CDEF',$pos,1)"/> 
</xsl:template>

  <xsl:template match="business_object_model" mode="abstract">
    <xsl:variable name="bom_name" select="./@name"/>
    <xsl:variable name="std_number">
      <xsl:call-template name="get_model_stdnumber">
        <xsl:with-param name="model" select="."/>
      </xsl:call-template>
    </xsl:variable>
     <xsl:choose>
      <xsl:when test="./abstract">
        <xsl:choose>
          <xsl:when  test="./abstract/li">
            <xsl:choose>
              <xsl:when  test="count(./abstract/li)=1">
                <P>
                  The following is within the scope of 
                  <xsl:value-of select="$std_number"/>
                </P>
              </xsl:when>
              <xsl:otherwise>
                <P>
                  The following are within the scope of 
                  <xsl:value-of select="$std_number"/>
                </P>
              </xsl:otherwise>
            </xsl:choose>
            <ul>
              <xsl:apply-templates select="./abstract/*"/>
            </ul>          
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="./abstract/*"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <p>
          <xsl:value-of select="$std_number"/>       
          specifies the business object model for
          <xsl:value-of select="$bom_name"/>. 
        </p>        
        <xsl:apply-templates select="./inscope">          
          <xsl:with-param name="abstract" select="'yes'"/>
        </xsl:apply-templates> 
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="inscope">
    <xsl:param name="abstract" select="'no'"/>
    <p>
      <xsl:choose>
        <xsl:when test="$abstract='yes'">
          The following are within the scope of 
          <xsl:call-template name="get_model_stdnumber">
            <xsl:with-param name="model" select="../."/>
          </xsl:call-template>:
        </xsl:when>
        <xsl:otherwise>
          <a name="inscope"/> 
          The following are within the scope of this part of ISO 10303:                     
        </xsl:otherwise>
      </xsl:choose>
    </p>
    <xsl:variable name="business_object_model_name" select="../../business_object_model/@name"/>
    <xsl:variable name="ap_name" select="../../business_object_model/@ap_name"/>
   
    <xsl:variable name="business_object_model_ok">
      <xsl:call-template name="check_business_object_model_exists">
        <xsl:with-param name="model" select="$business_object_model_name"/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:if test="./@from_module!='NO'">
      <!-- output the scope statements from the module -->
      <xsl:choose>
        <xsl:when test="$business_object_model_ok='true'">
            <ul>
              <!--<xsl:apply-templates select="document(concat('../../data/business_object_models/', $bom_name,'/business_object_model.xml'))/business_object_model/inscope/li"/>-->
            </ul>
        </xsl:when>
        <xsl:otherwise>
         <xsl:value-of select="$business_object_model_ok"/>
          <xsl:call-template name="error_message">
            <xsl:with-param name="message">
              <xsl:value-of select="concat('Error BOM1: The business_object_model ',$business_object_model_name,' does not exist.', ' Correct business_object_model module_name in business_object_model.xml')"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
        
    <!-- output the scope statements from the BOM doc -->
    <xsl:if test="./li">
      <ul>
        <xsl:apply-templates select="li"/>
      </ul>
    </xsl:if>
    
  </xsl:template>
		
  <xsl:template match="outscope">
    <p>
      <a name="outscope"/>
      The following are outside the scope of this part of ISO 10303: 
    </p>
    <xsl:variable name="business_object_model_name" select="../../business_object_model/@name"/>
    <xsl:variable name="ap_name" select="../../business_object_model/@ap_name"/>
    <xsl:variable name="business_object_model_ok">
      <xsl:call-template name="check_business_object_model_exists">
        <xsl:with-param name="model" select="$business_object_model_name"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="./@from_module!='NO'">
      <!-- output the scope statements from the module -->
      <xsl:choose>
        <xsl:when test="$business_object_model_ok='true'">
            <ul>
              <!--<xsl:apply-templates
                select="document(concat('../../data/modules/', $ap_name,'/module.xml'))/module/outscope/li"/>-->
            </ul>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="error_message">
            <xsl:with-param name="message">
              <xsl:value-of select="concat('Error BOM1: The business_object_model', $business_object_model_name,' does not exist.', ' Correct business_object_model module_name in business_object_model.xml')"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
        
    <!-- output the scope statements from the BOM doc -->
    <xsl:if test="./li">
      <ul>
        <xsl:apply-templates select="li"/>
      </ul>
    </xsl:if>
  </xsl:template> 

  <xsl:template match="express_ref_inline">

  <xsl:variable name="linkend" select="@linkend"/>

  <xsl:variable name="first_sect">
    <xsl:call-template name="check_express_ref_first_section">
      <xsl:with-param name="linkend" select="$linkend"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$first_sect = 'OK'">
      
      <!-- remove all whitespace -->
      <xsl:variable
        name="nlinkend"
        select="translate($linkend,'&#x9;&#xA;&#x20;&#xD;','')"/>

      <xsl:variable
        name="module"
        select="substring-before($nlinkend,':')"/>

      <xsl:variable name="bom_dir">
        <!--<xsl:call-template name="business_object_model_directory">
          <xsl:with-param name="business_object_model" select="$module"/>
        </xsl:call-template>-->
      </xsl:variable>


      <xsl:variable name="express_path"
        select="substring-after(substring-after($nlinkend,':'),':')"/>
      
      <xsl:variable name="schema">
        <xsl:choose>
          <xsl:when test="contains($express_path,'.')">
            <xsl:value-of select="substring-before($express_path,'.')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$express_path"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="express_path1"
        select="substring-after($express_path,'.')"/>
      
      <xsl:variable name="entity_type">
        <xsl:choose>
          <xsl:when test="contains($express_path1,'.')">
            <xsl:value-of select="substring-before($express_path1,'.')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$express_path1"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="express_path2"
        select="substring-after($express_path1,'.')"/>

      <xsl:variable name="attribute">
        <xsl:choose>
          <xsl:when test="starts-with($express_path2,'wr:') 
                          or starts-with($express_path2,'ur:')">
            <xsl:value-of select="''"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$express_path2"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="wr">
        <xsl:choose>
          <xsl:when test="starts-with($express_path2,'wr:')">
            <xsl:value-of select="substring-after($express_path2,'wr:')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="''"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="ur">
        <xsl:choose>
          <xsl:when test="starts-with($express_path2,'ur:')">
            <xsl:value-of select="substring-after($express_path2,'ur:')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="''"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>



      <xsl:variable name="arm_mim_res"
        select="substring-before(substring-after($nlinkend,':'),':')"/>

      <!--<xsl:variable name="express_file">
        <xsl:choose>
          <xsl:when test="$arm_mim_res='arm'
                          or $arm_mim_res='arm_express'">
            <xsl:value-of select="concat($bom_dir,'/arm.xml')"/>
          </xsl:when>
          <xsl:when test="$arm_mim_res='mim'
                          or $arm_mim_res='mim_express'">
            <xsl:value-of select="concat($bom_dir,'/mim.xml')"/>
          </xsl:when>
          <xsl:when test="$arm_mim_res='mim_lf_express'">
            <xsl:value-of select="concat($bom_dir,'/mim_lf.xml')"/>
          </xsl:when>
          <xsl:when test="$arm_mim_res='ir_express'">
            <xsl:value-of select="concat('../data/resources/',$schema,'/',$schema,'.xml')"/>
          </xsl:when>
          <xsl:when test="$arm_mim_res='reference'">
            <xsl:value-of select="concat('../../data/reference/',$schema,'/',$schema,'.xml')"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>-->
      <!--<xsl:variable name="express_nodes"
        select="document(string($express_file))"/>-->
      <xsl:choose>
        <xsl:when test="string-length($wr) != 0">
          <!--<xsl:if test="not($express_nodes/express/schema[@name=$schema]/entity[@name=$entity_type]/where[@label=$wr])">
            <xsl:call-template name="error_message">
              <xsl:with-param name="message" 
                select="concat('Error ER-4: The express_ref linkend #', 
                        $linkend, 
                        '# is incorrectly specified. 
                        #The WHERE rule does not exist.
                        #Note linkend is case sensitive.')"/>
            </xsl:call-template>
          </xsl:if>-->
                 <!--<xsl:if test="$express_nodes/express/schema[@name=$schema]/entity[@name=$entity_type]/where[@label=$wr]">
                   <xsl:apply-templates select="$express_nodes/express/schema[@name=$schema]/entity[@name=$entity_type]" mode="code"/>           </xsl:if>
        </xsl:when>

        <xsl:when test="string-length($ur) != 0">
          <xsl:if test="not($express_nodes/express/schema[@name=$schema]/entity[@name=$entity_type]/unique[@label=$ur])">
            <xsl:call-template name="error_message">
              <xsl:with-param name="message" 
                select="concat('Error ER-5: The express_ref linkend ', 
                        $linkend, 
                        '# is incorrectly specified.# 
                        The UNIQUE rule does not exist.
                        #Note linkend is case sensitive.')"/>
            </xsl:call-template>
          </xsl:if>-->
        </xsl:when>

        <xsl:when test="string-length($attribute) != 0">
          <!--<xsl:if
            test="not($express_nodes/express/schema[@name=$schema]/entity[@name=$entity_type]/explicit[@name=$attribute]
                  or 
                  $express_nodes/express/schema[@name=$schema]/entity[@name=$entity_type]/inverse[@name=$attribute]
                  or
                  $express_nodes/express/schema[@name=$schema]/entity[@name=$entity_type]/derived[@name=$attribute]
                  or
                  $express_nodes/express/schema[@name=$schema]/type[@name=$entity_type]/enumeration/@items[contains(.,$attribute)]
)">
            <xsl:call-template name="error_message">
              <xsl:with-param name="message" 
                select="concat('Error ER-6: The express_ref linkend# ', 
                        $linkend, 
                        '# is incorrectly specified. 
                        The attribute does not exist.#
                        Note linkend
is case sensitive.')"/>
            </xsl:call-template>
          </xsl:if>-->
        </xsl:when>


        <xsl:when test="string-length($entity_type) != 0">
          <!--<xsl:if
            test="not($express_nodes/express/schema[@name=$schema]/entity[@name=$entity_type]
                  or 
                  $express_nodes/express/schema[@name=$schema]/type[@name=$entity_type]
                  or
                  $express_nodes/express/schema[@name=$schema]/rule[@name=$entity_type]
                  or 
                  $express_nodes/express/schema[@name=$schema]/function[@name=$entity_type]
                  or
                  $express_nodes/express/schema[@name=$schema]/procedure[@name=$entity_type]
                  )">
            <xsl:call-template name="error_message">
              <xsl:with-param name="message" 
                select="concat('Error ER-7: The express_ref linkend#', 
                              $linkend, 
                              '# is incorrectly specified.# 
                        The entity does not exist.#Note linkend
is case sensitive.')"/>
            </xsl:call-template>

          </xsl:if>-->

            <!--<xsl:if test="$express_nodes/express/schema[@name=$schema]/entity[@name=$entity_type]">
              <xsl:apply-templates select="$express_nodes/express/schema[@name=$schema]/entity[@name=$entity_type]" mode="code"/>
              
            </xsl:if>

            <xsl:if test="$express_nodes/express/schema[@name=$schema]/type[@name=$entity_type]">
              <xsl:apply-templates select="$express_nodes/express/schema[@name=$schema]/type[@name=$entity_type]" mode="code"/>

              
            </xsl:if>
            <xsl:if test="$express_nodes/express/schema[@name=$schema]/rule[@name=$entity_type]">
              <xsl:apply-templates select="$express_nodes/express/schema[@name=$schema]/rule[@name=$entity_type]" mode="code"/>
              
            </xsl:if>
            <xsl:if test="$express_nodes/express/schema[@name=$schema]/function[@name=$entity_type]">
              <xsl:apply-templates select="$express_nodes/express/schema[@name=$schema]/function[@name=$entity_type]" mode="code"/>
              
            </xsl:if>
            <xsl:if test="$express_nodes/express/schema[@name=$schema]/procedure[@name=$entity_type]">
              <xsl:apply-templates select="$express_nodes/express/schema[@name=$schema]/procedure[@name=$entity_type]" mode="code"/>
            </xsl:if>  -->          
        </xsl:when>

        <xsl:otherwise>
            <!--<xsl:call-template name="error_message">
              <xsl:with-param name="message" 
                select="concat('Error ER-9: The express_ref linkend #', 
                        $linkend, 
                        '# is incorrectly specified.')"/>
            </xsl:call-template>-->          
        </xsl:otherwise>
       
      </xsl:choose>

    </xsl:when>

    <xsl:otherwise>
      <!--<xsl:call-template name="error_message">
        <xsl:with-param name="message" select="$first_sect"/>
      </xsl:call-template>-->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
 
  <xsl:template match="bom">

    <xsl:variable name="model" select="../../@name"/>
    <xsl:variable name="model_dir" select="$model"/>
    <xsl:variable name="bom_xml" select="concat('../../data/business_object_models/', $model_dir,'/bom.xml')"/>
    <xsl:variable name="bom_node" select="document($bom_xml)"/>

  <xsl:variable name="type_clause_number">
    <xsl:call-template name="express_clause_number">
      <xsl:with-param name="clause" select="'type'"/>
      <xsl:with-param name="schema_name" select="$bom_node/express/schema/@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="entity_clause_number">
    <xsl:call-template name="express_clause_number">
      <xsl:with-param name="clause" select="'entity'"/>
      <xsl:with-param name="schema_name" select="$bom_node/express/schema/@name"/>
    </xsl:call-template>
  </xsl:variable>

	 
  <!--  <h2><a name="types"><xsl:value-of select="$type_clause_number"/>&#160;Business object model type definitions</a></h2>
    <p>
      <u>EXPRESS specification:</u><br/>
      (*<br/>
      SCHEMA <xsl:value-of select="concat($model, '_bom')"/>;<br/>
      *)
    </p> -->
    <!--<xsl:apply-templates select="$bom_node/express/schema/interface"/> -->
    <xsl:apply-templates select="$bom_node/express/schema/constant"/>
    <!-- display the EXPRESS for the types in the schema. -->
    <xsl:apply-templates select="$bom_node/express/schema/type"/>
    
    <h2><a name="entities"><xsl:value-of select="$entity_clause_number"/>&#160;Business object model entity definitions</a></h2>
    
    <!-- display the EXPRESS for the entities in the BOM.
    The template is in sect4_express.xsl -->
    <xsl:apply-templates select="$bom_node/express/schema/entity"/>
    
    <!--
    <xsl:variable name="c_expg"
      select="concat('./c_arm_expg',$FILE_EXT)"/>
    <xsl:variable name="sect51" 
      select="concat('./5_mapping',$FILE_EXT,'#mapping')"/>
    
    <xsl:variable name="current_module">
      <xsl:call-template name="module_display_name">
        <xsl:with-param name="module" select="../@name"/>
      </xsl:call-template>           
    </xsl:variable>
    
    <p class="note">
      <small>
        NOTE&#160;1&#160;&#160;A graphical representation of the information
        requirements is given in 
        Annex <a href="{$c_expg}">C</a>.
      </small>
    </p>
    
    <p class="note">
      <small>
        NOTE&#160;2&#160;&#160;The mapping specification is specified in 
        <a href="{$sect51}">5.1</a>. It shows how
        the information requirements are met by using common resources and
        constructs defined or imported in the MIM schema of this application
        module. 
      </small>
    </p>
    
    <p>
      This clause defines the information requirements to which implementations shall
      conform using the EXPRESS language as defined in ISO 10303-11.   
      <xsl:choose>
        <xsl:when test="$arm_node/express/schema/interface">
          The following begins the 
          <b><xsl:value-of select="$arm_node/express/schema/@name"/></b>
          schema and identifies the necessary external references.
        </xsl:when>
        <xsl:otherwise>
          The following begins the 
          <b><xsl:value-of select="$current_module"/></b> schema.
        </xsl:otherwise>
      </xsl:choose>
    </p>
    
    <!-\- Just display the description of the schema. -\->
    <xsl:apply-templates 
      select="$arm_node/express/schema" mode="description"/>
    
    
    <!-\- there is only one schema in a module -\->
    <xsl:variable 
      name="schema_name" 
      select="$arm_node/express/schema/@name"/>
    
    <xsl:call-template name="check_schema_name">
      <xsl:with-param name="arm_mim_schema" select="'arm'"/>
      <xsl:with-param name="schema_name" select="$schema_name"/>
    </xsl:call-template>
    
    <xsl:variable name="xref">
      <xsl:call-template name="express_a_name">
        <xsl:with-param name="section1" select="$schema_name"/>
      </xsl:call-template>
    </xsl:variable>
    
    <!-\- output any issuess against the schema   -\->
    <!-\-<xsl:call-template name="output_express_issue">
      <xsl:with-param name="schema" select="$schema_name"/>
    </xsl:call-template>-\-> 
    <u>EXPRESS specification: </u>
    <code>
      <br/>    <br/>
      *)<br/>
      <a name="{$xref}">
        SCHEMA <xsl:value-of select="concat($schema_name,';')"/>
      </a>
      <br/>(*<br/>
    </code>
   
    
    <!-\- display the constant EXPRESS. The template is in sect4_express.xsl -\->
    
    
    
    
    <!-\- display the EXPRESS for the subtype.contraints in the ARM.
      The template is in sect4_express.xsl -\->
    <xsl:apply-templates 
      select="$arm_node/express/schema/subtype.constraint"/>
    
    <!-\- display the EXPRESS for the functions in the ARM
      The template is in sect4_express.xsl -\->
    <xsl:apply-templates 
      select="$arm_node/express/schema/function"/>
    
    <!-\- display the EXPRESS for the entities in the ARM. 
      The template is in sect4_express.xsl -\->
    <xsl:apply-templates 
      select="$arm_node/express/schema/rule"/>
    
    <!-\- display the EXPRESS for the procedures in the ARM. 
      The template is in sect4_express.xsl -\->
    <xsl:apply-templates 
      select="$arm_node/express/schema/procedure"/>-->
    
    
    <code>
      <br/>    <br/>
      *)<br/>
      END_SCHEMA;&#160;&#160;--&#160;<!--<xsl:value-of select="$arm_node/express/schema/@name"/>-->
      <br/>(*
    </code>
    
  </xsl:template>


</xsl:stylesheet>
