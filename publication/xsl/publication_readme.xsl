<?xml version="1.0" encoding="utf-8"?>
<!--
$ Id: build.xsl,v 1.9 2003/02/26 02:12:17 thendrix Exp $
   Author:  Rob Bodington, Eurostep Limited
   Owner:   Developed by Eurostep Limited http://www.eurostep.com and supplied to NIST under contract.
   Purpose: To build the readme.txt for a set of part for publication
-->

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exslt="http://exslt.org/common"
  exclude-result-prefixes="exslt"
  version="1.0">
  
  <xsl:output method="text"/>
  <xsl:param name="date" select="'&lt;DATE>'" />
  <xsl:template match="publication_index">This directory comprises a set of parts (modules, resource parts or 
application protocol documents) that have been compiled for publication.

Each part is stored in a separate directory.

The zip files in the directory zip, are the individual parts that should be
sent to ISO.

The zip file:
  <xsl:choose>
    <xsl:when test="contains(@sc4.working_group,'WG')">
  <xsl:value-of select="concat(@sc4.working_group,'N',@wg.number.publication_set,'_',$date,'.zip')"/> 
has been created for sending to the convener for sign off.      
    </xsl:when>
    <xsl:otherwise>
  <xsl:value-of select="concat('WG',@sc4.working_group,'N',@wg.number.publication_set,'_',$date,'.zip')"/> 
has been created for sending to the convener for sign off.      
    </xsl:otherwise>
  </xsl:choose>
  </xsl:template>

</xsl:stylesheet>