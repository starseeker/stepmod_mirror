<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="../document_xsl.xsl" ?>
<!--
	$Id: modXML2schema.xsl,v 1.60 2006/05/17 15:37:44 mikeward Exp $
	Author:  Mike Ward, Eurostep Limited
	Owner:   Developed by Eurostep.
	Purpose:     generation of p28 XSD from expressXML
-->


<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:exp="urn:iso:std:iso:10303:28:ed-2:2005:schema:common">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
	<xsl:variable name="module_directory_name" select="//module_clause/@directory"/>
	<xsl:variable name="dex_directory_name" select="//dex_clause/@directory"/>
	<xsl:variable name="directory_path">
		<xsl:choose>
			<xsl:when test="string-length($dex_directory_name)>0">
				<xsl:value-of select="concat('../../../dexlib/data/dex/', $dex_directory_name)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat('../../data/modules/', $module_directory_name)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="long_form_file_name">
		<xsl:choose>
			<xsl:when test="string-length($dex_directory_name)>0">
				<xsl:value-of select="string('dex_lf.xml')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="string('arm_lf.xml')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="base_schema_location">
		<xsl:choose>
			<xsl:when test="string-length($dex_directory_name)>0">
				<xsl:value-of select="string('../../../../stepmod/dtd/part28/exp.xsd')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="string('../../../dtd/part28/exp.xsd')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="stepmod_namespace_file" select="document(concat($directory_path, '/stepmod_namespace.xml'))"/>
	<xsl:variable name="schema_name" select="$stepmod_namespace_file//dummy/@schema_name"/>
	<xsl:variable name="namespace_prefix" select="concat($stepmod_namespace_file//dummy/@ns_prefix_name, ':')"/>
	<xsl:strip-space elements="xs:all"/>	

	<xsl:template match="/">
		<xsl:apply-templates select="express"/>
	</xsl:template>
	
	<xsl:template match="express">
		<xsl:apply-templates select="schema"/>
	</xsl:template>
	
	<xsl:template match="schema">
		<xsl:text>&#xa;</xsl:text>
		<xsl:element name="xs:schema">
			<xsl:copy-of select="document('../../dtd/part28/exp_namespace.xml')/*/namespace::exp"/>
			<xsl:copy-of select="document(concat($directory_path, '/stepmod_namespace.xml'))/*/namespace::*"/>
			<xsl:attribute name="targetNamespace"><xsl:value-of select="concat('urn:iso10303-28:schema/', $schema_name)"/></xsl:attribute>
			<xsl:text>&#xa;</xsl:text>
			<xs:import namespace="urn:iso:std:iso:10303:28:ed-2:2005:schema:common" schemaLocation="{$base_schema_location}"/>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xs:complexType name="uos">
				<xs:complexContent>
					<xs:extension base="exp:uos">
						<xs:choice maxOccurs="unbounded" minOccurs="0">
							<xs:element ref="exp:Entity"/>
							<xs:element ref="exp:edokey"/>
						</xs:choice>
						<!-- xs:anyAttribute namespace="##any" processContents="skip"/ -->
					</xs:extension>
				</xs:complexContent>
			</xs:complexType>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:apply-templates select="type"/>
			<!-- Seq-types for list of elements aggregate form -->
			<!-- Go ahead each time if there is a simple data type of the specified sort that is referenced by aggregate that is not an optional array -->
			<xsl:if test="//type[aggregate and not(aggregate/@type='ARRAY' and aggregate/@optional='YES')]/builtintype/@type='BOOLEAN'">
				<xs:complexType name="Seq-boolean">
					<xs:simpleContent>
						<xs:extension base="{$namespace_prefix}List-boolean">
							<xs:attribute name="ref" type="xs:IDREF" use="optional"/>
							<xs:attribute ref="exp:arraySize" />
							<xs:attribute ref="exp:itemType" fixed="xs:boolean" />
							<xs:attribute ref="exp:cType" />
						</xs:extension>
					</xs:simpleContent>
				</xs:complexType>
			</xsl:if>		
			<xsl:if test="//type[aggregate and not(aggregate/@type='ARRAY' and aggregate/@optional='YES')]/builtintype/@type='INTEGER'">
				<xs:complexType name="Seq-long">
					<xs:simpleContent>
						<xs:extension base="{$namespace_prefix}List-long">
							<xs:attribute name="ref" type="xs:IDREF" use="optional"/>
							<xs:attribute ref="exp:arraySize" />
							<xs:attribute ref="exp:itemType" fixed="xs:long" />
							<xs:attribute ref="exp:cType" />
						</xs:extension>
					</xs:simpleContent>
				</xs:complexType>
			</xsl:if>	
			<xsl:if test="//type[aggregate and not(aggregate/@type='ARRAY' and aggregate/@optional='YES')]/builtintype/@type='LOGICAL'">
				<xs:complexType name="Seq-logical">
					<xs:simpleContent>
						<xs:extension base="{$namespace_prefix}List-logical">
							<xs:attribute name="ref" type="xs:IDREF" use="optional"/>
							<xs:attribute ref="exp:arraySize" />
							<xs:attribute ref="exp:itemType" fixed="xs:logical" />
							<xs:attribute ref="exp:cType" />
						</xs:extension>
					</xs:simpleContent>
				</xs:complexType>
			</xsl:if>
			<xsl:if test="//type[aggregate and not(aggregate/@type='ARRAY' and aggregate/@optional='YES')]/builtintype/@type='NUMBER'">
				<xs:complexType name="Seq-decimal">
					<xs:simpleContent>
						<xs:extension base="{$namespace_prefix}List-decimal">
							<xs:attribute name="ref" type="xs:IDREF" use="optional"/>
							<xs:attribute ref="exp:arraySize" />
							<xs:attribute ref="exp:itemType" fixed="xs:decimal" />
							<xs:attribute ref="exp:cType" />
						</xs:extension>
					</xs:simpleContent>
				</xs:complexType>
			</xsl:if>
			<xsl:if test="//type[aggregate and not(aggregate/@type='ARRAY' and aggregate/@optional='YES')]/builtintype/@type='REAL'">
				<xs:complexType name="Seq-double">
					<xs:simpleContent>
						<xs:extension base="{$namespace_prefix}List-double">
							<xs:attribute name="ref" type="xs:IDREF" use="optional"/>
							<xs:attribute ref="exp:arraySize" />
							<xs:attribute ref="exp:itemType" fixed="xs:double" />
							<xs:attribute ref="exp:cType" />
						</xs:extension>
					</xs:simpleContent>
				</xs:complexType>
			</xsl:if>
			<!-- consider each non-entity non-select express datatype in turn and go ahead each time if the type is referenced by aggregate that is not an optional array -->
			<xsl:for-each select="//type[not(select)]/@name">
				<xsl:variable name="name_of_aggregated_datatype" select="."/>
				<xsl:if test="//type[aggregate and not(aggregate/@type='ARRAY' and aggregate/@optional='YES')]/typename[@name=$name_of_aggregated_datatype]">
					<xsl:choose>
						<!-- exclude types whose base type is STRING-->
						<xsl:when test="//type[@name=$name_of_aggregated_datatype]/builtintype/@type='STRING'"></xsl:when>
						<!-- exclude types whose base type is BINARY -->
						<xsl:when test="//type[@name=$name_of_aggregated_datatype]/builtintype/@type='BINARY'"></xsl:when>
						<xsl:otherwise>
							<xsl:variable name="corrected_name_of_aggregated_datatype">
								<xsl:call-template name="correct_express_name">
									<xsl:with-param name="raw_express_name_param" select="$name_of_aggregated_datatype"/>
								</xsl:call-template>
							</xsl:variable>
							<xs:complexType name="Seq-{$corrected_name_of_aggregated_datatype}">
								<xs:simpleContent>
									<xs:extension base="{$namespace_prefix}List-{$corrected_name_of_aggregated_datatype}">
										<xs:attribute name="ref" type="xs:IDREF" use="optional"/>
										<xs:attribute ref="exp:arraySize" />
										<xs:attribute ref="exp:itemType" fixed="{$namespace_prefix}{$corrected_name_of_aggregated_datatype}" />
										<xs:attribute ref="exp:cType" />
									</xs:extension>
								</xs:simpleContent>
							</xs:complexType>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:for-each>
			<xsl:apply-templates select="entity" mode="elements_and_types"/>
			<xs:element substitutionGroup="exp:uos" name="uos" type="{$namespace_prefix}uos">
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				<xsl:apply-templates select="entity" mode="keys"/>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				<xsl:apply-templates select="entity/explicit[typename/@name = //entity/@name]" mode="keys"/>
			</xs:element>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>&#xa;</xsl:text>
                                            <!-- SYNTHETIC ENTITIES -->
                                            <xsl:variable name="configuration" select="document(concat($directory_path, '/p28_config.xml'))"/>
                    	                <xsl:for-each select="$configuration//exp:entity"/>
                    	                    
                    	               
                    	       
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="explicit" mode="keys">
		<xsl:variable name="raw_entity_name" select="../@name"/>
		<xsl:variable name="raw_attribute_name" select="./@name"/>
		<xsl:variable name="raw_target_name" select="./typename/@name"/>
		<xsl:variable name="corrected_entity_name">
			<xsl:call-template name="correct_express_name">
				<xsl:with-param name="raw_express_name_param" select="$raw_entity_name"/>
			</xsl:call-template>
		</xsl:variable>	
		<xsl:variable name="corrected_attribute_name">
			<xsl:call-template name="correct_express_name">
				<xsl:with-param name="raw_express_name_param" select="$raw_attribute_name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="corrected_target_name">
			<xsl:call-template name="correct_express_name">
				<xsl:with-param name="raw_express_name_param" select="$raw_target_name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="subtypes_of_target_exist">
			<xsl:for-each select="//entity/@supertypes">
				<xsl:if test="contains(concat(' ', normalize-space(.), ' '), concat(' ', $raw_target_name, ' '))">YES</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:choose>
			<!-- test whether target has subtypes -->
			<xsl:when test="contains($subtypes_of_target_exist, 'YES')">
				<xs:keyref name="{$corrected_entity_name}___{$corrected_attribute_name}-keyref" refer="{$namespace_prefix}{$schema_name}___{$corrected_target_name}-keysub">
					<xs:selector xpath=".//{$namespace_prefix}{$corrected_target_name}/{$corrected_attribute_name}"/>
					<xs:field xpath="@ref"/>
				</xs:keyref>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>&#xa;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>&#xa;</xsl:text>
				<xs:keyref name="{$corrected_entity_name}___{$corrected_attribute_name}-keyref" refer="{$namespace_prefix}{$schema_name}___{$corrected_target_name}-key">
					<xs:selector xpath=".//{$namespace_prefix}{$corrected_target_name}/{$corrected_attribute_name}"/>
					<xs:field xpath="@ref"/>
				</xs:keyref>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>&#xa;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="entity" mode="keys">
		<xsl:variable name="abstract" select="./@abstract.supertype"/>
		<xsl:choose>
			<xsl:when test="$abstract='YES'"></xsl:when>
			<xsl:when test="$abstract='yes'"></xsl:when>
			<xsl:otherwise>
				<xsl:variable name="raw_entity_name" select="./@name"/>
				<xsl:variable name="corrected_entity_name">
					<xsl:call-template name="correct_express_name">
						<xsl:with-param name="raw_express_name_param" select="$raw_entity_name"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				<xs:key name="{$schema_name}___{$corrected_entity_name}-key">
					<xs:selector xpath="{$namespace_prefix}{$corrected_entity_name}"/>
					<xs:field xpath="@id"/>
				</xs:key>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				<xs:keyref name="{$schema_name}___{$corrected_entity_name}-keyref" refer="{$namespace_prefix}{$schema_name}___{$corrected_entity_name}-key">
					<xs:selector xpath=".//{$namespace_prefix}{$corrected_entity_name}"/>
					<xs:field xpath="@ref"/>
				</xs:keyref>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				<xsl:variable name="subtypes_list">
					<xsl:call-template name="collect_subtypes">
						<xsl:with-param name="top_entity_name_param" select="$raw_entity_name"/>
					</xsl:call-template>
				</xsl:variable>
				<!-- test whether end of recursion found -->
				<xsl:if test="string-length($subtypes_list)!=0">
					<xsl:text>&#xa;</xsl:text>
					<xsl:text>&#xa;</xsl:text>
					<xs:key name="{$schema_name}___{$corrected_entity_name}-keysub">
						<xsl:variable name="subtypes_xpath">
							<xsl:call-template name="generate_subtypes_xpath_for_key">
								<xsl:with-param name="subtypes_list_param" select="$subtypes_list"/>
							</xsl:call-template>
						</xsl:variable>
						<xs:selector xpath="{$namespace_prefix}{$corrected_entity_name}{$subtypes_xpath}"/>
						<xs:field xpath="@id"/>
					</xs:key>
					<xsl:text>&#xa;</xsl:text>
					<xsl:text>&#xa;</xsl:text>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- DEAL WITH NON-ENTITY EXPRESS DATATYPES -->
	<xsl:template match="type">
		<xsl:variable name="raw_type_name" select="./@name"/>
		<xsl:variable name="corrected_type_name">
			<xsl:call-template name="correct_express_name">
				<xsl:with-param name="raw_express_name_param" select="$raw_type_name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<!-- test whether express type is a select type -->
		
			
			<xsl:when test="./select">
				
				<xsl:variable name="initial_list_of_items" select="./select/@selectitems"/>
				
				<xsl:variable name="working_select_list">
					<xsl:call-template name="build_working_select_list">
						<xsl:with-param name="list_of_items_param" select="$initial_list_of_items"/>
					</xsl:call-template>
				</xsl:variable>
										
				<xsl:variable name="working_select_list_no_duplicates">
					<xsl:call-template name="filter-word-list-unique">
						<xsl:with-param name="word-list" select="$working_select_list"/>
					</xsl:call-template>
				</xsl:variable>
								
				<xsl:variable name="working_select_list_no_duplicates_no_abstracts">
					<xsl:call-template name="remove_names_of_abstract_entities_from_list">
						<xsl:with-param name="list_of_selected_datatypes_param" select="$working_select_list_no_duplicates"/>
					</xsl:call-template>
				</xsl:variable>
				
				<!-- xsl:variable name="working_select_list_no_duplicates_no_abstracts_no_subtypes_of_concrete_entities">
					<xsl:call-template name="remove_subtypes_of_concrete_entities_from_list">
						<xsl:with-param name="list_of_selected_datatypes_param" select="$working_select_list_no_duplicates"/>
						<xsl:with-param name="fixed_list_of_selected_datatypes_param" select="$working_select_list_no_duplicates" />
					</xsl:call-template>
				</xsl:variable -->
								
				<xsl:choose>
					<!-- check whether select list is empty -->
					<xsl:when test="string-length(normalize-space($working_select_list_no_duplicates_no_abstracts)) = 0"></xsl:when>
					<!-- check that select list contains at least two items -->
					<xsl:when test="contains(normalize-space($working_select_list_no_duplicates_no_abstracts), ' ')">
						<xsl:text>&#xa;</xsl:text>
						<xsl:text>&#xa;</xsl:text>
						<xs:complexType name="{$corrected_type_name}">
							<xs:group ref="{$namespace_prefix}{$corrected_type_name}"/>
						</xs:complexType>
						<xsl:text>&#xa;</xsl:text>
						<xsl:text>&#xa;</xsl:text>
						<xs:group name="{$corrected_type_name}">
							<xs:choice>
								<xsl:call-template name="construct_select_elements">
									
									<xsl:with-param name="complete_list_of_items_param" select="$working_select_list_no_duplicates_no_abstracts"/>
								</xsl:call-template>
							</xs:choice>
						</xs:group>
						<xsl:text>&#xa;</xsl:text>
						<xsl:text>&#xa;</xsl:text>
					</xsl:when>
					<xsl:otherwise>
							<!-- add instruction for what to do if select list contains only one item; p28 spec says elminate select type, but there are problems if u do this, so 4 now do say and for multiple items in select-->
							<xsl:text>&#xa;</xsl:text>
						<xsl:text>&#xa;</xsl:text>
						<xs:complexType name="{$corrected_type_name}">
							<xs:group ref="{$namespace_prefix}{$corrected_type_name}"/>
						</xs:complexType>
						<xsl:text>&#xa;</xsl:text>
						<xsl:text>&#xa;</xsl:text>
						<xs:group name="{$corrected_type_name}">
							<xs:choice>
								<xsl:call-template name="construct_select_elements">
									<xsl:with-param name="complete_list_of_items_param" select="$working_select_list_no_duplicates_no_abstracts"/>
								</xsl:call-template>
							</xs:choice>
						</xs:group>
						<xsl:text>&#xa;</xsl:text>
						<xsl:text>&#xa;</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<!-- test whether express type is an aggregate type -->
			<xsl:when test="./aggregate">
				<xsl:variable name="express_name_of_aggregated_datatype">
					<xsl:choose>
						<xsl:when test="./aggregate/builtintype">
							<xsl:value-of select="./aggregate/builtintype/@type"/>
						</xsl:when>
						<xsl:when test="./aggregate/typename">
							<xsl:value-of select="./aggregate/typename/@name"/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="fundamental_datatype">
					<xsl:call-template name="generate_fundamental_datatype">
						<xsl:with-param name="type" select="."/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="lower_bound">
					<xsl:call-template name="calculate_lower_bound">
						<xsl:with-param name="aggregate" select="."/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="upper_bound">
					<xsl:call-template name="calculate_upper_bound">
						<xsl:with-param name="aggregate" select="."/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="optionality">
					<xsl:choose>
						<xsl:when test="not(./@type = 'ARRAY') or ./@optional = 'YES'">
							<xsl:value-of select="string('optional')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('required')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="current_aggregate_type">
					<xsl:choose>
						<xsl:when test="./@type = 'ARRAY'">
							<xsl:value-of select="string('array')"/>
						</xsl:when>
						<xsl:when test="./@type = 'LIST'">
							<xsl:value-of select="string('list')"/>
						</xsl:when>
						<xsl:when test="./@type = 'BAG'">
							<xsl:value-of select="string('bag')"/>
						</xsl:when>
						<xsl:when test="./@type = 'SET'">
							<xsl:value-of select="string('set')"/>
						</xsl:when>
						<xsl:otherwise/>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="immediate_base_datatype"><!-- i.e. exp:string-wrapper or Tns:My_express_datatype_name -->
					<xsl:call-template name="generate_immediate_base_datatype">
						<xsl:with-param name="type" select="."/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				<xs:element name="{$corrected_type_name}" nillable="true">
					<xs:complexType>
						<xs:complexContent>
							<xs:extension base="{$namespace_prefix}{$corrected_type_name}">
								<xs:attributeGroup ref="exp:instanceAttributes"/>
							</xs:extension>
						</xs:complexContent>
					</xs:complexType>
				</xs:element>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				<xsl:choose>
					<!-- test whether to use 7.2.2.2	sequence-of-elements form -->
					<xsl:when test="$fundamental_datatype = 'string' or $fundamental_datatype = 'binary' or ($current_aggregate_type='array' and ./@optional='YES') or $fundamental_datatype = 'select' or $fundamental_datatype = 'entity'">
						<xs:complexType name="{$corrected_type_name}">
							<xsl:choose>
								<!-- test whether aggregated datatype is a select -->
								<xsl:when test="$express_name_of_aggregated_datatype=//type[select]/@name">
									<xs:sequence>
										<xs:group ref="{$immediate_base_datatype}" minOccurs="{$lower_bound}" maxOccurs="{$upper_bound}"/>
									</xs:sequence>
								</xsl:when>
								<!-- test whether aggregated datatype is an entity -->
								<xsl:when test="$express_name_of_aggregated_datatype=//entity/@name">
									<!-- xsl:variable name="subtypes_exist">
										<xsl:call-template name="check_whether_subtypes_exist">
											<xsl:with-param name="entity_name_param" select="$express_name_of_aggregated_datatype"/>
										</xsl:call-template>
									</xsl:variable -->
								</xsl:when>
								<xsl:otherwise>
									<xs:sequence>
										<xs:element ref="{$immediate_base_datatype}">
											<xsl:if test="$lower_bound!='NaN'">
												<xsl:attribute name="minOccurs"><xsl:value-of select="$lower_bound"/></xsl:attribute>
											</xsl:if>
											<xsl:if test="$upper_bound!='NaN'">
												<xsl:attribute name="maxOccurs"><xsl:value-of select="$upper_bound"/></xsl:attribute>
											</xsl:if>
										</xs:element>
									</xs:sequence>
								</xsl:otherwise>
							</xsl:choose>
							<xs:attribute name="ref" type="xs:IDREF" use="optional"/>
							<xsl:choose>
								<!-- test whether aggregated datatype is an array AND has upper OR lower bounds that are NOT constants -->
								<xsl:when test="$current_aggregate_type='array' and (number($upper_bound)='NaN' or number($lower_bound='NaN'))">
									<xs:attribute ref="exp:arraySize" use="required"/>
								</xsl:when>
								<!-- test whether aggregated datatype is an array AND has constant upper AND lower bounds -->
								<xsl:when test="$current_aggregate_type='array' and not(number($upper_bound)='NaN' or number($lower_bound='NaN'))">
									<xs:attribute ref="exp:arraySize" fixed="{$upper_bound}"/>
								</xsl:when>
								<xsl:otherwise>
									<xs:attribute ref="exp:arraySize" use="optional"/>
								</xsl:otherwise>
							</xsl:choose>
							<xs:attribute ref="exp:itemType" fixed="{$immediate_base_datatype}"/>
							<xs:attribute ref="exp:cType" fixed="{$current_aggregate_type}"/>
						</xs:complexType>
						<xsl:text>&#xa;</xsl:text>
						<xsl:text>&#xa;</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<!-- use 7.2.2.3	List-of-values form -->
						<xsl:variable name="express_name_of_immediate_datatype">
								<xsl:choose>
									<xsl:when test="../builtintype"><xsl:value-of select="../builtintype/@type"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="../typename/@name"/></xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
						<xsl:variable name="list_type_name">
							<xsl:call-template name="get_list_type_name">
								<xsl:with-param name="list_type_name_param" select="$express_name_of_immediate_datatype"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="list_type_name_with_seq_prefix" select="concat('Seq-', $list_type_name)"/>
						<xsl:variable name="list_type_name_with_list_prefix" select="concat('List-', $list_type_name)"/>
						<xs:complexType name="{$corrected_type_name}">
							<xs:simpleContent>
								<xs:restriction base="{$namespace_prefix}{$list_type_name_with_seq_prefix}">
									<xs:simpleType>
										<xs:restriction base="{$namespace_prefix}{$list_type_name_with_list_prefix}">
											<xsl:choose>
												<!-- test whether lower bound is NOT a number -->
												<xsl:when test="$lower_bound='NaN'"></xsl:when>
												<xsl:otherwise><xs:minLength value="{$lower_bound}"/></xsl:otherwise>
											</xsl:choose>
											<xsl:choose>
												<!-- test whether upper bound is NOT a number -->
												<xsl:when test="$upper_bound='NaN'"></xsl:when>
												<!-- test whether lower bound is NOT a number -->
												<xsl:when test="$upper_bound='unbounded'"></xsl:when>
												<xsl:otherwise>
													<xs:maxLength value="{$upper_bound}"/>
												</xsl:otherwise>
											</xsl:choose>
										</xs:restriction>
									</xs:simpleType>
									<xsl:choose>
										<!-- test whether aggregated datatype is an array AND has upper OR lower bounds that are NOT constants -->
										<xsl:when test="$current_aggregate_type='array' and (number($upper_bound)='NaN' or number($lower_bound='NaN'))">
											<xs:attribute ref="exp:arraySize" use="required"/>
										</xsl:when>
										<!-- test whether aggregated datatype is an array AND has constant upper AND lower bounds -->
										<xsl:when test="$current_aggregate_type='array' and not(number($upper_bound)='NaN' or number($lower_bound='NaN'))">
											<xs:attribute ref="exp:arraySize" fixed="{$upper_bound}"/>
										</xsl:when>
										<xsl:otherwise>
											<xs:attribute ref="exp:arraySize" use="optional"/>
										</xsl:otherwise>
									</xsl:choose>
									<xs:attribute ref="exp:cType" fixed="{$current_aggregate_type}"/>
								</xs:restriction>
							</xs:simpleContent>
						</xs:complexType>
						<xsl:variable name="list_type_name_with_xs_prefix" select="concat('xs:', $list_type_name)"/>
						<xsl:variable name="list_type_name_with_ns_prefix" select="concat($namespace_prefix, $list_type_name)"/>
						<xsl:choose>
							<!-- test whether type based on simple type -->
							<xsl:when test="../builtintype">
								<xs:simpleType name="{$list_type_name_with_list_prefix}">
									<xs:list itemType="{$list_type_name_with_xs_prefix}"/>
								</xs:simpleType>
							</xsl:when>
							<!-- test whether type based on non-simple type -->
							<xsl:when test="../typename">
								<xs:simpleType name="{$list_type_name_with_list_prefix}">
									<xs:list itemType="{$list_type_name_with_ns_prefix}"/>
								</xs:simpleType>
							</xsl:when>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<!-- test whether express type is based on a select type -->
			<xsl:when test="./typename/@name=//type[select]/@name">
				<xsl:variable name="raw_select_type_name" select="./typename/@name"/>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				<xs:element name="{$corrected_type_name}" nillable="true">
					<xs:complexType>
						<xs:complexContent>
							<xs:extension base="{$namespace_prefix}{$corrected_type_name}">
								<xs:attributeGroup ref="exp:instanceAttributes"/>
							</xs:extension>
						</xs:complexContent>
					</xs:complexType>
				</xs:element>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				<xsl:variable name="end_of_wr">&apos; IN TYPEOF</xsl:variable>
				<xsl:variable name="list_of_items_for_underlying_select" select="//type[@name=$raw_select_type_name]/select/@selectitems"/>
				
				<xsl:variable name="working_select_list_for_underlying_select">
					<xsl:call-template name="build_working_select_list">
						<xsl:with-param name="list_of_items_param" select="$list_of_items_for_underlying_select"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="list_of_exclusions">
					<xsl:for-each select="./where">
						<xsl:value-of select="concat(substring-after(substring-before(./@expression, $end_of_wr), 'LF.'), ' ')"/>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="corrected_case_list_of_exclusions">
					<xsl:call-template name="correct_express_names">
						<xsl:with-param name="list_of_express_names_param" select="concat(' ',$list_of_exclusions)"/>
					</xsl:call-template>
				</xsl:variable>
				<!-- NEW -->
				<xsl:variable name="corrected_case_list_of_exclusions_with_subtypes">
					<xsl:call-template name="add_subtypes_to_a_list">
					<xsl:with-param name="entity_list_param" select="concat(' ', normalize-space($corrected_case_list_of_exclusions), ' ')"/>
					<xsl:with-param name="entity_list_plus_subtypes_param" select="$corrected_case_list_of_exclusions"/>
				</xsl:call-template>
				</xsl:variable>
				
				<xsl:variable name="pruned_select_list">
					<xsl:call-template name="subtract-forbidden-word-list-from-main-word-list">
						<xsl:with-param name="forbidden-list" select="$corrected_case_list_of_exclusions_with_subtypes"/>
						<xsl:with-param name="main-list" select="$working_select_list_for_underlying_select"/>
					</xsl:call-template>
				</xsl:variable>
				
				<xsl:variable name="pruned_select_list_no_duplicates">
					<xsl:call-template name="filter-word-list-unique">
						<xsl:with-param name="word-list" select="$pruned_select_list"/>
					</xsl:call-template>
				</xsl:variable>
				
				<xsl:variable name="pruned_select_list_no_duplicates_no_abstracts">
					<xsl:call-template name="remove_names_of_abstract_entities_from_list">
						<xsl:with-param name="list_of_selected_datatypes_param" select="$pruned_select_list_no_duplicates"/>
					</xsl:call-template>
				</xsl:variable>
				
				<!-- xsl:variable name="pruned_select_list_no_duplicates_no_abstracts_no_subtypes_of_concrete_entities">
					<xsl:call-template name="remove_subtypes_of_concrete_entities_from_list">
						<xsl:with-param name="list_of_selected_datatypes_param" select="$pruned_select_list_no_duplicates"/>
						<xsl:with-param name="fixed_list_of_selected_datatypes_param" select="$pruned_select_list_no_duplicates"/>
					</xsl:call-template>
				</xsl:variable -->
				
				<xsl:choose>
						<!-- test whether select list empty -->
						<xsl:when test="string-length(normalize-space($pruned_select_list_no_duplicates_no_abstracts)) = 0"/>
						<!-- test whether select list has at least two items -->		
						<xsl:when test="contains(normalize-space($pruned_select_list_no_duplicates_no_abstracts), ' ')">
							<xs:complexType name="{$corrected_type_name}">
								<xs:group ref="{$namespace_prefix}{$corrected_type_name}"/>
							</xs:complexType>
							<xsl:text>&#xa;</xsl:text>
							<xsl:text>&#xa;</xsl:text>
							<xs:group name="{$corrected_type_name}">
								<xs:choice>
									<xsl:call-template name="construct_select_elements">
										<xsl:with-param name="complete_list_of_items_param" select="$pruned_select_list_no_duplicates_no_abstracts"/>
									</xsl:call-template>
								</xs:choice>
							</xs:group>
							<xsl:text>&#xa;</xsl:text>
							<xsl:text>&#xa;</xsl:text>
						</xsl:when>
						<xsl:otherwise>
								<!-- need to add what to do if select list has one item -->
								<xs:complexType name="{$corrected_type_name}">
								<xs:group ref="{$namespace_prefix}{$corrected_type_name}"/>
							</xs:complexType>
							<xsl:text>&#xa;</xsl:text>
							<xsl:text>&#xa;</xsl:text>
							<xs:group name="{$corrected_type_name}">
								<xs:choice>
									<xsl:call-template name="construct_select_elements">
										<xsl:with-param name="complete_list_of_items_param" select="$pruned_select_list_no_duplicates_no_abstracts"/>
									</xsl:call-template>
								</xs:choice>
							</xs:group>
							<xsl:text>&#xa;</xsl:text>
							<xsl:text>&#xa;</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text>&#xa;</xsl:text>
					<xsl:text>&#xa;</xsl:text>			
			</xsl:when>
			<xsl:otherwise>
				<xs:element name="{$corrected_type_name}-wrapper" nillable="true">
					<xs:complexType>
						<xs:simpleContent>
							<xs:extension base="{$namespace_prefix}{$corrected_type_name}">
								<xs:attributeGroup ref="exp:instanceAttributes"/>
							</xs:extension>
						</xs:simpleContent>
					</xs:complexType>
				</xs:element>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				<xsl:choose>
					<xsl:when test="./builtintype[@type='BINARY' or @type='LOGICAL']">
						<xs:complexType name="{$corrected_type_name}">
							<xs:simpleContent>
								<xsl:call-template name="generate_restriction">
									<xsl:with-param name="type" select="."/>
								</xsl:call-template>
							</xs:simpleContent>
						</xs:complexType>
					</xsl:when>
					<xsl:otherwise>
						<xs:simpleType name="{$corrected_type_name}">
							<xsl:call-template name="generate_restriction">
								<xsl:with-param name="type" select="."/>
							</xsl:call-template>
						</xs:simpleType>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>&#xa;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- DEAL WITH ENTITY EXPRESS DATATYPES HERE-->
	<xsl:template match="entity" mode="elements_and_types">
		<xsl:variable name="raw_entity_name" select="./@name"/>
		<xsl:variable name="corrected_entity_name">
			<xsl:call-template name="correct_express_name">
				<xsl:with-param name="raw_express_name_param" select="$raw_entity_name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="raw_supertypes_list" select="./@supertypes"/>
		<xsl:variable name="base_type_of_optional_array">
			<xsl:choose>
				<xsl:when test="//type/aggregate[@type='ARRAY' and @optional='YES']/../typename/@name=$raw_entity_name">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="abstractness">
			<xsl:choose>
				<xsl:when test="$base_type_of_optional_array='true'">false</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="./@abstract.supertype='YES'">true</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$base_type_of_optional_array='true' or $abstractness='true'"></xsl:when>
			<xsl:when test="$base_type_of_optional_array='false'">
				<xs:element name="{$corrected_entity_name}" type="{$namespace_prefix}{$corrected_entity_name}" block="extension restriction" substitutionGroup="exp:Entity" nillable="true"/>				
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				<xs:complexType name="{$corrected_entity_name}" abstract="{$abstractness}">
					<xs:complexContent>
						<xs:extension base="exp:Entity">
							<xs:all>
								<xsl:call-template name="collect_attributes_from_supertypes_but_weed_those_redeclared_lower_down">
									<xsl:with-param name="raw_entity_param" select="$raw_entity_name"/>
									<xsl:with-param name="redeclared_attributes_param" select="string(' ')"/>
									<xsl:with-param name="supertypes_list_param" select="$raw_supertypes_list"/>
								</xsl:call-template>
								<xsl:for-each select="./explicit">
									<xsl:call-template name="deal_with_attributes">
										<xsl:with-param name="attribute_node_param" select="."/>
									</xsl:call-template>
								</xsl:for-each>
							</xs:all>
						</xs:extension>
					</xs:complexContent>
				</xs:complexType>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>&#xa;</xsl:text>
			</xsl:when>
		</xsl:choose>
		<xs:group name="{$corrected_entity_name}-group">
			<xs:choice>
				<xsl:if test="not($abstractness='true')"><xs:element ref="{$namespace_prefix}{$corrected_entity_name}"/></xsl:if>
				<xsl:call-template name="recurse_through_subtype_tree">
					<xsl:with-param name="raw_node_name_param" select="$raw_entity_name"/>
				</xsl:call-template>
			</xs:choice>
		</xs:group>
		<xs:group name="{$corrected_entity_name}-complexEntity-group">
			<xs:choice>
				<xs:group ref="{$namespace_prefix}{$corrected_entity_name}-group"/>
				<xs:element ref="exp:complexEntity"/>
			</xs:choice>
		</xs:group>
	</xsl:template>
		
	<xsl:template match="explicit">
		<xsl:variable name="optionality">
			<xsl:choose>
				<xsl:when test="./@optional = 'YES'">
					<xsl:value-of select="number(0)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="number(1)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="raw_attribute_name" select="./@name"/>
		<xsl:variable name="corrected_attribute_name">
			<xsl:call-template name="correct_express_name">
				<xsl:with-param name="raw_express_name_param" select="$raw_attribute_name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="current_node" select="."/>
		<xsl:variable name="first_aggregate_node" select="./aggregate[position()=1]"/>
		<xsl:choose>
			<xsl:when test="./aggregate">
				<xsl:variable name="base_datatype">
					<xsl:call-template name="generate_immediate_base_datatype">
						<xsl:with-param name="type" select="$current_node"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="lower_bound">
					<xsl:call-template name="calculate_lower_bound">
						<xsl:with-param name="aggregate" select="$first_aggregate_node[position()=1]"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="upper_bound">
					<xsl:call-template name="calculate_upper_bound">
						<xsl:with-param name="aggregate" select="$first_aggregate_node"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="aggregate_optionality">
					<xsl:choose>
						<xsl:when test="not($first_aggregate_node/@type = 'ARRAY') or $first_aggregate_node/@optional = 'YES'">
							<xsl:value-of select="string('optional')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('required')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="current_aggregate_type">
					<xsl:choose>
						<xsl:when test="$first_aggregate_node/@type = 'ARRAY'">
							<xsl:value-of select="string('array')"/>
						</xsl:when>
						<xsl:when test="$first_aggregate_node/@type = 'LIST'">
							<xsl:value-of select="string('list')"/>
						</xsl:when>
						<xsl:when test="$first_aggregate_node/@type = 'BAG'">
							<xsl:value-of select="string('bag')"/>
						</xsl:when>
						<xsl:when test="$first_aggregate_node/@type = 'SET'">
							<xsl:value-of select="string('set')"/>
						</xsl:when>
						<xsl:otherwise/>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="seq_prefix">
					<xsl:call-template name="generate_prefix">
						<xsl:with-param name="position_param" select="count(./aggregate)"/>
						<xsl:with-param name="prefix_param" select="string('')"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="./aggregate[position()=1 and position()=last()]">
						<xsl:text>&#xa;</xsl:text>
						<xsl:choose>
							<xsl:when test="./typename">
								<xsl:variable name="target" select="./typename/@name"/>
								<xsl:variable name="corrected_target_name">
									<xsl:call-template name="correct_express_name">
										<xsl:with-param name="raw_express_name_param" select="$target"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="$target = //type[select]/@name">
										<xsl:variable name="initial_list_of_items" select="//type[@name=$target]/select/@selectitems"/>
										<xsl:variable name="working_select_list">
											<xsl:call-template name="build_working_select_list">
												<xsl:with-param name="list_of_items_param" select="$initial_list_of_items"/>
											</xsl:call-template>
										</xsl:variable>
										<xsl:variable name="normalized_working_select_list" select="normalize-space($working_select_list)"/>
										<!-- xsl:choose -->
											<!-- test whether single item select -->
											<!-- xsl:when test="contains($normalized_working_select_list, ' ')" -->
												<xs:element name="{$corrected_attribute_name}">
													<xs:complexType>
														<xs:sequence>
															<xsl:choose>
																<xsl:when test="./typename/@name=//type[select]/@name">
																	<xs:group ref="{$base_datatype}" minOccurs="{$lower_bound}" maxOccurs="{$upper_bound}"/>
																</xsl:when>
																<xsl:otherwise>
																	<xs:element ref="{$base_datatype}" minOccurs="{$lower_bound}" maxOccurs="{$upper_bound}"/>
																</xsl:otherwise>
															</xsl:choose>
														</xs:sequence>
														<xs:attribute ref="exp:itemType" fixed="{$base_datatype}"/>
														<xs:attribute ref="exp:cType" fixed="{$current_aggregate_type}"/>
														<xs:attribute ref="exp:arraySize" use="{$aggregate_optionality}"/>
													</xs:complexType>
												</xs:element>
												<xsl:text>&#xa;</xsl:text>
												<xsl:text>&#xa;</xsl:text>
											<!-- /xsl:when>
											<xsl:otherwise>
												<xsl:variable name="corrected_target_select_target_name">
													<xsl:call-template name="correct_express_name">
														<xsl:with-param name="raw_express_name_param" select="$normalized_working_select_list"/>
													</xsl:call-template>
												</xsl:variable>
												<xs:element name="{$corrected_attribute_name}">
													<xs:complexType>
														<xs:sequence>
															<xs:element ref="{$namespace_prefix}{$corrected_target_select_target_name}" minOccurs="{$lower_bound}" maxOccurs="{$upper_bound}"/>
														</xs:sequence>
														<xs:attribute ref="exp:itemType" fixed="{$corrected_target_select_target_name}"/>
														<xs:attribute ref="exp:cType" fixed="{$current_aggregate_type}"/>
														<xs:attribute ref="exp:arraySize" use="{$aggregate_optionality}"/>
													</xs:complexType>
												</xs:element>
											</xsl:otherwise>
										</xsl:choose -->
									</xsl:when>
									<xsl:when test="$target = //entity/@name">
										<xsl:variable name="subtypes_exist">
											<xsl:call-template name="check_whether_subtypes_exist">
												<xsl:with-param name="entity_name_param" select="$target"/>
											</xsl:call-template>
										</xsl:variable>
										<xsl:choose>
											<xsl:when test="contains($subtypes_exist, 'YES')">
												<xs:element name="{$corrected_attribute_name}" minOccurs="{$optionality}">
													<xs:complexType>
														<xs:sequence>
															<xs:group ref="{$namespace_prefix}{$corrected_target_name}-group" minOccurs="{$lower_bound}" maxOccurs="{$upper_bound}"/>
														</xs:sequence>
														<xs:attribute ref="exp:itemType" fixed="{$corrected_target_name}"/>
														<xs:attribute ref="exp:cType" fixed="{$current_aggregate_type}"/>
														<xs:attribute ref="exp:arraySize" use="{$aggregate_optionality}"/>
													</xs:complexType>
												</xs:element>
											</xsl:when>
											<xsl:otherwise>
												<xs:element name="{$corrected_attribute_name}" minOccurs="{$optionality}">
													<xs:complexType>
														<xs:sequence>
															<xs:element ref="{$namespace_prefix}{$corrected_target_name}" minOccurs="{$lower_bound}" maxOccurs="{$upper_bound}"/>
														</xs:sequence>
														<xs:attribute ref="exp:itemType" fixed="{$corrected_target_name}"/>
														<xs:attribute ref="exp:cType" fixed="{$current_aggregate_type}"/>
														<xs:attribute ref="exp:arraySize" use="{$aggregate_optionality}"/>
													</xs:complexType>
												</xs:element>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise></xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="./builtintype">
								<xsl:call-template name="generate_attribute_to_simple_datatype">
									<xsl:with-param name="type_param" select="."/>
									<xsl:with-param name="optionality_param" select="$optionality"/>
									<xsl:with-param name="attribute_name_param" select="$corrected_attribute_name"/>
								</xsl:call-template>
								<xsl:text>&#xa;</xsl:text>
								<xsl:text>&#xa;</xsl:text>
							</xsl:when>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="./aggregate[position()=1 and position()!=last()]"></xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="./typename">
						<xsl:variable name="target" select="./typename/@name"/>
						<xsl:variable name="corrected_target_name">
							<xsl:call-template name="correct_express_name">
								<xsl:with-param name="raw_express_name_param" select="$target"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="$target = //type[select]/@name">
								<xsl:variable name="initial_list_of_items" select="//type[@name=$target]/select/@selectitems"/>
								<xsl:variable name="working_select_list">
									<xsl:call-template name="build_working_select_list">
										<xsl:with-param name="list_of_items_param" select="$initial_list_of_items"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:variable name="normalized_working_select_list" select="normalize-space($working_select_list)"/>
								<!-- xsl:choose -->
									<!-- test whether single item select -->
									<!-- xsl:when test="contains($normalized_working_select_list, ' ')" -->
										<xs:element name="{$corrected_attribute_name}" minOccurs="{$optionality}">
											<xs:complexType>
												<xs:group ref="{$namespace_prefix}{$corrected_target_name}"/>
											</xs:complexType>
										</xs:element>
										<xsl:text>&#xa;</xsl:text>
										<xsl:text>&#xa;</xsl:text>
									<!-- /xsl:when>
									<xsl:otherwise>
										<xsl:variable name="corrected_target_select_target_name">
											<xsl:call-template name="correct_express_name">
												<xsl:with-param name="raw_express_name_param" select="$normalized_working_select_list"/>
											</xsl:call-template>
										</xsl:variable>
										<xsl:choose>
											<xsl:when test="//type/@name = $normalized_working_select_list">
												<xsl:choose>
													<xsl:when test="//type[builtintype]/@name = $normalized_working_select_list">
														<xsl:call-template name="generate_attribute_to_simple_datatype">
															<xsl:with-param name="type_param" select="//type[@name = $normalized_working_select_list]/builtintype"/>
															<xsl:with-param name="optionality_param" select="$optionality"/>
															<xsl:with-param name="attribute_name_param" select="$corrected_attribute_name"/>
														</xsl:call-template>
													</xsl:when>
													<xsl:when test="//type[typename]/@name = $normalized_working_select_list">
														<xs:element name="{$corrected_attribute_name}" ref="{$namespace_prefix}{$corrected_target_select_target_name}"/>
													</xsl:when>
													<xsl:otherwise/>
												</xsl:choose>
											</xsl:when>
											<xsl:when test="//entity/@name = $normalized_working_select_list">
												<xs:element name="{$corrected_attribute_name}" minOccurs="{$optionality}">
													<xs:complexType>
														<xs:choice>
															<xs:element ref="{$namespace_prefix}{$corrected_target_select_target_name}"/>
														</xs:choice>
													</xs:complexType>
												</xs:element>
											</xsl:when>
											<xsl:otherwise/>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose -->
							</xsl:when>
							<xsl:when test="$target = //entity/@name">
								<xsl:variable name="subtypes_exist">
									<xsl:call-template name="check_whether_subtypes_exist">
										<xsl:with-param name="entity_name_param" select="$target"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="contains($subtypes_exist, 'YES')">
										<xs:element name="{$corrected_attribute_name}" minOccurs="{$optionality}">
											<xs:complexType>
												<xs:sequence>
													<xs:group ref="{$namespace_prefix}{$corrected_target_name}-group"/>
												</xs:sequence>
											</xs:complexType>
										</xs:element>
									</xsl:when>
									<xsl:otherwise>
										<xs:element name="{$corrected_attribute_name}" minOccurs="{$optionality}">
											<xs:complexType>
												<xs:all>
													<xs:element ref="{$namespace_prefix}{$corrected_target_name}"/>
												</xs:all>
											</xs:complexType>
										</xs:element>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="./builtintype">
						<xsl:call-template name="generate_attribute_to_simple_datatype">
							<xsl:with-param name="type_param" select="."/>
							<xsl:with-param name="optionality_param" select="$optionality"/>
							<xsl:with-param name="attribute_name_param" select="$corrected_attribute_name"/>
						</xsl:call-template>
						<xsl:text>&#xa;</xsl:text>
						<xsl:text>&#xa;</xsl:text>
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- PROCEDURES -->
	
	<!-- USED -->
	<xsl:template name="deal_with_attributes">
		<xsl:param name="attribute_node_param"/>
		<xsl:variable name="optionality">
			<xsl:choose>
				<xsl:when test="$attribute_node_param/@optional = 'YES'">
					<xsl:value-of select="number(0)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="number(1)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="raw_attribute_name" select="$attribute_node_param/@name"/>
		<xsl:variable name="corrected_attribute_name">
			<xsl:call-template name="correct_express_name">
				<xsl:with-param name="raw_express_name_param" select="$raw_attribute_name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="current_node" select="$attribute_node_param"/>
		<xsl:variable name="first_aggregate_node" select="$attribute_node_param/aggregate[position()=1]"/>
		<xsl:choose>
			<!-- test whether aggregate attribute -->
			<xsl:when test="$attribute_node_param/aggregate">
				<xsl:variable name="base_datatype">
					<xsl:call-template name="generate_immediate_base_datatype">
						<xsl:with-param name="type" select="$current_node"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="lower_bound">
					<xsl:call-template name="calculate_lower_bound">
						<xsl:with-param name="aggregate" select="$first_aggregate_node[position()=1]"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="upper_bound">
					<xsl:call-template name="calculate_upper_bound">
						<xsl:with-param name="aggregate" select="$first_aggregate_node"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="aggregate_optionality">
					<xsl:choose>
						<xsl:when test="not($first_aggregate_node/@type = 'ARRAY') or $first_aggregate_node/@optional = 'YES'">
							<xsl:value-of select="string('optional')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string('required')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="current_aggregate_type">
					<xsl:choose>
						<xsl:when test="$first_aggregate_node/@type = 'ARRAY'">
							<xsl:value-of select="string('array')"/>
						</xsl:when>
						<xsl:when test="$first_aggregate_node/@type = 'LIST'">
							<xsl:value-of select="string('list')"/>
						</xsl:when>
						<xsl:when test="$first_aggregate_node/@type = 'BAG'">
							<xsl:value-of select="string('bag')"/>
						</xsl:when>
						<xsl:when test="$first_aggregate_node/@type = 'SET'">
							<xsl:value-of select="string('set')"/>
						</xsl:when>
						<xsl:otherwise/>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="seq_prefix">
					<xsl:call-template name="generate_prefix">
						<xsl:with-param name="position_param" select="count($attribute_node_param/aggregate)"/>
						<xsl:with-param name="prefix_param" select="string('')"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<!-- test whether single level aggregate -->
					<xsl:when test="$attribute_node_param/aggregate[position()=1 and position()=last()]">
						<xsl:choose>
							<!-- test if aggregate of non simple datatype -->
							<xsl:when test="$attribute_node_param/typename">
								<xsl:variable name="target" select="$attribute_node_param/typename/@name"/>
								<xsl:variable name="corrected_target_name">
									<xsl:call-template name="correct_express_name">
										<xsl:with-param name="raw_express_name_param" select="$target"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:choose>
									<!-- test whether aggregate of non simple non entity datatype -->
									<xsl:when test="$target = //type/@name">
										<xsl:choose>
											<!-- test whether aggregate of select type -->
											<xsl:when test="$target = //type[select]/@name">
											<xsl:variable name="initial_list_of_items" select="//type[@name=$target]/select/@selectitems"/>
											<xsl:variable name="working_select_list">
												<xsl:call-template name="build_working_select_list">
													<xsl:with-param name="list_of_items_param" select="$initial_list_of_items"/>
												</xsl:call-template>
											</xsl:variable>
											<xsl:variable name="normalized_working_select_list" select="normalize-space($working_select_list)"/>
											<xsl:choose>
												<!-- test whether single item select -->
												<xsl:when test="contains($normalized_working_select_list, ' ')">
													<xs:element name="{$corrected_attribute_name}">
														<xs:complexType>
															<xs:sequence>
																<xsl:choose>
																	<xsl:when test="$attribute_node_param/typename/@name=//type[select]/@name">
																		<xs:group ref="{$base_datatype}" minOccurs="{$lower_bound}" maxOccurs="{$upper_bound}"/>
																	</xsl:when>
																	<xsl:otherwise>
																		<xs:element ref="{$base_datatype}" minOccurs="{$lower_bound}" maxOccurs="{$upper_bound}"/>
																	</xsl:otherwise>
																</xsl:choose>
															</xs:sequence>
															<xs:attribute ref="exp:itemType" fixed="{$base_datatype}"/>
															<xs:attribute ref="exp:cType" fixed="{$current_aggregate_type}"/>
															<xs:attribute ref="exp:arraySize" use="{$aggregate_optionality}"/>
														</xs:complexType>
													</xs:element>
													<xsl:text>&#xa;</xsl:text>
													<xsl:text>&#xa;</xsl:text>
												</xsl:when>
												<xsl:otherwise>
													<xsl:variable name="corrected_target_select_target_name">
														<xsl:call-template name="correct_express_name">
															<xsl:with-param name="raw_express_name_param" select="$normalized_working_select_list"/>
														</xsl:call-template>
													</xsl:variable>
													<xs:element name="{$corrected_attribute_name}">
														<xs:complexType>
															<xs:sequence>
																<xs:element ref="{$namespace_prefix}{$corrected_target_select_target_name}" minOccurs="{$lower_bound}" maxOccurs="{$upper_bound}"/>
															</xs:sequence>
															<xs:attribute ref="exp:itemType" fixed="{$corrected_target_select_target_name}"/>
															<xs:attribute ref="exp:cType" fixed="{$current_aggregate_type}"/>
															<xs:attribute ref="exp:arraySize" use="{$aggregate_optionality}"/>
														</xs:complexType>
													</xs:element>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
											<xsl:when test="$target = //type[typename]/@name">
												<xs:element name="{$corrected_attribute_name}">
													<xs:complexType>
														<xs:sequence>
															<xs:element ref="{$namespace_prefix}{$corrected_target_name}" minOccurs="{$lower_bound}" maxOccurs="{$upper_bound}"/>
														</xs:sequence>
													</xs:complexType>
												</xs:element>
											</xsl:when>
											<!-- if aggregate of non simple non entity non select datatype -->
											<xsl:otherwise>
												<xs:element name="{$corrected_attribute_name}">
													<xs:complexType>
														<xs:sequence>
															<xs:element ref="{$namespace_prefix}{$corrected_target_name}-wrapper" minOccurs="{$lower_bound}" maxOccurs="{$upper_bound}"/>
														</xs:sequence>
													</xs:complexType>
												</xs:element>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									
									<xsl:when test="$target = //entity/@name">
										<xsl:variable name="subtypes_exist">
											<xsl:call-template name="check_whether_subtypes_exist">
												<xsl:with-param name="entity_name_param" select="$target"/>
											</xsl:call-template>
										</xsl:variable>
										<xsl:choose>
											<xsl:when test="contains($subtypes_exist, 'YES')">
												<xs:element name="{$corrected_attribute_name}" minOccurs="{$optionality}">
													<xs:complexType>
														<xs:sequence>
															<xs:group ref="{$namespace_prefix}{$corrected_target_name}-group" minOccurs="{$lower_bound}" maxOccurs="{$upper_bound}"/>
														</xs:sequence>
														<xs:attribute ref="exp:itemType" fixed="{$corrected_target_name}"/>
														<xs:attribute ref="exp:cType" fixed="{$current_aggregate_type}"/>
														<xs:attribute ref="exp:arraySize" use="{$aggregate_optionality}"/>
													</xs:complexType>
												</xs:element>
											</xsl:when>
											<xsl:otherwise>
												<xs:element name="{$corrected_attribute_name}" minOccurs="{$optionality}">
													<xs:complexType>
														<xs:sequence>
															<xs:element ref="{$namespace_prefix}{$corrected_target_name}" minOccurs="{$lower_bound}" maxOccurs="{$upper_bound}"/>
														</xs:sequence>
														<xs:attribute ref="exp:itemType" fixed="{$corrected_target_name}"/>
														<xs:attribute ref="exp:cType" fixed="{$current_aggregate_type}"/>
														<xs:attribute ref="exp:arraySize" use="{$aggregate_optionality}"/>
													</xs:complexType>
												</xs:element>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									
									<xsl:otherwise><xs:element name="{$corrected_attribute_name}" type="{$namespace_prefix}{$corrected_target_name}"></xs:element></xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<!-- test if aggregate of simple datatype -->
							<xsl:when test="$attribute_node_param/builtintype">
							
								<xs:element name="{$corrected_attribute_name}" minOccurs="{$optionality}">
									<xs:complexType>
										<xs:sequence>
											<xs:element ref="{$base_datatype}" minOccurs="{$lower_bound}" maxOccurs="{$upper_bound}"/>
										</xs:sequence>
										<xs:attribute name="ref" type="xs:IDREF" use="optional"/>
										<xs:attribute ref="exp:itemType" fixed="{$base_datatype}"/>
										<xs:attribute ref="exp:cType" fixed="{$current_aggregate_type}"/>
										<xs:attribute ref="exp:arraySize" use="optional"/>
									</xs:complexType>
								</xs:element>
								
		

	

							
								<!-- xsl:call-template name="generate_attribute_to_simple_datatype">
									<xsl:with-param name="type_param" select="$attribute_node_param"/>
									<xsl:with-param name="optionality_param" select="$optionality"/>
									<xsl:with-param name="attribute_name_param" select="$corrected_attribute_name"/>
								</xsl:call-template -->
								<xsl:text>&#xa;</xsl:text>
								<xsl:text>&#xa;</xsl:text>
							</xsl:when>
						</xsl:choose>
					</xsl:when>
					<!-- test whether multi level aggregate -->
					<xsl:when test="$attribute_node_param/aggregate[position()=1 and position()!=last()]"></xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$attribute_node_param/typename">
						<xsl:variable name="target" select="$attribute_node_param/typename/@name"/>
						<xsl:variable name="corrected_target_name">
							<xsl:call-template name="correct_express_name">
								<xsl:with-param name="raw_express_name_param" select="$target"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="$target = //type[select]/@name">
								<xsl:variable name="initial_list_of_items" select="//type[@name=$target]/select/@selectitems"/>
								<xsl:variable name="working_select_list">
									<xsl:call-template name="build_working_select_list">
										<xsl:with-param name="list_of_items_param" select="$initial_list_of_items"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:variable name="normalized_working_select_list" select="normalize-space($working_select_list)"/>
								<xsl:choose>
									<!-- test whether single item select -->
									<xsl:when test="contains($normalized_working_select_list, ' ')">
										<xs:element name="{$corrected_attribute_name}" minOccurs="{$optionality}">
											<xs:complexType>
												<xs:group ref="{$namespace_prefix}{$corrected_target_name}"/>
											</xs:complexType>
										</xs:element>
										<xsl:text>&#xa;</xsl:text>
										<xsl:text>&#xa;</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:variable name="corrected_target_select_target_name">
											<xsl:call-template name="correct_express_name">
												<xsl:with-param name="raw_express_name_param" select="$normalized_working_select_list"/>
											</xsl:call-template>
										</xsl:variable>
										<xsl:choose>
											<xsl:when test="//type/@name = $normalized_working_select_list">
												<xsl:choose>
													<xsl:when test="//type[builtintype]/@name = $normalized_working_select_list">
														<xsl:call-template name="generate_attribute_to_simple_datatype">
															<xsl:with-param name="type_param" select="//type[@name = $normalized_working_select_list]/builtintype"/>
															<xsl:with-param name="optionality_param" select="$optionality"/>
															<xsl:with-param name="attribute_name_param" select="$corrected_attribute_name"/>
														</xsl:call-template>
													</xsl:when>
													<xsl:when test="//type[typename]/@name = $normalized_working_select_list">
														<xs:element name="{$corrected_attribute_name}" ref="{$namespace_prefix}{$corrected_target_select_target_name}"/>
													</xsl:when>
													<xsl:otherwise/>
												</xsl:choose>
											</xsl:when>
											<xsl:when test="//entity/@name = $normalized_working_select_list">
												<xs:element name="{$corrected_attribute_name}" minOccurs="{$optionality}">
													<xs:complexType>
														<xs:choice>
															<xs:element ref="{$namespace_prefix}{$corrected_target_select_target_name}"/>
														</xs:choice>
													</xs:complexType>
												</xs:element>
											</xsl:when>
											<xsl:otherwise/>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$target = //entity/@name">
								<xsl:variable name="subtypes_exist">
									<xsl:call-template name="check_whether_subtypes_exist">
										<xsl:with-param name="entity_name_param" select="$target"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="contains($subtypes_exist, 'YES')">
										<xs:element name="{$corrected_attribute_name}" minOccurs="{$optionality}">
											<xs:complexType>
												<xs:sequence>
													<xs:group ref="{$namespace_prefix}{$corrected_target_name}-group"/>
												</xs:sequence>
											</xs:complexType>
										</xs:element>
									</xsl:when>
									<xsl:otherwise>
										<xs:element name="{$corrected_attribute_name}" minOccurs="{$optionality}">
											<xs:complexType>
												<xs:sequence>
													<xs:element ref="{$namespace_prefix}{$corrected_target_name}"/>
												</xs:sequence>
											</xs:complexType>
										</xs:element>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xs:element name="{$corrected_attribute_name}" type="{$namespace_prefix}{$corrected_target_name}"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$attribute_node_param/builtintype">
						<xsl:call-template name="generate_attribute_to_simple_datatype">
							<xsl:with-param name="type_param" select="$attribute_node_param"/>
							<xsl:with-param name="optionality_param" select="$optionality"/>
							<xsl:with-param name="attribute_name_param" select="$corrected_attribute_name"/>
						</xsl:call-template>
						<xsl:text>&#xa;</xsl:text>
						<xsl:text>&#xa;</xsl:text>
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- USED -->
	<xsl:template name="check_whether_subtypes_exist">
		<xsl:param name="entity_name_param"/>
		<xsl:for-each select="//entity/@supertypes">
			<xsl:variable name="supertypes" select="."/>
			<xsl:if test="contains(concat(' ', normalize-space($supertypes), ' '), concat(' ', $entity_name_param, ' '))">
				<xsl:value-of select="string('YES')"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	<!-- USED -->
	<xsl:template name="collect_subtypes">
		<xsl:param name="top_entity_name_param"/>
		<xsl:for-each select="//entity/@supertypes">
			<xsl:variable name="supertypes" select="."/>
			<xsl:variable name="subtype_name" select="../@name"/>
			<xsl:if test="contains(concat(' ', normalize-space($supertypes), ' '), concat(' ', $top_entity_name_param, ' '))">
				<xsl:value-of select="concat($subtype_name, ' ')"/>
				<xsl:call-template name="collect_subtypes">
					<xsl:with-param name="top_entity_name_param" select="$subtype_name"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	<!-- USED NEW -->
	<xsl:template name="add_subtypes_to_a_list">
		<xsl:param name="entity_list_param"/>
		<xsl:param name="entity_list_plus_subtypes_param"/>
		<xsl:variable name="wlist_of_entities" select="concat(normalize-space($entity_list_param), ' ')"/>
		<xsl:choose>
			<xsl:when test="$wlist_of_entities!=' '">
				<xsl:variable name="first" select="substring-before($wlist_of_entities, ' ')"/>
				<xsl:variable name="rest" select="substring-after($wlist_of_entities, ' ')"/>
				<xsl:variable name="subtypes">
					<xsl:call-template name="collect_subtypes">
						<xsl:with-param name="top_entity_name_param" select="$first"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="entity_list_plus_subtypes" select="concat($first, ' ', $subtypes)"/>
				<xsl:call-template name="add_subtypes_to_a_list">
					<xsl:with-param name="entity_list_param" select="$rest"/>
					<xsl:with-param name="entity_list_plus_subtypes_param" select="$entity_list_plus_subtypes"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$entity_list_plus_subtypes_param"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- USED -->
	<xsl:template name="generate_subtypes_xpath_for_key">
		<xsl:param name="subtypes_list_param"/>
		<xsl:variable name="wlist_of_subtypes" select="concat(normalize-space($subtypes_list_param), ' ')"/>
		<xsl:choose>
			<xsl:when test="$wlist_of_subtypes!=' '">
				<xsl:variable name="first" select="substring-before($wlist_of_subtypes, ' ')"/>
				<xsl:variable name="rest" select="substring-after($wlist_of_subtypes, ' ')"/>
				<xsl:variable name="corrected_subtype_name">
					<xsl:call-template name="correct_express_name">
						<xsl:with-param name="raw_express_name_param" select="$first"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="concat(' | ', $namespace_prefix, $corrected_subtype_name)"/>
				<xsl:call-template name="generate_subtypes_xpath_for_key">
					<xsl:with-param name="subtypes_list_param" select="$rest"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	
		
	<!-- USED -->
	<xsl:template name="collect_attributes_from_supertypes_but_weed_those_redeclared_lower_down">
		<xsl:param name="raw_entity_param"/>
		<xsl:param name="redeclared_attributes_param"/>
		<xsl:param name="supertypes_list_param"/>
		<xsl:variable name="long_form" select="document(concat($directory_path, '/', $long_form_file_name))"/>
		<xsl:variable name="raw_entity_param_with_spaces" select="concat(' ', $raw_entity_param, ' ')"/>
		<xsl:variable name="supertype_name_list_with_spaces" select="concat(' ', $supertypes_list_param, ' ')"/>
		<xsl:variable name="next_supertype_name_list">
			<xsl:for-each select="$long_form//entity[contains($supertype_name_list_with_spaces, concat(' ', ./@name, ' '))]">
				<xsl:value-of select="concat(./@supertypes, ' ')"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="new_list_of_redeclared_attributes">
			<xsl:for-each select="$long_form//entity[contains($raw_entity_param_with_spaces, concat(' ', @name, ' '))]/explicit/redeclaration">
				<xsl:choose>
					<xsl:when test="./@old_name">
						<xsl:value-of select="string(concat(' ', ../../@name, ./@old_name, ' '))"/>
					</xsl:when>
				</xsl:choose>
				<xsl:value-of select="string(concat(' ', ../@name, ' '))"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="extended_list_of_redeclared_attributes" select="concat(' ', normalize-space($redeclared_attributes_param), ' ', normalize-space($new_list_of_redeclared_attributes), ' ')"/>
		<xsl:for-each select="$long_form//entity[contains($supertype_name_list_with_spaces, concat(' ', @name, ' '))]/explicit">
			<xsl:variable name="raw_attribute_name" select="./@name"/>
			<xsl:variable name="normalized_raw_attribute_name_w_spaces" select="concat(' ', normalize-space($raw_attribute_name), ' ')"/>
			<xsl:choose>
				<xsl:when test="contains($extended_list_of_redeclared_attributes, $normalized_raw_attribute_name_w_spaces)"/>
				<xsl:otherwise>
					<xsl:call-template name="deal_with_attributes">
							<xsl:with-param name="attribute_node_param" select="."/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<xsl:if test="string-length($next_supertype_name_list) &gt; 0">
			<xsl:call-template name="collect_attributes_from_supertypes_but_weed_those_redeclared_lower_down">
				<xsl:with-param name="raw_entity_param" select="$supertypes_list_param"/>
				<xsl:with-param name="redeclared_attributes_param" select="$extended_list_of_redeclared_attributes"/>
				<xsl:with-param name="supertypes_list_param" select="$next_supertype_name_list"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- USED -->
	<xsl:template name="collect_attributes_from_supertypes">
		<xsl:param name="raw_supertype_param"/>
		<xsl:param name="raw_entity_param"/>
		<xsl:for-each select="//entity[@name=$raw_supertype_param]/explicit">
			<xsl:variable name="raw_attribute_name" select="./@name"/>
			<xsl:choose>
				<xsl:when test="$raw_attribute_name=//entity[@name=$raw_entity_param]/explicit/redeclaration/@old_name"/>
				<xsl:otherwise>
					<xsl:variable name="corrected_attribute_name">
						<xsl:call-template name="correct_express_name">
							<xsl:with-param name="raw_express_name_param" select="$raw_attribute_name"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="optionality">
						<xsl:choose>
							<xsl:when test="./@optional = 'YES'">
								<xsl:value-of select="number(0)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="number(1)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="./typename">
							<xsl:variable name="raw_type_name" select="./typename/@name"/>
							<xsl:variable name="corrected_type_name">
								<xsl:call-template name="correct_express_name">
									<xsl:with-param name="raw_express_name_param" select="$raw_type_name"/>
								</xsl:call-template>
							</xsl:variable>
							<xs:element name="{$corrected_attribute_name}" type="{$namespace_prefix}{$corrected_type_name}" minOccurs="{$optionality}"/>
						</xsl:when>
						<xsl:when test="./builtintype">
							<xsl:call-template name="generate_attribute_to_simple_datatype">
								<xsl:with-param name="type_param" select="."/>
								<xsl:with-param name="optionality_param" select="$optionality"/>
								<xsl:with-param name="attribute_name_param" select="$corrected_attribute_name"/>
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<xsl:variable name="next_supertype_name" select="//entity[@name=$raw_supertype_param]/@supertypes"/>
		<xsl:if test="$next_supertype_name">
			<xsl:call-template name="collect_attributes_from_supertypes">
				<xsl:with-param name="raw_supertype_param" select="$next_supertype_name"/>
				<xsl:with-param name="raw_entity_param" select="$raw_supertype_param"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- USED -->
	<xsl:template name="generate_attribute_to_simple_datatype">
		<xsl:param name="type_param"/>
		<xsl:param name="optionality_param"/>
		<xsl:param name="attribute_name_param"/>
		<xsl:choose>
			<xsl:when test="$type_param/builtintype[@type='BINARY' and not(@width)]">
				<xs:element name="{$attribute_name_param}" type="exp:hexBinary" minOccurs="{$optionality_param}"/>
			</xsl:when>
			<xsl:when test="$type_param/builtintype[@type='BINARY' and @width]">
				<xsl:variable name="express_length" select="./builtintype/@width"/>
				<xsl:variable name="schema_length">
					<xsl:choose>
						<xsl:when test="$express_length mod 8 > 0">
							<xsl:value-of select="floor($express_length div 8 + 1)"/>
						</xsl:when>
						<xsl:when test="$express_length mod 8 = 0">
							<xsl:value-of select="$express_length div 8"/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$type_param/builtintype[@type='BINARY' and @fixed='YES']">
						<xs:element name="{$attribute_name_param}" minOccurs="{$optionality_param}">
							<xs:complexType>
								<xs:simpleContent>
									<xs:restriction base="exp:hexBinary">
										<xs:maxLength value="{$schema_length}"/>
										<xs:minLength value="{$schema_length}"/>
										
									</xs:restriction>
								</xs:simpleContent>
							</xs:complexType>
						</xs:element>
					</xsl:when>
					<xsl:when test="$type_param/builtintype[@type='BINARY' and not(@fixed='YES')]">
						<xs:element name="{$attribute_name_param}" minOccurs="{$optionality_param}">
							<xs:complexType>
								<xs:simpleContent>
									<xs:restriction base="exp:hexBinary">
										<xs:maxLength value="{$schema_length}"/>
										
									</xs:restriction>
								</xs:simpleContent>
							</xs:complexType>
						</xs:element>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$type_param/builtintype[@type='BOOLEAN']">
				<xs:element name="{$attribute_name_param}" type="xs:boolean" minOccurs="{$optionality_param}"/>
			</xsl:when>
			<xsl:when test="$type_param/builtintype[@type='LOGICAL']">
				<xs:element name="{$attribute_name_param}" type="exp:logical" minOccurs="{$optionality_param}"/>
			</xsl:when>
			<xsl:when test="$type_param/builtintype[@type='INTEGER']">
				<xs:element name="{$attribute_name_param}" type="xs:long" minOccurs="{$optionality_param}"/>
			</xsl:when>
			<xsl:when test="$type_param/builtintype[@type='NUMBER']">
				<xs:element name="{$attribute_name_param}" type="xs:decimal" minOccurs="{$optionality_param}"/>
			</xsl:when>
			<xsl:when test="$type_param/builtintype[@type='REAL']">
				<xs:element name="{$attribute_name_param}" type="xs:double" minOccurs="{$optionality_param}"/>
			</xsl:when>
			<xsl:when test="$type_param/builtintype[@type='GENERICENTITY']">
				<xsl:comment>NO MAPPING FOR GENERICENTITY DATATYPE</xsl:comment>
			</xsl:when>
			<xsl:when test="$type_param/builtintype[@type='STRING' and not(@width)]">
				<xs:element name="{$attribute_name_param}" type="xs:normalizedString" minOccurs="{$optionality_param}"/>
			</xsl:when>
			<xsl:when test="$type_param/builtintype[@type='STRING' and @width]">
				<xsl:variable name="express_length" select="./builtintype/@width"/>
				<xsl:choose>
					<xsl:when test="$type_param/builtintype[@type='STRING' and @fixed='YES']">
						<xs:element name="{$attribute_name_param}" minOccurs="{$optionality_param}">
							<xs:simpleType>
								<xs:restriction base="xs:normalizedString">
									<xs:maxLength value="{$express_length}"/>
									<xs:minLength value="{$express_length}"/>
								</xs:restriction>
							</xs:simpleType>
						</xs:element>
					</xsl:when>
					<xsl:when test="$type_param/builtintype[@type='STRING' and not(@fixed='YES')]">
						<xs:element name="{$attribute_name_param}" minOccurs="{$optionality_param}">
							<xs:simpleType>
								<xs:restriction base="xs:normalizedString">
									<xs:maxLength value="{$express_length}"/>
								</xs:restriction>
							</xs:simpleType>
						</xs:element>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<!-- USED -->
	<xsl:template name="generate_prefix">
		<xsl:param name="position_param"/>
		<xsl:param name="prefix_param"/>
		<xsl:choose>
			<xsl:when test="$position_param = 1">
				<xsl:value-of select="concat('Seq-', string($prefix_param))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="reduced_position" select="$position_param - 1"/>
				<xsl:call-template name="generate_prefix">
					<xsl:with-param name="position_param" select="$reduced_position"/>
					<xsl:with-param name="prefix_param" select="concat('seq-', string($prefix_param))"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="calculate_lower_bound">
		<xsl:param name="aggregate"/>
		<xsl:variable name="aggregate_upper_bound" select="$aggregate/@upper"/>
		<xsl:variable name="aggregate_lower_bound" select="$aggregate/@lower"/>
		<xsl:choose>
			<xsl:when test="$aggregate/@type='ARRAY'">
				<xsl:choose>
					<xsl:when test="$aggregate/@optional = 'YES'">
						<xsl:value-of select="number(0)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="array_size" select="$aggregate_upper_bound - $aggregate_lower_bound + 1"/>
						<xsl:value-of select="$array_size"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="string-length($aggregate_lower_bound) = 0">
						<xsl:value-of select="number(0)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$aggregate_lower_bound"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- USED -->
	<xsl:template name="calculate_upper_bound">
		<xsl:param name="aggregate"/>
		<xsl:variable name="aggregate_upper_bound" select="$aggregate/@upper"/>
		<xsl:variable name="aggregate_lower_bound" select="$aggregate/@lower"/>
		<xsl:choose>
			<xsl:when test="$aggregate/@type='ARRAY'">
				<xsl:choose>
					<xsl:when test="string($aggregate_upper_bound) = '?'">
						<xsl:value-of select="string('unbounded')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="array_size" select="$aggregate_upper_bound - $aggregate_lower_bound + 1"/>
						<xsl:value-of select="$array_size"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="string-length($aggregate_upper_bound) = 0">
						<xsl:value-of select="string('unbounded')"/>
					</xsl:when>
					<xsl:when test="string($aggregate_upper_bound) = '?'">
						<xsl:value-of select="string('unbounded')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$aggregate_upper_bound"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- USED -->
	<xsl:template name="generate_restriction">
		<xsl:param name="type"/>
		<xsl:choose>
			<xsl:when test="$type/typename">
				<xsl:variable name="raw_type_name" select="$type/typename/@name"/>
				<xsl:variable name="corrected_type_name">
					<xsl:call-template name="correct_express_name">
						<xsl:with-param name="raw_express_name_param" select="$raw_type_name"/>
					</xsl:call-template>
				</xsl:variable>
				<xs:restriction base="{$namespace_prefix}{$corrected_type_name}"/>
			</xsl:when>
			<xsl:when test="$type/builtintype[@type='STRING' and not(@width)]">
				<xs:restriction base="xs:normalizedString"/>
			</xsl:when>
			<xsl:when test="$type/builtintype[@type='BINARY' and not(@width)]">
				<xs:restriction base="exp:hexBinary"/>
			</xsl:when>
			<xsl:when test="$type/builtintype[@type='BINARY' and @width]">
				<xsl:variable name="express_length" select="./builtintype/@width"/>
				<xsl:variable name="schema_length">
					<xsl:choose>
						<xsl:when test="$express_length mod 8 > 0">
							<xsl:value-of select="floor($express_length div 8 + 1)"/>
						</xsl:when>
						<xsl:when test="$express_length mod 8 = 0">
							<xsl:value-of select="$express_length div 8"/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$type/builtintype[@type='BINARY' and @fixed='YES']">
						<xs:restriction base="exp:hexBinary">
							<xs:maxLength value="{$schema_length}"/>
							<xs:minLength value="{$schema_length}"/>
							<xs:attribute use="optional" type="xs:integer" name="extrabits"/>
						</xs:restriction>
					</xsl:when>
					<xsl:when test="$type/builtintype[@type='BINARY' and not(@fixed='YES')]">
						<xs:restriction base="exp:hexBinary">
							<xs:maxLength value="{$schema_length}"/>
							<xs:attribute use="optional" type="xs:integer" name="extrabits"/>
						</xs:restriction>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$type/builtintype[@type='BOOLEAN']">
				<xs:restriction base="xs:boolean"/>
			</xsl:when>
			<xsl:when test="$type/builtintype[@type='LOGICAL']">
				<xs:restriction base="exp:logical"/>
			</xsl:when>
			<xsl:when test="$type/builtintype[@type='NUMBER']">
				<xs:restriction base="xs:decimal"/>
			</xsl:when>
			<xsl:when test="$type/builtintype[@type='INTEGER']">
				<xs:restriction base="xs:long"/>
			</xsl:when>
			<xsl:when test="$type/builtintype[@type='REAL']">
				<xs:restriction base="xs:double"/>
			</xsl:when>
			<xsl:when test="$type/builtintype[@type='STRING' and not(@width)]">
				<xs:restriction base="xs:normalizedString"/>
			</xsl:when>
			<xsl:when test="$type/builtintype[@type='STRING' and @width]">
				<xsl:variable name="express_length" select="./builtintype/@width"/>
				<xsl:choose>
					<xsl:when test="$type/builtintype[@type='STRING' and @fixed='YES']">
						<xs:restriction base="normalizedString">
							<xs:maxLength value="{$express_length}"/>
							<xs:minLength value="{$express_length}"/>
						</xs:restriction>
					</xsl:when>
					<xsl:when test="$type/builtintype[@type='STRING' and not(@fixed='YES')]">
						<xs:restriction base="normalizedString">
							<xs:maxLength value="{$express_length}"/>
						</xs:restriction>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$type/enumeration">
				<xsl:variable name="list_of_items" select="$type/enumeration/@items"/>
				<xs:restriction base="xs:string">
					<xsl:call-template name="recurse_through_enumeration_items">
						<xsl:with-param name="list_of_items_param" select="$list_of_items"/>
					</xsl:call-template>
				</xs:restriction>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<!-- USED -->
	<xsl:template name="generate_immediate_base_datatype">
		<xsl:param name="type"/>
		<xsl:choose>
			<xsl:when test="$type/builtintype[@type='STRING']">
				<xsl:value-of select="string('exp:string-wrapper')"/>
			</xsl:when>
			<xsl:when test="$type/builtintype[@type='BINARY']">
				<xsl:value-of select="string('exp:hexBinary-wrapper')"/>
			</xsl:when>
			<xsl:when test="$type/builtintype[@type='BOOLEAN']">
				<xsl:value-of select="string('exp:boolean-wrapper')"/>
			</xsl:when>
			<xsl:when test="$type/builtintype[@type='LOGICAL']">
				<xsl:value-of select="string('exp:logical-wrapper')"/>
			</xsl:when>
			<xsl:when test="$type/builtintype[@type='NUMBER']">
				<xsl:value-of select="string('exp:decimal-wrapper')"/>
			</xsl:when>
			<xsl:when test="$type/builtintype[@type='INTEGER']">
				<xsl:value-of select="string('exp:long-wrapper')"/>
			</xsl:when>
			<xsl:when test="$type/builtintype[@type='REAL']">
				<xsl:value-of select="string('exp:double-wrapper')"/>
			</xsl:when>
			<xsl:when test="$type/typename">
				<xsl:variable name="typename_name" select="$type/typename/@name"/>
				<xsl:variable name="corrected_type_name">
					<xsl:call-template name="correct_express_name">
							<xsl:with-param name="raw_express_name_param" select="$type/typename/@name"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="//type[@name=$typename_name]/select">
						<xsl:value-of select="concat($namespace_prefix, $corrected_type_name)"/>
					</xsl:when>
					<xsl:when test="//entity[@name=$typename_name]">
						<xsl:value-of select="concat($namespace_prefix, $corrected_type_name)"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<!-- USED -->
	<xsl:template name="generate_fundamental_datatype">
		<xsl:param name="type"/>
		<xsl:choose>
			<xsl:when test="$type/builtintype[@type='STRING']">
				<xsl:value-of select="string('string')"/>
			</xsl:when>
			<xsl:when test="$type/builtintype[@type='BINARY']">
				<xsl:value-of select="string('binary')"/>
			</xsl:when>
			<xsl:when test="$type/builtintype[@type='BOOLEAN']">
				<xsl:value-of select="string('boolean')"/>
			</xsl:when>
			<xsl:when test="$type/builtintype[@type='LOGICAL']">
				<xsl:value-of select="string('logical')"/>
			</xsl:when>
			<xsl:when test="$type/builtintype[@type='NUMBER']">
				<xsl:value-of select="string('number')"/>
			</xsl:when>
			<xsl:when test="$type/builtintype[@type='INTEGER']">
				<xsl:value-of select="string('integer')"/>
			</xsl:when>
			<xsl:when test="$type/builtintype[@type='REAL']">
				<xsl:value-of select="string('real')"/>
			</xsl:when>
			<xsl:when test="$type/typename">
				<xsl:variable name="typename_name" select="$type/typename/@name"/>
				<xsl:choose>
					<xsl:when test="//type[@name=$typename_name]/builtintype">
						<xsl:variable name="underlying_type" select="//type[@name=$typename_name]/builtintype/@type"/>
						<xsl:choose>
							<xsl:when test="$underlying_type='STRING'">
								<xsl:value-of select="string('string')"/>
							</xsl:when>
							<xsl:when test="$underlying_type='BINARY'">
								<xsl:value-of select="string('binary')"/>
							</xsl:when>
							<xsl:when test="$underlying_type='BOOLEAN'">
								<xsl:value-of select="string('boolean')"/>
							</xsl:when>
							<xsl:when test="$underlying_type='LOGICAL'">
								<xsl:value-of select="string('logical')"/>
							</xsl:when>
							<xsl:when test="$underlying_type='NUMBER'">
								<xsl:value-of select="string('number')"/>
							</xsl:when>
							<xsl:when test="$underlying_type='INTEGER'">
								<xsl:value-of select="string('integer')"/>
							</xsl:when>
							<xsl:when test="$underlying_type='REAL'">
								<xsl:value-of select="string('real')"/>
							</xsl:when>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="//type[@name=$typename_name]/select">
						<xsl:value-of select="string('select')"/>
					</xsl:when>
					<xsl:when test="//entity[@name=$typename_name]">
						<xsl:value-of select="string('entity')"/>
					</xsl:when>
					<xsl:when test="//type[@name=$typename_name]/enumeration">
						<xsl:value-of select="string('enumeration')"/>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<!-- USED -->
	<xsl:template name="correct_express_names">
		<xsl:param name="list_of_express_names_param"/>
		<xsl:variable name="wlist_of_items" select="concat(normalize-space($list_of_express_names_param), ' ')"/>
		<xsl:choose>
			<xsl:when test="$wlist_of_items!=' '">
				<xsl:variable name="first" select="substring-before($wlist_of_items, ' ')"/>
				<xsl:variable name="rest" select="substring-after($wlist_of_items, ' ')"/>
				<xsl:variable name="corrected_first">
					<xsl:call-template name="correct_express_name">
						<xsl:with-param name="raw_express_name_param" select="$first"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="concat($corrected_first, ' ')"/>
				<xsl:call-template name="correct_express_names">
					<xsl:with-param name="list_of_express_names_param" select="$rest"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- USED -->
	<xsl:template name="correct_express_name">
		<xsl:param name="raw_express_name_param"/>
		<xsl:variable name="lc_item_name">
			<xsl:call-template name="put_into_lower_case">
				<xsl:with-param name="raw_item_name_param" select="$raw_express_name_param"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="lc_item_name_minus_xml_string">
			<xsl:call-template name="replace_xml_string">
				<xsl:with-param name="lower_case_item_name_param" select="$lc_item_name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="fully_corrected_name">
			<xsl:call-template name="put_first_letter_into_upper_case">
				<xsl:with-param name="lower_case_item_name_minus_xml_param" select="$lc_item_name_minus_xml_string"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="$fully_corrected_name"/>
	</xsl:template>
	
	<!-- USED -->
	<xsl:template name="put_into_lower_case">
		<xsl:param name="raw_item_name_param"/>
		<xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>
		<xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
		<xsl:variable name="lower_case_item_name" select="translate($raw_item_name_param, $UPPER, $LOWER)"/>
		<xsl:value-of select="$lower_case_item_name"/>
	</xsl:template>
	
	<!-- USED -->
	<xsl:template name="replace_xml_string">
		<xsl:param name="lower_case_item_name_param"/>
		<xsl:choose>
			<xsl:when test="starts-with($lower_case_item_name_param, 'xml')">
				<xsl:value-of select="concat('x-m-l', substring-after($lower_case_item_name_param, 'xml'))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$lower_case_item_name_param"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- USED -->
	<xsl:template name="put_first_letter_into_upper_case">
		<xsl:param name="lower_case_item_name_minus_xml_param"/>
		<xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>
		<xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
		<xsl:variable name="length_of_item_name" select="string-length($lower_case_item_name_minus_xml_param)"/>
		<xsl:variable name="initial_letter" select="substring($lower_case_item_name_minus_xml_param, 1, 1)"/>
		<xsl:variable name="rest_of_name" select="substring($lower_case_item_name_minus_xml_param, 2, $length_of_item_name)"/>
		<xsl:variable name="capitalized_initial_letter" select="translate($initial_letter, $LOWER, $UPPER)"/>
		<xsl:value-of select="concat($capitalized_initial_letter, $rest_of_name)"/>
	</xsl:template>
	
	<!-- USED -->
	<xsl:template name="recurse_through_enumeration_items">
		<xsl:param name="list_of_items_param"/>
		<xsl:variable name="wlist_of_items" select="concat(normalize-space($list_of_items_param), ' ')"/>
		<xsl:choose>
			<xsl:when test="$wlist_of_items!=' '">
				<xsl:variable name="first" select="substring-before($wlist_of_items, ' ')"/>
				<xsl:variable name="rest" select="substring-after($wlist_of_items, ' ')"/>
				<xs:enumeration value="{$first}"/>
				<xsl:call-template name="recurse_through_enumeration_items">
					<xsl:with-param name="list_of_items_param" select="$rest"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- USED -->
	<xsl:template name="recurse_through_subtype_tree">
		<xsl:param name="raw_node_name_param"/>
		<xsl:variable name="subtypes_still_exist">
			<xsl:for-each select="//entity/@supertypes">
				<xsl:if test="contains(concat(' ', normalize-space(.), ' '), concat(' ', $raw_node_name_param, ' '))">YES</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="contains($subtypes_still_exist, 'YES')">
				<xsl:for-each select="//entity[contains(concat(' ', normalize-space(@supertypes), ' '), concat(' ', $raw_node_name_param, ' '))]/@name">
					<xsl:variable name="raw_subtype_name" select="."/>
					<!-- xsl:choose>
						<xsl:when test="//entity[@name=$raw_subtype_name]/@abstract.supertype='YES'"></xsl:when>
						<xsl:otherwise -->
							
							<xsl:variable name="corrected_subtype_name">
								<xsl:call-template name="correct_express_name">
									<xsl:with-param name="raw_express_name_param" select="$raw_subtype_name"/>
								</xsl:call-template>
							</xsl:variable>
							<xs:group ref="{$namespace_prefix}{$corrected_subtype_name}-group"/>
							<!-- /xsl:otherwise>
					</xsl:choose -->
						<!-- xsl:call-template name="recurse_through_subtype_tree">
								<xsl:with-param name="raw_node_name_param" select="$raw_subtype_name"/>
							</xsl:call-template -->
						
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	
	<!-- USED -->
	<xsl:template name="build_working_select_list">
		<xsl:param name="list_of_items_param"/>
		<xsl:variable name="wlist_of_items" select="concat(normalize-space($list_of_items_param), ' ')"/>
		<xsl:choose>
			<xsl:when test="$wlist_of_items!=' '">
				<xsl:variable name="first" select="substring-before($wlist_of_items, ' ')"/>
				<xsl:variable name="rest" select="substring-after($wlist_of_items, ' ')"/>
				<xsl:choose>
					<xsl:when test="//type[@name=$first]/select">
						<xsl:call-template name="build_working_select_list">
							<xsl:with-param name="list_of_items_param" select="//type[@name=$first]/select/@selectitems"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="//entity[@name=$first]">
						<xsl:value-of select="concat($first, ' ')"/>
						<xsl:call-template name="get_subtypes_in_select">
							<xsl:with-param name="raw_entity_name_param" select="$first"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat($first, ' ')"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:call-template name="build_working_select_list">
					<xsl:with-param name="list_of_items_param" select="$rest"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	
	<!-- USED -->
	<xsl:template name="construct_select_elements">
		<xsl:param name="complete_list_of_items_param"/>
		<xsl:variable name="wcomplete_list_of_items" select="concat(normalize-space($complete_list_of_items_param), ' ')"/>
		<xsl:choose>
			<xsl:when test="$wcomplete_list_of_items!=' '">
				<xsl:variable name="first" select="substring-before($wcomplete_list_of_items, ' ')"/>
				<xsl:variable name="rest" select="substring-after($wcomplete_list_of_items, ' ')"/>
				
				<xsl:variable name="corrected_select_item_name">
					<xsl:call-template name="correct_express_name">
						<xsl:with-param name="raw_express_name_param" select="$first"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="//entity[@name=$first]">
						<xs:element ref="{$namespace_prefix}{$corrected_select_item_name}"/>
					</xsl:when>
					<xsl:when test="//type[@name=$first]">
						<xs:element ref="{$namespace_prefix}{$corrected_select_item_name}-wrapper"/>
					</xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
				
				<xsl:call-template name="construct_select_elements">
					<xsl:with-param name="complete_list_of_items_param" select="$rest"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	
	<!-- USED -->
	<xsl:template name="get_subtypes_in_select">
		<xsl:param name="raw_entity_name_param"/>
		<xsl:variable name="entity_node" select="//entity[@name =$raw_entity_name_param]"/>
		<xsl:for-each select="//entity[contains(concat(' ', @supertypes, ' '), concat(' ', $raw_entity_name_param, ' '))]">
			<xsl:variable name="subtype_name" select="./@name"/>
			<xsl:value-of select="concat($subtype_name, ' ')"/>
			<xsl:choose>
				<xsl:when test="$subtype_name">
					<xsl:call-template name="get_subtypes_in_select">
						<xsl:with-param name="raw_entity_name_param" select="$subtype_name"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	
	<!-- USED -->
	<xsl:template name="subtract-forbidden-word-list-from-main-word-list" >
		<xsl:param name="forbidden-list" />
		<xsl:param name="main-list" />
		<!-- outputs all words from main-word-list that are NOT in forbidden-list -->
		<!-- get first item in list -->
		<xsl:variable name="first" select="substring-before(concat(normalize-space($main-list), ' '), ' ')"/>
		<xsl:if test="$first">
			<xsl:if test="not(contains(concat(' ', $forbidden-list, ' '),concat(' ', $first, ' ')))">
				<xsl:value-of select="concat(' ',$first,' ')"/> 
			</xsl:if>
			<xsl:call-template name="subtract-forbidden-word-list-from-main-word-list">
				<xsl:with-param name="forbidden-list" select="$forbidden-list"/>
				<xsl:with-param name="main-list" select="substring-after($main-list, $first)"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- USED -->
	<xsl:template name="filter-word-list-unique" >
		<xsl:param name="word-list" />
		<xsl:variable name="first" select="substring-before(concat(normalize-space($word-list),' '),' ')" />
		<xsl:variable name="rest" select="substring-after($word-list,$first)" />
		<xsl:if test="$first" >
			<xsl:if test="not( contains(concat(' ',$rest,' '),concat(' ',$first,' ')))" >
				<xsl:value-of select="concat(' ',$first,' ')" /> 
			</xsl:if>
			<xsl:call-template name="filter-word-list-unique">
				<xsl:with-param name="word-list" select="$rest" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- USED -->
	<xsl:template name="remove_names_of_abstract_entities_from_list">
		<xsl:param name="list_of_selected_datatypes_param"/>
		<xsl:variable name="first" select="substring-before(concat(normalize-space($list_of_selected_datatypes_param),' '),' ')" />
		<xsl:variable name="rest" select="substring-after($list_of_selected_datatypes_param,$first)" />
		<xsl:if test="$first">
			<xsl:if test="not(//entity[@name=$first]/@abstract.supertype='YES')" >
				<xsl:value-of select="concat(' ',$first,' ')" /> 
			</xsl:if>
			<xsl:call-template name="remove_names_of_abstract_entities_from_list">
				<xsl:with-param name="list_of_selected_datatypes_param" select="$rest" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- USED NEW -->
	<xsl:template name="remove_subtypes_of_concrete_entities_from_list">
		<xsl:param name="list_of_selected_datatypes_param"/>
		<xsl:param name="fixed_list_of_selected_datatypes_param"/>
		<xsl:variable name="first" select="substring-before(concat(normalize-space($list_of_selected_datatypes_param),' '),' ')" />
		<xsl:variable name="rest" select="substring-after($list_of_selected_datatypes_param,$first)" />
		<xsl:variable name="supertypes" select="//entity[@name=$first]/@supertypes"/>
		<xsl:variable name="has_concrete_supertype">
			<xsl:call-template name="go_thru_list_of_supertypes_and_generate_llist_entry_if_appropriate">
				<xsl:with-param name="supertypes" select="$supertypes" />
				<xsl:with-param name="fixed_list_of_selected_datatypes_param" select="$fixed_list_of_selected_datatypes_param"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="$first">
			<xsl:choose>
				<xsl:when test="contains($has_concrete_supertype, 'YES')"></xsl:when>
				<xsl:otherwise><xsl:value-of select="concat(' ',$first,' ')" /></xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="remove_subtypes_of_concrete_entities_from_list">
				<xsl:with-param name="list_of_selected_datatypes_param" select="$rest" />
				<xsl:with-param name="fixed_list_of_selected_datatypes_param" select="$fixed_list_of_selected_datatypes_param" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- USED NEW -->
	<xsl:template name="go_thru_list_of_supertypes_and_generate_llist_entry_if_appropriate">
		<xsl:param name="supertypes"/>
		<xsl:param name="fixed_list_of_selected_datatypes_param"/>
		<xsl:variable name="first" select="substring-before(concat(normalize-space($supertypes),' '),' ')" />
		<xsl:variable name="rest" select="substring-after($supertypes,$first)" />
		<xsl:if test="$first">
			<xsl:if test="contains($fixed_list_of_selected_datatypes_param, concat(' ',$first,' '))">
				<xsl:value-of select="' YES'"/> 
			</xsl:if>
			<xsl:call-template name="go_thru_list_of_supertypes_and_generate_llist_entry_if_appropriate">
				<xsl:with-param name="supertypes" select="$rest" />
				<xsl:with-param name="fixed_list_of_selected_datatypes_param" select="$fixed_list_of_selected_datatypes_param"/>
				
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- USED -->									
	<xsl:template name="get_list_type_name">
		<xsl:param name="list_type_name_param"/>
		<xsl:choose>
			<xsl:when test="$list_type_name_param='STRING'">
				<xsl:value-of select="string('string')"/>
			</xsl:when>
			<xsl:when test="$list_type_name_param='BINARY'">
				<xsl:value-of select="string('hexBinary')"/>
			</xsl:when>
			<xsl:when test="$list_type_name_param='BOOLEAN'">
				<xsl:value-of select="string('boolean')"/>
			</xsl:when>
			<xsl:when test="$list_type_name_param='LOGICAL'">
				<xsl:value-of select="string('logical')"/>
			</xsl:when>
			<xsl:when test="$list_type_name_param='NUMBER'">
				<xsl:value-of select="string('decimal')"/>
			</xsl:when>
			<xsl:when test="$list_type_name_param='INTEGER'">
				<xsl:value-of select="string('long')"/>
			</xsl:when>
			<xsl:when test="$list_type_name_param='REAL'">
				<xsl:value-of select="string('double')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="correct_express_name">
						<xsl:with-param name="raw_express_name_param" select="$list_type_name_param"/>
					</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
</xsl:template>

</xsl:stylesheet>
