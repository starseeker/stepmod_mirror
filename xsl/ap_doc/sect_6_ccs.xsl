<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_6_ccs.xsl,v 1.7 2003/05/27 07:34:15 robbod Exp $
  Author:  Mike Ward, Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: Display the main set of frames for an AP document.     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="application_protocol.xsl"/>
  <xsl:import href="application_protocol_clause.xsl"/>
  <xsl:output method="html"/>
	
	
  <xsl:template match="application_protocol">
    <xsl:call-template name="clause_header">
      <xsl:with-param name="heading" select="'6 Conformance requirements'"/>
      <xsl:with-param name="aname" select="'ccs'"/>
    </xsl:call-template>
    <p>
      Conformance to this part of ISO 10303 includes satisfying the
      requirements stated in this part, the requirements of the
      implementation method(s) supported, and the relevant requirements of the
      normative references.
    </p>
    <p>
      An implementation shall support at least one of the following implementation methods:
    </p>  
    <ul>
      <xsl:for-each select="imp_meths/imp_meth">
        <xsl:if test="@general!='y'">
          <li>            
            <xsl:choose>
              <xsl:when test="position()!=last()">
                <xsl:value-of select="concat('ISO 10303-', @part,';')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat('ISO 10303-', @part,'.')"/>        
              </xsl:otherwise>
            </xsl:choose>
          </li>
        </xsl:if>
      </xsl:for-each>
    </ul>

    <xsl:variable name="annC" select="concat('./annex_imp_meth',$FILE_EXT)"/>
    <p>
      Requirements with respect to implementation methods-specific
      requirements are specified in annex       
      <a href="{$annC}">C</a>. 
    </p>

    <xsl:variable name="annD" select="concat('./annex_pics',$FILE_EXT)"/>
    <p>
      The Protocol Implementation Conformance Statement (PICS) proforma
      lists the options or the combinations of options that may be included
      in the implementation. The PICS proforma is provided in annex
      <a href="{$annD}">D</a>.
    </p>
  
    <p>
      This part of ISO 10303 provides for a number of options that may be
      supported by an implementation. 
      These options have been grouped into the following conformance
      classes: 
    </p>

    <xsl:variable name="ccs_path"
      select="concat('../../data/application_protocols/', @name, '/ccs.xml')"/>
    <xsl:variable name="ccs_xml" select="document(string($ccs_path))"/>
    <ul>
      <xsl:apply-templates
        select="$ccs_xml/conformance/cc" mode="summary"/>
    </ul>
    <p>
      Support for a particular conformance class requires support of all the options specified
      in that class.
    </p>

    <xsl:choose>
      <xsl:when test="$ccs_xml/conformance/mims_in_ccs">
        <p>
          Conformance to a particular class requires that all ARM elements
          defined as part of that class be supported. 
          Table 
          <a href="#cc_arm_table">1</a>
          defines the classes to which each ARM element belongs.
          Table 
          <a href="#cc_mim_table">2</a>
          defines the classes to which each MIM element belongs.
        </p>
      </xsl:when>
      <xsl:otherwise>
        <p>
          Conformance to a particular class requires that all ARM elements
          defined as part of that class be supported. 
          Table 
          <a href="#cc_arm_table">1</a>
          defines the classes to which each ARM element belongs.
        </p>        
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="$ccs_xml/conformance/cc" mode="scope"/>    
    <xsl:apply-templates select="$ccs_xml/conformance/arms_in_ccs" mode="table"/>
    <xsl:apply-templates select="$ccs_xml/conformance/mims_in_ccs" mode="table"/>
  </xsl:template>

  <xsl:template match="arms_in_ccs" mode="table">
    <xsl:variable name="no_of_ccs" select="count(/conformance/cc)"/>
    <div align="center">
      <p>
        <b>
          <a name="cc_arm_table">
            Table 1 &#8212; Conformance classes per ARM entity
          </a>
        </b>
      </p>
    </div>
    <div align="center">
      <table border="1" cellspacing="1">
        <tr>
          <td rowspan="2"><b>ARM Entity</b></td>
          <td colspan="{$no_of_ccs}">
            <b>Conformance class</b>
          </td>
        </tr>
        <tr>
          <xsl:apply-templates select="/conformance/cc" mode="td_title"/>
        </tr>
        <xsl:apply-templates select="arm_entity_in_cc" mode="cc_table"/>
      </table>
    </div>
  </xsl:template>


  <xsl:template match="mims_in_ccs" mode="table">
    <xsl:variable name="no_of_ccs" select="count(/conformance/cc)"/>
    <div align="center">
      <p>
        <b>
          <a name="cc_summ">
            Table 2 &#8212; Conformance classes per MIM entity
          </a>
        </b>
      </p>
    </div>
    <div align="center">
      <table border="1" cellspacing="1">
        <tr>
          <td rowspan="2"><b>MIM Entity</b></td>
          <td colspan="{$no_of_ccs}">
            <b>Conformance class</b>
          </td>
        </tr>
        <tr>
          <xsl:apply-templates select="/conformance/cc" mode="td_title"/>
        </tr>
        <xsl:apply-templates select="mim_entity_in_cc" mode="cc_table"/>
      </table>
    </div>
  </xsl:template>




  <xsl:template match="arm_entity_in_cc|mim_entity_in_cc" mode="cc_table">
    <tr>
      <td align="left">
        <xsl:value-of select="@name"/>
      </td>
      <xsl:apply-templates select="/conformance/cc" mode="td_arm_entity">
        <xsl:with-param name="entity_in_cc" select="current()"/>
      </xsl:apply-templates>
    </tr>
  </xsl:template>


  <xsl:template match="cc" mode="td_arm_entity">
    <xsl:param name="entity_in_cc"/>
    <xsl:variable name="cc_id" select="@id"/>
    <td>
      <xsl:choose>
        <xsl:when test="$entity_in_cc/cc_id[@id=$cc_id]">
          <img align="middle" border="0" alt="X" src="../../../../images/bullet.gif"/>
        </xsl:when>
        <xsl:otherwise>
          &#160;
        </xsl:otherwise>
      </xsl:choose>
    </td>
  </xsl:template>

  <xsl:template match="cc" mode="td_title">
    <xsl:variable name="href" select="concat('cc_',@id)"/>
    <td>
      <b>
        <a href="#{$href}">
          <xsl:value-of select="@id"/>
        </a>
      </b>
    </td>
  </xsl:template>

  <xsl:template match="cc" mode="summary">
    <xsl:variable name="terminator">
      <xsl:choose>
        <xsl:when test="position()=last()">.</xsl:when>
        <xsl:otherwise>;</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="href" select="concat('cc_',@id)"/>
    <li>
      <a href="#{$href}">
        <xsl:value-of select="@id"/>
      </a>:&#160;
      <xsl:value-of select="concat(@name,$terminator)"/>
    </li>
  </xsl:template>

  <xsl:template match="cc" mode="scope">
    <xsl:variable name="module" select="@module"/>
    <xsl:variable name="module_ok">
      <xsl:call-template name="check_module_exists">
        <xsl:with-param name="module" select="$module"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="aname" select="concat('cc_',@id)"/>

    <h2>
      <a name="{$aname}">
        <xsl:value-of select="concat('6.',position(),' Conformance class for ',@name,' (',@id,')')"/> 
      </a>
    </h2>

    <xsl:apply-templates select="./inscope"/>
  </xsl:template>


  <xsl:template match="inscope">
    <p>
      <a name="inscope"/> 
      The scope of the 
      <b>
        <xsl:value-of select="../@name"/>
      </b>
      conformance class is:
    </p>

    <xsl:variable name="module" select="../@module"/>
    <xsl:variable name="module_ok">
      <xsl:call-template name="check_module_exists">
        <xsl:with-param name="module" select="$module"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="./@from_module!='NO'">
      <!-- output the scope statements from the module -->
      <xsl:choose>
        <xsl:when test="$module_ok='true'">
            <xsl:variable name="module_dir">
              <xsl:call-template name="ap_module_directory">
                <xsl:with-param name="application_protocol" select="$module"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:apply-templates
              select="document(concat($module_dir,'/module.xml'))/module/inscope/li"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="error_message">
            <xsl:with-param name="message">
            <xsl:value-of select="concat('Error APCC1: The module ',$module,' does not exist.',
                                  '  Correct CC module_name in ccs.xml')"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
        
    <!-- output the scope statements from the AP doc -->
    <xsl:if test="./li">
      <xsl:apply-templates select="li"/>
    </xsl:if>
    
  </xsl:template>


</xsl:stylesheet>
