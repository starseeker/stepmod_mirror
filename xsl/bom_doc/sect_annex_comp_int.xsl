<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_annex_comp_int.xsl,v 1.7 2005/03/02 10:47:35 mikeward Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: Display Annex E for a BOM document.  
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="business_object_model.xsl"/>
  <xsl:import href="business_object_model_clause.xsl"/>
  <xsl:output method="html"/>
	
  <xsl:template match="business_object_model">
    <xsl:call-template name="annex_header">
      <xsl:with-param name="annex_no" select="'E'"/>
      <xsl:with-param name="heading" select="'Computer interpretable listings'"/>
      <xsl:with-param name="aname" select="'annexe'"/>
      <xsl:with-param name="informative" select="'informative'"/>
    </xsl:call-template>
    <xsl:apply-templates select="." mode="annexe"/>	
  </xsl:template>
  

<!-- Annex E -->
<xsl:template match="business_object_model" mode="annexe">
  <xsl:variable name="bom_dir" select="./@name"/>
  
  <xsl:variable name="bom">
    <xsl:choose>
      <xsl:when test="$FILE_EXT='.xml'">
        <xsl:value-of select="concat('../../../data/business_object_models/', $bom_dir,'/bom.xml')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('../../../data/business_object_models/', $bom_dir,'/bom.htm')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="bom_exp" select="'../bom.exp'"/>
  <xsl:variable name="bom_xsd" select="'../bom.xsd'"/>
  <xsl:variable name="bom_xml" select="concat('../bom', $FILE_EXT)"/>
      
  <p>
    This annex references a listing of the EXPRESS entity names and corresponding short names as specified or referenced in this part of ISO 10303. 
    It also provides a listing of each EXPRESS schema specified in this part of ISO 10303 without comments nor other explanatory text.  
    These listings are available in computer-interpretable form in Table E.1 and can be found at the following URLs:
  </p> 
  <p>
    EXPRESS:	<a href="http://www.tc184-sc4.org/EXPRESS/">http://www.tc184-sc4.org/EXPRESS/</a>
  </p>
  <div align="center">
  <table border="1">
    <tr>
      <th>Description</th>
      <th>HTML file</th>
      <th>ASCII file</th>
      <th>Identifier</th>
    </tr>
    <tr>
      <td>BO EXPRESS</td>
      <td><a href="{$bom_xml}" target="info">HTML</a></td>
      <td><a href="{$bom_exp}" target="_blank">EXPRESS</a></td>
      <td>ISO TC184/SC4/WG12 N7648</td>
    </tr>
    <tr>
      <td>BO XML schema</td>
      <td></td>
      <td><a href="{$bom_xsd}" target="_blank">XSD</a></td>
      <td>ISO TC184/SC4/WG12 N7649</td>
    </tr>
  </table>
  </div>
</xsl:template>


</xsl:stylesheet>
