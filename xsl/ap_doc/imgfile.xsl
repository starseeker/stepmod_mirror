<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: imgfile.xsl,v 1.8 2003/05/27 07:34:15 robbod Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose:     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../imgfile.xsl"/>
  <xsl:import href="common.xsl"/>
  <xsl:import href="application_protocol_toc.xsl"/>
  <xsl:output 
    method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd" 
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" indent="yes"/>

  <xsl:template match="ap.imgfile.content">
    <xsl:variable name="application_protocol" select="@application_protocol"/>
    <xsl:variable name="application_protocol_dir">
      <xsl:call-template name="application_protocol_directory">
        <xsl:with-param name="application_protocol" select="@application_protocol"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="application_protocol_file" 
      select="concat($application_protocol_dir,'/application_protocol.xml')"/>

    <xsl:variable name="application_doc_xml"
      select="document($application_protocol_file)"/>


    <xsl:variable name="fig_title">
      <xsl:choose>
        <xsl:when test="./@file">
          <xsl:apply-templates 
            select="$application_doc_xml/application_protocol//imgfile"
            mode="imgfiletitle">
            <xsl:with-param name="file" select="@file"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@title"/>
        </xsl:otherwise>
      </xsl:choose> 
    </xsl:variable>

    <HTML>
      <HEAD>
        <xsl:if test="@application_protocol">
          <xsl:apply-templates select="$application_doc_xml/application_protocol" mode="meta_data"/>
        </xsl:if>        
        <TITLE>
          <xsl:value-of select="concat(@application_protocol,' : ',@title)"/>
        </TITLE>
      </HEAD>
      <body bgcolor="#eeeeee">
        <xsl:value-of select="$fig_title"/>
        <xsl:variable name="self" select="."/>
        <xsl:choose>
          <xsl:when test="@application_protocol">
            <xsl:apply-templates select="$application_doc_xml/application_protocol" mode="TOCmultiplePage">
              <xsl:with-param name="application_protocol_root" select="'.'"/>
            </xsl:apply-templates>

            <xsl:choose>
              <xsl:when test="./@file">
                <h1>
                  <xsl:apply-templates
                    select="$application_doc_xml/application_protocol//imgfile" 
                    mode="nav_arrows">
                    <xsl:with-param name="file" select="@file"/>
                  </xsl:apply-templates>
                </h1>
              </xsl:when>
              <xsl:otherwise>
                To enable navigation, add file parameter to expressg file
                <xsl:call-template name="error_message">
                  <xsl:with-param name="inline" select="'no'"/>
                  <xsl:with-param name="message">
                    <xsl:value-of 
                      select="'Warning APIM2: To enable navigation, add file parameter to img file'"/>
                  </xsl:with-param>
                  <xsl:with-param name="warning_gif"
                    select="'../../../images/warning.gif'"/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>

            <!-- now display the image -->
            <xsl:apply-templates select="img">
              <xsl:with-param name="alt" select="$fig_title"/>
            </xsl:apply-templates>
            <div align="center">
              <br/><br/>
              <b>
                <xsl:value-of select="$fig_title"/>
              </b>
              <br/>
            </div>
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
  
  <xsl:template match="imgfile" mode="imgfiletitle">
    <xsl:param name="file"/>
    <xsl:if test="$file=@file">
      <xsl:apply-templates select=".." mode="imgfiletitle">
        <xsl:with-param name="number">
          <xsl:number/>
        </xsl:with-param>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="data_plan" mode="imgfiletitle">
    <xsl:param name="number"/>
    <xsl:apply-templates select=".." mode="imgfiletitle">
      <xsl:with-param name="number" select="$number"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="fundamentals" mode="imgfiletitle">
    <xsl:param name="number"/>
    <xsl:variable name="figure_count">
      <xsl:call-template name="count_figures_from_fundamentals"/>
    </xsl:variable>
    <xsl:value-of select="concat('Figure ', $figure_count+$number ' Data planning model')"/>
  </xsl:template>
  
  <xsl:template match="purpose" mode="imgfiletitle">
    <xsl:param name="number"/>
    <xsl:value-of select="concat('Figure '$number, ' Data planning model')"/>
  </xsl:template>


  <xsl:template match="idef0" mode="imgfiletitle">
    <xsl:param name="number"/>
    <xsl:apply-templates select=".." mode="imgfiletitle">
      <xsl:with-param name="number" select="$number"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="aam" mode="imgfiletitle">
    <xsl:param name="number"/>
    
    <xsl:variable name="ap_dir">
      <xsl:value-of select="/application_protocol/@name"/>
    </xsl:variable>
    
    <xsl:variable name="aam_path">
      <xsl:value-of select="concat('../../data/application_protocols/', $ap_dir, '/aam.xml')"/>
    </xsl:variable>
    
    <xsl:variable name="aam_filename" select="./@file"/>
    
    <xsl:variable name="fig_no" select="$number"/>
    <xsl:variable name="node" select="document(string($aam_path))/idef0/page[position() = $fig_no]/@node"/>
    <xsl:variable name="fig_title"
      select="document(string($aam_path))/idef0/page[position() = $fig_no]/@title"/>    
    <xsl:value-of select="concat('Figure E.'$fig_no, ' - ', $node, ' ', $fig_title)"/>
  </xsl:template>
	
  <xsl:template match="imgfile" mode="nav_arrows">
    <xsl:param name="file"/>
    <xsl:if test="$file=@file">
      <xsl:variable name="home">
        <xsl:choose>
          <xsl:when test="name(../..)='aam'">
            <xsl:call-template name="set_file_ext">
              <xsl:with-param name="filename" select="'./sys/f_aam.xml'"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="name(../..)='purpose'">
            <xsl:value-of select="concat('./sys/introduction',$FILE_EXT,'#data_plan')"/>
          </xsl:when>
          <xsl:when test="name(../..)='fundamentals'">
            <xsl:value-of select="concat('./sys/4_info_reqs',$FILE_EXT,'#data_plan')"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>

      <a href="./{$home}">
        <xsl:choose>
          <xsl:when test="name(../..)='aam'">
            <img align="middle" border="0" alt="Index of IDEF0 pages" src="../../../images/home.gif"/>
          </xsl:when>
          <xsl:when test="name(../..)='purpose'">
            <img align="middle" border="0" alt="Index of data planning diagrams" src="../../../images/home.gif"/>
          </xsl:when>
          <xsl:when test="name(../..)='fundamentals'">
            <img align="middle" border="0" alt="Index of detailed data planning diagrams" src="../../../images/home.gif"/>
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
	
</xsl:stylesheet>

