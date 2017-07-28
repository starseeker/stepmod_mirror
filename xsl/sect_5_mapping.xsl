<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_5_mapping.xsl,v 1.85 2015/08/12 11:29:42 mikeward Exp $
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
          
          <!-- RBN was
               <xsl:variable name="express_xml"
                 select="concat($module_dir,'/mim.xml')"/>
               changed to allow linking of ARM assertions, Checking of
               refpath is now done in mapping view 
          -->
          <xsl:variable name="express_xml" select="concat($module_dir,'/arm.xml')"/>
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

  <xsl:variable 
    name="modname"
    select="/module_clause/@directory"/>

<xsl:template match="module">
  <!--
       SC4 do not like the index of mapping tables at the top
       <xsl:apply-templates select="./mapping_table" mode="toc"/>
       -->
  <h2>
    <a name="mapping">5.1 Mapping specification</a>
  </h2>
  <a name="mappings"/>
  <xsl:choose>
    <xsl:when test="./mapping_table/ae or ./mapping_table/sc">
      <xsl:call-template name="mapping_syntax"/>
      <xsl:apply-templates select="." mode="output_mapping_issue"/>
      <xsl:apply-templates select="./mapping_table" mode="check_all_arm_mapped"/>
      <xsl:apply-templates select="./mapping_table/ae" mode="specification">
        <xsl:sort select="./@entity"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="./mapping_table/sc" mode="specification"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="no_mapping_syntax"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="no_mapping_syntax">
  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="/module/@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="arm_xml" select="document(concat($module_dir,'/arm.xml'))"/>
  <xsl:choose>
    <xsl:when test="count($arm_xml/express/schema/interface)=1">
      <p>
        The mapping specification for this part of ISO 10303 is defined in
        <xsl:apply-templates select="$arm_xml/express/schema/interface" mode="link_use_from">
          <xsl:with-param name="item" select="'.'"/>
        </xsl:apply-templates>
      </p>
    </xsl:when>
    <xsl:when test="$arm_xml/express/schema/interface">
      <p>
        The mapping specification for this part of ISO 10303 is defined in:    
      </p>
      <ul>
        <xsl:apply-templates select="$arm_xml/express/schema/interface" mode="link_use_from">
          <xsl:with-param name="item" select="'li'"/>
        </xsl:apply-templates>
      </ul>
    </xsl:when>
    <xsl:otherwise>
      There is no mapping specification for this part of ISO 10303.
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="interface" mode="link_use_from">
  <xsl:param name="item" select="'li'"/>
  <xsl:variable name="mod_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="@schema"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="part">
    <xsl:value-of select="concat('ISO 10303-',document(concat($mod_dir,'/module.xml'))/module/@part)"/>
  </xsl:variable>

  <xsl:variable name="module_name">
    <xsl:call-template name="module_name">
      <xsl:with-param name="module" select="@schema"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="module_display_name">
    <xsl:call-template name="module_display_name">
      <xsl:with-param name="module" select="$module_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="module_href"
    select="concat('../../',$module_name,'/sys/5_mapping',$FILE_EXT)"/>
  <xsl:choose>
    <xsl:when test="$item='li'">
      <li>
        <xsl:choose>
          <xsl:when test="position()=last()">
            <a href="{$module_href}"><xsl:value-of select="$part"/></a>
            <xsl:value-of select="concat(' (',$module_display_name,').')"/>
          </xsl:when>
          <xsl:otherwise>
            <a href="{$module_href}"><xsl:value-of select="$part"/></a>
            <xsl:value-of select="concat(' (',$module_display_name,');')"/>
          </xsl:otherwise>
        </xsl:choose>
      </li>
    </xsl:when>
    <xsl:otherwise>
      <a href="{$module_href}"><xsl:value-of select="$part"/></a>
      <xsl:value-of select="concat(' (',$module_display_name,');')"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="mapping_syntax">
  <!-- boiler plate text for mapping syntax -->
  <xsl:variable name="sect4" 
    select="concat('4_info_reqs',$FILE_EXT)"/>
  <xsl:variable name="sect52" 
    select="concat('5_mim',$FILE_EXT,'#mim_express')"/>
  <p>
    In the following, &quot;Application element&quot; designates any entity data
    type defined in Clause <a href="{$sect4}">4</a>, any of its 
    explicit attributes and any subtype constraint. 
    &quot;MIM element&quot; designates any entity data type defined in 
    Clause <a href="{$sect52}">5.2</a> or imported with a USE FROM
    statement, from another EXPRESS schema, any of its 
    attributes and any subtype constraint defined in Clause <a href="{$sect52}">5.2</a> or imported with a USE FROM
    statement.
  </p>
  <p>
    This clause contains the mapping specification that defines how each 
    application element of this part of ISO 10303 (see Clause <a href="{$sect4}">4</a>) maps to one
    or more MIM elements (see Clause <a href="{$sect52}">5.2</a>).
  </p>

	<p>
The mapping for each application element is specified in a separate subclause below. 
The mapping specification of an attribute of an ARM entity is a subclause of the clause that contains the mapping specification of this entity.
    Each mapping specification subclause contains up to five elements.
  </p>
  <p>
    <b>Title:</b>
The clause title contains:</p>
<ul>
<li>the name of the considered ARM entity or subtype constraint, or </li>
<li>the name of the considered ARM entity atribute when this attribute refers to a type that is not an entity data type or a SELECT type that contains or may contain entity data types, or</li>
<li>a composite expression, &lt;attribute name&gt; to &lt;referred type&gt;, when this attribute refers to a type that is not an entity data type or a SELECT type that contains or may contain entity data types.</li>
</ul>


  <p>
    <b>MIM element:</b> 
    This section contains, depending on the considered application element:</p>
		<ul>
<li>the name of one or more MIM entity data types;</li>
		<li>the name of a MIM entity attribute, presented with the syntax &lt;entity name&gt;.&lt;attribute name&gt;, when the considered ARM attribute refers to a type that is not an entity data type or a SELECT type that contains or may contain entity data types;</li>
		<li>the term PATH, when the considered ARM entity attribute refers to an entity data type or to a SELECT type that contains or may contain entity data types;</li>
		<li>the term IDENTICAL MAPPING, when both application objects
    involved in an application assertion map to the same instance of a MIM entity data type;</li>
		<li>the term NO MAPPING EXTENSION PROVIDED, when the extension to an extensible SELECT TYPE has no impact;</li>
		<li>the syntax /SUPERTYPE(&lt;supertype name&gt;)/, when the considered ARM entity is mapped as its supertype;</li>
		<li>one or more constructs /SUBTYPE(&lt;subtype name&gt;)/, when the mapping of the considered ARM entity is the union of the mapping of its subtypes.</li>
		</ul>
		<p>
When the mapping of an application element involves more than one MIM element, each of these MIM elements is 
    presented on a separate line in the mapping specification, enclosed between parentheses or brackets. 
</p>
  <p>
    <b>Source:</b> This section contains:</p>
		<ul>
<li>the ISO standard number and part number in which the
    MIM element is defined, for those MIM elements that are defined in a common
    resource document;</li>
<li>the ISO standard number and
    part number of this part of ISO 10303, for those MIM elements that are defined in the MIM schema of this part.</li>
</ul>
  <p>
  This section is omitted when the keywords PATH or IDENTICAL MAPPING or NO MAPPING EXTENSION PROVIDED are used in the MIM element section.
  </p> 
  <p>
    <b>Rules:</b> 
    This section contains the name of one or more global rules that apply to the
    population of the MIM entity data types listed in the MIM element section or
    in the reference path. When no rule applies, this section is omitted.
		</p>
		<p>A reference to a
    global rule may be followed by a reference to the subclause in
    which the rule is defined.
  </p> 
  <p>
    <b>Constraint:</b> 
    This section contains the name of one or more subtype constraints that apply to the
    population of the MIM entity data types listed in the MIM element section or
    in the reference path. When no subtype constraint applies, this section is omitted.
  </p>
  <p>
    A reference to a subtype constraint may be followed by a reference to the subclause in
    which the subtype constraint is defined.
  </p> 

  <p>
    <b>Reference path:</b> This section contains:</p>
		<ul>
<li>the reference path to its supertypes in the common resources, 
for each MIM element created within this part of ISO 10303; 
</li>
<li>
the specification of the relationships between MIM elements, when the mapping of an application element requires to relate instances of several
 MIM entity data types. In such a case, each line in the reference path
    documents the role of a MIM element relative to the referring MIM
    element or to the next referred MIM element. 
		</li>
		</ul>

		<p>For the expression of reference paths and of the
    constraints between MIM elements, the following notational conventions
    apply:
  </p> 

  <table cellspacing="6">
    <tbody>
      <tr valign="top">
        <td valign="top">[]</td>
        <td valign="top">
          enclosed section constrains multiple MIM elements or
          sections of the reference path are required to satisfy an
          information requirement;
        </td>
      </tr>
      <tr valign="top">
        <td valign="top">()</td>
        <td valign="top">
          enclosed section constrains multiple MIM elements or
          sections of the reference path are identified as alternatives
          within the mapping to satisfy an information requirement;
        </td>
      </tr>
      <tr valign="top">
        <td valign="top">{}</td>
        <td valign="top">
          enclosed section constrains the reference path to satisfy
          an information requirement;
        </td>
      </tr>
      <tr valign="top">
        <td valign="top">&lt;&gt;</td>
        <td valign="top">
          enclosed section constrains at one or more required
          reference path;
        </td>
      </tr>
      <tr valign="top">
        <td valign="top">||</td>
        <td valign="top">enclosed section constrains the supertype entity;</td>
      </tr>
      <tr valign="top">
        <td valign="top">-&gt;</td>
        <td valign="top">
          the attribute, whose name precedes the -&gt; symbol, references the entity or select type whose name follows the -&gt; symbol;
        </td>
      </tr>
      <tr valign="top">
        <td valign="top">&lt;-</td>
	<td valign="top" >
          the entity or select type, whose name precedes the &lt;- symbol, is referenced by the entity attribute whose name follows the &lt;- symbol;
        </td>
      </tr>
      <tr valign="top">
        <td valign="top">[i]</td>
        <td valign="top">
          the attribute, whose name precedes the [i] symbol, is an aggregate; any element of that aggregate is referred to;
        </td>
      </tr>
      <tr valign="top">
        <td valign="top">[n]</td>
        <td valign="top">
          the attribute, whose name precedes the [n] symbol, is an ordered aggregate; member n of that aggregate is referred to;
        </td>
      </tr>
      <tr valign="top">
        <td valign="top">=&gt;</td>
        <td valign="top">
          the entity, whose name precedes the =&gt; symbol, is a supertype of the entity whose name follows the =&gt; symbol;
        </td>
      </tr>
      <tr valign="top">
        <td valign="top">&lt;=</td>
        <td valign="top">
          the entity, whose name precedes the &lt;= symbol, is a subtype of the entity whose name follows the &lt;= symbol;
        </td>
      </tr>
      <tr valign="top">
        <td valign="top">=</td>
        <td valign="top">
          the string, select, or enumeration type is constrained to a choice or value;
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
one or more instances of the relationship entity data type may be assembled in a
relationship tree structure. The path between the relationship entity and the related entities, is enclosed with braces;
        </td>
      </tr>
      <tr valign="top">
        <td valign="top">--</td>
        <td valign="top">
          the text following is a comment or introduces a clause reference;
        </td>
      </tr>
      <tr valign="top">
        <td valign="top">*&gt;</td>
        <td valign="top">
the select or enumeration type, whose name precedes the *&gt; symbol, is
          extended into the select or enumeration type whose name follows the *&gt; symbol;
        </td>
      </tr>
      <tr valign="top">
        <td valign="top">&lt;*</td>
        <td valign="top">
the select or enumeration type, whose name precedes the &lt;* symbol, is an
          extension of the select or enumeration type whose name follows the &lt;* symbol;
        </td>
      </tr>
      <tr valign="top">
        <td valign="top" nowrap='t'>!{}</td>
        <td valign="top">
 section enclosed by {} indicates a negative constraint placed on the mapping.</td>
      </tr>
    </tbody>
  </table>
  The definition and use of mapping templates is not supported in the
  present version of the application modules. However, use of predefined
  templates /SUBTYPE/ and /SUPERTYPE/ is supported. 
</xsl:template>


<!-- layout the mapping as a mapping specification -->
<xsl:template match="ae" mode="specification">
  <xsl:variable name="sect_no">
    <xsl:number/>
  </xsl:variable>
  <xsl:variable name="aname" select="@entity"/>

  <xsl:variable name="schema_name">
    <xsl:choose>
      <!-- original_module specified then the ARM object is declared in
           another module -->
      <!-- TEH except when it isnt - as in derived_geometry -->
      <xsl:when test="@original_module and @original_module != $modname">
        <xsl:call-template name="schema_name">
          <xsl:with-param name="module_name" select="@original_module"/>
          <xsl:with-param name="arm_mim" select="'arm'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="schema_name">
          <xsl:with-param name="module_name" select="../../../module/@name"/>
          <xsl:with-param name="arm_mim" select="'arm'"/>
        </xsl:call-template>        
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="ae_aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@entity"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="ae_xref">
    <xsl:choose>
      <!-- if original_module specified then the ARM object is declared in
           another module -->
      <!-- TEH except when it isnt - as in derived_geometry -->
      <xsl:when test="@original_module">
        <xsl:value-of 
          select="concat('../../',@original_module,'/sys/4_info_reqs',$FILE_EXT,'#',$ae_aname)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of 
          select="concat('./4_info_reqs',$FILE_EXT,'#',$ae_aname)"/>        
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="arm_entity" select="@entity"/>

  <xsl:variable name="module_dir">
    <xsl:choose>
      <!-- original_module specified then the ARM object is declared in
           another module -->
      <xsl:when test="@original_module">
        <xsl:call-template name="module_directory">
          <xsl:with-param name="module" select="@original_module"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="module_directory">
          <xsl:with-param name="module" select="../../../module/@name"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="module_ok">
    <xsl:choose>
      <!-- original_module specified then the ARM object is declared in
           another module -->
      <xsl:when test="@original_module">
        <xsl:call-template name="check_module_exists">
          <xsl:with-param name="module" select="@original_module"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="check_module_exists">
          <xsl:with-param name="module" select="../../../module/@name"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable> <!-- module_ok -->


  <xsl:variable name="arm_xml" select="concat($module_dir,'/arm.xml')"/>

  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <!-- No longer required to make ARM entity in upper case 
  <xsl:variable name="ae" select="translate(@entity,$LOWER,$UPPER)"/>
  -->
  <xsl:variable name="ae" select="@entity"/>

  <xsl:variable name="ae_map_aname">
    <xsl:apply-templates select="." mode="map_attr_aname"/>  
  </xsl:variable>

  <h2>
    <a name="{$ae_map_aname}">
      <xsl:value-of select="concat('5.1.',$sect_no,' ')"/>
    </a>
    <a href="{$ae_xref}">
      <xsl:value-of select="$ae"/>
    </a>
    <xsl:if test="$module_ok='true'">
      <xsl:variable name="entity_node"
        select="document($arm_xml)/express/schema/entity[@name=$arm_entity]"/>
      <!-- 
        Commented out as the current method of getting expressg link
        assumes that all entities etc are in same module 
      <xsl:apply-templates select="$entity_node" mode="expressg_icon">
        <xsl:with-param name="original_schema" select="$schema_name"/>
      </xsl:apply-templates> -->
    </xsl:if>
  </h2>
<!--  <xsl:apply-templates select="." mode="output_mapping"/> -->

  <!-- output any issues against the mapping -->
  <xsl:apply-templates select="."  mode="output_mapping_issue"/>

  <xsl:choose>
    <xsl:when test="$module_ok != 'true'">
      <xsl:call-template name="error_message">
        <xsl:with-param name="message"
          select="concat('Error m1a: The module specified in the
@original_module attribute (', @original_module,
                  ') does not exist in stepmod/repository_index.xml')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="not(document($arm_xml)/express/schema/entity[@name=$arm_entity])">
      <xsl:call-template name="error_message">
        <xsl:with-param name="message"
          select="concat('Error m1: The entity ', $arm_entity, 
                  ' does not exist in the arm (',$arm_xml,')')"/>
      </xsl:call-template>
    </xsl:when>
  </xsl:choose>
  
  <!-- original_module specified then the ARM object is declared in
       another module -->
  <xsl:if test="@original_module  and @original_module != $modname">
    <!-- get the URL of the mapping -->
    <xsl:variable name="map_xref"
      select="translate(concat('../../',@original_module,'/sys/5_mapping',$FILE_EXT,'#aeentity',@entity),$UPPER,$LOWER)"/>

    <p>
      This application object,  
      <a href="{$ae_xref}">
        <xsl:value-of select="@entity"/></a>, is defined in the module
      <a href="{$ae_xref}"><xsl:value-of select="@original_module"/></a>.
      This mapping section extends the 
      <a href="{$map_xref}"> mapping of <xsl:value-of select="@entity"/></a>,
      to include assertions defined in this module.  
    </p>
  </xsl:if>

  <xsl:if test="@extensible='YES'">
    This section specifies the mapping of the entity 
    <a href="{$ae_xref}"><xsl:value-of select="@entity"/></a>
    for the case where it maps onto the resource entity 
    <xsl:value-of select="./aimelt"/>.    
    Depending on the extensions of the Select

    <!-- not sure what is the most sensible approach here
         could explicitly list the selects in the xml or
         look at all the explicit attributes that have extensible
         selects. Gone for the latter approach
         -->
    <xsl:if test="$module_ok = 'true'">
      <xsl:variable name="selects">
        <xsl:apply-templates 
          select="document($arm_xml)/express/schema/entity[@name=$arm_entity]/explicit"
          mode="output_extensible_attributes"/>
      </xsl:variable>
      <xsl:variable name="nselects">
        <xsl:call-template name="remove_duplicates">
          <xsl:with-param name="list" select="$selects"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="contains($nselects,' ')">
          types 
        </xsl:when>
        <xsl:otherwise>
          type 
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="translate($nselects,': ',', ')"/>
    </xsl:if>
    this mapping may be superseded in the application modules that define these extensions. 
  </xsl:if>

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
    <xsl:sort select="./@assertion_to"/>
    <xsl:sort select="./@attribute"/>
  </xsl:apply-templates>
</xsl:template>


<xsl:template match="explicit" mode="output_extensible_attributes">
  <xsl:variable name="attr_select" select="typename/@name"/>
  <xsl:variable name="ext_select"
    select="../../type[@name=$attr_select]/select[@extensible='YES']/../@name"/>
  <xsl:if test="$ext_select">
    <xsl:value-of select="concat($ext_select,': ')"/>
  </xsl:if>
</xsl:template>


<xsl:template match="aa" mode="specification">
  <xsl:param name="sect"/>

  <xsl:variable name="schema_name">
    <xsl:choose>
      <!-- original_module specified then the ARM object is declared in
           another module -->
      <xsl:when test="../@original_module">
        <xsl:value-of select="concat(../@original_module,'_arm')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat(../../../../module/@name,'_arm')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="attr">
    <!-- the attribute may be redeclared i.e. SELF\product.of_product -->
    <xsl:call-template name="get_last_section">
      <xsl:with-param name="path" select="@attribute"/>
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:variable name="aa_aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="../@entity"/>
      <xsl:with-param name="section3" select="$attr"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- attribute Xref -->
  <xsl:variable name="aa_xref">
    <xsl:choose>
      <!-- original_module specified then the ARM object is declared in
           another module -->
      <xsl:when test="../@original_module">
        <xsl:value-of 
          select="concat('../../',../@original_module,'/sys/4_info_reqs',$FILE_EXT,'#',$aa_aname)"/>

      </xsl:when>
      <!-- inherited_from_module specified then the ARM attribute is
           declared in another module -->
      <xsl:when test="@inherited_from_module">
        <xsl:variable name="aa_inh_aname">
          <xsl:call-template name="express_a_name">
            <xsl:with-param name="section1" select="concat(@inherited_from_module,'_arm')"/>
            <xsl:with-param name="section2" select="@inherited_from_entity"/>
            <xsl:with-param name="section3" select="$attr"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:value-of 
          select="concat('../../',@inherited_from_module,'/sys/4_info_reqs',$FILE_EXT,'#',$aa_inh_aname)"/>

      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('./4_info_reqs',$FILE_EXT,'#',$aa_aname)"/>        
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="module_dir">
    <xsl:choose>
      <!-- inherited_from_module specified then the ARM object is declared in
           another module -->
      <xsl:when test="@inherited_from_module">
        <xsl:call-template name="module_directory">
          <xsl:with-param name="module" select="@inherited_from_module"/>
        </xsl:call-template>
      </xsl:when>
      <!-- original_module specified then the ARM object is declared in
           another module -->
      <xsl:when test="../@original_module">
        <xsl:call-template name="module_directory">
          <xsl:with-param name="module" select="../@original_module"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="../../../../module/@name"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="arm_xml" select="concat($module_dir,'/arm.xml')"/>

  <xsl:variable name="sect_no" select="concat($sect,'.',position())"/>

  <xsl:variable name="arm_entity" select="string(../@entity)"/>
  <xsl:variable name="arm_attr" select="string(@attribute)"/>

  <xsl:variable name="module_aok">
    <xsl:choose>
      <!-- inherited_from_module specified then the ARM object is declared in
           another module -->
      <xsl:when test="@inherited_from_module">
        <xsl:call-template name="check_module_exists">
          <xsl:with-param name="module" select="@inherited_from_module"/>
        </xsl:call-template>
      </xsl:when>
      <!-- original_module specified then the ARM object is declared in
           another module -->
      <xsl:when test="../@original_module">
        <xsl:call-template name="check_module_exists">
          <xsl:with-param name="module" select="../@original_module"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="check_module_exists">
          <xsl:with-param name="module" select="../../../../module/@name"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable> <!-- module_aok -->

  


  <h2>
    <xsl:apply-templates select="." mode="map_attr_aname_output"/>  
    <xsl:choose>
      <xsl:when test="@assertion_to">
        
        <xsl:variable name="ae_aname">
          <xsl:call-template name="express_a_name">
            <xsl:with-param name="section1" select="$schema_name"/>
            <xsl:with-param name="section2" select="../@entity"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="ae_xref">
          <xsl:choose>
            <!-- if original_module specified then the ARM object is
                 declared in another module -->
            <xsl:when test="../@original_module">
              <xsl:value-of 
                select="concat('../../',../@original_module,'/sys/4_info_reqs',$FILE_EXT,'#',$ae_aname)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of 
                select="concat('./4_info_reqs',$FILE_EXT,'#',$ae_aname)"/>        
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:value-of select="concat($sect_no,' ')"/>
        <a href="{$ae_xref}"><xsl:value-of select="../@entity"/></a>
        to <xsl:call-template name="link_object">
        <xsl:with-param name="object_name" select="@assertion_to"/>
        <xsl:with-param name="object_used_in_schema_name" 
          select="$schema_name"/>
        <xsl:with-param name="clause" select="'section'"/>
      </xsl:call-template>
      <!-- <xsl:value-of select="@assertion_to"/> -->
        (as <a href="{$aa_xref}"><xsl:value-of select="@attribute"/></a>)
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat($sect_no,' ')"/>
        <a href="{$aa_xref}"><xsl:value-of select="@attribute"/></a>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:if test="$module_aok='true'">
      <xsl:variable name="ae" select="../@entity"/>
      <xsl:variable name="entity_node"
        select="document($arm_xml)/express/schema/entity[@name=$ae]"/>      
      <!-- 
        Commented out as the current method of getting expressg link
        assumes that all entities etc are in same module 
      <xsl:apply-templates select="$entity_node" mode="expressg_icon">
        <xsl:with-param name="original_schema" select="$schema_name"/>
      </xsl:apply-templates> -->
    </xsl:if>
  </h2>

  <!-- output any issues against the mapping -->
  <xsl:apply-templates select="."  mode="output_mapping_issue"/>

  <xsl:if test="$module_aok='true'">
    <xsl:apply-templates select="." mode="check_valid_attribute"/>
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
      'Warning use of &lt;alt&gt; is deprecated. Use &lt;alt_map&gt; instead'
    </xsl:with-param>
  </xsl:call-template>
  <xsl:call-template name="output_string_with_linebreaks">
    <xsl:with-param name="string" select="string(.)"/>
  </xsl:call-template>
  <br/>
</xsl:template>

<xsl:template match="aimelt" mode="specification">
  <tr valign="top">
    <td>MIM element:</td>
    <td>
      <xsl:variable name="aimelt_string">
        <xsl:call-template name="remove_start_end_whitespace">
          <xsl:with-param name="string" select="string(.)"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:call-template name="output_string_with_linebreaks">
        <xsl:with-param name="string" select="$aimelt_string"/>
      </xsl:call-template>
    </td>
  </tr>
</xsl:template>


<xsl:template match="source" mode="specification">
  <xsl:variable name="str">
    <xsl:call-template name="remove_start_end_whitespace">
      <xsl:with-param name="string" select="string(.)"/>
    </xsl:call-template>
  </xsl:variable> 
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


<xsl:template match="refpath_extend" mode="specification">
  <xsl:variable name="ae" select="ancestor::ae/@entity"/>
  <xsl:variable name="orig_mod" select="ancestor::ae/@original_module"/>

  <xsl:if test="not(string-length(normalize-space(.)) > 3 )" >
      <xsl:call-template name="error_message">
        <xsl:with-param name="message"
          select="concat('Error refpath_ext5: No extension to reference path specified in refpath_extend for entity ',
	  			$ae,' ',ancestor::aa/@attribute,' assertion to ',ancestor::aa/@assertion_to)"/>
      </xsl:call-template>

  </xsl:if>

  <xsl:choose>
    <xsl:when test="ancestor::ae/@original_module">
      <!-- if there has been an external module declared, then get the 
           alt_map descriptions from there -->
      <xsl:variable name="module_dir">
        <xsl:call-template name="module_directory">
          <xsl:with-param name="module" select="$orig_mod"/>
        </xsl:call-template>
      </xsl:variable>
      
      <xsl:variable name="module_ok">
        <xsl:choose>
          <!-- original_module specified then the ARM object is declared in
               another module -->
          <xsl:when test="$orig_mod">
            <xsl:call-template name="check_module_exists">
              <xsl:with-param name="module" select="$orig_mod"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            false
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable> <!-- module_ok -->

      <xsl:choose>
        <xsl:when test="$module_ok != 'true'">
          <xsl:call-template name="error_message">
            <xsl:with-param name="message"
              select="concat('Error refpath_ext2: The module specified in the
                      @original_module attribute (', $orig_mod,') does not exist in stepmod/repository_index.xml')"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>

          <!-- get the refpath from the mapped attribute of the original module and extend -->          
          <xsl:variable name="refpath">
            <xsl:choose>
              <xsl:when test="name(..)='alt_map'">
		<!-- if there exists an alt map in the original module, 
		     the refpath in the original module must be in the same
                    alternative 
		    
		    Note that where there are alternatives at both the original and the using case:
		    do not use refpath extension, supply a full path
		    -->
                <xsl:variable name="extended_select" select="./@extended_select"/>
       	        <xsl:variable name="attribute" select="../../@attribute"/>
               	<xsl:variable name="alt_id" select="../@alt_map.inc"/>
		     <xsl:choose>
			<xsl:when test="document(concat($module_dir,'/module.xml'))/module/mapping_table/ae[@entity=$ae]/aa[@attribute=$attribute and @assertion_to=$extended_select]/alt_map" >
		                <xsl:value-of
        		          select="document(concat($module_dir,'/module.xml'))/module/mapping_table/ae[@entity=$ae]/aa[@attribute=$attribute and @assertion_to=$extended_select]/alt_map[@alt_map.inc=$alt_id]/refpath"/>	
			</xsl:when>			     
			<xsl:otherwise>
		                <xsl:value-of 
                		  select="document(concat($module_dir,'/module.xml'))/module/mapping_table/ae[@entity=$ae]/aa[@attribute=$attribute and @assertion_to=$extended_select]/refpath"/>
			</xsl:otherwise>
		      </xsl:choose>
              </xsl:when>

              <xsl:otherwise>
                <xsl:variable name="extended_select" select="./@extended_select"/>
                <xsl:variable name="attribute" select="../@attribute"/>
                <xsl:value-of 
                  select="document(concat($module_dir,'/module.xml'))/module/mapping_table/ae[@entity=$ae]/aa[@attribute=$attribute and @assertion_to=$extended_select]/refpath"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <xsl:if test="string-length($refpath)=0">
            <tr valign="top">
              <td></td>
              <td>
                <xsl:variable name="msg">
                  <xsl:choose>
                    <xsl:when test="./../@inherited_from_module"></xsl:when>
                    
                    <xsl:when test="name(..)='alt_map'">
                      <xsl:variable name="extended_select" select="./@extended_select"/>
                      <xsl:variable name="attribute" select="../../@attribute"/>
                      <xsl:variable name="alt_id" select="../@alt_map.inc"/>
                      <xsl:value-of 
                        select="concat('Error refpath_ext41: The refpath to be extended can not be found in the module: &quot;',
                                $orig_mod,'&quot;. #  Check that the entity  &quot;',$ae,'&quot; exists in  &quot;',$orig_mod,
                                '&quot;#  and has an attribute &quot;',$attribute,
                                '&quot;, #  that there is an assertion to &quot;',$extended_select,
                                ' &quot;#  and that the there is an alt_map &quot;alt_map.inc=',$alt_id,'&quot;')"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:variable name="extended_select" select="./@extended_select"/>
                      <xsl:variable name="attribute" select="../@attribute"/>
                      <xsl:value-of 
                        select="concat('Error refpath_ext42: The refpath to be extended can not be found in the module: &quot;',
 $orig_mod,'&quot;. #  Check that the entity &quot;',$ae,'&quot; exists in &quot;',$orig_mod,
                                '&quot;#  and has an attribute  &quot;',$attribute,
                                '&quot;#  and there is an assertion to &quot;',$extended_select,'&quot;')"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:if test="string-length($msg)>0">
                  <xsl:call-template name="error_message">
                  <xsl:with-param name="message" select="$msg"/>
                </xsl:call-template>
                </xsl:if>
                
              </td>
            </tr>
          </xsl:if>

              
          <xsl:variable name="refpath1">
            <xsl:call-template name="remove_start_end_whitespace">
              <xsl:with-param name="string" select="$refpath"/>
            </xsl:call-template>
          </xsl:variable>

          <xsl:variable name="refpath_extend">
            <xsl:call-template name="remove_start_end_whitespace">
              <xsl:with-param name="string" select="string(.)"/>
            </xsl:call-template>
          </xsl:variable>

          <!-- the refpath may be an alternative path in which case it will
               end in )
               So test for ) and insert refpath_extend before ) -->
          <xsl:variable name="refpath_extend1">
            <xsl:choose>
              <xsl:when test="substring($refpath1,string-length($refpath1))=')'">
                <xsl:value-of
                  select="concat(substring($refpath1,1,string-length($refpath1)-1),'&#xA;',$refpath_extend,')')"/>
              </xsl:when>
              <xsl:otherwise>
                <!-- if the refpath_extend does not start with * then add
                     new line, otherwise continue on same line -->
                <xsl:choose>
                  <xsl:when test="starts-with($refpath_extend,'*>')">
                    <xsl:value-of select="concat($refpath1,'&#160;',$refpath_extend)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="concat($refpath1,'&#xA;',$refpath_extend)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>            
          </xsl:variable>


          <xsl:if test="string-length($refpath_extend1)>0">
            <tr valign="top">
              <td>Reference path:&#160;&#160;</td>

              <!--
                   <xsl:apply-templates select="$refpath" mode="check_ref_path"/>
                   -->

              <xsl:apply-templates select="." mode="check_ref_path"/>

              <td>
                <xsl:call-template name="output_string_with_linebreaks">
                  <xsl:with-param name="string" select="$refpath_extend1"/>
                </xsl:call-template>
              </td>
            </tr>
          </xsl:if>

        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="msg"
        select="concat('Error refpath_extend_1: No original_module specified in ',$ae)"/>
      <xsl:call-template name="error_message">
        <xsl:with-param name="message">
          <xsl:value-of select="$msg"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="refpath" mode="specification">
  <xsl:variable name="str">
    <xsl:call-template name="remove_trailing_whitespace">
      <xsl:with-param name="string" select="string(.)"/>
    </xsl:call-template>
  </xsl:variable>

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
      <xsl:value-of select="concat('#',@id,':&#160;&#160;&#160;')"/>
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
        <xsl:when test="../../@original_module">
          <!-- if there has been an external module declared, then get the 
               alt_map descriptions from there -->
          <xsl:variable name="ae" select="../../@entity"/>
          <xsl:variable name="module_dir">
            <xsl:call-template name="module_directory">
              <xsl:with-param name="module" select="../../@original_module"/>
            </xsl:call-template>
          </xsl:variable>
          
          <xsl:variable name="module_ok">
            <xsl:choose>
              <!-- original_module specified then the ARM object is declared in
                   another module -->
              <xsl:when test="../../@original_module">
                <xsl:call-template name="check_module_exists">
                  <xsl:with-param name="module" select="../../@original_module"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="check_module_exists">
                  <xsl:with-param name="module" select="../../../module/@name"/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable> <!-- module_ok -->

          <xsl:choose>
            <xsl:when test="$module_ok != 'true'">
              <xsl:call-template name="error_message">
                <xsl:with-param name="message"
                  select="concat('Error refpath_ext3: The module specified in the
                          @original_module attribute (', ../../@original_module,') does not exist in stepmod/repository_index.xml')"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <!-- get the alt_map description from the original module -->
              <xsl:variable name="alt_description"
                select="document(concat($module_dir,'/module.xml'))/module/mapping_table/ae[@entity=$ae]/alt_map[@id=$dsc.id]"/>
              <xsl:if test="$alt_description">
                <xsl:apply-templates select="$alt_description" mode="output_id_description"/>              
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
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

<xsl:template match="ae|aa|sc" mode="output_id_description">
  <p/>
	<xsl:apply-templates select="./description"/>
	<p/>
</xsl:template>


<!-- This is the main template to output the mapping specification -->
<xsl:template match="ae|aa|alt_map" mode="output_mapping">
  <xsl:apply-templates select="." mode="output_id_description"/>
  <!-- only output a table if it will be populated -->
  <xsl:if test="./aimelt or ./source or ./rules or ./refpath or ./refpath_extend">
    <table>
      <xsl:apply-templates select="./aimelt"  mode="specification"/>
      <xsl:apply-templates select="./source"  mode="specification"/>
      <xsl:apply-templates select="./rules"  mode="specification"/>
      <xsl:apply-templates select="./refpath"  mode="specification"/>
      <xsl:apply-templates select="./refpath_extend"  mode="specification"/>
    </table>  
  </xsl:if>
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


<!-- give the A NAME for the mapping of the subtype constraint in sect 5 -->
<xsl:template match="sc" mode="map_attr_aname">
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>
  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:value-of select="translate(concat('scconstraint',@constraint),$UPPER,$LOWER)"/>
</xsl:template>


<!-- give the A NAME for the mapping of the entity in sect 5 -->
<xsl:template match="ae" mode="map_attr_aname">
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>
  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:value-of select="translate(concat('aeentity',@entity),$UPPER,$LOWER)"/>
</xsl:template>

<!-- give the A NAME for the mapping of the entity attribute in sect 5 -->
<xsl:template match="aa" mode="map_attr_aname_output">
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ\'"/>

  <xsl:variable name="attr">
    <xsl:choose>
      <xsl:when test="@assertion_to">
        <xsl:value-of
          select="translate(concat('aeentity',../@entity,'aaattribute',@attribute,'assertion_to',@assertion_to),$UPPER,$LOWER)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of
          select="translate(concat('aeentity',../@entity,'aaattribute',@attribute),$UPPER,$LOWER)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- need to put in whitespace to make HREF work in IExplorer -->
  <a name="{$attr}"> </a>

  <!-- cater for the fact that the assertion may be written as:
       aa attribute="SELF\Applied_activity_assignment.assigned_activity"
       or
       aa attribute="assigned_activity" 
       so output both anchours for both
       -->
  <xsl:if test="starts-with(translate(@attribute,$UPPER,$LOWER),'self\')">
    <xsl:variable name="redcl_attr">
      <!-- the attribute may be redeclared i.e. SELF\product.of_product -->
      <xsl:call-template name="get_last_section">
        <xsl:with-param name="path" select="@attribute"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="attr1">
      <xsl:choose>
        <xsl:when test="@assertion_to">
          <xsl:value-of
            select="translate(concat('aeentity',../@entity,'aaattribute',$redcl_attr,'assertion_to',@assertion_to),$UPPER,$LOWER)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of
            select="translate(concat('aeentity',../@entity,'aaattribute',$redcl_attr),$UPPER,$LOWER)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- need to put in whitespace to make HREF work in IExplorer -->
    <a name="{$attr1}"> </a>
  </xsl:if>  
</xsl:template>

<!-- TEH added to support mapping of subtype constraints -->

<xsl:template match="sc" mode="specification">
  <xsl:variable name="sect_no"><xsl:number/>
  </xsl:variable>

  <xsl:variable name="schema_name">
    <xsl:choose>
      <!-- original_module specified then the ARM object is declared in another module -->
      <xsl:when test="../@original_module">
        <xsl:call-template name="schema_name">
          <xsl:with-param name="module_name" select="@original_module"/>
          <xsl:with-param name="arm_mim" select="'arm'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="schema_name">
          <xsl:with-param name="module_name" select="../../../module/@name"/>
          <xsl:with-param name="arm_mim" select="'arm'"/>
        </xsl:call-template>        
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="sc_aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@constraint"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="sc_xref">
    <xsl:choose>
      <!-- if original_module specified then the ARM object is declared in another module -->
      <xsl:when test="@original_module">
        <xsl:value-of 
          select="concat('../../',@original_module,'/sys/4_info_reqs',$FILE_EXT,'#',$sc_aname)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of 
          select="concat('./4_info_reqs',$FILE_EXT,'#',$sc_aname)"/>        
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


  <xsl:variable name="module_dir">
    <xsl:choose>
      <!-- original_module specified then the ARM object is declared in another module -->
      <xsl:when test="@original_module">
        <xsl:call-template name="module_directory">
          <xsl:with-param name="module" select="@original_module"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="module_directory">
          <xsl:with-param name="module" select="../../../module/@name"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="module_ok">
    <xsl:choose>
      <!-- original_module specified then the ARM object is declared in another module -->
      <xsl:when test="@original_module">
        <xsl:call-template name="check_module_exists">
          <xsl:with-param name="module" select="@original_module"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="check_module_exists">
          <xsl:with-param name="module" select="../../../module/@name"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable> <!-- module_ok -->

  <xsl:variable name="arm_xml" select="concat($module_dir,'/arm.xml')"/>
  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>

  <xsl:variable name="sc" select="@constraint"/>
  <xsl:variable name="arm_constraint"  select="string(@constraint)"/>

  <xsl:variable name="sc_map_aname">
    <xsl:apply-templates select="." mode="map_attr_aname"/>  
  </xsl:variable>

  <xsl:variable name="sc_count" select="count(//sc)" />
  <xsl:variable name="ae_count" select="count(//ae)" />
  <h2>
    <a name="{$sc_map_aname}">
      <xsl:value-of select="concat('5.1.',$ae_count+position(),' ')"/>
    </a>
    <a href="{$sc_xref}"><xsl:value-of select="$sc"/></a>
  </h2>

  <!-- output any issues against the mapping -->
  <!-- commmented out below because it is not found 
  <xsl:apply-templates select="."  mode="output_mapping_issue"/>
-->
  <xsl:choose>
    <xsl:when test="$module_ok != 'true'">
      <xsl:call-template name="error_message">
        <xsl:with-param name="message"
          select="concat('Error m1a: The module specified in the
@original_module attribute (', @original_module,') does not exist in stepmod/repository_index.xml')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="not(document($arm_xml)/express/schema/subtype.constraint[@name=$arm_constraint])">
      <xsl:call-template name="error_message">
        <xsl:with-param name="message"
          select="concat('Error m1: The subtype constraint ', $arm_constraint, 
                  ' does not exist in the arm (',$arm_xml,')')"/>
      </xsl:call-template>
    </xsl:when>
  </xsl:choose>
  
  <!-- original_module specified then the ARM object is declared in another module -->
  <xsl:if test="@original_module">

    <!-- get the URL of the mapping -->
    <xsl:variable name="map_xref"
      select="translate(concat('../../',@original_module,'/sys/5_mapping',$FILE_EXT,'#scconstraint',@constraint),$UPPER,$LOWER)"/>

    <p>The subtype constraint 
      <a href="{$sc_xref}"><xsl:value-of select="@constraint"/></a> is defined in the module
      <a href="{$sc_xref}"><xsl:value-of select="@original_module"/></a>.
    </p>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="./alt_scmap">
      <!-- can either have a set of alternatives or one mapping -->
      <xsl:apply-templates select="./alt_scmap" mode="output_mapping"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="." mode="output_mapping"/>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<!-- This is the main template to output the mapping specification -->
<xsl:template match="sc|alt_scmap" mode="output_mapping">
  <xsl:apply-templates select="." mode="output_id_description"/>
  <table>
    <xsl:apply-templates select="./rules"  mode="specification"/>
    <xsl:apply-templates select="./constraint"  mode="specification"/>
    <xsl:apply-templates select="./source"  mode="specification"/>
  </table>  
</xsl:template>

<xsl:template match="constraint" mode="specification">
  <tr valign="top">
    <td>Constraint:</td>
    <td>
      <xsl:call-template name="output_string_with_linebreaks">
        <xsl:with-param name="string" select="string(.)"/>
      </xsl:call-template>
    </td>
  </tr>
</xsl:template>

<!-- end of added to support mapping of subtype constraints -->

</xsl:stylesheet>
