<?xml version="1.0" encoding="utf-8"?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
<!--
$Id: document_xsl.xsl,v 1.4 2003/05/19 08:45:08 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
     Purpose: To display the import/includes in stylesheets
              Derived from XSL progammers reference, M.Kay
-->

<?xml-stylesheet 
  type="text/xsl" 
  href="./document_xsl.xsl" ?>

<xsl:template match="/">
  <html><body>
  <xsl:apply-templates select="comment()" mode="date"/>
    <h1>
      Stylesheet Module Structure</h1>

    <h2>Included stylesheets</h2>
    <ul>
    <xsl:apply-templates select="*/xsl:include | */xsl:import"/>
    </ul>
    <hr/>
    <h2>Templates</h2>
    <ul>
      <xsl:apply-templates select="*/xsl:template[@match]">
        <xsl:sort select="./@match"/>
      </xsl:apply-templates>

      <xsl:apply-templates select="*/xsl:template[@name]">
        <xsl:sort select="./@name"/>
      </xsl:apply-templates>
    </ul>
  </body></html>
</xsl:template>

<xsl:template match="xsl:include | xsl:import">
    <xsl:variable name="href" select="@href"/>
    <li>
      <xsl:value-of select="concat(local-name(),'s ')"/>
      <a href="{$href}">
        <xsl:value-of select="@href"/>
      </a>
    <xsl:variable name="module" select="document(@href)"/>
    <ul>

        <xsl:apply-templates select="$module/*/xsl:include | $module/*/xsl:import"/>
    </ul>
    </li>
</xsl:template>

<xsl:template match="comment()" mode="date">
  <xsl:variable name="cmt" select="normalize-space(.)"/>
  <xsl:variable name="cmt1"
    select="substring(substring-after
            (substring-after
            (substring-before(substring-after($cmt,'$Id: '),
            ' '),' '),1),19)"/>
  CVS Date: <xsl:value-of select="$cmt1"/>
</xsl:template>

<xsl:template match="xsl:template">
  <li>
    <xsl:choose>
      <xsl:when test="./@match">
        template match="<xsl:value-of select="@match"/>"
      <xsl:if test="./@mode">
        mode="<xsl:value-of select="@mode"/>"
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      template name="<xsl:value-of select="@name"/>"     
    </xsl:otherwise>
  </xsl:choose>
  </li>
</xsl:template>

</xsl:transform>

