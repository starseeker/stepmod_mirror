<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id:  $

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
  exclude-result-prefixes="msxsl exslt"
  version="1.0">

  <xsl:output method="xml"/>

  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>
  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ_'"/>


  <xsl:variable name="XSDID" select="'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_:'"/>
  <xsl:variable name="EXPID" select="'abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz_.'"/>


<xsl:template name="toexpid">
<!-- for now keep the qualifier. -->
  <xsl:param name="string"/>
        <xsl:value-of select="translate($string,$XSDID,$EXPID)"/>
</xsl:template>

<!--

  <xsl:template match="xsd:schema">


    <xsl:processing-instruction name="xml-stylesheet">
      type="text/xsl" 
      href="../../../xsl/express.xsl"
    </xsl:processing-instruction>

    <xsl:text></xsl:text>

    <xsl:element name="express">
      <xsl:copy-of select="/express/@*"/>
      <xsl:apply-templates select="/express/application"/>
      <xsl:copy-of select="."/>
    </xsl:element>
    <xsl:apply-templates/>
  </xsl:template>
-->

  <xsl:template match="xsd:include">
    <xsl:element name="interface">
      <xsl:attribute name="kind"><xsl:value-of select="'use_from'"/></xsl:attribute>
      <xsl:attribute  name="schema"><xsl:value-of select="substring-before(@schemaLocation,'.xsd')"/></xsl:attribute>
<!-- perhaps not needed       <xsl:apply-templates select="entity_import|type_import"/> -->
    </xsl:element>
  </xsl:template>


  <xsl:template match="simpleType">
    <xsl:apply-templates/>
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
	<xsl:element name="type">
	  <xsl:attribute name="name">
	    <xsl:value-of select="../@name"/>
	  </xsl:attribute>
	  <xsl:element name="builtintype">
	    <xsl:attribute name="type"><xsl:value-of select="STRING"/>
	    </xsl:attribute>
	  </xsl:element>
	</xsl:element>
	<xsl:element name="where">
	  <xsl:attribute name="label">
	    <xsl:value-of select="'WR1'"/>
	    <xsl:attribute name="expression">
	      <xsl:apply-templates/>
	    </xsl:attribute>
	  </xsl:attribute>
	</xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="xsd:enumeration">
	  <xsl:value-of select="concat(@value,' OR ')"/>
 </xsl:template>

 <xsl:template match="xsd:complexType">
    <xsl:element name="entity">
   <xsl:attribute name="name">
     <xsl:value-of select="@name"/>
   </xsl:attribute>
      <xsl:apply-templates />
    </xsl:element>
 </xsl:template> 


<xsl:template match="xsd:complexContent">
    <xsl:element name="entity">
      <xsl:apply-templates />
    </xsl:element>
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

 <xsl:template match="xsd:element|xsd:attribute">
<!--  <xsl:template match="xsd:element"> -->
   <xsl:element name="explicit">
     <xsl:attribute name="name">
       <xsl:call-template name="toexpid">
	 <xsl:with-param name="string" select="@name"/>
       </xsl:call-template>
     </xsl:attribute>
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

<!-- continue this monday

<xsl:template match="xsd:attribute">
   <xsl:apply-templates />
 </xsl:template>
-->
 <xsl:template match="xsd:annotation">
   <xsl:apply-templates />
 </xsl:template>

 <xsl:template match="documentation">
    <xsl:element name="description">
      <xsl:value-of select="." />
    </xsl:element>
  </xsl:template>

<!-- test only set aside later -->
  <xsl:template match="query" >
    <xsl:variable name="doc_node" select="document('PLMXMLAnnotationSchema.xsd')"/>
    <xsl:apply-templates select="$doc_node"/>
  </xsl:template>
</xsl:stylesheet>
