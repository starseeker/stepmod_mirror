<?xml version="1.0" encoding="utf-8"?>

<!--
$Id: express_index.xsl,v 1.5 2005/03/05 01:05:31 thendrix Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:saxon="http://icl.com/saxon"
  extension-element-prefixes="msxsl saxon"
  version="1.0">

  <xsl:import href="../../../xsl/common.xsl"/>


  <xsl:output method="html"/>


<xsl:template match="repository_index">
  <xsl:param name="arm_mim"/>
  <xsl:variable name="objects">
    <xsl:choose>
      <xsl:when test="$arm_mim='resource'">
        <xsl:element name="objects">
          <xsl:apply-templates select="./resources/resource" mode="objects">
            <xsl:with-param name="arm_mim" select="$arm_mim"/>
          </xsl:apply-templates>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="objects">
          <xsl:apply-templates select="./modules/module" mode="objects">
            <xsl:with-param name="arm_mim" select="$arm_mim"/>
          </xsl:apply-templates>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  

  <xsl:choose>
    <xsl:when test="function-available('msxsl:node-set')">
      <xsl:variable name="objects-node-set" 
        select="msxsl:node-set($objects)"/>
      <xsl:apply-templates select="." mode="node_set">
        <xsl:with-param name="arm_mim" select="$arm_mim"/>
        <xsl:with-param name="objects-node-set" select="$objects-node-set"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="function-available('saxon:node-set')">
      <xsl:variable name="objects-node-set" 
        select="saxon:node-set($objects)"/>
      <xsl:apply-templates select="." mode="node_set">
        <xsl:with-param name="arm_mim" select="$arm_mim"/>
        <xsl:with-param name="objects-node-set" select="$objects-node-set"/>
      </xsl:apply-templates>      
    </xsl:when>
    <xsl:otherwise>
      XSL require node-set function.
      Currently checks for SAXON MSXML3
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
  
<xsl:template match="repository_index" mode="node_set">
  <xsl:param name="objects-node-set"/>
  <xsl:param name="arm_mim"/>
  <xsl:variable name="title">
    <xsl:choose>
      <xsl:when test="$arm_mim='arm'">
        ARM Objects
      </xsl:when>
      <xsl:when test="$arm_mim='mim'">
        MIM Objects
      </xsl:when>
      <xsl:otherwise>
        Resource Objects
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <html>
    <head>
      <!-- apply a cascading stylesheet.
           the stylesheet will only be applied if the parameter output_css
           is set in parameter.xsl 
           -->
      <link rel="stylesheet" type="text/css" href="../css/stepmod.css"/>
      <title>
        <xsl:value-of select="$title"/>
      </title>
    </head>
    <body>
        <h4>
          <xsl:value-of select="$title"/>
        </h4>
        <font size= "-2">
          <xsl:if test="$objects-node-set/objects/schema_object">
            <a href="#schema_object">schemas</a>&#160;
          </xsl:if>
          
          <xsl:if test="$objects-node-set/objects/schema_object/constant_object">
            <a href="#constant_object">constants</a>&#160;
          </xsl:if>
          
          <xsl:if test="$objects-node-set/objects/schema_object/type_object">
            <a href="#type_object">types</a>&#160;
          </xsl:if>

          <xsl:if test="$objects-node-set/objects/schema_object/entity_object">
            <a href="#entity_object">entities</a>&#160; 
          </xsl:if>
          
          <xsl:if test="$objects-node-set/objects/schema_object/rule_object">
            <a href="#rule_object">rules</a>&#160;
          </xsl:if>
          
          <xsl:if test="$objects-node-set/objects/schema_object/function_object">
            <a href="#function_object">functions</a>&#160; 
          </xsl:if>
          
          <xsl:if test="$objects-node-set/objects/schema_object/procedure_object">
            <a href="#procedure_object">procedures</a>&#160;
          </xsl:if>

          <xsl:if test="$objects-node-set/objects/schema_object/subtype.constraint_object">
            <a href="#subtype.constraint_object">subtype constraints</a>&#160;
          </xsl:if>

        </font>

      <xsl:apply-templates select="$objects-node-set/objects/schema_object">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

     <dl>
        <xsl:apply-templates
          select="$objects-node-set/objects/schema_object/type_object">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
      </dl>

      <dl>
        <xsl:apply-templates
          select="$objects-node-set/objects/schema_object/constant_object">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
      </dl>
      <dl>
        <xsl:apply-templates
          select="$objects-node-set/objects/schema_object/entity_object">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
      </dl>
      
      <dl>
        <xsl:apply-templates
          select="$objects-node-set/objects/schema_object/function_object">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
      </dl>
      <dl>
        <xsl:apply-templates
          select="$objects-node-set/objects/schema_object/rule_object">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
      </dl>
      <dl>
        <xsl:apply-templates
          select="$objects-node-set/objects/schema_object/procedure_object">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
      </dl>
      <dl>
        <xsl:apply-templates
          select="$objects-node-set/objects/schema_object/subtype.constraint_object">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
      </dl>
    </body>
  </html>
</xsl:template>


<!-- collect up the objects -->
<xsl:template match="resource" mode="objects">
  <xsl:variable name="schema_doc" 
    select="concat('../../../stepmod/data/resources/',@name,'/',@name,'.xml')"/>
  <xsl:apply-templates 
    select="document($schema_doc)/express/schema"
    mode="objects">
    <xsl:with-param name="file" select="concat(@name,'.xml')"/>
  </xsl:apply-templates>
</xsl:template>


<!-- collect up the objects -->
<xsl:template match="module" mode="objects">
  <xsl:param name="arm_mim"/>
  <xsl:variable name="schema_doc" 
    select="concat('../../../stepmod/data/modules/',@name,'/',$arm_mim,'.xml')"/>
  <xsl:apply-templates 
    select="document($schema_doc)/express/schema"
    mode="objects">
    <xsl:with-param name="file" select="concat($arm_mim,'.xml')"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="schema" mode="objects">
  <xsl:param name="file"/>
  <xsl:element name="schema_object">
    <xsl:attribute name="name">
      <xsl:value-of select="@name"/>
    </xsl:attribute>
    <xsl:attribute name="file">
      <xsl:value-of select="$file"/>
    </xsl:attribute>
    <xsl:attribute name="module">
      <xsl:call-template name="module_name">
        <xsl:with-param name="module" select="@name"/>
      </xsl:call-template>
    </xsl:attribute>

    <xsl:apply-templates select="*" mode="objects">
      <xsl:with-param name="file" select="$file"/>
    </xsl:apply-templates>
  </xsl:element>
</xsl:template>

<xsl:template 
  match="constant|type|entity|procedure|function|rule|subtype.constraint" 
  mode="objects">
  <xsl:param name="file"/>
  <xsl:variable name="obj_type" select="name()"/>
  <xsl:element name="{$obj_type}_object">
    <xsl:attribute name="name">
      <xsl:value-of select="@name"/>
    </xsl:attribute>
    <xsl:attribute name="file">
      <xsl:value-of select="$file"/>
    </xsl:attribute>
    <xsl:attribute name="schema">
      <xsl:value-of select="../@name"/>
    </xsl:attribute>
    <xsl:attribute name="module">
      <xsl:call-template name="module_name">
        <xsl:with-param name="module" select="../@name"/>
      </xsl:call-template>
    </xsl:attribute>
  </xsl:element>
</xsl:template>


<xsl:template match="schema_object">
  <xsl:if test="position()=1">
    <h5>
      <a name="schema">Schemas</a>
      <a href="#top"> <font size="-3"> [top]</font></a>
    </h5>
  </xsl:if>
  <xsl:variable name="schema_href">
    <xsl:choose>
      <xsl:when test="@file='arm.xml'">
        <xsl:value-of 
          select="concat('../../stepmod/data/modules/',@module,
                  '/sys/4_info_reqs',$FILE_EXT,'#',@name)"/>        
      </xsl:when>
      <xsl:when test="@file='mim.xml'">
        <xsl:value-of 
          select="concat('../../stepmod/data/modules/',@module,
                  '/sys/5_mim',$FILE_EXT,'#',@name)"/>        
      </xsl:when>
      <xsl:otherwise>
        <!-- must be an Integrated Resource -->
        <xsl:value-of 
          select="concat('../../stepmod/data/resources/',
                  @name,'/',@name,$FILE_EXT,'#',@name)"/>        
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <font size="-3">
    <a href="{$schema_href}" target="content">
      <xsl:value-of select="@name"/><br/>
    </a>
  </font>
</xsl:template>

<xsl:template match="type_object|entity_object|function_object|rule_object|procedure_object|constant_object|subtype.constraint_object">
  <xsl:if test="position()=1">
    <xsl:variable name="aname" select="name()"/>
    <h5>
      <a name="{$aname}">
        <xsl:apply-templates select="." mode="section_head"/>
      </a>
      <a href="#top"> <font size="-3"> [top]</font></a>
    </h5>
  </xsl:if>

  <xsl:variable name="schema" select="@schema"/>
  <xsl:variable name="schema_href">
    <xsl:choose>
      <xsl:when test="@file='arm.xml'">
        <xsl:value-of 
          select="concat('../../stepmod/data/modules/',@module,
                  '/sys/4_info_reqs',$FILE_EXT,'#',$schema)"/>
      </xsl:when>
      <xsl:when test="@file='mim.xml'">
        <xsl:value-of 
          select="concat('../../stepmod/data/modules/',@module,
                  '/sys/5_mim',$FILE_EXT,'#',$schema)"/>        
      </xsl:when>
      <xsl:otherwise>
        <!-- must be an Integrated Resource -->
        <xsl:value-of 
          select="concat('../../stepmod/data/resources/',
                  $schema,'/',$schema,$FILE_EXT,'#',$schema)"/>        
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="type_href" 
    select="concat($schema_href,'.',@name)"/>
  <dt>
    <font size="-3">
      <a href="{$type_href}" target="content">
        <xsl:value-of select="@name"/>
      </a>
    </font>
  </dt>
  <dd>
    <font size="-3">
      <a href="{$schema_href}" target="content">
        <i><xsl:value-of select="@schema"/></i><br/>
      </a>
    </font>
  </dd>
</xsl:template>



<xsl:template match="type_object" mode="section_head">
  Types
</xsl:template>

<xsl:template match="entity_object" mode="section_head">
  Entities
</xsl:template>

<xsl:template match="function_object" mode="section_head">
  Functions
</xsl:template>

<xsl:template match="rule_object" mode="section_head">
  Rules
</xsl:template>

<xsl:template match="procedure_object" mode="section_head">
  Procedures
</xsl:template>

<xsl:template match="constant_object" mode="section_head">
  Constants
</xsl:template>

<xsl:template match="subtype.constraint_object" mode="section_head">
  Subtype Constraints
</xsl:template>


</xsl:stylesheet>