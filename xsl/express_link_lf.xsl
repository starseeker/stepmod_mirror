<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
     $Id: express_link.xsl,v 1.15 2003/03/10 01:26:26 robbod Exp $

  Author: Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep and supplied to NIST under contract.
  Purpose: 
     Used to establish links (URLs) for entities and types that are
     referenced in a LONG FORM schema 
-->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>

<xsl:template name="link_object">
  <xsl:param name="object_name"/>
  <xsl:param name="clause" select="section"/>
  <!-- the schema in which the object has been used -->
  <xsl:param name="object_used_in_schema_name"/>

  <!-- make sure that the arguments don't have any whitespace -->
  <xsl:variable name="lobject_name" 
    select="normalize-space($object_name)"/>
  
  <xsl:variable name="lobject_used_in_schema_name" 
    select="normalize-space($object_used_in_schema_name)"/>

  <xsl:variable name="schema" select="//schema/@name"/>
   

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param 
        name="section1" 
        select="$schema"/>
      <xsl:with-param 
        name="section2" 
        select="$object_name"/>
    </xsl:call-template>
  </xsl:variable>
  <A HREF="#{$aname}">
    <xsl:value-of select="$lobject_name"/>
  </A>

</xsl:template>

</xsl:stylesheet>