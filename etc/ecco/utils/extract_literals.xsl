<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: extract_schema.xsl,v 1.2 2005/05/18 15:00:34 thendrix Exp $

Author: Tom Hendrix, adapted from GE version.
Owner:  sourceforge stepmod
Purpose: 
Extract a schema from a ECCO pseudo p28 pdts file
-->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0"
    >
  <xsl:output 
      method="xml"
      indent="yes"
      doctype-system="../../../dtd/express.dtd"
      omit-xml-declaration="yes"
      />


  <!--
      <xsl:template match="iso_10303_28">
      <xsl:apply-templates />
      </xsl:template>
  -->

  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>
  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ_'"/>

 <xsl:template match="schema_decl">

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



  <xsl:template match="express_schema/schema_decl" >

    <xsl:processing-instruction name="xml-stylesheet">
      type="text/xsl" 
      href="../../../xsl/express.xsl"
    </xsl:processing-instruction>

    <xsl:element name="express">
      <xsl:attribute name="language_version">
	<xsl:value-of select="concat(../@express_version,../@express_schema_version)"/>
      </xsl:attribute>
      <xsl:attribute name="reference">
	<xsl:value-of select="'ISO 10303-'"/>
      </xsl:attribute>
      <xsl:attribute name="rcs.date">
	<xsl:value-of select="'$Date: 2005/05/18 15:00:34 $'"/>
      </xsl:attribute>
      <xsl:attribute name="rcs.revision">
	<xsl:value-of select="'$Revision: 1.2 $'"/>
      </xsl:attribute>
      <application
	  name="ecco2module.js"
	  owner="stepmod"
	  url="http://stepmod.sourceforge.net"
	  version="'$Revision: 1.2 $'"
	  source="FIX../data/resources/topology_schema/topology_schema.exp"/>
      <xsl:element name="schema">
	<xsl:attribute name="name"><xsl:value-of select="./schema_id"/></xsl:attribute>
	<xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="interface_specification_block|constant_block"  mode="literal">
    <xsl:apply-templates  mode="literal"/>
  </xsl:template>

  <xsl:template match="reference_from|use_from"  mode="literal">
    <xsl:element name="interface">
      <xsl:attribute  name="kind"><xsl:value-of select="substring-before(name(.),'_from')"/></xsl:attribute>
      <xsl:attribute  name="schema"><xsl:value-of select="schema_ref"/></xsl:attribute>
      <xsl:apply-templates select="entity_import|type_import"  mode="literal"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="entity_import|type_import" mode="literal">
      <xsl:value-of select="entity_id|type_id"/>
  </xsl:template>

  <xsl:template match="constant_decl"  mode="literal">
    <xsl:element name="constant">
      <xsl:apply-templates select="constant_id"  mode="literal"/>
      <xsl:apply-templates select="term"  mode="literal"/>
      <xsl:apply-templates select="base_type"  mode="literal"/>
    </xsl:element>
  </xsl:template>


  <xsl:template match="constant_id" mode="literal">
    <xsl:attribute name="name" ><xsl:value-of select="."/></xsl:attribute>
  </xsl:template>


  <xsl:template match="algorithm_head | statement_block"  mode="literal">
    <xsl:apply-templates mode="literal"/>
  </xsl:template>

  <xsl:template match="binary | boolean | integer | logical | number | real | string" mode="literal">
      <xsl:variable  name="upper">
	<xsl:call-template name="toupper">
	  <xsl:with-param name="string" select="name(.)"/>
	</xsl:call-template>
      </xsl:variable>
    <xsl:value-of select="$upper"/>
  </xsl:template>

  <xsl:template match="base_type" mode="literal">
    <xsl:apply-templates mode="literal"/>
  </xsl:template>

  <xsl:template match="base_type/entity_ref | base_type/type_ref |formal_parameter/entity_ref| formal_parameter/type_ref|
		       general_list_type/entity_ref|general_set_type/entity_ref|general_bag_type/entity_ref|general_array_type/entity_ref|function_return_type/type_ref|function_return_type/entity_ref"

mode="literal">
    <xsl:apply-templates mode="literal"/>
  </xsl:template>

  <xsl:template match="base_type">
    <xsl:apply-templates mode="literal"/>
  </xsl:template>


  <xsl:template match="entity_ref | type_ref | attribute_ref| function_ref" mode="literal">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="type_decl" mode="literal">
      <xsl:apply-templates mode="literal"/>
  </xsl:template>

  <xsl:template match="type_id" mode="literal">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="type_label_id" mode="literal">
    <xsl:value-of select="." />
  </xsl:template>

  <xsl:template match="entity_decl" mode="literal">
      <xsl:apply-templates  mode="literal"/>
  </xsl:template>

  <xsl:template match="entity_id"  mode="literal">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="underlying_type"  mode="literal">
    <xsl:apply-templates mode="literal"/>
  </xsl:template>


  <xsl:template match="subtype_of">
    <xsl:attribute name="supertypes">
      <xsl:for-each select="entity_ref">
	<xsl:value-of select="concat(string(.),' ')"/>
      </xsl:for-each>
    </xsl:attribute>
  </xsl:template>


<xsl:template match="explicit_attr_block">
<xsl:apply-templates />
</xsl:template>

<xsl:template match="explicit_attr_block/explicit_attr">
<xsl:element name="explicit">
<xsl:apply-templates />
</xsl:element> 
</xsl:template>

<xsl:template match="attribute_id" mode="literal">
  <xsl:value-of select="."/>
</xsl:template>


<xsl:template match="optional" mode="literal">
  <xsl:value-of select="OPTIONAL "/>
</xsl:template>

  <xsl:template match="underlying_type"  mode="literal" >
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="array_type|general_array_type" mode="literal">
      <xsl:value-of select="'ARRAY'" />
       <xsl:apply-templates select="bound_spec" mode="literal" />
       <xsl:value-of select="' OF'" />
       <xsl:apply-templates select="optional" mode="literal" />
       <xsl:apply-templates select="unique" mode="literal" />
       <xsl:apply-templates select="*[not(self::bound_spec or self::optional or self::unique)]"  mode="literal" />

  </xsl:template>



  <xsl:template match="bag_type|general_bag_type" mode="literal">
       <xsl:value-of select="'BAG'" />
       <xsl:apply-templates select="bound_spec" mode="literal" />
       <xsl:value-of select="' OF '" />
       <xsl:apply-templates select="optional" mode="literal" />
       <xsl:apply-templates select="base_type"  mode="literal" />
  </xsl:template>

  <xsl:template match="list_type|general_list_type"  mode="literal">
       <xsl:value-of select="'LIST'" />
       <xsl:apply-templates select="bound_spec" mode="literal" />
       <xsl:value-of select="' OF '" />
       <xsl:apply-templates select="unique" mode="literal" />
       <xsl:apply-templates select="*[not(self::bound_spec or self::optional or self::unique)]"  mode="literal" />
   </xsl:template>

  <xsl:template match="set_type|general_set_type"  mode="literal">
    <xsl:value-of select="'SET '" />
       <xsl:apply-templates select="bound_spec" mode="literal" />
       <xsl:value-of select="' OF '" />
       <xsl:apply-templates select="bound_spec" mode="literal" />
       <xsl:apply-templates select="*[not(self::bound_spec)]"  mode="literal" />
  </xsl:template>



  <xsl:template match="bound_spec"  mode="literal">
    <xsl:value-of select="'['"/> 
     <xsl:apply-templates select="lower_bound"  mode="literal"/> 
    <xsl:value-of select="':'"/> 
     <xsl:apply-templates select="upper_bound"  mode="literal"/>
    <xsl:value-of select="']'"/> 
    <xsl:apply-templates mode="literal"/>
  </xsl:template>

  <xsl:template match="lower_bound"  mode="literal">
      <xsl:apply-templates  mode="literal"/>
  </xsl:template>

  <xsl:template match="upper_bound"  mode="literal">
    <xsl:attribute name="upper">
      <xsl:apply-templates   mode="literal"/>
    </xsl:attribute>
  </xsl:template>

 <xsl:template match="index_spec"    mode="literal">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="low_index"   mode="literal">
      <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="high_index"    mode="literal">
      <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="unset">
    <xsl:value-of select="'?'"/>
  </xsl:template>

  <xsl:template match="const_e">
    <xsl:value-of select="'E'"/>
  </xsl:template>

  <xsl:template match="pi">
    <xsl:value-of select="'PI'"/>
  </xsl:template>
 <xsl:template match="rule_decl">
   <xsl:apply-templates />
  </xsl:template>
 <xsl:template match="rule_id">
   <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="parameter_ref"  mode="literal">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="unique">
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="unique_clause">
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="unique_rule">
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="unknown">
    <xsl:apply-templates />
 </xsl:template>
  <xsl:template match="until">
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="usedin">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="value">
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="value_in">
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="value_unique">
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="variable_id">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="variable_ref">
    <xsl:value-of select="."/>
  </xsl:template>
 
 <xsl:template match="var_formal_parameter">
    <xsl:value-of select="."/>
  </xsl:template>
<xsl:template match="where_clause">
  <xsl:apply-templates/>
  </xsl:template>
 
<xsl:template match="where_clause_parameter">
  <xsl:apply-templates/>
  </xsl:template>

 <xsl:template match="while">
 <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="width_spec">
  <xsl:apply-templates/>
  </xsl:template>
 <xsl:template match="xor">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="select">
    <xsl:element name="select">
      <xsl:apply-templates select="extensible"/>
      <xsl:apply-templates select="generic_entity"/>
      <xsl:apply-templates select="based_on"/>
      <xsl:apply-templates select="." mode="refs"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="select" mode="refs">
    <xsl:if test="./entity_ref or ./type_ref">
      <xsl:attribute name="selectitems">
	<xsl:for-each select="entity_ref|type_ref" >
	  <xsl:value-of select="concat(string(.),' ')"/>
	</xsl:for-each>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template match="extensible">
    <xsl:attribute name="extensible">YES</xsl:attribute>
  </xsl:template>

  <xsl:template match="based_on">
    <xsl:attribute name="name">
      <xsl:apply-templates />
    </xsl:attribute>
  </xsl:template>

<xsl:template match="term" mode="literal">
  <xsl:apply-templates select="*[2]"   mode="literal"/>
  <xsl:apply-templates select="*[1]"   mode="literal"/>
  <xsl:apply-templates select="*[3]"   mode="literal"/>
</xsl:template>

<xsl:template match="population">
      <xsl:apply-templates />
</xsl:template>

<xsl:template match="element_item">
      <xsl:apply-templates />
</xsl:template>

<xsl:template match="entity_instance">
      <xsl:apply-templates />
</xsl:template>

<xsl:template match="entity_instance_as_group">
      <xsl:apply-templates />
</xsl:template>

<xsl:template match="entity_instance_ref">
      <xsl:apply-templates />
</xsl:template>


<xsl:template match="element_list">
      <xsl:apply-templates />
</xsl:template>


<xsl:template match="factor">
      <xsl:apply-templates />
</xsl:template>


<xsl:template match="integer_divide">
      <xsl:apply-templates />
</xsl:template>

<xsl:template match="mod">
      <xsl:apply-templates />
</xsl:template>
<xsl:template match="multiply">
      <xsl:apply-templates />
</xsl:template>
<xsl:template match="negate">
      <xsl:apply-templates />
</xsl:template>
<xsl:template match="not_equal">
      <xsl:apply-templates />
</xsl:template>
<xsl:template match="null_stmt">
      <xsl:apply-templates />
</xsl:template>

<xsl:template match="real_divide">
      <xsl:apply-templates />
</xsl:template>

<xsl:template match="numeric_expression" mode="literal">
      <xsl:apply-templates mode="literal"/>
</xsl:template>

<xsl:template match="nvl">
      <xsl:apply-templates />
</xsl:template>
<xsl:template match="odd">
      <xsl:apply-templates />
</xsl:template>


  <xsl:template match="or|and">
    <xsl:variable name="literal">
	<xsl:call-template name="toupper">
	  <xsl:with-param name="string" select="name(.)"/>
	</xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="concat(' ',$literal,' ')"/>
  </xsl:template>

  <xsl:template match="self" mode="literal">
    <xsl:variable name="literal">
      <xsl:call-template name="toupper">
	<xsl:with-param name="string" select="name(.)"/>
      </xsl:call-template>
    </xsl:variable>
   <xsl:value-of select="$literal"/>
 </xsl:template>

  <xsl:template match="sizeof|not|exists|typeof"  mode="literal">
    <xsl:variable name="literal">
      <xsl:call-template name="toupper">
	<xsl:with-param name="string" select="name(.)"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="$literal"/>
  </xsl:template>


<xsl:template match="otherwise"  mode="literal">
      <xsl:apply-templates  mode="literal"/>
</xsl:template>

<xsl:template match="parenthetic_expression"  mode="literal">
  <xsl:value-of select="'('"/>
      <xsl:apply-templates  mode="literal"/>
  <xsl:value-of select="')'"/>
</xsl:template>
<xsl:template match="partial_entity_instance" mode="literal">
      <xsl:apply-templates  mode="literal"/>
</xsl:template>
<xsl:template match="plus" mode="literal">
      <xsl:value-of select="' + '" />
</xsl:template>

<xsl:template match="relation_expression|simple_expression" mode="literal">
      <xsl:apply-templates select="*[2]"  mode="literal"/>
      <xsl:apply-templates select="*[1]"  mode="literal"/>
      <xsl:apply-templates select="*[3]" mode="literal"/>
</xsl:template>

<xsl:template match="in" mode="literal">
    <xsl:value-of select="' IN '"  />
</xsl:template>

<xsl:template match="function_call" mode="literal">
    <xsl:for-each select="child::node()">
      <xsl:choose>
	<xsl:when test="position()=1">
	  <xsl:apply-templates select="." mode="literal"/>
	</xsl:when>
	<xsl:when test="position()=2" >
	  <xsl:value-of select="'('"/>
	  <xsl:apply-templates select="." mode="literal"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="', '"/>
	  <xsl:apply-templates select="." mode="literal"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <xsl:value-of select="')'"/>
</xsl:template>

<xsl:template match="function_id| parameter_id" mode="literal">
  <xsl:attribute name="name"><xsl:value-of select="."/></xsl:attribute>
</xsl:template>

<xsl:template match="function_import" mode="literal">
      <xsl:apply-templates mode="literal"/>
</xsl:template>

<xsl:template match="function_return_type" mode="literal">
      <xsl:apply-templates mode="literal"/>
</xsl:template>

<xsl:template match="general_type" mode="literal">
      <xsl:apply-templates mode="literal"/>
</xsl:template>


<xsl:template match="true">
      <xsl:apply-templates />
</xsl:template>

<xsl:template match="generic_type">
    <xsl:element name="builtintype">
      <xsl:attribute name="type">
	<xsl:value-of select="'GENERIC'"/>
      </xsl:attribute>
      <xsl:apply-templates select="type_label_id"/>
    </xsl:element>
  </xsl:template>

<xsl:template match="greater_than">
      <xsl:value-of select="' &gt; '" />
</xsl:template>

<xsl:template match="greater_than_or_equal">
      <xsl:value-of select="' &gt;= '" />
</xsl:template>
<xsl:template match="hibound">
      <xsl:apply-templates />
</xsl:template>
<xsl:template match="high_index">
      <xsl:apply-templates />
</xsl:template>
<xsl:template match="hiindex">
      <xsl:apply-templates />
</xsl:template>
<xsl:template match="if_stmt" mode="literal">
  <xsl:value-of select="'IF '" />
      <xsl:apply-templates select="logical_expression" mode="literal"/>
  <xsl:value-of select="' THEN
'" />
      <xsl:apply-templates select="statement_block[1]"  mode="literal" />
      <xsl:variable name="else" select="statement_block[2]"/>
      <xsl:if test="$else">
  <xsl:value-of select="'
ELSE
'" />
  <xsl:apply-templates select="statement_block[2]"   mode="literal"/>
</xsl:if>
  <xsl:value-of select="'END_IF;
'"/>
</xsl:template>


<xsl:template match="import_all">
      <xsl:apply-templates />
</xsl:template>
<xsl:template match="increment"  mode="literal">
      <xsl:apply-templates />
</xsl:template>
<xsl:template match="increment_control"  mode="literal">
      <xsl:apply-templates />
</xsl:template>

<xsl:template match="index_qualifier" mode="literal">
      <xsl:value-of select="'['" />
      <xsl:apply-templates mode="literal"/>
      <xsl:value-of select="']'" />
</xsl:template>
<xsl:template match="index_spec" mode="literal">
      <xsl:apply-templates  mode="literal"/>
</xsl:template>
<xsl:template match="inherited_attribute_instance"  mode="literal">
      <xsl:apply-templates  mode="literal"/>
</xsl:template>
<xsl:template match="insert">
      <xsl:apply-templates />
</xsl:template>

<xsl:template match="instance_equal"  mode="literal">
      <xsl:value-of select="' :=: '" />
</xsl:template>

<xsl:template match="instance_not_equal"   mode="literal">
      <xsl:value-of select="' :&lt;&gt;: '" />
</xsl:template>

<xsl:template match="qualified_attribute"  mode="literal">
  <xsl:attribute name="name">
      <xsl:apply-templates select="attribute_ref"  mode="literal"/>
  </xsl:attribute>
</xsl:template>

<xsl:template match="qualified_factor" mode="literal">
      <xsl:apply-templates select="attribute_ref|entity_ref|parameter_ref|variable_ref|self"/>
      <xsl:apply-templates select="qualifier" mode="literal"/>
</xsl:template>


<xsl:template match="qualifier" mode="literal">
  <xsl:for-each select="child::node()">
    <xsl:choose>
      <xsl:when test="self::entity_ref">
	<xsl:value-of select="'\'"/>
	<xsl:apply-templates select="." mode="literal"/>
      </xsl:when>
      <xsl:when test="self::attribute_ref">
	<xsl:value-of select="'.'"/>
	<xsl:apply-templates select="."  mode="literal"/>
      </xsl:when>
      <xsl:when test="self::index_qualifier" >
	<xsl:apply-templates select="." mode="literal"/>
      </xsl:when>

      <xsl:otherwise>
	<xsl:value-of select="':did not find:'"/>
	<xsl:apply-templates select="." mode="literal"/>
	<xsl:value-of select="':'"/>
		<xsl:value-of select="':name-of-folsib:'"/> <xsl:value-of select="name(./following-sibling::node())" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>

<xsl:template match="domain_rule">
<xsl:element name="where">
      <xsl:apply-templates />
</xsl:element>
</xsl:template>

<xsl:template match="label">
    <xsl:attribute name="label" ><xsl:value-of select="."/></xsl:attribute>
</xsl:template>

<xsl:template match="length">
      <xsl:apply-templates />
</xsl:template>

<xsl:template match="less_than"   mode="literal">
      <xsl:value-of select="' &lt; '" />
</xsl:template>
<xsl:template match="less_than_or_equal"  mode="literal">
      <xsl:value-of select="' &lt;= '" />
      <xsl:apply-templates  mode="literal"/>
</xsl:template>
<xsl:template match="like"  mode="literal">
      <xsl:apply-templates mode="literal"/>
</xsl:template>
<xsl:template match="list_literal" mode="literal">
      <xsl:apply-templates  mode="literal"/>
</xsl:template>
<xsl:template match="lobound" mode="literal">
      <xsl:apply-templates  mode="literal"/>
</xsl:template>
<xsl:template match="length" mode="literal">
      <xsl:apply-templates  mode="literal"/>
</xsl:template>
<xsl:template match="local_variable_block" mode="literal">
  <xsl:value-of select="'
LOCAL
'"/>
      <xsl:apply-templates  mode="literal"/>
  <xsl:value-of select="'
END_LOCAL;
'"/>
</xsl:template>

<xsl:template match="local_variable_decl" mode="literal">
      <xsl:apply-templates select="variable_id" mode="literal"/>
      <xsl:value-of select="' : '" />
      <xsl:apply-templates select="*[2]" mode="literal"/>
      <xsl:if test="*[3]">
	<xsl:value-of select="' := '" /> 
	<xsl:apply-templates select="*[3]" mode="literal" />
      </xsl:if>
      <xsl:value-of select="';
'" />
</xsl:template>

<xsl:template match="log"   mode="literal">
      <xsl:apply-templates   mode="literal" />
</xsl:template>
<xsl:template match="log10"  mode="literal">
      <xsl:apply-templates />
</xsl:template>
<xsl:template match="log2" mode="literal">
      <xsl:apply-templates  mode="literal"/>
</xsl:template>
<xsl:template match="logical_literal">
      <xsl:apply-templates  mode="literal"/>
</xsl:template>
<xsl:template match="loindex" mode="literal">
      <xsl:apply-templates  mode="literal"/>
</xsl:template>
<xsl:template match="low_index" mode="literal">
      <xsl:apply-templates  mode="literal"/>
</xsl:template>

<xsl:template match="logical_expression" mode="literal">
    <xsl:apply-templates  mode="literal"/>
</xsl:template>

<xsl:template match="unary_op" mode="literal">
      <xsl:apply-templates select="*[1]"  mode="literal"/>
    <xsl:value-of select="'('"/>
      <xsl:apply-templates select="*[2]"  mode="literal"/>
    <xsl:value-of select="')'"/>
</xsl:template>

<xsl:template match="complex_entity_constructor" mode="literal">
    <xsl:value-of select="' || '"/>
</xsl:template>

<xsl:template match="entity_constructor" mode="literal">
      <xsl:apply-templates  select="entity_ref" mode="literal"/>
      <xsl:value-of select="'('"/>
      <xsl:apply-templates  select="*[not(self::entity_ref)]" mode="literal"/>
      <xsl:value-of select="')'"/>
</xsl:template>

  <xsl:template match="*">
  <!-- comment this out to see what's done. 
    <xsl:value-of select="name(.)" /> 
    <br/> -->
  </xsl:template>

<xsl:template match="declaration_block" mode="literal">
      <xsl:apply-templates  mode="literal"/>
</xsl:template>
<xsl:template match="embedded_remark" mode="literal">
      <xsl:apply-templates />
</xsl:template>
<xsl:template match="tail_remark" mode="literal">
      <xsl:apply-templates />
</xsl:template>
<xsl:template match="function_decl" mode="literal">
      <xsl:apply-templates mode="literal"/>
  </xsl:template>

<xsl:template match="procedure_decl" mode="literal">
      <xsl:apply-templates  mode="literal"/>
</xsl:template>

<xsl:template match="derive_clause" mode="literal">
      <xsl:value-of select="'WARNING: NOT IMPLEMENTED'" />
  <xsl:apply-templates  mode="literal"/>
</xsl:template>

<xsl:template match="aggregate_initializer" mode="literal">
  <xsl:value-of select="'['" />
  <xsl:apply-templates mode="literal"/>
  <xsl:value-of select="']'" />
</xsl:template>

<xsl:template match="population" mode="literal">
      <xsl:apply-templates mode="literal"/>
</xsl:template>

<xsl:template match="entity_constructor"  mode="literal">
      <xsl:apply-templates  mode="literal" />
</xsl:template>

<xsl:template match="enumeration_reference"  mode="literal">
      <xsl:apply-templates  mode="literal"/>
</xsl:template>

<xsl:template match="enumeration"  mode="literal">
      <xsl:apply-templates  mode="literal"/>
</xsl:template>

<xsl:template match="equal"  mode="literal">
      <xsl:value-of select="'='" />
</xsl:template>

<xsl:template match="alias_stmt | case_stmt | escape_stmt | null_stmt | procedure_call_stmt | skip_stmt"   mode="literal">
      <xsl:apply-templates  mode="literal" />
</xsl:template>

<xsl:template match="assignment_stmt"   mode="literal">
      <xsl:apply-templates select="*[1]"  mode="literal"/>
      <xsl:value-of select="' := '"/>
      <xsl:apply-templates select="*[last()]" mode="literal"/>
      <xsl:apply-templates select="qualifier"  mode="literal"/>
      <xsl:value-of select="';
'"/>
</xsl:template>

<xsl:template match="return_stmt" mode="literal">
 <xsl:value-of select="'RETURN('"/>
 <xsl:apply-templates  mode="literal" />
 <xsl:value-of select="');
'"/>
</xsl:template>

<xsl:template match="repeat_stmt"   mode="literal">
 <xsl:value-of select="'REPEAT '"/>
 <xsl:apply-templates  select="repreat_control" mode="literal" />
 <xsl:value-of select="';
'"/>
 <xsl:apply-templates  select="statement_block" mode="literal" />
 <xsl:value-of select="'END_REPEAT;
'"/>
</xsl:template>


<xsl:template match="escape_stmt"  mode="literal">
      <xsl:apply-templates  mode="literal"/>
</xsl:template>


<xsl:template match="exp">
      <xsl:apply-templates />
</xsl:template>

<xsl:template match="interval" mode="literal">
  <xsl:value-of select="'{'" />
  <xsl:apply-templates  mode="literal"/>
  <xsl:value-of select="'}'" />
</xsl:template>


<xsl:template match="interval_high_exclusive"  mode="literal">
      <xsl:value-of select="' &lt; '" />
      <xsl:apply-templates mode="literal"/>
</xsl:template>

<xsl:template match="interval_high_inclusive"  mode="literal">
      <xsl:value-of select="' &lt; '" />
      <xsl:apply-templates mode="literal"/>
</xsl:template>
<xsl:template match="interval_item" mode="literal">
      <xsl:apply-templates mode="literal"/>
</xsl:template>
<xsl:template match="interval_low_exclusive" mode="literal">
      <xsl:apply-templates mode="literal"/>
      <xsl:value-of select="' &gt; '" />
</xsl:template>

<xsl:template match="interval_low_inclusive">
      <xsl:apply-templates />
      <xsl:value-of select="' &gt;= '" />
</xsl:template>


<xsl:template match="inverse_attr">
      <xsl:apply-templates />
</xsl:template>

<xsl:template match="inverse_bag">
      <xsl:apply-templates />
</xsl:template>

<xsl:template match="inverse_clause">
      <xsl:apply-templates />
</xsl:template>
<xsl:template match="inverse_clause">
      <xsl:apply-templates />
</xsl:template>
<xsl:template match="inverse_set">
      <xsl:apply-templates />
</xsl:template>
<xsl:template match="inverse_clause">
      <xsl:apply-templates />
</xsl:template>

<xsl:template match="query" mode="literal">
    <xsl:variable name="literal">
      <xsl:call-template name="toupper">
	<xsl:with-param name="string" select="name(.)"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="$literal"/>
    <xsl:value-of select="'('"/>
    <xsl:apply-templates select="variable_id" mode="literal"/>
    <xsl:value-of select="' &gt;* '"/>
    <xsl:apply-templates select="aggregate_source" mode="literal"/>
    <xsl:value-of select="'|'"/>
    <xsl:apply-templates select="logical_expression" mode="literal"/>

</xsl:template>

<xsl:template match="aggregate_source" mode="literal">
      <xsl:apply-templates mode="literal" />
</xsl:template>

<xsl:template match="binary_literal">
      <xsl:apply-templates />
</xsl:template>

<xsl:template match="boolean_literal">
      <xsl:apply-templates />
</xsl:template>

<xsl:template match="real_literal">
      <xsl:apply-templates />
</xsl:template>

<xsl:template match="string_literal" mode="literal">
  <xsl:value-of select='string("&apos;")'/>
  <xsl:apply-templates mode="literal"/>
  <xsl:value-of select='string("&apos;")'/>
</xsl:template>

<xsl:template match="false">
      <xsl:apply-templates />
</xsl:template>

<xsl:template match="fixed">
      <xsl:apply-templates />
</xsl:template>

<xsl:template match="formal_parameter">
    <xsl:element name="parameter">
      <xsl:apply-templates select="parameter_id"/>
      <xsl:apply-templates select="*[position() > 1]"/>
    </xsl:element> 
</xsl:template>


<xsl:template match="formal_parameter_block">
    <xsl:apply-templates />
</xsl:template>

<xsl:template match="format">
      <xsl:apply-templates />
</xsl:template>

<xsl:template name="toupper">
<xsl:param name="string"/>
        <xsl:value-of select="translate($string,$LOWER,$UPPER)"/>
</xsl:template>
 
</xsl:stylesheet>
