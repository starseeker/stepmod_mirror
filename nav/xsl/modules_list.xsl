<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: common.xsl,v 1.23 2002/02/14 16:47:52 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: Set up the contents frame along the top
     The contents are defined in the index.xml file
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="../../xsl/common.xsl"/>


  <xsl:output method="html"/>


  <xsl:template match="/" >
    <xsl:apply-templates select="./stylesheet_application"/>
  </xsl:template>

  <xsl:template match="stylesheet_application">
    <xsl:apply-templates select="document(@file)/repository_index"/>
  </xsl:template>

<xsl:template match="repository_index">
  <HTML>
    <head>
      <link rel="stylesheet" type="text/css" href="../css/stepmod.css"/>
      <title>
        <xsl:value-of select="Modules" />
      </title>
    </head>
    <body>

      <!-- There must be a better way of doing this -->
      <xsl:apply-templates select="modules/module[substring(@name,1,1)='a' or substring(@name,1,1)='A']">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="modules/module[substring(@name,1,1)='b' or substring(@name,1,1)='B']">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="modules/module[substring(@name,1,1)='c' or substring(@name,1,1)='C']">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="modules/module[substring(@name,1,1)='d' or substring(@name,1,1)='D']">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="modules/module[substring(@name,1,1)='e' or substring(@name,1,1)='E']">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="modules/module[substring(@name,1,1)='f' or substring(@name,1,1)='F']">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="modules/module[substring(@name,1,1)='g' or substring(@name,1,1)='G']">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="modules/module[substring(@name,1,1)='h' or substring(@name,1,1)='H']">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="modules/module[substring(@name,1,1)='i' or substring(@name,1,1)='I']">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="modules/module[substring(@name,1,1)='j' or substring(@name,1,1)='J']">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="modules/module[substring(@name,1,1)='k' or substring(@name,1,1)='K']">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="modules/module[substring(@name,1,1)='l' or substring(@name,1,1)='L']">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>


      <xsl:apply-templates select="modules/module[substring(@name,1,1)='m' or substring(@name,1,1)='M']">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="modules/module[substring(@name,1,1)='n' or substring(@name,1,1)='N']">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="modules/module[substring(@name,1,1)='o' or substring(@name,1,1)='O']">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="modules/module[substring(@name,1,1)='p' or substring(@name,1,1)='P']">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="modules/module[substring(@name,1,1)='q' or substring(@name,1,1)='Q']">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="modules/module[substring(@name,1,1)='r' or substring(@name,1,1)='R']">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="modules/module[substring(@name,1,1)='s' or substring(@name,1,1)='S']">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="modules/module[substring(@name,1,1)='t' or substring(@name,1,1)='T']">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="modules/module[substring(@name,1,1)='u' or substring(@name,1,1)='U']">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="modules/module[substring(@name,1,1)='v' or substring(@name,1,1)='V']">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="modules/module[substring(@name,1,1)='w' or substring(@name,1,1)='W']">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="modules/module[substring(@name,1,1)='x' or substring(@name,1,1)='X']">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="modules/module[substring(@name,1,1)='y' or substring(@name,1,1)='Y']">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="modules/module[substring(@name,1,1)='z' or substring(@name,1,1)='Z']">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

    </body>
  </HTML>
</xsl:template>

<xsl:template match="module">
  <xsl:variable 
    name="letter"
    select="translate(substring(@name,1,1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>

  <xsl:if test="position()=1">
    <br/>
    <b>
      <A NAME="{$letter}">
        <xsl:value-of select="concat('Modules: ',$letter)"/>
      </A>
    </b>
    <br/>
  </xsl:if>


    <xsl:variable name="armg" 
      select="concat('../data/modules/',@name,'/armexpg1',$FILE_EXT)"/>
    <a href="{$armg}" target="content">
      <img align="middle" border="0" 
        alt="ExpressG" src="../images/expg_small.gif"/>
    </a>
    <xsl:variable name="map" 
      select="concat('../data/modules/',@name,'/sys/5_mapping',$FILE_EXT)"/>
    <a href="{$map}" target="content">
      <img align="middle" border="0" 
        alt="mapping" src="../images/mapping_small.gif"/>
    </a>
    <xsl:variable name="mimg" 
      select="concat('../data/modules/',@name,'/mimexpg1',$FILE_EXT)"/>
    <a href="{$mimg}" target="content">
      <img align="middle" border="0" 
        alt="ExpressG" src="../images/expg_small.gif"/>
    </a>

  <font size="-3">
    <xsl:variable name="href" 
      select="concat('../data/modules/',@name,'/sys/introduction',$FILE_EXT)"/>
    <a href="{$href}" target="content">
      <xsl:value-of select="@name"/>
    </a>

    <br/>
  </font>
</xsl:template>


</xsl:stylesheet>