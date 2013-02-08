<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_annex_comp_int.xsl,v 1.4 2013/01/17 13:53:14 ungerer Exp $
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
      <xsl:with-param name="annex_no" select="'D'"/>
      <xsl:with-param name="heading" select="'Computer interpretable listings'"/>
      <xsl:with-param name="aname" select="'annexe'"/>
      <xsl:with-param name="informative" select="'informative'"/>
    </xsl:call-template>
    <xsl:apply-templates select="." mode="annexe"/>	
  </xsl:template>
  

<!-- Annex D -->
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
  <xsl:variable name="bom_p28" select="'../p28_config.xml'"/>
      
  <p>
    This annex provides a listing of the Business Object Model EXPRESS schema specified in this part of ISO 10303 without comments nor other explanatory text. It also provides a listing of the XML schema and the XML configuration specification.
    These listings are available in computer-interpretable form in Table D.1 and can be found at the following URLs:
  </p> 
  <p>
    EXPRESS:	<a href="http://standards.iso.org/iso/ts/10303/-3001/-ed-1/tech/express">http://standards.iso.org/iso/ts/10303/-3001/-ed-1/tech/express</a>
    <br></br>
    XSD:	<a href="http://standards.iso.org/iso/ts/10303/-3001/-ed-1/tech/xml-schema">http://standards.iso.org/iso/ts/10303/-3001/-ed-1/tech/xml-schema</a>
    <br></br>
    XML:	<a href="http://standards.iso.org/iso/ts/10303/-3001/-ed-1/tech/xml-schema">http://standards.iso.org/iso/ts/10303/-3001/-ed-1/tech/xml-schema</a>
  </p>
    <div align="center">
    <a name="table_e1">
      <b>
            Table D.1 &#8212; BO Model EXPRESS and XML schema listings
      </b>
    </a>
  </div>
<br>
</br>
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
    <tr>
      <td>BO XML configuration specification</td>
      <td></td>
      <td><a href="{$bom_p28}" target="_blank">XML</a></td>
      <td>ISO TC184/SC4/WG12 Nxxxx</td>
    </tr>
  </table>
  </div>
</xsl:template>


</xsl:stylesheet>
