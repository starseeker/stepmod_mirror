<?xml version="1.0"?>
<!--
     $Id: sect_4_express.xsl,v 1.2 2001/11/15 18:16:54 robbod Exp $

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

  <!-- loop through all the interface specifications in the express and 
       build a reference table of all the URLS for the entties and types
       build_xref_list is defined in express_link
       This variable is used in express_link.xsl;
       link_object
       link_list
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

  <hr/>
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

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>    
  <h3>
    <A NAME="{$aname}">
      <xsl:value-of select="@name" />  
    </A>
  </h3>
  <blockquote>
    <p>
      <xsl:choose>
        <xsl:when test="./description">
          <xsl:apply-templates select="./description"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message" 
              select="concat('No description provided for ',$aname)"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </p>
    *)
    <blockquote>
      <code>
        CONSTANT<br/>
        <xsl:value-of select="@name"/> : <xsl:value-of select="@expression"/><br/>
        END_CONSTANT;
      </code>
    </blockquote>
    (*
  </blockquote>
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
  
  <blockquote>
    <p>
      <xsl:choose>
        <xsl:when test="./description">
          <xsl:apply-templates select="./description"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message" 
              select="concat('No description provided for ',$aname)"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </p>
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
  </blockquote>
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
  (<xsl:call-template name="link_list">
    <xsl:with-param name="suffix" select="', '"/>
    <xsl:with-param name="list" select="@selectitems"/>
    <xsl:with-param name="object_used_in_schema_name"
      select="../../@name"/>
    <xsl:with-param name="clause" select="'section'"/>
  </xsl:call-template>)</xsl:template>


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
  <u>Express specification</u>
  <blockquote>
    <p>
      <xsl:choose>
        <xsl:when test="./description">
          <xsl:apply-templates select="./description"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message" 
              select="concat('No description provided for ',@name)"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </p>
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
        <xsl:apply-templates select="./where" mode="code"/>
        END_ENTITY;<br/>
      </code>
    </blockquote>
    (*
    <xsl:apply-templates select="./explicit" mode="description"/>    
    <xsl:apply-templates select="./derived" mode="description"/>    
    <xsl:apply-templates select="./inverse" mode="description"/>  
    <xsl:apply-templates select="./unique" mode="description"/>
    <xsl:apply-templates select="./where" mode="description"/>
  </blockquote>
</xsl:template>


<xsl:template name="super.expression-code">
  <xsl:if test="@super.expression">
    <br/>
    &#160; SUPERTYPE OF (<xsl:value-of select="@super.expression"/>)
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
    <p><u>Attributes definitions</u></p>
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
    <xsl:choose>
      <xsl:when test="./description">
        <xsl:apply-templates select="./description"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('No description provided for ',$aname)"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </blockquote>
</xsl:template>

<xsl:template match="derived" mode="description">
  <!-- check that this is the first derived attribute and that the
       there are no explicit attribute - if there were then Attribute
       definitions" would have already been output -->
  <xsl:if test="position()=1 and not(../explicit)">
    <p><u>Attributes definitions</u></p>
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
    <xsl:choose>
      <xsl:when test="./description">
        <xsl:apply-templates select="./description"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('No description provided for ',$aname)"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </blockquote>
</xsl:template>

<xsl:template match="inverse" mode="description">

  <xsl:if test="position()=1 and not(../explicit | ../derived)">
    <p><u>Attributes definitions</u></p>
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
    <xsl:choose>
      <xsl:when test="./description">
        <xsl:apply-templates select="./description"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('No description provided for ',$aname)"/>
        </xsl:call-template>
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
    <xsl:choose>
      <xsl:when test="./description">
        <xsl:apply-templates select="./description"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('No description provided for ',$aname)"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </blockquote>
</xsl:template>


<xsl:template match="where" mode="description">
  <xsl:if test="position()=1 and not(../unique)">
    <p><u>Formal propositions:</u></p>
  </xsl:if>

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
    <xsl:choose>
      <xsl:when test="./description">
        <xsl:apply-templates select="./description"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('No description provided for ',$aname)"/>
        </xsl:call-template>
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
  <u>Express specification</u>


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
  <u>Express specification</u>

</xsl:template>


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
          <xsl:value-of select="concat($clause_number, ' MIM EXPRESS rules')"/>
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
  <u>Express specification</u>

</xsl:template>

<!-- 
     Express is displayed in clauses: 
       Interfaces
       Constants
       Types
       Entities
       Functions
       Rules
       Procedures
     Template checks to see whether a particular clause is present in the
     schema. 
     If it is the clause number is returned. If not 0 is returned.
     The clause argument is: 
     interface constant type entity function rule procedure

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

    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$clause_present"/>
</xsl:template>

<!--
     The order of the clauses describing the express is:
     Interfaces
     Constants
     Types
     Entities
     Functions
     Rules
     Procedures
     Each set of constructs is in a separate clause. The clauses are
     numbered consequetively.
     If the express does not contain a particular set of express
     constructs, then the clause is not output. This will obviously affect
     the numbering of the clauses.
          
     This template will return the number of the clause according to
     whether any of the previous express clauses are required.
     the clause argument is: 
     interface constant type entity function rule procedure
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
      <xsl:when test="$clause='type'">
        <xsl:value-of select="$interface_clause + $constant_clause + $type_clause"/>
      </xsl:when>
      <xsl:when test="$clause='entity'">
        <xsl:value-of 
          select="$interface_clause + $constant_clause +
                  $type_clause + $entity_clause"/>
      </xsl:when>
      <xsl:when test="$clause='function'">
        <xsl:value-of 
          select="$interface_clause + $constant_clause +
                  $type_clause + $entity_clause + $function_clause"/>
      </xsl:when>
      <xsl:when test="$clause='rule'">
        <xsl:value-of 
          select="$interface_clause + $constant_clause +
                  $type_clause + $entity_clause + $function_clause
                  + $rule_clause"/>
      </xsl:when>
      <xsl:when test="$clause='procedure'">
        <xsl:value-of 
          select="$interface_clause + $constant_clause +
                  $type_clause + $entity_clause + $function_clause
                  + $rule_clause"/>
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


</xsl:stylesheet>