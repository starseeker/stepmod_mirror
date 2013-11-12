<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
     $Id: express_code.xsl,v 1.16 2011/03/02 21:30:39 lothartklein Exp $

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
  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="@name"/>
    </xsl:call-template>
  </xsl:variable>    

  <code>
    <br/><br/>
    <a name="{$aname}">
      SCHEMA <b><xsl:value-of select="@name"/></b>;</a>
  <br/><br/>
</code>
  <xsl:apply-templates select="./interface" mode="code"/>
  <xsl:apply-templates select="./constant" mode="code"/>
  <xsl:apply-templates select="./type" mode="code"/>
  <xsl:apply-templates select="./entity" mode="code"/>
  <xsl:apply-templates select="./subtype.constraint" mode="code">
    <xsl:sort select="@name"/>
  </xsl:apply-templates>
  <xsl:apply-templates select="./rule" mode="code"/>
  <xsl:apply-templates select="./function" mode="code"/>
  <xsl:apply-templates select="./procedure" mode="code"/>
  <code>
  <br/>
  END_SCHEMA;&#160;&#160;--&#160;<xsl:value-of select="@name"/>
  <br/>
  </code>
</xsl:template>


<xsl:template match="interface" mode="code">
  <xsl:variable 
    name="schema_name" 
    select="../@name"/>
  <code>      
  <xsl:choose>
    <xsl:when test="@kind='reference'">
      REFERENCE FROM 
      <xsl:call-template name="link_schema">
        <xsl:with-param name="schema_name" select="@schema"/>
        <xsl:with-param name="clause" select="'annexe'"/>
      </xsl:call-template>

      <xsl:choose>
        <xsl:when test="./interfaced.item">
          <!-- if interface items then out put source tail comment now -->
          <xsl:apply-templates select="." mode="source"/>
          <xsl:apply-templates select="./interfaced.item" mode="code"/>;
          <br/><br/>          
        </xsl:when>
        <xsl:otherwise>;
          <xsl:apply-templates select="." mode="source"/>
          <br/><br/>
        </xsl:otherwise>
      </xsl:choose>      

    </xsl:when>
    <xsl:when test="@kind='use'">
      USE FROM
      <xsl:call-template name="link_schema">
        <!-- defined in sect_4_express_link.xsl -->
        <xsl:with-param name="schema_name" select="@schema"/>
        <xsl:with-param name="clause" select="'annexe'"/>
      </xsl:call-template>

      <xsl:choose>
        <xsl:when test="./interfaced.item">
          <!-- if interface items then out put source tail comment now -->
          <xsl:apply-templates select="." mode="source"/>
          <xsl:apply-templates select="./interfaced.item" mode="code"/>;
          <br/><br/>          
        </xsl:when>
        <xsl:otherwise>;
          <xsl:apply-templates select="." mode="source"/>
          <br/><br/>
        </xsl:otherwise>
      </xsl:choose>      

    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="error_message">
        <xsl:with-param 
          name="message" 
          select="concat('Error ec1: Interface in schema ', 
                  $schema_name, 
                  ' is incorrectly specified')"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</code>
</xsl:template>

<!-- output the trailing comment that shows where the express came from -->
<xsl:template match="interface" mode="source">
  <xsl:variable name="resource" select="string(@schema)"/> 
      <!-- In our case it is always  an integrated resource -->

      <xsl:variable name="resource_ok">
        <xsl:call-template name="check_resource_exists">
          <xsl:with-param name="schema" select="$resource"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="$resource_ok='true'">

          <!-- the IR directory must be all lower case - the schema itself
               sometimes is mixed case -->
          <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>
          <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
          <xsl:variable name="lmodule" 
            select="translate($resource,$UPPER,$LOWER)"/>

          <!-- found integrated resource schema, so get IR title -->
          <xsl:variable name="reference">
            <xsl:value-of
              select="document(concat('../../data/resources/',$lmodule,'/',$lmodule,'.xml'))/express/@reference"/>
          </xsl:variable>

          <xsl:choose>
            <xsl:when test="string-length($reference)>0">
              <xsl:if test="not(starts-with($reference,'ISO 10303-')) and
                            not(starts-with($reference,'ISO 13584-')) and
                            not(starts-with($reference,'ISO 15926-'))">
              <xsl:call-template name="error_message">
                <xsl:with-param name="message">
                  <xsl:value-of select="concat('Error IF-3a: The reference parameter for ',
                            $resource,' is incorrectly specified. It should
                    be of the form ISO 10303-*** (or ISO 13584-*** or ISO 15926-***) . Change @reference in
                            data/resources/',$resource,'/',$resource,'.xml.')"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:if>

              <xsl:value-of select="concat('&#160;&#160;&#160;-- ',$reference)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="error_message">
                <xsl:with-param name="message">
                  <xsl:value-of 
                    select="concat('Error IF-3: The reference parameter for ',
                            $resource,' has not been specified ','Add
                            @reference (e.g. ISO 10303-***) to
data/resources/',$resource,'/',$resource,'.xml.')"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="error_message">
            <xsl:with-param name="message" 
              select="concat('Error IF-2: ',$resource_ok)"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>

</xsl:template>


<xsl:template match="interfaced.item" mode="code">
  <xsl:choose>
    <xsl:when test="position()=1">
      <br/><xsl:text>&#160;&#160;(</xsl:text>
    </xsl:when>
    <xsl:otherwise>
        &#160;&#160;
    </xsl:otherwise>
  </xsl:choose>

  <xsl:call-template name="link_object">
    <xsl:with-param name="object_name" select="@name"/>
    <xsl:with-param name="object_used_in_schema_name" 
      select="../../@name"/>
    <xsl:with-param name="clause" select="'annexe'"/>
  </xsl:call-template>

  <xsl:if test="@alias">
    AS&#160;<xsl:value-of select="@alias"/>
  </xsl:if>

  <xsl:if test="position()!=last()">,<br/></xsl:if>

  <xsl:if test="position()=last()">)</xsl:if>

</xsl:template>

<xsl:template match="constant" mode="code">
  <code>
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
    <xsl:if test="position()=1">CONSTANT<br/></xsl:if>
    <A NAME="{$aname}"></A>
    &#160;&#160;<xsl:value-of select="@name"/> : <xsl:apply-templates select="./*" mode="underlyingconstant"/><xsl:apply-templates select="./*" mode="underlying"/> := <xsl:choose>
    
    <xsl:when test="./aggregate and contains(@expression,',')"><br/>
      &#160;&#160;&#160;<xsl:value-of select="concat(substring-before(@expression,','),',')"/>
      <xsl:call-template name="output_constant_expression">
        <xsl:with-param name="expression" select="substring-after(@expression,',')"/>
      </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@expression"/>;
      </xsl:otherwise>
  </xsl:choose>
    <xsl:if test="position()=last()">
      <br/>
      END_CONSTANT;
      <br/>
    </xsl:if>
  </code>
</xsl:template>

<!-- THX added to support constants that are aggregates -->


<xsl:template name="output_constant_expression">
  <xsl:param name="expression"/>
  <!--  <xsl:value-of select="','" /> -->
    <br/>
    &#160;&#160;&#160;&#160;<xsl:value-of select="substring-before($expression,',')"/>
    
    <xsl:choose>
      <xsl:when test="contains($expression,',')">,
        <xsl:call-template name="output_constant_expression">
          <xsl:with-param name="expression" select="substring-after($expression,',')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$expression"/>;
      </xsl:otherwise>
    </xsl:choose>


</xsl:template>

<xsl:template match="description" mode="underlyingconstant">
<!-- keeps description if any from printing out -->
</xsl:template>
<xsl:template match="aggregate" mode="underlyingconstant">
  <xsl:choose>
    <xsl:when test="@lower">
      <xsl:value-of select="concat(@type, '[', @lower, ':', @upper, '] OF ')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat(@type, ' OF ')"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="type" mode="code">
  <code>
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
      <xsl:choose>
        <xsl:when test="./where">
          <xsl:apply-templates select="./*" mode="underlying"/>;<br/>
          <xsl:apply-templates select="./where" mode="code"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="./*" mode="underlying"/>;<br/>
        </xsl:otherwise>
      </xsl:choose>
    END_TYPE; 
  <br/>
</code>
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
  <xsl:choose>
    <xsl:when test="@type='GENERICENTITY'">GENERIC_ENTITY</xsl:when>
    <xsl:otherwise>  
      <xsl:value-of select="@type"/>
    </xsl:otherwise>
  </xsl:choose> 
  <xsl:variable name="type_label" select="@typelabel"/>
	<xsl:if test="$type_label">
		<xsl:value-of select="concat( ' : ', $type_label)"/>
	</xsl:if>
</xsl:template>


<xsl:template match="select" mode="underlying">
  <xsl:if test="@extensible='YES' or @extensible='yes'">
    EXTENSIBLE
  </xsl:if>

  <xsl:if test="@genericentity='YES' or @genericentity='yes'">
    GENERIC_ENTITY
  </xsl:if>

  SELECT<xsl:if test="@basedon">
    BASED_ON
      <xsl:call-template name="link_object">
        <xsl:with-param name="object_name" select="@basedon"/>
        <xsl:with-param name="object_used_in_schema_name" 
          select="../../@name"/>
        <xsl:with-param name="clause" select="'annexe'"/>
      </xsl:call-template>  
  </xsl:if>
  <!-- need to check for NULL as some XML outputs attribute as null of not
       known -->
  <xsl:if test="@selectitems and 
                (string-length(@selectitems)!=0)">
    <xsl:if test="@basedon">
      WITH 
    </xsl:if><br/>
    &#160;&#160;&#160;(<xsl:call-template name="link_list">
    <xsl:with-param name="linebreak" select="'yes'"/>
    <xsl:with-param name="suffix" select="', '"/>
    <xsl:with-param name="prefix" select="'&#160;&#160;&#160;&#160;'"/>
    <xsl:with-param name="first_prefix" select="'no'"/>
    <xsl:with-param name="list" select="@selectitems"/>
    <xsl:with-param name="object_used_in_schema_name"
      select="../../@name"/>
    <xsl:with-param name="clause" select="'annexe'"/>
  </xsl:call-template>)</xsl:if></xsl:template>


<xsl:template match="enumeration" mode="underlying">
  <xsl:if test="@extensible='YES' or @extensible='yes'">
    EXTENSIBLE
  </xsl:if>
  ENUMERATION
  <xsl:if test="@basedon">
    BASED_ON 
    <xsl:call-template name="link_object">
      <xsl:with-param name="object_name" select="@basedon"/>
      <xsl:with-param name="object_used_in_schema_name" 
        select="../../@name"/>
      <xsl:with-param name="clause" select="'section'"/>
    </xsl:call-template>  
  </xsl:if>

  <xsl:if test="@items and (string-length(@items)!=0)">
    <xsl:choose>
      <xsl:when test="@basedon">
        WITH 
      </xsl:when>
      <xsl:otherwise>
        OF
      </xsl:otherwise>
    </xsl:choose>
    <br/>
    &#160;&#160; 
    <xsl:variable name="enum"
      select="concat('(',translate(normalize-space(@items),' ',','),')')"/>
    <xsl:call-template name="output_line_breaks">
      <xsl:with-param name="str" select="$enum"/>
      <xsl:with-param name="break_char" select="','"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>



<xsl:template match="entity" mode="code">
  <code>
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
    <xsl:call-template name="abstract.entity"/>
    <xsl:call-template name="super.expression-code"/>
    <xsl:call-template name="supertypes-code"/><xsl:text>;</xsl:text>  
    <br/>
    <xsl:apply-templates select="./explicit" mode="code"/>
    <xsl:apply-templates select="./derived" mode="code"/>
    <xsl:apply-templates select="./inverse" mode="code"/>
    <xsl:apply-templates select="./unique" mode="code"/>
    <xsl:apply-templates select="./where[@expression]" mode="code"/>
    <!-- <xsl:call-template name="output_where_formal"/> -->
    END_ENTITY;<br/>
  </code>
</xsl:template>


<xsl:template name="abstract.entity">
  <xsl:if test="@abstract.entity='YES' or @abstract.entity='yes'">
    ABSTRACT</xsl:if>
</xsl:template>


<xsl:template name="super.expression-code">
  <!-- Always enclose the expression in parentheses -->
  <xsl:variable name="sup_expr"
    select="concat('(',@super.expression,')')"/>
  <xsl:choose>
    <xsl:when test="@abstract.supertype='YES' or @abstract.supertype='yes'">
      <br/>
&#160;&#160;ABSTRACT SUPERTYPE
      <xsl:if test="@super.expression">
        OF&#160;<xsl:call-template name="link_super_expression_list">
          <xsl:with-param name="list" select="$sup_expr"/>
          <xsl:with-param name="object_used_in_schema_name" select="../@name"/>
          <xsl:with-param name="clause" select="'section'"/>
          <xsl:with-param name="indent" select="25"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="@super.expression">
        <br/>
&#160;&#160;SUPERTYPE OF 
      <xsl:call-template name="link_super_expression_list">
        <xsl:with-param name="list" select="$sup_expr"/>
        <xsl:with-param name="object_used_in_schema_name" select="../@name"/>
        <xsl:with-param name="clause" select="'section'"/>
        <xsl:with-param name="indent" select="16"/>
      </xsl:call-template>
    </xsl:if>      
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="supertypes-code">
  <xsl:if test="@supertypes">
    <br/>
    &#160;&#160;SUBTYPE OF (<xsl:call-template name="link_list">
    <xsl:with-param name="list" select="@supertypes"/>
    <xsl:with-param name="suffix" select="', '"/>
      <xsl:with-param name="object_used_in_schema_name" select="../@name"/>
      <xsl:with-param name="clause" select="'annexe'"/>
    </xsl:call-template><xsl:text>)</xsl:text>
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
&#160;&#160;<xsl:apply-templates select="./redeclaration" mode="code"/>
  <A NAME="{$aname}"><xsl:value-of select="concat(@name, ' : ')"/></A>
  <xsl:if test="@optional='YES' or @optional='yes'">
    OPTIONAL 
  </xsl:if>
  <xsl:apply-templates select="./aggregate" mode="code"/>
  <xsl:apply-templates select="./*" mode="underlying"/>;<br/>
</xsl:template>

<xsl:template match="redeclaration" mode="code">SELF\<xsl:call-template name="link_object">
      <xsl:with-param name="object_name" select="@entity-ref"/>
      <xsl:with-param name="object_used_in_schema_name" 
        select="../../@name"/>
      <xsl:with-param name="clause" select="'annexe'"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="@old_name">
        <xsl:value-of select="concat('.',@old_name,' RENAMED ')"/>        
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>.</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="derived" mode="code">
  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="../../@name"/>
      <xsl:with-param name="section2" select="../@name"/>
      <xsl:with-param name="section3" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="position()=1">DERIVE<br/>
  </xsl:if>
&#160;&#160;<xsl:apply-templates select="./redeclaration" mode="code"/>
  <!-- need to clarify the XML for derive --> 
<A NAME="{$aname}"><xsl:value-of select="concat(@name, ' : ')"/></A>
  <xsl:apply-templates select="./aggregate" mode="code"/>
  <xsl:apply-templates select="./*" mode="underlying"/> 
  <xsl:value-of select="concat(' := ',@expression,';')"/><br/>
</xsl:template>

<xsl:template match="inverse" mode="code">
  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="../../@name"/>
      <xsl:with-param name="section2" select="../@name"/>
      <xsl:with-param name="section3" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="position()=1">INVERSE<br/>
  </xsl:if>
&#160;&#160;<xsl:apply-templates select="./redeclaration" mode="code"/>
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
  <xsl:choose>
    <xsl:when test="@lower">
      <xsl:value-of select="concat(@type, '[', @lower, ':', @upper, '] OF ')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat(@type, ' OF ')"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="unique" mode="code">
  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="../../@name"/>
      <xsl:with-param name="section2" select="../@name"/>
      <xsl:with-param name="section3" select="concat('ur:',@label)"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="position()=1">UNIQUE<br/>
  </xsl:if>
&#160;&#160;<A NAME="{$aname}"><xsl:value-of select="concat(@label, ': ')"/></A>
  <xsl:apply-templates select="./unique.attribute" mode="code"/>
  <br/>
</xsl:template>


<xsl:template match="unique.attribute" mode="code">
  <xsl:variable name="suffix">
    <xsl:choose>
      <xsl:when test="position()!=last()">
        <xsl:value-of select="', '"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="';'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="@entity-ref">
      SELF\<xsl:call-template name="link_object">
      <xsl:with-param name="object_name" select="@entity-ref"/>
      <xsl:with-param name="object_used_in_schema_name" 
        select="../../@name"/>
      <xsl:with-param name="clause" select="'annexe'"/>
    </xsl:call-template><xsl:value-of select="concat('.',@attribute,$suffix)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat(@attribute,$suffix)"/>
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
  <xsl:if test="@optional='YES'">
    OPTIONAL
  </xsl:if>
  <xsl:if test="@unique='YES'">
    UNIQUE
  </xsl:if>
</xsl:template>

<xsl:template name="output_where_formal">
  <xsl:if test="./where[@expression] and not(./unique)">
    <xsl:apply-templates select="./where[@expression]" mode="code"/>
  </xsl:if>
</xsl:template>

<xsl:template match="where" mode="code">
  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="../../@name"/>
      <xsl:with-param name="section2" select="../@name"/>
      <xsl:with-param name="section3" select="concat('wr:',@label)"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="position()=1">WHERE<br/>
	</xsl:if>
&#160;&#160;<A NAME="{$aname}"><xsl:value-of select="concat(@label, ': ', @expression, ';')"/></A>
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
  <code>             
  <br/>
  <A NAME="{$aname}">FUNCTION <b><xsl:value-of select="@name"/></b> </A>
  <br/>
  <xsl:apply-templates select="./parameter" mode="code"/><xsl:text> : </xsl:text>
  <xsl:apply-templates select="./aggregate" mode="code"/>
  <xsl:apply-templates select="./*" mode="underlying"/>;
</code>
  <xsl:apply-templates select="./algorithm" mode="code"/>
	<!-- <br/> -->
        <code>
  END_FUNCTION;
</code>
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
      <xsl:text>; </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>)</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="algorithm" mode="code">
  <!-- empty algorithms are sometimes output so ignore -->
  <xsl:if test="string-length(normalize-space(.))>0">
    <pre>
      <xsl:value-of select="."/>
    </pre>
  </xsl:if>
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
  <code>
  <A NAME="{$aname}">PROCEDURE <b><xsl:value-of select="@name"/></b> </A>
  <xsl:apply-templates select="./parameter" mode="code"/><xsl:text> : </xsl:text>
  <xsl:apply-templates select="./aggregate" mode="code"/>
  <xsl:apply-templates select="./*" mode="underlying"/>;
</code>
  <xsl:apply-templates select="./algorithm" mode="code"/><br/>
  <code>
  END_PROCEDURE;
  </code>
  <br/>

</xsl:template>

<xsl:template match="rule" mode="code">  
<code>
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
  (<xsl:value-of select="translate(@appliesto,' ',', ')"/>);<br/>
</code>
  <xsl:apply-templates select="./algorithm" mode="code"/>
  <code>
  <xsl:apply-templates select="./where" mode="code"/>
</code>
<code>
  END_RULE;
</code>
  <br/>
</xsl:template>

<xsl:template match="subtype.constraint" mode="code">
  <code>
  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <!--
  <br/>
  <A NAME="{$aname}">SUBTYPE_CONSTRAINT <b>
	<xsl:value-of select="@name"/></b></A>
  <xsl:text> FOR </xsl:text>
	<xsl:value-of select="@entity"/>
  ;<br/>

    <xsl:if test="@abstract.supertype='YES' or @abstract.supertype='yes'">
&#160;&#160;ABSTRACT SUPERTYPE;<br/>
      </xsl:if>
   <xsl:if test="@super.expression">
&#160;&#160; <xsl:value-of select="@super.expression"/>;<br/>
    </xsl:if>      
  END_SUBTYPE_CONSTRAINT;<br/>
-->
<br/>
  <A NAME="{$aname}">SUBTYPE_CONSTRAINT <b>
	<xsl:value-of select="@name"/></b></A>
  <xsl:text> FOR </xsl:text>
  <xsl:call-template name="link_object">
    <xsl:with-param name="object_name" select="@entity"/>
    <xsl:with-param name="object_used_in_schema_name" 
      select="../@name"/>
    <xsl:with-param name="clause" select="'annexe'"/>
  </xsl:call-template>;<br/>

  <xsl:if test="@abstract.supertype='YES' or @abstract.supertype='yes'">
      &#160;&#160;ABSTRACT SUPERTYPE;<br/>
  </xsl:if>

  <xsl:if test="@totalover and 
                (string-length(@totalover)!=0)">
    &#160;&#160;TOTAL_OVER&#160;(<xsl:call-template name="link_list">
    <xsl:with-param name="list" select="@totalover"/>
    <xsl:with-param name="linebreak" select="'yes'"/>
    <xsl:with-param name="prefix" select="'&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;'"/>
    <xsl:with-param name="first_prefix" select="'no'"/>
    <xsl:with-param name="suffix" select="', '"/>
    <xsl:with-param name="object_used_in_schema_name" select="../@name"/>
    <xsl:with-param name="clause" select="'annexe'"/>
  </xsl:call-template>);<br/>
  </xsl:if>

  
  <xsl:variable name="sup_expr" select="@super.expression"/>
  <xsl:if test="@super.expression">
    &#160;&#160;<xsl:call-template name="link_super_expression_list">
        <xsl:with-param name="list" select="$sup_expr"/>
        <xsl:with-param name="object_used_in_schema_name" select="../@name"/>
        <xsl:with-param name="clause" select="'annexe'"/>
        <xsl:with-param name="indent" select="3"/>
      </xsl:call-template>;<br/>
    </xsl:if>      
  END_SUBTYPE_CONSTRAINT;<br/>
  </code>


</xsl:template>
</xsl:stylesheet>
