<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
	$Id: sect_biblio.xsl,v 1.5 2003/03/03 17:15:10 goset1 Exp $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="application_protocol.xsl"/>
  <xsl:import href="application_protocol_clause.xsl"/>
  <xsl:import href="projmg/issues.xsl"/>
  
  <xsl:output method="html"/>
  
  <xsl:template match="module"/>
  
  <xsl:template match="application_protocol">
    
    <div align="center">
      <h3>
        <A NAME="bibliography">Bibliography</A>
      </h3>
    </div>
    <xsl:choose>
      <xsl:when test="./bibliography">
        <xsl:apply-templates select="./bibliography"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="document('../../data/basic/bibliography_default.xml')/bibliography/bibitem.inc"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


<xsl:template match="bibliography">
  <!-- output the defaults -->
  <xsl:apply-templates 
    select="document('../../data/basic/bibliography_default.xml')/bibliography/bibitem.inc"/>

  <!-- 
       count how many bitiem.incs are in
       ../data/basic/bibliography_default.xml 
       and start the numbering of the bibitem from there
       -->
  <xsl:variable name="bibitem_inc_cnt" 
    select="count(document('../../data/basic/bibliography_default.xml')/bibliography/bibitem.inc)"/>
  <xsl:apply-templates select="./bibitem">
    <xsl:with-param name="number_start" select="$bibitem_inc_cnt"/>
  </xsl:apply-templates>

  <!-- 
       count how many bitiem.incs are in the current document add that to
       the default bibitem.inc and bibitem in current document and start
       counting from there
       -->
  <xsl:variable name="bibitem_cnt" 
    select="count(./bibitem)"/>

  <xsl:apply-templates select="./bibitem.inc">
    <xsl:with-param name="number_start" select="$bibitem_cnt+1"/>
  </xsl:apply-templates>
</xsl:template>


<xsl:template match="bibitem">
  <!-- the value from which to start the counting. -->
  <xsl:param name="number_start" select="0"/>

  <!-- 
       the value to be used for the number. This is used if the bibitem
       is being displayed from a bibitem.inc
       -->
  <xsl:param name="number_inc" select="0"/>

  <xsl:variable name="number">
    <!-- if the number is provided, use it, else count -->
    <xsl:choose>
      <xsl:when test="$number_inc>0">
        <xsl:value-of select="$number_inc"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:number count="bibitem"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <p>
    [<xsl:value-of select="$number_start+$number"/>] 
	<!--	<xsl:apply-templates select="orgname"/> 
    <xsl:apply-templates select="orgname"/>   -->
    <xsl:apply-templates select="stdnumber"/>
    <xsl:apply-templates select="stdtitle"/>
    <xsl:apply-templates select="subtitle"/>
    <xsl:apply-templates select="pubdate"/>
    <xsl:apply-templates select="ulink"/>
  </p>
</xsl:template>


<xsl:template match="bibitem.inc">
  <!-- the value from which to start the counting. -->
  <xsl:param name="number_start" select="0"/>

  <xsl:variable name="ref" select="@ref"/>
  <xsl:variable name="bibitem" 
    select="document('../../data/basic/bibliography.xml')/bibitem.list/bibitem[@id=$ref]"/>
  
  <xsl:choose>
    <xsl:when test="$bibitem">
      <xsl:apply-templates select="$bibitem">
        <xsl:with-param name="number_start" select="$number_start"/>
        <xsl:with-param name="number_inc" select="position()"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="error_message">
        <xsl:with-param 
          name="message"
          select="concat('Error 13: Can not find bibitem referenced by: ',$ref,
                  'in ../data/basic/bibliography.xml')"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates />
</xsl:template>

</xsl:stylesheet>
