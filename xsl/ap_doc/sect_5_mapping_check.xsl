<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
	$Id:$
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:saxon="http://icl.com/saxon" extension-element-prefixes="msxsl saxon" version="1.0">

	<xsl:import href="../sect_5_mapping_check.xsl"/>
	
	<xsl:template match="mapping_table" mode="check_all_arm_mapped">
		<xsl:variable name="ap_module_dir">
			<xsl:call-template name="ap_module_directory">
				<xsl:with-param name="application_protocol" select="/module/@name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="ae_nodes" select="./ae"/>
		<xsl:variable name="aa_nodes" select="./ae//aa"/>
		<xsl:for-each select="document(concat($ap_module_dir,'/arm.xml'))/express/schema/entity">
			<xsl:variable name="entity" select="@name"/>
			<xsl:choose>
				<xsl:when test="not($ae_nodes[@entity=$entity])">
        				<xsl:call-template name="error_message">
						<xsl:with-param name="message" select="concat('Error mc5: the entity ',$entity,' has not been mapped.')"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="./explicit">
						<xsl:choose>
							<xsl:when test="./redeclaration">
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="arm_attr" select="@name"/>
								<xsl:if test="not($aa_nodes[@attribute=$arm_attr])">
									<xsl:call-template name="error_message">
										<xsl:with-param name="message" select="concat('Error mc6: the attribute ', $entity,'.',$arm_attr, ' has not been mapped.')"/>
									</xsl:call-template>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="aa" mode="check_valid_attribute">
		<xsl:if test="$check_mapping='yes'">
			<xsl:variable name="arm_entity">
				<xsl:choose>
					<xsl:when test="@inherited_from_module">
						<xsl:value-of select="@inherited_from_entity"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="../@entity"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="arm_attr" select="@attribute"/>
			<xsl:variable name="ap_module_dir">
				<xsl:choose>
					<xsl:when test="../@original_module">
						<xsl:call-template name="ap_module_directory">
							<xsl:with-param name="application_protocol" select="../@original_module"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="@inherited_from_module">
						<xsl:call-template name="ap_module_directory">
							<xsl:with-param name="application_protocol" select="@inherited_from_module"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="ap_module_directory">
							<xsl:with-param name="application_protocol" select="../../../../module/@name"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="arm_xml" select="concat($ap_module_dir,'/arm.xml')"/>
			<xsl:choose>
				<xsl:when test="contains(@attribute,'(as')">
					<xsl:call-template name="error_message">
						<xsl:with-param name="message">
							<xsl:value-of select="concat('Error m2: ', @attribute, ' should be the name of an ARM entity. Use &lt;aa attribute=&#034;&#034; assertion_to=&#034;&#034;&gt; ')"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="contains($arm_attr,'SELF')">
					<xsl:variable name="redec_attr">
						<xsl:call-template name="get_last_section">
							<xsl:with-param name="path" select="@attribute"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:if test="not(document($arm_xml)/express/schema/entity[@name=$arm_entity]/explicit[@name=$redec_attr])">
						<xsl:call-template name="error_message">
							<xsl:with-param name="message" select="concat('Error m4: The attribute ', ../@entity,'.',@attribute, ' does not exist in the arm as a redeclared attribute')"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:when>
				<xsl:when test="not(document($arm_xml)/express/schema/entity[@name=$arm_entity]/explicit[@name=$arm_attr])">
					<xsl:choose>
						<xsl:when test="@inherited_from_module">
							<xsl:call-template name="error_message">
								<xsl:with-param name="message" select="concat('Error m5: The attribute ', @inherited_from_module,'.',@attribute, ' specified as @inherited_from_module does not exist in the arm (',$arm_xml,') as an  attribute')"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="error_message">
								<xsl:with-param name="message" select="concat('Error m6: The attribute ', ../	@entity,'.',@attribute, ' does not exist in the arm (',$arm_xml,') as an explicit attribute')"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>

