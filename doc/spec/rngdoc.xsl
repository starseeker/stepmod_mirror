<?xml version="1.0" encoding="utf-8"?>
<!-- $Id: rngdoc.xsl,v 1.7 2004/10/08 15:18:18 joshualubell Exp $

     XSLT transform to convert annotated RELAX NG schema to DocBook 
     section element documenting the schema.

     Created by Josh Lubell, lubell@nist.gov -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:exsl="http://exslt.org/common"
		xmlns:rng="http://relaxng.org/ns/structure/1.0" 
		xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" 
		version="1.0"
		exclude-result-prefixes="rng a exsl">

  <xsl:output method="xml" indent="yes"/>

  <xsl:param name="title">XML Schema Documentation</xsl:param>

  <xsl:param name="intro.boilerplate">The XML schema contains the following 
  constructs. The schema's root element is </xsl:param>

  <xsl:param name="root"/>

  <xsl:template match="rng:grammar">
    <section>
      <title>
	<xsl:value-of select="$title"/>
      </title>
      <para>
	<xsl:value-of select="$intro.boilerplate"/>
	<literal>
	  <link linkend="{$root}">
	    <xsl:value-of select="$root"/>
	  </link>
	</literal>
	<xsl:text>.</xsl:text>
      </para>
      <para>

	The documentation uses the following notational conveniences:

      </para>
      <itemizedlist>
	<listitem>
	  <para><literal>?</literal> means &#34;optional.&#34;</para>
	</listitem>
	<listitem>
	  <para><literal>*</literal> means &#34;zero or more.&#34;</para>
	</listitem>
	<listitem>
	  <para><literal>+</literal> means &#34;one or more.&#34;</para>
	</listitem>
	<listitem>
	  <para><literal>|</literal> means &#34;or.&#34;</para>
	</listitem>
	<listitem>
	  <para>Literals are enclosed in single quotes.</para>
	</listitem>
	<listitem>
	  <para><literal>text</literal> means any character string.</para>
	</listitem>
	<listitem>
	  <para><literal>#PCDATA</literal> denotes &#34;parsed character data&#34;, as defined in XML 1.0, in a content model.</para>
	</listitem>
	<listitem>
	  <para><literal>NMTOKEN</literal> denotes a name token, as defined in XML 1.0.</para>
	</listitem>
      </itemizedlist>
      <xsl:for-each select="//rng:element">
	<xsl:sort select="@name"/>
	<section id="{@name}">
	  <title>
	    <xsl:text>Element </xsl:text>
	    <literal>
	      <xsl:value-of select="@name"/>
	    </literal>
	    <xsl:if test="$root=@name">
	      <xsl:text> (Root Element)</xsl:text>
	    </xsl:if>
	  </title>
	  <informaltable>
	    <tgroup cols="2">
	      <tbody>
		<xsl:if test="a:documentation">
		  <row>
		    <entry><emphasis role="bold">Documentation</emphasis></entry>
		    <entry>
		      <xsl:value-of select="a:documentation"/>
		    </entry>
		  </row>
		</xsl:if>
		<row>
		  <entry><emphasis role="bold">Content Model</emphasis></entry>
		  <entry>
		    <literal>
		      <xsl:apply-templates select="rng:empty |
						   rng:zeroOrMore | 
						   rng:oneOrMore | 
						   rng:optional | 
						   rng:choice | 
						   rng:ref | 
						   rng:element | 
						   rng:text"
					   mode="content"/>
		    </literal>
		  </entry>
		</row>
		<xsl:if test="@name != $root">
		  <row>
		    <entry><emphasis role="bold">Parent Elements</emphasis></entry>
		    <entry>
		      <literal>
			<xsl:apply-templates
			    select=".."
			    mode="parents"/>
		      </literal>
		    </entry>
		  </row>
		</xsl:if>
	      </tbody>
	    </tgroup>
	  </informaltable>
	  <xsl:variable name="attributes">
	    <xsl:apply-templates select="rng:optional | rng:ref"
				 mode="attributes"/>
	  </xsl:variable>
	  <xsl:if test="exsl:node-set($attributes)/row">
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
		  <xsl:copy-of select="$attributes"/>
		</tbody>
	      </tgroup>
	    </informaltable>
	  </xsl:if>
	</section>
      </xsl:for-each>
    </section>
  </xsl:template>

  <xsl:template match="rng:ref" mode="content">
    <xsl:variable name="name" select="@name"/>
    <xsl:apply-templates select="//rng:define[@name=$name]"
			 mode="content"/>
    <xsl:if test="local-name(..)='choice' and following-sibling::*">
      <xsl:text> | </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="rng:define" mode="content">
    <xsl:if test="not(rng:empty)">
      <xsl:apply-templates mode="content"/>
      <xsl:if test="local-name(..)='choice' and following-sibling::*">
	<xsl:text> | </xsl:text>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template match="rng:element" mode="content">
    <link linkend="{@name}">
      <xsl:value-of select="@name"/>
    </link>
    <xsl:if test="local-name(..)='choice' and following-sibling::*">
      <xsl:text> | </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="rng:text" mode="content">
    <xsl:text> #PCDATA </xsl:text>
    <xsl:if test="local-name(..)='choice' and following-sibling::*">
      <xsl:text> | </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="rng:empty" mode="content">
    <xsl:text> EMPTY </xsl:text>
    <xsl:if test="local-name(..)='choice' and following-sibling::*">
      <xsl:text> | </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="rng:zeroOrMore" mode="content">
    <xsl:text>(</xsl:text>
    <xsl:apply-templates mode="content"/>
    <xsl:text>)*</xsl:text>
    <xsl:if test="local-name(..)='choice' and following-sibling::*">
      <xsl:text> | </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="rng:oneOrMore" mode="content">
    <xsl:text>(</xsl:text>
    <xsl:apply-templates mode="content"/>
    <xsl:text>)+</xsl:text>
    <xsl:if test="local-name(..)='choice' and following-sibling::*">
      <xsl:text> | </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="rng:optional" mode="content">
    <xsl:if test="not(rng:attribute)">
      <xsl:text>(</xsl:text>
      <xsl:apply-templates mode="content"/>
      <xsl:text>)?</xsl:text>
      <xsl:if test="local-name(..)='choice' and following-sibling::*">
	<xsl:text> | </xsl:text>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template match="rng:choice" mode="content">
    <xsl:text>(</xsl:text>
    <xsl:apply-templates mode="content"/>
    <xsl:text>)</xsl:text>
    <xsl:if test="local-name(..)='choice' and following-sibling::*">
      <xsl:text> | </xsl:text>
    </xsl:if>
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
	<literal>
	  <xsl:value-of select="@name"/>
	</literal>
	<xsl:if test="local-name(..)='optional'">
	  <xsl:text>?</xsl:text>
	</xsl:if>
      </entry>
      <entry>
	<xsl:choose>
	  <xsl:when test="a:documentation">
	    <xsl:value-of select="a:documentation"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>none</xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
      </entry>
      <entry>
	<literal>
	  <xsl:choose>
	    <xsl:when test="rng:choice | rng:data">
	      <xsl:apply-templates mode="att-type"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:text>text</xsl:text>
	    </xsl:otherwise>
	  </xsl:choose>
	</literal>
      </entry>
      <entry>
	<literal>
	  <xsl:value-of select="@a:defaultValue"/>
	</literal>
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
    <xsl:if test="following-sibling::*">
      <xsl:text> | </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="rng:define" mode="parents">
    <xsl:variable name="name" select="@name"/>
    <xsl:apply-templates select="//rng:ref[@name=$name]" mode="parents"/>
  </xsl:template>

  <xsl:template match="rng:ref |
		       rng:zeroOrMore |
		       rng:oneOrMore |
		       rng:optional |
		       rng:choice" 
		mode="parents">
    <xsl:apply-templates select=".." mode="parents"/>
  </xsl:template>

  <xsl:template match="rng:element" mode="parents">
    <link linkend="{@name}">
      <xsl:value-of select="@name"/>
    </link>
    <xsl:text> </xsl:text>
  </xsl:template>

</xsl:stylesheet>
