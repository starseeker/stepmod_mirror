<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
     $Id: express_description.xsl,v 1.15 2003/06/25 23:57:00 thendrix Exp $

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
  

  
  <!-- if a type, the name of a type 
       Optional parameter -->
  <xsl:param name="type" select="''"/>
  

  <!-- if an entity, the name of an attribute 
       Optional exclusive parameter -->
  <xsl:param name="attribute" select="''"/>
  
  <!-- if an entity, the name of a where rule 
       Optional exclusive parameter -->
  <xsl:param name="where" select="''"/>

  <!-- if an entity, the name of a unique rule 
       Optional exclusive parameter -->
  <xsl:param name="unique" select="''"/>

  <!-- if an entity, the node
       Optional exclusive parameter -->

      <xsl:param name="supertypes" select="''"/>


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
    <xsl:if test="string-length($attribute)>0">
      <xsl:variable name="attr_start_char"
        select="substring(normalize-space($description),1,1)"/>
      <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

      <xsl:if test="contains($UPPER,$attr_start_char)">
        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Warning Attr1: The first word of the attribute
                    definition should be lower case. It is: ',$attr_start_char)"/>
        </xsl:call-template>
      </xsl:if>

    </xsl:if>

    <!-- this test is not commmitted, as it does not apply to all projects
    <xsl:if test="$description/@linkend and contains($schema,$description/@linkend) and string-length(normalize-space($description)) > 1">
      <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Warning Schem1: Description is provided for schema','')"/>
        </xsl:call-template>        


    </xsl:if>
 -->

      <xsl:variable name="ent_start_char"
        select="substring(normalize-space($entity),1,1)"/>
      <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
      
<!-- -->

<!-- if an entity , that is 
if 
    not a type rule function procedure constant 
and only one dot in string (hence not an attribute) 
and  string is more than the schema name ( hence not the  schema ) 
  ....  

-->

    <xsl:if test="string-length($type)=0 and not(contains(substring-after($description/@linkend,'.'),'.')) and not(contains($schema,$description/@linkend))">


      <xsl:if test="not(contains(substring(normalize-space($description/text()),1),'A'))">
        
      <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Warning Ent1: ',$description/@linkend,  '. Description of entity should start with A or An')"/>
        </xsl:call-template>        
        
      </xsl:if>

      <xsl:if test="not($description/b/text()) and not($description/express_ref)">
      <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Warning Ent2:' , $description/@linkend, '. Should be at least one bold text or express ref in the description of entity. It should contains the entity name ')"/>
        </xsl:call-template>        
      </xsl:if>


      <!-- if -->
      <xsl:if test="not(contains('is',substring-before(normalize-space($description/text()[position()=2]),' ')))">
      <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Warning Ent3: ', $description/@linkend, '. Check that description starts with is ')"/>
        </xsl:call-template>        
      </xsl:if>

      <xsl:if test="not(contains($description/@linkend,$description/b/text())) and not(contains($description/@linkend,$description/express_ref/@linkend))">
      <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Warning Ent4: ',  $description/@linkend, '. There should be at least one bold text or express_ref in the entity description that contains the entity name. ')"/>
        </xsl:call-template>
        
      </xsl:if>

<xsl:if test="string-length($supertypes)>0 and not(contains(normalize-space($description),concat('is a type of ',substring-before($supertypes,' '))))" >
  
      <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Warning Ent5: ',$description/@linkend, ' check for is a type of ', $supertypes,'.')"/>
        </xsl:call-template>        

      </xsl:if>
    </xsl:if>
    <!-- this and everything else I tried does not work - need more complicated set operations for node sets. 
    <xsl:apply-templates select="$description//*[not(../b)/text() | *not(../express_ref)]/text()" mode="chktxt"/>      
-->
    <xsl:apply-templates select="$description" />
     
  </xsl:if>
</xsl:template>

<!-- not used at the moment -->
<xsl:template match="text()" mode="chktxt" >
  <xsl:if test="contains(.,'_')">
      <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Warning Ent6: ',' check for express identifier not bold ')"/>
        </xsl:call-template>
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

  <!-- if a type, the name of the type 
       Optional parameter -->
  <xsl:param name="type" select="''"/>
  
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