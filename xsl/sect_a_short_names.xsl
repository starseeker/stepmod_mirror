<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_a_short_names.xsl,v 1.9 2002/06/06 09:22:41 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="module.xsl"/>

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
  <xsl:import href="module_clause.xsl"/>


  <xsl:output method="html"/>

<!-- overwrites the template declared in module.xsl -->
<xsl:template match="module">
  <xsl:call-template name="annex_header">
    <xsl:with-param name="annex_no" select="'A'"/>
    <xsl:with-param name="heading" select="'MIM short names'"/>
    <xsl:with-param name="aname" select="'annexa'"/>
    <xsl:with-param name="informative" select="'normative'"/>
  </xsl:call-template>

  <xsl:choose>
    <xsl:when test="mim/shortnames">
      <xsl:apply-templates select="mim/shortnames"/>
    </xsl:when>
    <xsl:otherwise>
      <p>
        Entity names in this part of ISO 10303 have been defined in other
        parts of ISO 10303. Requirements on the use of the short names are
        found in the implementation methods included in ISO 10303.  
      </p>
      <!--
      <p class="note">
        <small>
          NOTE&#160;&#160;The EXPRESS entity names are available from
          Internet:<br/>
        <xsl:variable name="UPPER"
          select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
        <xsl:variable name="LOWER"
          select="'abcdefghijklmnopqrstuvwxyz'"/>
        <xsl:variable name="mim_schema"
          select="translate(concat(@name,'_mim'),$LOWER, $UPPER)"/>
        <xsl:variable name="names_url"
          select="'http://www.tc184-sc4.org/Short_Names/'"/>
        <p class="center">
          &lt;
          <a href="{$names_url}">
            <xsl:value-of select="$names_url"/>
          </a>
          &gt;
        </p>
       </small>
     </p> -->
   </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template match="shortnames">
  <p>
    Table A.1 provides the short names for entities defined in the MIM of
    this part of ISO 10303. Requirements on the use of the short names are
    found in the implementation methods included in ISO 10303. 
  </p>
  <p class="note">
    <small>
      NOTE&#160;&#160;The EXPRESS entity names are available from
      Internet:<br/>  
      <xsl:variable name="names_url"
        select="'http://www.tc184-sc4.org/Short_Names/'"/>      
      <p align="center">
        &lt;
        <a href="{$names_url}">
          <xsl:value-of select="$names_url"/>
        </a>
        &gt;
      </p>
    </small>
  </p>
  <p align="center">
    <b>
      Table A.1 - MIM short names of entities 
    </b>
  </p>
  <div align="center">
    <table border="1" cellspacing="0" cellpadding="7" width="537">
      <tr>
        <td>
          <b>Entity data types names</b>
        </td>
        <td>
          <b>Short names</b>
        </td>
      </tr>
      <xsl:apply-templates select="shortname"/>
    </table>
  </div>
</xsl:template>

<xsl:template match="shortname">
  <td width="77%" align="left">
    <xsl:value-of select="@entity"/>
  </td>
  <td width="23%" align="left">
    <xsl:value-of select="@name"/>
  </td>
</xsl:template>
  
</xsl:stylesheet>
