<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
     $Id: $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="../imgfile.xsl"/>
	<xsl:import href="sect_4_express.xsl"/>
	<xsl:import href="application_protocol_toc.xsl"/>
	<xsl:output
		method="html"
		doctype-system="http://www.w3.org/TR/html4/loose.dtd"
		doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
		indent="yes"
	/>
	<xsl:template match="ap.imgfile.content">
		<HTML>
			<HEAD>
				<TITLE>
					<xsl:value-of select="concat(@application_protocol,' : ',@title)"/>
				</TITLE>
			</HEAD>
			<body>
				<xsl:variable name="application_protocol" select="@application_protocol"/>
				<xsl:variable name="self" select="."/>
				<xsl:choose>
					<xsl:when test="@application_protocol">
						<xsl:variable name="application_protocol_dir">
            						<xsl:call-template name="application_protocol_directory">
								<xsl:with-param name="application_protocol" select="@application_protocol"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="application_protocol_file" select="concat($application_protocol_dir,'/application_protocol.xml')"/>
						<xsl:apply-templates select="document($application_protocol_file)/application_protocol" mode="TOCmultiplePage">
							<xsl:with-param name="application_protocol_root" select="'.'"/>
						</xsl:apply-templates>
						<xsl:choose>
							<xsl:when test="./@file">
								<xsl:apply-templates select="document($application_protocol_file)/application_protocol/*/express-g/imgfile" mode="nav_arrows">
									<xsl:with-param name="file" select="@file"/>
								</xsl:apply-templates>
							</xsl:when>
							<xsl:otherwise>
								To enable navigation, add file parameter to expressg file
							</xsl:otherwise>
						</xsl:choose>
						<xsl:apply-templates select="img"/>
						<xsl:choose>
							<xsl:when test="./@file">
								<div align="center">
									<h3>
										<xsl:apply-templates select="document($application_protocol_file)/application_protocol/*/express-g/imgfile" mode="title">
											<xsl:with-param name="file" select="@file"/>
										</xsl:apply-templates>
									</h3>
								</div>
							</xsl:when>
							<xsl:otherwise>
								<div align="center">
									<h3>
										<xsl:value-of select="@title"/>
									</h3>
								</div>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="error_message">
							<xsl:with-param name="message">
								<xsl:value-of select="'Error IM1: Error in image file - application_protocol not specified'"/>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:apply-templates select="img"/>
						<div align="center">
							<h3>
								<xsl:value-of select="@title"/>
							</h3>
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</body>
		</HTML>
	</xsl:template>
	
	<xsl:template match="imgfile" mode="title">
		<xsl:param name="file"/>
			<xsl:if test="$file=@file">
				<xsl:variable name="number">
					<xsl:number/>
				</xsl:variable>
				<xsl:variable name="fig_no">
					<xsl:choose>
						<xsl:when test="name(../..)='arm'">
							<xsl:choose>
								<xsl:when test="$number=1">
									<xsl:value-of select="concat('Figure C.',$number, ' - ARM Schema level EXPRESS-G diagram ',$number)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat('Figure C.',$number, ' - ARM Entity level EXPRESS-G diagram ',($number - 1))"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="name(../..)='mim'">
							<xsl:choose>
								<xsl:when test="$number=1">
									<xsl:value-of select="concat('Figure D.',$number, ' - aim Schema level EXPRESS-G diagram ',$number)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat('Figure D.',$number, ' - aim Entity level EXPRESS-G diagram ',($number - 1))"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
			<xsl:value-of select="$fig_no"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="imgfile" mode="nav_arrows">
		<xsl:param name="file"/>
		<xsl:if test="$file=@file">
			<xsl:variable name="maphref" select="concat('./sys/5_mapping',$FILE_EXT,'#mappings')"/>
				<a href="{$maphref}">
					<img align="middle" border="0" alt="Mapping table" src="../../../images/mapping.gif"/>
				</a>
			<xsl:variable name="home">
				<xsl:choose>
					<xsl:when test="name(../..)='arm'">
						<xsl:call-template name="set_file_ext">
							<xsl:with-param name="filename" select="'./sys/c_arm_expg.xml'"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="name(../..)='mim'">
						<xsl:call-template name="set_file_ext">
							<xsl:with-param name="filename" select="'./sys/d_mim_expg.xml'"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="name(../..)='aam'">
						<xsl:call-template name="set_file_ext">
							<xsl:with-param name="filename" select="'./sys/e_aam.xml'"/>
						</xsl:call-template>
					</xsl:when>

				</xsl:choose>
			</xsl:variable>
			<a href="./{$home}">
				<img align="middle" border="0" alt="Index of Express-G pages" src="../../../images/home.gif"/>
			</a>
			<xsl:variable name="img_position">
				<xsl:number/>
			</xsl:variable>
			<xsl:if test="$img_position != 1">
				<xsl:variable name="start">
					<xsl:call-template name="set_file_ext">
						<xsl:with-param name="filename" select="../imgfile[1]/@file"/>
					</xsl:call-template>
				</xsl:variable>
				<a href="./{$start}">
					<img align="middle" border="0" alt="First page" src="../../../images/start.gif"/>
				</a>
				<xsl:variable name="previous">
					<xsl:call-template name="set_file_ext">
						<xsl:with-param name="filename" select="preceding-sibling::*/@file"/>
					</xsl:call-template>
				</xsl:variable>
				<a href="./{$previous}">
					<img align="middle" border="0" alt="Previous page" src="../../../images/prev.gif"/>
				</a>
			</xsl:if>
			<xsl:if test="count(following-sibling::*)>0">
				<xsl:variable name="next">
					<xsl:call-template name="set_file_ext">
						<xsl:with-param name="filename" select="following-sibling::*/@file"/>
					</xsl:call-template>
				</xsl:variable>
				<a href="./{$next}">
					<img align="middle" border="0" alt="Next page" src="../../../images/next.gif"/>
				</a>
				<xsl:variable name="last">
					<xsl:call-template name="set_file_ext">
						<xsl:with-param name="filename" select="../imgfile[last()]/@file"/>
					</xsl:call-template>
				</xsl:variable>
				<a href="./{$last}">
					<img align="middle" border="0" alt="Last page" src="../../../images/end.gif"/>
				</a>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="imgfile">
		<xsl:variable name="href">
			<xsl:call-template name="set_file_ext">
				<xsl:with-param name="filename" select="@file"/>
			</xsl:call-template>
		</xsl:variable>
		<a href="{$href}">
			<xsl:value-of select="position()"/>
		</a>
		&#160;
	</xsl:template>

</xsl:stylesheet>

