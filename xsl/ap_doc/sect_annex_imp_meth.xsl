<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./pas_document_xsl.xsl" ?>
<!--
$Id: sect_annex_imp_meth.xsl,v 1.2 2003/06/11 08:26:54 robbod Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose:     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="application_protocol.xsl"/>
  <xsl:import href="application_protocol_clause.xsl"/>
  <xsl:output method="html"/>
  
  <xsl:template match="module"/>
  
  <xsl:template match="application_protocol">
    <xsl:call-template name="annex_header">
      <xsl:with-param name="annex_no" select="'C'"/>
      <xsl:with-param name="heading" select="'Implementation method specific requirements'"/>
      <xsl:with-param name="aname" select="'annexc'"/>
      <xsl:with-param name="informative" select="'normative'"/>
    </xsl:call-template>
    <xsl:variable name="schema_name">
      <xsl:value-of select="@name"/>
    </xsl:variable>
    <xsl:variable name="imp_meths_phrase">
      <xsl:for-each select="imp_meths/imp_meth">
        <xsl:variable name="part_no" select="./@part"/>
        <xsl:choose>
          <xsl:when test="position()=1">
            <xsl:value-of select="concat('ISO 10303-', $part_no)"/>
          </xsl:when>
          <xsl:when test="position()=last()">
            <xsl:value-of select="concat(' or ISO 10303-', $part_no)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat(', ISO 10303-', $part_no)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>					

    The implementation method defines what types of exchange behaviour are
    required with respect to this part of ISO 10303. Conformance to this
    part of ISO 10303 shall be realized in an exchange structure.  The file
    format may be encoded according to either the syntax and EXPRESS
    language mapping defined in 
    <xsl:value-of select="$imp_meths_phrase"/>
    and in the MIM referenced in 
    <a href="annex_exp_lf{$FILE_EXT}">A.2</a>
    of this part of ISO 10303.

		
    <xsl:for-each select="imp_meths/imp_meth">		
    <xsl:variable name="sect_no">
      <xsl:number/>
    </xsl:variable>
		
    <xsl:choose>
      <xsl:when test="@general='y'">
        <h2>
          <xsl:value-of select="concat('C.',$sect_no,' ')"/>
          General requirements
        </h2>
        </xsl:when>
        <xsl:otherwise>
          <h2>
            <xsl:value-of select="concat('C.',$sect_no,' ')"/>
            Requirements specific to the implementation method defined in 
            <xsl:value-of select="concat('ISO 10303-', @part)"/>
          </h2>
        </xsl:otherwise>
      </xsl:choose>			
      <xsl:choose>
        <xsl:when test="string-length(./description) > 0">
          <xsl:apply-templates select="description"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="error_message">
            <xsl:with-param name="message" select="concat('Error 3: No description provided for the implementation method',' ')"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    
  </xsl:template>
  
	
</xsl:stylesheet>
