<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: xsd2expressxml.xsl,v 1.5 2005/08/12 21:54:28 thendrix Exp $

Author: Tom Hendrix
Owner:  sourceforge stepmod
Purpose: 
Convert an xsd schema to stepmod express xml. 
Adapted from  stepmod/etc/ecco/utils/extract_schema.xsl

Sorry, this does not invert the mapping in stepmod/xsl/p28xsd/
-->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:exslt="http://exslt.org/common"
    xmlns:plm="http://www.plmxml.org/Schemas/PLMXMLSchema"
    exclude-result-prefixes="msxsl exslt"
    version="1.0">

  <xsl:output method="xml" indent="yes" />
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>
  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ_'"/>


  <xsl:variable name="XSDID" select="'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_:'"/>
  <xsl:variable name="EXPID" select="'abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz__'"/>


  <xsl:template name="toexpid">
    <!-- need to check for qualifier and maybe remove, then . for now qualifiers are removed elsewhere -->
    <xsl:param name="string"/>
    <!-- for now retain the camelCase identifiers of xsd
	 <xsl:value-of select="translate($string,$XSDID,$EXPID)"/> -->
    <xsl:value-of select="$string"/>
  </xsl:template>

  <xsl:template match="xsd:appinfo" mode="source">
    <xsl:attribute name="source">
      <xsl:value-of select="@source"/>
    </xsl:attribute>
  </xsl:template>  


  <xsl:template match="xsd:appinfo" />

  <xsl:template match="xsd:schema">
    <xsl:processing-instruction name="xml-stylesheet">
      <xsl:text>type="text/xsl"  href="../../xsl/express.xsl"</xsl:text>
     </xsl:processing-instruction>
     <xsl:element name="express">
      <xsl:attribute name="language_version">2
      </xsl:attribute>
      <xsl:attribute name="rcs.date">
	<xsl:value-of select="'&#x24;Date&#x3A;&#x24;'"/>
      </xsl:attribute>
      <xsl:attribute name="rcs.revision">
	<xsl:value-of select="'&#x24;Revision&#x3A;&#x24;'"/>
      </xsl:attribute>
      <!--      <xsl:attribute name="description.file"><xsl:value-of select="'mim_descriptions.xml'"/></xsl:attribute> -->
      <xsl:element name="application">
	<xsl:attribute name="name">xmlschema
	</xsl:attribute>
	<xsl:apply-templates select="xsd:annotation/xsd:appinfo" mode="source"/>
      </xsl:element>
      <xsl:element name="schema">
	<xsl:attribute name="name">
	  <xsl:call-template name="toexpid">
	    <xsl:with-param name="string"  select="substring-before(xsd:annotation/xsd:appinfo/plm:SchemaInfo/@name,'.xsd')"/>
	  </xsl:call-template>
	</xsl:attribute>
	<xsl:apply-templates select="xsd:annotation/xsd:documentation"/>
	<xsl:apply-templates select="xsd:include"/>
	<xsl:apply-templates select="//xsd:complexType//xsd:choice[count(xsd:element)>1]" mode="select" />
	<xsl:apply-templates select="xsd:simpleType"/>
	<xsl:apply-templates select="//xsd:complexType" mode="entity"/>
	<xsl:apply-templates select="*[not(self::xsd:annotation) and  not(self::xsd:include)]"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="xsd:include">
    <xsl:element name="interface">
      <xsl:attribute name="kind"><xsl:value-of select="'use'"/></xsl:attribute>
      <xsl:attribute  name="schema"><xsl:value-of select="substring-before(@schemaLocation,'.xsd')"/></xsl:attribute>
      <!-- perhaps not needed       <xsl:apply-templates select="entity_import|type_import"/> -->
    </xsl:element>
  </xsl:template>


  <xsl:template match="xsd:simpleType">
   <xsl:element name="type">
      <xsl:attribute name="name">
	<xsl:value-of select="@name"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="xsd:element|xsd:attribute|xsd:restriction|xsd:list" mode="type">
<!-- can you believe this kludge ? -->
    <xsl:variable name="ref" select="substring-after(@ref,':')"/>
    <xsl:variable name="type" select="concat(@base,@type,@itemType,//xsd:element[@name=$ref]/@type)"/>
    <xsl:choose>
      <xsl:when test="$type='xsd:ID' or $type='xsd:IDREF'">
	<xsl:element name="typename">
	  <xsl:attribute name="name">identifier</xsl:attribute>
	</xsl:element>
      </xsl:when>
      <xsl:when test="$type='xsd:IDREFS'">
	<xsl:element name="aggregate">
	  <xsl:attribute name="type">LIST</xsl:attribute>
	</xsl:element>
	<xsl:element name="typename">
	  <xsl:attribute name="name">identifier</xsl:attribute>
	</xsl:element>
      </xsl:when>
      <xsl:when test="contains($type,'xsd:')">
	<xsl:element name="builtintype">
	  <xsl:attribute name="type">
	    <xsl:choose>
	      <xsl:when test="$type='xsd:string'">STRING</xsl:when>
	      <xsl:when test="$type='xsd:integer'">INTEGER</xsl:when>
	      <xsl:when test="$type='xsd:nonNegativeInteger'">INTEGER</xsl:when>
	      <xsl:when test="$type='xsd:positiveInteger'">INTEGER</xsl:when>
	      <xsl:when test="$type='xsd:float'">REAL</xsl:when>
	      <xsl:when test="$type='xsd:double'">REAL</xsl:when>
	      <xsl:when test="$type='xsd:boolean'">BOOLEAN</xsl:when>
	      <xsl:when test="$type='xsd:logical'">LOGICAL</xsl:when>
	      <xsl:when test="$type='xsd:time'">STRING</xsl:when>
	      <xsl:when test="$type='xsd:date'">STRING</xsl:when>
	      <xsl:when test="$type='xsd:dateTime'">STRING</xsl:when>
	      <xsl:when test="$type='xsd:decimal'">STRING</xsl:when>
	      <xsl:when test="$type='xsd:language'">STRING</xsl:when>
	    </xsl:choose>
	  </xsl:attribute>
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<xsl:element name="typename">
	  <xsl:attribute name="name">
	    <xsl:choose>
	      <xsl:when test="contains($type,':')" >
		<xsl:value-of select="substring-after($type,':')"/>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:value-of select="'UNDEFINED'"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:attribute>
	</xsl:element>
      </xsl:otherwise>
    </xsl:choose>
 </xsl:template>

  <xsl:template match="xsd:restriction">
    <xsl:choose>
      <xsl:when test="@base='xsd:NMTOKEN'">
	<xsl:element name="enumeration">
	  <xsl:attribute name="items">
	    <xsl:apply-templates/>
	  </xsl:attribute>
	</xsl:element>
      </xsl:when>
     <xsl:otherwise>
       <xsl:apply-templates select="." mode="type"/>
     </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="child::node()[not(text())] and count(xsd:enumeration) &lt; 2">
	<xsl:element name="where">
	  <xsl:attribute name="label">
	    <xsl:value-of select="'WR1'"/>
	  </xsl:attribute>
	  <xsl:attribute name="expression">
	    <xsl:apply-templates mode="where"/>
	  </xsl:attribute>
	</xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*" mode="where">
    <xsl:value-of select="concat(' ',substring-after(name(.),':'),'=',@value,' AND ')"/> 
  </xsl:template>

  <xsl:template match="xsd:enumeration">
    <xsl:value-of select="concat(@value,' ')"/>
  </xsl:template>

<xsl:template match="simpleType" mode="typeref">
  <xsl:element name="builtintype">
    <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
  </xsl:element>
</xsl:template>

<xsl:template match="complexType" mode="typeref">
  <xsl:element name="typename">
    <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
  </xsl:element>
</xsl:template>


  <xsl:template match="xsd:list">
    <xsl:element name="aggregate">
      <xsl:attribute name="type">LIST</xsl:attribute>
    </xsl:element>
    <xsl:apply-templates select="." mode="type"/>
  </xsl:template>


  <xsl:template match="*" mode="listname">
    <xsl:value-of select="concat(@name,' ')"/>
  </xsl:template>


  <xsl:template match="*" mode="listtype">
    <xsl:value-of select="concat(substring-after(@type,':'),' ')"/>
  </xsl:template>


  <xsl:template match="*" mode="listreftype">
    <xsl:variable name="ref"><xsl:value-of select="substring-after(@ref,':')"/></xsl:variable>
    <xsl:value-of select="concat(substring-after(//xsd:element[@name=$ref]/@type,':'),' ')"/>
  </xsl:template>

  <xsl:template match="xsd:choice" mode="select">
<!-- create a select type -->
    <xsl:element name="type">
      <xsl:attribute name="name">
	<xsl:value-of select="concat(ancestor::node()/@name,'_select')"/>
      </xsl:attribute>
      <xsl:element name="select">
	<xsl:attribute name="selectitems">
	  <xsl:for-each select="xsd:element">
	    <xsl:apply-templates select="self::node()[@type]" mode="listtype"/>
	    <xsl:apply-templates select="self::node()[@ref]" mode="listreftype"/>
	  </xsl:for-each>
	</xsl:attribute>
      </xsl:element>
    </xsl:element>
  </xsl:template>


  <xsl:template match="xsd:simpleContent">
      <xsl:apply-templates />
 </xsl:template>


  <xsl:template match="xsd:complexContent">
      <xsl:apply-templates />
 </xsl:template>

  <xsl:template match="xsd:choice">
      <xsl:apply-templates />
 </xsl:template>

  <xsl:template match="xsd:extension">
    <xsl:attribute name="supertypes"><xsl:value-of select="substring-after(@base,':')"/></xsl:attribute>
  </xsl:template>

  <xsl:template match="xsd:sequence">
    <xsl:apply-templates />
  </xsl:template>

<xsl:template match="xsd:complexType" mode="abstract">
  <xsl:if test="@abstract='true'">
    <xsl:attribute name="abstract.supertype">YES</xsl:attribute>
  </xsl:if>
</xsl:template>


  <xsl:template match="xsd:complexType" mode="entity">
    <xsl:element name="entity">
      <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
      <xsl:apply-templates select="." mode="abstract"/>
      <!--      <xsl:apply-templates select="xsd:complexContent"/>
	   <xsl:apply-templates select="xsd:simpleContent"/> -->
      <xsl:apply-templates  select="xsd:complexContent/xsd:extension"/>
      <xsl:apply-templates  select=".//xsd:element[@name]" mode="name"/>
      <xsl:apply-templates  select=".//xsd:element[@ref]" mode="ref"/>
      <xsl:apply-templates  select=".//xsd:attribute" mode="name"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="xsd:element|xsd:attribute" mode="name">
   <xsl:element name="explicit">
      <xsl:attribute name="name">
	<xsl:call-template name="toexpid">
	  <xsl:with-param name="string" select="@name"/>
	</xsl:call-template>
      </xsl:attribute>
      <xsl:if test="@use='optional'">
	<xsl:attribute name="optional">YES</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="." mode="type"/>
      <xsl:apply-templates />
    </xsl:element> 
  </xsl:template>

  <xsl:template match="xsd:element" mode="ref">
   <xsl:element name="explicit">
      <xsl:attribute name="name">
	<xsl:value-of  select="substring-after(@ref,':')"/>
      </xsl:attribute>
      <xsl:apply-templates select="." mode="type"/>
      <xsl:apply-templates />
    </xsl:element> 
  </xsl:template>

  
<xsl:template match="xsd:complexType/xsd:attributeGroup">
    <xsl:element name="explicit">
      <xsl:attribute name="name">
	<xsl:call-template name="toexpid">
	  <xsl:with-param name="string" select="name(.)"/>
	</xsl:call-template>
      </xsl:attribute>
      <xsl:if test="@use='optional'">
	<xsl:attribute name="optional">YES</xsl:attribute>
      </xsl:if>
      <xsl:element name="typename">
	<xsl:attribute name="name">
	    <xsl:value-of select="substring-after(@ref,':')"/>
	</xsl:attribute>
      </xsl:element>
      <xsl:apply-templates />
    </xsl:element> 
  </xsl:template>

  <xsl:template match="xsd:annotation">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="xsd:documentation">
    <xsl:element name="description">
      <xsl:value-of select="." />
    </xsl:element>
  </xsl:template>

  <!-- test only set aside later -->
  <xsl:template match="query" >
    <xsl:variable name="doc_node" select="document(concat('xsd','/',@schema,'.xsd'))"/>
    <xsl:apply-templates select="$doc_node"/>
  </xsl:template>
  <xsl:template match="*">
		<xsl:message>
		<xsl:value-of select="name(.)" />  not matched:
		</xsl:message>
  </xsl:template>
</xsl:stylesheet>
