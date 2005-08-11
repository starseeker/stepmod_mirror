<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: xsd2expressxml.xsl,v 1.1 2005/08/05 23:50:18 thendrix Exp $

Author: Tom Hendrix
Owner:  sourceforge stepmod
Purpose: 
Convert an xsd schema to stepmod express xml. 
Adapted from  stepmod/etc/ecco/utils/extract_schema.xsl
-->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:exslt="http://exslt.org/common"
    xmlns:plm="http://www.plmxml.org/Schemas/PLMXMLSchema"
    exclude-result-prefixes="msxsl exslt"
    version="1.0">

  <xsl:output method="xml"/>

  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>
  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ_'"/>


  <xsl:variable name="XSDID" select="'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_:'"/>
  <xsl:variable name="EXPID" select="'abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz__'"/>


  <xsl:template name="toexpid">
    <!-- for now keep the qualifier. -->
    <xsl:param name="string"/>
    <xsl:value-of select="translate($string,$XSDID,$EXPID)"/>
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
	<xsl:apply-templates select="xsd:element[@name]" mode="entity" />
	<xsl:apply-templates select="//xsd:complexType//xsd:choice[not(@maxOccurrs)]" mode="select" />
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
    <xsl:apply-templates select="xsd:list"/>
	<xsl:element name="type">
	  <xsl:attribute name="name">
	    <xsl:value-of select="@name"/>
	  </xsl:attribute>
	  <xsl:apply-templates/>
	</xsl:element>
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
      <xsl:when test="@base='xsd:string'">
	<xsl:element name="builtintype">
	  <xsl:attribute name="type"><xsl:value-of select="'STRING'"/>
	  </xsl:attribute>
	</xsl:element>
	<xsl:element name="where">
	  <xsl:attribute name="label">
	    <xsl:value-of select="'WR1'"/>
	  </xsl:attribute>
	  <xsl:attribute name="expression">
	    <xsl:apply-templates/>
	  </xsl:attribute>
	</xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="xsd:enumeration">
    <xsl:value-of select="concat(@value,' ')"/>
  </xsl:template>

  <xsl:template match="xsd:list">
    <xsl:element name="aggregate">
      <xsl:attribute name="type">LIST</xsl:attribute>
      <xsl:variable name="itemtype"><xsl:value-of select="@itemType"/></xsl:variable>
      <xsl:apply-templates select="//simpleType[@name=$itemtype]" mode="typeref"/>
      <xsl:apply-templates select="//complexType[@name=$itemtype]" mode="typeref"/>
    </xsl:element>
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

  <xsl:template match="xsd:list" mode="typeref">
    <xsl:element name="aggregate">
      <xsl:attribute name="type">LIST</xsl:attribute>
	<xsl:value-of select="@itemType"/>
      <xsl:apply-templates select="." mode="typeref"/>
    </xsl:element>
  </xsl:template>


  <xsl:template match="xsd:element" mode="listname">
    <xsl:value-of select="concat(@name,' ')"/>
  </xsl:template>

  <xsl:template match="xsd:choice" mode="select">
    <xsl:element name="type">
      <xsl:attribute name="name">
	<xsl:value-of select="concat(../../../@name,'_select')"/>
      </xsl:attribute>
      <xsl:element name="select">
	<xsl:attribute name="selectitems">
	  <xsl:apply-templates select="xsd:element" mode="listname"/>
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
    <xsl:attribute name="supertypes">
      <xsl:call-template name="toexpid">
	<xsl:with-param name="string" select="@base"/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="xsd:sequence">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="xsd:element" mode="entity">
    <!--  <xsl:template match="xsd:element"> -->
   <xsl:element name="entity">
      <xsl:attribute name="name">
	<xsl:call-template name="toexpid">
	  <xsl:with-param name="string" select="@name"/>
	</xsl:call-template>
      </xsl:attribute>
      <xsl:variable name="type" select="substring-after(@type,':')"/>
      <xsl:apply-templates select="//xsd:complexType[@name=$type][@abstract='true']" mode="abstract" />
    </xsl:element> 
  </xsl:template>

  <xsl:template match="xsd:complexType" mode="abstract">
    <xsl:attribute name="abstract.supertype">YES</xsl:attribute>
  </xsl:template>


  <xsl:template match="xsd:complexType" mode="entity">
    <xsl:element name="entity">
    <xsl:attribute name="name">@name</xsl:attribute>
    </xsl:element>
    <xsl:apply-templates  select=".//xsd:element" mode="attr"/>
    <xsl:apply-templates  select=".//xsd:attribute" mode="attr"/>
    <xsl:attribute name="abstract.supertype">YES</xsl:attribute>
  </xsl:template>

  <xsl:template match="xsd:element|xsd:attribute" mode="attr">
   <xsl:element name="explicit">
      <xsl:attribute name="name">
	<xsl:call-template name="toexpid">
	  <xsl:with-param name="string" select="@name"/>
	</xsl:call-template>
      </xsl:attribute>
      <xsl:if test="@use='optional'">
	<xsl:attribute name="optional">YES</xsl:attribute>
      </xsl:if>
      <xsl:element name="typename">
	<xsl:attribute name="name">
	  <xsl:call-template name="toexpid">
	    <xsl:with-param name="string" select="@type"/>
	  </xsl:call-template>
	</xsl:attribute>
      </xsl:element>
      <xsl:apply-templates />
    </xsl:element> 
  </xsl:template>

  
<xsl:template match="xsd:complexType/xsd:attributeGroup">
    <xsl:element name="explicit">
      <xsl:attribute name="name">
	<xsl:call-template name="toexpid">
	  <xsl:with-param name="string" select="name()"/>
	</xsl:call-template>
      </xsl:attribute>
      <xsl:if test="@use='optional'">
	<xsl:attribute name="optional">YES</xsl:attribute>
      </xsl:if>
      <xsl:element name="typename">
	<xsl:attribute name="name">
	  <xsl:call-template name="toexpid">
	    <xsl:with-param name="string" select="@ref"/>
	  </xsl:call-template>
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
