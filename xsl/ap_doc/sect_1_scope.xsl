<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_1_scope.xsl,v 1.15 2003/10/10 12:44:21 robbod Exp $
  Author:  Mike Ward, Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose:     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:import href="application_protocol.xsl"/>
	<xsl:import href="application_protocol_clause.xsl"/>
	<xsl:output method="html"/>
	
	<xsl:template match="application_protocol">
	  <xsl:apply-templates select="." mode="special_header"/>
  
		<h1>
    			Industrial automation systems and integration &#8212; <br/>
    			Product data representation and exchange &#8212;  <br/>
    			Part <xsl:value-of select="@part"/>:<br/>
    			Application protocol:
			<xsl:call-template name="protocol_display_name">
      				<xsl:with-param name="application_protocol" select="@title"/>
    			</xsl:call-template>
  		</h1>

			<xsl:call-template name="clause_header">
				<xsl:with-param name="heading" select="'1 Scope'"/>
				<xsl:with-param name="aname" select="'scope'"/>
			</xsl:call-template>
			<xsl:variable name="application_protocol_name">
				<xsl:call-template name="module_display_name">
					<xsl:with-param name="module" select="@title"/>
				</xsl:call-template>
			</xsl:variable>
			<p>
                          This part of ISO 10303 specifies the use of the
                          integrated resources necessary for the scope and information 
                          requirements for 
                          <xsl:value-of select="normalize-space(./inscope/@context)"/>
			</p>	
    <!-- TODO - need to check whether there are any notes in the inscope
         statements, if so the note will need to be numbered -->
    <xsl:variable name="note_number" select="''"/>
    <p class="note">
      <small>
        NOTE&#160;
        <xsl:value-of select="$note_number"/>
        &#160;&#160;
        The scope of this part of ISO 10303 is further refined in the
        application activity model in 
        Annex <a href="./annex_aam{$FILE_EXT}">F</a>.
      </small>
    </p>

    <xsl:apply-templates select="./inscope"/> 
    <xsl:apply-templates select="./outscope"/>             
  </xsl:template>

<xsl:template match="application_protocol" mode="special_header">
  <xsl:variable name="right">
    <xsl:choose>
      <xsl:when test="@status='WD' or @status='CD' or @status='DIS'">
        <xsl:value-of select="concat('ISO','/',@status,' 10303-',@part)"/>
      </xsl:when>
      <xsl:when test="@status='CD-TS'">
        <xsl:value-of select="concat('ISO/CD TS 10303-',@part)"/>
      </xsl:when>
      <xsl:when test="@status='IS'">
        <xsl:value-of select="concat('ISO',' 10303-',@part,':',@publication.year,'(',@language,')')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('ISO','/',@status,' 10303-',@part,':',@publication.year,'(',@language,')')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="left">
    <xsl:choose>
      <xsl:when test="@status='WD'"> 
        <xsl:value-of select="'WORKING DRAFT'"/>
      </xsl:when>
      <xsl:when test="@status='CD' or @status='CD-TS'">
        <xsl:value-of select="'COMMITTEE DRAFT'"/>
      </xsl:when>
      <xsl:when test="@status='DIS'">
        <xsl:value-of select="'DRAFT INTERNATIONAL STANDARD'"/>
      </xsl:when>
      <xsl:when test="@status='FDIS'">
        <xsl:value-of select="'FINAL DRAFT INTERNATIONAL STANDARD'"/>
      </xsl:when>
      <xsl:when test="@status='IS'">
        <xsl:value-of select="'INTERNATIONAL STANDARD'"/>
      </xsl:when>
      <xsl:when test="@status='TS'">
        <xsl:value-of select="'TECHNICAL SPECIFICATION'"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <p/>
  <hr/>
  <table width="100%">
    <tr>
      <td align="left">
        <xsl:value-of select="$left"/>
      </td>
      <td align="right">
        <xsl:value-of select="$right"/>
      </td>
    </tr>
  </table>
  <hr/>
</xsl:template>


</xsl:stylesheet>
