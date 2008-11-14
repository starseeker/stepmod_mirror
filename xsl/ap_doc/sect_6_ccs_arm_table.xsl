<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_6_ccs.xsl,v 1.25 2008/01/02 13:36:33 darla Exp $
  Author:  Mike Ward, Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: Display the main set of frames for an AP document.     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		xmlns:exslt="http://exslt.org/common"
                exclude-result-prefixes="msxsl exslt"
                version="1.0">
  <xsl:import href="sect_6_ccs_tables.xsl"/>
  <xsl:output method="html"/>
  
  <xsl:template match="application_protocol">
    <xsl:variable name="top_module" select="./@module_name"/>
    <xsl:variable name="ccs_path"
      select="concat('../../data/application_protocols/', @name, '/ccs.xml')"/>
    <xsl:variable name="ccs_xml" select="document(string($ccs_path))"/>

    <div align="center">
      <p>
        <b>Table 1 &#8212; Conformance class(es) and option(s) ARM elements</b>
      </p>
    </div>


    <xsl:apply-templates select="$ccs_xml/conformance" mode="arm_table">
      <xsl:with-param name="top_module" select="$top_module"/>
    </xsl:apply-templates> 
  </xsl:template>
  
  <xsl:template match="conformance" mode="arm_table">
    <xsl:param name="top_module"/>
    <xsl:variable name="no_of_ccs" select="count(/conformance/cc)"/>
    <xsl:variable name="no_of_cos" select="count(/conformance/co)"/>
     <div align="center">
      <table border="1" cellspacing="1">
        <tr>
          <td rowspan="2"><b>ARM entity</b></td>
          <td colspan="{$no_of_ccs}">
            <b>Conformance class</b>
          </td>
          <xsl:if test="$no_of_cos > 0">
          <td colspan="{$no_of_cos}">
            <b>Conformance option</b>
          </td>
          </xsl:if> 
        </tr>
        <tr>
          <xsl:apply-templates select="/conformance/cc" mode="td_title"/>
          <xsl:apply-templates select="/conformance/co" mode="td_title"/> 
        </tr>
           <xsl:apply-templates select="." mode="cc_arm_table">
          	<xsl:with-param name="top_module" select="$top_module"/>
          </xsl:apply-templates>         
      </table>
    </div>
  </xsl:template>
  
  <!-- the first conformance class is the complete module, so list all the
       entities from the long form -->
  <xsl:template match="conformance" mode="cc_arm_table">
    <xsl:param name="top_module"/>
<!--    <xsl:variable name="top_module" select="top_module/@name"/> -->
    <xsl:variable name="module_ok">
      <xsl:call-template name="check_module_exists">
        <xsl:with-param name="module" select="$top_module"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$module_ok='true'">
        <xsl:variable name="ap_module_dir">
          <xsl:call-template name="ap_module_directory">
            <xsl:with-param name="application_protocol" select="$top_module"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="ap_arm_lf"
          select="document(concat($ap_module_dir,'/arm_lf.xml'))"/> 
        <xsl:if test="count($ap_arm_lf//entity)=0">
          <xsl:call-template name="error_message">
            <xsl:with-param name="message">
              <xsl:value-of select="concat('Error APCC2: The module
                ',$top_module,' does not have an ARM
                long form defined. This is required in order to present the first
                conformance class')"/>
            </xsl:with-param>
          </xsl:call-template>
          
        </xsl:if>
<!--        <xsl:for-each select="cc">
          <xsl:variable name="lf_exists">
            <xsl:call-template name="check_module_exists">
              <xsl:with-param name="module" select="@module"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="arm_lf" select="document(concat('../../data/modules/',@module,'/arm_lf.xml'))"/>
          XXX: <xsl:value-of select="@module"/> 
          <xsl:if test="$lf_exists='true'">
            TRUE
          </xsl:if>,
          <xsl:value-of select="$arm_lf/entity"/>
          </xsl:for-each> -->
        <!-- collect entities and sort -->
        <xsl:variable name="entities">
          <!-- Now we are no longer dependent on CC, we have explicit top_schema where we take entities from -->
          <xsl:element name="top_schema">
            <xsl:for-each select="$ap_arm_lf//entity">
              <xsl:element name="entity">
                <xsl:attribute name="name">
                  <xsl:value-of select="@name"/>
                </xsl:attribute>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
          <xsl:for-each select="cc">
            <xsl:variable name="lf_exists">
              <xsl:call-template name="check_module_exists">
                <xsl:with-param name="module" select="@module"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="cc_pos" select="position()"/>
            <xsl:variable name="cc_id" select="@id"/>
            <xsl:element name="cc">
              <xsl:attribute name="cc">
                <xsl:value-of select="$cc_pos"/>
              </xsl:attribute>
              <xsl:attribute name="cc_id">
                <xsl:value-of select="@id"/>
              </xsl:attribute>
              <xsl:attribute name="entity_in_cc">
                <xsl:choose>
                  <xsl:when test="//arm_entity_in_cc/cc_id[@id=$cc_id]">
                    <xsl:value-of select="'yes'"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="'no'"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:choose>
                <xsl:when test="$lf_exists='true'">
                  <xsl:variable name="arm_lf" select="document(concat('../../data/modules/',@module,'/arm_lf.xml'))"/>                  
                  <xsl:for-each select="$arm_lf//entity">
                    <xsl:element name="entity">
                      <xsl:attribute name="name">
                        <xsl:value-of select="@name"/>
                      </xsl:attribute>
                    </xsl:element>
                  </xsl:for-each>
                  <xsl:for-each select="//arm_entity_in_cc">
                    <xsl:variable name="lname" select="@name"/>
                    <xsl:if test="not($arm_lf//entity[@name=$lname])">
                      <xsl:element name="entity">
                        <xsl:attribute name="name">
                          <xsl:value-of select="$lname"/>
                        </xsl:attribute>
                        <xsl:attribute name="cc">
                          <xsl:value-of select="'?'"/>
                        </xsl:attribute>
                      </xsl:element>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
              <xsl:for-each select="//arm_entity_in_cc"> 
                <!-- only add if not in cc1 long form -->
                <xsl:variable name="lname" select="@name"/>
                    <xsl:for-each select="@module">
                      <xsl:variable name="arm_xml">
                        "document(concat('../../data/modules/',@module,'/arm.xml'))"
                      </xsl:variable>
                      <xsl:if test="not($arm_xml//entity[@name=$lname])">
                        <xsl:element name="entity">
                          <xsl:attribute name="name">
                            <xsl:value-of select="$lname"/>
                          </xsl:attribute>
                          <xsl:attribute name="cc">
                            <xsl:value-of select="'?'"/>
                          </xsl:attribute>
                        </xsl:element>
                      </xsl:if>
                    </xsl:for-each>
              </xsl:for-each> 
                </xsl:otherwise>
              </xsl:choose>
            </xsl:element> 
          </xsl:for-each> 
          <!-- CO element is pruned cc element (with anyway not supported elements) --> 
            <xsl:for-each select="co">
            <xsl:variable name="co_pos" select="position()"/>
             <xsl:variable name="co_name" select="@name"/>
            <xsl:element name="co">
              <xsl:attribute name="co">
                <xsl:value-of select="$co_pos"/>
              </xsl:attribute>
              <xsl:attribute name="co_name">
                <xsl:value-of select="@name"/>
            </xsl:attribute>
              <xsl:attribute name="entity_in_co">
                <xsl:choose>
                  <xsl:when test="//arm_entity_in_cc/co_ref[@name=$co_name]">
                    <xsl:value-of select="'yes'"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="'no'"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
            </xsl:element>
            </xsl:for-each>
        </xsl:variable>
         <xsl:choose>
          <xsl:when test="function-available('msxsl:node-set')">
            <xsl:variable name="entities_node_set" select="msxsl:node-set($entities)"/>
            <xsl:call-template name="output_cc_arm_row">
              <xsl:with-param name="entities_node_set" select="$entities_node_set"/>
              <xsl:with-param name="conformance_node_set" select="/conformance"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="function-available('exslt:node-set')">
            <xsl:variable name="entities_node_set" select="exslt:node-set($entities)"/>
            <xsl:call-template name="output_cc_arm_row">
              <xsl:with-param name="entities_node_set" select="$entities_node_set"/>
              <xsl:with-param name="conformance_node_set" select="/conformance"/>
            </xsl:call-template> 
          </xsl:when>
        </xsl:choose>  
      </xsl:when>
      
      <xsl:otherwise>
        <xsl:call-template name="error_message">
          <xsl:with-param name="message">
            <xsl:value-of select="concat('Error APCC1: xxx The module ',$top_module,' does not exist.',
              '  Correct CC top_module in ccs.xml')"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="output_cc_arm_row">
    <xsl:param name="entities_node_set"/>
    <xsl:param name="conformance_node_set"/>
    <xsl:variable name="ccs" select="$conformance_node_set/cc"/>
    <xsl:variable name="cos" select="$conformance_node_set/co"/>
    <xsl:variable name="top_module" select="$conformance_node_set/top_module"/>
    <xsl:variable name="arms_in_ccs" select="$conformance_node_set/arms_in_ccs"/>
    <xsl:for-each select="$entities_node_set/top_schema/*">
      <xsl:sort select="@name"/>
      <xsl:variable name="lname" select="@name"/>
      <tr>
        <td align="left">
          <xsl:value-of select="$lname"/>
        </td>
        <!-- output CC1 -->
<!--        <xsl:choose>
          <xsl:when test="../@cc='2'">
            <td>
              <img align="middle" border="0" alt="X"
                src="../../../../images/bullet.gif"/>
            </td>
          </xsl:when>
          <xsl:otherwise>
            <td>&#160;</td>
          </xsl:otherwise>
        </xsl:choose> --> 
        <!-- output rest of CCs 
             check if the entity is referenced in CCs other than 1
             -->
        <xsl:choose>
          <xsl:when test="$arms_in_ccs/arm_entity_in_cc[@name=$lname] or $entities_node_set/cc/entity[@name=$lname] or $entities_node_set/co/entity[@name=$lname]">  
            <xsl:apply-templates select="." mode="cc_table_new">
	      		<xsl:with-param name="entity_in_ccs" select="$arms_in_ccs"/>
	      		<xsl:with-param name="entities_node_set" select="$entities_node_set"/>
	      	</xsl:apply-templates> 
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="$ccs" mode="blanks"/> 
            <xsl:apply-templates select="$cos" mode="blanks"/>
          </xsl:otherwise>
        </xsl:choose> 
      </tr>
    </xsl:for-each>
  </xsl:template>
  
</xsl:stylesheet>