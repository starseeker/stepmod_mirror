<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
	$Id: $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:param name="merge_application_protocol" select="'merge_application_protocol'"/>
	<xsl:param name="merge_clause" select="'merge_clause'"/>
	<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"/>
	
	<xsl:variable name="description_file">
		<xsl:choose>
			<xsl:when test="$merge_clause='ir'">
				<xsl:value-of select="concat('../data/resources/', $merge_application_protocol,'/descriptions/description.xml')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat('../data/application_protocols/', $merge_application_protocol,'/descriptions/description.xml')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="descriptions" select="document($description_file)/ext_descriptions"/>
	
	<xsl:template match="/">
		<xsl:message>
			XSL reading description:
			<xsl:value-of select="$description_file"/>
		</xsl:message>
		<xsl:apply-templates mode="copy"/>
	</xsl:template>
	
	<xsl:template match="*" mode="copy">
		<xsl:message>
			Copying:
			<xsl:value-of select="name()"/>
		</xsl:message>
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="." mode="output_description"/>
			<xsl:apply-templates select="node()" mode="copy"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="express" mode="output_description"/>
		<xsl:template match="schema" mode="output_description">
  <xsl:variable name="express_ref">
    <xsl:call-template name="make_express_ref">
      <xsl:with-param name="application_protocol" select="$merge_application_protocol"/>
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
      <xsl:with-param name="application_protocol" select="$merge_application_protocol"/>
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
      <xsl:with-param name="application_protocol" select="$merge_application_protocol"/>
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
      <xsl:with-param name="application_protocol" select="$merge_application_protocol"/>
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
  <xsl:param name="application_protocol"/>

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
    select="concat($application_protocol,':',$clause,':',$schema)"/>

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
