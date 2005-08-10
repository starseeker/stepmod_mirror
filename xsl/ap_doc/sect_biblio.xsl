<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
	$Id: sect_biblio.xsl,v 1.17 2005/08/10 10:43:21 robbod Exp $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:exslt="http://exslt.org/common"
  exclude-result-prefixes="msxsl exslt"
  version="1.0">

  <xsl:import href="application_protocol.xsl"/>
  <xsl:import href="application_protocol_clause.xsl"/>
  
  <xsl:output method="html"/>
  
  <xsl:template match="module"/>
  
  <xsl:template match="application_protocol">
    
    <div align="center">
      <h2>
        <A NAME="biblio">Bibliography</A>
      </h2>
    </div>
    <xsl:choose>
      <xsl:when test="./bibliography">
        <xsl:apply-templates select="./bibliography"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="document('../../data/basic/ap_doc/bibliography_default.xml')/bibliography/bibitem.inc"/>
      </xsl:otherwise>
    </xsl:choose>

    <!-- check that all bibitems have been published, if not output
         footnote -->
    <xsl:apply-templates select="./bibliography" mode="unpublished_bibitems_footnote"/>    
  </xsl:template>


<xsl:template match="bibliography">
  <!-- output the defaults -->
  <xsl:apply-templates 
    select="document('../../data/basic/ap_doc/bibliography_default.xml')/bibliography/bibitem.inc"/>

  <!-- 
       count how many bitiem.incs are in
       ../data/basic/bibliography_default.xml 
       and start the numbering of the bibitem from there
       -->
  <xsl:variable name="bibitem_inc_cnt" 
    select="count(document('../../data/basic/ap_doc/bibliography_default.xml')/bibliography/bibitem.inc)"/>

  <xsl:apply-templates select="./bibitem">
    <xsl:with-param name="number_start" select="$bibitem_inc_cnt"/>
  </xsl:apply-templates>

  <!-- 
       count how many bitiem.incs are in the current document add that to
       the default bibitem.inc and bibitem in current document and start
       counting from there
       -->
  <xsl:variable name="bibitem_cnt" 
    select="count(./bibitem)+$bibitem_inc_cnt"/>

  <xsl:apply-templates select="./bibitem.inc">
    <xsl:with-param name="number_start" select="$bibitem_cnt"/>
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
  <xsl:variable name="frag" select="concat('bibitem_',@id)" />
  <p>        
  <A NAME="{$frag}"/>

    [<xsl:value-of select="$number_start+$number"/>] 
	<!--	<xsl:apply-templates select="orgname"/> 
    <xsl:apply-templates select="orgname"/>   -->
    <xsl:apply-templates select="stdnumber"/>
    <xsl:if test="stdtitle and stdnumber">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="stdtitle"/>

    <xsl:if test="subtitle">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="subtitle"/>

    <xsl:if test="pubdate">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="pubdate"/>

    <xsl:if test="ulink">
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="ulink"/>
    <xsl:text>.</xsl:text>
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

<xsl:template match="orgname">
<xsl:value-of select="."/>
</xsl:template>

<xsl:template match="stdnumber">
  <xsl:value-of select="."/>
  <xsl:if test="../@published='n'">
    <sup>
      &#160;<a href="#tobepub">1</a><xsl:text>)</xsl:text>
    </sup>
  </xsl:if>
</xsl:template>

<xsl:template match="stdtitle">
<i>
<xsl:value-of select="normalize-space(.)"/>
</i>
</xsl:template>

<xsl:template match="subtitle">
<xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<xsl:template match="pubdate">
<xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<xsl:template match="ulink">
<xsl:text>Available from the World Wide Web: </xsl:text>
  <xsl:variable name="href" select="."/>
  <br/><a href="{$href}"><xsl:value-of select="$href"/></a>
</xsl:template>


<!-- check that all bibitems have been published, if not output
     footnote -->
<xsl:template match="bibliography" mode="unpublished_bibitems_footnote">
  <!-- collect up all bibitems -->
  <xsl:variable name="bibitems">
    <bibitems>
      <!-- collect up the defaults -->
      <xsl:apply-templates
        select="document('../../data/basic/bibliography_default.xml')/bibliography" 
        mode="collect_bibitems"/>
      
      <!-- collect up the documents -->
      <xsl:apply-templates
        select="." 
        mode="collect_bibitems"/>
    </bibitems>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="function-available('msxsl:node-set')">
      <xsl:variable name="bibitem_nodes"
        select="msxsl:node-set($bibitems)"/>
      <xsl:if test="$bibitem_nodes//bibitem[@published='n']">
        <table width="200">
          <tr>
            <td><hr/></td>
          </tr>
          <tr>
            <td>
              <a name="tobepub">
                <sup>1)</sup> To be published.
              </a>
            </td>
          </tr>
        </table>
      </xsl:if>
    </xsl:when>
    <xsl:when test="function-available('exslt:node-set')">
      <xsl:variable name="bibitem_nodes"
        select="exslt:node-set($bibitems)"/>
      <xsl:if test="$bibitem_nodes//bibitem[@published='n']">
        <table width="200">
          <tr>
            <td><hr/></td>
          </tr>
          <tr>
            <td>
              <a name="tobepub">
                <sup>1)</sup> To be published.
              </a>
            </td>
          </tr>
        </table>
      </xsl:if>
    </xsl:when>
  </xsl:choose>
  
</xsl:template>

<!-- collect up all bibitems in order to check for unpublished bib items -->
<xsl:template match="bibliography"  mode="collect_bibitems">
  <xsl:variable name="bibitem_list" 
    select="document('../../data/basic/bibliography.xml')/bibitem.list"/>

  <xsl:for-each select="bibitem">
    <xsl:element name="bibitem">
      <xsl:if test="@published='n'">
        <xsl:attribute name="published">
          <xsl:value-of select="'n'"/>
        </xsl:attribute>
      </xsl:if>
    </xsl:element>
  </xsl:for-each>
  <xsl:for-each select="bibitem.inc">
    <xsl:variable name="ref" select="@ref"/>
    <xsl:variable name="bibitem_inc" select="$bibitem_list/bibitem[@id=$ref]"/>
    <xsl:element name="bibitem">
      <xsl:if test="$bibitem_inc/@published='n'">
        <xsl:attribute name="published">
          <xsl:value-of select="'n'"/>
        </xsl:attribute>
      </xsl:if>
    </xsl:element>
  </xsl:for-each>
</xsl:template>



</xsl:stylesheet>
