<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: module.xsl,v 1.2 2001/10/05 15:35:00 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <!-- 
       Template to detemine whether the output is XML or HTML 
       Sets variable global FILE_EXT
       -->
  <xsl:import href="file_ext.xsl"/>


<xsl:template match="mapping_table" mode="toc">
  <ul>
    <xsl:apply-templates select="ae" mode="toc"/>
  </ul>
</xsl:template>

<xsl:template match="ae" mode="toc">
  <xsl:variable name="xref" select="concat('mapping',$FILE_EXT,'#',@entity)"/>
  <li>
    <a href="{$xref}">
      <xsl:value-of select="@entity"/>
    </a>
  </li>
</xsl:template>


</xsl:stylesheet>
