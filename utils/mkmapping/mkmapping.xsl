<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: mkmapping.xsl,v 1.1 2002/08/22 15:06:47 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: Extracts the basis of a mapping table from the ARM express
        defined in arm.xml.
     The table lists every arm element and attributes and maps them to a
     aim constructs of the same name.
-->

<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:exslt="http://exslt.org/common"
    exclude-result-prefixes="msxsl exslt"
    version="1.0">
  
  <xsl:import href="../../xsl/common.xsl"/>

  <xsl:output 
    method="xml"
    indent="yes"
    omit-xml-declaration="yes"
    encoding="utf-8"
    />
    
  <xsl:template match="/">
    <xsl:processing-instruction name="xml-stylesheet">
      type="text/xsl" 
      href="../../../../xsl/mapping.xsl"</xsl:processing-instruction>

	  <xsl:comment>Source is required, except for assertions, where it is forbidden. 
	  source is the number of  STEP part where aimelt is declared. </xsl:comment>
	  <xsl:comment>If aimelt is not a common resource, 
	  then a refpath to a common resource is required. 
	  Additionally a refpath may be needed to document constraints.</xsl:comment>
      
    <xsl:element name="module">
      <xsl:variable name="module_name">
        <xsl:call-template name="module_name">
          <xsl:with-param name="module" select="/express/schema/@name"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:attribute name="name">
        <xsl:value-of select="$module_name"/>
      </xsl:attribute>      
      <xsl:attribute name="rcs.date">
        <xsl:value-of select="'$Date: 2002/08/22 15:06:47 $'"/>
      </xsl:attribute>
      <xsl:attribute name="rcs.revision">
        <xsl:value-of select="'$Revision: 1.1 $'"/>
      </xsl:attribute>

      <xsl:element name="mapping_table">
        <xsl:apply-templates select="/express/schema/entity"/>
        <xsl:apply-templates select="/express/schema/type/select"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="entity">
    <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
    <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>

    <xsl:variable name="arm_entity" 
      select="@name"/>

    <xsl:variable name="aim_entity"
      select="translate($arm_entity,$UPPER,$LOWER)"/>
    <xsl:text>
      
    </xsl:text>
    <xsl:comment>
      <xsl:value-of select="concat('  ++  ',
                            translate($aim_entity,$LOWER,$UPPER), 
                            '  ++ ')"/>
    </xsl:comment>
    <xsl:element name="ae">
      <xsl:attribute name="entity">
        <xsl:value-of select="$arm_entity"/>
      </xsl:attribute>
      <xsl:element name="aimelt">-</xsl:element>
        <!--  <xsl:value-of select="$aim_entity"/> -->
      <xsl:element name="source">ISO 10303-</xsl:element>
      <xsl:element name="refpath">-</xsl:element>
      <xsl:apply-templates select="./explicit"/>
    </xsl:element>
  </xsl:template>

  
  <xsl:template match="explicit">
    <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
    <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
    <xsl:variable name="aim_attr"
		  select="concat(translate(../@name,$UPPER,$LOWER),'.',@name)"/>
    <xsl:variable name="explicit_attr"
		  select="./@name"/>
    
    <xsl:choose>
      <xsl:when test="./builtintype">
      <!-- builtin type so not an assertion -->
	<xsl:element name="aa">
	  <xsl:attribute name="attribute">
	    <xsl:value-of select="@name"/>
	  </xsl:attribute>
	  <xsl:element name="aimelt">-</xsl:element>
	  <xsl:element name="source">ISO 10303-</xsl:element> 

	  <xsl:element name="refpath">-</xsl:element>
	</xsl:element>
      </xsl:when>
      <xsl:when test="./typename and ../type[@name=./typename/@name]/builtintype">
      <!-- defined type so not an assertion -->
	<xsl:element name="aa">
	  <xsl:attribute name="attribute">
	    <xsl:value-of select="@name"/>
	  </xsl:attribute>
	  <xsl:apply-templates select="typename"/>
	  <xsl:if test="not(./typename)">
	    <!-- output PATH -->
	    <xsl:element name="aimelt">-</xsl:element>
	  </xsl:if>
	  <xsl:element name="source">ISO 10303-</xsl:element>
	  <xsl:element name="refpath">-</xsl:element>
	</xsl:element>
      </xsl:when>

      <xsl:when test="./typename and not(../../type/@name=./typename/@name)">
      <!-- probably an entity, or maybe an imported type, but we arent recursing so create a single assertion -->
      <!--      <xsl:when test="./typename and ../../entity/@name=./typename/@name"> -->
	<xsl:element name="aa">
	  <xsl:attribute name="attribute">
	    <xsl:value-of select="@name"/>
	  </xsl:attribute>
	  <xsl:apply-templates select="typename"/>
	  <xsl:if test="not(./typename)">
	    <!-- output PATH -->
	    <xsl:element name="aimelt">-</xsl:element>
	  </xsl:if>
	  <xsl:element name="source">ISO 10303-</xsl:element>
	  <xsl:element name="refpath">-</xsl:element>
	</xsl:element>
      </xsl:when>
      <xsl:when test="./typename and ../../type/select/../@name=./typename/@name">
      <!-- local select type so generates possibly  multiple assertions.  -->
	<xsl:variable name="tname" select="./typename/@name"/>
	<!-- extensible select so create a mapping -->
	<xsl:if test="count(../../type/select[@extensible='YES'][../@name=$tname]) > 0" >
	  <xsl:element name="aa">
	    <xsl:attribute name="attribute">
	      <xsl:value-of select="$explicit_attr"/>
	    </xsl:attribute>
	    <xsl:attribute name="assertion_to">
	      <xsl:value-of select="$tname"/>
	    </xsl:attribute>    
	    <xsl:element name="aimelt">PATH</xsl:element>
	    <xsl:element name="refpath">-</xsl:element>
	  </xsl:element>
	</xsl:if>

	<xsl:variable name="nodes">
	  <xsl:call-template name="list_to_nodes">
	    <xsl:with-param name="string"
			    select="../../type[@name=$tname]/select/@selectitems"/>
	  </xsl:call-template>
	</xsl:variable>
	<xsl:choose>
	  <xsl:when test="string-length($nodes) = 0">
	  </xsl:when>
	  <xsl:when test="function-available('msxsl:node-set')">
	    <xsl:variable name="nodes_set" select="msxsl:node-set($nodes)"/>
	    <xsl:for-each select="$nodes_set//x">
	      <xsl:sort/>
	      <xsl:element name="aa">
		<xsl:attribute name="attribute">
		  <xsl:value-of select="$explicit_attr"/>
		</xsl:attribute>
		<xsl:attribute name="assertion_to">
		  <xsl:value-of select="."/>
		</xsl:attribute>    
		<xsl:element name="aimelt">PATH</xsl:element>
		<xsl:element name="refpath">-</xsl:element>
	      </xsl:element>
	    </xsl:for-each>
	  </xsl:when>
	  <xsl:when test="function-available('exslt:node-set')">
	    <xsl:variable name="nodes_set" select="exslt:node-set($nodes)"/>
	    <xsl:for-each select="$nodes_set//x">
	      <xsl:sort/>
	      <xsl:element name="aa">
		<xsl:attribute name="attribute">
		  <xsl:value-of select="$explicit_attr"/>
		</xsl:attribute>
		<xsl:attribute name="assertion_to">
		  <xsl:value-of select="."/>
		</xsl:attribute>    
		<xsl:element name="aimelt">PATH</xsl:element>
		<xsl:element name="refpath">-</xsl:element>
	      </xsl:element>
	    </xsl:for-each>
	  </xsl:when>
	</xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

    <!-- select is extended so may need more mappings.  -->
    <xsl:template match="select">
    <xsl:if test="./@basedon" >
      <xsl:comment>select <xsl:value-of select="../@name"/>  is based on
      <xsl:value-of select="./@basedon"/>, therefore additional mappings may be required.</xsl:comment>
    </xsl:if>
    </xsl:template>


  <xsl:template match="typename">
      <xsl:attribute name="assertion_to">
        <xsl:value-of select="@name"/>
      </xsl:attribute>    
      <xsl:element name="aimelt">PATH</xsl:element>
  </xsl:template>

</xsl:stylesheet>
