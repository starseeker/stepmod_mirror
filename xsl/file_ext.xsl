<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: file_ext.xsl,v 1.1 2001/10/05 07:52:22 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     Templates that are common to most other stylesheets
-->


<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>

<!-- 
     This parameter is passed in from Saxon and used to determine 
     whether the output is html or xml
-->
<xsl:param name="output_type" />
  
<!-- A global variable either .xml or .htm -->
<xsl:variable name="FILE_EXT" >
  <xsl:call-template name="file_ext"/>
</xsl:variable>

<xsl:template name="file_ext">
  <xsl:choose>
    <xsl:when test="$output_type='HTM'">
      <xsl:value-of select="'.htm'" /> 
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="'.xml'" /> 
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- replace the file extension with .xml or .htm according to FILE_EXT -->
<xsl:template name="set_file_ext">
  <xsl:param name="filename"/>   
  <xsl:variable name="nfilename">
    <xsl:choose>
      <xsl:when test="contains($filename,'.html')">
        <xsl:value-of select="substring-before($filename,'.html')"/>
      </xsl:when>
      <xsl:when test="contains($filename,'.htm')">
        <xsl:value-of select="substring-before($filename,'.htm')"/>
      </xsl:when>
      <xsl:when test="contains($filename,'.xml')">
        <xsl:value-of select="substring-before($filename,'.xml')"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="concat($nfilename,$FILE_EXT)"/>
</xsl:template>

</xsl:stylesheet>



