<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!-- last edited mwd 2002-08-20 -->
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
				<xsl:with-param name="application_protocol" select="$application_protocol"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="concat('../../data/application_protocols/',$ap_dir)"/>
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
            <xsl:value-of
              select="concat(' The application_protocol ', $application_protocol_name,
                      ' is not identified as a application_protocol module in repository_index.xml')"/>
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
	
	<xsl:template match="application_protocol" mode="TOCbannertitle">
		<xsl:param name="selected"/>
		<xsl:param name="module_root" select="'..'"/>
		<xsl:call-template name="rcs_output">
			<xsl:with-param name="module" select="@name"/>
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
					<B>
						Application protocol:
						<xsl:call-template name="module_display_name">
							<xsl:with-param name="module" select="@name"/>
						</xsl:call-template>
					</B>
				</td>
				<td valign="MIDDLE" align="RIGHT">
					<xsl:variable name="stdnumber">
						<xsl:call-template name="get_module_pageheader">
							<xsl:with-param name="module" select="."/>
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

</xsl:stylesheet>


