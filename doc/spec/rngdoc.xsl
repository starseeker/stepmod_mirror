<?xml version="1.0" encoding="utf-8"?>
<!-- $Id: rngdoc.xsl,v 1.2 2004/09/30 15:48:44 joshualubell Exp $

     XSLT transform to convert annotated RELAX NG schema to DocBook 
     section element documenting the schema.

     Created by Josh Lubell, lubell@nist.gov -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:rng="http://relaxng.org/ns/structure/1.0" 
		xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" 
		version="1.0"
		exclude-result-prefixes="rng a">

  <xsl:output method="xml" indent="yes"/>

  <xsl:param name="title">RELAX NG Schema Documentation</xsl:param>

  <xsl:param name="intro.boilerplate">The RELAX NG schema contains the 
following constructs.</xsl:param>

  <xsl:template match="rng:grammar">
    <section>
      <title>
	<xsl:value-of select="$title"/>
      </title>
      <para>
	<xsl:value-of select="$intro.boilerplate"/>
      </para>
      <xsl:for-each select="//rng:element">
	<xsl:sort select="@name"/>
	<section>
	  <title>Element <code><xsl:value-of select="@name"/></code></title>
	  <informaltable>
	    <tgroup cols="2">
	      <tbody>
		<xsl:if test="a:documentation">
		  <row>
		    <entry>Documentation</entry>
		    <entry>
		      <xsl:value-of select="a:documentation"/>
		    </entry>
		  </row>
		</xsl:if>
		<row>
		  <entry>Content Model</entry>
		  <entry>
		    <code>
		      <xsl:apply-templates select="rng:empty |
						   rng:zeroOrMore | 
						   rng:oneOrMore | 
						   rng:optional | 
						   rng:choice | 
						   rng:ref | 
						   rng:element | 
						   rng:text"
					   mode="content"/>
		    </code>
		  </entry>
		</row>
	      </tbody>
	    </tgroup>
	  </informaltable>
	  <informaltable>
	    <tgroup cols="4">
	      <thead>
		<row>
		  <entry>Attribute</entry>
		  <entry>Documentation</entry>
		  <entry>Type</entry>
		  <entry>Default</entry>
		</row>
	      </thead>
	      <tbody>
		<xsl:apply-templates select="rng:optional | 
					     rng:ref"
				     mode="attributes"/>
	      </tbody>
	    </tgroup>
	  </informaltable>
	</section>
      </xsl:for-each>
    </section>
  </xsl:template>

  <xsl:template match="rng:ref" mode="content">
    <xsl:variable name="name" select="@name"/>
    <xsl:apply-templates select="//rng:define[@name=$name]"
			 mode="content"/>
  </xsl:template>

  <xsl:template match="rng:define" mode="content">
    <xsl:if test="not(rng:empty)">
      <xsl:apply-templates mode="content"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="rng:element" mode="content">
    <xsl:text> </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="rng:text" mode="content">
    <xsl:text> #PCDATA </xsl:text>
  </xsl:template>

  <xsl:template match="rng:empty" mode="content">
    <xsl:text> EMPTY </xsl:text>
  </xsl:template>

  <xsl:template match="rng:zeroOrMore" mode="content">
    <xsl:text>(</xsl:text>
    <xsl:apply-templates mode="content"/>
    <xsl:text>)*</xsl:text>
  </xsl:template>

  <xsl:template match="rng:oneOrMore" mode="content">
    <xsl:text>(</xsl:text>
    <xsl:apply-templates mode="content"/>
    <xsl:text>)+</xsl:text>
  </xsl:template>

  <xsl:template match="rng:optional" mode="content">
    <xsl:if test="not(rng:attribute)">
      <xsl:text>(</xsl:text>
      <xsl:apply-templates mode="content"/>
      <xsl:text>)?</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="rng:choice" mode="content">
    <xsl:text>(CHOICE </xsl:text>
    <xsl:apply-templates mode="content"/>
    <xsl:text>)</xsl:text>
  </xsl:template>

  <xsl:template match="rng:attribute | a:documentation" mode="content"/>

  <xsl:template match="rng:ref" mode="attributes">
    <xsl:variable name="name" select="@name"/>
    <xsl:apply-templates select="//rng:define[@name=$name]"
			 mode="attributes"/>
  </xsl:template>

  <xsl:template match="rng:define" mode="attributes">
    <xsl:apply-templates mode="attributes"/>
  </xsl:template>

  <xsl:template match="rng:optional" mode="attributes">
    <xsl:apply-templates mode="attributes"/>
  </xsl:template>

  <xsl:template match="rng:element" mode="attributes"/>

  <xsl:template match="rng:attribute" mode="attributes">
    <row>
      <entry>
	<code>
	  <xsl:value-of select="@name"/>
	</code>
      </entry>
      <entry>
	<xsl:value-of select="a:documentation"/>
      </entry>
      <entry>
	<code>
	  <xsl:choose>
	    <xsl:when test="rng:choice | rng:data">
	      <xsl:apply-templates mode="att-type"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:text>text</xsl:text>
	    </xsl:otherwise>
	  </xsl:choose>
	</code>
      </entry>
      <entry>
	<code>
	  <xsl:value-of select="@a:defaultValue"/>
	</code>
      </entry>
    </row>
  </xsl:template>

  <xsl:template match="rng:data" mode="att-type">
    <xsl:value-of select="@type"/>
  </xsl:template>

  <xsl:template match="a:documentation" mode="att-type"/>

  <xsl:template match="rng:choice" mode="att-type">
    <xsl:apply-templates select="rng:value" mode="att-type"/>
  </xsl:template>

  <xsl:template match="rng:value" mode="att-type">
    <xsl:text>&#x27;</xsl:text>
    <xsl:apply-templates mode="att-type"/>
    <xsl:text>&#x27;</xsl:text>
    <xsl:text> | </xsl:text>
  </xsl:template>

  <xsl:template match="rng:value[last()]" mode="att-type">
    <xsl:text>&#x27;</xsl:text>
    <xsl:apply-templates mode="att-type"/>
    <xsl:text>&#x27;</xsl:text>
  </xsl:template>

</xsl:stylesheet>
