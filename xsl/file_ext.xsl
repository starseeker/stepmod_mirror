<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: $
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

</xsl:stylesheet>