<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: imgfile.xsl,v 1.20 2002/09/11 12:27:05 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: To display an imgfile as an imagemap
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">


  <xsl:import href="sect_4_express.xsl"/>
  <xsl:import href="module_toc.xsl"/>



  <xsl:output 
    method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    indent="yes"
    />


<xsl:template match="imgfile.content">
  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="@module"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="module_file" select="concat($module_dir,'/module.xml')"/>

  <!-- if a file is specified then can deduce the figure title -->
  <xsl:variable name="fig_title">
    <xsl:choose>
      <xsl:when test="./@file">
        <xsl:apply-templates 
          select="document($module_file)/module/*/express-g/imgfile"
          mode="title">
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
      <TITLE>
        <xsl:choose>
          <xsl:when test="@module">
            <xsl:value-of select="concat(@module,' : ',$fig_title)"/>
          </xsl:when>
          <xsl:otherwise>
            @module not specified.
          </xsl:otherwise>
        </xsl:choose>
      </TITLE>
    </HEAD>

    <body>
      <xsl:variable name="module" select="@module"/>
      <xsl:variable name="self" select="."/>
      <xsl:choose>
        <xsl:when test="@module">
          <xsl:apply-templates 
            select="document($module_file)/module"
            mode="TOCmultiplePage">
            <xsl:with-param name="module_root" select="'.'"/>
          </xsl:apply-templates>

          <!-- display navigation arrows -->
          <xsl:choose>
            <xsl:when test="./@file">
              <xsl:apply-templates 
                select="document($module_file)/module/*/express-g/imgfile"
                mode="nav_arrows">
                <xsl:with-param name="file" select="@file"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
              To enable navigation, add file parameter to expressg file
              <xsl:call-template name="error_message">
                <xsl:with-param name="inline" select="'no'"/>
                <xsl:with-param name="message">
                  <xsl:value-of 
                    select="'Warning IM2: To enable navigation, add file parameter to expressg file'"/>
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
              <xsl:value-of 
                select="'Error IM1: Error in image file - module not specified'"/>
            </xsl:with-param>
            <xsl:with-param name="warning_gif"
              select="'../../../images/warning.gif'"/>

          </xsl:call-template>
          <xsl:apply-templates select="img"/>
          <div align="center"><br/><br/><b><xsl:value-of select="@title"/></b><br/></div>
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
              <xsl:value-of 
                select="concat('Figure C.',$number, 
                        ' &#8212; ARM schema level EXPRESS-G diagram ',$number)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of 
                select="concat('Figure C.',$number, 
                        ' &#8212; ARM entity level EXPRESS-G diagram ',($number - 1))"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="name(../..)='mim'">
          <xsl:choose>
            <xsl:when test="$number=1">
              <xsl:value-of 
                select="concat('Figure D.',$number, 
                        ' &#8212; MIM schema level EXPRESS-G diagram ',$number)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of 
                select="concat('Figure D.',$number, 
                        ' &#8212; MIM entity level EXPRESS-G diagram ',($number - 1))"/>
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
    <!-- Page navigation:&#160; -->
      <xsl:variable name="maphref" 
        select="concat('./sys/5_mapping',$FILE_EXT,'#mappings')"/>
      <a href="{$maphref}">
        <img align="middle" border="0" 
          alt="Mapping table" src="../../../images/mapping.gif"/>
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
        </xsl:choose>
      </xsl:variable>

      <a href="./{$home}">
        <img align="middle" border="0" 
          alt="Index of EXPRESS-G pages" src="../../../images/home.gif"/>
      </a>
      <xsl:variable name="img_position">
        <xsl:number/>
      </xsl:variable>

      <xsl:if test="$img_position != 1">
        <!-- not first page, so start page and previous page -->
        <xsl:variable name="start">
          <xsl:call-template name="set_file_ext">
            <xsl:with-param name="filename" select="../imgfile[1]/@file"/>
          </xsl:call-template>
        </xsl:variable>
        <a href="./{$start}">
          <img align="middle" border="0" 
            alt="First page" src="../../../images/start.gif"/>
        </a>
        <xsl:variable name="prevpos" select="$img_position - 1"/>
        <xsl:variable name="previous">
          <xsl:call-template name="set_file_ext">
            <xsl:with-param name="filename" 
              select="../imgfile[$prevpos]/@file"/>
          </xsl:call-template>
        </xsl:variable>   

        <a href="./{$previous}">
          <img align="middle" border="0" 
            alt="Previous page" src="../../../images/prev.gif"/>
        </a>
      </xsl:if> <!-- end of NOT first page -->
      
      <xsl:if test="count(following-sibling::*)>0">
        <!-- there are subsequent diagrams, so next and end -->
        <xsl:variable name="next">
          <xsl:call-template name="set_file_ext">
            <xsl:with-param name="filename" 
              select="following-sibling::*/@file"/>
          </xsl:call-template>
        </xsl:variable>
        <a href="./{$next}">
          <img align="middle" border="0" 
            alt="Next page" src="../../../images/next.gif"/>
        </a>
        
        <xsl:variable name="last">
          <xsl:call-template name="set_file_ext">
            <xsl:with-param name="filename" 
              select="../imgfile[last()]/@file"/>
          </xsl:call-template>
        </xsl:variable>
        
        <a href="./{$last}">
          <img align="middle" border="0" 
            alt="Last page" src="../../../images/end.gif"/>
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
  </a>&#160;
</xsl:template>


</xsl:stylesheet>

