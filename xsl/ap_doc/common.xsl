<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
     $Id: common.xsl,v 1.11 2003/03/03 17:15:13 goset1 Exp $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="../common.xsl"/>
	<xsl:import href="file_ext.xsl"/>
	<xsl:import href="parameters.xsl"/>
	
	<xsl:template name="ap_module_directory">
		<xsl:param name="application_protocol"/>
		<xsl:variable name="mod_dir">
			<xsl:call-template name="module_name">
				<xsl:with-param name="module" select="$application_protocol"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="concat('../../data/modules/', $mod_dir)"/>
	</xsl:template>
	
	<xsl:template name="application_protocol_directory">
		<xsl:param name="application_protocol"/>
		<xsl:variable name="ap_dir">
			<xsl:call-template name="module_name">
				<xsl:with-param name="module" select="$application_protocol"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="concat('../../data/application_protocols/', $ap_dir)"/>
	</xsl:template>
	
	<xsl:template name="check_application_protocol_exists">
		<xsl:param name="application_protocol"/>
		<xsl:variable name="application_protocol_name">
			<xsl:call-template name="module_name">
				<xsl:with-param name="module" select="$application_protocol"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="ret_val">
			<xsl:choose>
				<xsl:when test="document('../../repository_index.xml')/repository_index/modules/module[@name=$application_protocol_name]">
					<xsl:value-of select="'true'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat(' The application_protocol ', $application_protocol_name, ' is not identified as a application_protocol module in repository_index.xml')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$ret_val"/>
	</xsl:template>

	<xsl:template name="idef0_icon">
		<xsl:param name="schema"/>
		<xsl:param name="application_protocol_root" select="'..'"/>
		
		<xsl:variable name="application_protocol_dir">
			<xsl:call-template name="application_protocol_directory">
				<xsl:with-param name="application_protocol" select="$schema"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="href_aam">
			<xsl:value-of select="concat($application_protocol_root,'/aamidef01',$FILE_EXT)"/>
		</xsl:variable>
		&#160;&#160;
		<a href="{$href_aam}">
			<img align="middle" border="0" alt="AAM" src="{$application_protocol_root}/../../../images/ap_doc/aam.gif"/>
		</a>
	</xsl:template>
	
	<xsl:template match="module" mode="TOCbannertitle"/>

	<xsl:template match="application_protocol" mode="TOCbannertitle">
		<xsl:param name="selected"/>
		<xsl:param name="module_root" select="'..'"/>

		<xsl:call-template name="rcs_output">
			<xsl:with-param name="module" select="@module_name"/>
			<xsl:with-param name="module_root" select="$module_root"/>
		</xsl:call-template>

		<TABLE cellspacing="0" border="0" width="100%">
			<tr>
				<td>
					<xsl:call-template name="output_menubar">
						<xsl:with-param name="module_root" select="$module_root"/>
						<xsl:with-param name="module_name" select="@name"/>
					</xsl:call-template>
				</td>
			</tr>
			<tr>
				<td valign="MIDDLE">
					<B>Application protocol:
						<xsl:call-template name="protocol_display_name">
							<xsl:with-param name="application_protocol" select="@name"/>
						</xsl:call-template>
					</B>
				</td>
				<td valign="MIDDLE" align="RIGHT">
					<xsl:variable name="stdnumber">
						<xsl:call-template name="get_protocol_pageheader">
							<xsl:with-param name="application_protocol" select="."/>
						</xsl:call-template>
					</xsl:variable>
					<b>
						<xsl:value-of select="$stdnumber"/>
						<xsl:variable name="status" select="string(@status)"/>
						<xsl:if test="$status='TS' or $status='DIS' or $status='IS'">
							<br/>
							&#169; ISO
						</xsl:if>
					</b>
				</td>
			</tr>
		</TABLE>
	</xsl:template>
	
	<xsl:template name="rcs_output">
		<xsl:param name="module" select="@name"/>
		<xsl:param name="module_root" select="'..'"/>
		<xsl:variable name="icon_path" select="concat($module_root,'/../../../images/')"/>
		<xsl:if test="$output_rcs='YES'">
			<xsl:variable name="ap_mod_dir">
				<xsl:call-template name="ap_module_directory">
					<xsl:with-param name="application_protocol" select="$module"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="fldr_gif" select="concat($icon_path,'folder.gif')"/>
			<xsl:variable name="proj_gif" select="concat($icon_path,'project.gif')"/>
			<table cellspacing="0" border="0">
				<xsl:variable name="module_file" select="concat($ap_mod_dir,'/module.xml')"/>
				<xsl:variable name="module_date" select="translate(document($module_file)/module/@rcs.date,'$','')"/>
				<xsl:variable name="module_rev" select="translate(document($module_file)/module/@rcs.revision,'$','')"/>
				<tr>
					<td>
						<p class="rcs">
							<a href="{$module_root}">
								<img alt="module folder" border="0" align="middle" src="{$fldr_gif}"/>
							</a>&#160;
							<xsl:if test="@development.folder">
								<xsl:variable name="prjmg_href" select="concat($module_root,'/',@development.folder,'/projmg',$FILE_EXT)"/>
								<a href="{$prjmg_href}">
									<img alt="project management summary" border="0" align="middle" src="{$proj_gif}"/>
								</a>&#160;
								<xsl:variable name="issue_href" select="concat($module_root,'/',@development.folder,'/issues',$FILE_EXT)"/>
								<xsl:variable name="issues_file" select="concat($ap_mod_dir,'/',@development.folder,'/issues.xml')"/>
								<xsl:variable name="open_issues" select="count(document($issues_file)/issues/issue[@status!='closed'])"/>
								<xsl:variable name="total_issues" select="count(document($issues_file)/issues/issue)"/>
								<xsl:variable name="issue_gif">
									<xsl:choose>
										<xsl:when test="$open_issues>0">
											<xsl:value-of select="concat($icon_path,'issues.gif')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="concat($icon_path,'closed.gif')"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:if test="$total_issues > 0">
									<a href="{$issue_href}">
										<img alt="issues" border="0" align="middle" src="{$issue_gif}"/>
										<small>
											[
											<xsl:value-of select="$open_issues"/>
											/
											<xsl:value-of select="$total_issues"/>
											]
										</small>
									</a>
									&#160;
								</xsl:if>
							</xsl:if>
						</p>
					</td>
					<td>
						<font size="-2">
							<p class="rcs">
								<xsl:value-of select=" 'application_protocol.xml' "/>
							</p>
						</font>
					</td>
					<td>
						<font size="-2">
							<p class="rcs">
								<xsl:value-of select="concat('(',$module_date,' ',$module_rev,')')"/>
							</p>
						</font>
					</td>
					<td>&#160;&#160;</td>
					<xsl:variable name="arm_file" select="concat($ap_mod_dir,'/arm.xml')"/>
					<xsl:variable name="arm_date" select="translate(document($arm_file)/express/@rcs.date,'$','')"/>
					<xsl:variable name="arm_rev" select="translate(document($arm_file)/express/@rcs.revision,'$','')"/>
					<td>
						<font size="-2">
							<p class="rcs">
								<xsl:value-of select="'arm.xml'"/>
							</p>
						</font>
					</td>
					<td>
						<font size="-2">
							<p class="rcs">
								<xsl:value-of select="concat('(', $arm_date,' ',$arm_rev,')')"/>
							</p>
						</font>
					</td>
					<td>&#160;&#160;</td>
					<xsl:variable name="mim_file" select="concat($ap_mod_dir,'/mim.xml')"/>
					<xsl:variable name="mim_date" select="translate(document($mim_file)/express/@rcs.date,'$','')"/>
					<xsl:variable name="mim_rev" select="translate(document($mim_file)/express/@rcs.revision,'$','')"/>
					<td>
						<font size="-2">
							<p class="rcs">
								<xsl:value-of select="'mim.xml'"/>
							</p>
						</font>
					</td>
					<td>
						<font size="-2">
							<p class="rcs">
								<xsl:value-of select="concat('(', $mim_date, ' ', $mim_rev, ')')"/>
							</p>
						</font>
					</td>
				</tr>
			</table>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="img">
  <xsl:param name="alt"/>

  <xsl:variable name="src">
    <xsl:choose>
      <xsl:when test="name(..)='imgfile.content'">
        <xsl:value-of select="@src"/>
      </xsl:when>
<xsl:when test="name(..)='ap.imgfile.content'">
        <xsl:value-of select="@src"/>
      </xsl:when>

      <xsl:otherwise>
        <xsl:value-of select="concat('../',@src)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="alt1">
    <xsl:choose>
      <xsl:when test="string-length($alt)>0">
        <xsl:value-of select="$alt"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@src"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <div align="center">
    <xsl:choose>
      <xsl:when test="img.area">
        <IMG src="{$src}" border="0" usemap="#map" alt="{$alt1}">
          <MAP NAME="map">
            <xsl:apply-templates select="img.area"/>
          </MAP>
        </IMG>        
      </xsl:when>
      <xsl:otherwise>
        <IMG src="{$src}" border="0" alt="{$alt1}"/>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>


	<xsl:template match="entity|type|schema|constant" mode="expressg_icon">
		<xsl:param name="original_schema"/>
		<xsl:variable name="schema">
			<xsl:choose>
				<xsl:when test="$original_schema">
					<xsl:value-of select="$original_schema"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="../@name"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="ap_module_dir">
			<xsl:call-template name="ap_module_directory">
				<xsl:with-param name="application_protocol" select="$schema"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="module_name">
			<xsl:call-template name="module_name">
				<xsl:with-param name="module" select="$schema"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="href_expg">
			<xsl:choose>
				<xsl:when test="substring($schema,string-length($schema)-3)='_arm'">
					<xsl:choose>
						<xsl:when test="./graphic.element/@page">
							<xsl:value-of select="concat('../../../modules/', $module_name, '/armexpg',./graphic.element/@page,$FILE_EXT)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat('../../../modules/',$module_name,'/armexpg1',$FILE_EXT)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="substring($schema, string-length($schema)-3)='_mim'">
					<xsl:choose>
						<xsl:when test="./graphic.element/@page">
							<xsl:value-of select="concat('../../../modules/',$module_name,'/mimexpg',./graphic.element/@page,$FILE_EXT)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat('../../../modules/',$module_name,'/mimexpg1',$FILE_EXT)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		&#160;&#160;
		<a href="{$href_expg}">
			<img align="middle" border="0" alt="EXPRESS-G" src="../../../../images/expg.gif"/>
		</a>
	</xsl:template>



	<xsl:template name="ap_expressg_icon">
		<xsl:param name="schema"/>
		<xsl:param name="entity"/>
		<xsl:param name="module_root" select="'..'"/>
		<xsl:param name="mod"/>
		<xsl:variable name="href_expg">
			<xsl:choose>
				<xsl:when test="$entity">
					<xsl:choose>
						<xsl:when test="substring($schema,string-length($schema)-3)='_arm'">
							<xsl:choose>
								<xsl:when test="./graphic.element/@page">
									<xsl:value-of select="concat('../../modules/', $mod, '/armexpg',./graphic.element/@page,$FILE_EXT)"/>                  
			      </xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat('../../modules/', $mod, '/armexpg1', $FILE_EXT)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="substring($schema, string-length($schema)-3)='_mim'">
							<xsl:choose>
								<xsl:when test="./graphic.element/@page">
									<xsl:value-of select="concat('../../modules/', $mod, '/mimexpg',./graphic.element/@page,$FILE_EXT)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat('../../modules/', $mod, '/mimexpg1', $FILE_EXT)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="substring($schema, string-length($schema)-3)='_arm'">
							<xsl:value-of select="concat	($module_root,'/../../modules/', $mod, '/armexpg1', $FILE_EXT)"/>
						</xsl:when>
						<xsl:when test="substring($schema, string-length($schema)-3)='_mim'">
							<xsl:value-of select="concat	($module_root,'/../../modules/', $mod, '/mimexpg1', $FILE_EXT)"/>
						</xsl:when>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		&#160;&#160;
		<a href="{$href_expg}">
			<img align="middle" border="0" alt="EXPRESS-G" src="{$module_root}/../../../images/expg.gif"/>
		</a>
	</xsl:template>

</xsl:stylesheet>


