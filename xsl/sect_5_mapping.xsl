<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_5_mapping.xsl,v 1.31 2002/06/28 10:19:55 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="module.xsl"/>
  <xsl:import href="sect_5_mapping_check.xsl"/>

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
  <xsl:import href="module_clause.xsl"/>

  <xsl:preserve-space elements="aimelt"/>
  <xsl:output method="html"/>


  <!-- +++++++++++++++++++
         Global variables
       +++++++++++++++++++ -->

  <!-- a list of all the entities and resources defined in the resources.
       Used by link_resource_object to produce a URL 
       <xsl:variable name="global_resource_xref_list">
         <xsl:call-template name="build_resource_xref_list"/>
       </xsl:variable>
-->

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
       The list is used to check for existence of entities in mapping tables
       BUILDING THIS LIST SLOWS EVERYTHING DOWN SO SETTING
       check_mapping to 'no' will turn off check
       -->
  <xsl:variable name="global_xref_list">
    <xsl:if test="$check_mapping='yes'">
      <!-- debug 
           <xsl:message>
             global_xref_list defined in sect_5_mapping.xsl
           </xsl:message> -->
      <xsl:choose>
        <xsl:when test="/module_clause">
          <xsl:variable name="module_dir">
            <xsl:call-template name="module_directory">
              <xsl:with-param name="module" select="/module_clause/@directory"/>
            </xsl:call-template>
          </xsl:variable>
          
          <xsl:variable name="express_xml" select="concat($module_dir,'/mim.xml')"/>
          <xsl:call-template name="build_xref_list">
            <xsl:with-param name="express" select="document($express_xml)/express"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="/module">
          <xsl:variable name="module_dir">
            <xsl:call-template name="module_directory">
              <xsl:with-param name="module" select="/module/@name"/>
            </xsl:call-template>
          </xsl:variable>
          
          <xsl:variable name="express_xml" select="concat($module_dir,'/mim.xml')"/>
          <xsl:call-template name="build_xref_list">
            <xsl:with-param name="express" select="document($express_xml)/express"/>
          </xsl:call-template>        
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:variable>


  <!-- A global variable used by the express_file_to_ref template defined
       in express_link.xsl.
       It defines the relative path from the file applying the stylesheet
       to the root of the stepmod repository.
       sect_e_exp_arm.xsl stylesheet is normally used
         stepmod/data/module/?module?/sys/5_mapping.xml
       Hence the relative root is: ../../../../
       -->
  <xsl:variable 
    name="relative_root"
    select="'../../../../'"/>

  <!-- +++++++++++++++++++
         Templates
       +++++++++++++++++++ -->

<!-- overwrites the template declared in module.xsl -->
<xsl:template match="module">
  <!--
       SC4 do not like the index of mapping tables at the top
       <xsl:apply-templates select="./mapping_table" mode="toc"/>
       -->
  <h3>
    <a name="mapping">5.1 Mapping specification</a>
  </h3>
  <xsl:call-template name="mapping_syntax"/>
  <a name="mappings"/>
  <xsl:apply-templates select="./mapping_table" mode="check_all_arm_mapped"/>
  <xsl:apply-templates select="./mapping_table/ae" mode="specification"/>
</xsl:template>


<xsl:template name="mapping_syntax">
  <!-- boiler plate text for mapping syntax -->
  <p>
    This clause contains the mapping specification that shows how each UoF and
    application object of this part of ISO 10303 (see clause 4) maps to one or
    more AIM constructs (see annex A). Each mapping specifies up to five
    elements.
  </p>

  <p>
    <b>Application element:</b>
    The mapping for each application element is specified in a separate
    subclause below. Application object names are given in title
    case. Attribute names and assertions are listed after the application
    object to which they belong and are given in lower case.
  </p>

  <p>
    <b>AIM element:</b>
    The name of one or more AIM entity data types (see annex A), the term
    "IDENTICAL MAPPING", or the term "PATH" entity data type names are given in
    lower case. Attributes of AIM entity data types are referred to as
    &lt;entity name&gt;.&lt;attribute name&gt;. The mapping of an application 
    element may involve more than one AIM element. Each of these AIM elements
    is presented on a separate line in the mapping specification. 
    The term "IDENTICAL MAPPING" indicates that both application objects
    involved in an application assertion map to the same instance of an AIM
    entity data type. The term "PATH" indicates that the application
    assertion maps to a collection of related AIM entity instances specified
    by the entire reference path. 
  </p>

  <p>
    <b>Source:</b>
    For those AIM elements that are interpreted from any common resource,
    this is the ISO standard number and part number in which the resource is
    defined. For those AIM elements that are created for the purpose of this
    part of ISO 10303, this is "ISO 10303-" followed by the number of
    this part.
  </p>

  <p>
    <b>Rules:</b>
    One or more global rules may be specified that apply to the population of
    the AIM entity data types specified as the AIM element or in the
    reference path. For rules that are derived from relationships between
    application objects, the same rule is referred to by the mapping entries of
    all the involved AIM elements. A reference to a global rule may be
    accompanied by a reference to the sub-clause in which the rule is defined.
  </p>

  <p>
    <b>Reference path:</b>
    To describe fully the mapping of an application object, it may be
    necessary to specify a reference path involving several related AIM
    elements. Each line in the reference path documents the role of an AIM
    element relative to the AIM element in the line following it. Two or more
    such related AIM elements define the interpretation of the integrated
    resources that satisfies the requirement specified by the application
    object. For each AIM element that has been created for use within this part
    of ISO 10303, a reference path to its supertype from an integrated resource
    is specified. 
    For the expression of reference paths and the relationships between AIM
    elements the following notational conventions apply: 
  </p>
  <table cellspacing="4">
    <tr valign="top">
      <td valign="top">[]</td>
      <td valign="top">
        enclosed section constrains multiple AIM elements or sections of
        the reference path are required to satisfy an information
        requirement;
      </td>
    </tr>

    <tr valign="top">
      <td valign="top">()</td>
      <td valign="top">
        enclosed section constrains multiple AIM elements or sections of
        the reference path are identified as alternatives within the mapping to
        satisfy an information requirement; 
      </td>
    </tr>

    <tr valign="top">
      <td valign="top">{}</td>
      <td valign="top">
        enclosed section constrains the reference path to satisfy an
        information requirement; 
      </td>
    </tr>

    <tr valign="top">
      <td valign="top">&lt;&gt;</td>
      <td valign="top">
        enclosed section constrains at one or more required reference path;   
      </td>
    </tr>

    <tr valign="top">
      <td valign="top">||</td>
      <td valign="top">
        enclosed section constrains the supertype entity;
      </td>
    </tr>

    <tr valign="top">
      <td valign="top">-&gt;</td>
      <td valign="top">
        attribute references the entity or select type given in the
        following row; 
      </td>
    </tr>

    <tr valign="top">
      <td valign="top">&lt;-</td>
      <td valign="top">
        entity or select type is referenced by the attribute in the
        following row; 
      </td>
    </tr>

    <tr valign="top">
      <td valign="top">[i]</td>
      <td valign="top">
        attribute is an aggregation of which a single member is given in
        the following row; 
      </td>
    </tr>

    <tr valign="top">
      <td valign="top">[n]</td>
      <td valign="top">
        attribute is an aggregation of which member n is given in the
        following row; 
      </td>
    </tr>

    <tr valign="top">
      <td valign="top">=&gt;</td>
      <td valign="top">
        entity is a supertype of the entity given in the following row;
      </td>
    </tr>

    <tr valign="top">
      <td valign="top">&lt;=</td>
      <td valign="top">
        entity is a subtype of the entity given in the following row;
      </td>
    </tr>

    <tr valign="top">
      <td valign="top">=</td>
      <td valign="top">
        the string, select, or enumeration type is constrained to a choice
        or value; 
      </td>
    </tr>

    <tr valign="top">
      <td valign="top">\</td>
      <td valign="top">
        the reference path expression continues on the next line;
      </td>
    </tr>

    <tr valign="top">
      <td valign="top">*</td>
      <td valign="top">
        used in conjunction with braces to indicate that any number of
        relationship entity data types may be assembled in a relationship
        tree structure.
      </td>
    </tr>
    <!-- we do not use or support templates yet
    <tr valign="top">
      <td valign="top">//</td>
      <td valign="top">
        enclosed section is an application of one of the mapping templates
        defined in 5.1.1 below; 
      </td>
    </tr>
    -->
    <tr valign="top">
      <td valign="top">--</td>
      <td valign="top">
        the text following is a comment (normally a clause reference);
      </td>
    </tr>

    <tr valign="top">
      <td valign="top">*&gt;</td>
      <td valign="top">
        the select, or enumeration type before the symbol is extended into
        the select or enumeration after the symbol;  
      </td>
    </tr>
 

    <tr valign="top">
      <td valign="top">&lt;*</td>
      <td valign="top">
        the select, or enumeration type before the symbol is an extension
        of the select or enumeration after the symbol.
      </td>
    </tr>
  </table>
  The definition and use of mapping templates is not supported in the
  present version of the application modules.  
</xsl:template>


<!-- layout the mapping as a mapping specification -->
<xsl:template match="ae" mode="specification">
  <xsl:variable name="sect_no">
    <xsl:number/>
  </xsl:variable>
  <xsl:variable name="aname" select="@entity"/>

  <xsl:variable name="schema_name">
    <xsl:call-template name="schema_name">
      <xsl:with-param name="module_name" select="../../../module/@name"/>
      <xsl:with-param name="arm_mim" select="'arm'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="ae_aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@entity"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable 
    name="ae_xref"
    select="concat('./4_info_reqs',$FILE_EXT,'#',$ae_aname)"/>

  <xsl:variable name="arm_entity" select="@entity"/>
  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="../../../module/@name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="arm_xml" select="concat($module_dir,'/arm.xml')"/>
  <xsl:choose>
    <xsl:when test="not(document($arm_xml)/express/schema/entity[@name=$arm_entity])">
      <xsl:call-template name="error_message">
        <xsl:with-param name="message"
          select="concat('Error m1: The entity ', $arm_entity, 
                  ' does not exist in the arm')"/>
      </xsl:call-template>
    </xsl:when>
  </xsl:choose>

  
  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="ae" select="translate(@entity,$LOWER,$UPPER)"/>

  <h3>
    <a name="{$aname}">
      <xsl:value-of select="concat('5.1.',$sect_no,' ')"/>
    </a>

    <a href="{$ae_xref}">
      <xsl:value-of select="$ae"/>
    </a>
    <xsl:variable name="entity_node"
      select="document($arm_xml)/express/schema/entity[@name=$arm_entity]"/>
    <xsl:apply-templates select="$entity_node" mode="expressg_icon"/>
  </h3>

  <xsl:apply-templates select="./alt" mode="specification"/>
  <!-- now layout the aim element -->

  <xsl:choose>
    <xsl:when test="./alt_map">
      <!-- can either have a set of alternatives or one mapping -->
      <xsl:apply-templates select="./alt_map" mode="output_mapping"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="." mode="output_mapping"/>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:apply-templates select="aa" mode="specification">
    <xsl:with-param name="sect" select="concat('5.1.',$sect_no)"/>
  </xsl:apply-templates>
</xsl:template>


<xsl:template match="aa" mode="specification">
  <xsl:param name="sect"/>
  <xsl:variable 
    name="schema_name" 
    select="concat(../../../../module/@name,'_arm')"/>

  <xsl:variable name="aa_aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="../@entity"/>
      <xsl:with-param name="section3" select="@attribute"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable 
    name="aa_xref"
    select="concat('./4_info_reqs',$FILE_EXT,'#',$aa_aname)"/>

  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="../../../../module/@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="arm_xml" select="concat($module_dir,'/arm.xml')"/>

  <xsl:variable name="sect_no" select="concat($sect,'.',position())"/>
  <!-- users frequently try to write the assertion explicitly e.g.
       Part_version to Part (as of_product)
       instead of using assertion_to -->
  <xsl:choose>
    <xsl:when test="contains(@attribute,'(as')">
      
      <xsl:call-template name="error_message">
        <xsl:with-param name="message">
          <xsl:value-of select="concat('Error m2: ', @attribute, ' should
                                be the name of an ARM entity. Use 
                                &lt;aa attribute=&#034;&#034; assertion_to=&#034;&#034;&gt; ')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
  </xsl:choose>

  <xsl:variable name="arm_entity" select="string(../@entity)"/>
  <xsl:variable name="arm_attr" select="string(@attribute)"/>

  <h3>
    <a name="{$aa_aname}">
    <xsl:choose>
      <xsl:when test="@assertion_to">
        
        <xsl:variable name="ae_aname">
          <xsl:call-template name="express_a_name">
            <xsl:with-param name="section1" select="$schema_name"/>
            <xsl:with-param name="section2" select="../@entity"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="ae_xref"
          select="concat('./4_info_reqs',$FILE_EXT,'#',$ae_aname)"/>
        <xsl:value-of select="concat($sect_no,' ')"/>
        <a href="{$ae_xref}">
          <xsl:value-of select="../@entity"/>
        </a>
        to 
        <xsl:value-of select="@assertion_to"/>
        (as             
        <a href="{$aa_xref}">
          <xsl:value-of select="@attribute"/>
        </a>)
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat($sect_no,' ')"/>
        <a href="{$aa_xref}">
          <xsl:value-of select="@attribute"/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </a>

  <xsl:variable name="ae" select="../@entity"/>
  <xsl:variable name="entity_node"
      select="document($arm_xml)/express/schema/entity[@name=$ae]"/>
  <xsl:apply-templates select="$entity_node" mode="expressg_icon"/>
  </h3>

  <!--  check that the attribut exists in the arm -->
  <xsl:if
    test="not(document($arm_xml)/express/schema/entity[@name=$arm_entity]/explicit[@name=$arm_attr])">
    <xsl:call-template name="error_message">
      <xsl:with-param name="message"
        select="concat('Error m1: The attribute ', ../@entity,'.',@attribute 
                ' does not exist in the arm as an expilcit attribute')"/>
    </xsl:call-template>
  </xsl:if>


  <xsl:apply-templates select="./alt" mode="specification"/>

  <xsl:choose>
    <xsl:when test="./alt_map">
      <!-- can either have a set of alternatives or one mapping -->
      <xsl:apply-templates select="./alt_map" mode="output_mapping"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="." mode="output_mapping"/>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>


<xsl:template match="alt" mode="specification">
  <xsl:call-template name="error_message">
    <xsl:with-param name="message">
      'Warning &lt;alt&gt; has been deprecated. Use &lt;alt_map&gt; instead'
    </xsl:with-param>
  </xsl:call-template>
  <xsl:call-template name="output_string_with_linebreaks">
    <xsl:with-param name="string" select="string(.)"/>
  </xsl:call-template>
  <br/>
</xsl:template>

<xsl:template match="aimelt" mode="specification">
  <xsl:apply-templates select="." mode="check_aimelt"/>
  <tr valign="top">
    <td>AIM element:</td>
    <td>
      <xsl:call-template name="output_string_with_linebreaks">
        <xsl:with-param name="string" select="string(.)"/>
      </xsl:call-template>
    </td>
  </tr>
</xsl:template>


<xsl:template match="source" mode="specification">
  <xsl:variable name="str" select="string(.)"/>
  <xsl:if test="string-length($str)>0">
    <tr valign="top">
      <td>Source:</td>
      <td>
        <xsl:call-template name="output_string_with_linebreaks">
          <xsl:with-param name="string" select="$str"/>
        </xsl:call-template>
      </td>
    </tr>
  </xsl:if>
</xsl:template>

<xsl:template match="rules" mode="specification">
  <xsl:variable name="str" select="string(.)"/>
  <xsl:if test="string-length($str)>0">
    <tr valign="top">
      <td>Rules:</td>
      <td>
        <xsl:call-template name="output_string_with_linebreaks">
          <xsl:with-param name="string" select="$str"/>
        </xsl:call-template>
      </td>
    </tr>
  </xsl:if>
</xsl:template>


<xsl:template match="refpath" mode="specification">
  <xsl:variable name="str" select="string(.)"/>
  <xsl:if test="string-length($str)>0">
    <tr valign="top">
      <td>Reference path:&#160;&#160;</td>
      <xsl:apply-templates select="." mode="check_ref_path"/>
      <td>
        <xsl:call-template name="output_string_with_linebreaks">
          <xsl:with-param name="string" select="$str"/>
        </xsl:call-template>
      </td>
    </tr>
  </xsl:if>
</xsl:template>


<xsl:template match="alt_map" mode="output_id_description">
  <xsl:choose>
    <xsl:when test="@id">
      <p/>
      <xsl:value-of select="concat('#',@id,'&#160;&#160;&#160;')"/>
      <xsl:apply-templates select="./description"/>
      <p/>
    </xsl:when>

    <!-- use a description defined earlier in the mapping specification -->
    <xsl:when test="@alt_map.inc">
      <!-- 
           can only use in an a mapping specification for an attribute aa
           -->
      <xsl:variable name="dsc.id" select="@alt_map.inc"/>
      <xsl:choose>
        <xsl:when test="../../alt_map[@id=$dsc.id]/description">
          <xsl:apply-templates 
            select="../../alt_map[@id=$dsc.id]" mode="output_id_description"/>          
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="error_message">
            <xsl:with-param name="message">
              <xsl:value-of select="concat('Error altm2: cannot find the
description referred to by @alt_map.inc ',@alt_map.inc, ' Can only
reference description defnied in the alt_map at the entity (ae) level) in
the mapping specification')"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>


    <xsl:otherwise>
      <xsl:variable name="msg">
        <xsl:choose>
          <xsl:when test="../@entity">
            <xsl:value-of 
              select="concat('Error altm1: alt_map in &lt;ae entity=&quot;',
                      ../@entity,'&quot; must specifiy @id')"/>
          </xsl:when>
          <xsl:when test="../@attribute">
            <xsl:value-of 
              select="concat('Error altm1: alt_map in &lt;a attribute=&quot;',
                      ../@attribute,'&quot; must specifiy @id')"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:call-template name="error_message">
        <xsl:with-param name="message">
          <xsl:value-of select="$msg"/>
          </xsl:with-param>
        </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="ae|aa" mode="output_id_description">
  <p/>
  <xsl:apply-templates select="./description"/>
  <p/>
</xsl:template>


<!-- This is the main template to output the mapping specification -->
<xsl:template match="ae|aa|alt_map" mode="output_mapping">
  <xsl:apply-templates select="." mode="output_id_description"/>
  <table>
    <xsl:apply-templates select="./aimelt"  mode="specification"/>
    <xsl:apply-templates select="./source"  mode="specification"/>
    <xsl:apply-templates select="./rules"  mode="specification"/>
    <xsl:apply-templates select="./refpath"  mode="specification"/>
  </table>  
</xsl:template>

<!-- 
     ************************************************************
     Error checking 
     ************************************************************
-->





<!-- to be done -->
<xsl:template name="check_ref_path_line"/>

<xsl:template name="check_ref_path_line_RBN">
  <xsl:param name="refpath"/>

  <xsl:variable name="entity">
    <xsl:call-template name="extract_entity">
      <xsl:with-param name="line" select="$refpath"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="rest" select="substring-after($refpath,'$')"/>

  <xsl:call-template name="check_entity_exists">
    <xsl:with-param name="entity" select="$entity"/>
  </xsl:call-template>


  <!-- not yet implimented
  <xsl:if test="contains($nline,'.')">
    <xsl:variable name="attribute">
      <xsl:value-of select="substring-after($nline,'.')"/>
    </xsl:variable>
    <xsl:call-template name="check_valid_attribute">
      <xsl:with-param name="entity" select="$entity"/>
      <xsl:with-param name="attribute" select="$attribute"/>
    </xsl:call-template>
  </xsl:if>
  -->

  <xsl:if test="string-length(normalize-space($rest)) > 1">
    <xsl:call-template name="check_ref_path_line">
      <xsl:with-param name="refpath" select="$rest"/>
    </xsl:call-template>    
  </xsl:if>
</xsl:template>


<!-- extracts an entity from a reference path string -->
<xsl:template name="extract_entity">
  <xsl:param name="line"/>
  <xsl:variable name="nline0" 
    select="normalize-space(substring-before($line,'$'))"/>

  <!-- extract the entity from a line. E.g.
       {representation.name = 'document creation'}
       representation.items[i] ->
       representation_item =>
       {representation_item.name = 'creating system'}
       First, truncate string at = 
       replace all separators e.g {}[]()<> with space
       normalize the sapce and add a space to the end of the line
       -->
  <xsl:variable name="nline1">
    <xsl:choose>
      <xsl:when test="contains($nline0,'=')">
        <xsl:value-of select="substring-before($nline0,'=')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$nline0"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="nline2"
    select="translate($nline1,'1234567890','          ')"/>
  <xsl:variable name="nline3"
    select="concat(normalize-space(translate($nline2,'#:{}[]()&lt;&gt;-=',
            '            ')),' ')"/>

  <xsl:variable name="entity">
    <xsl:choose>
      <xsl:when test="contains($nline3,'.')">
        <xsl:value-of select="substring-before($nline3,'.')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="substring-before($nline3,' ')"/>    
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$entity"/>
</xsl:template>

</xsl:stylesheet>
