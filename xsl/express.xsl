<?xml version="1.0"?>
<!--
     $Id: express.xsl,v 1.3 2001/10/22 09:32:56 robbod Exp $

  Author: Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep and supplied to NIST under contract.
  Purpose: 
     Used to display the commented XML encoded Express generated 
     from GraphicalExpress 
-->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>

  <xsl:import href="common.xsl"/>

  <xsl:import href="express_application.xsl"/>
  <xsl:import href="express_toc.xsl"/>
  <xsl:import href="express_link.xsl"/>


  <xsl:output method="html"/>


<xsl:template match="express" >
  <HTML>
    <HEAD>
      <xsl:apply-templates select="./application" mode="meta"/>
        <!-- apply a cascading stylesheet.
             the stylesheet will only be applied if the parameter output_css
             is set in parameter.xsl 
             -->
      <xsl:call-template name="output_css">
        <xsl:with-param name="path" select="'../../../css/'"/>
      </xsl:call-template>
      <TITLE></TITLE>
    </HEAD>
    <BODY>
      <xsl:apply-templates select="./application" mode="body"/>
      <xsl:apply-templates select="." mode="top_TOC"/>      
      <xsl:apply-templates select="./schema"/>
    </BODY>
  </HTML>
</xsl:template>


<xsl:template match="schema">
  <xsl:apply-templates select="." mode="TOC"/>
  <blockquote>
    *) <br/>
    SCHEMA <xsl:value-of select="@name"/>;<br/>
    (* 
  </blockquote>
  <!-- now output the full documentation -->
  <xsl:apply-templates select="./interface"/>
  <xsl:apply-templates select="./constant"/>
  <xsl:apply-templates select="./type"/>
  <xsl:apply-templates select="./entity[1]" mode="header"/>
  <xsl:apply-templates select="./entity"/>

  <hr/>
  <blockquote>
    *) <br/>
    END_SCHEMA; <br/>
    (* <br/>
  </blockquote>
</xsl:template>


<xsl:template match="interface">
  <xsl:variable 
    name="schema-name" 
    select="../@name"/>      

  <xsl:if test="position()=1">
    <xsl:variable 
      name="interface_aname" 
      select="concat('interfaces_',$schema-name)"/>
    <h2>
      <A NAME="{$interface_aname}">
        <xsl:value-of select="concat('Interfaces in ',$schema-name)"/>
      </A>
    </h2>
    )*<br/>
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
          </xsl:call-template>
          <xsl:apply-templates select="./interfaced.item"/>;
        </xsl:when>
        <xsl:when test="@kind='use'">
          <xsl:value-of select="concat('USE FROM ',@schema)"/>
          <xsl:apply-templates select="./interfaced.item"/>;
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message" 
              select="concat('Interface in schema ', 
                      $schema-name, 
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
    &#160; (<br/>
  </xsl:if>
  &#160; &#160;
  <xsl:call-template name="link_object">
    <xsl:with-param name="object_name" select="@name"/>
    <xsl:with-param name="object_used_in_schema_name" 
      select="../../@name"/>
  </xsl:call-template>

  <xsl:if test="position()!=last()">
    ,<br/>
  </xsl:if>

  <xsl:if test="position()=last()">
    )
  </xsl:if>

</xsl:template>

<xsl:template match="constant">
  <xsl:variable 
    name="schema-name" 
    select="../@name"/>      

  <xsl:variable 
    name="xref"    
    select="concat($schema-name,'.',@name)"/>
    
  <xsl:variable 
    name="graphics" 
    select="''"/>

  <xsl:variable 
    name="schema-ref" 
    select="concat('index_',$schema-name)"/>

  <hr/>
  <xsl:if test="position()=1">
    <xsl:variable 
      name="constants_aname" 
      select="concat('constants_',$schema-name)"/>
    <h2>
      <A NAME="{$constants_aname}">
        <xsl:value-of select="concat('Constants in ',$schema-name)"/>
      </A>
    </h2>
  </xsl:if>
    
  <h3>
    <A NAME="{$xref}">
      <xsl:value-of select="@name" />  
    </A>
    <font size="1">
      [Schema: 
      <A HREF="#{$schema-ref}">
        <xsl:value-of select="$schema-name"/>
      </A>
      ]
    </font>
  </h3>
  <blockquote>
    <p>
      <xsl:apply-templates select="./description"/>
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
    name="schema-name" 
    select="../@name"/>      

  <xsl:variable 
    name="aname"    
    select="concat($schema-name,'.',@name)"/>
    
  <xsl:variable 
    name="graphics" 
    select="''"/>

  <xsl:variable 
    name="schema-ref" 
    select="concat('index_',$schema-name)"/>
  
  <hr/>
  <xsl:if test="position()=1">
    <xsl:variable 
      name="types_aname" 
      select="concat('types_',$schema-name)"/>
    <h2>
      <A NAME="{$types_aname}">
        <xsl:value-of select="concat('Types in ',$schema-name)"/>
      </A>
    </h2>
  </xsl:if>

  <h3>
    <A NAME="{$aname}">
      <xsl:value-of select="@name" />  
    </A>
    <font size="1">
      [Schema: 
      <A HREF="#{$schema-ref}" >
        <xsl:value-of select="$schema-name"/>
      </A>
      ]
    </font>
    <xsl:if test="$graphics">
      <xsl:variable 
        name="graphics-url" 
        select="concat($graphics,'.html')" />
        &#160;<A HREF="{$graphics-url}"> <IMG SRC="../../stylesheets/exp_g.gif" ALT="[EXPRESS-G]" target="content" align="absbottom" BORDER="0"/> </A>
    </xsl:if>
  </h3>
  
  <blockquote>
    <p>
      <xsl:apply-templates select="./description"/>
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
    BASED ON <xsl:value-of select="@basedon"/> WITH 
  </xsl:if>

  (
  <xsl:call-template name="link_list">
    <xsl:with-param name="suffix" select="', '"/>
    <xsl:with-param name="list" select="@selectitems"/>
    <xsl:with-param name="object_used_in_schema_name" select="../../@name"/>
  </xsl:call-template>)
</xsl:template>


<xsl:template match="enumeration" mode="underlying">
  ENUMERATION OF 
  <br/>
  &#160; &#160; 
  <xsl:value-of 
    select="concat('(',translate(normalize-space(@items),' ', ','),')')"/>
</xsl:template>

<!--
     Run once in a schema to output a header 
-->
<xsl:template match="entity" mode="header">
  <xsl:variable 
    name="entities_aname" 
    select="concat('entities_',../@name)"/>
  <h2>
    <A NAME="{$entities_aname}">
      <xsl:value-of select="concat('Entities in ',../@name)"/>
    </A>
  </h2>
</xsl:template>

<!-- output the entity.
     If noheader is set to anything, then no header information is output 
     If nousedby is set then there is no display of the used by links
-->
<xsl:template match="entity">
  <xsl:param name="noheader"/>
  <xsl:param name="nousedby"/>

  <xsl:variable 
    name="schema-name" 
    select="../@name"/>      

  <xsl:variable 
    name="aname"    
    select="concat($schema-name,'.',@name)"/>
    
  <xsl:variable 
    name="graphics" 
    select="''"/>

  <xsl:variable 
    name="schema-ref" 
    select="concat('index_',$schema-name)"/>

  <!-- unless explicitly told not to, output a header -->
  <xsl:if test="not($noheader)">
    <hr/>
    <h3>
      <A NAME="{$aname}">
        <xsl:value-of select="@name"/>
      </A>
      <font size="1">
        [Schema: 
        <A HREF="#{$schema-ref}" >
          <xsl:value-of select="$schema-name"/>
        </A>
        ]
      </font>
      <xsl:if test="$graphics">
        <xsl:variable 
          name="graphics-url" 
          select="concat($graphics,'.html')" />
          &#160;<A HREF="{$graphics-url}"> <IMG SRC="../../stylesheets/exp_g.gif" ALT="[EXPRESS-G]" target="content" align="absbottom" BORDER="0"/> </A>
      </xsl:if>
    </h3>
  </xsl:if>

  <blockquote>
    <p>
      <xsl:apply-templates select="./description"/>
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
    <xsl:call-template name="super.expression-description"/>
    <xsl:call-template name="supertypes-description"/>    
    <xsl:apply-templates select="./explicit" mode="description"/>    
    <xsl:apply-templates select="./derived" mode="description"/>    
    <xsl:apply-templates select="./inverse" mode="description"/>  
    <xsl:apply-templates select="./unique" mode="description"/>
    <xsl:apply-templates select="./where" mode="description"/>
    <xsl:if test="not($nousedby)">
      <xsl:apply-templates select="." mode="usedbyattrib"/>
      <xsl:apply-templates select="." mode="usedbyselect"/>
    </xsl:if>
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
    &#160; SUBTYPE OF (
    <xsl:call-template name="link_list">
      <xsl:with-param name="list" select="@supertypes"/>
        <xsl:with-param name="suffix" select="', '"/>
      <xsl:with-param name="object_used_in_schema_name" select="../@name"/>
    </xsl:call-template>)
  </xsl:if>
</xsl:template>

<xsl:template match="explicit" mode="code">
  &#160; &#160; 
  <xsl:value-of select="concat(@name, ' : ')"/>
  <xsl:if test="@optional='YES'">
    OPTIONAL 
  </xsl:if>
  <xsl:apply-templates select="./aggregate" mode="code"/>
  <xsl:apply-templates select="./*" mode="underlying"/>;<br/>
</xsl:template>


<xsl:template match="derived" mode="code">
  <xsl:if test="position()=1">
    &#160; &#160; 
    DERIVE<br/>
  </xsl:if>
  &#160; &#160; &#160;
  <!-- need to clarify the XML for derive --> 
  <xsl:value-of select="concat(@name, ' : ')"/>
  <xsl:apply-templates select="./aggregate" mode="code"/>
  <xsl:apply-templates select="./*" mode="underlying"/>
  <xsl:value-of select="concat(' : ',@expression,';')"/><br/>
</xsl:template>

<xsl:template match="inverse" mode="code">
  <xsl:if test="position()=1">
    &#160; &#160; 
    INVERSE<br/>
  </xsl:if>
  &#160; &#160; &#160;
  <br/>
</xsl:template>

<xsl:template match="unique" mode="code">
  <xsl:if test="position()=1">
    &#160; &#160; 
    UNIQUE<br/>
  </xsl:if>
  &#160; &#160; &#160;
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
  <xsl:value-of select="concat(@type, '[', @lower, ':', @upper, '] OF ')"/>
</xsl:template>

<xsl:template match="where" mode="code">
  <xsl:if test="position()=1">
    &#160; &#160; WHERE<br/>
  </xsl:if>  
  &#160; &#160; &#160;
  <xsl:value-of select="concat(@label, ': ', @expression, ';')"/>
  <br/>
</xsl:template>

<xsl:template match="graphic.element" mode="code">
</xsl:template>


<!-- Extract the list of sub type entities from the expression,
     convert it to a list of linked entities and output
-->
<xsl:template name="super.expression-description">
  <xsl:if test="@super.expression">
    <xsl:variable name="entity_list">
      <xsl:call-template name="supertypes-list">
        <xsl:with-param name="expression" select="@super.expression"/>    
      </xsl:call-template>    
    </xsl:variable>
    <xsl:variable name="nentity_list">
      <xsl:call-template name="remove_duplicates">
        <xsl:with-param name="list" select="$entity_list"/>    
      </xsl:call-template>    
    </xsl:variable>

    <h3>Supertype of:</h3>
    <blockquote>
      <xsl:call-template name="link_list">
        <xsl:with-param name="suffix" select="'br'"/>
        <xsl:with-param name="list" select="$nentity_list"/>
        <xsl:with-param name="object_used_in_schema_name" select="../@name"/>
      </xsl:call-template>
    </blockquote>
  </xsl:if>
</xsl:template>

<!-- Remove all expression constructs from the super.expression. I.e.
     OR ANDOR AND  
-->
<xsl:template name="supertypes-list">
  <xsl:param name="expression"/>
  <xsl:variable name="nexpression">  
  <xsl:choose>
    <!-- normalise the expression, replacing (), with whitespace -->
    <xsl:when test="contains($expression,'(')">
      <xsl:value-of select="concat('( ',
                            normalize-space(
                            translate($expression,'(),',' ')
                            ),
                            ' )')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$expression"/>     
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>

    <xsl:when test="contains($nexpression,'ANDOR')">
      <!-- remove the ANDOR -->
      <xsl:variable 
        name="expression1"
        select="concat(
                substring-before($nexpression,' ANDOR '),' ',
                substring-after($nexpression,' ANDOR '))"/>
      <!-- recurse to remove any others -->
      <xsl:call-template name="supertypes-list">
        <xsl:with-param name="expression" select="$expression1"/>    
      </xsl:call-template>    
    </xsl:when>

    <xsl:when test="contains($nexpression,'SUBTYPE OF')">
      <!-- remove the SUBTYPE OF -->
      <xsl:variable 
        name="expression1"
        select="concat(
                substring-before($nexpression,' SUBTYPE OF '),' ',
                substring-after($nexpression,' SUBTYPE OF '))"/>
      <!-- recurse to remove any others -->
      <xsl:call-template name="supertypes-list">
        <xsl:with-param name="expression" select="$expression1"/>    
      </xsl:call-template>    
    </xsl:when>

    <xsl:when test="contains($nexpression,'ONEOF')">
      <!-- remove the ONEOF -->
      <xsl:variable 
        name="expression1"
        select="concat(
                substring-before($nexpression,' ONEOF '),' ',
                substring-after($nexpression,' ONEOF '))"/>
      <!-- recurse to remove any others -->
      <xsl:call-template name="supertypes-list">
        <xsl:with-param name="expression" select="$expression1"/>    
      </xsl:call-template>    
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="normalize-space(translate($nexpression,'(),',''))"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Extract the list of sub type entities from the expression,
     convert it to a list of linked entities and output
-->
<xsl:template name="supertypes-description">
  <xsl:if test="@supertypes">
    <h3>Subtype of:</h3>
    <blockquote>
      <xsl:call-template name="link_list">
        <xsl:with-param name="suffix" select="'br'"/>
        <xsl:with-param name="list" select="@supertypes"/>
        <xsl:with-param name="object_used_in_schema_name" select="../@name"/>
      </xsl:call-template>
    </blockquote>
  </xsl:if>  
</xsl:template>


<xsl:template match="explicit" mode="description">
  <xsl:if test="position()=1">
    <p><u>Attributes definitions</u></p>
  </xsl:if>
  <xsl:variable name="aname"
    select="concat(../../@name,'.',../@name,'.',@name)"/>
  <blockquote>
    <b>
      <a name="{$aname}">
        <xsl:value-of select="@name"/>(
        <xsl:apply-templates select="./*" mode="underlying"/>
        ):
      </a>
    </b>
    <xsl:apply-templates select="./description"/>
  </blockquote>
</xsl:template>

<xsl:template match="derived" mode="description">
  <!-- check that this is the first derived attribute and that the
       there are no explicit attribute - if there were then Attribute
       definitions" would have already been output -->
  <xsl:if test="position()=1 and not(../explicit)">
    <p><u>Attributes definitions</u></p>
  </xsl:if>
  <xsl:variable name="aname"
    select="concat(../../@name,'.',../@name,'.',@name)"/>
  <blockquote>
    <b>
      <a name="{$aname}">
        <xsl:value-of select="@name"/>(
        <xsl:apply-templates select="./*" mode="underlying"/>
        ):
      </a>
    </b>
    <xsl:apply-templates select="./description"/>
  </blockquote>
</xsl:template>

<xsl:template match="inverse" mode="description">
  <xsl:if test="position()=1">
    <h3>Inverse attributes:</h3>
  </xsl:if>
  <xsl:variable name="aname"
    select="concat(../../@name,'.',../@name,'.',@name)"/>
  <blockquote>
    <b>
      <a name="{$aname}">
        <xsl:value-of select="@name"/>(
        <xsl:apply-templates select="./*" mode="underlying"/>
        ):
      </a>
    </b>
    <xsl:apply-templates select="./description"/>
  </blockquote>
</xsl:template>



<xsl:template match="unique" mode="description">
  <xsl:if test="position()=1">
    <h3>Unique constraints:</h3>
  </xsl:if>  
  <xsl:variable name="aname"
    select="concat(../../@name,'.',../@name,'.ur:',@label)"/>
  <blockquote>
    <b>
      <a name="{$aname}">
        <xsl:value-of select="concat(@label,' : ')"/>
      </a>
    </b>
    <xsl:apply-templates select="./description"/>
  </blockquote>
</xsl:template>


<xsl:template match="where" mode="description">
  <xsl:if test="position()=1">
    <h3>Where rules:</h3>
  </xsl:if>
  <xsl:variable name="aname"
    select="concat(../../@name,'.',../@name,'.wr:',@label)"/>
  <blockquote>
    <b>
      <a name="{$aname}">
        <xsl:value-of select="concat(@label,' : ')"/>
      </a>
    </b>
    <xsl:apply-templates select="./description"/>
  </blockquote>
</xsl:template>



<!-- list all the entities that use this entity in an attribute 
     Note - it only checks this schema
     -->
<xsl:template match="entity" mode="usedbyattrib">
  <xsl:variable name="this_type" select="./@name"/>  
  <xsl:variable name="this_schema" select="../@name"/>  
  <!-- get all the entities in the same schema that use this entity --> 
  <xsl:variable name="using_as_attrib" 
    select="../entity/explicit[$this_type=typename/@name]"/>
  <xsl:if test="$using_as_attrib" >    
    <h3>Used by attributes:</h3>
    <blockquote>
      <xsl:for-each select="$using_as_attrib">
        <xsl:variable name="xref"
          select="concat(../../@name,'.',../@name,'.',@name)"/>
        <a href="#{$xref}">
          <xsl:value-of select="concat(../@name,'.',@name)"/>
        </a>
        <br/>
      </xsl:for-each>
    </blockquote>
    </xsl:if>
</xsl:template>


<xsl:template match="entity" mode="usedbyselect">
  <xsl:variable name="this_type" select="./@name"/>  
  <xsl:variable name="this_schema" select="../@name"/>  
  <!-- get all the selects in the same schema that use this entity --> 
  <xsl:variable name="using_in_select" 
    select="../type/select[contains(@selectitems,$this_type)]"/>
  <xsl:if test="$using_in_select" >    
    <h3>Used by SELECT:</h3>    
    <blockquote>
      <xsl:for-each select="$using_in_select">
        <xsl:variable name="xref"
          select="concat(../../@name,'.',../@name)"/>
        <a href="#{$xref}">
          <xsl:value-of select="string(../@name)"/>
        </a>
        <br/>
      </xsl:for-each>
    </blockquote>
    </xsl:if>
</xsl:template>

</xsl:stylesheet>


