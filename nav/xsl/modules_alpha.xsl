<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: modules_list.xsl,v 1.1 2002/09/03 14:25:21 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: Display an alphabetical list of modules.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="modules_list.xsl"/>

  <xsl:output method="html"/>

<xsl:template match="modules">

      <!-- There must be a better way of doing this -->
      <xsl:apply-templates select="./module[substring(@name,1,1)='a' or substring(@name,1,1)='A']" mode="alpha">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="./module[substring(@name,1,1)='b' or substring(@name,1,1)='B']" mode="alpha">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="./module[substring(@name,1,1)='c' or substring(@name,1,1)='C']" mode="alpha">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="./module[substring(@name,1,1)='d' or substring(@name,1,1)='D']" mode="alpha">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="./module[substring(@name,1,1)='e' or substring(@name,1,1)='E']" mode="alpha">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="./module[substring(@name,1,1)='f' or substring(@name,1,1)='F']" mode="alpha">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="./module[substring(@name,1,1)='g' or substring(@name,1,1)='G']" mode="alpha">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="./module[substring(@name,1,1)='h' or substring(@name,1,1)='H']" mode="alpha">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="./module[substring(@name,1,1)='i' or substring(@name,1,1)='I']" mode="alpha">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="./module[substring(@name,1,1)='j' or substring(@name,1,1)='J']" mode="alpha">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="./module[substring(@name,1,1)='k' or substring(@name,1,1)='K']" mode="alpha">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="./module[substring(@name,1,1)='l' or substring(@name,1,1)='L']" mode="alpha">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>


      <xsl:apply-templates select="./module[substring(@name,1,1)='m' or substring(@name,1,1)='M']" mode="alpha">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="./module[substring(@name,1,1)='n' or substring(@name,1,1)='N']" mode="alpha">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="./module[substring(@name,1,1)='o' or substring(@name,1,1)='O']" mode="alpha">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="./module[substring(@name,1,1)='p' or substring(@name,1,1)='P']" mode="alpha">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="./module[substring(@name,1,1)='q' or substring(@name,1,1)='Q']" mode="alpha">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="./module[substring(@name,1,1)='r' or substring(@name,1,1)='R']" mode="alpha">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="./module[substring(@name,1,1)='s' or substring(@name,1,1)='S']" mode="alpha">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="./module[substring(@name,1,1)='t' or substring(@name,1,1)='T']" mode="alpha">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="./module[substring(@name,1,1)='u' or substring(@name,1,1)='U']" mode="alpha">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="./module[substring(@name,1,1)='v' or substring(@name,1,1)='V']" mode="alpha">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="./module[substring(@name,1,1)='w' or substring(@name,1,1)='W']" mode="alpha">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="./module[substring(@name,1,1)='x' or substring(@name,1,1)='X']" mode="alpha">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="./module[substring(@name,1,1)='y' or substring(@name,1,1)='Y']" mode="alpha">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="./module[substring(@name,1,1)='z' or substring(@name,1,1)='Z']" mode="alpha">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>
</xsl:template>

<xsl:template match="module" mode="alpha">
  <xsl:variable 
    name="letter"
    select="translate(substring(@name,1,1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>

  <xsl:if test="position()=1">
    <p class="alpha">
      <A NAME="{$letter}">
        <xsl:value-of select="$letter"/>
      </A>
    </p>
  </xsl:if>

  <xsl:apply-templates select="."/>
</xsl:template>

</xsl:stylesheet>