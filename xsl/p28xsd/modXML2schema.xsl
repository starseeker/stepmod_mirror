<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:variable name="namespace_prefix" select="string('ap239:')"/>
	<xsl:variable name="schema_name" select="string('Product_life_cycle_support')"/>
		
	<xsl:template match="/">
		<xsl:apply-templates select="express"/>
	</xsl:template>
		
	<xsl:template match="express">
		<xsl:apply-templates select="schema"/>
	</xsl:template>
	
	<xsl:template match="schema">
		<xsl:text>&#xa;</xsl:text>
		
		<xs:schema 
			targetNamespace="urn:iso10303-28:xs/{$schema_name}"
  			xmlns:ex="urn:iso10303-28:ex" 
  			xmlns:xs="http://www.w3.org/2001/XMLSchema"
  			xmlns:ap239="urn:iso10303-28:xs/{$schema_name}"
		>
			<xsl:text>&#xa;</xsl:text>
			
			<xs:import namespace="urn:iso10303-28:ex" schemaLocation="../../../dtd/part28/ex.xsd"/>
			
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			
			<xs:complexType name="uos">
				<xs:complexContent>
					<xs:restriction base="ex:uos">
						<xs:choice maxOccurs="unbounded" minOccurs="0">
						<xsl:for-each select="//entity">
							<xsl:variable name="raw_entity_name" select="./@name"/>
							<xsl:choose>
								<xsl:when test="./@abstract.supertype='YES'">
								</xsl:when>
								<xsl:when test="@abstract.entity='YES'">
								</xsl:when>
								<xsl:when test="//subtype.constraint[@abstract.supertype='YES']/@entity=$raw_entity_name">
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="corrected_entity_name">
										<xsl:call-template name="put_into_lower_case">
											<xsl:with-param name="raw_item_name_param" select="$raw_entity_name"/>
										</xsl:call-template>
									</xsl:variable>
									<xs:element ref="{$namespace_prefix}{$corrected_entity_name}"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
						</xs:choice>
					</xs:restriction>
				</xs:complexContent>
			</xs:complexType>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>&#xa;</xsl:text>

			<xsl:apply-templates select="type"/>
			<xsl:apply-templates select="entity" mode="elements_and_types"/>
			<xs:element substitutionGroup="ex:uos" type="{$namespace_prefix}uos" name="uos" >
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				<xsl:apply-templates select="entity" mode="keys"/>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				<xsl:apply-templates select="entity/explicit[typename/@name = //entity/@name]" mode="keys"/>
			</xs:element>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>&#xa;</xsl:text>
		</xs:schema>
	</xsl:template>
	
	<xsl:template match="explicit" mode="keys">
		<xsl:variable name="raw_entity_name" select="../@name"/>
		<xsl:variable name="raw_attribute_name" select="./@name"/>
		<xsl:variable name="raw_target_name" select="./typename/@name"/>
		<xsl:variable name="corrected_entity_name">
			<xsl:call-template name="put_into_lower_case">
				<xsl:with-param name="raw_item_name_param" select="$raw_entity_name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="corrected_attribute_name">
			<xsl:call-template name="put_into_lower_case">
				<xsl:with-param name="raw_item_name_param" select="$raw_attribute_name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="corrected_target_name">
			<xsl:call-template name="put_into_lower_case">
				<xsl:with-param name="raw_item_name_param" select="$raw_target_name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="subtypes_of_target_exist">
			<xsl:for-each select="//entity/@supertypes">
				<xsl:if test="contains(concat(' ', normalize-space(.), ' '), concat(' ', $raw_target_name, ' '))">YES</xsl:if>
			</xsl:for-each>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="contains($subtypes_of_target_exist, 'YES')">
				<xs:keyref name="{$corrected_entity_name}___{$corrected_attribute_name}-keyref" refer="{$namespace_prefix}{$schema_name}___Product_category-keysub">
					<xs:selector xpath=".//{$namespace_prefix}{$corrected_target_name}/{$corrected_attribute_name}"/>
					<xs:field xpath="@ref"/>
				</xs:keyref>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>&#xa;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xs:keyref name="{$corrected_entity_name}___{$corrected_attribute_name}-keyref"  refer="{$namespace_prefix}{$schema_name}___	{$corrected_target_name}-key">
					<xs:selector xpath=".//{$namespace_prefix}{$corrected_target_name}/{$corrected_attribute_name}"/>
					<xs:field xpath="@ref" />
				</xs:keyref>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>&#xa;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="entity" mode="keys">
		<xsl:variable name="raw_entity_name" select="./@name"/>
			
		<xsl:variable name="corrected_entity_name">
			<xsl:call-template name="put_into_lower_case">
				<xsl:with-param name="raw_item_name_param" select="$raw_entity_name"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:comment>EXPRESS ENTITY DATATYPE KEY DECLARATION FOR: <xsl:value-of select="$corrected_entity_name"/></xsl:comment>
		<xsl:text>&#xa;</xsl:text>
		<xs:key name="{$schema_name}___{$corrected_entity_name}-key">
			<xs:selector xpath="{$namespace_prefix}{$corrected_entity_name}" />
			<xs:field xpath="@id" />
		</xs:key>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>&#xa;</xsl:text>

		<xsl:comment>EXPRESS ENTITY DATATYPE KEYREF DECLARATION FOR: <xsl:value-of select="$corrected_entity_name"/></xsl:comment>
		<xsl:text>&#xa;</xsl:text>
 		<xs:keyref name="{$schema_name}___{$corrected_entity_name}-keyref" refer="{$namespace_prefix}{$schema_name}___{$corrected_entity_name}-key">
				<xs:selector xpath=".//{$namespace_prefix}{$corrected_entity_name}"/>
			<xs:field xpath="@ref"/>
		</xs:keyref>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		
		<xsl:variable name="subtypes_list">
			<!-- xsl:for-each select="//entity/@supertypes">
				<xsl:variable name="supertypes" select="."/>
				<xsl:if test="contains(concat(' ', normalize-space($supertypes), ' '), concat(' ', $raw_entity_name, ' '))">
					<xsl:value-of select="concat(../@name, ' ')"/>
				</xsl:if>
			</xsl:for-each -->
			
			
			
			<xsl:call-template name="collect_subtypes">
				<xsl:with-param name="top_entity_name_param" select="$raw_entity_name"/>
			</xsl:call-template>
			
		</xsl:variable>

		<xsl:if test="string-length($subtypes_list)!=0">
			<xsl:comment>EXPRESS ENTITY DATATYPE WITH SUBTYPES KEY DECLARATION FOR: <xsl:value-of select="$corrected_entity_name"/>				</xsl:comment>
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
	</xsl:template>
	
	<!-- DEAL WITH NON-ENTITY EXPRESS DATATYPES -->
	<xsl:template match="type">
		<xsl:variable name="raw_type_name" select="./@name"/>
		<xsl:variable name="corrected_type_name">
			<xsl:call-template name="put_into_lower_case">
				<xsl:with-param name="raw_item_name_param" select="$raw_type_name"/>
			</xsl:call-template>
		</xsl:variable>
	
		<xsl:choose>
			<xsl:when test="./select">
				<xsl:variable name="list_of_items" select="./select/@selectitems"/>
					
							<xsl:comment>EXPRESS SELECT DATATYPE TYPE DECLARATION FOR: <xsl:value-of 	select="$corrected_type_name"/></xsl:comment><xsl:text>&#xa;</xsl:text>
	
							<xs:complexType name="{$corrected_type_name}">
								<xs:group ref="{$namespace_prefix}{$corrected_type_name}"/>
							</xs:complexType>
							<xsl:text>&#xa;</xsl:text>
							<xsl:text>&#xa;</xsl:text>
			
							<xsl:comment>EXPRESS SELECT DATATYPE GROUP DECLARATION FOR: <xsl:value-of 			select="$corrected_type_name"/></xsl:comment><xsl:text>&#xa;</xsl:text>
							<xs:group name="{$corrected_type_name}">
								<xs:choice>
									<xsl:call-template name="recurse_through_select_items">
										<xsl:with-param name="list_of_items_param" select="$list_of_items"/>
									</xsl:call-template>
								</xs:choice>
							</xs:group>
							<xsl:text>&#xa;</xsl:text>
							<xsl:text>&#xa;</xsl:text>
	
				
							</xsl:when>
			
			<xsl:when test="./aggregate">
				<xsl:variable name="base_datatype">
					<xsl:call-template name="generate_base_datatype">
						<xsl:with-param name="type" select="."/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:for-each select="./aggregate">
					<xsl:variable name="next_datatype_down">
						<xsl:value-of select="following-sibling::aggregate/@type"/>
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
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="seq_prefix">
						<xsl:call-template name="generate_prefix">
							<xsl:with-param name="position_param" select="last() - position() + 1"/>
							<xsl:with-param name="prefix_param" select="string('')"/>
						</xsl:call-template>
					</xsl:variable>
					
					
					<xsl:choose>
						<xsl:when test="position()=1 and position()=last()">
						
						<xsl:comment>EXPRESS AGGREGATE DATATYPE ELEMENT DECLARATION FOR: <xsl:value-of select="$corrected_type_name"/></xsl:comment>
							<xsl:text>&#xa;</xsl:text>
							
							<xs:element name="{$corrected_type_name}" nillable="true">
								<xs:complexType>
									<xs:complexContent>
										<xs:extension base="{$namespace_prefix}{$corrected_type_name}">
											<xs:attributeGroup ref="ex:instanceAttributes"/>
										</xs:extension>
									</xs:complexContent>
								</xs:complexType>
							</xs:element>
							<xsl:text>&#xa;</xsl:text>
							<xsl:text>&#xa;</xsl:text>
							
							<xsl:comment>EXPRESS AGGREGATE DATATYPE TYPE DECLARATION FOR: <xsl:value-of select="$corrected_type_name"/></xsl:comment>
							<xsl:text>&#xa;</xsl:text>
							
									
							<xs:complexType name="{$corrected_type_name}">
								<xs:sequence>
									<xsl:choose>
										<xsl:when test="./typename/@name=//type[select]/@name">
											<xs:group 
												ref="{$base_datatype}"
												minOccurs="{$lower_bound}" 
												maxOccurs="{$upper_bound}"
											/>
										</xsl:when>
										<xsl:otherwise>
											<xs:element 
												ref="{$base_datatype}" 
												minOccurs="{$lower_bound}"
												maxOccurs="{$upper_bound}"
											/>
										</xsl:otherwise>
									</xsl:choose>
								</xs:sequence>
								<xs:attribute name="ref" type="xs:IDREF" use="optional"/>
								<xsl:choose>
									<xsl:when test="$current_aggregate_type='array'">
										<xs:attribute ref="ex:arraySize" fixed="{$upper_bound}"/>
									</xsl:when>
									<xsl:when test="$current_aggregate_type='array'">
										<xs:attribute ref="ex:arraySize" use="required"/>
									</xsl:when>
									<xsl:otherwise>
										<xs:attribute ref="ex:arraySize" use="optional"/>
									</xsl:otherwise>
								</xsl:choose>
								
								<xs:attribute ref="ex:itemType" fixed="{$base_datatype}"/>
								<xs:attribute ref="ex:cType" fixed="{$current_aggregate_type}"/>
														
							</xs:complexType>							
							<xsl:text>&#xa;</xsl:text>
							<xsl:text>&#xa;</xsl:text>
						</xsl:when>
						
						<xsl:when test="position()=1 and position()!=last()">
												
							<!-- xsl:comment>EXPRESS AGGREGATE DATATYPE TYPE DECLARATION FOR: <xsl:value-of select="$corrected_type_name"/></xsl:comment>
							<xs:complexType name="{$corrected_type_name}">
								<xs:sequence>
									<xs:element 
										ref="ap239:{$seq_prefix}{$base_datatype}" 
										minOccurs="{$lower_bound}"
										maxOccurs="{$upper_bound}"
									/>
								</xs:sequence>
								<xs:attribute ref="ex:itemType" fixed="ap239:{$seq_prefix}{$base_datatype}"/>
								<xs:attribute ref="ex:cType" fixed="{$current_aggregate_type}"/>
								<xs:attribute ref="ex:arraySize" use="{$optionality}"/>
							</xs:complexType>
							<xsl:text>&#xa;</xsl:text>
							<xsl:text>&#xa;</xsl:text>
						</xsl:when>
						<xsl:when test="position()!=1 and position()!=last()">
					
							<xsl:comment>EXPRESS AGGREGATE DATATYPE TYPE DECLARATION FOR: <xsl:value-of select="$corrected_type_name"/></xsl:comment>
							
								<xs:complexType name="{$seq_prefix}{$base_datatype}">
									<xs:sequence>
										<xs:element 
											ref="ap239:{$seq_prefix}{$base_datatype}" 
											minOccurs="{$lower_bound}"
											maxOccurs="{$upper_bound}"
										/>
									</xs:sequence>
									<xs:attribute ref="ex:itemType" fixed="ap239:{$seq_prefix}{$base_datatype}"/>
									<xs:attribute ref="ex:cType" fixed="{$current_aggregate_type}"/>
									<xs:attribute ref="ex:arraySize" use="{$optionality}"/>													</xs:complexType>
						
							
							<xsl:text>&#xa;</xsl:text>
							<xsl:text>&#xa;</xsl:text -->
						</xsl:when>
						
						<xsl:when test="position()=last()">
													
							<!-- xsl:comment>EXPRESS AGGREGATE DATATYPE TYPE DECLARATION FOR: <xsl:value-of select="$corrected_type_name"/></xsl:comment>
							
								<xs:complexType name="{$seq_prefix}{$base_datatype}">
									<xs:sequence>
										<xs:element 
											ref="ap239:{$seq_prefix}{$base_datatype}" 
											minOccurs="{$lower_bound}"
											maxOccurs="{$upper_bound}"
										/>
									</xs:sequence>
									<xs:attribute ref="ex:itemType" fixed="ap239:{$seq_prefix}{$base_datatype}"/>
									<xs:attribute ref="ex:cType" fixed="{$current_aggregate_type}"/>
									<xs:attribute ref="ex:arraySize" use="{$optionality}"/>
								</xs:complexType>
			
							<xsl:text>&#xa;</xsl:text>
							<xsl:text>&#xa;</xsl:text -->
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			
			<xsl:when test="./typename/@name=//type[select]/@name">
				<xsl:variable name="raw_select_type_name" select="./typename/@name"/>
				<xsl:variable name="corrected_underlying_select_type_name">
					<xsl:call-template name="put_into_lower_case">
						<xsl:with-param name="raw_item_name_param" select="$raw_select_type_name"/>
					</xsl:call-template>
				</xsl:variable>
				
				<xsl:comment>EXPRESS DEFINED DATATYPE ELEMENT DECLARATION FOR: <xsl:value-of select="$corrected_type_name"/></xsl:comment>
				<xsl:text>&#xa;</xsl:text>
				
				<xs:element name="{$corrected_type_name}" nillable="true">
					<xs:complexType>
						<xs:complexContent>
							<xs:extension base="{$namespace_prefix}{$corrected_type_name}">
								<xs:attributeGroup ref="ex:instanceAttributes"/>
							</xs:extension>
						</xs:complexContent>
					</xs:complexType>
				</xs:element>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				
				<xsl:comment>EXPRESS DEFINED DATATYPE ELEMENT DECLARATION FOR: <xsl:value-of select="$corrected_type_name"/></xsl:comment>
				<xsl:text>&#xa;</xsl:text>

				
				<xs:complexType name = "{$corrected_type_name}">
					<xs:complexContent>
						<xs:restriction base="{$namespace_prefix}{$corrected_underlying_select_type_name}"/>
					</xs:complexContent>
				</xs:complexType>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>&#xa;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:comment>EXPRESS DEFINED DATATYPE ELEMENT DECLARATION FOR: <xsl:value-of select="$corrected_type_name"/></xsl:comment>
				<xsl:text>&#xa;</xsl:text>
				<xs:element name="{$corrected_type_name}" nillable="true">
					<xs:complexType>
						<xs:simpleContent>
							<xs:extension base="{$namespace_prefix}{$corrected_type_name}">
								<xs:attributeGroup ref="ex:instanceAttributes"/>
							</xs:extension>
						</xs:simpleContent>
					</xs:complexType>
				</xs:element>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				
			
				<xsl:comment>EXPRESS DEFINED DATATYPE TYPE DECLARATION FOR: <xsl:value-of select="$corrected_type_name"/></xsl:comment>
				<xsl:text>&#xa;</xsl:text>
				<xs:simpleType name = "{$corrected_type_name}">
					<xsl:call-template name="generate_restriction">
						<xsl:with-param name="type" select="."/>
					</xsl:call-template>
				</xs:simpleType>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>&#xa;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- DEAL WITH ENTITY EXPRESS DATATYPES HERE-->
	
	<xsl:template match="entity" mode="elements_and_types">
		
		<xsl:variable name="raw_entity_name" select="./@name"/>
			
		<xsl:variable name="corrected_entity_name">
			<xsl:call-template name="put_into_lower_case">
				<xsl:with-param name="raw_item_name_param" select="$raw_entity_name"/>
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
						<xsl:when test="./@abstract.entity='YES'">true</xsl:when>
						<xsl:when test="//subtype.constraint[@entity=$raw_entity_name and @abstract.supertype='YES']">true</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="part_of_multiple_inheritance_graph">
			<xsl:call-template name="check_whether_part_of_multiple_inheritance_graph">
					<xsl:with-param name="raw_entity_param" select="$raw_entity_name"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$part_of_multiple_inheritance_graph='true'">
				<xsl:call-template name="inheritance-free_mapping">
					<xsl:with-param name="raw_entity_name_param" select="$raw_entity_name"/>
					<xsl:with-param name="corrected_entity_name_param" select="$corrected_entity_name"/>
					<xsl:with-param name="abstractness_param" select="$abstractness"/>
					<xsl:with-param name="base_type_of_optional_array_param" select="$base_type_of_optional_array"/>
					<xsl:with-param name="raw_supertype_name_param" select="$raw_supertypes_list"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="inheritance_mapping">
					<xsl:with-param name="raw_entity_name_param" select="$raw_entity_name"/>
					<xsl:with-param name="corrected_entity_name_param" select="$corrected_entity_name"/>
					<xsl:with-param name="abstractness_param" select="$abstractness"/>
					<xsl:with-param name="raw_supertype_name_param" select="$raw_supertypes_list"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="inheritance-free_mapping">
		<xsl:param name="raw_entity_name_param"/>
		<xsl:param name="corrected_entity_name_param"/>
		<xsl:param name="abstractness_param"/>
		<xsl:param name="base_type_of_optional_array_param"/>
		<xsl:param name="raw_supertype_name_param"/>

		<xsl:variable name="corrected_supertype_name">
			<xsl:call-template name="put_into_lower_case">
				<xsl:with-param name="raw_item_name_param" select="$raw_supertype_name_param"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="ext_base_sub_grp">
			<xsl:choose>
				<xsl:when test="$raw_supertype_name_param">
					<xsl:value-of select="concat($namespace_prefix, $corrected_supertype_name)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="string('ex:Entity')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$base_type_of_optional_array_param='true'">
			</xsl:when>
			<xsl:when test="$base_type_of_optional_array_param='false'">
				<xsl:comment>EXPRESS ENTITY DATATYPE WITH MULTIPLE INHERITANCE: xsd element declaration for <xsl:value-of select="$corrected_entity_name_param"/></xsl:comment>
				<xs:element
					name="{$corrected_entity_name_param}" 
					type="{$namespace_prefix}{$corrected_entity_name_param}" 
					nillable="true">
				</xs:element>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				
				<xsl:comment>EXPRESS ENTITY DATATYPE WITH MULTIPLE INHERITANCE: xsd complexType declaration for <xsl:value-of select="$corrected_entity_name_param"/></xsl:comment>
				<xs:complexType name="{$corrected_entity_name_param}" abstract="{$abstractness_param}">
			<xs:complexContent>
				<xs:extension base="ex:Entity">
					<xsl:if test="./explicit">
						<xs:all>
							<xsl:apply-templates select="explicit"/>
						</xs:all>
					</xsl:if>
				</xs:extension>
			</xs:complexContent>
		</xs:complexType>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		

			</xsl:when>
		</xsl:choose>
		<xsl:comment>EXPRESS ENTITY DATATYPE WITH MULTIPLE INHERITANCE: xsd group declaration for <xsl:value-of select="$corrected_entity_name_param"/></xsl:comment>
		<xsl:variable name="subtypes_exist">
			<xsl:for-each select="//entity/@supertypes">
				<xsl:if test="contains(concat(' ', normalize-space(.), ' '), concat(' ', $raw_entity_name_param, ' '))">YES</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="contains($subtypes_exist, 'YES')">
				<xs:group name="{$corrected_entity_name_param}-group">
					<xs:choice>
						<xs:element ref="{$namespace_prefix}{$corrected_entity_name_param}"/>
						<xsl:call-template name="recurse_through_subtype_tree">
							<xsl:with-param name="raw_node_name_param" select="$raw_entity_name_param"/>
						</xsl:call-template>
					</xs:choice>
				</xs:group>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="inheritance_mapping">
		<xsl:param name="raw_entity_name_param"/>
		<xsl:param name="corrected_entity_name_param"/>
		<xsl:param name="abstractness_param"/>
		<xsl:param name="raw_supertype_name_param"/>
		
		<xsl:variable name="corrected_supertype_name">
			<xsl:call-template name="put_into_lower_case">
				<xsl:with-param name="raw_item_name_param" select="$raw_supertype_name_param"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="ext_base_sub_grp">
			<xsl:choose>
				<xsl:when test="$raw_supertype_name_param">
					<xsl:value-of select="concat($namespace_prefix, $corrected_supertype_name)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="string('ex:Entity')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:comment>EXPRESS ENTITY DATATYPE WITHOUT MULTIPLE INHERITANCE ELEMENT DECLARATION FOR: <xsl:value-of select="$corrected_entity_name_param"/></xsl:comment><xsl:text>&#xa;</xsl:text>

		
		<xs:element 
			name="{$corrected_entity_name_param}" 
			type="{$namespace_prefix}{$corrected_entity_name_param}" 
			substitutionGroup="{$ext_base_sub_grp}"
			nillable="true">
		</xs:element>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:comment>EXPRESS ENTITY DATATYPE WITHOUT MULTIPLE INHERITANCE TYPE DECLARATION FOR: <xsl:value-of select="$corrected_entity_name_param"/></xsl:comment><xsl:text>&#xa;</xsl:text>

		<xs:complexType name="{$corrected_entity_name_param}" abstract="{$abstractness_param}">
			<xs:complexContent>
				<xs:extension base="{$ext_base_sub_grp}">
					<xsl:if test="./explicit">
						<xs:sequence><xsl:text>&#xa;</xsl:text>
							<xsl:apply-templates select="explicit"/>
						</xs:sequence>
					</xsl:if>
				</xs:extension>
			</xs:complexContent>
		</xs:complexType>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		
					
		<xsl:if test="./explicit/redeclaration">
			<xsl:comment>EXPRESS ENTITY DATATYPE  WITHOUT MULTIPLE INHERITANCE BUT WITH REDECLARED ATTRIBUTES TYPE DECLARATION FOR: <xsl:value-of select="$corrected_entity_name_param"/></xsl:comment>
			<xsl:text>&#xa;</xsl:text>
			<xs:complexType name="{$corrected_entity_name_param}-temp" abstract="true">
				<xs:complexContent>
					<xs:restriction base="{$namespace_prefix}{$corrected_supertype_name}">
						<xs:sequence>
							<xsl:call-template name="collect_attributes_from_supertypes">
								<xsl:with-param name="raw_supertype_param" select="$raw_supertype_name_param"/>
								<xsl:with-param name="raw_entity_param" select="$raw_entity_name_param"/>
							</xsl:call-template>
							<xsl:for-each select="./explicit/redeclaration[not(@old_name)]">
								<xsl:variable name="raw_attribute_name" select="../@name"/>
								<xsl:variable name="corrected_attribute_name">
									<xsl:call-template name="put_into_lower_case">
										<xsl:with-param name="raw_item_name_param" select="$raw_attribute_name"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:variable name="optionality">
									<xsl:if test="../@optional = 'YES'">
										<xsl:value-of select="number(0)"/>
									</xsl:if>
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="../builtintype">
										<xsl:variable name="attribute" select=".."/>
										<xsl:call-template name="generate_attribute_to_simple_datatype">
											<xsl:with-param name="type_param" select=".."/>
											<xsl:with-param name="optionality_param" select="$optionality"/>
											<xsl:with-param name="attribute_name_param" select="$corrected_attribute_name"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:when test="../typename">
										<xsl:variable name="target" select="../typename/@name"/>
										<xsl:variable name="corrected_target_name">
											<xsl:call-template name="put_into_lower_case">
												<xsl:with-param name="raw_item_name_param" select="$target"/>
											</xsl:call-template>
										</xsl:variable>
										<xsl:choose>
											<xsl:when test="$target = //type[select]/@name">
												<xs:element name="{$corrected_attribute_name}">
												<xs:complexType>
													<xs:group ref="{$namespace_prefix}{$corrected_target_name}"/>
												</xs:complexType>
												</xs:element>
											</xsl:when>
											<xsl:otherwise>
												<xs:element name="{$corrected_attribute_name}" type="{$namespace_prefix}{$corrected_target_name}"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
								</xsl:choose>
							</xsl:for-each>
						</xs:sequence>
					</xs:restriction>
				</xs:complexContent>
			</xs:complexType>
		</xsl:if>
		<!-- GENERATE ANONYMOUS AGGREGATE STRUCTURES -->
		<xsl:for-each select="./explicit/aggregate[position()!=1]">	
			<!-- xsl:variable name="base_datatype">
				<xsl:call-template name="generate_base_datatype">
					<xsl:with-param name="type" select=".."/>
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
			<xsl:variable name="aggregate_optionality">
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
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="seq_prefix">
				<xsl:call-template name="generate_prefix">
					<xsl:with-param name="position_param" select="last() - position() + 1"/>
					<xsl:with-param name="prefix_param" select="string('')"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="position()!=last()">
					<xsl:comment>EXPRESS AGGREGATE attribute component: xsd element declaration for <xsl:value-of select="concat($seq_prefix, $base_datatype)"/></xsl:comment>
					
						<xs:complexType name="{$seq_prefix}{$base_datatype}">
							<xs:sequence>
								<xs:element 
									ref="ap239:{$seq_prefix}{$base_datatype}" 
									minOccurs="{$lower_bound}"
									maxOccurs="{$upper_bound}"
								/>
							</xs:sequence>
							<xs:attribute ref="ex:itemType" fixed="ap239:{$seq_prefix}{$base_datatype}"/>
							<xs:attribute ref="ex:cType" fixed="{$current_aggregate_type}"/>
							<xs:attribute ref="ex:arraySize" use="{$aggregate_optionality}"/>
						</xs:complexType>
					<xsl:text>&#xa;</xsl:text>
					<xsl:text>&#xa;</xsl:text>
				</xsl:when>
				<xsl:when test="position()=last()">
					<xsl:comment>EXPRESS AGGREGATE attribute component: xsd element declaration for <xsl:value-of select="concat($seq_prefix, $base_datatype)"/></xsl:comment>
					
						<xs:complexType name="{$seq_prefix}{$base_datatype}">
							<xs:sequence>
								<xs:element 
									ref="ap239:{$seq_prefix}{$base_datatype}" 
									minOccurs="{$lower_bound}"
									maxOccurs="{$upper_bound}"
								/>
							</xs:sequence>
							<xs:attribute ref="ex:itemType" fixed="ap239:{$seq_prefix}{$base_datatype}"/>
							<xs:attribute ref="ex:cType" fixed="{$current_aggregate_type}"/>
							<xs:attribute ref="ex:arraySize" use="{$aggregate_optionality}"/>
						</xs:complexType>
					
					<xsl:text>&#xa;</xsl:text>
					<xsl:text>&#xa;</xsl:text>

				</xsl:when>
			</xsl:choose -->
		</xsl:for-each>
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
			<xsl:call-template name="put_into_lower_case">
				<xsl:with-param name="raw_item_name_param" select="$raw_attribute_name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="current_node" select="."/>
		<xsl:variable name="first_aggregate_node" select="./aggregate[position()=1]"/>
		
		
			<xsl:choose>
				<xsl:when test="./aggregate">
					<xsl:variable name="base_datatype">
						<xsl:call-template name="generate_base_datatype">
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
								<xsl:otherwise></xsl:otherwise>
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
								<xsl:comment>EXPRESS AGGREGATE ATTRIBUTE ELEMENT DECLARATION FOR: <xsl:value-of select="$corrected_attribute_name"/></xsl:comment><xsl:text>&#xa;</xsl:text>

								<xs:element name="{$corrected_attribute_name}"	>
									<xs:complexType>
										<xs:sequence>
											<xsl:choose>
												<xsl:when test="./typename/@name=//type[select]/@name">
													<xs:group 
														ref="{$base_datatype}"
														minOccurs="{$lower_bound}" 
														maxOccurs="{$upper_bound}"
													/>
												</xsl:when>
												<xsl:otherwise>
													<xs:element 
														ref="{$base_datatype}" 
														minOccurs="{$lower_bound}"
														maxOccurs="{$upper_bound}"
													/>
												</xsl:otherwise>
											</xsl:choose>
										</xs:sequence>
										<xs:attribute ref="ex:itemType" fixed="{$base_datatype}"/>
										<xs:attribute ref="ex:cType" fixed="{$current_aggregate_type}"/>
										<xs:attribute ref="ex:arraySize" use="{$aggregate_optionality}"/>
									</xs:complexType>	
								</xs:element>
								<xsl:text>&#xa;</xsl:text>
								<xsl:text>&#xa;</xsl:text>

							</xsl:when>
							<xsl:when test="./aggregate[position()=1 and position()!=last()]">
								<!-- xsl:comment>EXPRESS AGGREGATE attribute: xsd element declaration for <xsl:value-of select="$corrected_attribute_name"/></xsl:comment>

								<xs:element name="{$corrected_attribute_name}"	>
									<xs:complexType>
										<xs:sequence>
											<xs:element ref="ap239:{$seq_prefix}{$base_datatype}" minOccurs="{$lower_bound}" maxOccurs="{$upper_bound}"/>
										</xs:sequence>
										<xs:attribute ref="ex:itemType" fixed="ap239:{$seq_prefix}{$base_datatype}"/>
										<xs:attribute ref="ex:cType" fixed="{$current_aggregate_type}"/>
										<xs:attribute ref="ex:arraySize" use="{$aggregate_optionality}"/>												</xs:complexType>
								</xs:element -->
								
							</xsl:when>
						</xsl:choose>
					
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="./typename">
							<xsl:variable name="target" select="./typename/@name"/>
							<xsl:variable name="corrected_target_name">
								<xsl:call-template name="put_into_lower_case">
									<xsl:with-param name="raw_item_name_param" select="$target"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:choose>
							
								<xsl:when test="$target = //type[select]/@name">
									<xs:element name="{$corrected_attribute_name}">
									<xs:complexType>
										<xs:group ref="{$namespace_prefix}{$corrected_target_name}"/>
									</xs:complexType>
									</xs:element>
									<xsl:text>&#xa;</xsl:text>
									<xsl:text>&#xa;</xsl:text>
								</xsl:when>
								
								<xsl:when test="$target = //entity/@name">
									<xs:element name="{$corrected_attribute_name}">
										<xs:complexType>
											<xs:sequence>
												<xs:element ref="{$namespace_prefix}{$corrected_target_name}"/>
											</xs:sequence>
										</xs:complexType>
									</xs:element>
									<xsl:text>&#xa;</xsl:text>
									<xsl:text>&#xa;</xsl:text>
								</xsl:when>			

								<xsl:otherwise>
									<xs:element name="{$corrected_attribute_name}" type="{$namespace_prefix}{$corrected_target_name}"/>
									<xsl:text>&#xa;</xsl:text>
									<xsl:text>&#xa;</xsl:text>
								</xsl:otherwise>
								
							</xsl:choose>
						</xsl:when>
						<xsl:when test="./builtintype">
							<xsl:comment>EXPRESS ATTRIBUTE ELEMENT DECLARATION FOR: <xsl:value-of select="$corrected_attribute_name"/></xsl:comment><xsl:text>&#xa;</xsl:text>

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
	
	<xsl:template name="generate_subtypes_xpath_for_key">
		<xsl:param name="subtypes_list_param"/>
		<xsl:variable name="wlist_of_subtypes" select="concat(normalize-space($subtypes_list_param), ' ')"/>
		<xsl:choose>
			<xsl:when test="$wlist_of_subtypes!=' '">
				<xsl:variable name="first" select="substring-before($wlist_of_subtypes, ' ')"/>
				<xsl:variable name="rest" select="substring-after($wlist_of_subtypes, ' ')"/>
				<xsl:variable name="corrected_subtype_name">
					<xsl:call-template name="put_into_lower_case">
						<xsl:with-param name="raw_item_name_param" select="$first"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="concat(' | ', $namespace_prefix, $corrected_subtype_name)"/>
				<xsl:call-template name="generate_subtypes_xpath_for_key">
					<xsl:with-param name="subtypes_list_param" select="$rest"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	
	<xsl:template name="check_whether_part_of_multiple_inheritance_graph">
		<xsl:param name="raw_entity_param"/>
		
		<xsl:variable name="result_of_looking_up">
			<xsl:call-template name="look_up">
				<xsl:with-param name="raw_entity_name_param" select="$raw_entity_param"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="result_of_looking_down">
			<xsl:call-template name="look_down">
				<xsl:with-param name="raw_entity_name_param" select="$raw_entity_param"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($result_of_looking_up, 'YES')">true</xsl:when>
			<xsl:when test="contains($result_of_looking_down, 'YES')">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
		
		<!-- xsl:if test="contains($result_of_looking_up, 'YES') or contains($result_of_looking_down, 'YES')">
			<xsl:comment>THIS ENTITY IS PART OF A TYPE GRAPH CONTAIINING MULTIPLE INHERITANCE AND IS DEALT WITH USING INHERITANCE-FREE MAPPING (UNDER CONSTRUCTION)</xsl:comment>
		</xsl:if -->
	</xsl:template>
	
	<xsl:template name="look_up">
		<xsl:param name="raw_entity_name_param"/>
		<xsl:variable name="entity_node" select="//entity[@name =$raw_entity_name_param]"/>
		
		<xsl:choose>
			<xsl:when test="$entity_node[@supertypes]">
				<xsl:variable name="supertypes_list" select="$entity_node/@supertypes"/>
				<xsl:choose>
					<xsl:when test="contains($supertypes_list, ' ')">
						<xsl:value-of select="string('YES')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="look_up">
							<xsl:with-param name="raw_entity_name_param" select="$supertypes_list"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="look_down">
		<xsl:param name="raw_entity_name_param"/>
		<xsl:variable name="entity_node" select="//entity[@name =$raw_entity_name_param]"/>
		<xsl:variable name="supertypes_list" select="$entity_node/@supertypes"/>
		<xsl:choose>
			<xsl:when test="contains($supertypes_list, ' ')">
				<xsl:value-of select="string('YES')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="//entity[contains(concat(' ', @supertypes, ' '), concat(' ', $raw_entity_name_param, ' '))]">
					<xsl:variable name="subtype_name" select="./@name"/>
					<xsl:choose>
						<xsl:when test="$subtype_name">
							
							<xsl:call-template name="look_down">
								<xsl:with-param name="raw_entity_name_param" select="$subtype_name"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise></xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- xsl:template name="new_collect_attributes_from_supertypes">
		<xsl:param name="raw_supertype_param"/>
		<xsl:param name="raw_entity_param"/>
	</xsl:template -->
	
	<xsl:template name="collect_attributes_from_supertypes">
		<xsl:param name="raw_supertype_param"/>
		<xsl:param name="raw_entity_param"/>
		<xsl:for-each select="//entity[@name=$raw_supertype_param]/explicit">
			<xsl:variable name="raw_attribute_name" select="./@name"/>
			<xsl:choose>
				<xsl:when test="$raw_attribute_name=//entity[@name=$raw_entity_param]/explicit/redeclaration/@old_name"></xsl:when>
				<xsl:otherwise>
					<xsl:variable name="corrected_attribute_name">
						<xsl:call-template name="put_into_lower_case">
							<xsl:with-param name="raw_item_name_param" select="$raw_attribute_name"/>
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
								<xsl:call-template name="put_into_lower_case">
									<xsl:with-param name="raw_item_name_param" select="$raw_type_name"/>
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
	
	
	<xsl:template name="generate_attribute_to_simple_datatype">
		<xsl:param name="type_param"/>
		<xsl:param name="optionality_param"/>
		<xsl:param name="attribute_name_param"/>
		
		<xsl:choose>
			<xsl:when test="$type_param/builtintype[@type='BINARY' and not(@width)]">
				<xs:element type="ex:hexBinary" name="{$attribute_name_param}" minOccurs="{$optionality_param}"/>
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
									<xs:restriction base="ex:hexBinary">
										<xs:maxLength value="{$schema_length}"/>
										<xs:minLength value="{$schema_length}"/>
										<xs:attribute use="optional" type="xs:integer" name="extrabits"/>
									</xs:restriction>
								</xs:simpleContent>
							</xs:complexType>
						</xs:element>
					</xsl:when>
					<xsl:when test="$type_param/builtintype[@type='BINARY' and not(@fixed='YES')]">
						<xs:element name="{$attribute_name_param}" minOccurs="{$optionality_param}">
							<xs:complexType>
								<xs:simpleContent>
									<xs:restriction base="ex:hexBinary">
										<xs:maxLength value="{$schema_length}"/>
										<xs:attribute use="optional" type="xs:integer" name="extrabits"/>
									</xs:restriction>
								</xs:simpleContent>
							</xs:complexType>
						</xs:element>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			
			<xsl:when test="$type_param/builtintype[@type='BOOLEAN']">
				<xs:element type="xs:boolean"   name="{$attribute_name_param}" minOccurs="{$optionality_param}"/>
			</xsl:when>
			
			<xsl:when test="$type_param/builtintype[@type='LOGICAL']">
				<xs:element type="ex:logical"   name="{$attribute_name_param}" minOccurs="{$optionality_param}"/>
			</xsl:when>
			
			<xsl:when test="$type_param/builtintype[@type='INTEGER']">
				<xs:element type="xs:long" name="{$attribute_name_param}" minOccurs="{$optionality_param}"/>
			</xsl:when>
			
			<xsl:when test="$type_param/builtintype[@type='NUMBER']">
				<xs:element type="xs:decimal" name="{$attribute_name_param}" minOccurs="{$optionality_param}"/>
			</xsl:when>
			
			<xsl:when test="$type_param/builtintype[@type='REAL']">
				<xs:element type="xs:double" name="{$attribute_name_param}" minOccurs="{$optionality_param}"/>
			</xsl:when>
			
			<xsl:when test="$type_param/builtintype[@type='GENERICENTITY']">
				<xsl:comment>NO MAPPING FOR GENERICENTITY DATATYPE</xsl:comment>
			</xsl:when>

			
			<xsl:when test="$type_param/builtintype[@type='STRING' and not(@width)]">
				<xs:element type="xs:normalizedString" name="{$attribute_name_param}" minOccurs="{$optionality_param}"/>
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
		<xsl:choose>
			<xsl:when test="$aggregate/@type='ARRAY'">
				<xsl:variable name="array_size" select="$aggregate/@upper - $aggregate/@lower + 1"/>
				<xsl:value-of select="$array_size"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="aggregate_lower_bound" select="$aggregate/@lower"/>
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
	
	<xsl:template name="calculate_upper_bound">
		<xsl:param name="aggregate"/>
		<xsl:choose>
			<xsl:when test="$aggregate/@type='ARRAY'">
				<xsl:variable name="array_size" select="$aggregate/@upper - $aggregate/@lower + 1"/>
				<xsl:value-of select="$array_size"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="aggregate_upper_bound" select="$aggregate/@upper"/>
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
	
	<xsl:template name="generate_restriction">
		<xsl:param name="type"/>
		<xsl:choose>
			<xsl:when test="$type/typename">
				<xsl:variable name="raw_type_name" select="$type/typename/@name"/>
				<xsl:variable name="corrected_type_name">
						<xsl:call-template name="put_into_lower_case">
							<xsl:with-param name="raw_item_name_param" select="$raw_type_name"/>
						</xsl:call-template>
					</xsl:variable>
				<xs:restriction base = "{$namespace_prefix}{$corrected_type_name}"/>
			</xsl:when>
		
			<xsl:when test="$type/builtintype[@type='STRING' and not(@width)]">
				<xs:restriction base = "xs:normalizedString"/>
			</xsl:when>
				
			<xsl:when test="$type/builtintype[@type='BINARY' and not(@width)]">
				<xs:restriction base="ex:hexBinary"/>
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
						<xs:restriction base="ex:hexBinary">
							<xs:maxLength value="{$schema_length}"/>
							<xs:minLength value="{$schema_length}"/>
							<xs:attribute use="optional" type="xs:integer" name="extrabits"/>
						</xs:restriction>
					</xsl:when>
					<xsl:when test="$type/builtintype[@type='BINARY' and not(@fixed='YES')]">
						<xs:restriction base="ex:hexBinary">
							<xs:maxLength value="{$schema_length}"/>
							<xs:attribute use="optional" type="xs:integer" name="extrabits"/>
						</xs:restriction>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
				
			<xsl:when test="$type/builtintype[@type='BOOLEAN']">
				<xs:restriction base = "xs:boolean"/>
			</xsl:when>
				
			<xsl:when test="$type/builtintype[@type='LOGICAL']">
				<xs:restriction base = "ex:logical"/>
			</xsl:when>
				
			<xsl:when test="$type/builtintype[@type='NUMBER']">
				<xs:restriction base = "xs:decimal"/>
			</xsl:when>
			
			<xsl:when test="$type/builtintype[@type='INTEGER']">
				<xs:restriction base = "xs:long"/>
			</xsl:when>

					
			<xsl:when test="$type/builtintype[@type='REAL']">
				<xs:restriction base = "xs:double"/>
			</xsl:when>
	
			<xsl:when test="$type/builtintype[@type='STRING' and not(@width)]">
				<xs:restriction base = "xs:normalizedString"/>
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
	
	<xsl:template name="generate_base_datatype">
		<xsl:param name="type"/>
		<xsl:choose>
			<xsl:when test="$type/builtintype[@type='STRING']">
				<xsl:value-of select="string('ex:string-wrapper')"/>
			</xsl:when>
				
			<xsl:when test="$type/builtintype[@type='BINARY']">
				<xsl:value-of select="string('ex:hexBinary-wrapper')"/>
			</xsl:when>
			
			<xsl:when test="$type/builtintype[@type='BOOLEAN']">
				<xsl:value-of select="string('ex:boolean-wrapper')"/>
			</xsl:when>
				
			<xsl:when test="$type/builtintype[@type='LOGICAL']">
				<xsl:value-of select="string('ex:logical-wrapper')"/>
			</xsl:when>
				
			<xsl:when test="$type/builtintype[@type='NUMBER']">
				<xsl:value-of select="string('ex:decimal-wrapper')"/>
			</xsl:when>
			
			<xsl:when test="$type/builtintype[@type='INTEGER']">
				<xsl:value-of select="string('ex:long-wrapper')"/>
			</xsl:when>
					
			<xsl:when test="$type/builtintype[@type='REAL']">
				<xsl:value-of select="string('ex:double-wrapper')"/>
			</xsl:when>
			
			<xsl:when test="$type/typename">

				<xsl:variable name="corrected_type_name">
					<xsl:call-template name="put_into_lower_case">
						<xsl:with-param name="raw_item_name_param" select="$type/typename/@name"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="concat($namespace_prefix, $corrected_type_name)"/>
			</xsl:when>
	
		</xsl:choose>
	</xsl:template>

	<xsl:template name="put_into_lower_case">
		<xsl:param name="raw_item_name_param"/>
		<xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>
   		<xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
 		<xsl:variable name="lower_case_item_name" select="translate($raw_item_name_param, $UPPER, $LOWER)"/>
		<xsl:call-template name="replace_xml_string">
			<xsl:with-param name="lower_case_item_name_param" select="$lower_case_item_name"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="replace_xml_string">
		<xsl:param name="lower_case_item_name_param"/>
		<xsl:variable name="lower_case_item_name_minus_xml_string">
			<xsl:choose>
				<xsl:when test="starts-with($lower_case_item_name_param, 'xml')">
					<xsl:value-of select="concat('x-m-l', substring-after($lower_case_item_name_param, 'xml'))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$lower_case_item_name_param"/>				
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="put_first_letter_into_upper_case">
			<xsl:with-param name="lower_case_item_name_minus_xml_param" select="$lower_case_item_name_minus_xml_string"/>
		</xsl:call-template>
	</xsl:template>
	
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
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--                [contains(
			concat(' ', normalize-space(/@supertypes), ' '), concat(' ', $raw_node_name_param, ' ')
		)]                    -->
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
					<xsl:variable name="corrected_subtype_name">
						<xsl:call-template name="put_into_lower_case">
							<xsl:with-param name="raw_item_name_param" select="$raw_subtype_name"/>
						</xsl:call-template>
					</xsl:variable>
					<xs:element ref="{$namespace_prefix}{$corrected_subtype_name}"/>
					<xsl:call-template name="recurse_through_subtype_tree">
						<xsl:with-param name="raw_node_name_param" select="$raw_subtype_name"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="recurse_through_select_items">
		<xsl:param name="list_of_items_param"/>
		<xsl:variable name="wlist_of_items" select="concat(normalize-space($list_of_items_param), ' ')"/>
		<xsl:choose>
			<xsl:when test="$wlist_of_items!=' '">
				<xsl:variable name="first" select="substring-before($wlist_of_items, ' ')"/>
				<xsl:variable name="rest" select="substring-after($wlist_of_items, ' ')"/>
				<xsl:choose>
					<xsl:when test="//type[@name=$first]/select">
						<xsl:call-template name="recurse_through_select_items">
							<xsl:with-param name="list_of_items_param" select="//type[@name=$first]/select/@selectitems"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="corrected_select_item_name">
							<xsl:call-template name="put_into_lower_case">
								<xsl:with-param name="raw_item_name_param" select="$first"/>
							</xsl:call-template>
						</xsl:variable>
						<xs:element ref="{$namespace_prefix}{$corrected_select_item_name}"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:call-template name="recurse_through_select_items">
					<xsl:with-param name="list_of_items_param" select="$rest"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
