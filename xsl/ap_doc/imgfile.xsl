<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: application_protocol_clause.xsl,v 1.12 2003/05/23 15:52:56 robbod Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose:     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../imgfile.xsl"/>
  <xsl:import href="sect_4_express.xsl"/>
  <xsl:import href="application_protocol_toc.xsl"/>
  <xsl:output method="html" doctype-system="http://www.w3.org/TR/html4/loose.dtd" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" indent="yes"/>

  <xsl:template match="ap.imgfile.content">
    <xsl:variable name="application_protocol" select="@application_protocol"/>
    <xsl:variable name="application_protocol_dir">
      <xsl:call-template name="application_protocol_directory">
        <xsl:with-param name="application_protocol" select="@application_protocol"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="application_protocol_file" select="concat($application_protocol_dir,'/application_protocol.xml')"/>
    <HTML>
      <HEAD>
        <xsl:if test="@application_protocol">
          <xsl:apply-templates select="document($application_protocol_file)/application_protocol" mode="meta_data"/>
        </xsl:if>        
        <TITLE>
          <xsl:value-of select="concat(@application_protocol,' : ',@title)"/>
        </TITLE>
      </HEAD>
      <body bgcolor="#eeeeee">
        <xsl:variable name="self" select="."/>
        <xsl:choose>
          <xsl:when test="@application_protocol">
            <xsl:apply-templates select="document($application_protocol_file)/application_protocol" mode="TOCmultiplePage">
              <xsl:with-param name="application_protocol_root" select="'.'"/>
            </xsl:apply-templates>

            <xsl:choose>
              <xsl:when test="./@file">
                <h1>
                  <xsl:apply-templates
                    select="document($application_protocol_file)/application_protocol//imgfile" 
                    mode="nav_arrows">
                    <xsl:with-param name="file" select="@file"/>
                  </xsl:apply-templates>
                </h1>
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
                  <xsl:apply-templates select="document($application_protocol_file)/application_protocol/aam/idef0/imgfile" mode="title">
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

<xsl:template match="imgfile.content">
		<xsl:variable name="ap_module_dir">
			<xsl:call-template name="ap_module_directory">
				<xsl:with-param name="application_protocol" select="@module"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="ap_dir">
			<xsl:call-template name="application_protocol_directory">
				<xsl:with-param name="application_protocol" select="@module"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="module_file" select="concat($ap_module_dir,'/module.xml')"/>
		<xsl:variable name="ap_file" select="string(concat($ap_dir,'/application_protocol.xml'))"/>

		<xsl:variable name="fig_title">
			<xsl:choose>
				<xsl:when test="./@file">
					<xsl:apply-templates select="document($module_file)/module/*/express-g/imgfile" mode="title">
						<xsl:with-param name="file" select="@file"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@title"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<html>
			<head>
				<title>
					<xsl:choose>
						<xsl:when test="@module">
							<xsl:value-of select="concat(@module,' : ',$fig_title)"/>
						</xsl:when>
						<xsl:otherwise>
							title not specified.
						</xsl:otherwise>
					</xsl:choose>
				</title>
			</head>
			<body>
				<xsl:variable name="module" select="@module"/>
				<xsl:variable name="self" select="."/>
				<xsl:choose>
					<xsl:when test="@module">
						
						<xsl:apply-templates select="document($ap_file)/application_protocol" mode="TOCmultiplePage">
							<xsl:with-param name="application_protocol_root" select="'.'"/>
						</xsl:apply-templates>
						<xsl:choose>
							<xsl:when test="./@file">
								<xsl:apply-templates select="document($module_file)/module/*/express-g/imgfile" mode="nav_arrows">
									<xsl:with-param name="file" select="@file"/>
								</xsl:apply-templates>
							</xsl:when>
							<xsl:otherwise>
								To enable navigation, add file parameter to expressg file
								<xsl:call-template name="error_message">
									<xsl:with-param name="inline" select="'no'"/>
									<xsl:with-param name="message">
										<xsl:value-of select="'Warning IM2: To enable navigation, add file parameter to expressg file'"/>
									</xsl:with-param>
									<xsl:with-param name="warning_gif" select="'../../../images/warning.gif'"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:apply-templates select="img">
							<xsl:with-param name="alt" select="$fig_title"/>
						</xsl:apply-templates>
						<div align="center">
							<br/>
							<br/>
							<b>
								<xsl:value-of select="$fig_title"/>
							</b>
							<br/>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="error_message">
							<xsl:with-param name="message">
								<xsl:value-of select="'Error IM1: Error in image file - module or application protocol not specified'"/>
							</xsl:with-param>
							<xsl:with-param name="warning_gif" select="'../../../images/warning.gif'"/>
						</xsl:call-template>
						<xsl:apply-templates select="img"/>
						<div align="center">
							<br/>
							<br/>
							<b>
								<xsl:value-of select="@title"/>
							</b>
							<br/>
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</body>
		</html>
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
									<xsl:value-of select="concat('Figure F.',$number, ' - ARM Schema level EXPRESS-G diagram ',$number)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat('Figure F.',$number, ' - ARM Entity level EXPRESS-G diagram ',($number - 1))"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="name(../..)='mim'">
							<xsl:choose>
								<xsl:when test="$number=1">
									<xsl:value-of select="concat('Figure A.',$number, ' - AIM Schema level EXPRESS-G diagram ',$number)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat('Figure A.',$number, ' - AIM Entity level EXPRESS-G diagram ',($number - 1))"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="name(../..)='aam'">
							<xsl:variable name="ap_dir">
								<xsl:value-of select="../../../@name"/>
							</xsl:variable>
							
							<xsl:variable name="aam_path">
								<xsl:value-of select="concat('../../data/application_protocols/', $ap_dir, '/aam.xml')"/>
							</xsl:variable>
					
							<xsl:variable name="aam_filename" select="./@file"/>
							
							<xsl:variable name="fig_no" select="position()"/>
							<xsl:variable name="node" select="document(string($aam_path))/idef0/page[position() = $fig_no]/@node"/>
							<xsl:variable name="fig_title" select="document(string($aam_path))/idef0/page[position() = $fig_no]/@title"/>
							Figure E.<xsl:value-of select="$fig_no"/> - <xsl:value-of select="$node"/> <xsl:value-of select="concat(' ', $fig_title)"/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
			<xsl:value-of select="$fig_no"/>
		</xsl:if>
	</xsl:template>
	
  <xsl:template match="imgfile" mode="nav_arrows">
    <xsl:param name="file"/>
    <xsl:if test="$file=@file">
      <xsl:if test="name(../..)='arm' or name(../..)='mim'">
        <xsl:variable name="maphref" select="concat('./sys/5_mapping',$FILE_EXT,'#mappings')"/>
        <a href="{$maphref}">
          <img align="middle" border="0" alt="Mapping table" src="../../../images/mapping.gif"/>
        </a>
      </xsl:if>
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
          <xsl:when test="name(../..)='fundamentals'">
            <xsl:call-template name="set_file_ext">
              <xsl:with-param name="filename" select="'./sys/e_aam.xml'"/>
            </xsl:call-template>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>

      <a href="./{$home}">
				<xsl:choose>
					<xsl:when test="name(../..)='arm' or name(../..)='mim'">
						<img align="middle" border="0" alt="Index of Express-G pages" src="../../../images/home.gif"/>
					</xsl:when>
					<xsl:when test="name(../..)='aam'">
						<img align="middle" border="0" alt="Index of IDEF0 pages" src="../../../images/home.gif"/>
					</xsl:when>
				</xsl:choose>
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
	
	<!-- xsl:template match="imgfile">
		<xsl:variable name="href">
			<xsl:call-template name="set_file_ext">
				<xsl:with-param name="filename" select="@file"/>
			</xsl:call-template>
		</xsl:variable>
		<a href="{$href}">
			<xsl:value-of select="position()"/>
		</a>
		&#160;
	</xsl:template -->

</xsl:stylesheet>

