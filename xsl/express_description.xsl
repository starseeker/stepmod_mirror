<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
     $Id: express_description.xsl,v 1.4 2002/07/15 08:56:44 goset1 Exp $

  Author: Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep and supplied to NIST under contract.
  Purpose: 
     Used to display the commented XML encoded Express
     in clause 4 and 5 of a module.
-->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>

  <xsl:output method="html"/>

  
<xsl:template name="output_external_description">
  <!--
       The name of the express schema 
       Compulsory parameter -->
  <xsl:param name="schema"/>
  
  <!-- the name of the entity, type, function, rule, procedure, constant 
       Optional parameter -->
  <xsl:param name="entity" select="''"/>
  
  <!-- if an entity, the name of an attribute 
       Optional exclusive parameter -->
  <xsl:param name="attribute" select="''"/>
  
  <!-- if an entity, the name of a where rule 
       Optional exclusive parameter -->
  <xsl:param name="where" select="''"/>

  <!-- if an entity, the name of a unique rule 
       Optional exclusive parameter -->
  <xsl:param name="unique" select="''"/>

  <xsl:variable name="description_file"
    select="/express/@description.file"/>
  
  <!-- 
       only proceed if there is a description file specified in the
       express 
       -->
  <xsl:if test="$description_file">
    <xsl:variable name="xref">
      <xsl:variable name="return1">
        <xsl:choose>
          <xsl:when test="$entity">
            <xsl:value-of select="concat($schema,'.',$entity)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$schema"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <xsl:variable name="return2">
        <xsl:choose>
          <xsl:when test="$attribute">
            <xsl:value-of select="concat($return1,'.',$attribute)"/>
          </xsl:when>
          <xsl:when test="$where">
            <xsl:value-of select="concat($return1,'.wr:',$where)"/>
          </xsl:when>
          <xsl:when test="$unique">
            <xsl:value-of select="concat($return1,'.ur:',$unique)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$return1"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:value-of select="$return2"/>
    </xsl:variable>
    
    <xsl:variable name="description"
      select="document($description_file)/ext_descriptions/ext_description[@linkend=$xref]"/>
    <xsl:apply-templates select="$description"/>      
  </xsl:if>
</xsl:template>

<!-- return false if the description does not exist in an external file -->
<xsl:template name="check_external_description">
  <!--
       The name of the express schema 
       Compulsory parameter -->
  <xsl:param name="schema"/>
  
  <!-- the name of the entity, type, function, rule, procedure, constant 
       Optional parameter -->
  <xsl:param name="entity" select="''"/>
  
  <!-- if an entity, the name of an attribute 
       Optional exclusive parameter -->
  <xsl:param name="attribute" select="''"/>
  
  <!-- if an entity, the name of a where rule 
       Optional exclusive parameter -->
  <xsl:param name="where" select="''"/>

  <!-- if an entity, the name of a unique rule 
       Optional exclusive parameter -->
  <xsl:param name="unique" select="''"/>

  <xsl:variable name="description_file"
    select="/express/@description.file"/>

  <xsl:variable name="found_description">
    <xsl:choose>
      <xsl:when test="$description_file">
        <xsl:variable name="xref">
          <xsl:variable name="return1">
            <xsl:choose>
              <xsl:when test="$entity">
                <xsl:value-of select="concat($schema,'.',$entity)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$schema"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          
          <xsl:variable name="return2">
            <xsl:choose>
              <xsl:when test="$attribute">
                <xsl:value-of select="concat($return1,'.',$attribute)"/>
              </xsl:when>
              <xsl:when test="$where">
                <xsl:value-of select="concat($return1,'.wr:',$where)"/>
              </xsl:when>
              <xsl:when test="$unique">
                <xsl:value-of select="concat($return1,'.ur:',$unique)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$return1"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:value-of select="$return2"/>
        </xsl:variable> <!-- xref -->



        <xsl:variable name="description"
          select="document($description_file)/ext_descriptions/ext_description[@linkend=$xref]"/>
        <!-- debug
        <xsl:message>
          <xsl:value-of select="concat($xref,' -',string-length($description))"/></xsl:message>
          -->

        <xsl:choose>
          <xsl:when test="$description and string-length($description)>1">
            <xsl:value-of select="'true'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'false'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'false'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable> <!-- found_description -->
  <xsl:value-of select="$found_description"/>
</xsl:template>

<xsl:template match="ext_description">
  <xsl:apply-templates />
</xsl:template>


<!-- return the string "notes" if there are any note in the external
     description -->
<xsl:template name="notes_in_external_description">
  <!--
       The name of the express schema 
       Compulsory parameter -->
  <xsl:param name="schema"/>
  
  <!-- the name of the entity, type, function, rule, procedure, constant 
       Optional parameter -->
  <xsl:param name="entity" select="''"/>
  
  <!-- if an entity, the name of an attribute 
       Optional exclusive parameter -->
  <xsl:param name="attribute" select="''"/>
  
  <!-- if an entity, the name of a where rule 
       Optional exclusive parameter -->
  <xsl:param name="where" select="''"/>

  <!-- if an entity, the name of a unique rule 
       Optional exclusive parameter -->
  <xsl:param name="unique" select="''"/>

  <xsl:variable name="description_file"
    select="/express/@description.file"/>
  
  <!-- 
       only proceed if there is a description file specified in the
       express 
       -->
  <xsl:if test="$description_file">
    <xsl:variable name="xref">
      <xsl:variable name="return1">
        <xsl:choose>
          <xsl:when test="$entity">
            <xsl:value-of select="concat($schema,'.',$entity)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$schema"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <xsl:variable name="return2">
        <xsl:choose>
          <xsl:when test="$attribute">
            <xsl:value-of select="concat($return1,'.',$attribute)"/>
          </xsl:when>
          <xsl:when test="$where">
            <xsl:value-of select="concat($return1,'.wr:',$where)"/>
          </xsl:when>
          <xsl:when test="$unique">
            <xsl:value-of select="concat($return1,'.ur:',$unique)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$return1"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:value-of select="$return2"/>
    </xsl:variable>
    
    <xsl:variable name="description"
      select="document($description_file)/ext_descriptions/ext_description[@linkend=$xref]"/>
    <xsl:choose>
      <xsl:when test="$description//note">
        <xsl:value-of select="'notes'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:if>
</xsl:template>




</xsl:stylesheet>