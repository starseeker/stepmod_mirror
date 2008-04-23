<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: normrefs.xsl,v 1.2 2003/07/28 17:09:23 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep
  Purpose: To display a file of  normative references for test purposes.
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">


  <xsl:output 
    method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    indent="yes"
    />



<xsl:template match="/">
  <HTML>
    <HEAD>
      <TITLE>
      </TITLE>
    </HEAD>
    <BODY>
      <xsl:apply-templates select="./normref.list/normref" />
    </BODY>
  </HTML>
</xsl:template>


<xsl:template match="normref">
  <xsl:variable name="stdnumber">
<!--     <xsl:choose>
      <xsl:when test="stdref/pubdate">
        <xsl:value-of 
          select="concat(stdref/orgname,'&#160;',stdref/stdnumber,':',stdref/pubdate)"/> 
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of 
          select="concat(stdref/orgname,'&#160;',stdref/stdnumber,':&#8212;&#160;')"/>
      </xsl:otherwise>
    </xsl:choose> -->
	  <xsl:value-of 
	    select="concat(stdref/orgname,'&#160;',stdref/stdnumber)"/>
  </xsl:variable>

  <p>
    <!-- <xsl:value-of select="concat(stdref/orgname,' ',stdref/stdnumber)"/> -->
    <xsl:value-of select="$stdnumber"/>
    <xsl:if test="stdref[@published='n']">
      <sup>
        <a href="#tobepub">
          1
        </a>
      </sup>
    </xsl:if>,&#160;
    <i>
      <xsl:value-of select="stdref/stdtitle"/>
      <!-- make sure that the title ends with a . -->
      <xsl:variable 
        name="subtitle"
        select="normalize-space(stdref/subtitle)"/>
      <xsl:choose>
        <xsl:when test="substring($subtitle, string-length($subtitle)) != '.'">
          <xsl:value-of select="concat($subtitle,'.')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$subtitle"/>
        </xsl:otherwise>
      </xsl:choose>
    </i>
  </p>
</xsl:template>

</xsl:stylesheet>