<?xml version="1.0"?>
<!--
     $Id: sect_4_express.xsl,v 1.13 2002/02/08 08:18:15 robbod Exp $

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

  <xsl:import href="express_link.xsl"/> 

  <xsl:output method="html"/>

  <!-- +++++++++++++++++++
         Global variables
       +++++++++++++++++++ -->

  <!-- 
       Global variable used in express_link.xsl by:
         link_object
         link_list
       Provides a lookup table of all the references for the entities and
       types indexed through all the interface specifications in the
       express.
       Note:  This variable must defined in each XSL that is used for
       formatting express.
         sect_4_info.xsl
         sect_5_mim.xsl
         sect_e_exp_arm.xsl
         sect_e_exp_mim.xsl
       build_xref_list is defined in express_link
       -->
  <xsl:variable name="global_xref_list">
    <!-- debug 
    <xsl:message>
      global_xref_list defined in sect_4_express.xsl
    </xsl:message> -->
    <xsl:choose>
      <xsl:when test="/module_clause">
        <xsl:variable name="module_dir">
          <xsl:call-template name="module_directory">
            <xsl:with-param name="module" select="/module_clause/@directory"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="express_xml" select="concat($module_dir,'/arm.xml')"/>
        <xsl:call-template name="build_xref_list">
          <xsl:with-param name="express" select="document($express_xml)/express"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="/module">
        <xsl:variable name="module_dir">
          <xsl:call-template name="module_directory">
            <xsl:with-param name="module" select="/module/@name"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="express_xml" select="concat($module_dir,'/arm.xml')"/>
        <xsl:call-template name="build_xref_list">
          <xsl:with-param name="express" select="document($express_xml)/express"/>
        </xsl:call-template>        
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <!-- A global variable used by the express_file_to_ref template defined
       in express_link.xsl.
       It defines the relative path from the file applying the stylesheet
       to the root of the stepmod repository.
       sect_4_express.xsl stylesheet is normally applied from file in:
         stepmod/data/module/?module?/sys/
       Hence the relative root is: ../../../
       -->
  <xsl:variable 
    name="relative_root"
    select="'../../../../'"/>


  <!-- +++++++++++++++++++
         Templates
       +++++++++++++++++++ -->
<xsl:template match="interface">
  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      
  <xsl:if test="position()=1">
    <xsl:variable name="clause_number">
      <xsl:call-template name="express_clause_number">
        <xsl:with-param name="clause" select="'interface'"/>
        <xsl:with-param name="schema_name" select="$schema_name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="clause_header">
      <xsl:choose>
        <xsl:when test="contains($schema_name,'_arm')">
          <xsl:value-of select="concat($clause_number, ' Required AM ARMs')"/>
        </xsl:when>
        <xsl:when test="contains($schema_name,'_mim')">
        </xsl:when>
      </xsl:choose>      
    </xsl:variable>

    <xsl:variable name="clause_intro">
      <xsl:choose>
        <xsl:when test="contains($schema_name,'_arm')">
          The following Express interface statements specify the elements
          imported from the ARMs of other application modules.
        </xsl:when>
        <xsl:when test="contains($schema_name,'_mim')">
          <!-- no intro for the MIM -->
        </xsl:when>
      </xsl:choose>      
    </xsl:variable>
  
    <h3>
      <A NAME="interfaces">
        <xsl:value-of select="$clause_header"/>
      </A>
    </h3>
    <xsl:value-of select="$clause_intro"/>
    <xsl:if test="contains($schema_name,'_arm')">
      <p><u>EXPRESS specification:</u></p>
      *)<br/>
    </xsl:if>

  </xsl:if>

  <blockquote>
    <code>
      <xsl:choose>
        <xsl:when test="@kind='reference'">
          REFERENCE FROM 
          <xsl:call-template name="link_schema">
            <xsl:with-param 
              name="schema_name" 
              select="@schema"/>
            <xsl:with-param name="clause" select="'section'"/>
          </xsl:call-template>
          <xsl:apply-templates select="./interfaced.item"/>;
        </xsl:when>
        <xsl:when test="@kind='use'">
          USE FROM
          <xsl:call-template name="link_schema">
            <!-- defined in sect_4_express_link.xsl -->
            <xsl:with-param 
              name="schema_name" 
              select="@schema"/>
            <xsl:with-param name="clause" select="'section'"/>
          </xsl:call-template>
          <xsl:apply-templates select="./interfaced.item"/>;
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message" 
              select="concat('Interface in schema ', 
                      $schema_name, 
                      ' is incorrectly specified')"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </code>
  </blockquote>

  <xsl:if test="position()=last()">
    (*
  </xsl:if>
</xsl:template>

<xsl:template match="interfaced.item">
  <xsl:if test="position()=1">
    (<br/>
  </xsl:if>

  &#160;&#160;
  <xsl:call-template name="link_object">
    <xsl:with-param name="object_name" select="@name"/>
    <xsl:with-param name="object_used_in_schema_name" 
      select="../../@name"/>
    <xsl:with-param name="clause" select="'section'"/>
  </xsl:call-template>

  <xsl:if test="position()!=last()">,<br/></xsl:if>

  <xsl:if test="position()=last()">)</xsl:if>

</xsl:template>

<xsl:template match="constant">
  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      

  <xsl:variable 
    name="graphics" 
    select="''"/>

  <xsl:variable name="clause_number">
    <xsl:call-template name="express_clause_number">
      <xsl:with-param name="clause" select="'interface'"/>
      <xsl:with-param name="schema_name" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="position()=1">
    <xsl:variable name="clause_header">
      <xsl:choose>
        <xsl:when test="contains($schema_name,'_arm')">
          <xsl:value-of select="concat($clause_number, ' ARM constant definitions')"/>
        </xsl:when>
        <xsl:when test="contains($schema_name,'_mim')">
          <xsl:value-of select="concat($clause_number, ' MIM EXPRESS constants')"/>
        </xsl:when>
      </xsl:choose>      
    </xsl:variable>

    <xsl:variable name="clause_intro">
      <xsl:choose>
        <xsl:when test="contains($schema_name,'_arm')">
          <!-- no intro for the ARM -->
        </xsl:when>
        <xsl:when test="contains($schema_name,'_mim')">
          <!-- no intro for the MIM -->
        </xsl:when>
      </xsl:choose>      
    </xsl:variable>

    <h3>
      <A NAME="constants">
        <xsl:value-of select="$clause_header"/>
      </A>
    </h3>
    <xsl:value-of select="$clause_intro"/>
  </xsl:if>

  <xsl:if test="position()=1">
    <p><u>EXPRESS specification:</u></p>
    *)
    <blockquote>
      <code>
        CONSTANT
      </code>
    </blockquote>
    (*
  </xsl:if>
  
  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>    
  <h3>
    <A NAME="{$aname}">
      <xsl:value-of select="concat($clause_number,'.',position(),' ',@name)"/>
    </A>
  </h3>
  
  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="./@name"/>
  </xsl:call-template> 
  <!-- output description from express -->
  <p>
    <xsl:choose>
      <xsl:when test="./description">
        <xsl:apply-templates select="./description"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="external_description">
          <xsl:call-template name="check_external_description">
            <xsl:with-param name="schema" select="../@name"/>
            <xsl:with-param name="entity" select="./@name"/>
          </xsl:call-template>        
        </xsl:variable>
        <xsl:if test="$external_description='false'">
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message" 
              select="concat('No description provided for ',$aname)"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </p>

    <!-- output EXPRESS -->
    <p><u>EXPRESS specification:</u></p>
    *)
    <blockquote>
      <code>
        &#160;&#160;<xsl:value-of select="@name"/> : <xsl:value-of select="@expression"/>
      </code>
    </blockquote>
    (*
    
    <xsl:if test="position()=last()">
      <br/>
      *)
      <blockquote>
        <code>
          END_CONSTANT;
        </code>
      </blockquote>
      (*
    </xsl:if>

</xsl:template>

<xsl:template match="type" >

  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      

  <xsl:variable 
    name="graphics" 
    select="''"/>

  <xsl:variable name="clause_number">
    <xsl:call-template name="express_clause_number">
      <xsl:with-param name="clause" select="'type'"/>
      <xsl:with-param name="schema_name" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="clause_header">
    <xsl:choose>
      <xsl:when test="contains($schema_name,'_arm')">
        <xsl:value-of select="concat($clause_number, ' ARM type definitions')"/>
      </xsl:when>
      <xsl:when test="contains($schema_name,'_mim')">
          <xsl:value-of select="concat($clause_number, ' MIM EXPRESS types')"/>
      </xsl:when>
    </xsl:choose>      
  </xsl:variable>

  <xsl:variable name="clause_intro">
    <xsl:choose>
      <xsl:when test="contains($schema_name,'_arm')">
        This subclause specifies the application types for this module. The
        application types and their definitions are given below. 
      </xsl:when>
      <xsl:when test="contains($schema_name,'_mim')">
        <!-- no intro for the MIM -->
      </xsl:when>
    </xsl:choose>      
  </xsl:variable>

  <xsl:if test="position()=1">
    <!-- first entity so output the intro -->
    <h3>
      <a name="types">
        <xsl:value-of select="$clause_header"/>
      </a>
    </h3>
    <xsl:value-of select="$clause_intro"/>
  </xsl:if>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>    
  <h3>
    <A NAME="{$aname}">
      <xsl:value-of select="concat($clause_number, '.', position(), ' ', @name)"/>
    </A>
  </h3>
  
  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="./@name"/>
  </xsl:call-template> 
  <!-- output description from express -->

  <p>
    <xsl:choose>
      <xsl:when test="./description">
        <xsl:apply-templates select="./description"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="external_description">
          <xsl:call-template name="check_external_description">
            <xsl:with-param name="schema" select="../@name"/>
            <xsl:with-param name="entity" select="@name"/>
          </xsl:call-template>        
        </xsl:variable>
        <xsl:if test="$external_description='false'">
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message" 
              select="concat('No description provided for ',$aname)"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </p>
  <p><u>EXPRESS specification:</u></p>
  *)
  <blockquote>
    <code>
      TYPE 
      <xsl:value-of select="@name" />
        =
        <xsl:apply-templates select="./aggregate" mode="code"/>        
        <xsl:apply-templates select="./*" mode="underlying"/>;<br/>
      END_TYPE; <br/>
    </code>
  </blockquote>
  (*
</xsl:template>

<!-- empty template to prevent the description element being out put along
     with the code -->
<xsl:template match="description" mode="underlying"/>  

<xsl:template match="typename" mode="underlying">
  <xsl:call-template name="link_object">
    <xsl:with-param name="object_name" select="@name"/>
    <xsl:with-param name="object_used_in_schema_name" 
      select="../../../@name"/>
    <xsl:with-param name="clause" select="'section'"/>
  </xsl:call-template>
</xsl:template>


<xsl:template match="builtintype" mode="underlying">
  <xsl:value-of select="@type" />
</xsl:template>


<xsl:template match="select" mode="underlying">
  <xsl:if test="@extensible='YES'">
    EXTENSIBLE
  </xsl:if>

  <xsl:if test="@genericentity='YES'">
    GENERIC_ENTITY
  </xsl:if>

  SELECT

  <xsl:if test="@basedon">
    BASED ON 
      <xsl:call-template name="link_object">
        <xsl:with-param name="object_name" select="@basedon"/>
        <xsl:with-param name="object_used_in_schema_name" 
          select="../../@name"/>
        <xsl:with-param name="clause" select="'section'"/>
      </xsl:call-template>  
      WITH 
  </xsl:if>
  <xsl:if test="@selectitems and (string-length(@selectitems)!=0)">
  (<xsl:call-template name="link_list">
    <xsl:with-param name="suffix" select="', '"/>
    <xsl:with-param name="list" select="@selectitems"/>
    <xsl:with-param name="object_used_in_schema_name"
      select="../../@name"/>
    <xsl:with-param name="clause" select="'section'"/>
  </xsl:call-template>)</xsl:if></xsl:template>


<xsl:template match="enumeration" mode="underlying">
  ENUMERATION OF 
  <br/>
  &#160;&#160; 
  <xsl:value-of 
    select="concat('(',translate(normalize-space(@items),' ', ','),')')"/>
</xsl:template>


<xsl:template match="entity">

  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      
  <xsl:variable name="clause_number">
    <xsl:call-template name="express_clause_number">
      <xsl:with-param name="clause" select="'entity'"/>
      <xsl:with-param name="schema_name" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="position()=1">
    <!-- first entity so output the intro -->    
    <xsl:variable name="clause_header">
      <xsl:choose>
        <xsl:when test="contains($schema_name,'_arm')">
          <xsl:value-of select="concat($clause_number, ' ARM entity definitions')"/>
        </xsl:when>
        <xsl:when test="contains($schema_name,'_mim')">
          <xsl:value-of select="concat($clause_number, ' MIM EXPRESS entities')"/>
        </xsl:when>
      </xsl:choose>      
    </xsl:variable>

    <xsl:variable name="clause_intro">
      <xsl:choose>
        <xsl:when test="contains($schema_name,'_arm')">
          This subclause specifies the application entities for this
          module. Each application entity is an atomic element that
          embodies a unique application concept and contains attributes
          specifying the data elements of the entity. The application
          entities and their definitions are given below. 
        </xsl:when>
        <xsl:when test="contains($schema_name,'_mim')">
          <!-- no intro for the MIM -->
        </xsl:when>
      </xsl:choose>      
    </xsl:variable>

    <h3>
      <a name="entities">
        <xsl:value-of select="$clause_header"/>
      </a>
    </h3>
    <xsl:value-of select="$clause_intro"/>
  </xsl:if>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <h3>
    <A NAME="{$aname}">
      <xsl:value-of select="concat($clause_number,'.',position(),' ',@name)"/>
    </A>
  </h3>
  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="@name"/>
  </xsl:call-template> 
  <!-- output description from express -->
  <p>
    <xsl:choose>
      <xsl:when test="./description">
        <xsl:apply-templates select="./description"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="external_description">
          <xsl:call-template name="check_external_description">
            <xsl:with-param name="schema" select="../@name"/>
            <xsl:with-param name="entity" select="@name"/>
          </xsl:call-template>        
        </xsl:variable>
        <xsl:if test="$external_description='false'">
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message" 
              select="concat('No description provided for ',@name)"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </p>
  <p><u>EXPRESS specification:</u></p>
  *)
  <blockquote>
    <code>
      ENTITY <xsl:value-of select="@name"/>
      <xsl:call-template name="super.expression-code"/>
      <xsl:call-template name="supertypes-code"/>;    
      <br/>
      <xsl:apply-templates select="./explicit" mode="code"/>
      <xsl:apply-templates select="./derived" mode="code"/>
      <xsl:apply-templates select="./inverse" mode="code"/>
      <xsl:apply-templates select="./unique" mode="code"/>
      <xsl:apply-templates select="./where[@expression]" mode="code"/>
      END_ENTITY;<br/>
    </code>
  </blockquote>
  (*
  <xsl:apply-templates select="./explicit" mode="description"/>    
  <xsl:apply-templates select="./derived" mode="description"/>    
  <xsl:apply-templates select="./inverse" mode="description"/>  
  <xsl:apply-templates select="./unique" mode="description"/>
  <xsl:call-template name="output_where_formal"/>
  <xsl:call-template name="output_where_informal"/>
</xsl:template>


<xsl:template name="super.expression-code">
  <!-- check of the expression already ends in () -->
  <xsl:variable name="open_paren">
    <xsl:if test="not(starts-with(normalize-space(@super.expression),'('))">
      (
    </xsl:if>
  </xsl:variable>
  <xsl:variable name="close_paren">
    <xsl:if test="$open_paren">
      )
    </xsl:if>
  </xsl:variable>

  <xsl:if test="@abstract.supertype='YES'">
    <br/>
    &#160; ABSTRACT SUPERTYPE
    <xsl:if test="@super.expression">
      OF 
    </xsl:if>
  </xsl:if>

  <xsl:if test="@super.expression">
    <br/>
    &#160; <xsl:value-of select="concat($open_paren,@super.expression,$close_paren)"/>
  </xsl:if>
</xsl:template>

<xsl:template name="supertypes-code">
  <xsl:if test="@supertypes">
    <br/>
    &#160; SUBTYPE OF (<xsl:call-template name="link_list">
      <xsl:with-param name="list" select="@supertypes"/>
        <xsl:with-param name="suffix" select="', '"/>
      <xsl:with-param name="object_used_in_schema_name" select="../@name"/>
      <xsl:with-param name="clause" select="'section'"/>
    </xsl:call-template>)
  </xsl:if>
</xsl:template>

<xsl:template match="explicit" mode="code">
  &#160;&#160; 
  <xsl:value-of select="concat(@name, ' : ')"/>
  <xsl:if test="@optional='YES'">
    OPTIONAL 
  </xsl:if>
  <xsl:apply-templates select="./aggregate" mode="code"/>
  <xsl:apply-templates select="./*" mode="underlying"/>;<br/>
</xsl:template>


<xsl:template match="derived" mode="code">
  <xsl:if test="position()=1">
    &#160;&#160;DERIVE<br/>
  </xsl:if>
  &#160;&#160;&#160;
  <!-- need to clarify the XML for derive --> 
  <xsl:value-of select="concat(@name, ' : ')"/>
  <xsl:apply-templates select="./aggregate" mode="code"/>
  <xsl:apply-templates select="./*" mode="underlying"/>
  <xsl:value-of select="concat(' : ',@expression,';')"/><br/>
</xsl:template>

<xsl:template match="inverse" mode="code">
  <xsl:if test="position()=1">
    &#160;&#160;INVERSE<br/>
  </xsl:if>
  &#160;&#160;&#160;
  <xsl:value-of select="concat(@name, ' : ')"/>
  <xsl:apply-templates select="./inverse.aggregate" mode="code"/>;<br/>
</xsl:template>

<xsl:template match="inverse.aggregate" mode="code">
  <xsl:value-of select="concat(@type, '[', @lower, ':', @upper, '] OF ')"/>
  <xsl:call-template name="link_object">
    <xsl:with-param name="object_name" select="../@entity"/>
    <xsl:with-param name="object_used_in_schema_name" 
      select="../../../@name"/>
    <xsl:with-param name="clause" select="'section'"/>
  </xsl:call-template>  
  <xsl:value-of select="concat(' FOR ', ../@attribute)"/>
</xsl:template>

<xsl:template match="unique" mode="code">
  <xsl:if test="position()=1">
    &#160;&#160; 
    UNIQUE<br/>
  </xsl:if>
  &#160;&#160;&#160;
  <xsl:value-of select="concat(@label, ': ')"/>
  <xsl:apply-templates select="./unique.attribute" mode="code"/>
  <br/>
</xsl:template>


<xsl:template match="unique.attribute" mode="code">
  <xsl:choose>
    <xsl:when test="position()!=last()">
      <xsl:value-of select="concat(@attribute,', ')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat(@attribute,';')"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="aggregate" mode="code">
  <xsl:choose>
    <xsl:when test="@lower">
      <xsl:value-of select="concat(@type, '[', @lower, ':', @upper, '] OF ')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat(@type, ' OF ')"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="where" mode="code">
  <xsl:if test="position()=1">
    &#160;&#160;WHERE<br/>
  </xsl:if>  
  &#160;&#160;&#160;
  <xsl:value-of select="concat(@label, ': ', @expression, ';')"/>
  <br/>
</xsl:template>

<xsl:template match="graphic.element" mode="code">
</xsl:template>


<xsl:template match="explicit" mode="description">
  <xsl:if test="position()=1">
    <p><u>Attribute definitions:</u></p>
  </xsl:if>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="../../@name"/>
      <xsl:with-param name="section2" select="../@name"/>
      <xsl:with-param name="section3" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <blockquote>
    <b>
      <a name="{$aname}">
        <xsl:value-of select="@name"/>:
      </a>
    </b>

  <!-- get description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../../@name"/>
    <xsl:with-param name="entity" select="../@name"/>
    <xsl:with-param name="attribute" select="@name"/>
  </xsl:call-template>
  
  <!-- output description from express -->
  <xsl:choose>
    <xsl:when test="./description">
      <xsl:apply-templates select="./description"/>
    </xsl:when>
    <xsl:otherwise>      
      <xsl:variable name="external_description">
        <xsl:call-template name="check_external_description">
          <xsl:with-param name="schema" select="../../@name"/>
          <xsl:with-param name="entity" select="../@name"/>
          <xsl:with-param name="attribute" select="@name"/>
        </xsl:call-template>        
      </xsl:variable>
      <xsl:if test="$external_description='false'">
        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('No description provided for ',$aname)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</blockquote>
</xsl:template>

<xsl:template match="derived" mode="description">
  <!-- check that this is the first derived attribute and that the
       there are no explicit attribute - if there were then Attribute
       definitions" would have already been output -->
  <xsl:if test="position()=1 and not(../explicit)">
    <p><u>Attribute definitions:</u></p>
  </xsl:if>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="../../@name"/>
      <xsl:with-param name="section2" select="../@name"/>
      <xsl:with-param name="section3" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <blockquote>
    <b>
      <a name="{$aname}">
        <xsl:value-of select="@name"/>:
      </a>
    </b>
  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../../@name"/>
    <xsl:with-param name="entity" select="../@name"/>
    <xsl:with-param name="attribute" select="@name"/>
  </xsl:call-template>
  <!-- output description from express -->
    <xsl:choose>
      <xsl:when test="./description">
        <xsl:apply-templates select="./description"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="external_description">
          <xsl:call-template name="check_external_description">
            <xsl:with-param name="schema" select="../../@name"/>
            <xsl:with-param name="entity" select="../@name"/>
            <xsl:with-param name="attribute" select="@name"/>
          </xsl:call-template>        
        </xsl:variable>
        <xsl:if test="$external_description='false'">
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message" 
              select="concat('No description provided for ',$aname)"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </blockquote>
</xsl:template>

<xsl:template match="inverse" mode="description">

  <xsl:if test="position()=1 and not(../explicit | ../derived)">
    <p><u>Attribute definitions:</u></p>
  </xsl:if>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="../../@name"/>
      <xsl:with-param name="section2" select="../@name"/>
      <xsl:with-param name="section3" select="@name"/>
    </xsl:call-template>
  </xsl:variable>
  
  <blockquote>
    <b>
      <a name="{$aname}">
        <xsl:value-of select="@name"/>:
      </a>
    </b>

  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../../@name"/>
    <xsl:with-param name="entity" select="../@name"/>
    <xsl:with-param name="attribute" select="@name"/>
  </xsl:call-template>
  <!-- output description from express -->
    <xsl:choose>
      <xsl:when test="./description">
        <xsl:apply-templates select="./description"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="external_description">
          <xsl:call-template name="check_external_description">
            <xsl:with-param name="schema" select="../../@name"/>
            <xsl:with-param name="entity" select="../@name"/>
            <xsl:with-param name="attribute" select="@name"/>
          </xsl:call-template>        
        </xsl:variable>
        <xsl:if test="$external_description='false'">
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message" 
              select="concat('No description provided for ',$aname)"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </blockquote>
</xsl:template>



<xsl:template match="unique" mode="description">
  <xsl:if test="position()=1">
    <p><u>Formal propositions:</u></p>
  </xsl:if>  

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="../../@name"/>
      <xsl:with-param name="section2" select="../@name"/>
      <xsl:with-param name="section3" select="@label"/>
      <xsl:with-param name="section3separator" select="'.ur:'"/>
    </xsl:call-template>
  </xsl:variable>

  <blockquote>
    <b>
      <a name="{$aname}">
        <xsl:value-of select="concat(@label,' : ')"/>
      </a>
    </b>
    <!-- output description from external file -->
    <xsl:call-template name="output_external_description">
      <xsl:with-param name="schema" select="../../@name"/>
      <xsl:with-param name="entity" select="../@name"/>
      <xsl:with-param name="unique" select="./@name"/>
    </xsl:call-template>
    <!-- output description from express -->
    
    <xsl:choose>
      <xsl:when test="./description">
        <xsl:apply-templates select="./description"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="external_description">
          <xsl:call-template name="check_external_description">
            <xsl:with-param name="schema" select="../../@name"/>
            <xsl:with-param name="entity" select="../@name"/>
            <xsl:with-param name="unique" select="./@name"/>
          </xsl:call-template>        
        </xsl:variable>
        <xsl:if test="$external_description='false'">
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message" 
              select="concat('No description provided for ',$aname)"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </blockquote>
</xsl:template>

<xsl:template name="output_where_formal">
  <xsl:if test="./where[@expression] and not(./unique)">
    <p><u>Formal propositions:</u></p>
  </xsl:if>
  <xsl:apply-templates select="./where[@expression]" mode="description"/>
</xsl:template>

<xsl:template name="output_where_informal">
  <xsl:if test="./where[not(@expression)]">
    <p><u>Informal propositions:</u></p>
  </xsl:if>
  <xsl:apply-templates select="./where[not(@expression)]" mode="description"/>
</xsl:template>


<xsl:template match="where" mode="description">

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="../../@name"/>
      <xsl:with-param name="section2" select="../@name"/>
      <xsl:with-param name="section3" select="@label"/>
      <xsl:with-param name="section3separator" select="'.wr:'"/>
    </xsl:call-template>
  </xsl:variable>

  <blockquote>
    <b>
      <a name="{$aname}">
        <xsl:value-of select="concat(@label,' : ')"/>
      </a>
    </b>

  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../../@name"/>
    <xsl:with-param name="entity" select="../@name"/>
    <xsl:with-param name="where" select="./@name"/>
  </xsl:call-template>
  <!-- output description from express -->

    <xsl:choose>
      <xsl:when test="./description">
        <xsl:apply-templates select="./description"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="external_description">
          <xsl:call-template name="check_external_description">
            <xsl:with-param name="schema" select="../../@name"/>
            <xsl:with-param name="entity" select="../@name"/>
            <xsl:with-param name="where" select="@name"/>
          </xsl:call-template>        
        </xsl:variable>
        <xsl:if test="$external_description='false'">
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message" 
              select="concat('No description provided for ',$aname)"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </blockquote>
</xsl:template>


<xsl:template match="function">
  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      
  <xsl:variable name="clause_number">
    <xsl:call-template name="express_clause_number">
      <xsl:with-param name="clause" select="'function'"/>
      <xsl:with-param name="schema_name" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="position()=1">
    <!-- first entity so output the intro -->
    <xsl:variable name="clause_header">
      <xsl:choose>
        <xsl:when test="contains($schema_name,'_arm')">
          <xsl:value-of select="concat($clause_number, ' ARM function definitions')"/>
        </xsl:when>
        <xsl:when test="contains($schema_name,'_mim')">
          <xsl:value-of select="concat($clause_number, ' MIM EXPRESS functions')"/>
        </xsl:when>
      </xsl:choose>      
    </xsl:variable>

    <xsl:variable name="clause_intro">
      <xsl:choose>
        <xsl:when test="contains($schema_name,'_arm')">
        </xsl:when>
        <xsl:when test="contains($schema_name,'_mim')">
          <!-- no intro for the MIM -->
        </xsl:when>
      </xsl:choose>      
    </xsl:variable>

    <h3>
      <a name="functions">
        <xsl:value-of select="$clause_header"/>
      </a>
    </h3>
    <xsl:value-of select="$clause_intro"/>
  </xsl:if>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>
             
  <h3>
    <A NAME="{$aname}">
      <xsl:value-of select="concat($clause_number,'.',position(),' ',@name)"/>
    </A>
  </h3>
  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="@name"/>
  </xsl:call-template>
  <!-- output description from express -->
  <xsl:choose>
    <xsl:when test="./description">
      <xsl:apply-templates select="./description"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="external_description">
        <xsl:call-template name="check_external_description">
          <xsl:with-param name="schema" select="../@name"/>
          <xsl:with-param name="entity" select="@name"/>
        </xsl:call-template>        
      </xsl:variable>
      <xsl:if test="$external_description='false'">
        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('No description provided for ',$aname)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>

  <!-- output the EXPRESS -->
  <p><u>EXPRESS specification:</u></p>
  *)
  <blockquote>
    <code>
      FUNCTION <xsl:value-of select="@name"/>
      <xsl:apply-templates select="./parameter" mode="code"/><xsl:text> : </xsl:text>
      <xsl:apply-templates select="./*" mode="underlying"/>;
      <pre>
        <xsl:apply-templates select="./algorithm" mode="code"/>
      </pre>
      END_FUNCTION;
    </code>
  </blockquote>


</xsl:template>

<xsl:template match="procedure">  
  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      
  <xsl:variable name="clause_number">
    <xsl:call-template name="express_clause_number">
      <xsl:with-param name="clause" select="'procedure'"/>
      <xsl:with-param name="schema_name" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="position()=1">
    <!-- first entity so output the intro -->
    <xsl:variable name="clause_header">
      <xsl:choose>
        <xsl:when test="contains($schema_name,'_arm')">
          <xsl:value-of select="concat($clause_number, ' ARM procedure definitions')"/>
        </xsl:when>
        <xsl:when test="contains($schema_name,'_mim')">
          <xsl:value-of select="concat($clause_number, ' MIM EXPRESS procedures')"/>
        </xsl:when>
      </xsl:choose>      
    </xsl:variable>

    <xsl:variable name="clause_intro">
      <xsl:choose>
        <xsl:when test="contains($schema_name,'_arm')">
        </xsl:when>
        <xsl:when test="contains($schema_name,'_mim')">
          <!-- no intro for the MIM -->
        </xsl:when>
      </xsl:choose>      
    </xsl:variable>

    <h3>
      <a name="procedures">
        <xsl:value-of 
          select="$clause_header"/>
      </a>
      </h3> 
      <xsl:value-of select="$clause_intro"/>
  </xsl:if>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <h3>
    <A NAME="{$aname}">
      <xsl:value-of select="concat($clause_number,'.',position(),' ',@name)"/>
    </A>
  </h3>
  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="@name"/>
  </xsl:call-template>
  <!-- output description from express -->
  <xsl:choose>
    <xsl:when test="./description">
      <xsl:apply-templates select="./description"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="external_description">
        <xsl:call-template name="check_external_description">
          <xsl:with-param name="schema" select="../@name"/>
          <xsl:with-param name="entity" select="@name"/>
        </xsl:call-template>        
      </xsl:variable>
      <xsl:if test="$external_description='false'">
        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('No description provided for ',$aname)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
  
  <!-- output the EXPRESS -->
  <p><u>EXPRESS specification:</u></p>
  *)
  <blockquote>
    <code>
      PROCEDURE <xsl:value-of select="@name"/>
    <xsl:apply-templates select="./parameter" mode="code"/><xsl:text> : </xsl:text>
    <xsl:apply-templates select="./*" mode="underlying"/>;
    <pre>
      <xsl:apply-templates select="./algorithm" mode="code"/>
    </pre>
    END_PROCEDURE;
    </code>
  </blockquote>
  (*
</xsl:template>

<!-- empty template to prevent the algorithm element being out put along
     with the code -->
<xsl:template match="parameter" mode="underlying"/>


<xsl:template match="parameter" mode="code">
  <xsl:if test="position()=1">&#160;(</xsl:if>
  <xsl:value-of select="@name"/><xsl:text> : </xsl:text>
  <xsl:apply-templates select="./aggregate" mode="code"/>
  <xsl:apply-templates select="./*" mode="underlying"/>
  <xsl:choose>
    <xsl:when test="position()!=last()">
      <xsl:text>, </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>)</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="algorithm" mode="code">
  <xsl:value-of select="."/>
</xsl:template>

<!-- empty template to prevent the algorithm element being out put along
     with the code -->
<xsl:template match="algorithm" mode="underlying"/>


<xsl:template match="rule">  
  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      
  <xsl:variable name="clause_number">
    <xsl:call-template name="express_clause_number">
      <xsl:with-param name="clause" select="'rule'"/>
      <xsl:with-param name="schema_name" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="position()=1">
    <!-- first entity so output the intro -->
    <xsl:variable name="clause_header">
      <xsl:choose>
        <xsl:when test="contains($schema_name,'_arm')">
          <xsl:value-of select="concat($clause_number, ' ARM rule definitions')"/>
        </xsl:when>
        <xsl:when test="contains($schema_name,'_mim')">
          <xsl:value-of select="concat($clause_number, ' MIM rule definitions')"/>
        </xsl:when>
      </xsl:choose>      
    </xsl:variable>

    <xsl:variable name="clause_intro">
      <xsl:choose>
        <xsl:when test="contains($schema_name,'_arm')">
        </xsl:when>
        <xsl:when test="contains($schema_name,'_mim')">
          <!-- no intro for the MIM -->
        </xsl:when>
      </xsl:choose>      
    </xsl:variable>
    <h3>
      <a name="rules">
        <xsl:value-of select="$clause_header"/>
      </a>
    </h3>
    <xsl:value-of select="$clause_intro"/>
  </xsl:if>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <h3>
    <A NAME="{$aname}">
      <xsl:value-of select="concat($clause_number,'.',position(),' ',@name)"/>
    </A>
  </h3>

  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="@name"/>
  </xsl:call-template>
  <!-- output description from express -->
  <xsl:choose>
    <xsl:when test="./description">
      <xsl:apply-templates select="./description"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="external_description">
        <xsl:call-template name="check_external_description">
          <xsl:with-param name="schema" select="../@name"/>
          <xsl:with-param name="entity" select="@name"/>
        </xsl:call-template>        
      </xsl:variable>
      <xsl:if test="$external_description='false'">
        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('No description provided for ',$aname)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
  
  <!-- output the EXPRESS -->
  <p><u>EXPRESS specification:</u></p>
  *)
  <blockquote>
    <code>
      RULE <xsl:value-of select="@name"/> FOR
      <br/>
      &#160;(<xsl:value-of select="translate(@appliesto,' ',', ')"/>);
      <pre>
        <xsl:apply-templates select="./algorithm" mode="code"/>
        <xsl:apply-templates select="./where" mode="code"/>
      </pre>
      END_RULE;
    </code>
  </blockquote>
  <p><u>Argument definitions:</u></p>        
  <xsl:call-template name="process_rule_arguments">
    <xsl:with-param name="args" select="@appliesto"/>
  </xsl:call-template>

  <xsl:apply-templates select="./where[@expression]" mode="description"/>
  <xsl:apply-templates select="./where[not(@expression)]" mode="description"/>

  (*
</xsl:template>

<xsl:template name="process_rule_arguments">
  <xsl:param name="args"/>
  <xsl:choose>
    <!-- single argument -->
    <xsl:when test="not(contains($args,' '))">
      <xsl:call-template name="output_rule_argument">
        <xsl:with-param name="arg" select="$args"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="arg1" select="substring-before($args,' ')"/>
      <xsl:variable name="rest" select="substring-after($args,' ')"/>
      <xsl:call-template name="output_rule_argument">
        <xsl:with-param name="arg" select="$arg1"/>
      </xsl:call-template>
      <xsl:if test="$rest">
        <xsl:call-template name="process_rule_arguments">
          <xsl:with-param name="args" select="$rest"/>
        </xsl:call-template>
      </xsl:if>      
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="output_rule_argument">
  <xsl:param name="arg"/>
  <blockquote>
    <b>
      <xsl:value-of select="concat($arg,' : ')"/>
    </b>
    <!-- output the default description -->
    the set of all instances of 
    <xsl:call-template name="link_object">
      <xsl:with-param name="object_name" select="$arg"/>
      <xsl:with-param name="object_used_in_schema_name" 
        select="../../@name"/>
      <xsl:with-param name="clause" select="'section'"/>
    </xsl:call-template>  

  </blockquote>
</xsl:template>


<!-- 
     Express is displayed in clauses: 
     Interfaces
     Constants
     Imported Constants
     Types
     Imported Types
     Entities
     Imported Entities
     Functions
     Imported Functions
     Rules
     Imported Rules
     Procedures
     Imported Procedures
     Template checks to see whether a particular clause is present in the
     schema. 
     If it is the clause number is returned. If not 0 is returned.
     The clause argument is: 
     interface constant type entity function rule procedure
     imported_constant imported_type imported_entity 
     imported_function imported_rule imported_procedure
-->
<xsl:template name="express_clause_present">
  <xsl:param name="clause"/>
  <xsl:param name="schema_name"/>

  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="xml_file">
    <xsl:choose>
      <xsl:when test="contains($schema_name,'_arm')">
        <xsl:value-of select="concat($module_dir,'/arm.xml')"/>
      </xsl:when>
      <xsl:when test="contains($schema_name,'_mim')">
        <xsl:value-of select="concat($module_dir,'/mim.xml')"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- should never get here -->
        1000
      </xsl:otherwise>
    </xsl:choose>      
  </xsl:variable>

  <xsl:variable name="clause_present">
    <xsl:choose>
      <xsl:when test="$clause='interface'">
        <xsl:choose>
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string -->
          <xsl:when
            test="document(string($xml_file))/express/schema/interface">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="clause" select="'interface'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='constant'">
        <xsl:choose>          
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string -->
          <xsl:when
            test="document(string($xml_file))/express/schema/constant">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="clause" select="'constant'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='type'">
        <xsl:choose>          
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string -->
          <xsl:when
            test="document(string($xml_file))/express/schema/type">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="clause" select="'type'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='entity'">
        <xsl:choose>          
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string -->
          <xsl:when
            test="document(string($xml_file))/express/schema/entity">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="clause" select="'entity'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='function'">
        <xsl:choose>
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string -->
          <xsl:when
            test="document(string($xml_file))/express/schema/function">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="clause" select="'function'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='rule'">
        <xsl:choose>
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string -->
          <xsl:when
            test="document(string($xml_file))/express/schema/rule">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="clause" select="'rule'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='procedure'">
        <xsl:choose>
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string -->
          <xsl:when
            test="document(string($xml_file))/express/schema/procedure">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="clause" select="'procedure'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      
      <xsl:when test="$clause='imported_constant'">
        <xsl:choose>          
        <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string --> 
          <xsl:when
            test="document(string($xml_file))/express/schema/interface/described.item[@kind='CONSTANT']">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="clause" select="'imported_constant'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='imported_type'">
        <xsl:choose>          
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string --> 
          <xsl:when
            test="document(string($xml_file))/express/schema/interface/described.item[@kind='TYPE']">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="clause" select="'imported_type'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='imported_entity'">
        <xsl:choose>          
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string --> 
          <xsl:when
            test="document(string($xml_file))/express/schema/interface/described.item[@kind='ENTITY']">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="clause" select="'imported_entity'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='imported_function'">
        <xsl:choose>          
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string --> 
          <xsl:when
            test="document(string($xml_file))/express/schema/interface/described.item[@kind='FUNCTION']">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="clause" select="'imported_function'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='imported_rule'">
        <xsl:choose>          
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string --> 
          <xsl:when
            test="document(string($xml_file))/express/schema/interface/described.item[@kind='RULE']">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="clause" select="'imported_rule'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='imported_procedure'">
        <xsl:choose>          
        <!-- There seems to be a bug in MXSL3. 
             Should not need to convert $xml_file to a string --> 
        <xsl:when
            test="document(string($xml_file))/express/schema/interface/described.item[@kind='PROCEDURE']"> 
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="clause" select="'imported_procedure'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$clause_present"/>
</xsl:template>






<!--
     The order of the clauses describing the express is:
     Interfaces
     Constants
     Imported Constants
     Types
     Imported Types
     Entities
     Imported Entities
     Functions
     Imported Functions
     Rules
     Imported Rules
     Procedures
     Imported Procedures
     Each set of constructs is in a separate clause. The clauses are
     numbered consecutively.
     If the express does not contain a particular set of express
     constructs, then the clause is not output. This will obviously affect
     the numbering of the clauses.
          
     This template will return the number of the clause according to
     whether any of the previous express clauses are required.
     the clause argument is: 
     interface 
     constant type entity function rule procedure
     imported_constant imported_type imported_entity 
     imported_function imported_rule imported_procedure
-->
<xsl:template name="express_clause_number">
  <xsl:param name="clause"/>
  <xsl:param name="schema_name"/>

  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="xml_file">
    <xsl:choose>
      <xsl:when test="contains($schema_name,'_arm')">
        <xsl:value-of select="concat($module_dir,'/arm.xml')"/>
      </xsl:when>
      <xsl:when test="contains($schema_name,'_mim')">
        <xsl:value-of select="concat($module_dir,'/mim.xml')"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- should never get here -->
        1000
      </xsl:otherwise>
    </xsl:choose>      
  </xsl:variable>


  <!-- create a variable for each clause then assign 1 to it if the clause
       exists in the express. Then add them together to give the number       
       -->
  <xsl:variable name="interface_clause">
    <xsl:choose>
      <!-- Only clause 4 (ARM) puts USE/REFERENCE FROMs in a separate
           clause -->
      <xsl:when test="contains($schema_name,'_arm')">
        <xsl:choose>
          <xsl:when
            test="document(string($xml_file))/express/schema/interface">
            1
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>        
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>

  </xsl:variable>

  <xsl:variable name="constant_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/constant">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="imported_constant_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/interface/described.item[@kind='CONSTANT']">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="type_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/type">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="imported_type_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/interface/described.item[@kind='TYPE']">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


  <xsl:variable name="entity_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/entity">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="imported_entity_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/interface/described.item[@kind='ENTITY' or @kind='ATTRIBUTE']">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


  <xsl:variable name="function_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/function">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="imported_function_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/interface/described.item[@kind='FUNCTION']">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="rule_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/rule">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="imported_rule_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/interface/described.item[@kind='RULE']">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="procedure_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/procedure">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="imported_procedure_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/interface/described.item[@kind='PROCEDURE']">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


  <!-- now add the clause variables together according to which clause
       number is required -->
  <xsl:variable name="clause_number">
    <xsl:choose>
      <xsl:when test="$clause='interface'">
        <xsl:value-of select="$interface_clause"/>
      </xsl:when>

      <xsl:when test="$clause='constant'">
        <xsl:value-of select="$interface_clause + $constant_clause"/>
      </xsl:when>
      <xsl:when test="$clause='imported_constant'">
        <xsl:value-of select="$interface_clause + 
                              $constant_clause + $imported_constant_clause"/>
      </xsl:when>

      <xsl:when test="$clause='type'">
        <xsl:value-of select="$interface_clause + 
                              $constant_clause + $imported_constant_clause + 
                              $type_clause"/>
      </xsl:when>
      <xsl:when test="$clause='imported_type'">
        <xsl:value-of select="$interface_clause + 
                              $constant_clause + $imported_constant_clause + 
                              $type_clause + $imported_type_clause"/>
      </xsl:when>

      <xsl:when test="$clause='entity'">
        <xsl:value-of select="$interface_clause + 
                              $constant_clause + $imported_constant_clause +
                              $type_clause + $imported_type_clause +
                              $entity_clause"/>
      </xsl:when>
      <xsl:when test="$clause='imported_entity'">
        <xsl:value-of select="$interface_clause + 
                              $constant_clause + $imported_constant_clause +
                              $type_clause + $imported_type_clause + 
                              $entity_clause + $imported_entity_clause"/>
      </xsl:when>

      <xsl:when test="$clause='function'">
        <xsl:value-of select="$interface_clause + 
                              $constant_clause + $imported_constant_clause +
                              $type_clause + $imported_type_clause + 
                              $entity_clause + $imported_entity_clause + 
                              $function_clause"/>
      </xsl:when>
      <xsl:when test="$clause='imported_function'">
        <xsl:value-of select="$interface_clause + 
                              $constant_clause + $imported_constant_clause +
                              $type_clause + $imported_type_clause + 
                              $entity_clause + $imported_entity_clause + 
                              $function_clause + $imported_function_clause"/>
      </xsl:when>

      <xsl:when test="$clause='rule'">
        <xsl:value-of select="$interface_clause + 
                              $constant_clause + $imported_constant_clause +
                              $type_clause + $imported_type_clause + 
                              $entity_clause + $imported_entity_clause + 
                              $function_clause + $imported_function_clause +
                              $rule_clause"/>
      </xsl:when>
      <xsl:when test="$clause='imported_rule'">
        <xsl:value-of select="$interface_clause + 
                              $constant_clause + $imported_constant_clause +
                              $type_clause + $imported_type_clause + 
                              $entity_clause + $imported_entity_clause + 
                              $function_clause + $imported_function_clause +
                              $rule_clause + $imported_rule_clause"/>
      </xsl:when>

      <xsl:when test="$clause='procedure'">
        <xsl:value-of select="$interface_clause + 
                              $constant_clause + $imported_constant_clause +
                              $type_clause + $imported_type_clause +
                              $entity_clause + $imported_entity_clause + 
                              $function_clause + $imported_function_clause +
                              $rule_clause + $imported_rule_clause +
                              $procedure_clause"/>
      </xsl:when>
      <xsl:when test="$clause='imported_procedure'">
        <xsl:value-of select="$interface_clause + 
                              $constant_clause + $imported_constant_clause +
                              $type_clause + $imported_type_clause + 
                              $entity_clause + $imported_entity_clause + 
                              $function_clause + $imported_function_clause +
                              $rule_clause + $imported_rule_clause +
                              $procedure_clause + $imported_procedure_clause"/>
      </xsl:when>

    </xsl:choose>    
  </xsl:variable>

  <!-- if the schema ends in _arm then it is clause 4
       if it ends in _mim then it is clause 5.2
       -->
  <xsl:variable name="main_clause">
    <xsl:choose>
      <xsl:when test="contains($schema_name,'_arm')">
        <xsl:value-of select="concat('4.',$clause_number+1)"/>
      </xsl:when>
      <xsl:when test="contains($schema_name,'_mim')">
        <xsl:value-of select="concat('5.2.',$clause_number)"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- should never get here -->
        1000
      </xsl:otherwise>
    </xsl:choose>      
  </xsl:variable>

  <xsl:value-of select="$main_clause"/>

</xsl:template>

<!-- to be implemented -->
<xsl:template name="output_external_description">
</xsl:template>

<!-- to be implemented -->
<xsl:template name="check_external_description">
</xsl:template>


<xsl:template name="imported_constructs">
  <xsl:param name="desc_item"/>
  <xsl:if test="$desc_item">
    <xsl:variable name="kind" select="$desc_item/@kind"/>
    <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
    <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
    <xsl:variable name="lkind" select="translate($kind,$UPPER, $LOWER)"/>

    <xsl:variable name="imported_kind" select="concat('imported_',$lkind)"/>
    <xsl:variable name="schema_name" select="$desc_item/../../@name"/>
        <xsl:variable name="clause_number">
          <xsl:call-template name="express_clause_number">
            <xsl:with-param name="clause" select="$imported_kind"/>
            <xsl:with-param name="schema_name" select="$schema_name"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="clause_header">
          <xsl:choose>
            <xsl:when test="contains($schema_name,'_arm')">
              <xsl:value-of select="concat($clause_number, 
                                    ' ARM EXPRESS imported ',
                                    $lkind,' modifications')"/>
            </xsl:when>
            <xsl:when test="contains($schema_name,'_mim')">
              <xsl:value-of select="concat($clause_number, 
                                    ' MIM  EXPRESS imported '
                                    ,$lkind,' modifications')"/>
            </xsl:when>
          </xsl:choose>      
        </xsl:variable>

        <xsl:variable name="aname" select="concat('imported_',$lkind)"/>
        <h3>
          <A NAME="{$aname}">
            <xsl:value-of select="$clause_header"/>
          </A>
        </h3>
        <xsl:apply-templates select="$desc_item"/>                    
      </xsl:if>
</xsl:template>

<xsl:template match="described.item">
  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="lkind" select="translate(@kind,$UPPER, $LOWER)"/>
  <xsl:variable name="imported_kind" select="concat('imported_',$lkind)"/>

  <xsl:variable name="schema_name" select="../../@name"/>
  <xsl:variable name="clause_number">
    <xsl:call-template name="express_clause_number">
      <xsl:with-param name="clause" select="$imported_kind"/>
      <xsl:with-param name="schema_name" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  
  <h4>
    <xsl:value-of select="concat($clause_number,'.',position(),' ',@item )"/>
  </h4>
  <!-- get information about the module from which the construct is being
       imported -->
  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="../@schema"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="module_no"
    select="document(concat($module_dir,'/module.xml'))/module/@part"/>
  <xsl:variable name="module_name">
    <xsl:call-template name="module_name">
      <xsl:with-param name="module" select="../@schema"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="module_href"
    select="concat('../../',$module_name,'/sys/1_scope',$FILE_EXT)"/>
  
  The base definition of the 
  <xsl:call-template name="link_object">
    <xsl:with-param name="object_name" select="@item"/>
    <xsl:with-param name="object_used_in_schema_name" 
      select="../../@name"/>
    <xsl:with-param name="clause" select="'section'"/>
  </xsl:call-template>
  <xsl:value-of select="concat(' ',$lkind)"/>
  is given in 
  <a href="{$module_href}">
    <xsl:value-of select="concat('ISO 10303-',$module_no)"/>
  </a>
  The following modifications apply to this part of ISO 10303.
  <p>
    The definition of 
    <xsl:call-template name="link_object">
      <xsl:with-param name="object_name" select="@item"/>
      <xsl:with-param name="object_used_in_schema_name" 
        select="../../@name"/>
      <xsl:with-param name="clause" select="'section'"/>
    </xsl:call-template>
    is modified as follows:
  </p>
  <ul>
    <li>
      <xsl:apply-templates/>
    </li>
  </ul>
</xsl:template>

</xsl:stylesheet>
