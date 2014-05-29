<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_annex_comp_int.xsl,v 1.12 2014/05/29 08:04:45 nigelshaw Exp $
  Author:  Mike Ward, Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: 
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="application_protocol.xsl"/>
  <xsl:import href="application_protocol_clause.xsl"/>
  <xsl:output method="html"/>
	
  <xsl:template match="application_protocol">
    <xsl:apply-templates select="." mode="annexg"/>	
  </xsl:template>
  

<!-- Annex G -->
<xsl:template match="application_protocol" mode="annexg">

 <xsl:variable name="bom_name" select="@business_object_model"/>

  <xsl:variable name="annex_list">
    <xsl:apply-templates select="." mode="annex_list"/>
  </xsl:variable>
  
  <xsl:variable name="annex_letter">
    <xsl:call-template name="annex_letter" >
      <xsl:with-param name="annex_name" select="'computerinterpretablelisting'"/>
      <xsl:with-param name="annex_list" select="$annex_list"/>
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:call-template name="annex_header">
    <xsl:with-param name="annex_no" select="$annex_letter"/>
    <xsl:with-param name="heading" select="'Computer interpretable listings'"/>
    <xsl:with-param name="aname" select="'annexg'"/>
  </xsl:call-template>
  
  <xsl:variable name="module" select="@module_name"/>
  <xsl:variable name="module_ok">
    <xsl:call-template name="check_module_exists">
      <xsl:with-param name="module" select="$module"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$module_ok!='true'">
    <xsl:call-template name="error_message">
      <xsl:with-param name="message">
        <xsl:value-of select="concat('Error AP1: The module ',$module,' does not exist.',
                              '  Correct application_protocol module_name in application_protocol.xml')"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:if>
  <xsl:variable name="module_dir">
    <xsl:call-template name="ap_module_directory">
      <xsl:with-param name="application_protocol" select="$module"/>
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:variable name="module_xml" select="document(concat($module_dir,'/module.xml'))"/>
  <xsl:apply-templates select="$module_xml/module" mode="annexe">
    <xsl:with-param name="annex_no" select="$annex_letter"/>
    <xsl:with-param name="bom_name" select="@business_object_model"/>
  </xsl:apply-templates>
</xsl:template>



<xsl:template match="module" mode="annexe">
  <xsl:param name="annex_no" select="'E'"/>
  <xsl:param name="bom_name"/>

  <xsl:variable name="arm">
    <xsl:choose>
      <xsl:when test="$FILE_EXT='.xml'">
        <xsl:value-of select="concat('../../../modules/',/module/@name,'/sys/e_exp_arm.xml')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('../../../modules/',/module/@name,'/sys/e_exp_arm.htm')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="mim">
    <xsl:choose>
      <xsl:when test="$FILE_EXT='.xml'">
        <xsl:value-of select="concat('../../../modules/',/module/@name,'/sys/e_exp_mim.xml')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('../../../modules/',/module/@name,'/sys/e_exp_mim.htm')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="UPPER"
    select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="LOWER"
    select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="mim_schema"
    select="translate(concat(@name,'_mim'),$LOWER, $UPPER)"/>
   
  <!--
       It has been decided to point to the index instead
  <xsl:variable name="names_url"
      select="concat('http://www.steptools.com/cgi-bin/getnames.cgi?schema=',
              $mim_schema)"/>
  
  <xsl:variable name="parts_url"
  select="concat('http://www.steptools.com/sc4/archive/~checkout~/modules/10303-',@part,'-arm.exp?rev=1.1&amp;content-type=text/plain')"/>
  -->
  <xsl:variable name="names_url"
    select="'http://standards.iso.org/iso/10303/tech/short_names/short_names.txt'"/>
  
  <xsl:variable name="parts_url"
    select="'http://standards.iso.org/iso/10303/smrl/v6/tech/smrlv6.zip'"/>

  <p>
    This annex provides a listing of the complete EXPRESS schema referenced
    in Annex 
    <a href="annex_exp_lf{$FILE_EXT}">A</a> 
    of this part of ISO 10303 without comments or other
    explanatory text. It also provides a listing of the EXPRESS entity
    names and corresponding short names as specified in Annex 
    <a href="annex_shortnames{$FILE_EXT}">B</a> 
    of this part of ISO 10303.  The content of this annex is available in
    computer-interpretable form and can be found in Table 
    <xsl:value-of select="$annex_no"/>.1
    or at the following  URLs:    
  </p>

  <table>
    <tr>
      <td>&#160;&#160;</td>
      <td>Short names:</td>
      <td><a href="{$names_url}" target="_blank"><xsl:value-of select="$names_url"/></a></td>
  </tr>
  <tr>
    <td>&#160;&#160;</td>
    <td>EXPRESS:</td>
     <td><a href="{$parts_url}" target="_blank"><xsl:value-of select="$parts_url"/></a></td>
   </tr>
  </table>
  <p/>
  <div align="center">
    <a name="table_e1">
      <b>
        <xsl:choose>
          <xsl:when test="./mim_lf or ./arm_lf">
            Table <xsl:value-of select="$annex_no"/>.1 &#8212; ARM and MIM EXPRESS short and long form listings
          </xsl:when>
          <xsl:otherwise>
            Table <xsl:value-of select="$annex_no"/>.1 &#8212; ARM and MIM EXPRESS listings
          </xsl:otherwise>
        </xsl:choose>
      </b>
    </a>
  </div>

  <br/>

  <div align="center">
    <table border="1" cellspacing="1">
      <tr>
        <td><b>Description</b></td>
        <xsl:choose>
          <xsl:when test="$FILE_EXT='.xml'">
            <td><b>XML file</b></td>
          </xsl:when>
          <xsl:otherwise>
            <td><b>HTML file</b></td>
          </xsl:otherwise>
        </xsl:choose>

        <td><b>ASCII file</b></td>
        <td><b>Identifier</b></td>
      </tr>
      
      <!-- ARM HTML row -->
      <tr>
        <xsl:choose>
          <xsl:when test="$FILE_EXT='.xml'">
            <td>ARM short form EXPRESS</td>
          </xsl:when>
          <xsl:otherwise>
            <td>ARM short form EXPRESS</td>
          </xsl:otherwise>
        </xsl:choose>
        <td>
          <a href="{$arm}">
            <!-- <xsl:value-of select="concat('arm',$FILE_EXT)"/> -->
            <xsl:choose>
              <xsl:when test="$FILE_EXT='.xml'">
                XML
              </xsl:when>
              <xsl:otherwise>
                HTML
              </xsl:otherwise>
            </xsl:choose>
          </a>
        </td>

        <xsl:call-template name="output_express_links">
          <xsl:with-param name="module" select="/module/@name"/>
          <xsl:with-param name="wgnumber" select="./@wg.number.arm"/>
          <xsl:with-param name="file" select="'arm.exp'"/>
        </xsl:call-template>        
      </tr>
      <xsl:apply-templates select="arm_lf" mode="annexe"/>

      <!-- MIM HTML row -->
      <tr>
        <xsl:choose>
          <xsl:when test="$FILE_EXT='.xml'">
            <td>MIM short form EXPRESS</td>
          </xsl:when>
          <xsl:otherwise>
            <td>MIM short form EXPRESS</td>
          </xsl:otherwise>
        </xsl:choose>
        <td>
          <a href="{$mim}">
            <!-- <xsl:value-of select="concat('mim',$FILE_EXT)"/> -->
            <xsl:choose>
              <xsl:when test="$FILE_EXT='.xml'">
                XML
              </xsl:when>
              <xsl:otherwise>
                HTML
              </xsl:otherwise>
            </xsl:choose>
          </a>
        </td>
        <xsl:call-template name="output_express_links">
          <xsl:with-param name="module" select="/module/@name"/>
          <xsl:with-param name="wgnumber" 
            select="./@wg.number.mim"/>
          <xsl:with-param name="file" select="'mim.exp'"/>
        </xsl:call-template>        
      </tr>
      <xsl:apply-templates select="mim_lf" mode="annexe"/>

      <xsl:if test="$bom_name" >
<!-- BOM -->
	<xsl:variable name="bom_exp" select="concat('../../../business_object_models/',$bom_name,'/bom.exp')"/>
	<xsl:variable name="bom_xsd" select="concat('../../../business_object_models/',$bom_name,'/bom.xsd')"/>
	<xsl:variable name="bom_xml" select="concat('../../../business_object_models/',$bom_name,'/bom', $FILE_EXT)"/>
	<xsl:variable name="bom_xsd_file" select="concat('../../../business_object_models/',$bom_name,'/sys/bom_xsd', $FILE_EXT)"/>
	<xsl:variable name="bom_xsd_conf_file" select="concat('../../../business_object_models/',$bom_name,'/sys/config_xsd', $FILE_EXT)"/>
	<xsl:variable name="bom_xsd_conf" select="concat('../../../business_object_models/',$bom_name,'/p28_config.xml')"/>
	<xsl:variable name="bom_element" select="document(concat('../../data/business_object_models/',$bom_name,'/business_object_model.xml'))/business_object_model" />

	    <tr>
	      <td>BO EXPRESS</td>
	      <td><a href="{$bom_xml}" target="info">HTML</a></td>
	      <td><a href="{$bom_exp}" target="_blank">EXPRESS</a></td>
	      <td>ISO/TC 184/SC 4/WG 12 N<xsl:value-of select="$bom_element/@wg.number.bom.exp"/></td>
	    </tr>
	    <tr>
	      <td>BO XML schema</td>
	      <td><a href="{$bom_xsd_file}" target="info">HTML</a></td>
	      <td><a href="{$bom_xsd}" target="_blank">XSD</a></td>
	      <td>ISO/TC 184/SC 4/WG 12 N<xsl:value-of select="$bom_element/@wg.number.bom.xsd"/></td>
	    </tr>
	    <tr>
	      <td>BO XML configuration specification</td>
	      <td><a href="{$bom_xsd_conf_file}" target="info">HTML</a></td>
	      <td><a href="{$bom_xsd_conf}" target="_blank">XSD</a></td>
	      <td>ISO/TC 184/SC 4/WG 12 N<xsl:value-of select="$bom_element/@wg.number.bom.confspec"/></td>
	    </tr>
    </xsl:if>
<!--   
-->
    </table>
  </div>
  <p>
    If there is difficulty accessing these sites, contact ISO Central
    Secretariat.
  </p>
  <p class="note">
    <small>
      NOTE&#160;&#160;The information provided in computer-interpretable
      form at the 
      above URLs is informative. The information that is contained in the
      body of this part of ISO 10303 is normative. 
    </small>
  </p>
</xsl:template>

<xsl:template name="output_express_links">
  <xsl:param name="wgnumber"/>
  <xsl:param name="module"/>
  <xsl:param name="file"/>

  <td>
    <a href="../../../modules/{$module}/{$file}">
      EXPRESS
      <!--  <xsl:value-of select="$file"/> -->
    </a>
  </td>
  <td align="left">
    <xsl:variable name="test_wg_number">
      <xsl:call-template name="test_wg_number">
        <xsl:with-param name="wgnumber" select="$wgnumber"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="type">
      <xsl:choose>
        <xsl:when test="$file='arm.exp'">
          arm
        </xsl:when>
        <xsl:otherwise>
          mim
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="contains($test_wg_number,'Error')">
        <xsl:call-template name="error_message">
          <xsl:with-param name="message">
            <xsl:value-of select="concat('(Error in
                                  module.xml/module/@wg.number.',$type,' - ',
                                  $test_wg_number)"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="wg_group">
          <xsl:call-template name="get_module_wg_group"/>
        </xsl:variable>
	<xsl:value-of select="concat('ISO/TC 184/SC 4/WG ',$wg_group,' N',$wgnumber)"/>
      </xsl:otherwise>
    </xsl:choose>    
  </td>
</xsl:template>

<xsl:template match="arm_lf" mode="annexe">
  <xsl:variable name="arm_lf">
    <xsl:choose>
      <xsl:when test="$FILE_EXT='.xml'">
        <xsl:value-of select="concat('../../../modules/',/module/@name,'/sys/e_exp_arm_lf.xml')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('../../../modules/',/module/@name,'/sys/e_exp_arm_lf.htm')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <tr>
    <td>ARM long form EXPRESS</td>
    <td>
      <a href="{$arm_lf}">
        <!-- <xsl:value-of select="concat('arm_lf',$FILE_EXT)"/> -->
        <xsl:choose>
          <xsl:when test="$FILE_EXT='.xml'">
            XML
          </xsl:when>
          <xsl:otherwise>
            HTML
          </xsl:otherwise>
        </xsl:choose>
      </a>
    </td>
    <xsl:call-template name="output_express_links">
      <xsl:with-param name="module" select="/module/@name"/>
      <xsl:with-param name="wgnumber" 
        select="../@wg.number.arm_lf"/>
      <xsl:with-param name="file" select="'arm_lf.exp'"/>
    </xsl:call-template>        
  </tr>
</xsl:template>

<xsl:template match="mim_lf" mode="annexe">
  <xsl:variable name="mim_lf">
    <xsl:choose>
      <xsl:when test="$FILE_EXT='.xml'">
        <xsl:value-of select="concat('../../../modules/',/module/@name,'/sys/e_exp_mim_lf.xml')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('../../../modules/',/module/@name,'/sys/e_exp_mim_lf.htm')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <tr>
    <td>MIM long form EXPRESS</td>
    <td>
      <a href="{$mim_lf}">
        <!-- <xsl:value-of select="concat('mim_lf',$FILE_EXT)"/> -->
        <xsl:choose>
          <xsl:when test="$FILE_EXT='.xml'">
            XML
          </xsl:when>
          <xsl:otherwise>
            HTML
          </xsl:otherwise>
        </xsl:choose>
      </a>
    </td>
    <xsl:call-template name="output_express_links">
      <xsl:with-param name="module" select="/module/@name"/>
      <xsl:with-param name="wgnumber" 
        select="../@wg.number.mim_lf"/>
      <xsl:with-param name="file" select="'mim_lf.exp'"/>
    </xsl:call-template>        
  </tr>
</xsl:template>

	
</xsl:stylesheet>
