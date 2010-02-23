<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
    $Id: sect_biblio.xsl,v 1.25 2010/02/23 14:18:30 radack Exp $
  -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		xmlns:exslt="http://exslt.org/common"
		exclude-result-prefixes="msxsl exslt"
		version="1.0">
  <xsl:template name="render_elt_list">
    <xsl:param name="elt_list"/>
    <xsl:variable name="elt_list_pruned">
      <xsl:choose>
	<xsl:when test="function-available('msxsl:node-set')">
	  <xsl:apply-templates select="msxsl:node-set($elt_list)/elt-list" mode="prune-elt-list"/>
	</xsl:when>
	<xsl:when test="function-available('exslt:node-set')">
	  <xsl:apply-templates select="exslt:node-set($elt_list)/elt-list" mode="prune-elt-list"/>
	</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="function-available('msxsl:node-set')">
	<xsl:apply-templates select="msxsl:node-set($elt_list_pruned)/elt-list" mode="render-elt-list"/>
      </xsl:when>
      <xsl:when test="function-available('exslt:node-set')">
	<xsl:apply-templates select="exslt:node-set($elt_list_pruned)/elt-list" mode="render-elt-list"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- pruning -->

  <xsl:template match="elt-list" mode="prune-elt-list">
    <xsl:variable name="pruned">
      <xsl:apply-templates mode="prune-elt-list"/>
    </xsl:variable>
    <xsl:variable name="count">
      <xsl:choose>
	<xsl:when test="function-available('msxsl:node-set')">
	  <xsl:value-of select="count(msxsl:node-set($pruned)/*)"/>
	</xsl:when>
	<xsl:when test="function-available('exslt:node-set')">
	  <xsl:value-of select="count(exslt:node-set($pruned)/*)"/>
	</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$count > 0">
      <xsl:copy>
	<xsl:apply-templates select="@*" mode="prune-elt-list"/>
	<xsl:copy-of select="$pruned"/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>

  <xsl:template match="elt" mode="prune-elt-list">
    <xsl:if test="string-length(normalize-space(*|text())) > 0">
      <xsl:copy-of select="."/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@*" mode="prune-elt-list">
    <xsl:copy-of select="."/>
  </xsl:template>

  <!-- rendering -->

  <xsl:template match="elt-list" mode="render-elt-list">
    <xsl:variable name="result">
      <xsl:call-template name="render_elt_list_content">
	<xsl:with-param name="preceding_content_processed"/>
	<xsl:with-param name="remaining_content" select="*"/>
	<xsl:with-param name="separator" select="@separator"/>
	<xsl:with-param name="terminator" select="@terminator"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:copy-of select="$result"/>
  </xsl:template>

  <xsl:template name="render_elt_list_content">
    <xsl:param name="preceding_content_processed"/>
    <xsl:param name="remaining_content"/>
    <xsl:param name="separator"/>
    <xsl:param name="terminator"/>
    <xsl:variable name="preceding_content_str" select="normalize-space($preceding_content_processed)"/>
    <xsl:choose>
      <xsl:when test="$remaining_content">
	<xsl:variable name="content_processed">
	  <xsl:if test="$preceding_content_processed">
	    <xsl:copy-of select="$preceding_content_processed"/>
	    <xsl:if test="(string-length($separator) > 0) and (substring($preceding_content_str,string-length($preceding_content_str)) != $separator)">
	      <xsl:value-of select="$separator"/>
	    </xsl:if>
	    <xsl:text> </xsl:text>
	  </xsl:if>
	  <xsl:apply-templates select="$remaining_content[position() = 1]" mode="render-elt-list"/>
	</xsl:variable>
	<xsl:call-template name="render_elt_list_content">
	  <xsl:with-param name="preceding_content_processed" select="$content_processed"/>
	  <xsl:with-param name="remaining_content" select="$remaining_content[position() > 1]"/>
	  <xsl:with-param name="separator" select="$separator"/>
	  <xsl:with-param name="terminator" select="$terminator"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:copy-of select="$preceding_content_processed"/>
	<xsl:if test="(string-length($terminator) > 0) and (substring($preceding_content_str,string-length($preceding_content_str)) != $terminator)">
	  <xsl:value-of select="$terminator"/>
	</xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="elt" mode="render-elt-list">
    <!--
	[elt template name = <xsl:value-of select="@name"/>] 
      -->
    <xsl:for-each select="*|text()">
      <xsl:copy-of select="."/>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
