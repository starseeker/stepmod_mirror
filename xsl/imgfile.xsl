<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: imgfile.xsl,v 1.4 2002/03/25 14:31:07 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: To display an imgfile as an imagemap
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="common.xsl"/>

  <xsl:output 
    method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    indent="yes"
    />


<xsl:template match="imgfile.content">
  <xsl:variable name="module" select="@module"/>
  <HTML>
    <HEAD>
      <TITLE>
        <xsl:value-of select="concat(@module,' : ',@title)"/>
      </TITLE>
    </HEAD>

    <BODY>

      <!-- Need to identify whether looking at an ARM or MIM expressG
           diagram. Make an assumption if an ARM diagram then the href of
           img.area will contain 4_info_reqs -->
      <xsl:variable name="href">
        <xsl:choose>
          <xsl:when test="./img/img.area[contains(@href,'4_info_reqs.xml')]">
            <xsl:value-of select="concat('./sys/c_arm_expg',$FILE_EXT)"/>  
          </xsl:when>
          <xsl:when test="./img/img.area[contains(@href,'5_mim.xml')]">
            <xsl:value-of select="concat('./sys/d_mim_expg',$FILE_EXT)"/>  
          </xsl:when>
          <xsl:otherwise>
            <!-- the image map is probably incorrect -->
            <xsl:value-of select="concat('./sys/1_scope',$FILE_EXT)"/>  
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>


      <h3>
        <a href="{$href}">
          application module: <xsl:value-of select="@module"/>
        </a>
      </h3>
      <xsl:choose>
        <xsl:when test="@module">
          <!-- only proceed if a module is specified -->
          <small>
            ARM EXPRESS-G:&#160;
            <xsl:apply-templates 
              select="document(concat('../data/modules/',@module,'/module.xml'))/module/arm/express-g"/>
          </small>
&#160;&#160;&#160;
          <small>
            MIM EXPRESS-G:&#160;
            <xsl:apply-templates 
              select="document(concat('../data/modules/',@module,'/module.xml'))/module/mim/express-g"/>
          </small>
          <br/>
        </xsl:when>
      </xsl:choose>      
      <xsl:apply-templates select="img"/>
      <center><h3><xsl:value-of select="@title"/></h3></center>
    </BODY>
  </HTML>
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

