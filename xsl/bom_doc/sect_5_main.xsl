<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_5_main.xsl,v 1.6 2014/05/08 13:44:37 nigelshaw Exp $
  Author:  Mike Ward, Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: Display the main set of frames for an AP document.     
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="business_object_model.xsl"/>
  <xsl:import href="business_object_model_clause_nofooter.xsl"/>

  <xsl:output method="html"/>
	


  <xsl:template match="business_object_model">

    <xsl:variable name="model" select="@name"/>
    <xsl:variable name="model_title" select="@title"/>
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

    <xsl:variable name="armref" select="concat('../../../modules/',@ap_name,'/sys/4_info_reqs',$FILE_EXT)" />

    <!--<xsl:call-template name="clause_header">
      <xsl:with-param name="heading" select="'5 Business object model mapping'"/>
      <xsl:with-param name="aname" select="'bom'"/>
    </xsl:call-template>-->
    <h1>
      <a name="mappings">5 Business object model mapping</a>
    </h1>
    
    

    <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
    <xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz'"/>

   
    <h2>
      5.1 Mapping specification
    </h2>
    
    <p>
      The mapping from the Business Object Model to the Application Reference Model is defined here. 
    </p>
    <!--<a name="mappings"/>-->

    <xsl:call-template name="bom_mapping_syntax">
	    <xsl:with-param name="armref" select="$armref" />
    </xsl:call-template>



    <!--
	Approach is as follows:
	1)	Read the bom.xml file into a global variable - bom_xml
	2)	Check that each item in the bom file has a mapping - if not present an error message
	3)	Present each mapping
	4) 	Check that the  items referenced in each mapping exist

	The (4) check will require looking at all the ARM items. Assume that arm.xml as defined for the AP is adequate 
	and that all mappings will refer to those items. Hence read the ARM (LONG FORM for now)into a global variable too - arm_xml

    -->

          <xsl:variable name="module_dir">
            <xsl:call-template name="bom_directory">
              <xsl:with-param name="module" select="$model"/>
            </xsl:call-template>
          </xsl:variable>
          
	  <xsl:variable name="bom_xml_file" select="concat($module_dir,'/bom.xml')"/>

	  <xsl:variable name="bom_xml" select="document($bom_xml_file)"/>

          <xsl:variable name="ap_module_dir">
            <xsl:call-template name="ap_module_directory">
		    <xsl:with-param name="application_protocol" select="./@ap_name"/>
            </xsl:call-template>
          </xsl:variable>

          <xsl:variable name="arm_xml_file" select="concat($ap_module_dir,'/arm_lf.xml')"/>

	  <xsl:variable name="arm_xml" select="document($arm_xml_file)"/>

	  <xsl:variable name="be_nodes" select="./mapping_table/be"/>

	  <!-- for each entity type in the BOM check for a mapping -->
		
	  <xsl:for-each select="$bom_xml/express/schema/entity" >
		  <xsl:variable name="entity" select="@name"/>
		  <xsl:variable name="be_node" select="$be_nodes[@entity=$entity]"/>
    		  <xsl:variable name="ba_nodes" select="$be_node/ba"/>

		  <xsl:variable name="sect_no">
		    <xsl:number/>
		  </xsl:variable>

		  <xsl:variable name="be_xref">
			  <xsl:value-of select="concat('./4_info_reqs',$FILE_EXT,'#',../@name,'.',translate($entity,$UPPER,$lower))"/>        
		  </xsl:variable>

		  <xsl:variable name="be_map_aname">
			  <xsl:apply-templates select="$be_node" mode="map_attr_aname"/>  
		  </xsl:variable>

		  <h2>
		    <a name="{$be_map_aname}">
		      <xsl:value-of select="concat('5.1.',$sect_no,' ')"/>
		    </a>
		    <a href="{$be_xref}">
		      <xsl:value-of select="$entity"/>
		    </a>
		  </h2>


		<xsl:choose>
		  <xsl:when test="not($be_node/*)">
		        <xsl:call-template name="error_message">
		          <xsl:with-param name="message" 
		            select="concat('Error mc5: the entity ',$entity,' has not been mapped.')"/>
		        </xsl:call-template>    
		  </xsl:when>
		  <xsl:otherwise>
		   <!-- present the mapping -->

		<xsl:apply-templates select="$be_node" mode="output_mapping" />

		   <!-- check that all the attributes have been mapped -->      
		   <xsl:for-each select="./explicit">
			   <xsl:variable name="bom_attr" select="@name"/>            
			  <xsl:variable name="attr_no">
			    <xsl:number/>
			  </xsl:variable>
			  <!--
			  <xsl:variable name="attr_link" select="concat($be_map_aname,'.',translate($bom_attr,$UPPER,$lower))" />
			  <xsl:variable name="attr_xref" select="concat($be_xref,'.',translate($bom_attr,$UPPER,$lower))" />
		<xsl:if test="not($ba_nodes[@assertion_to])" >	
		  <h2>
		    <a name="{$attr_link}">
		      <xsl:value-of select="concat('5.1.',$sect_no,'.',position(),' ')"/>
		    </a>
		    <a href="{$attr_xref}">
		      <xsl:value-of select="concat($entity,'.',$bom_attr)"/>
		    </a>
	    	  </h2>
	        </xsl:if>
		-->

		  <xsl:choose>
        	      <xsl:when test="not($ba_nodes[@attribute=$bom_attr])">
                	<xsl:call-template name="error_message">
	                  <xsl:with-param name="message" 
	                    select="concat('Error mc6: the attribute ',
        	                    $entity,'.',$bom_attr,
                	            ' has not been mapped.')"/>
	                </xsl:call-template> 
        	      </xsl:when>
              	      <xsl:otherwise>
                        <!-- if the attribute is an extensible select, then you need a
			mapping to the select 
			-->
        	        <xsl:variable name="attr"
	                  select="$ba_nodes[@attribute=$bom_attr]"/>
	                <xsl:variable name="typename" select="./typename/@name"/>
	                <!-- attribute is referencing an extensible select so there must be a mapping -->
	                <xsl:if test="$bom_xml/express/schema/type[@name=$typename]/select[@extensible='YES']">
	                  <xsl:if test="not($ba_nodes[@attribute=$bom_attr and @assertion_to=$typename])">
        	            <xsl:call-template name="error_message">
                	      <xsl:with-param name="message" 
	                        select="concat('Error mc7: the attribute ',
        	                        $entity,'.',$bom_attr,
                	                ' has not been mapped to the extended select ',$typename )"/>
	                    </xsl:call-template> 
        	          </xsl:if>
	                </xsl:if>
        	      </xsl:otherwise>
	            </xsl:choose>

	           </xsl:for-each>
		    <!-- NSW: missing specification layer of templates - see stepmod/xsl/sect_5_mapping.xsl line 678 and onwards -->

		    <xsl:apply-templates select="$ba_nodes" mode="specification" >
			    <xsl:sort select="concat(@attribute,'   ',@assertion_to)" />
			    <xsl:with-param name="schema" select="../../@name" />
			    <xsl:with-param name="entity" select="$entity" />
			    <!--<xsl:with-param name="sect" select="concat('5.1.',$sect_no,'.',$attr_no)" /> -->
			    <xsl:with-param name="sect" select="concat('5.1.',$sect_no)" />
			    <xsl:with-param name="e_xref" select="$be_xref" />
			    <xsl:with-param name="attr_link" select="concat($be_map_aname,'.',translate(@attribute,$UPPER,$lower))" />
		    </xsl:apply-templates>

		    <!--			<xsl:apply-templates select="$ba_nodes[@attribute=$bom_attr]" mode="output_mapping" /> -->
	   </xsl:otherwise>
	</xsl:choose>

	  </xsl:for-each>


  </xsl:template>


  <xsl:template match="ba" mode="specification">
	  <xsl:param name="schema"/>
	  <xsl:param name="entity"/>
	  <xsl:param name="sect"/>
	  <xsl:param name="e_xref"/>
	  <xsl:param name="attr_link"/>

    <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
    <xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz'"/>
    
    <xsl:variable name="attr_xref" select="concat($e_xref,'.',translate(@attribute,$UPPER,$lower))" />
	  
	<xsl:variable name="assert_no">
	    <xsl:number value="position()" />
	</xsl:variable>

	<xsl:choose>
		<xsl:when test="@assertion_to" >

		  <xsl:variable name="assert_xref">
			  <xsl:value-of select="concat('./4_info_reqs',$FILE_EXT,'#',translate(concat($schema,'.',@assertion_to),$UPPER,$lower))"/>        
		  </xsl:variable>

		  <h2>
			  <!--		    <a name="{$assert_link}"> -->
		      <xsl:value-of select="concat($sect,'.',$assert_no,' ')"/>
		      <!-- </a> --> 
		    <a href="{$e_xref}">
			    <xsl:value-of select="$entity"/>
		    </a>
		    to 
		    <a href="{$assert_xref}" >
			    <xsl:value-of select="@assertion_to"/>
		    </a>
		    ( as <a href="{$attr_xref}">
			    <xsl:value-of select="@attribute"/><xsl:value-of select="@position"/>
		    </a> )
		  </h2>
		</xsl:when>
		<xsl:otherwise>	
		  <h2>
		    <a name="{$attr_link}">
		      <xsl:value-of select="concat($sect,'.',position(),' ')"/>
		    </a>
		    <a href="{$attr_xref}">
		      <xsl:value-of select="concat($entity,'.',@attribute)"/>
		    </a>
	    	  </h2>
	        </xsl:otherwise>
	</xsl:choose>

	  	  <xsl:apply-templates select="." mode="output_mapping" /> 

  </xsl:template>
  


  <xsl:template name="ap_module_directory">
    <xsl:param name="application_protocol"/>
    <xsl:variable name="mod_dir">
      <xsl:call-template name="module_name">
        <xsl:with-param name="module" select="$application_protocol"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="concat('../../data/modules/', $mod_dir)"/>
  </xsl:template>

  <xsl:template name="bom_directory">
    <xsl:param name="module"/>
    <xsl:variable name="mod_dir">
      <xsl:call-template name="module_name">
        <xsl:with-param name="module" select="$module"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="concat('../../data/business_object_models/',$mod_dir)"/>
  </xsl:template>

<xsl:template name="bom_mapping_syntax">
  <xsl:param name="armref" />	
  <xsl:variable name="sect4" 
    select="concat('4_info_reqs',$FILE_EXT)"/>

  <!-- boiler plate text for business object model mapping syntax -->
  <p>
    In the following, &quot;Business element&quot; designates any entity data
    type defined in Clause <a href="{$sect4}">4</a>, any of its 
    explicit attributes and any subtype constraint. 
    &quot;ARM element&quot; designates any entity data type defined in the 
    <!-- Clause <a href="{$sect52}">5.2</a> -->
    <a href="{$armref}">Application Reference Model</a> specified in ISO 10303-<xsl:value-of select="@ap.module.number"/>.
    <!--    or imported with a USE FROM
    statement, from another EXPRESS schema, any of its 
    attributes and any subtype constraint defined in Clause <a href="{$sect52}">5.2</a> or imported with a USE FROM
    statement. -->
  </p>
  <p>
    This clause contains the mapping specification that defines how each 
    business element of this part of ISO 10303 (see Clause <a href="{$sect4}">4</a>) maps to one
    or more ARM elements<!-- (see Clause <a href="{$sect52}">5.2</a>) -->.
  </p>

  <p>
The mapping for each business element is specified in a separate subclause below. 
The mapping specification of an attribute of a business element is a subclause of the clause that contains the mapping specification of this element.
    Each mapping specification subclause contains up to five elements.
  </p>
  <p>
    <b>Title:</b>
The clause title contains:</p>
<ul>
	<li>the name of the considered business element<!-- entity or subtype constraint, or --></li>
<li>the name of the considered ARM entity atribute when this attribute refers to a type that is not an entity data type or a SELECT type that contains or may contain entity data types, or</li>
<li>a composite expression, &lt;attribute name&gt; to &lt;referred type&gt;, when this attribute refers to a type that is not an entity data type or a SELECT type that contains or may contain entity data types.</li>
</ul>


  <p>
    <b>ARM element:</b> 
    This section contains, depending on the considered business element:</p>
		<ul>
<li>the name of one or more ARM entity data types;</li>
		<li>the name of a ARM entity attribute, presented with the syntax &lt;entity name&gt;.&lt;attribute name&gt;, when the considered business attribute refers to a type that is not an entity data type or a SELECT type that contains or may contain entity data types;</li>
		<li>the term PATH, when the considered business entity attribute refers to an entity data type or to a SELECT type that contains or may contain entity data types;</li>
		<li>the term IDENTICAL MAPPING, when both application objects
    involved in an application assertion map to the same instance of a MIM entity data type;</li>
		<li>the syntax /SUPERTYPE(&lt;supertype name&gt;)/, when the considered business element is mapped as its supertype;</li>
		<li>one or more constructs /SUBTYPE(&lt;subtype name&gt;)/, when the mapping of the considered business element is the union of the mapping of its subtypes.</li>
		</ul>
		<p>
When the mapping of a business element involves more than one ARM element, each of these ARM elements is 
    presented on a separate line in the mapping specification, enclosed between parentheses or brackets. 
</p>
  <p>
    <b>Source:</b> This section contains:the ISO standard number and
    part number of this part of ISO 10303, for those ARM elements that are defined in the ARM schema of this part.
    </p>
    <p>
	This section is omitted when the keywords PATH or IDENTICAL MAPPING are used in the ARM element section.
  </p> 
  <p>
    <b>Rules:</b> 
    This section contains the name of one or more global rules that apply to the
    population of the ARM entity data types listed in the ARM element section or
    in the reference path. When no rule applies, this section is omitted.
		</p>
		<p>A reference to a
    global rule may be followed by a reference to the subclause in
    which the rule is defined.
  </p> 
  <p>
    <b>Constraint:</b> 
    This section contains the name of one or more subtype constraints that apply to the
    population of the ARM entity data types listed in the ARM element section or
    in the reference path. When no subtype constraint applies, this section is omitted.
  </p>
  <p>
    A reference to a subtype constraint may be followed by a reference to the subclause in
    which the subtype constraint is defined.
  </p> 

  <p>
	  <b>Reference path:</b> This section contains the specification of the relationships between ARM elements, 
	  when the mapping of a business element requires to relate instances of several 
	 ARM entity data types. In such a case, each line in the reference path
    documents the role of a ARM element relative to the referring ARM
    element or to the next referred ARM element. 
    </p>

     <p>For the expression of reference paths and of the
    constraints between ARM elements, the following notational conventions
    apply:
	  </p> 

  <table cellspacing="6">
    <tbody>
      <tr valign="top">
        <td valign="top">[]</td>
        <td valign="top">
          enclosed section constrains multiple ARM elements or
          sections of the reference path are required to satisfy an
          information requirement;
        </td>
      </tr>
      <tr valign="top">
        <td valign="top">()</td>
        <td valign="top">
          enclosed section constrains multiple ARM elements or
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

<!-- give the A NAME for the mapping of the entity in sect 5 -->
<xsl:template match="be" mode="map_attr_aname">
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>
  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:value-of select="translate(concat('beentity',@entity),$UPPER,$LOWER)"/>
</xsl:template>

<!-- give the A NAME for the mapping of the entity attribute in sect 5 -->
<xsl:template match="ba" mode="map_attr_aname_output">
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ\'"/>

  <xsl:variable name="attr">
    <xsl:choose>
      <xsl:when test="@assertion_to">
        <xsl:value-of
          select="translate(concat('beentity',../@entity,'baattribute',@attribute,'assertion_to',@assertion_to),$UPPER,$LOWER)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of
          select="translate(concat('beentity',../@entity,'baattribute',@attribute),$UPPER,$LOWER)"/>
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
            select="translate(concat('beentity',../@entity,'baattribute',$redcl_attr,'assertion_to',@assertion_to),$UPPER,$LOWER)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of
            select="translate(concat('beentity',../@entity,'baattribute',$redcl_attr),$UPPER,$LOWER)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- need to put in whitespace to make HREF work in IExplorer -->
    <a name="{$attr1}"> </a>
  </xsl:if>  
</xsl:template>

<!-- This is the main template to output the mapping specification -->
<xsl:template match="be|ba" mode="output_mapping">
  <xsl:apply-templates select="." mode="output_id_description"/>
  <!-- only output a table if it will be populated -->
  <xsl:if test="./armelt or ./source or ./rules or ./refpath or ./refpath_extend">
    <table>
      <xsl:apply-templates select="./armelt"  mode="specification"/>
      <xsl:apply-templates select="./source"  mode="specification"/>
      <xsl:apply-templates select="./rules"  mode="specification"/>
      <xsl:apply-templates select="./refpath"  mode="specification"/>
      <xsl:apply-templates select="./refpath_extend"  mode="specification"/>
    </table>  
  </xsl:if>
</xsl:template>

<xsl:template match="be|ba|sc" mode="output_id_description">
  <p/>
	<xsl:apply-templates select="./description"/>
  <p/>
</xsl:template>

<xsl:template match="armelt" mode="specification">
  <tr valign="top">
    <td>ARM element:</td>
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

<xsl:template match="refpath" mode="specification">
  <xsl:variable name="str">
    <xsl:call-template name="remove_trailing_whitespace">
      <xsl:with-param name="string" select="string(.)"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="string-length($str)>0">
    <tr valign="top">
      <td>Reference path:&#160;&#160;</td>
      <!--      Checking of ref path disabled for BOM documents
      <xsl:apply-templates select="." mode="check_ref_path"/> 
      -->
      <td>
        <xsl:call-template name="output_string_with_linebreaks">
          <xsl:with-param name="string" select="$str"/>
        </xsl:call-template>
      </td>
    </tr>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
