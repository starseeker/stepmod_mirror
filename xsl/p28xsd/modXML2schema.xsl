<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:template match="/">
		<xsl:apply-templates select="express"/>
	</xsl:template>
		
	<xsl:template match="express">
		<xsl:apply-templates select="schema"/>
	</xsl:template>
	
	<xsl:template match="schema">
		<xsl:text>&#xa;</xsl:text>
		
		<xs:schema 
			targetNamespace="urn:iso10303-28:ex"
  			xmlns:ex="urn:iso10303-28:ex" 
  			xmlns:xs="http://www.w3.org/2001/XMLSchema"
		>
			<xsl:text>&#xa;</xsl:text>
			<!-- DOCUMENT HEADER -->
			<xsl:comment>
				DOCUMENT HEADER (BASE SCHEMA)
			</xsl:comment>
			<xs:complexType name="name_and_address">
				<xs:sequence>
					<xs:element name="name" type="xs:string" />
					<xs:element name="address">
						<xs:complexType>
							<xs:sequence>
								<xs:element name="address_line" type="xs:string" minOccurs="0"  maxOccurs="unbounded"/>
							</xs:sequence>
						</xs:complexType>
					</xs:element>
				</xs:sequence>
			</xs:complexType>
			<xs:element name = "iso_10303_28_header" minOccurs="0">
				<xs:complexType>
					<xs:sequence>
						<xs:element name="name" type="xs:anyURI"/>
						<xs:element name="time_stamp" type="xs:dateTime"/>
						<xs:element name="author" type="ex:name_and_address"/>
						<xs:element name="organization" type="ex:name_and_address"/>
						<xs:element name="preprocessor_version" type="xs:string"/>
						<xs:element name="originating_system" type="xs:string"/>
						<xs:element name="authorization" type="xs:string"/>
						<xs:element name="documentation" type="xs:string"/>
					</xs:sequence>
				</xs:complexType>
			</xs:element>
			
			<!-- ROOT ELEMENT  UOS -->
			<xsl:comment>
				ROOT ELEMENT  UOS (BASE SCHEMA)
			</xsl:comment>
			<xs:complexType name="uos">
				<xs:sequence>
					<xs:any namespace="##any"  minOccurs="0"  maxOccurs="unbounded"/>
				</xs:sequence>
				<xs:attribute name="id" type="xs:ID"  use="required"/>
				<xs:attribute name="express" type="ex:Seq-anyURI" 
			    use="optional"/>
				<xs:attribute name="configuration" type="ex:Seq-anyURI"  
			    use="optional"/>
				<xs:attribute name="schemaLocation"  type="ex:Seq-anyURI" 
			    use="optional"/>
				<xs:attribute name="edo"  type="xs:anyURI" use="optional"/>
				<xs:attribute name="description"  type="xs:string" use="optional"/>
			</xs:complexType>
			
			<xs:element name="uos" type="ex:uos"/>	

			<!--  EX ENTITY DEFINTIONS and DECLARATIONS -->
			<xsl:comment>
				EX ENTITY DEFINTIONS and DECLARATIONS (BASE SCHEMA)
			</xsl:comment>
			<xs:complexType name = "Entity" abstract="true">
					<xs:annotation>
						<xs:documentation>The Entity type is the supertype for every
			         ex entity. It provides the ex id attribute that is the local
			         identifier for each instance as well as the other ex descriptive
			         attributes.</xs:documentation>
					</xs:annotation>
				<xs:attribute name = "href" type = "xs:anyURI" use = "optional"/>
				<xs:attribute name = "ref" type = "xs:IDREF" use = "optional"/>
				<xs:attribute name = "proxy" type = "xs:IDREF" use = "optional"/>
				<xs:attribute name = "edo" type = "xs:anyURI" use = "optional"/>
				<xs:attributeGroup ref="ex:instanceAttributes"/>
			</xs:complexType>
			
			<xs:element name="Entity" type = "ex:Entity" abstract = "true" nillable = "true"/>

			<!--  EX ARRAY -->
			<xsl:comment>
				EX ARRAY (BASE SCHEMA)
			</xsl:comment>
			<xs:attribute name="arraySize">
					<xs:simpleType>
			     <xs:restriction>
						  <xs:simpleType>
						    <xs:list itemType="xs:integer"/>
						  </xs:simpleType>
						  <xs:minLength value="1"/>
			     </xs:restriction>
					   </xs:simpleType>
			</xs:attribute>
			
			<xs:attribute name="itemType" type="xs:QName"/>
			
			<xs:attributeGroup name="instanceAttributes">
			 <xs:attribute name="id"  type="xs:ID" use="optional"/>
			 <xs:attribute name="path" type="xs:NMTOKENS" use="optional"/>
			 <xs:attribute name="pos" use="optional">
					<xs:simpleType>
						<xs:restriction>
							<xs:simpleType>
									<xs:list itemType="xs:integer"/>
							</xs:simpleType>
							<xs:minLength value="1"/>
						</xs:restriction>
					</xs:simpleType>
				</xs:attribute>
			</xs:attributeGroup>

			<!-- GLOBAL ATTRIBUTE DECLARATIONS  -->
			<xsl:comment>
				GLOBAL ATTRIBUTE DECLARATIONS (BASE SCHEMA)
			</xsl:comment>
			<xs:attribute name="cType">
				<xs:simpleType>
				  <xs:list itemType="ex:aggregateType"/>
				</xs:simpleType>
			</xs:attribute>
		
			<xs:simpleType name="aggregateType">
				<xs:restriction base="xs:normalizedString">
					<xs:enumeration value="array"/>
					<xs:enumeration value="list"/>
					<xs:enumeration value="set"/>
					<xs:enumeration value="bag"/>
		    			<xs:enumeration value="array-unique"/>
					<xs:enumeration value="array-optional"/>
					<xs:enumeration value="array-optional-unique"/>
		   			<xs:enumeration value="list-unique"/>
				</xs:restriction>
			</xs:simpleType>

			<!--  SIMPLE TYPE DEFINITIONS -->
			<xsl:comment>
				SIMPLE TYPE DEFINITIONS (BASE SCHEMA)
			</xsl:comment>
			<xs:complexType name="base64Binary">
				<xs:simpleContent>
					<xs:extension base="xs:base64Binary" >
						<xs:attribute name="extraBits" type="xs:integer" use="optional"/>
					</xs:extension>
				</xs:simpleContent>
			</xs:complexType>
			
			<xs:simpleType name = "logical">
				<xs:restriction base = "xs:string">
					<xs:enumeration value = "false"/>
					<xs:enumeration value = "true"/>
					<xs:enumeration value = "unknown"/>
				</xs:restriction>
			</xs:simpleType>

			<xs:element name="base64Binary-wrapper" nillable="true">
				<xs:complexType>
					<xs:simpleContent>
						<xs:extension base="ex:base64Binary">
							<xs:attributeGroup ref="ex:instanceAttributes"/>
						</xs:extension>
					</xs:simpleContent>
				</xs:complexType>
			</xs:element>
			
			<xs:element name="hexBinary-wrapper" nillable="true">
				<xs:complexType>
					<xs:simpleContent>
						<xs:extension base="ex:hexBinary">
							<xs:attributeGroup ref="ex:instanceAttributes"/>
						</xs:extension>
					</xs:simpleContent>
				</xs:complexType>
			</xs:element>
			
			<xs:element name="integer-wrapper" nillable="true">
				<xs:complexType>
					<xs:simpleContent>
						<xs:extension base="xs:integer">
							<xs:attributeGroup ref="ex:instanceAttributes"/>
						</xs:extension>
					</xs:simpleContent>
				</xs:complexType>
			</xs:element>

			<xs:element name="logical-wrapper" nillable="true">
				<xs:complexType>
					<xs:simpleContent>
						<xs:extension base="ex:logical">
							<xs:attributeGroup ref="ex:instanceAttributes"/>
						</xs:extension>
					</xs:simpleContent>
				</xs:complexType>
			</xs:element>
			
			<xs:complexType name="hexBinary">
				<xs:simpleContent>
					<xs:extension base="xs:hexBinary" >
							<xs:attribute name="extraBits" type="xs:integer" use="optional"/>
					</xs:extension>
				</xs:simpleContent>
			</xs:complexType>
			
			<!-- WRAPPER FOR ATOMIC SIMPLE TYPES  -->
			<xsl:comment>
				WRAPPER FOR ATOMIC SIMPLE TYPES (BASE SCHEMA)
			</xsl:comment>
			<xs:simpleType name="posType">
			 <xs:list itemType="xs:nonNegativeInteger"/>
			</xs:simpleType>
			
			<xs:element name="boolean-wrapper" nillable="true">
				<xs:complexType>
					<xs:simpleContent>
						<xs:extension base="xs:boolean">
							<xs:attributeGroup ref="ex:instanceAttributes"/>
						</xs:extension>
					</xs:simpleContent>
				</xs:complexType>
			</xs:element>
			
			<xs:element name="double-wrapper" nillable="true">
				<xs:complexType>
					<xs:simpleContent>
						<xs:extension base="xs:double">
							<xs:attributeGroup ref="ex:instanceAttributes"/>
						</xs:extension>
					</xs:simpleContent>
				</xs:complexType>
			</xs:element>	

			<xs:element name="decimal-wrapper" nillable="true">
					<xs:complexType>
						<xs:simpleContent>
							<xs:extension base="xs:decimal">
								<xs:attribute ref="ex:posType" use="optional"/>
							</xs:extension>
						</xs:simpleContent>
					</xs:complexType>
			</xs:element>
			
			<xs:element name="long-wrapper" nillable="true">
				<xs:complexType>
					<xs:simpleContent>
						<xs:extension base="xs:long">
							<xs:attributeGroup ref="ex:instanceAttributes"/>
						</xs:extension>
					</xs:simpleContent>
				</xs:complexType>
			</xs:element>
			
			<xs:element name="string-wrapper" nillable="true">
				<xs:complexType>
					<xs:simpleContent>
						<xs:extension base="xs:normalizedString">
							<xs:attributeGroup ref="ex:instanceAttributes"/>
						</xs:extension>
					</xs:simpleContent>
				</xs:complexType>
			</xs:element>
 
			<xs:element name="actualstring-wrapper" nillable="true">
				<xs:complexType>
					<xs:simpleContent>
						<xs:extension base="xs:string">
							<xs:attributeGroup ref="ex:instanceAttributes"/>
						</xs:extension>
					</xs:simpleContent>
				</xs:complexType>
			</xs:element>
			
			<xs:element name="language-wrapper" nillable="true" >
				<xs:complexType>
					<xs:simpleContent>
						<xs:extension base="xs:language">
							<xs:attributeGroup ref="ex:instanceAttributes"/>
						</xs:extension>
					</xs:simpleContent>
				</xs:complexType>
			</xs:element>
			
			<xs:element name="Name-wrapper" nillable="true">
				<xs:complexType>
					<xs:simpleContent>
						<xs:extension base="xs:Name">
							<xs:attributeGroup ref="ex:instanceAttributes"/>
						</xs:extension>
					</xs:simpleContent>
				</xs:complexType>
			</xs:element>
			
			<xs:element name="QName-wrapper" nillable="true">
				<xs:complexType>
					<xs:simpleContent>
						<xs:extension base="xs:QName ">
							<xs:attributeGroup ref="ex:instanceAttributes"/>
						</xs:extension>
					</xs:simpleContent>
				</xs:complexType>
			</xs:element>
			
			<xs:element name="NMTOKEN-wrapper" nillable="true">
				<xs:complexType>
					<xs:simpleContent>
						<xs:extension base="xs:NMTOKEN ">
							<xs:attributeGroup ref="ex:instanceAttributes"/>
						</xs:extension>
					</xs:simpleContent>
				</xs:complexType>
			</xs:element>
			
			<xs:element name="UriReference-wrapper" nillable="true">
				<xs:complexType>
					<xs:simpleContent>
						<xs:extension base="xs:UriReference">
							<xs:attributeGroup ref="ex:instanceAttributes"/>
						</xs:extension>
					</xs:simpleContent>
				</xs:complexType>
			</xs:element>

			<xs:element name="NOTATION-wrapper" nillable="true">
				<xs:complexType>
					<xs:simpleContent>
						<xs:extension base="xs:NOTATION">
							<xs:attributeGroup ref="ex:instanceAttributes"/>
						</xs:extension>
					</xs:simpleContent>
				</xs:complexType>
			</xs:element>
 
			<!-- seq types for ATOMIC SIMPLE TYPES  -->
			<xsl:comment>
				seq types for ATOMIC SIMPLE TYPES (BASE SCHEMA)
			</xsl:comment>
			<xs:simpleType name="Seq-boolean">
				<xs:list itemType="xs:boolean"/>
			</xs:simpleType>
		
			<xs:complexType name="Seq-boolean-type">
				<xs:simpleContent>
					<xs:extension base="ex:Seq-boolean">
						<xs:attribute ref="ex:posType" use="optional"/>
					</xs:extension>
				</xs:simpleContent>
			</xs:complexType>

			<xs:element name="Seq-boolean" type="ex:Seq-boolean-type"/>
		
			<xs:simpleType name="Seq-decimal">
				<xs:list itemType="xs:decimal"/>
			</xs:simpleType>
		
			<xs:complexType name="Seq-decimal-type">
				<xs:simpleContent>
					<xs:extension base="ex:Seq-decimal">
						<xs:attribute ref="ex:posType" use="optional"/>
					</xs:extension>
				</xs:simpleContent>
			</xs:complexType>
		
			<xs:element name="Seq-decimal" type="ex:Seq-decimal-type"/>
		
			<xs:simpleType name="Seq-double">
				<xs:list itemType="xs:double"/>
			</xs:simpleType>
		
			<xs:complexType name="Seq-double-type">
				<xs:simpleContent>
					<xs:extension base="ex:Seq-double">
						<xs:attribute ref="ex:posType" use="optional"/>
					</xs:extension>
				</xs:simpleContent>
			</xs:complexType>

			<xs:element name="Seq-double" type="ex:Seq-double-type"/>
		
			<xs:simpleType name="Seq-logical">
				<xs:list itemType="ex:logical"/>
			</xs:simpleType>
		
			<xs:complexType name="Seq-logical-type">
				<xs:simpleContent>
					<xs:extension base="ex:Seq-logical">
						<xs:attribute ref="ex:posType" use="optional"/>
					</xs:extension>
				</xs:simpleContent>
			</xs:complexType>
			<xs:element name="Seq-logical" type="ex:Seq-logical-type"/>
		
			<xs:simpleType name="Seq-long">
				<xs:list itemType="xs:long"/>
			</xs:simpleType>
		
			<xs:complexType name="Seq-long-type">
				<xs:simpleContent>
					<xs:extension base="ex:Seq-long">
						<xs:attribute ref="ex:posType" use="optional"/>
					</xs:extension>
				</xs:simpleContent>
			</xs:complexType>
		
			<xs:element name="Seq-long" type="ex:Seq-long-type"/>

			<xs:simpleType name="Seq-hexBinary">
				<xs:list itemType="ex:hexBinary"/>
			</xs:simpleType>

			<xs:complexType name="Seq-hexBinary-type">
				<xs:simpleContent>
					<xs:extension base="ex:Seq-hexBinary">
						<xs:attribute ref="ex:posType" use="optional"/>
					</xs:extension>
				</xs:simpleContent>
			</xs:complexType>

			<xs:element name="Seq-hexBinary" type="ex:Seq-hexBinary-type"/>

			<xs:simpleType name="Seq-base64Binary">
				<xs:list itemType="ex:base64Binary"/>
			</xs:simpleType>
		
			<xs:complexType name="Seq-base64Binary-type">
				<xs:simpleContent>
					<xs:extension base="ex:Seq-base64Binary">
						<xs:attribute ref="ex:posType" use="optional"/>
					</xs:extension>
				</xs:simpleContent>
			</xs:complexType>
		
			<xs:element name="Seq-base64Binary" type="ex:Seq-base64Binary-type"/>
		
			<xs:simpleType name="Seq-anyURI">
				<xs:list itemType="xs:anyURI"/>
			</xs:simpleType>
		
			<xs:complexType name="Seq-anyURI-type">
				<xs:simpleContent>
					<xs:extension base="ex:Seq-anyURI">
						<xs:attribute ref="ex:posType" use="optional"/>
					</xs:extension>
				</xs:simpleContent>
			</xs:complexType>

			<xs:element name="Seq-anyURI" type="ex:Seq-anyURI-type"/>

			<xs:simpleType name="Seq-dateTime">
				<xs:list itemType="xs:dateTime"/>
			</xs:simpleType>

			<xs:complexType name="Seq-dateTime-type">
				<xs:simpleContent>
					<xs:extension base="ex:Seq-dateTime">
						<xs:attribute ref="ex:posType" use="optional"/>
					</xs:extension>
				</xs:simpleContent>
			</xs:complexType>
	
			<xs:element name="Seq-dateTime" type="ex:Seq-dateTime-type"/>
			
			<!-- XSL CODE FROM HERE-->
			<xsl:comment>
				EXPRESS SCHEMA specific XMLschema
			</xsl:comment>
			<xsl:apply-templates select="type"/>
			<xsl:apply-templates select="entity"/>
		</xs:schema>
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
				<xs:group name="{$corrected_type_name}">
					<xs:choice>
						<xsl:call-template name="recurse_through_select_items">
							<xsl:with-param name="list_of_items_param" select="$list_of_items"/>
						</xsl:call-template>
					</xs:choice>
				</xs:group>
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
							<xsl:comment>EXPRESS AGGREGATE DATATYPE: <xsl:value-of select="$corrected_type_name"/></xsl:comment>
							<xs:complexType name="{$corrected_type_name}">
								<xs:sequence>
									<xs:element 
										ref="{$base_datatype}" 
										minOccurs="{$lower_bound}"
										maxOccurs="{$upper_bound}"
									/>
								</xs:sequence>
								<xs:attribute name="ref" type="xs:IDREF" use="{$optionality}"/>
								<xs:attribute ref="ex:itemType" fixed="{$base_datatype}"/>
								<xs:attribute ref="ex:cType" fixed="{$current_aggregate_type}"/>
								<xs:attribute ref="ex:arraySize" fixed="{$upper_bound}"/>
							</xs:complexType>
							<xsl:text>&#xa;</xsl:text>
							<xsl:text>&#xa;</xsl:text>
						</xsl:when>
						<xsl:when test="position()=1 and position()!=last()">
							<xsl:comment>EXPRESS AGGREGATE DATATYPE: <xsl:value-of select="$corrected_type_name"/></xsl:comment>
							<xs:complexType name="{$corrected_type_name}">
								<xs:sequence>
									<xs:element 
										ref="Tns:{$seq_prefix}{$base_datatype}" 
										minOccurs="{$lower_bound}"
										maxOccurs="{$upper_bound}"
									/>
								</xs:sequence>
								<xs:attribute name="ref" type="xs:IDREF" use="{$optionality}"/>
								<xs:attribute ref="ex:itemType" fixed="Tns:{$seq_prefix}{$base_datatype}"/>
								<xs:attribute ref="ex:cType" fixed="{$current_aggregate_type}"/>
								<xs:attribute ref="ex:arraySize" fixed="{$upper_bound}"/>
							</xs:complexType>
							<xsl:text>&#xa;</xsl:text>
							<xsl:text>&#xa;</xsl:text>
						</xsl:when>
						<xsl:when test="position()!=1 and position()!=last()">
							<xsl:comment>EXPRESS AGGREGATE DATATYPE: <xsl:value-of select="$corrected_type_name"/></xsl:comment>
							<xs:element name="Tns:{$seq_prefix}{$base_datatype}" nillable="true">
								<xs:complexType>
									<xs:sequence>
										<xs:element 
											ref="Tns:{$seq_prefix}{$base_datatype}" 
											minOccurs="{$lower_bound}"
											maxOccurs="{$upper_bound}"
										/>
									</xs:sequence>
									<xs:attribute name="ref" type="xs:IDREF" use="{$optionality}"/>
									<xs:attribute ref="ex:itemType" fixed="Tns:{$seq_prefix}{$base_datatype}"/>
									<xs:attribute ref="ex:cType" fixed="{$current_aggregate_type}"/>
									<xs:attribute ref="ex:arraySize" fixed="{$upper_bound}"/>
								</xs:complexType>
							</xs:element>
							<xsl:text>&#xa;</xsl:text>
							<xsl:text>&#xa;</xsl:text>
						</xsl:when>
						<xsl:when test="position()=last()">
							<xsl:comment>EXPRESS AGGREGATE DATATYPE: <xsl:value-of select="$corrected_type_name"/></xsl:comment>
							<xs:element name="Tns:{$seq_prefix}{$base_datatype}" nillable="true">
								<xs:complexType>
									<xs:sequence>
										<xs:element 
											ref="Tns:{$seq_prefix}{$base_datatype}" 
											minOccurs="{$lower_bound}"
											maxOccurs="{$upper_bound}"
										/>
									</xs:sequence>
									<xs:attribute name="ref" type="xs:IDREF" use="{$optionality}"/>
									<xs:attribute ref="ex:itemType" fixed="Tns:{$seq_prefix}{$base_datatype}"/>
									<xs:attribute ref="ex:cType" fixed="{$current_aggregate_type}"/>
									<xs:attribute ref="ex:arraySize" fixed="{$upper_bound}"/>
								</xs:complexType>
							</xs:element>
							<xsl:text>&#xa;</xsl:text>
							<xsl:text>&#xa;</xsl:text>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
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
	
	<!-- DEAL WITH ENTITY EXPRESS DATATYPES -->
	<xsl:template match="entity">
		<xsl:variable name="raw_entity_name" select="./@name"/>
		
		<xsl:variable name="corrected_entity_name">
			<xsl:call-template name="put_into_lower_case">
				<xsl:with-param name="raw_item_name_param" select="$raw_entity_name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="raw_supertype_name" select="./@supertypes"/>
		<xsl:variable name="corrected_supertype_name">
			<xsl:call-template name="put_into_lower_case">
				<xsl:with-param name="raw_item_name_param" select="$raw_supertype_name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="abstractness">
			<xsl:choose>
				<xsl:when test="//type/aggregate[@type='ARRAY' and @optional='YES']/../typename/@name=$raw_entity_name">false</xsl:when>
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

		<xsl:variable name="ext_base_sub_grp">
			<xsl:choose>
				<xsl:when test="$raw_supertype_name">
					<xsl:value-of select="concat('Tns:', $corrected_supertype_name)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="string('ex:Entity')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:comment>EXPRESS ENTITY DATATYPE: xsd element declaration for <xsl:value-of select="$corrected_entity_name"/></xsl:comment>
		<xsl:call-template name="check_whether_part_of_multiple_inheritance_graph">
				<xsl:with-param name="raw_entity_param" select="$raw_entity_name"/>
		</xsl:call-template>
		<xs:element 
			name="{$corrected_entity_name}" 
			type="Tns:{$corrected_entity_name}" 
			block="extension restriction" 
			substitutionGroup="{$ext_base_sub_grp}"
			nillable="true">
		</xs:element>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:comment>EXPRESS ENTITY DATATYPE: xsd complexType declaration for <xsl:value-of select="$corrected_entity_name"/></xsl:comment>
		<xs:complexType name="{$corrected_entity_name}" abstract="{$abstractness}">
			<xs:complexContent>
				<xs:extension base="{$ext_base_sub_grp}">
					<xs:sequence>
						<xsl:apply-templates select="explicit"/>
					</xs:sequence>
				</xs:extension>
			</xs:complexContent>
		</xs:complexType>
		<xsl:text>&#xa;</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		
			
		<xsl:if test="./explicit/redeclaration">
			<xsl:comment>EXPRESS ENTITY DATATYPE with redeclared attributes: xsd complexType declaration for <xsl:value-of select="$corrected_entity_name"/></xsl:comment>
			<xs:complexType name="{$corrected_entity_name}-temp" abstract="true">
				<xs:complexContent>
					<xs:restriction base="Tns:{$corrected_supertype_name}">
						<xs:sequence>
							<xsl:call-template name="collect_attributes_from_supertypes">
								<xsl:with-param name="raw_supertype_param" select="$raw_supertype_name"/>
								<xsl:with-param name="raw_entity_param" select="$raw_entity_name"/>
							</xsl:call-template>
						</xs:sequence>
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
									<xs:element name="{$corrected_attribute_name}" type="Tns:{$target}"/>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
					</xs:restriction>
				</xs:complexContent>
			</xs:complexType>
		</xsl:if>
		<!-- GENERATE ANONYMOUS AGGREGATE STRUCTURES -->
		<xsl:for-each select="./explicit/aggregate[position()!=1]">	
			<xsl:variable name="base_datatype">
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
					<xs:element name="Tns:{$seq_prefix}{$base_datatype}" nillable="true">
						<xs:complexType>
							<xs:sequence>
								<xs:element 
									ref="Tns:{$seq_prefix}{$base_datatype}" 
									minOccurs="{$lower_bound}"
									maxOccurs="{$upper_bound}"
								/>
							</xs:sequence>
							<xs:attribute name="ref" type="xs:IDREF" use="{$aggregate_optionality}"/>
							<xs:attribute ref="ex:itemType" fixed="Tns:{$seq_prefix}{$base_datatype}"/>
							<xs:attribute ref="ex:cType" fixed="{$current_aggregate_type}"/>
							<xs:attribute ref="ex:arraySize" fixed="{$upper_bound}"/>
						</xs:complexType>
					</xs:element>
					<xsl:text>&#xa;</xsl:text>
					<xsl:text>&#xa;</xsl:text>
				</xsl:when>
				<xsl:when test="position()=last()">
					<xsl:comment>EXPRESS AGGREGATE attribute component: xsd element declaration for <xsl:value-of select="concat($seq_prefix, $base_datatype)"/></xsl:comment>
					<xs:element name="Tns:{$seq_prefix}{$base_datatype}" nillable="true">
						<xs:complexType>
							<xs:sequence>
								<xs:element 
									ref="Tns:{$seq_prefix}{$base_datatype}" 
									minOccurs="{$lower_bound}"
									maxOccurs="{$upper_bound}"
								/>
							</xs:sequence>
							<xs:attribute name="ref" type="xs:IDREF" use="{$aggregate_optionality}"/>
							<xs:attribute ref="ex:itemType" fixed="Tns:{$seq_prefix}{$base_datatype}"/>
							<xs:attribute ref="ex:cType" fixed="{$current_aggregate_type}"/>
							<xs:attribute ref="ex:arraySize" fixed="{$upper_bound}"/>
						</xs:complexType>
					</xs:element>
					<xsl:text>&#xa;</xsl:text>
					<xsl:text>&#xa;</xsl:text>

				</xsl:when>
			</xsl:choose>
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
		
		<xs:complexContent>
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
								<xsl:comment>EXPRESS AGGREGATE attribute: xsd element declaration for <xsl:value-of select="$corrected_attribute_name"/></xsl:comment>
								<xs:element 
									name="{$corrected_attribute_name}"
									ref="{$base_datatype}" 
									minOccurs="{$lower_bound}"
									maxOccurs="{$upper_bound}"
								/>
								<xs:attribute name="ref" type="xs:IDREF" use="{$aggregate_optionality}"/>
								<xs:attribute ref="ex:itemType" fixed="{$base_datatype}"/>
								<xs:attribute ref="ex:cType" fixed="{$current_aggregate_type}"/>
								<xs:attribute ref="ex:arraySize" fixed="{$upper_bound}"/>
								<xsl:text>&#xa;</xsl:text>
								<xsl:text>&#xa;</xsl:text>

							</xsl:when>
							<xsl:when test="./aggregate[position()=1 and position()!=last()]">
								<xsl:comment>EXPRESS AGGREGATE attribute: xsd element declaration for <xsl:value-of select="$corrected_attribute_name"/></xsl:comment>

								<xs:element 
									name="{$corrected_attribute_name}"
									ref="Tns:{$seq_prefix}{$base_datatype}" 
									minOccurs="{$lower_bound}"
									maxOccurs="{$upper_bound}"
								/>
								<xs:attribute name="ref" type="xs:IDREF" use="{$optionality}"/>
								<xs:attribute ref="ex:itemType" fixed="Tns:{$seq_prefix}{$base_datatype}"/>
								<xs:attribute ref="ex:cType" fixed="{$current_aggregate_type}"/>
								<xs:attribute ref="ex:arraySize" fixed="{$upper_bound}"/>
								<xsl:text>&#xa;</xsl:text>
								<xsl:text>&#xa;</xsl:text>

							</xsl:when>
						</xsl:choose>
					<!-- /xsl:for-each -->
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="./typename">
							<xsl:variable name="raw_type_name" select="./typename/@name"/>
							<xsl:variable name="corrected_type_name">
								<xsl:call-template name="put_into_lower_case">
									<xsl:with-param name="raw_item_name_param" select="$raw_type_name"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:comment>EXPRESS attribute: xsd element declaration for <xsl:value-of select="$corrected_attribute_name"/></xsl:comment>

							<xs:element name="{$corrected_attribute_name}" type="Tns:{$corrected_type_name}" minOccurs="{$optionality}"/>
							<xsl:text>&#xa;</xsl:text>
								<xsl:text>&#xa;</xsl:text>

						</xsl:when>
						<xsl:when test="./builtintype">
							<xsl:comment>EXPRESS attribute: xsd element declaration for <xsl:value-of select="$corrected_attribute_name"/></xsl:comment>
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
		</xs:complexContent>
	</xsl:template>
	
	<!-- PROCEDURES -->
	
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
		
		
		<xsl:if test="contains($result_of_looking_up, 'YES') or contains($result_of_looking_down, 'YES')">
			<xsl:comment>THIS ENTITY IS PART OF A TYPE GRAPH CONTAIINING MULTIPLE INHERITANCE AND MUST BE DEALT WITH USING INHERITANCE-FREE MAPPING (UNDER CONSTRUCTION)</xsl:comment>
		</xsl:if>
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
			<xsl:otherwise/>
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
	
	<xsl:template name="collect_attributes_from_supertypes">
		<xsl:param name="raw_supertype_param"/>
		<xsl:param name="raw_entity_param"/>
		<xsl:for-each select="//entity[@name=$raw_supertype_param]/explicit">
			<xsl:variable name="raw_attribute_name" select="./@name"/>
			<xsl:choose>
				<xsl:when test="$raw_attribute_name=//entity[@name=$raw_entity_param]/explicit/redeclaration/@old_name"/>
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
							<xs:element name="{$corrected_attribute_name}" type="Tns:{$corrected_type_name}" minOccurs="{$optionality}"/>
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
					        		<xs:restriction base="normalizedString">
									<xs:maxLength value="{$express_length}"/>
					                  		<xs:minLength value="{$express_length}"/>
								</xs:restriction>
							</xs:simpleType>
						</xs:element>
					</xsl:when>
					<xsl:when test="$type_param/builtintype[@type='STRING' and not(@fixed='YES')]">
						<xs:element name="{$attribute_name_param}" minOccurs="{$optionality_param}">
					            <xs:simpleType>
					        		<xs:restriction base="normalizedString">
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
				<xs:restriction base = "Tns:{$corrected_type_name}"/>
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
				<xsl:value-of select="string('string')"/>
			</xsl:when>
				
			<xsl:when test="$type/builtintype[@type='BINARY']">
				<xsl:value-of select="string('hexBinary')"/>
			</xsl:when>
			
			<xsl:when test="$type/builtintype[@type='BOOLEAN']">
				<xsl:value-of select="string('boolean')"/>
			</xsl:when>
				
			<xsl:when test="$type/builtintype[@type='LOGICAL']">
				<xsl:value-of select="string('logical')"/>
			</xsl:when>
				
			<xsl:when test="$type/builtintype[@type='NUMBER']">
				<xsl:value-of select="string('decimal')"/>
			</xsl:when>
			
			<xsl:when test="$type/builtintype[@type='INTEGER']">
				<xsl:value-of select="string('long')"/>
			</xsl:when>
					
			<xsl:when test="$type/builtintype[@type='REAL']">
				<xsl:value-of select="string('double')"/>
			</xsl:when>
			
			<xsl:when test="$type/typename">

				<xsl:variable name="corrected_type_name">
					<xsl:call-template name="put_into_lower_case">
						<xsl:with-param name="raw_item_name_param" select="$type/typename/@name"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="$corrected_type_name"/>
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
						<xs:element ref="Tns:{$corrected_select_item_name}"/>
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
