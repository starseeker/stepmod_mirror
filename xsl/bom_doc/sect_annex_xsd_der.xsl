<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_annex_xsd_der.xsl,v 1.5 2014/01/27 14:32:37 ungerer Exp $
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
      A XML name derived from a BO MODEL EXPRESS identifier is the BO MODEL EXPRESS identifier modified with following rules:
      <ul>
        <li>
          Names of XML tags shall be written using upper camel case.
        </li>
        <li>
          For identifiers that will be represented by XML element attributes lower camel case shall be used.
        </li>
        <li>
          This convention requires removing underscore characters " _" from EXPRESS names.
        </li>
        
      </ul>
    </p>
    <h3>
      <a name="b1_2">
        B.1.2 Mapping of EXPRESS entity data types
      </a>
    </h3>
    <p>
      For each EXPRESS entity data type declaration the XML Schema contain the definition of a 
      new complex type corresponding to that EXPRESS entity data type.
    </p>
    <p>
      For each entity data type that does not inherit from another entity data type a new ComplexType will be declared. 
      For each EXPRESS attribute appearing in the entity declaration, the ComplexType shall contain one corresponding element.
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
      There are some exceptions to mapping described above that do not require one-to-one mapping between EXPRESS entity and XML Schema ComplexType:
      <ul>
        <li>
          EXPRESS entities that have equivalent that is already defined in XML Schema, e.g., dateTime, duration, language
        </li>
        <li>
          Utilizing XML Schema constructs rather than one-to-one mapping e.g., Multilanguage support
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
      SELECT data types that are used in EXPRESS are created as IDREF(s) XML data types or using inverse given EXPRESS entity is included 
      in each SELECT type. 
      Therefore it is not needed to create SELECT type definitions. 
      In order to make resolving of IDREF(s) for SELECT types possible for each SELECT type XML Schema Group definition shall be created. 
      It shall contain list of items that belong to given SELECT type. 
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
      XML attributes shall be used. (e.g., name, description, role, relationType, versionId etc.).
    </p>
    <p>      
      The order of elements is fixed - this shall be realized with XML Schema sequence grouping.
    </p>
    <p>
      The name of the XML element shall be the name of the EXPRESS written in upper camel casing style. 
      EXPRESS attributes that are mapped to XML attributes shall be written in lower camel casing style. 
      If the EXPRESS attribute is declared to be OPTIONAL, 
      then the minOccurs pattern of the XML element shall be declared to be "0". 
      The type of the XML element shall be declared according to the data type of the EXPRESS attribute.
    </p>
    <p> 
      For each inverse attribute of an EXPRESS entity data type declaration the associated complexType shall contain an XML element 
      declaration corresponding to the EXPRESS attribute. 
      The name of the XML element shall be the name of the data type of the EXPRESS inverse attribute. 
      The type of the XML element shall be declared according to the data type of the EXPRESS inverse attribute.
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
      The XML element corresponding to an EXPRESS attribute whose data type is an EXPRESS entity data type shall be mapped in one of following ways:
      <ul>
        <li>
          XML element type shall be the name of a complexType defined in XML Schema. 
          Element in XML document shall be instantiated inside parent element i.a. attribute shall be represented by containment.
        </li>
        <li>
          XML element type shall be defined as IDREF(s). 
          The IDREF attribute shall reference the uid attribute of an XML complexType corresponding to the EXPRESS entity data type of the attribute.
        </li>
      </ul>
    </p>
    <p>
      The XML attribute corresponding to an EXPRESS attribute whose data type is a SELECT data type shall be declared 
      to have type IDREF in the XML schema declaration.
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
      If an EXPRESS attribute type REAL is mapped to an XML element type STRING the  format of this content string shall be according IEEE 754-1985.
    </p>
    <h4>
      <a name="b1_5_3">      
        B.1.5.3 Attributes with aggregate data types
      </a>
    </h4>
    <p>
      EXPRESS provides four kinds of aggregation data types: ARRAY, LIST, BAG and SET. 
      These data types have as their domains collections of values of a given base data type where the base data type can be a simple type, 
      a named type or another aggregation type.
    </p>
    <p> 
      The XML element corresponding to an aggregate valued EXPRESS attribute shall be declared to be of type "IDREFS" in case of reference 
      or for containment usage maxOccurs= "unbounded ".
    </p>
    <h3>
      <a name="b1_6">
        B.1.6 Containment and referencing rules
      </a>
    </h3>
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
        <li>Elements that cannot exist stanalone but depend from another object and cannot be reused e.g., DateTime, TranslatedString, PropertyValue</li>
        <li>Grouping of elements in master-revision pattern, like Part -> PartVersion, Document -> DocumentVersion</li>
        <li>For relationships containment shall be performed along the relating attribute</li>
        <li>For EXPRESS SET attributes that shall be represented as containment plural form shall be changed to singular form, 
          e.g., ConcernedOrganizations -&gt; ConcernedOrganization. It is needed to keep semantics correctness (maxOccurs= "unbounded")</li>
        <li>A contained element cannot be defined as RootObject</li>
        <li>If a containment is made along an attribute of kind SELECT type, the above rule shall apply to all members of the SELECT type</li>
      </ul>
    </p>
    <h2>
      <a name="b2">
        B.2 XML configuration specification        
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
