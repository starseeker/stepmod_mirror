<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
	$Id: $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="../sect_5_mapping.xsl"/>
	<xsl:import href="application_protocol.xsl"/>
	<xsl:import href="sect_5_mapping_check.xsl"/>
	<xsl:import href="application_protocol_clause.xsl"/>
	<xsl:preserve-space elements="aimelt"/>
	<xsl:output method="html"/>
	<xsl:variable name="global_xref_list">
		<xsl:if test="$check_mapping='yes'">
			<xsl:choose>
				<xsl:when test="/application_protocol_clause">
					<xsl:variable name="ap_module_dir">
						<xsl:call-template name="ap_module_directory">
							<xsl:with-param name="application_protocol" select="/application_protocol_clause/	@directory"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="express_xml" select="concat($ap_module_dir,'/mim.xml')"/>
					<xsl:call-template name="build_xref_list">
						<xsl:with-param name="express" select="document($express_xml)/express"/>
					</xsl:call-template>
					</xsl:when>
					<xsl:when test="/application_protocol">
						<xsl:variable name="ap_module_dir">
							<xsl:call-template name="ap_module_directory">
								<xsl:with-param name="application_protocol" select="/application_protocol/	@name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="express_xml" select="concat($ap_module_dir,'/mim.xml')"/>
						<xsl:call-template name="build_xref_list">
							<xsl:with-param name="express" select="document($express_xml)/express"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="relative_root" select="'../../../../'"/>
		
		<xsl:template match="application_protocol"/>
				
		<xsl:template match="module">
			<h3>
				<a name="mapping">5.1 Mapping specification</a>
			</h3>
			<xsl:call-template name="mapping_syntax"/>
			<a name="mappings"/>
			<xsl:apply-templates select="./mapping_table" mode="check_all_arm_mapped"/>
			<xsl:apply-templates select="./mapping_table/ae" mode="specification"/>
		</xsl:template>
		
		<xsl:template name="mapping_syntax">
			<xsl:variable name="sect4" select="concat('4_info_reqs',$FILE_EXT)"/>
			<xsl:variable name="sect52" select="concat('5_mim',$FILE_EXT,'#mim_express')"/>
			<p>
				This clause contains the mapping specification that shows how each UoF and application object of this part of ISO 10303 (see clause <a href="{$sect4}">4</a>) maps to one or more AIM constructs (see clause <a href="{$sect52}">5.2</a>)
			</p>
			<p>
				In the following, &quot;Application element&quot; designates any entity data type defined in clause <a href="{$sect4}">4</a> and any of its explicit attributes. &quot;MIM element&quot; designates any entity data type defined in clause <a href="{$sect52}">5.2</a> or imported with a USE FROM statement, from another EXPRESS schema and any of its attributes.
			</p>
			<p>
				Each mapping specification sub-clause specifies up to five elements.
			</p>
			<p>
				<b>Application element:</b>
				The mapping for each application element is specified in a separate sub-clause below. ARM entity names are given in title case. Attribute names and assertions are listed after the application object to which they belong and are given in lower case.
			</p>
			<p>
				<b>AIM element:</b>
				The name of one or more AIM entity data types , the term &quot;IDENTICAL MAPPING&quot;, or the term &quot;PATH&quot;. Entity data type names are presented in lower case. Attributes of AIM entity data types are referred to as &lt;entity name&gt;.&lt;attribute name&gt;. The mapping of an application element may involve more than one AIM element. Each of these AIM elements is presented on a separate line in the mapping specification. The term &quot;IDENTICAL MAPPING&quot; indicates that both application objects involved in an application assertion map to the same instance of an AIM entity data type. The term &quot;PATH&quot; indicates that the application assertion maps to a collection of related AIM entity instances specified by the entire reference path.
			</p>
			<p>
				<b>Source:</b>
				For those AIM elements that are interpreted from any common resource, this is the ISO standard number and part number in which the resource is defined. For those AIM elements that are created in the MIM for  this part of ISO 10303, this is the ISO standard number and part number of this part.
			</p>
			<p>
				<b>Rules:</b>
				One or more global rules may be specified that apply to the population of the AIM entity data types specified as the AIM element or in the reference path. For rules that are derived from relationships between application objects, the same rule is referred to by the mapping entries of all the involved AIM elements. A reference to a global rule may be accompanied by a reference to the sub-clause in which the rule is defined.
			</p>
			<p>
				<b>Reference path:</b>
				To describe fully the mapping of an application object, it may be necessary to specify a reference path involving several related AIM elements. Two or more such related AIM elements define the interpretation of the common resources that satisfies the requirement specified by the application element. Each line in the reference path documents the role of a AIM element relative to the referring AIM element or to the next referred AIM element. For each AIM element that has been created for use within this part of ISO 10303, a  reference path to its supertype from a common resource is specified. For the expression of reference paths and the relationships between AIM elements the following notational conventions apply:
			</p>
			<table cellspacing="4">
				<tbody>
					<tr valign="top">
						<td valign="top">[]</td>
						<td valign="top">
							enclosed section constrains multiple AIM elements or sections of the reference path are required to satisfy an information requirement;
						</td>
					</tr>
					<tr valign="top">
						<td valign="top">()</td>
						<td valign="top">
							enclosed section constrains multiple AIM elements or sections of the reference path are identified as alternatives within the mapping to satisfy an information requirement;
						</td>
					</tr>
					<tr valign="top">
						<td valign="top">{}</td>
						<td valign="top">
							enclosed section constrains the reference path to satisfy an information requirement:
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
						<td valign="top">enclosed section constrains the supertype entity;</td>
					</tr>
					<tr valign="top">
						<td valign="top">-&gt;</td>
						<td valign="top">
							attribute references the entity or select type given in the following row;
						</td>
					</tr>
					<tr valign="top">
						<td valign="top">&lt;-</td>
						<td valign="top">
							entity or select type is referenced by the attribute in the following row;
						</td>
					</tr>
					<tr valign="top">
						<td valign="top">[i]</td>
						<td valign="top">
							attribute is an aggregation of which a single member is given in the following row;
						</td>
					</tr>
					<tr valign="top">
						<td valign="top">[n]</td>
						<td valign="top">
							attribute is an aggregation of which member n is given in the following row;
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
							used in conjunction with braces to indicate that any number of relationship entity data types may be assembled in a relationship tree structure.
						</td>
					</tr>
					<tr valign="top">
					<td valign="top">--</td>
					<td valign="top">
						the text following is a comment (normally a clause reference);
					</td>
				</tr>
				<tr valign="top">
					<td valign="top">*&gt;</td>
					<td valign="top">
						the select, or enumeration type before the symbol is extended into the select or 	enumeration after the symbol;
					</td>
				</tr>
				<tr valign="top">
					<td valign="top">&lt;*</td>
					<td valign="top">
						the select, or enumeration type before the symbol is an extension of the select or enumeration after the symbol.
					</td>
				</tr>
			</tbody>
		</table>
		The definition and use of mapping templates is not supported in the present version of the application modules. However, use of predefined templates /SUBTYPE/ and /SUPERTYPE/ is supported. 
	</xsl:template>
	
	<xsl:template match="ae" mode="specification">
		<xsl:variable name="sect_no">
			<xsl:number/>
		</xsl:variable>
		<xsl:variable name="aname" select="@entity"/>
		<xsl:variable name="schema_name">
			<xsl:choose>
				<xsl:when test="@original_module">
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
				<xsl:when test="@original_module">
					<xsl:value-of select="concat('../../',@original_module,'/sys/4_info_reqs',$FILE_EXT,'#',$ae_aname)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat('./4_info_reqs',$FILE_EXT,'#',$ae_aname)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="arm_entity" select="@entity"/>
		<xsl:variable name="ap_module_dir">
			<xsl:choose>
				<xsl:when test="@original_module">
					<xsl:call-template name="ap_module_directory">
						<xsl:with-param name="application_protocol" select="@original_module"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="ap_module_directory">
						<xsl:with-param name="application_protocol" select="../../../module/@name"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="module_ok">
			<xsl:choose>
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
		</xsl:variable>
		<xsl:variable name="arm_xml" select="concat($ap_module_dir,'/arm.xml')"/>
		<xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
		<xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
		<xsl:variable name="ae" select="@entity"/>
		<xsl:variable name="ae_map_aname">
			<xsl:apply-templates select="." mode="map_attr_aname"/>
		</xsl:variable>
		<h3>
			<a name="{$ae_map_aname}">
				<xsl:value-of select="concat('5.1.',$sect_no,' ')"/>
			</a>
			<a href="{$ae_xref}">
				<xsl:value-of select="$ae"/>
			</a>
			<xsl:if test="$module_ok='true'">
				<xsl:variable name="entity_node" select="document($arm_xml)/express/schema/entity[@name=$arm_entity]"/>
				<xsl:apply-templates select="$entity_node" mode="expressg_icon">
					<xsl:with-param name="original_schema" select="$schema_name"/>
				</xsl:apply-templates>
			</xsl:if>
		</h3>
		<xsl:apply-templates select="."  mode="output_mapping_issue"/>
		<xsl:choose>
			<xsl:when test="$module_ok != 'true'">
				<xsl:call-template name="error_message">
					<xsl:with-param name="message" select="concat('Error m1a: The module specified in the
@orginal_module attribute (', @original_module, ') does not exist in stepmod/repository_index.xml')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="not(document($arm_xml)/express/schema/entity[@name=$arm_entity])">
				<xsl:call-template name="error_message">
					<xsl:with-param name="message" select="concat('Error m1: The entity ', $arm_entity, 
                  ' does not exist in the arm (',$arm_xml,')')"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
		<xsl:if test="@original_module">
			<xsl:variable name="map_xref" select="translate(concat('../../',@original_module,'/sys/5_mapping',	$FILE_EXT,'#aeentity',@entity),$UPPER,$LOWER)"/>
			<p>
				This application object,
				<a href="{$ae_xref}">
					<xsl:value-of select="@entity"/>
				</a>
				, is defined in the module
				<a href="{$ae_xref}">
					<xsl:value-of select="@original_module"/>
				</a>
				. This mapping section extends the
				<a href="{$map_xref}">
					mapping of <xsl:value-of select="@entity"/>
				</a>
				, to include assertions defined in this module.
			</p>
		</xsl:if>
		<xsl:if test="@extensible='YES'">
			This section specifies the mapping of the entity
			<a href="{$ae_xref}">
				<xsl:value-of select="@entity"/>
			</a>
			for the case where it maps onto the resource entity
			<xsl:value-of select="./aimelt"/>
			.  Depending on the extensions of the Select
			<xsl:if test="$module_ok = 'true'">
				<xsl:variable name="selects">
					<xsl:apply-templates select="document($arm_xml)/express/schema/entity[@name=$arm_entity]/explicit" mode="output_extensible_attributes"/>
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
		<xsl:choose>
			<xsl:when test="./alt_map">
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
		<xsl:variable name="schema_name">
			<xsl:choose>
				<xsl:when test="../@original_module">
					<xsl:value-of select="concat(../@original_module,'_arm')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat(../../../../module/@name,'_arm')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="attr">
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
		<xsl:variable name="aa_xref">
			<xsl:choose>
				<xsl:when test="../@original_module">
					<xsl:value-of select="concat('../../',../@original_module,'/sys/4_info_reqs',$FILE_EXT,'#',$aa_aname)"/>
				</xsl:when>
				<xsl:when test="@inherited_from_module">
					<xsl:variable name="aa_inh_aname">
						<xsl:call-template name="express_a_name">
							<xsl:with-param name="section1" select="concat(@inherited_from_module,'_arm')"/>
							<xsl:with-param name="section2" select="@inherited_from_entity"/>
							<xsl:with-param name="section3" select="$attr"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:value-of select="concat('../../',@inherited_from_module,'/sys/4_info_reqs',$FILE_EXT,'#',$aa_inh_aname)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat('./4_info_reqs',$FILE_EXT,'#',$aa_aname)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="ap_module_dir">
			<xsl:choose>
				<xsl:when test="../@original_module">
					<xsl:call-template name="ap_module_directory">
						<xsl:with-param name="application_protocol" select="../@original_module"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="@inherited_from_module">
					<xsl:call-template name="ap_module_directory">
						<xsl:with-param name="application_protocol" select="@inherited_from_module"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="ap_module_directory">
						<xsl:with-param name="application_protocol" select="../../../../module/@name"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="arm_xml" select="concat($ap_module_dir,'/arm.xml')"/>
		<xsl:variable name="sect_no" select="concat($sect,'.',position())"/>
		<xsl:variable name="arm_entity" select="string(../@entity)"/>
		<xsl:variable name="arm_attr" select="string(@attribute)"/>
		<xsl:variable name="module_aok">
			<xsl:choose>
				<xsl:when test="../@original_module">
					<xsl:call-template name="check_module_exists">
						<xsl:with-param name="module" select="../@original_module"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="@inherited_from_module">
					<xsl:call-template name="check_module_exists">
						<xsl:with-param name="module" select="@inherited_from_module"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="check_module_exists">
						<xsl:with-param name="module" select="../../../../module/@name"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="aa_map_aname">
			<xsl:apply-templates select="." mode="map_attr_aname"/>
		</xsl:variable>
		<h3>
			<a name="{$aa_map_aname}"/>
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
							<xsl:when test="../@original_module">
								<xsl:value-of select="concat('../../',../@original_module,'/sys/4_info_reqs',$FILE_EXT,'#',$ae_aname)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat('./4_info_reqs',$FILE_EXT,'#',$ae_aname)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:value-of select="concat($sect_no,' ')"/>
					<a href="{$ae_xref}">
						<xsl:value-of select="../@entity"/>
					</a>
					to
					<xsl:value-of select="@assertion_to"/>
					(as
					<a href="{$aa_xref}">
						<xsl:value-of select="@attribute"/>
					</a>
					)
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat($sect_no,' ')"/>
					<a href="{$aa_xref}">
						<xsl:value-of select="@attribute"/>
					</a>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="$module_aok='true'">
				<xsl:variable name="ae" select="../@entity"/>
				<xsl:variable name="entity_node" select="document($arm_xml)/express/schema/entity[@name=$ae]"/>
				<xsl:apply-templates select="$entity_node" mode="expressg_icon">
					<xsl:with-param name="original_schema" select="$schema_name"/>
				</xsl:apply-templates>
			</xsl:if>
		</h3>
		<xsl:apply-templates select="."  mode="output_mapping_issue"/>
		<xsl:if test="$module_aok='true'">
			<xsl:apply-templates select="." mode="check_valid_attribute"/>
		</xsl:if>
		<xsl:apply-templates select="./alt" mode="specification"/>
		<xsl:choose>
			<xsl:when test="./alt_map">
				<xsl:apply-templates select="./alt_map" mode="output_mapping"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="output_mapping"/>
			</xsl:otherwise>
		</xsl:choose>
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

</xsl:stylesheet>
