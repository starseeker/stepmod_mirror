<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
     $Id: combined_repository_index.xsl,v 1.3 2002/10/08 10:20:08 mikeward Exp $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="../repository_index.xsl"/>
	<xsl:variable name="file_ref" select="/modules_index/@filename"/>
	<xsl:variable name="modules_index_file" select="document(/modules_index/@filename)"/>
	
	<xsl:template match="modules_index">
		<xsl:apply-templates select="$modules_index_file"/>
	</xsl:template>
	
	<xsl:template match="repository_index">
		<HTML>
			<HEAD>
				<TITLE>Module and Application Protocol repository</TITLE>
			</HEAD>
			<BODY>
				<table width="600">
					<tr>
						<td>
							<h2>
								<a name="alphatop">
									Alphabetical list of Modules
								</a>
							</h2>
						</td>
						<td>
							<h2>
								<a href="../../help/index.htm">
									Help
								</a>
							</h2>
						</td>
					</tr>
				</table>
				<xsl:variable name="module_mid_point" select="(count(./modules/module)+1) div 2"/>
				<blockquote>
					<table width="90%" cellspacing="0" cellpadding="4">
						<tr>
							<td valign="top">
								<xsl:apply-templates select="./modules/module" mode="col1">
									<xsl:with-param name="mid_point" select="$module_mid_point"/>
									<xsl:sort select="@name"/>
								</xsl:apply-templates>
							</td>
							<td valign="top">
								<xsl:apply-templates select="./modules/module" mode="col2">
									<xsl:with-param name="mid_point" select="$module_mid_point"/>
									<xsl:sort select="@name"/>
								</xsl:apply-templates>
							</td>
						</tr>
					</table>
				</blockquote>
				<h2>
					<a name="alphatop">
						Alphabetical list of Common Resource schemas
					</a>
				</h2>
				<xsl:variable name="resource_mid_point" select="(count(./resources/resource)+1) div 2"/>
				<blockquote>
					<table width="90%" cellspacing="0" cellpadding="4">
						<tr>
							<td valign="top">
								<xsl:apply-templates select="./resources/resource" mode="col1">
									<xsl:with-param name="mid_point" select="$resource_mid_point"/>
									<xsl:sort select="@name"/>
								</xsl:apply-templates>
							</td>
							<td valign="top">
								<xsl:apply-templates select="./resources/resource" mode="col2">
									<xsl:with-param name="mid_point" select="$resource_mid_point"/>
									<xsl:sort select="@name"/>
								</xsl:apply-templates>
							</td>
						</tr>
					</table>
				</blockquote>
				<xsl:variable name="ap_index_file" select="document('../../data/application_protocols/ap_index.xml')"/>
				<xsl:apply-templates select="$ap_index_file"/>
			</BODY>
		</HTML>
	</xsl:template>
	
	<xsl:template match="application_protocols">
		<h2>
			<a name="alphatop">
				Alphabetical list of Application Protocols
			</a>
		</h2>
		<xsl:variable name="application_protocol_mid_point" select="(count(./application_protocol)+1) div 2"/>
		<blockquote>
			<table width="90%" cellspacing="0" cellpadding="4">
				<tr>
					<td valign="top">
						<xsl:apply-templates select="./application_protocol" mode="col1">
							<xsl:with-param name="mid_point" select="$application_protocol_mid_point"/>
							<xsl:sort select="@name"/>
						</xsl:apply-templates>
					</td>
					<td valign="top">
						<xsl:apply-templates select="./application_protocol" mode="col2">
							<xsl:with-param name="mid_point" select="$application_protocol_mid_point"/>
							<xsl:sort select="@name"/>
						</xsl:apply-templates>
					</td>
				</tr>
			</table>
		</blockquote>
	</xsl:template>
	
	<xsl:template match="module" mode="output">
		<xsl:variable name="xref" select="concat('../modules/',@name,'/sys/introduction',$FILE_EXT)"/>
		<xsl:variable name="part" select="@part"/>
		<a href="{$xref}">
			<font size="-1">
				<b>
					<xsl:value-of select="@name"/>
					(
					<xsl:value-of select="$part"/>
					)
				</b>
			</font>
		</a>
		<xsl:variable name="xref4" select="concat('../modules/',@name,'/sys/4_info_reqs',$FILE_EXT)"/>
		<xsl:variable name="arm_expg" select="concat('../modules/',@name,'/armexpg1',$FILE_EXT)"/>
	  	<xsl:variable name="xref5" select="concat('../modules/',@name,'/sys/5_mim',$FILE_EXT)"/>
	 	<xsl:variable name="mim_expg" select="concat('../modules/',@name,'/mimexpg1',$FILE_EXT)"/>
		<xsl:variable name="mod_directory" select="concat('../modules/',@name)"/>
		<table cellspacing="0" cellpadding="1">
			<tr>
				<td>&#160;&#160;&#160;&#160;</td>
	   			<td>
					<font size="-2">
						<a href="{$xref4}">ARM</a>
					</font>
				</td>
				<td>
					<font size="-2">
						<a href="{$arm_expg}">ARM-G</a>
					</font>
				</td>
				<td>
					<font size="-2">
						<a href="{$xref5}">MIM</a>
					</font>
				</td>
				<td>
					<font size="-2">
						<a href="{$mim_expg}">MIM-G</a>
					</font>
				</td>
				<td>
					<font size="-2">
						<a href="{$mod_directory}">
							<img alt="module folder" border="0" align="middle" src="../../images/folder.gif"/>
						</a>
					</font>
				</td>
			</tr>
		</table>
	</xsl:template>
	
	<xsl:template match="module" mode="output_mod_part_nos">
		<xsl:variable name="xref" select="concat('../modules/',@name,'/sys/introduction',$FILE_EXT)"/>
		<xsl:variable name="part">
			<xsl:call-template name="get_module_part">
				<xsl:with-param name="module_name" select="@name"/>
			</xsl:call-template>
		</xsl:variable>
		<a href="{$xref}">
			<font size="-1">
				<b>
					<xsl:value-of select="@name"/>
					(
						<xsl:value-of select="$part"/>
					)
				</b>
			</font>
		</a>
		<xsl:variable name="xref4" select="concat('../modules/',@name,'/sys/4_info_reqs',$FILE_EXT)"/>
		<xsl:variable name="arm_expg" select="concat('../modules/',@name,'/armexpg1',$FILE_EXT)"/>
		<xsl:variable name="xref5" select="concat('../modules/',@name,'/sys/5_mim',$FILE_EXT)"/>
		<xsl:variable name="mim_expg" select="concat('../modules/',@name,'/mimexpg1',$FILE_EXT)"/>
		<xsl:variable name="mod_directory" select="concat('./data/modules/',@name)"/>
		<table cellspacing="0" cellpadding="1">
			<tr>
				<td>&#160;&#160;&#160;&#160;</td>
				<td>
					<font size="-2">
						<a href="{$xref4}">ARM</a>
					</font>
				</td>
				<td>
					<font size="-2">
						<a href="{$arm_expg}">ARM-G</a>
					</font>
				</td>
				<td>
					<font size="-2">
						<a href="{$xref5}">MIM</a>
					</font>
				</td>
				<td>
					<font size="-2">
						<a href="{$mim_expg}">MIM-G</a>
					</font>
				</td>
				<td>
					<font size="-2">
						<a href="{$mod_directory}">
							<img alt="module folder" border="0" align="middle" src="./images/folder.gif"/>
						</a>
					</font>
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template match="resource" mode="output">
		<xsl:variable name="xref" select="concat('../resources/',@name,'/',@name,$FILE_EXT)"/>
  		<a href="{$xref}">
  			<font size="-1">
				<b>
					<xsl:value-of select="@name"/>
				</b>
			</font>
		</a>
		<br/>
	</xsl:template>
	
	<xsl:template match="application_protocol" mode="col1">
		<xsl:param name="mid_point"/>
		<xsl:if test="not(position()>$mid_point)">
			<xsl:apply-templates select="." mode="output"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="application_protocol" mode="col2">
		<xsl:param name="mid_point"/>
		<xsl:if test="position()>$mid_point">
			<xsl:apply-templates select="."  mode="output"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="application_protocol" mode="output">
		<xsl:variable name="xref" select="concat('./',@name,'/sys/introduction',$FILE_EXT)"/>
		<xsl:variable name="part">
			<xsl:call-template name="get_application_protocol_part">
				<xsl:with-param name="application_protocol_name" select="@name"/>
			</xsl:call-template>
		</xsl:variable>
		<a href="{$xref}">
			<font size="-1">
				<b>
					<xsl:value-of select="@name"/>
						 (
					<xsl:value-of select="$part"/>
						)
				</b>
			</font>
		</a>
		<xsl:variable name="xref4" select="concat('./',@name,'/sys/4_info_reqs',$FILE_EXT)"/>
	  	<xsl:variable name="arm_expg" select="concat('../modules/',@name,'/armexpg1',$FILE_EXT)"/>
	  	<xsl:variable name="xref5" select="concat('../modules/',@name,'/sys/5_mim',$FILE_EXT)"/>
	  	<xsl:variable name="aim_expg" select="concat('../modules/',@name,'/mimexpg1',$FILE_EXT)"/>
		<xsl:variable name="aam" select="concat('./',@name,'/sys/annex_aam',$FILE_EXT)"/>
		<xsl:variable name="ap_directory" select="concat('./',@name)"/>
		<table cellspacing="0" cellpadding="1">
			<tr>
				<td>&#160;&#160;&#160;&#160;</td>
	   			<td>
					<font size="-2">
						<a href="{$xref4}">ARM</a>
					</font>
				</td>
				<td>
					<font size="-2">
						<a href="{$arm_expg}">ARM-G</a>
					</font>
				</td>
				<td>
					<font size="-2">
						<a href="{$xref5}">AIM</a>
					</font>
				</td>
				<td>
					<font size="-2">
						<a href="{$aim_expg}">AIM-G</a>
					</font>
				</td>
				<td>
					<font size="-2">
						<a href="{$aam}">AAM</a>
					</font>
				</td>

				<td>
					<font size="-2">
						<a href="{$ap_directory}">
							<img alt="application_protocol folder" border="0" align="middle" src="../../images/folder.gif"/>
						</a>
					</font>
				</td>
			</tr>
		</table>
	</xsl:template>
	
	<xsl:template name="get_module_part">
		<xsl:param name="module_name"/>
		<xsl:variable name="module_file" select="concat('../../data/modules/',$module_name,'/module.xml')"/>
		<xsl:variable name="module_node" select="document($module_file)/module[@name=$module_name]"/>
		<xsl:variable name="part" select="$module_node/@part"/>
		<xsl:value-of select="$part"/>
	</xsl:template>
	
	<xsl:template name="get_application_protocol_part">
		<xsl:value-of select="@part"/>
	</xsl:template>
</xsl:stylesheet>