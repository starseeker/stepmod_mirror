<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_annex_xsd_der.xsl,v 1.6 2014/07/02 15:27:14 mikeward Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep Limited.
  Purpose: Display BOM Annex B
-->
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cnf="urn:iso:std:iso:10303:-28:ed-2:tech:XMLschema:configuration_language"
  xmlns:doc="urn:iso:std:iso:10303:-28:ed-2:tech:XMLschema:document"
  xmlns:exp="urn:iso:std:iso:10303:-28:ed-2:tech:XMLschema:common" 
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  version="1.0">

  
  <xsl:import href="business_object_model.xsl"/>
  <xsl:import href="business_object_model_clause_nofooter.xsl"/> 
  <xsl:output method="html" indent="yes"/>
 
  
  <xsl:template match="business_object_model">
    <xsl:call-template name="annex_header">
      <xsl:with-param name="annex_no" select="'B'"/>
      <xsl:with-param name="heading" select="'Derivation of the XML schema'"/>
      <xsl:with-param name="aname" select="'annexe'"/>
      <xsl:with-param name="informative" select="'normative'"/>
    </xsl:call-template>
    
    <h2>
      <a name="b1">
        B.1 General concepts
      </a>
    </h2>
    <p>
      This section describes the general concepts for the derivation of the XML Schema from the corresponding BO Model EXPRESS Schema. 
      These concepts where used to create the XML Schema Definition from that EXPRESS Schema using the configuration directives of ISO 10303-28.
    </p>
    <h3>
      <a name="b1_1">
        B.1.1 Naming conventions
      </a>
    </h3>
    <p>
      In general, the XML name derived from a BO MODEL EXPRESS identifier is the BO MODEL EXPRESS identifier modified with following rules:
      <ul>
        <li>
          Names of XML elements and attributes shall be written using upper camel case.
        </li>
        <li>
          This convention requires removing underscore characters " _" from EXPRESS names.
        </li>
      </ul>
     The structure of the EXPRESS model is preserved in XML:
	<ul>
        <li>
        No changes in cardinality
        </li>
        <li>
        One EXPRESS instance is represented by one XML instance
 	<ul>
        <li>
        No aggregation of several EXPRESS entities into one XML element
       </li>
        <li>
        No splitting of one EXPRESS entity into several XML elements
       </li>
       </ul>
       <li>Reverting the direction of associations is allowed:
 	<ul>
        <li>
        Does not violate the principle of structure preservation
       </li>
       </ul>
       </li>
        </li>
       </ul> 
    </p>
    <h3>
      <a name="b1_2">
        B.1.2 Mapping of EXPRESS entity data types
      </a>
    </h3>
    <p>
      For each EXPRESS entity data type declaration the XML Schema contains the definition of a 
      new complex type corresponding to that EXPRESS entity data type.
    </p>
    <p>
      For each EXPRESS attribute appearing in the entity declaration, the ComplexType shall contain one corresponding element.
    </p>
    <p>
    By default, each complexType is based on cmn:BaseObject (defined in defined in common.xsd).
    </p>
    <p>
For each entity data type that does not inherit from another entity data type, the complexType is based on cmn:BaseRootObject (defined in defined in common.xsd). The BaseRootObjects occur as top level elements in the DataContainer and cannot be contained by any other element.
</p>
    <p>
      In addition to the declaration of simple entity data types EXPRESS allows the specification of entity data types as 
      subtypes of other entity data types. 
      This establishes an inheritance relationship (subtype/supertype) and through successive subtype/supertype relationships an 
      inheritance graph in which every instance of a subtype is also an instance of its supertype(s). 
      An entity declared by using inheritance relationships with supertypes is said to be a complex entity data type. 
      A complex entity data type inherits not only the EXPRESS attributes and rules appearing in the EXPRESS entity declarations of 
      all of its supertypes, but also all the EXPRESS attributes and rules they inherit. 
      So subtype entities are specialisations of any of their supertypes, 
      where a specialisation means a more constrained form of the original declaration. 
      The mapping of complex entity data types use the technique of derivation by extension for those entity data types that do not inherit from 
      multiple supertypes. When a complex type is derived by extension, 
      its effective content model is the content model of the base type plus the content model specified in the type derivation.
    </p>
    <p>
      EXPRESS allows the declaration of entities that are not intended to be directly instantiated. 
      For each EXPRESS entity data type declared to be ABSTRACT, 
      the Schema shall contain an XML element declaration corresponding to the EXPRESS entity data type. 
      The XML element shall be declared to be abstract so it cannot be used in a XML instance document.
    </p>
    <p>
      There are some exceptions to the mapping described above that do not require one-to-one mapping between EXPRESS entity and XML Schema ComplexType:
      <ul>
        <li>
          EXPRESS entities that have an equivalent that is already defined in XML Schema, e.g., dateTime, duration, language;
        </li>
        <li>
          Utilizing XML Schema constructs rather than one-to-one mapping, e.g. multilanguage support.
        </li>
      </ul>
    </p>
    <h3>
      <a name="b1_3">
        B.1.3 Mapping of named data types
      </a>
    </h3>
    <p>
      For each defined EXPRESS data type with a final underlying type of 
      STRING, 
      INTEGER, 
      REAL, 
      NUMBER or 
      BOOLEAN the XML schema contains a new element using the corresponding built-in types of XML schema.
    </p>
    <h3>
      <a name="b1_4">
        B.1.4 Mapping of SELECT data types
      </a>
    </h3>
    <p>
      A SELECT data type has a select list where each item shall be an entity data type or a defined data type. 
      SELECT data types that are used in EXPRESS are mostly created as cmn:Reference XML data types. In some cases (like in AxisPlacementOrTransformationSelect for AxisPlacement and CartesianTransformation, or in ClassSelect for ClassString) some elements of the SELECT type are mapped by containment.
      Therefore it is not needed to create SELECT type definitions. 
      In order to make resolving of cmn:Reference and containments for SELECT types possible for each SELECT type an XML Schema Group definition shall be created. 
      It shall contain the list of items that belong to the given SELECT type. 
      Groups might be used for validation purposes.
    </p>
    <h3>
      <a name="b1_5">
        B.1.5 Mapping of EXPRESS attributes
      </a>
    </h3>
    <p>
      For each EXPRESS explicit attribute of an EXPRESS entity data type declaration the corresponding ComplexType in the XML Schema Definition shall 
      contain an element definition. 
      In case of EXPRESS attributes that have simple semantics, 
      XML elements shall be used. (e.g., name, description, role, relationType, versionId, etc.).
    </p>
    <p>
    There are four main cases for EXPRESS attribute mapping:
    <ul>
					<li>
					Single attribute
					<ul>
						<li>
						by containment
						</li>
						<li>
						by reference
					</li>
				</ul>
					</li>
					<li>
					Aggregation attribute (SET, BAG, LIST, ARRAY)
					<ul>
						<li>
						by containment
						</li>
						<li>
						by reference
					</li>
					</ul>
					</li>
				</ul>
    </p>

    <p>      
      The order of elements is fixed - this shall be realized with XML Schema sequence grouping.
    </p>
    <p>
The name of the XML element shall be the name of the EXPRESS entity written in upper camel casing style. There are some exceptions from this rule:
<ul>
	<li>Identifier: role is mapped to idRoleRef;
	</li>
	<li>
	Identifier: identificationContext is mapped to idContextRef;
	</li>
	<li>
	ProcessedCore: Shape is mapped to ProcessedCoreShape;
	</li>
	<li>
CompositeAssembly: Shape is mapped to CompositeAssemblyShape;
	</li>
	<li>
Ply: Shape is mapped to  PlyShape;
	</li>
	<li>
PlyLaminate: Shape is mapped to  PlyLaminateShape;
	</li>
	<li>
PlyPiece: Shape is mapped to PlyPieceShape.
	</li>
</ul>
    </p>
    <p>
      If the EXPRESS attribute is declared to be OPTIONAL, 
      then the minOccurs pattern of the XML element shall be declared to be "0". 
    </p>
    <p>
    An INVERSE attribute constraining to exactly one element (like ApprovingPersonOrganization.authorizedApproval of type Approval), as all INVERSE attributes, shall not be mapped to the XSD, 
    but shall be used as an indicator to apply the XML containment rules (i.e. to define ApprovingPersonOrganization as being contained into Approval). For more details, see below. 
    </p>
    <p>
      The re-declaration of EXPRESS attributes shall have no effect on the XML schema declaration.
    </p>
    <h4>
      <a name="b1_5_1">
        B.1.5.1 EXPRESS attribute types corresponding to XML complex type
      </a>
    </h4>
    <p>
      The XML element corresponding to an EXPRESS attribute type that is an EXPRESS entity data type shall be mapped in one of following ways:
      <ul>
        <li>
          XML element type shall be the name of a complexType defined in XML Schema. 
          The lement in the XML document shall be instantiated inside a parent element i.a. attribute shall be represented by containment.
        </li>
        <li>
          XML element type shall be defined as type="cmn:Reference". 
          The attribute shall reference the uid attribute of an XML complexType corresponding to the EXPRESS entity data type of the attribute.
        </li>
      </ul>
    </p>
    <p>
      The XML element corresponding to an EXPRESS attribute whose data type is a SELECT data type shall reference the XML group defined for the SELECT .
    </p>
    <p>
      cmn:Reference in XML is untyped. To map the type of the referenced object from the EXPRESS schema, xsd:ref and xsd:keyref definitions are defined in the XSD. Based on XPATH, each xsd:keyref definition lists all the places where the referenced object may occur together with the xsd:ref of the referenced Entity. There is one xsd:ref per Entity and one xsd:keyref per attribute of type cmn:Reference plus one xsd:keyref per Entity. This allows automatic consistency checking for the XML file during XML Schema validation.
    </p>
    <h4>
      <a name="b1_5_2">
        B.1.5.2 EXPRESS attribute types corresponding to XML simple type
      </a>
    </h4>
    <p>
      The XML element corresponding to an EXPRESS attribute whose data type is a defined data type with a 
      final underlying type of STRING, INTEGER, REAL, NUMBER, or BOOLEAN shall be declared to have the XML type corresponding to 
      the underlying type of the defined data type in the EXPRESS type declaration, if not otherwise specified in a configuration directive:
    </p>
    <table border="1">
      <tr>
        <th>
          EXPRESS attribute type
        </th>
        <th>
          ISO XML element type
        </th>
      </tr>
      <tr>
        <td>
          NUMBER, REAL	
        </td>
        <td>
          xs:double
        </td>
      </tr>
      <tr>
        <td>
          INTEGER	
        </td>
        <td>
          xs:integer
        </td>
      </tr>
      <tr>
        <td>
          STRING	
        </td>
        <td>
          xs:string
        </td>
      </tr>
      <tr>
        <td>
          BOOLEAN	
        </td>
        <td>
          xs:boolean
        </td>
      </tr>
    </table>
    <p>
    As suggested in ISO 10303-28, LOGICAL is mapped to a simpleType having a
&lt;xsd:restriction base=&quot;xsd:string&quot;&gt;. Each value element is defined within it as &lt;xsd:enumeration value=&quot;…&quot;/&gt;:<br/>

&lt;xsd:simpleType name=&quot;logical&quot;&gt; <br/>
&#160;&#160;&lt;xsd:restriction base=&quot;xsd:string&quot;&gt; <br/>
    &#160;&#160;&#160;&#160;&lt;xsd:enumeration value=&quot;false&quot;/&gt; <br/>
    &#160;&#160;&#160;&#160;&lt;xsd:enumeration value=&quot;true&quot;/&gt; <br/>
    &#160;&#160;&#160;&#160;&lt;xsd:enumeration value=&quot;unknown&quot;/&gt; <br/>
 &#160;&#160; &lt;/xsd:restriction&gt; <br/>
&lt;/xsd:simpleType&gt; <br/>
    </p>
    <p> 
EXPRESS ENUMERATION types are mapped to a simpleType having a
&lt;xsd:restriction base=&quot;xsd:string&quot;&gt;. Each value element is defined within it as &lt;xsd:enumeration value=&quot;…&quot;/&gt;.
    </p>
    <p> 
      If an EXPRESS attribute type REAL is mapped to an XML element type STRING the  format of this content string shall be according IEEE 754-1985.
    </p>
    <h4>
      <a name="b1_5_3">      
        B.1.5.3 Attributes with aggregate data types
      </a>
    </h4>
    <p>
    Aggregations (by containment) are mapped as a sequence of elements with the EXPRESS type as name and type. Aggregations (by reference) are represented as a sequence of elements with the EXPRESS type as name and "cmn:Reference” as type.
     </p>
    <p> 
      EXPRESS provides four kinds of aggregation data types: ARRAY, LIST, BAG, and SET. 
      These data types have as their domains collections of values of a given base data type where the base data type can be a simple type, 
      a named type or another aggregation type.
    </p>
    <p> 
      The XML element corresponding to an aggregate valued EXPRESS attribute shall make use of maxOccurs= "unbounded".
          </p>
               <p class="example">
      <small>
        NOTE&#160;&#160;maxOccurs= "unbounded" most match the EXPRESS Type BAG, since redundant values are allowed. The uniqueness of the elements (like in a SET), the indexing of the elements (like in a LIST or an ARRAY) and OPTIONAL ARRAY values are not supported.
      </small>
    </p>
<p>
Multi-Dimensional Aggregates are mapped as one-dimensional.
          </p>
               <p class="example">
      <small>
        EXAMPLE&#160;&#160;MomentsOfInertia.InertiaValue of kind ARRAY[1:3] OF ARRAY[1:3] OF NumericalValue is mapped to "&lt;xsd:element name=&quot;NumericalValue&quot; type=&quot;NumericalValue&quot; maxOccurs=&quot;9&quot;/&gt;".
      </small>
    </p>
<p>
The ordering is in the order of sequence as the aggregates are defined, separated by blanks.
    </p>
<p>
An exception is made for CartesianTransformation.RotationMatrix. This entity is defined as LIST[2:3] OF LIST[2:3] OF LengthMeasure, which is mapped to xsd:string for reasons of compactness.
In both cases, the separator is a blank and the ordering of the elements is as follows: xx xy xz yx yy yz zx zy zz.
    </p>
<p>
Some One-Dimensional Aggregates have been also mapped to xsd:string for reasons of compactness:
<ul>
	<li>Direction.DirectionRatios (LIST[2:3] OF REAL)
	</li>
	<li>CartesianTransformation.TranslationVector (LIST[2:3] OF LengthMeasure)
	</li>
	<li>AxisPlacement.Axis/Position/RefDirection (LIST[2:3] OF LengthMeasure)
	</li>
	<li>CartesianPoint.Coordinates (LIST[2:3] OF LengthMeasure)
	</li>
</ul>
    </p>
<p>
Here the order is obvious: x y z
</p>

    <h3>
      <a name="b1_6">
B.1.6	Not mapped EXPRESS Constructs
      </a>
    </h3>
    <p>
The UNIQUE, WHERE and global rules are not mapped to XML.
</p>

    <h3>
      <a name="b1_7">
        B.1.7 Containment and referencing rules
      </a>
    </h3>
    <p>
    An EXPRESS attribute whose data type is an EXPRESS entity data type shall be mapped in one of the following ways:
    <ul>
					<li>By containment
					</li>				
					<li>By reference
					</li>				
	</ul>
Containment is the preferred approach:
<ul>
	<li>It is recommended to use containment wherever possible</li>
	<li>Reference should only be used for elements that are commonly reused</li>
</ul>
Motivation:
<ul>
	<li>To place as much information as possible about an object within it highly increases human readability;</li>
	<li>Less complexity with script based analysis (e.g. XSLT);</li>
	<li>Increases the XSD validation quality.</li>
</ul>
    </p>
<p>

      Reference mapping rules:
      <ul>
        <li>Master data - for elements defined directly under XML root element e.g., Organization, Person</li>
        <li>Structure elements - for elements that are reused and referenced as structure elements e.g., Documents, Parts</li>
        
      </ul> 
    </p>
    <p>
      
      
      
      Containment mapping rules:
      <ul>
        
        
        <li>Simple attributes e.g., String values</li>
        <li>Elements that cannot exist standalone but depend from another object and cannot be reused e.g., DateTime, TranslatedString, PropertyValue</li>
        <li>Grouping of elements in master-revision pattern, like Part -> PartVersion, Document -> DocumentVersion (usually the EXPRESS schema defines a mandatory INVERSE attribute for the contained element, for example PartVersion.versionOf)</li>
        <li>For relationships containment shall be performed along the relating attributeattribute (see below)</li>
        <li>A contained element cannot be defined as BaseRootObject</li>
      </ul>
    </p>

    <h3>
      <a name="b1_8">
        B.1.8 Change of Direction for Associations
      </a>
    </h3>
    <p>
   For various associations in EXPRESS, the direction has been inverted:
   <ul>
				<li>The original attribute is omitted</li>
				<li>A new attribute is added to the originally reference entity</li>
			</ul>
The advantage of this ‘reverse’ mapping is to see all the characteristics (like dates, approv-als, projects, persons and organizations, properties, …) of one object at one single place within the object.			
</p> 

    <h4>
      <a name="b1_8_1">
        B.1.8.1 Entities of kind Relationship
      </a>
    </h4>
    <p>
Entities of kind …Relationship, which are instantiated once in EXPRESS and reference one or many relating instance, are mapped (and instantiated separately) in the relating object. The relating attribute is omitted.
The related attribute is mapped by reference.
</p> 

    <h4>
      <a name="b1_8_2">
        B.1.8.2 Entities of kind Assignment
      </a>
    </h4>
    <p>
Entities of kind …Assignment, which are instantiated once in EXPRESS and reference one or many ‘assignedTo’ instances, are mapped (and instantiated separately) in each assignedTo object.
The assignedTo attribute is omitted. The assignedXxx attribute is mapped by reference.
The semantic is nearly the same (at least within the scope of a single XML file): the SET attribute DateTimeAssignment.AssignedTo can be computed out of all DateTimeAssignments where DateTimeAssignedDate point to the same DateTimeString.
</p> 

    <h3>
      <a name="b1_9">
        B.1.9 Representation of Id Attribute
      </a>
    </h3>
    <p>
Two representations are supported:
<ul>
	<li>Compact representation of the most used variant „simple string“</li>
	<li>Optimized representation for the other variants
	<ul>
		<li>Associated context and/or role</li>
		<li>Multiple identifiers</li>
	</ul>
	</li>
</ul>
          </p>
               <p class="example">
      <small>
        NOTE&#160;&#160;
        <ul>
									<li>idRoleRef references the uid of a Class, ExternalClass or ExternalOwlClass</li>
									<li>idContextRef references the uid of an Identifier or an Organization</li>
									<li>if Identifier is set, Id.id shall not be set</li>
								</ul>
      </small>
    </p>
    
    <h3>
      <a name="b1_10">
        B.1.10 Multilanguage Support
      </a>
    </h3>
    <p>
Two representations are supported:
<ul>
	<li>Compact text strings with optional language indication</li>
	<li>xsd:language is used for the language indication
	<ul>
		<li>Country and language code conforming to RFC 3066</li>
	</ul>
	</li>
</ul>
The business object definition refers to ISO 639-2  for the language code and to ISO 3166-1 for the country code. They enable the specification of a language code optionally followed by a country code, for example ‘en’ or ‘en-US’. The EXPRESS TYPE Language defined as LIST[1:2] OF STRING is mapped to XML as xsd:language, where the language code and the country code are concatenated (the country code is optional).
The W3C definition of xsd:language englobes these two ISO standards plus further ones in RFC 3066 (IANA and unofficial languages) => these shall not be used.

    </p>
    
    <h3>
      <a name="b1_11">
        B.1.11 Representation of Date and Time
      </a>
    </h3>
    <p>
xsd:dateTime is used instead of String.
    </p>
    <p>
As in EXPRESS Time is not optional, to avoid conversion problems it shall be provided as ”T00:00:00”.
    </p>
    
    <h2>
      <a name="b2">
        B.2 Unit of Serialization        
      </a>
    </h2>
    <p>
To be a valid XML, a DataContainer has to be included into an UoS object (Unit of Serialization) defined in common.xsd. The UoS contains a mandatory header element that contains administrative information that characterizes the content of the data package.
    </p>
    <p>
The header elements are described in ISO 10303-28:2007, section 5.2, as follows:
<ul>
	<li>Name: human readable identifier for the XML resource</li>
	<li>TimeStamp: date and time when the XML resource was created</li>
	<li>Author: identifies the person or group of persons who created the XML resource</li>
	<li>Organization: identifies the organization that created, or is responsible for, the XML resource</li>
	<li>PreprocessorVersion: identifies the software system that created the XML resource itself, including platform and version identifiers.
	               <p class="example">
      <small>
        NOTE&#160;&#160;The preprocessor_version will identify the system that was used to produce the XML resource. It may well be distinct from the software system that created or captured the original information.
      </small>
    </p>
	</li>
	<li>OriginatingSystem: identifies the software system that created or captured the infor-mation contained in the XML resource, including platform and version identifiers</li>
	<li>Authorization: specifies the release authorization for the XML resource and the signa-tory, where appropriate.
	               <p class="example">
      <small>
        NOTE&#160;&#160;This may be distinct from the authorizations for various information units con-tained within the document. 
      </small>
    </p>
	</li>
<li>Documentation: free text field for information</li>
</ul>
common.xsd is defined in http://standards.iso.org/iso/ts/10303/-3000/-ed-1/tech/xml-schema/common.
    </p>
    
    <h2>
      <a name="b3">
        B.3 XML configuration specification        
      </a>
    </h2>
    
    <p>This section contains the configuration specification.</p>
    
    
    <xsl:variable name="bom_dir" select="./@name"/>
    
    <xsl:variable name="config_file">
      <xsl:choose>
        <xsl:when test="$FILE_EXT='.xml'">
          <xsl:value-of select="concat('../../data/business_object_models/', $bom_dir,'/p28_config.xml')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('../../data/business_object_models/', $bom_dir,'/p28_config.htm')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    
    <p>
      &lt;iso_10303_28 
      version=""
      xmlns="urn:iso:std:iso:10303:-28:ed-2:tech:XMLschema:document"
      xmlns:cnf="urn:iso:std:iso:10303:-28:ed-2:tech:XMLschema:configuration_language"
      xmlns:exp="urn:iso:std:iso:10303:-28:ed-2:tech:XMLschema:common"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="urn:iso:std:iso:10303:-28:ed-2:tech:XMLschema:document ../../implementation_resources/iso10303_28_document_schema/doc.xsd 
      urn:iso:std:iso:10303:-28:ed-2:tech:XMLschema:configuration_language ../../implementation_resources/iso10303_28_configuration_language_schema/cnf.xsd 
      urn:iso:std:iso:10303:-28:ed-2:tech:XMLschema:common ../../implementation_resources/iso10303_28_base_xml_schema/exp.xsd "&gt;
    </p>
    <xsl:apply-templates select="document(string($config_file))//doc:iso_10303_28/*"  mode="nconfig">
      
    </xsl:apply-templates>
    <p>
      &lt;/iso_10303_28&gt;
    </p>
  </xsl:template>
  
  <xsl:template match="*" mode="nconfig">
    <xsl:param name="spaceparam">&#160;&#160;&#160;</xsl:param>
    <xsl:variable name="newspaceparam"><xsl:value-of select="$spaceparam"/>&#160;&#160;&#160;</xsl:variable>
    <xsl:variable name="element_name" select="name(.)"/>
   
    
    <xsl:choose>
      <xsl:when test="./*">
    
        <xsl:value-of select="$spaceparam"/>&lt;<xsl:value-of select="$element_name"/>
    
      <xsl:choose>
        <xsl:when test="$element_name='configuration'">&#160;xmlns="urn:iso:std:iso:10303:-28:ed-2:tech:XMLschema:configuration_language"</xsl:when>
        <xsl:when test="$element_name='schema'">&#160;xmlns="urn:iso:std:iso:10303:-28:ed-2:tech:XMLschema:configuration_language"</xsl:when>
      </xsl:choose>
       <xsl:for-each select="@*">
         &#160;<xsl:value-of select="name(.)"/>=&quot;<xsl:value-of select="."/>&quot;
         <xsl:copy-of select="./namespace::*"/>
       </xsl:for-each>
    &gt;<br/>
    <xsl:apply-templates select="*" mode="nconfig">
      <xsl:with-param name="spaceparam" select="$newspaceparam"/>
    </xsl:apply-templates>
    <xsl:value-of select="$spaceparam"/>&lt;/<xsl:value-of select="name(.)"/>&gt;<br/>
        
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$spaceparam"/>&lt;<xsl:value-of select="$element_name"/>
        <xsl:for-each select="@*">
          &#160;<xsl:value-of select="name(.)"/>=&quot;<xsl:value-of select="."/>&quot;
          <xsl:copy-of select="./namespace::*"/>
        </xsl:for-each>
        /&gt;<br/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  
	
</xsl:stylesheet>
