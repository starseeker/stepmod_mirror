<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_e_obj_reg.xsl,v 1.2 2003/05/27 07:34:15 robbod Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose:     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:import href="../sect_b_obj_reg.xsl"/>
	<xsl:import href="application_protocol.xsl"/>
	<xsl:import href="application_protocol_clause.xsl"/>
	<xsl:output method="html"/>
	
	<xsl:template match="module"/>
	
	<xsl:template match="application_protocol">
		<xsl:call-template name="annex_header">
			<xsl:with-param name="annex_no" select="'E'"/>
			<xsl:with-param name="heading" select="'Information object registration'"/>
			<xsl:with-param name="aname" select="'annexe'"/>
			<xsl:with-param name="informative" select="'normative'"/>
		</xsl:call-template>
		<xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ_</xsl:variable>
		<xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz-</xsl:variable>
		<xsl:variable name="ap_module_dir">
			<xsl:call-template name="ap_module_directory">
				<xsl:with-param name="application_protocol" select="@name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="application_protocol_dir">
			<xsl:call-template name="application_protocol_directory">
				<xsl:with-param name="application_protocol" select="@name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="arm_xml" select="concat($ap_module_dir,'/arm.xml')"/>
		<xsl:variable name="aim_xml" select="concat($ap_module_dir,'/mim.xml')"/>
		<xsl:variable name="schema_name" select="document($arm_xml)/express/schema/@name"/>
		<xsl:variable name="object_reg" select="concat('{ iso standard 10303 part(',@part,') version(',@version,')')"/>
		<h2>E.1 Document identification </h2>
		To provide for unambiguous identification of an information object in an open system, the object identifier
		<p align="center">
			<xsl:value-of select="concat($object_reg,' }' )"/>
		</p>
		is assigned to this part of ISO 10303. The meaning of this value is defined in ISO/IEC 8824-1, and is described in ISO 10303-1.
		<h2>E.2 Schema identification</h2>
		
		<xsl:variable name="arm_schema" select="document($arm_xml)/express/schema/@name"/>
		<xsl:variable name="arm_schema_reg" select="translate($arm_schema,$UPPER, $LOWER)"/>
		<h2>E.2.1 <xsl:value-of select="$arm_schema"/> schema identification</h2>
		<p>
			To provide for unambiguous identification of the schema specifications given in this application module in an open information system, the object identifiers are assigned as follows:
		</p>
		<p align="center">
			<xsl:value-of select="concat($object_reg,' schema(1) ', $arm_schema_reg,'(1) }' )"/>
		</p>
		<p>
			is assigned to the <xsl:value-of select="$arm_schema"/> schema. The meaning of this value is defined in ISO 8824-1, and is described in ISO 10303-1.
		</p>
		<xsl:variable name="aim_schema" select="document($aim_xml)/express/schema/@name"/>
		<xsl:variable name="aim_schema_reg" select="translate($aim_schema,$UPPER, $LOWER)"/>
		<h2>E.2.2 <xsl:value-of select="substring-before($aim_schema, '_mim')"/>_aim schema identification</h2>
		<p>
			To provide for unambiguous identification of the schema specifications given in this application module in an open information system, the object identifiers are assigned as follows:
		</p>
		<p align="center">
			<xsl:value-of select="concat($object_reg,' schema(1) ', $aim_schema_reg,'(2) }' )"/>
		</p>
		<p>
			is assigned to the <xsl:value-of select="substring-before($aim_schema, '_mim')"/>_aim schema. The meaning of this value is defined in ISO 8824-1, and is described in
    ISO 10303-1.
		</p>
	</xsl:template>
	
</xsl:stylesheet>
