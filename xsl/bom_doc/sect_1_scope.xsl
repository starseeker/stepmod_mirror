<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_1_scope.xsl,v 1.1 2012/10/24 06:29:18 mikeward Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep Limited.
  Purpose:     
-->

<!-- BOM -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:import href="business_object_model.xsl"/>
  <xsl:import href="business_object_model_clause_nofooter.xsl"/>
	<xsl:output method="html"/>
  
  <xsl:template match="business_object_model">
	  <xsl:apply-templates select="." mode="special_header"/>
    <xsl:variable name="business_object_model_title" select="./@title"/>
  
		<h1>
    			Industrial automation systems and integration &#8212; <br/>
    			Product data representation and exchange &#8212;  <br/>
    			Part <xsl:value-of select="@part"/>:<br/>
		      Business Object Model: <xsl:value-of select="$business_object_model_title"/>
   </h1>

			<xsl:call-template name="clause_header">
				<xsl:with-param name="heading" select="'1 Scope'"/>
				<xsl:with-param name="aname" select="'scope'"/>
			</xsl:call-template>
			
			<p>
                          This part of ISO 10303 specifies the use of the
                          integrated resources necessary for the scope and information 
                          requirements for 
                          <xsl:value-of select="normalize-space(./inscope/@context)"/>
			</p>	
    <!-- TODO - need to check whether there are any notes in the inscope
         statements, if so the note will need to be numbered -->
    <xsl:variable name="note_number">
      <xsl:choose>
        <xsl:when test="(count(./inscope//note) = 0) or (count(./outscope//note) = 0)">
          <xsl:value-of select="''"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'1'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:apply-templates select="./inscope"/> 
    <xsl:apply-templates select="./outscope"/>             
  </xsl:template>

  <xsl:template match="business_object_model" mode="special_header">
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
