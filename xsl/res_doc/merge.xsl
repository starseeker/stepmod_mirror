<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: merge.xsl,v 1.3 2002/03/04 07:54:13 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: Merges descriptions into EXPRESS and then outputs new XML.
     Assumes a single description file containing the descriptions
     stored in:
          ?module?/descriptions/description.xml

     The description file comprises of XML with the following DTD.
     !ELEMENT ext_descriptions (ext_description*)
     !ATTLIST ext_descriptions module_directory CDATA #REQUIRED
     
     !ELEMENT ext_description (ext_description*)
     !ATTLIST ext_descriptions reference CDATA #REQUIRED

     reference identifies the EXPRESS construct for which a description is
     being provided. In a module ARM or MIM it has the form:
     <module>:mim|arm:<schema>.<entity|type|function|constant>.<attribute>|wr:<whererule>|ur:<uniquerule>
 
     e.g. work_order:arm:work_arm_schema.Activity.name

     In an Integrated Resource schema:
     <ir>:ir:<schema>.<entity|type|function|constant>.<attribute>|wr:<whererule>|ur:<uniquerule>
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">


  <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
       parameters passed in by SAXON - hence these defaults are
       overwritten. -->

  <!-- The name of the module whose descriptions are being merged -->
  <xsl:param name="merge_module" select="'merge_module'"/>

  <!-- The clause whose descriptions are being merged.
       Either: arm mim ir
       -->
  <xsl:param name="merge_clause" select="'merge_clause'"/>

  <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->

  <xsl:output 
    method="xml"
    version="1.0" 
    encoding="utf-8"
    indent="yes"/>

  <!-- work out from the merge_clause which description file is to be read.
       Note that descriptions are assumed to be stored in:
          ?module?/descriptions/description.xml
       The assumption is that there is one description file per module.
       We could be more sophisticated and have an index that lists all of
       the modules description files.

       Also note that the path to the document function path argument 
       is relative to the stylesheet NOT the XML - hence the need to know
       which module you are in either as a parameter passed to the
        stylesheets or explicitly mentioned in the XML being processed.
       -->
  <xsl:variable name="description_file">
    <xsl:choose>
      <!-- reading descriptions for IRs -->
      <xsl:when test="$merge_clause='ir'">
        <xsl:value-of select="concat(
                              '../data/resources/',
                              $merge_module,'/descriptions/description.xml')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat(
                              '../data/modules/',
                              $merge_module,'/descriptions/description.xml')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- the node set of descriptions from the description document. This is
       used by the template name="output_ext_description" -->
  <xsl:variable name="descriptions"
    select="document($description_file)/ext_descriptions"/>
  

<!-- Start everything going -->
<xsl:template match="/">
  <xsl:message>
    XSL reading description: <xsl:value-of select="$description_file"/>
  </xsl:message>
  <xsl:apply-templates mode="copy"/>
</xsl:template>


<!-- make a copy of everything in the file --> 
<xsl:template match="*" mode="copy">
  <!-- debug -->
  <xsl:message>
    Copying:<xsl:value-of select="name()"/>    
  </xsl:message>

  <!-- create a shallow copy of the element being matched -->
  <xsl:copy>
    <!-- copy all the attributes of the element -->
    <xsl:copy-of select="@*"/>
    
    <!-- get the description for the element and output it -->
    <xsl:apply-templates select="." mode="output_description"/>

    <!-- recurse through rest of the elements - a deep copy -->
    <xsl:apply-templates select="node()" mode="copy"/>
  </xsl:copy>
</xsl:template>


<!-- empty template to prevent description for schema being output when
     processing the express element -->
<xsl:template match="express" mode="output_description"/>


<xsl:template match="schema" mode="output_description">
  <xsl:variable name="express_ref">
    <xsl:call-template name="make_express_ref">
      <xsl:with-param name="module" select="$merge_module"/>
      <xsl:with-param name="clause" select="$merge_clause"/>
      <xsl:with-param name="schema" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="output_ext_description">
    <xsl:with-param name="express_ref" select="$express_ref"/>    
  </xsl:call-template>
</xsl:template>

<!-- empty template to prevent description for schema being output when
     processing the schema element -->
<xsl:template match="description" mode="output_description"/>

<xsl:template match="constant | entity | type | function | procedure | rule" mode="output_description">
  <xsl:variable name="express_ref">
    <xsl:call-template name="make_express_ref">
      <xsl:with-param name="module" select="$merge_module"/>
      <xsl:with-param name="clause" select="$merge_clause"/>
      <xsl:with-param name="schema" select="../@name"/>
      <xsl:with-param name="entity" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="output_ext_description">
    <xsl:with-param name="express_ref" select="$express_ref"/>    
  </xsl:call-template>
</xsl:template>

<xsl:template match="where" mode="output_description">
  <xsl:variable name="express_ref">
    <xsl:call-template name="make_express_ref">
      <xsl:with-param name="module" select="$merge_module"/>
      <xsl:with-param name="clause" select="$merge_clause"/>
      <xsl:with-param name="schema" select="../../@name"/>
      <xsl:with-param name="entity" select="../@name"/>
      <xsl:with-param name="where" select="@label"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="output_ext_description">
    <xsl:with-param name="express_ref" select="$express_ref"/>    
  </xsl:call-template>
</xsl:template>

<xsl:template match="unique" mode="output_description">
  <xsl:variable name="express_ref">
    <xsl:call-template name="make_express_ref">
      <xsl:with-param name="module" select="$merge_module"/>
      <xsl:with-param name="clause" select="$merge_clause"/>
      <xsl:with-param name="schema" select="../../@name"/>
      <xsl:with-param name="entity" select="../@name"/>
      <xsl:with-param name="unique" select="@label"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="output_ext_description">
    <xsl:with-param name="express_ref" select="$express_ref"/>    
  </xsl:call-template>
</xsl:template>



<!-- make a copy of the children of the external description. -->
<xsl:template match="ext_description" mode="ext_copy">
  <xsl:copy-of select="node()"/>
</xsl:template>


<!--
     Return a reference for an express construct.
     The reference for an EXPRESS construct in a module ARM or MIM:
     <module>:mim|arm:<schema>.<entity|type|function|constant>.<attribute>|wr:<whererule>|ur:<uniquerule>
 
     e.g. work_order:arm:work_arm_schema.Activity.name

     To address an EXPRESS construct in an Integrated Resource schema:
     <ir>:ir:<schema>.<entity|type|function|constant>.<attribute>|wr:<whererule>|ur:<uniquerule>

-->
<xsl:template name="make_express_ref">
  <!-- the name of the module or IR whose descriptions are being merged -->
  <xsl:param name="module"/>

  <!-- The clause whose descriptions are being merged. 
       Either: mim arm ir 
       Compulsory parameter -->
  <xsl:param name="clause"/>
  
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

  <!-- NOTE: the parameters attribute, where and unique are exclusive. 
       Can only pass value for one attribute -->

  <xsl:variable name="return1"
    select="concat($module,':',$clause,':',$schema)"/>

  <xsl:variable name="return2">
    <xsl:choose>
      <xsl:when test="$entity">
        <xsl:value-of select="concat($return1,'.',$entity)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$return1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="return3">
    <xsl:choose>
      <xsl:when test="$attribute">
        <xsl:value-of select="concat($return2,'.',$attribute)"/>
      </xsl:when>
      <xsl:when test="$where">
        <xsl:value-of select="concat($return2,'.wr:',$where)"/>
      </xsl:when>
      <xsl:when test="$unique">
        <xsl:value-of select="concat($return2,'.ur:',$unique)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$return2"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:value-of select="$return3"/>
</xsl:template>


<!-- given an external reference, find the relevant description from the
     eternal description file and output it. -->
<xsl:template name="output_ext_description">
  <xsl:param name="express_ref"/>
  <!-- debug -->
  <xsl:message>
    Get external: <xsl:value-of select="$express_ref"/>
  </xsl:message>

  <xsl:element name="description">
    <xsl:apply-templates
      select="$descriptions/ext_description[@reference=$express_ref]"
      mode="ext_copy"/>
  </xsl:element>
  
</xsl:template>

</xsl:stylesheet>
