<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
     $Id: $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="../sect_4_express.xsl"/>
	<xsl:import href="express_link.xsl"/> 
  	<xsl:import href="express_description.xsl"/>
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

</xsl:stylesheet>
