<?xml version="1.0"?>
<!--
     $Id: express_code.xsl,v 1.5 2002/01/31 18:09:48 robbod Exp $

  Author: Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep and supplied to NIST under contract.
  Purpose: 
     Used to display the XML encoded Express as Express code
     i.e. hyper linked plain express with no descriptions.
-->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>

  <xsl:import href="common.xsl"/>

  <xsl:import href="express_application.xsl"/>
  <xsl:import href="express_link.xsl"/>


  <xsl:output method="html"/>


  <!-- +++++++++++++++++++
         Templates
       +++++++++++++++++++ -->


<xsl:template match="schema" mode="code">
  <code>
    <br/><br/>
    SCHEMA <b><xsl:value-of select="@name"/></b>;
  <br/>    <br/>
  <xsl:apply-templates select="./interface" mode="code"/>
  <xsl:apply-templates select="./constant" mode="code"/>
  <xsl:apply-templates select="./type" mode="code"/>
  <xsl:apply-templates select="./entity" mode="code"/>
  <xsl:apply-templates select="./rule" mode="code"/>
  <xsl:apply-templates select="./function" mode="code"/>
  <xsl:apply-templates select="./procedure" mode="code"/>
  <br/>
  END_SCHEMA; <br/>
  </code>
</xsl:template>


<xsl:template match="interface" mode="code">
  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      
  <xsl:choose>
    <xsl:when test="@kind='reference'">
      REFERENCE FROM 
      <xsl:call-template name="link_schema">
        <xsl:with-param name="schema_name" select="@schema"/>
        <xsl:with-param name="clause" select="'annexe'"/>
      </xsl:call-template>
      <xsl:apply-templates select="./interfaced.item" mode="code"/>;<br/>
    </xsl:when>
    <xsl:when test="@kind='use'">
      USE FROM
      <xsl:call-template name="link_schema">
        <!-- defined in sect_4_express_link.xsl -->
        <xsl:with-param name="schema_name" select="@schema"/>
        <xsl:with-param name="clause" select="'annexe'"/>
      </xsl:call-template>
      <xsl:apply-templates select="./interfaced.item" mode="code"/>;<br/>
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
</xsl:template>


<xsl:template match="interfaced.item" mode="code">
  <xsl:if test="position()=1">
    (<br/>
  </xsl:if>

  &#160;&#160;
  <xsl:call-template name="link_object">
    <xsl:with-param name="object_name" select="@name"/>
    <xsl:with-param name="object_used_in_schema_name" 
      select="../../@name"/>
    <xsl:with-param name="clause" select="'annexe'"/>
  </xsl:call-template>

  <xsl:if test="position()!=last()">,<br/></xsl:if>

  <xsl:if test="position()=last()">)</xsl:if>

</xsl:template>


<xsl:template match="constant" mode="code">
  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>    
  <br/>
  <xsl:if test="position()=1">CONSTANT</xsl:if>
  <A NAME="{$aname}"></A>
  &#160;&#160;<xsl:value-of select="@name"/> : <xsl:value-of select="@expression"/>
  <xsl:if test="position()=last()">
    <br/>
    END_CONSTANT;
    <br/>
  </xsl:if>
</xsl:template>


<xsl:template match="type" mode="code">
  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>    

  <br/>
  <A NAME="{$aname}">TYPE </A><b><xsl:value-of select="@name"/></b> =
      <xsl:apply-templates select="./aggregate" mode="code"/>        
      <xsl:apply-templates select="./*" mode="underlying"/>;<br/>
    END_TYPE; 
  <br/>
</xsl:template>

<!-- empty template to prevent the description element being output along
     with the code -->
<xsl:template match="description" mode="underlying"/>


<xsl:template match="typename" mode="underlying">
  <xsl:call-template name="link_object">
    <xsl:with-param name="object_name" select="@name"/>
    <xsl:with-param name="object_used_in_schema_name" 
      select="../../../@name"/>
    <xsl:with-param name="clause" select="'annexe'"/>
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
        <xsl:with-param name="clause" select="'annexe'"/>
      </xsl:call-template>  
      WITH 
  </xsl:if>
  <xsl:if test="@selectitems and (string-length(@selectitems)!=0)">
  (<xsl:call-template name="link_list">
    <xsl:with-param name="suffix" select="', '"/>
    <xsl:with-param name="list" select="@selectitems"/>
    <xsl:with-param name="object_used_in_schema_name"
      select="../../@name"/>
    <xsl:with-param name="clause" select="'annexe'"/>
  </xsl:call-template>)</xsl:if></xsl:template>


<xsl:template match="enumeration" mode="underlying">
  ENUMERATION OF 
  <br/>
  &#160;&#160; 
  <xsl:value-of 
    select="concat('(',translate(normalize-space(@items),' ', ','),')')"/>
</xsl:template>


<xsl:template match="entity" mode="code">
  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <br/>
  <A NAME="{$aname}">ENTITY <b><xsl:value-of select="@name"/></b></A>
  <xsl:call-template name="super.expression-code"/>
  <xsl:call-template name="supertypes-code"/>;    
  <br/>
  <xsl:apply-templates select="./explicit" mode="code"/>
  <xsl:apply-templates select="./derived" mode="code"/>
  <xsl:apply-templates select="./inverse" mode="code"/>
  <xsl:apply-templates select="./unique" mode="code"/>
  <xsl:apply-templates select="./where" mode="code"/>
  END_ENTITY;<br/>
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
  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="../../@name"/>
      <xsl:with-param name="section2" select="../@name"/>
      <xsl:with-param name="section3" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

 &#160;&#160; 
  <A NAME="{$aname}"><xsl:value-of select="concat(@name, ' : ')"/></A>
  <xsl:if test="@optional='YES'">
    OPTIONAL 
  </xsl:if>
  <xsl:apply-templates select="./aggregate" mode="code"/>
  <xsl:apply-templates select="./*" mode="underlying"/>;<br/>
</xsl:template>


<xsl:template match="derived" mode="code">
  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="../../@name"/>
      <xsl:with-param name="section2" select="../@name"/>
      <xsl:with-param name="section3" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="position()=1">
    &#160;&#160;DERIVE<br/>
  </xsl:if>
  &#160;&#160;&#160;
  <!-- need to clarify the XML for derive --> 
  <A NAME="{$aname}"><xsl:value-of select="concat(@name, ' : ')"/></A>
  <xsl:apply-templates select="./aggregate" mode="code"/>
  <xsl:apply-templates select="./*" mode="underlying"/>
  <xsl:value-of select="concat(' : ',@expression,';')"/><br/>
</xsl:template>

<xsl:template match="inverse" mode="code">
  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="../../@name"/>
      <xsl:with-param name="section2" select="../@name"/>
      <xsl:with-param name="section3" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="position()=1">
    &#160;&#160;INVERSE<br/>
  </xsl:if>
  &#160;&#160;&#160;
  <A NAME="{$aname}"><xsl:value-of select="concat(@name, ' : ')"/></A>
  <xsl:apply-templates select="./inverse.aggregate" mode="code"/>
  <xsl:call-template name="link_object">
    <xsl:with-param name="object_name" select="@entity"/>
    <xsl:with-param name="object_used_in_schema_name" 
      select="../../@name"/>
    <xsl:with-param name="clause" select="'annexe'"/>
  </xsl:call-template>  
  <xsl:value-of select="concat(' FOR ', @attribute)"/>;<br/>
</xsl:template>

<xsl:template match="inverse.aggregate" mode="code">
  <xsl:value-of select="concat(@type, '[', @lower, ':', @upper, '] OF ')"/>
</xsl:template>

<xsl:template match="unique" mode="code">
  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="../../@name"/>
      <xsl:with-param name="section2" select="../@name"/>
      <xsl:with-param name="section3" select="concat('ur:',@label)"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="position()=1">
    &#160;&#160; 
    UNIQUE<br/>
  </xsl:if>
  &#160;&#160;&#160;
  <A NAME="{$aname}"><xsl:value-of select="concat(@label, ': ')"/></A>
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
  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="../../@name"/>
      <xsl:with-param name="section2" select="../@name"/>
      <xsl:with-param name="section3" select="concat('wr:',@label)"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="position()=1">
    &#160;&#160;WHERE<br/>
  </xsl:if>  
  &#160;&#160;&#160;
  <A NAME="{$aname}"><xsl:value-of select="concat(@label, ': ', @expression, ';')"/></A>
  <br/>
</xsl:template>


<xsl:template match="function" mode="code">
  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>
             
  <br/>
  <A NAME="{$aname}">FUNCTION <b><xsl:value-of select="@name"/></b> </A>
  <br/>
  <xsl:apply-templates select="./parameter" mode="code"/><xsl:text> : </xsl:text>
  <xsl:apply-templates select="./*" mode="underlying"/>;
  <pre>
    <xsl:apply-templates select="./algorithm" mode="code"/>
  </pre>
  END_FUNCTION;
  <br/>
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



<xsl:template match="procedure" mode="code">    
  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <br/>
  <A NAME="{$aname}">PROCEDURE <b><xsl:value-of select="@name"/></b> </A>
  <xsl:apply-templates select="./parameter" mode="code"/><xsl:text> : </xsl:text>
  <xsl:apply-templates select="./*" mode="underlying"/>;
  <pre>
    <xsl:apply-templates select="./algorithm" mode="code"/>
  </pre>
  END_PROCEDURE;
  <br/>

</xsl:template>


<xsl:template match="rule" mode="code">  
  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <br/>
  <A NAME="{$aname}">RULE 
  <b>
    <xsl:value-of select="@name"/>
  </b></A><xsl:text> FOR </xsl:text>
  <br/>
  &#160;(<xsl:value-of select="translate(@appliesto,' ',', ')"/>);
  <pre>
    <xsl:apply-templates select="./algorithm" mode="code"/> 
    <xsl:apply-templates select="./where" mode="code"/>
  </pre>
  END_RULE;
  <br/>

</xsl:template>

</xsl:stylesheet>
