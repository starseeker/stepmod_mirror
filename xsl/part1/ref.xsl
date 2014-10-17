<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
    $Id: $
  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		xmlns:exslt="http://exslt.org/common"
		exclude-result-prefixes="msxsl exslt"
		version="1.0">

  <xsl:template match="std-ref">
    <xsl:variable name="stdnumber" select="normalize-space(.)"/>
    <xsl:variable name="id" select="document($bibliography_path,.)/bibitem.list/bibitem[stdnumber = $stdnumber]/@id"/>
    <xsl:choose>
      <xsl:when test="string-length($id) > 0">
	<xsl:call-template name="link">
	  <xsl:with-param name="ref" select="concat('biblio#bibitem_',$id)"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:call-template name="error_message">
          <xsl:with-param 
             name="message"
             select="concat('Error xx: Cannot find bibitem for standard: ',$stdnumber,
                     ' in ', $bibliography_path)"/>
	</xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>
  
</xsl:stylesheet>
