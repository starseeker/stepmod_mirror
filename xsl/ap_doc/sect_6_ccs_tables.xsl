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
  <xsl:import href="application_protocol.xsl"/>
  <xsl:import href="application_protocol_clause.xsl"/>
  <xsl:output method="html"/>
  
<!-- ++++++++++++++++ -->  
<!--  GENERIC TEMPLATES -->  
  <xsl:template match="cc" mode="td_title">
    <xsl:variable name="href" select="concat('cc_',@id)"/>
    <td>
      <b>
        <a href="6_ccs.xml/#{$href}">
          <xsl:value-of select="@id"/>
        </a>
      </b>
    </td>
  </xsl:template>

  <xsl:template match="co" mode="td_title">
    <xsl:variable name="href" select="concat('co_',translate(@name,'&#x9;&#xA;&#x20;&#xD;',''))"/> <!-- position())"/> -->
    <td>
      <b>
        <a href="6_ccs.xml/#{$href}">
          co<xsl:value-of select="position()"/>
        </a>
      </b>
    </td>
  </xsl:template>

  <xsl:template match="cc" mode="blanks">
<!--    <xsl:if test="position() != 1"> -->
      <td>&#160;</td>
<!--    </xsl:if> -->
  </xsl:template>

  <xsl:template match="co" mode="blanks">
      <td>&#160;</td>
  </xsl:template>

  <xsl:template match="arm_entity_in_cc|mim_entity_in_cc" mode="cc_table_new">
  AAA
    <xsl:variable name="cc_id" select="@id"/>
    <xsl:choose>
      <xsl:when test="current()/cc_id[@id=$cc_id]">
	<img align="middle" border="0" alt="X" src="../../../../images/bullet.gif"/>
      </xsl:when>
      <xsl:otherwise>
	&#160;
      </xsl:otherwise>
    </xsl:choose>

      <xsl:apply-templates select="/conformance/cc" mode="td_entity">
        <xsl:with-param name="entity_in_cc" select="current()"/>
      </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="cc" mode="td_entity">
    <xsl:param name="entity_in_cc"/>
    <xsl:variable name="cc_id" select="@id"/>
    <!-- ignore first CC -->
    <!-- GL - this is no longer the case 
    <xsl:if test="position() != 1">  -->
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
<!--  </xsl:if> -->
  </xsl:template>
  
  <xsl:template match="entity" mode="cc_table_new">
    <xsl:param name="entity_in_ccs"/>
    <xsl:param name="entities_node_set"/>
    <xsl:variable name="lname" select="@name"/>
    <xsl:for-each select="//cc">
      <xsl:variable name="ipos" select="position()"/>
      <xsl:variable name="cc_pos" select="@cc_pos"/>
      <xsl:variable name="cc_id" select="@cc_id"/>
	<td>
	<xsl:choose>
	  <!-- Logic - if  CC is at least once mentioned in arm_in_cc, it has a precedence over LFs -->
	  <xsl:when test="../cc/@entity_in_cc='yes' and $entity_in_ccs/*[@name=$lname]/cc_id[@id=$cc_id]">
              <img align="middle" border="0" alt="X" src="../../../../images/bullet.gif"/>
	  </xsl:when>
	  <xsl:when test="../cc/@entity_in_cc='no' and $entities_node_set/cc[$ipos]/entity[@name=$lname]">
            <img align="middle" border="0" alt="X" src="../../../../images/bullet.gif"/>
	  </xsl:when>
	  <xsl:otherwise>
	    &#160; 
	  </xsl:otherwise>
	</xsl:choose>
	</td>
    </xsl:for-each>
    <!-- Conformance option stuff -->
    <xsl:for-each select="//co">
      <xsl:variable name="ipos" select="position()"/>
      <xsl:variable name="co_pos" select="@co_pos"/>
      <xsl:variable name="co_name" select="@co_name"/>
      <td>
        <xsl:choose>
          <xsl:when test="../co/@entity_in_co='yes'  and $entity_in_ccs/*[@name=$lname]/co_ref[@name=$co_name]">
            <img align="middle" border="0" alt="X" src="../../../../images/bullet.gif"/>
          </xsl:when>
          <xsl:when test="../co/@entity_in_co='no' and $entities_node_set/co[$ipos]/entity[@name=$lname]">
            <img align="middle" border="0" alt="X" src="../../../../images/bullet.gif"/>
          </xsl:when>
          <xsl:otherwise>
            &#160;
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </xsl:for-each>
    
  </xsl:template>
  
  
</xsl:stylesheet>