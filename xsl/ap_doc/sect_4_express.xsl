<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
     $Id: sect_4_express.xsl,v 1.3 2002/10/08 10:19:07 mikeward Exp $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="../sect_4_express.xsl"/>
	<xsl:import href="express_link.xsl"/> 
  	<xsl:import href="express_description.xsl"/>
	<xsl:import href="projmg/issues.xsl"/>
	
	<!-- xsl:variable name="global_xref_list">
		<xsl:choose>
			<xsl:when test="/module_clause">
				<xsl:variable name="ap_module_dir">
					<xsl:call-template name="ap_module_directory">
            					<xsl:with-param name="application_protocol" select="/module_clause/@directory"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="express_xml" select="concat($ap_module_dir,'/arm.xml')"/>
				<xsl:call-template name="build_xref_list">
					<xsl:with-param name="express" select="document($express_xml)/express"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="/module">
				<xsl:variable name="ap_module_dir">
					<xsl:call-template name="ap_module_directory">
						<xsl:with-param name="application_protocol" select="/module/@name"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="express_xml" select="concat($ap_module_dir,'/arm.xml')"/>
				<xsl:call-template name="build_xref_list">
					<xsl:with-param name="express" select="document($express_xml)/express"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="relative_root" select="'../../../../'"/ -->
	
	<xsl:template match="entity">
	
		<xsl:variable name="schema_name" select="../@name"/>
		<xsl:variable name="clause_number">
			<xsl:call-template name="express_clause_number">
				<xsl:with-param name="clause" select="'entity'"/>
				<xsl:with-param name="schema_name" select="$schema_name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="position()=1">
			<xsl:variable name="clause_header">
				<xsl:choose>
					<xsl:when test="contains($schema_name,'_arm')">
						<xsl:value-of select="concat($clause_number, ' ARM entity definitions')"/>
					</xsl:when>
					<xsl:when test="contains($schema_name,'_mim')">
						<xsl:value-of select="concat($clause_number, ' MIM entity definitions')"/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="clause_intro">
				<xsl:choose>
					<xsl:when test="substring($schema_name, string-length($schema_name)-3)= '_arm'">
						This subclause specifies the application entities for this application protocol. 
						Each application entity is an atomic element that embodies a unique application concept 
						and contains attributes specifying the data elements of the entity. The application 
						entities and their definitions are specified below.
					</xsl:when>
					<xsl:when test="contains($schema_name,'_mim')">
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<h3>
				<a name="entities">
					<xsl:value-of select="$clause_header"/>
				</a>
			</h3>
			<xsl:value-of select="$clause_intro"/>
		</xsl:if>
		<xsl:variable name="aname">
			<xsl:call-template name="express_a_name">
				<xsl:with-param name="section1" select="$schema_name"/>
				<xsl:with-param name="section2" select="@name"/>
			</xsl:call-template>
		</xsl:variable>
		<h3>
			<a name="{$aname}">
				<xsl:value-of select="concat($clause_number,'.',position(),' ',@name)"/>
			</a>
			<xsl:apply-templates select="." mode="expressg_icon"/>
			<xsl:if test="substring($schema_name, string-length($schema_name)-3)='_arm'">
				<xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>
				<xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
				<xsl:variable name="ae_map_aname" select="translate(concat('aeentity',@name),$UPPER,$LOWER)"/>
				<xsl:variable name="maphref" select="concat('./5_mapping',$FILE_EXT,'#',$ae_map_aname)"/>
				<a href="{$maphref}">
					<img align="middle" border="0" alt="Mapping table" src="../../../../images/mapping.gif"/>
				</a>
			</xsl:if>
		</h3>
		<xsl:choose>
			<xsl:when test="substring($schema_name, string-length($schema_name)-3)= '_arm'">
				<xsl:call-template name="check_arm_entity_name">
					<xsl:with-param name="entity_name" select="@name"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="check_mim_entity_name">
					<xsl:with-param name="entity_name" select="@name"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:call-template name="output_external_description">
			<xsl:with-param name="schema" select="../@name"/>
			<xsl:with-param name="entity" select="@name"/>
		</xsl:call-template>
		<p>
			<xsl:choose>
				<xsl:when test="string-length(./description)>0">
					<xsl:apply-templates select="./description"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="external_description">
						<xsl:call-template name="check_external_description">
							<xsl:with-param name="schema" select="../@name"/>
							<xsl:with-param name="entity" select="@name"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:if test="$external_description='false'">
						<xsl:call-template name="error_message">
							<xsl:with-param name="message" select="concat('Error e4: No description provided for ',@name)"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</p>
		<!-- xsl:call-template name="output_express_issue">
			<xsl:with-param name="schema" select="../@name"/>
			<xsl:with-param name="entity" select="./@name"/>
		</xsl:call-template -->
		<p>
			<u>
				EXPRESS specification:
			</u>
		</p>
		<p>
			<code>
				*)
				<br/>
				ENTITY 
				<xsl:value-of select="@name"/>
				<xsl:call-template name="abstract.entity"/>
				<xsl:call-template name="super.expression-code"/>
				<xsl:call-template name="supertypes-code"/>
				<xsl:text>
					;
				</xsl:text>
				<br/>
				<xsl:apply-templates select="./explicit" mode="code"/>
				<xsl:apply-templates select="./derived" mode="code"/>
				<xsl:apply-templates select="./inverse" mode="code"/>
				<xsl:apply-templates select="./unique" mode="code"/>
				<xsl:apply-templates select="./where[@expression]" mode="code"/>
				END_ENTITY;
				<br/>
				(*
			</code>
		</p>
		<xsl:apply-templates select="./explicit" mode="description"/>
		<xsl:apply-templates select="./derived" mode="description"/>
		<xsl:apply-templates select="./inverse" mode="description"/>
		<xsl:apply-templates select="./unique" mode="description"/>
		<xsl:call-template name="output_where_formal"/>
		<xsl:call-template name="output_where_informal"/>
	</xsl:template>

	
	<xsl:template match="interface" mode="source">
		<xsl:variable name="module" select="string(@schema)"/>
		<xsl:choose>
			<xsl:when test="contains($module,'_arm') or contains($module,'_mim')">
				<xsl:variable name="module_ok">
					<xsl:call-template name="check_module_exists">
						<xsl:with-param name="module" select="$module"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$module_ok='true'">
						<xsl:variable name="ap_mod_dir">
							<xsl:call-template name="ap_module_directory">
								<xsl:with-param name="application_protocol" select="$module"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="part">
							<xsl:value-of select="document(concat($ap_mod_dir,'/module.xml'))/module/@part"/>
						</xsl:variable>
						<xsl:variable name="status">
							<xsl:value-of select="document(concat($ap_mod_dir,'/module.xml'))/module/@status"/>
						</xsl:variable>
						<xsl:value-of select="concat('ISO/',$status,'&#160;10303-',$part)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="error_message">
							<xsl:with-param name="message">
								<xsl:value-of select="concat('Error IF-1: The module ', $module,' cannot be found in repository_index.xml ')"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="resource_ok">
						<xsl:call-template name="check_resource_exists">
							<xsl:with-param name="schema" select="$module"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="$resource_ok='true'">
							<xsl:variable name="reference">
								<xsl:value-of select="document(concat('../../data/resources/',$module,'/',$module,'.xml'))/express/	@reference"/>
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="string-length($reference)>0">
									<xsl:value-of select="$reference"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="error_message">
										<xsl:with-param name="message">
											<xsl:value-of select="concat('Error IF-3: The reference parameter for ', $module,' has not been 		specified 	')"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="error_message">
							<xsl:with-param name="message" select="concat('Error IF-2: ',$resource_ok)"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	
	<xsl:template name="interface_notes">
		<xsl:param name="schema_node"/>
		<p class="note">
			<small>
				NOTE&#160;1&#160;&#160;
				The schemas referenced above are specified in the following part of ISO 10303:
			</small>
		</p>
		<blockquote>
			<table>
				<xsl:for-each select="$schema_node/interface">
					<xsl:variable name="schema_name" select="./@schema"/>
					<tr>
						<td width="266">
							<b>
								<small>
									<xsl:value-of select="$schema_name"/>
								</small>
							</b>
						</td>
						<td width="127">
							<small>
								<xsl:apply-templates select="." mode="source"/>
							</small>
						</td>
					</tr>
				</xsl:for-each>
			</table>
		</blockquote>
		<p class="note">
			<small>
				NOTE&#160;2&#160;&#160;
				<xsl:variable name="ap_module_dir">
					<xsl:call-template name="ap_module_directory">
						<xsl:with-param name="application_protocol" select="$schema_node/@name"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="module_file" select="concat($ap_module_dir,'/module.xml')"/>
				<xsl:choose>
					<xsl:when test="contains($schema_node/@name,'_arm')">
						<xsl:variable name="penultimate" select="count(document($module_file)/module/arm/express-g/imgfile)-1"/>
						See annex
						<a href="f_arm_expg{$FILE_EXT}">
							F
						</a>, 
						<xsl:choose>
							<xsl:when test="count(document($module_file)/module/arm/express-g/imgfile)=1">
								figure
							</xsl:when>
							<xsl:otherwise>
								figures
							</xsl:otherwise>
						</xsl:choose>
						<xsl:for-each select="document($module_file)/module/arm/express-g/imgfile">
							<xsl:variable name="imgfile">
								<xsl:call-template name="set_file_ext">
									<xsl:with-param name="filename" select="concat('../',@file)"/>
								</xsl:call-template>
							</xsl:variable>
							<a href="{$imgfile}">
								<xsl:value-of select="concat('F.',position())"/>
							</a>
							<xsl:if test="position()!=last()">
								<xsl:choose>
									<xsl:when test="position()!=$penultimate">, </xsl:when>
									<xsl:otherwise>and </xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</xsl:for-each>
						for a graphical representation of this schema.
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="penultimate" select="count(document($module_file)/module/mim/express-g/imgfile)-1"/>
						See annex 
						<a href="d_mim_expg{$FILE_EXT}">D</a>, 
						<xsl:choose>
							<xsl:when test="count(document($module_file)/module/mim/express-g/imgfile)=1">
								figure
							</xsl:when>
							<xsl:otherwise>
								figures
							</xsl:otherwise>
						</xsl:choose>
						<xsl:for-each select="document($module_file)/module/mim/express-g/imgfile">
							<xsl:variable name="imgfile">
								<xsl:call-template name="set_file_ext">
									<xsl:with-param name="filename" select="concat('../',@file)"/>
								</xsl:call-template>
							</xsl:variable>
							<a href="{$imgfile}">
								<xsl:value-of select="concat('D.',position())"/>
							</a>
							<xsl:if test="position()!=last()">
								<xsl:choose>
									<xsl:when test="position()!=$penultimate">, </xsl:when>
									<xsl:otherwise>and </xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</xsl:for-each>
						for a graphical representation of this schema.
					</xsl:otherwise>
				</xsl:choose>
			</small>
		</p>
	</xsl:template>
	
	
	
	<xsl:template name="express_clause_present">
		<xsl:param name="clause"/>
		<xsl:param name="schema_name"/>
		<xsl:variable name="ap_module_dir">
			<xsl:call-template name="ap_module_directory">
				<xsl:with-param name="application_protocol" select="$schema_name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="xml_file">
			<xsl:choose>
				<xsl:when test="contains($schema_name,'_arm')">
					<xsl:value-of select="concat($ap_module_dir,'/arm.xml')"/>
				</xsl:when>
				<xsl:when test="contains($schema_name,'_mim')">
					<xsl:value-of select="concat($ap_module_dir,'/mim.xml')"/>
				</xsl:when>
				<xsl:otherwise>
					1000
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="clause_present">
			<xsl:choose>
				<xsl:when test="$clause='interface'">
					<xsl:choose>
						<xsl:when test="document(string($xml_file))/express/schema/interface">
							<xsl:call-template name="express_clause_number">
								<xsl:with-param name="clause" select="'interface'"/>
								<xsl:with-param name="schema_name" select="$schema_name"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							0
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$clause='constant'">
					<xsl:choose>
						<xsl:when test="document(string($xml_file))/express/schema/constant">
							<xsl:call-template name="express_clause_number">
								<xsl:with-param name="clause" select="'constant'"/>
								<xsl:with-param name="schema_name" select="$schema_name"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							0
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				
				<xsl:when test="$clause='type'">
					<xsl:choose>
						<xsl:when test="document(string($xml_file))/express/schema/type">
							<xsl:call-template name="express_clause_number">
								<xsl:with-param name="clause" select="'type'"/>
								<xsl:with-param name="schema_name" select="$schema_name"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							0
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$clause='entity'">#
					<xsl:choose>
						<xsl:when test="document(string($xml_file))/express/schema/entity">
							<xsl:call-template name="express_clause_number">
								<xsl:with-param name="clause" select="'entity'"/>
								<xsl:with-param name="schema_name" select="$schema_name"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							0
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$clause='subtype.constraint'">
					<xsl:choose>
						<xsl:when test="document(string($xml_file))/express/schema/subtype.constraint">
							<xsl:call-template name="express_clause_number">
								<xsl:with-param name="clause" select="'subtype.constraint'"/>
								<xsl:with-param name="schema_name" select="$schema_name"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							0
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$clause='function'">
					<xsl:choose>
						<xsl:when test="document(string($xml_file))/express/schema/function">
							<xsl:call-template name="express_clause_number">
								<xsl:with-param name="clause" select="'function'"/>
								<xsl:with-param name="schema_name" select="$schema_name"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							0
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$clause='rule'">
					<xsl:choose>
						<xsl:when test="document(string($xml_file))/express/schema/rule">
							<xsl:call-template name="express_clause_number">
								<xsl:with-param name="clause" select="'rule'"/>
								<xsl:with-param name="schema_name" select="$schema_name"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							0
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$clause='procedure'">
					<xsl:choose>
						<xsl:when test="document(string($xml_file))/express/schema/procedure">
							<xsl:call-template name="express_clause_number">
								<xsl:with-param name="clause" select="'procedure'"/>
								<xsl:with-param name="schema_name" select="$schema_name"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							0
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$clause='imported_constant'">
					<xsl:choose>
						<xsl:when test="document(string($xml_file))/express/schema/interface/described.item[@kind='CONSTANT']">
							<xsl:call-template name="express_clause_number">
								<xsl:with-param name="clause" select="'imported_constant'"/>
								<xsl:with-param name="schema_name" select="$schema_name"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							0
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				
				<xsl:when test="$clause='imported_type'">
					<xsl:choose>
						<xsl:when test="document(string($xml_file))/express/schema/interface/described.item[@kind='TYPE']">
							<xsl:call-template name="express_clause_number">
								<xsl:with-param name="clause" select="'imported_type'"/>
								<xsl:with-param name="schema_name" select="$schema_name"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							0
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				
				<xsl:when test="$clause='imported_entity'">
					<xsl:choose>
						<xsl:when test="document(string($xml_file))/express/schema/interface/described.item[@kind='ENTITY']">
							<xsl:call-template name="express_clause_number">
								<xsl:with-param name="clause" select="'imported_entity'"/>
								<xsl:with-param name="schema_name" select="$schema_name"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							0
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				
				<xsl:when test="$clause='imported_function'">
					<xsl:choose>
						<xsl:when test="document(string($xml_file))/express/schema/interface/described.item[@kind='FUNCTION']">
							<xsl:call-template name="express_clause_number">
								<xsl:with-param name="clause" select="'imported_function'"/>
								<xsl:with-param name="schema_name" select="$schema_name"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							0
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				
				<xsl:when test="$clause='imported_rule'">
					<xsl:choose>
						<xsl:when test="document(string($xml_file))/express/schema/interface/described.item[@kind='RULE']">
							<xsl:call-template name="express_clause_number">
								<xsl:with-param name="clause" select="'imported_rule'"/>
								<xsl:with-param name="schema_name" select="$schema_name"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							0
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				
				<xsl:when test="$clause='imported_procedure'">
					<xsl:choose>
						<xsl:when test="document(string($xml_file))/express/schema/interface/described.item[@kind='PROCEDURE']">
							<xsl:call-template name="express_clause_number">
								<xsl:with-param name="clause" select="'imported_procedure'"/>
								<xsl:with-param name="schema_name" select="$schema_name"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							0
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$clause_present"/>
	</xsl:template>
	


</xsl:stylesheet>
