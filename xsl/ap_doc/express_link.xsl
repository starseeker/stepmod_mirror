<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
	$Id: express_link.xsl,v 1.2 2002/10/08 10:20:08 mikeward Exp $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="../express_link.xsl"/>
	<xsl:import href="common.xsl"/>

	<xsl:template name="build_interface_xref_list">
		<xsl:param name="interfaces"/>
		<xsl:param name="indent" select="''"/>
		<xsl:param name="xref_list" select="'|'"/>
		<xsl:choose>
			<xsl:when test="$interfaces">
				<xsl:variable name="first_interface" select="$interfaces[1]"/>
				<xsl:variable name="remaining_interfaces" select="$interfaces[position()!=1]"/>
				<xsl:variable name="if_schema_name" select="$first_interface/@schema"/>
				<xsl:variable name="express_file_ok">
					<xsl:call-template name="check_express_file_to_read">
						<xsl:with-param name="schema_name" select="$if_schema_name"/>
					</xsl:call-template>
				</xsl:variable>
				
				<xsl:variable name="express_file_to_read">
					<xsl:call-template name="express_file_to_read">
						<xsl:with-param name="schema_name" select="$if_schema_name"/>
					</xsl:call-template>
				</xsl:variable>
				
				<xsl:variable name="l1_xref_list">
					<xsl:choose>
						<xsl:when test="contains($express_file_ok,'ERROR')">
							<xsl:call-template name="error_message">
								<xsl:with-param name="message" select="$express_file_ok"/>
								<xsl:with-param name="inline" select="'no'"/>
							</xsl:call-template>
							<xsl:value-of select="$xref_list"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="l_schema_node" select="document(string($express_file_to_read))//express/schema"/>
							<xsl:variable name="l2_xref_list">
								<xsl:call-template name="get_objects_in_schema">
									<xsl:with-param name="xref_list" select="$xref_list"/>
		              <xsl:with-param name="object_nodes" select="$l_schema_node/entity|$l_schema_node/type|		$l_schema_node/subtype.constraint|$l_schema_node/function|$l_schema_node/rule|$l_schema_node/procedure|		$l_schema_node/constant"/>
		            </xsl:call-template>
							</xsl:variable>
					    <xsl:variable name="if_schema" select="concat('|',$l_schema_node/interface/@schema)"/>
							<xsl:choose>
								<xsl:when test="$l_schema_node/interface[not(contains($l2_xref_list,$if_schema))]">
									<xsl:call-template name="build_interface_xref_list">
										<xsl:with-param name="interfaces" select="$l_schema_node/interface"/>
										<xsl:with-param name="xref_list" select="$l2_xref_list"/>
										<xsl:with-param name="indent" select="concat($indent,' ')"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$l2_xref_list"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$remaining_interfaces">
						<xsl:call-template name="build_interface_xref_list">
							<xsl:with-param name="interfaces" select="$remaining_interfaces"/>
							<xsl:with-param name="indent" select="concat($indent,' ')"/>
							<xsl:with-param name="xref_list" select="$l1_xref_list"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$l1_xref_list"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$xref_list"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="express_file_to_read">
		<xsl:param name="schema_name"/>
		<xsl:variable name="data_path">
			<xsl:value-of select="'../../data'"/>
		</xsl:variable>
		<xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
		<xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
		<xsl:variable name="schema_name_tmp" select="concat(translate($schema_name,$UPPER, $LOWER),';')"/>
		<xsl:variable name="filepath">
			<xsl:choose>
				<xsl:when test="contains($schema_name_tmp,'_mim;')">
					<xsl:value-of select="concat($data_path,'/modules/',substring-before($schema_name_tmp,'_mim;'), '/mim.xml')"/>
				</xsl:when>
				<xsl:when test="contains($schema_name_tmp,'_arm;')">
					<xsl:value-of select="concat($data_path,'/modules/',substring-before($schema_name_tmp,'_arm;'), '/arm.xml')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat($data_path,'/resources/',$schema_name,'/',$schema_name,'.xml')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$filepath"/>
	</xsl:template>
	
	<xsl:template name="check_express_file_to_read">
		<xsl:param name="schema_name"/>
		<xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
		<xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
		<xsl:variable name="schema_name_tmp" select="translate($schema_name,$UPPER, $LOWER)"/>
		<xsl:variable name="module_name">
			<xsl:call-template name="module_name">
				<xsl:with-param name="module" select="$schema_name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="ret_val">
			<xsl:choose>
				<xsl:when test="contains($schema_name_tmp,'_mim')">
					<xsl:choose>
						<xsl:when test="document('../../repository_index.xml')/repository_index/modules/module[@name=$module_name]"/>
						<xsl:otherwise>
							<xsl:value-of select="concat('ERROR el1: ', $module_name, ' does not exist as a module or resource')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="contains($schema_name_tmp,'_arm')">
					<xsl:choose>
						<xsl:when test="document('../../repository_index.xml')/repository_index/modules/module[@name=$module_name]"/>
						<xsl:otherwise>
							<xsl:value-of select="concat('ERROR el2: ', $module_name, ' does not exist as a module or resource')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="document('../../repository_index.xml')/repository_index/resources/resource[@name=$schema_name_tmp]"/>
						<xsl:otherwise>
							<xsl:value-of select="concat('ERROR el3: ', $module_name, ' does not exist as a module or resource')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$ret_val"/>
	</xsl:template>
	
	<xsl:template name="build_resource_xref_list">
		<xsl:call-template name="build_resource_xref_list_rec">
			<xsl:with-param name="resources" select="document('../../repository_index.xml')/repository_index/resources/resource"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="build_resource_xref_list_rec">
		<xsl:param name="resources"/>
		<xsl:param name="xref_list" select="'|'"/>
		<xsl:variable name="first_resource" select="$resources[1]"/>
		<xsl:variable name="remaining_resources" select="$resources[position()!=1]"/>
		<xsl:variable name="express_file" select="concat('../../data/resources/', $first_resource/@name,'/',$first_resource/@name,'.xml')"/>
		<xsl:variable name="object_nodes" select="document($express_file)/express/schema/entity|/express/schema/type|/express/schema/subtype.constraint|/express/schema/function|/express/schema/procedure|/express/schema/rule|/express/schema/constant"/>
		<xsl:choose>
			<xsl:when test="$remaining_resources">
				<xsl:variable name="l_xref_list">
					<xsl:call-template name="get_objects_in_schema">
						<xsl:with-param name="object_nodes" select="$object_nodes"/>
						<xsl:with-param name="xref_list" select="$xref_list"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:call-template name="build_resource_xref_list_rec">
					<xsl:with-param name="resources" select="$remaining_resources"/>
					<xsl:with-param name="xref_list" select="$l_xref_list"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="get_objects_in_schema">
					<xsl:with-param name="object_nodes" select="$object_nodes"/>
					<xsl:with-param name="xref_list" select="$xref_list"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>