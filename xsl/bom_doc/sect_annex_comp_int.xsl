<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_annex_comp_int.xsl,v 1.14 2014/05/29 16:09:43 nigelshaw Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: Display Annex E for a BOM document.  
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="business_object_model.xsl"/>
  <xsl:import href="business_object_model_clause_nofooter.xsl"/> 
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
  <xsl:variable name="bom_xsd_file" select="concat('bom_xsd', $FILE_EXT)"/>
  <xsl:variable name="config_xml_file" select="concat('config_xsd', $FILE_EXT)"/>
      
  <p>
    This annex provides a listing of the Business Object Model EXPRESS schema specified in this part of ISO 10303 without comments nor other explanatory text. It also provides a listing of the XML schema and the XML configuration specification.
    These listings are available in computer-interpretable form in Table D.1 and can be found at the following URLs:
  </p> 
  <p>
    EXPRESS:	<a href="http://standards.iso.org/iso/10303/smrl/v6/tech/smrlv6.zip">http://standards.iso.org/iso/10303/smrl/v6/tech/smrlv6.zip</a>
    <br></br>
    XSD:	<a href="http://standards.iso.org/iso/10303/smrl/v6/tech/xsd.zip">http://standards.iso.org/iso/10303/smrl/v6/tech/xsd.zip</a>
    <br></br>
    XML:	<a href="http://standards.iso.org/iso/10303/smrl/v6/tech/xml.zip">http://standards.iso.org/iso/10303/smrl/v6/tech/xml.zip</a>
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
      <td>ISO/TC 184/SC 4/WG 12 N<xsl:value-of select="@wg.number.bom.exp"/></td>
    </tr>
    <tr>
      <td>BO XML schema</td>
      <td><a href="{$bom_xsd_file}" target="info">HTML</a></td>
      <td><a href="{$bom_xsd}" target="_blank">XSD</a></td>
      <td>ISO/TC 184/SC 4/WG 12 N<xsl:value-of select="@wg.number.bom.xsd"/></td>
    </tr>
    <tr>
      <td>BO XML configuration specification</td>
      <td><a href="{$config_xml_file}" target="info">HTML</a></td>
      <td><a href="{$bom_p28}" target="_blank">XML</a></td>
      <td>ISO/TC 184/SC 4/WG 12 N<xsl:value-of select="@wg.number.bom.confspec"/></td>
    </tr>
  </table>
  </div>
</xsl:template>


</xsl:stylesheet>
