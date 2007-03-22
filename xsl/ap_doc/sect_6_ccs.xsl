<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_6_ccs.xsl,v 1.22 2005/02/06 06:42:43 robbod Exp $
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
	
	
  <xsl:template match="application_protocol">
    <xsl:call-template name="clause_header">
      <xsl:with-param name="heading" select="'6 Conformance requirements'"/>
      <xsl:with-param name="aname" select="'ccs'"/>
    </xsl:call-template>

    <xsl:variable name="module" select="./@module_name"/>           
    <xsl:variable name="module_ok">
      <xsl:call-template name="check_module_exists">
        <xsl:with-param name="module" select="$module"/>
      </xsl:call-template>
    </xsl:variable>
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
      requirements are specified in Annex       
      <a href="{$annC}">C</a>. 
    </p>

    <xsl:variable name="annD" select="concat('./annex_pics',$FILE_EXT)"/>
    <p>
      The Protocol Implementation Conformance Statement (PICS) proforma
      lists the options or the combinations of options that may be included
      in the implementation. The PICS proforma is provided in Annex
      <a href="{$annD}">D</a>.
    </p>

    <xsl:variable name="ccs_path"
      select="concat('../../data/application_protocols/', @name, '/ccs.xml')"/>
    <xsl:variable name="ccs_xml" select="document(string($ccs_path))"/>

    <xsl:choose>
      <xsl:when test="count($ccs_xml/conformance/cc)=1">
        <p>
          This part of ISO 10303 provides for only one option that may be
          supported by an implementation: 
        </p>
        <ul>
          <xsl:apply-templates
            select="$ccs_xml/conformance/cc" mode="summary"/>
        </ul>        

        <p>
          This option shall be supported by a single class of conformance
          that consists of all the ARM elements defined in the AP module
          <xsl:choose>
            <xsl:when test="$module_ok='true'">
              <xsl:variable name="module_dir">
                <xsl:call-template name="ap_module_directory">
                  <xsl:with-param name="application_protocol" select="$module"/>
                </xsl:call-template>
              </xsl:variable>
	      <xsl:variable name="module_node"
			    select="document(concat($module_dir,'/module.xml'))/module"/> 
	      (<a href="../../../modules/{$module}/sys/cover{$FILE_EXT}">ISO 10303-<xsl:value-of select="$module_node/@part"/></a>).
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
        </p>
      </xsl:when>
      <xsl:otherwise>
        <p>
          This part of ISO 10303 provides for a number of options that may be
          supported by an implementation. 
          These options have been grouped into the following conformance
          classes: 
        </p>  
        <ul>
          <xsl:apply-templates
            select="$ccs_xml/conformance/cc" mode="summary"/>
        </ul>        
        <p>
          Support for a particular conformance class requires support of all the options specified
          in that class.
        </p>
      </xsl:otherwise>
    </xsl:choose>


    <xsl:variable name="table_count">
      <xsl:apply-templates select="." mode="table_count_cc"/>
    </xsl:variable>

    <!-- the first conformance class is always the complete AP module -->
    <p>
      Conformance to a particular class requires that all ARM elements
      defined as part of that class be supported. 
      Table 
      <a href="#cc_arm_table">
        <xsl:value-of select="$table_count+1"/>
      </a>
      defines the classes to which each ARM element belongs.
      Table 
      <a href="#cc_mim_table">
        <xsl:value-of select="$table_count+2"/>
      </a>
      defines the classes to which each MIM element belongs.
    </p>    

    <xsl:apply-templates select="$ccs_xml/conformance/cc" mode="scope"/>

    <xsl:apply-templates select="$ccs_xml/conformance" mode="tables">
      <xsl:with-param name="table_number" select="$table_count+1"/>
    </xsl:apply-templates>
    
  </xsl:template>

  <xsl:template match="conformance" mode="tables">
    <xsl:param name="table_number" select="0"/>
    <div align="center">
      <p>
        <b>
          <a name="cc_arm_table">
            Table 
            <xsl:value-of select="$table_number"/>
            &#8212; Conformance class ARM elements
          </a>
        </b>
      </p>
    </div>
    <xsl:apply-templates select="." mode="arm_table"/>

    <div align="center">
      <p>
        <b>
          <a name="cc_mim_table">
            Table 
            <xsl:value-of select="$table_number+1"/>
            &#8212; Conformance class MIM elements
          </a>
        </b>
      </p>
    </div>
    <xsl:apply-templates select="." mode="mim_table"/>
  </xsl:template>

  <xsl:template match="conformance" mode="arm_table">
    <xsl:variable name="no_of_ccs" select="count(/conformance/cc)"/>
    <div align="center">
      <table border="1" cellspacing="1">
        <tr>
          <td rowspan="2"><b>ARM entity</b></td>
          <td colspan="{$no_of_ccs}">
            <b>Conformance class</b>
          </td>
        </tr>
        <tr>
          <xsl:apply-templates select="/conformance/cc" mode="td_title"/>
        </tr>
        <xsl:apply-templates select="." mode="cc_arm_table"/>
      </table>
    </div>
  </xsl:template>

  <xsl:template match="conformance" mode="mim_table">
    <xsl:variable name="no_of_ccs" select="count(/conformance/cc)"/>
    <div align="center">
      <table border="1" cellspacing="1">
        <tr>
          <td rowspan="2"><b>MIM entity</b></td>
          <td colspan="{$no_of_ccs}">
            <b>Conformance class</b>
          </td>
        </tr>
        <tr>
          <xsl:apply-templates select="/conformance/cc" mode="td_title"/>
        </tr>
        <xsl:apply-templates select="." mode="cc_mim_table"/>
      </table>
    </div>
  </xsl:template>


  
  <!-- the first conformance class is the complete module, so list all the
       entities from the long form -->
  <xsl:template match="conformance" mode="cc_arm_table">
    <xsl:variable name="cc1_module" select="cc[1]/@module"/>
    <xsl:variable name="module_ok">
      <xsl:call-template name="check_module_exists">
        <xsl:with-param name="module" select="$cc1_module"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$module_ok='true'">
        <xsl:variable name="ap_module_dir">
          <xsl:call-template name="ap_module_directory">
            <xsl:with-param name="application_protocol" select="$cc1_module"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="ap_arm_lf"
          select="document(concat($ap_module_dir,'/arm_lf.xml'))"/> 
        <xsl:if test="count($ap_arm_lf//entity)=0">
          <xsl:call-template name="error_message">
            <xsl:with-param name="message">
              <xsl:value-of select="concat('Error APCC2: The module
                                    ',$cc1_module,' does not have an ARM
long form defined. This is required in order to present the first
conformance class')"/>
          </xsl:with-param>
        </xsl:call-template>

        </xsl:if>
        
        <!-- collect entities and sort -->
        <xsl:variable name="entities">
	  <xsl:for-each select="cc">
	    <xsl:variable name="arm_lf" select="document(concat('../../data/modules/',@module,'/arm_lf.xml'))"/>
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
	    <xsl:for-each select="$arm_lf//entity">
	      <xsl:element name="entity">
		<xsl:attribute name="name">
		  <xsl:value-of select="@name"/>
		</xsl:attribute>
	      </xsl:element>
	    </xsl:for-each>
	    <xsl:for-each select="//arm_entity_in_cc">
	      <!-- only add if not in cc1 long form -->
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
            <xsl:value-of select="concat('Error APCC1: The module ',$cc1_module,' does not exist.',
                                  '  Correct CC module_name in ccs.xml')"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- the first conformance class is the complete module, so list all the
       entities from the long form -->
  <xsl:template match="conformance" mode="cc_mim_table">
    <xsl:variable name="cc1_module" select="cc[1]/@module"/>
    <xsl:variable name="module_ok">
      <xsl:call-template name="check_module_exists">
        <xsl:with-param name="module" select="$cc1_module"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$module_ok='true'">
        <xsl:variable name="module_dir">
          <xsl:call-template name="ap_module_directory">
            <xsl:with-param name="application_protocol" select="$cc1_module"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="ap_mim_lf"
          select="document(concat($module_dir,'/mim_lf.xml'))"/>
        <xsl:if test="count($ap_mim_lf//entity)=0">
          <xsl:call-template name="error_message">
            <xsl:with-param name="message">
              <xsl:value-of select="concat('Error APCC2: The module
                                    ',$cc1_module,' does not have an MIM
long form defined. This is required in order to present the first
conformance class')"/>
          </xsl:with-param>
        </xsl:call-template>

        </xsl:if>
        
        <!-- collect entities and sort -->
        <xsl:variable name="entities">
	  <xsl:for-each select="cc">
	    <xsl:variable name="mim_lf" select="document(concat('../../data/modules/',@module,'/mim_lf.xml'))"/>
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
		  <xsl:when test="//mim_entity_in_cc/cc_id[@id=$cc_id]">
		    <xsl:value-of select="'yes'"/>
		  </xsl:when>
		  <xsl:otherwise>
		    <xsl:value-of select="'no'"/>
		  </xsl:otherwise>
		</xsl:choose>
	      </xsl:attribute>
	      <xsl:for-each select="$mim_lf//entity">
		<xsl:element name="entity">
		  <xsl:attribute name="name">
		    <xsl:value-of select="@name"/>
		  </xsl:attribute>
		  <xsl:attribute name="cc">
		    <xsl:value-of select="'1'"/>
		  </xsl:attribute>
		</xsl:element>
	      </xsl:for-each>
	      <xsl:for-each select="//mim_entity_in_cc">
		<!-- only add if not in cc1 long form -->
		<xsl:variable name="lname" select="@name"/>
		<xsl:if test="not($mim_lf//entity[@name=$lname])">
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
	    </xsl:element>
	  </xsl:for-each>
	</xsl:variable>

        <xsl:choose>
          <xsl:when test="function-available('msxsl:node-set')">
            <xsl:variable name="entities_node_set" select="msxsl:node-set($entities)"/>
            <xsl:call-template name="output_cc_mim_row">
              <xsl:with-param name="entities_node_set" select="$entities_node_set"/>
              <xsl:with-param name="conformance_node_set" select="/conformance"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="function-available('exslt:node-set')">
            <xsl:variable name="entities_node_set" select="exslt:node-set($entities)"/>
            <xsl:call-template name="output_cc_mim_row">
              <xsl:with-param name="entities_node_set" select="$entities_node_set"/>
              <xsl:with-param name="conformance_node_set" select="/conformance"/>
            </xsl:call-template>
          </xsl:when>
        </xsl:choose>
      </xsl:when>

      <xsl:otherwise>
        <xsl:call-template name="error_message">
          <xsl:with-param name="message">
            <xsl:value-of select="concat('Error APCC1: The module ',$cc1_module,' does not exist.',
                                  '  Correct CC module_name in ccs.xml')"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="output_cc_arm_row">
    <xsl:param name="entities_node_set"/>
    <xsl:param name="conformance_node_set"/>
    <xsl:variable name="ccs" select="$conformance_node_set/cc"/>
    <xsl:variable name="arms_in_ccs" select="$conformance_node_set/arms_in_ccs"/>
    <xsl:for-each select="$entities_node_set/cc[1]/*">
      <xsl:sort select="@name"/>
      <xsl:variable name="lname" select="@name"/>
      <tr>
        <td align="left">
          <xsl:value-of select="$lname"/>
        </td>
        <!-- output CC1 -->
        <xsl:choose>
          <xsl:when test="../@cc='1'">
            <td>
              <img align="middle" border="0" alt="X"
                src="../../../../images/bullet.gif"/>
            </td>
          </xsl:when>
          <xsl:otherwise>
            <td>&#160;</td>
          </xsl:otherwise>
        </xsl:choose>
        <!-- output rest of CCs 
             check if the entity is referenced in CCs other than 1
             -->
        <xsl:choose>
          <xsl:when test="$arms_in_ccs/arm_entity_in_cc[@name=$lname] or $entities_node_set/cc[position()>1]/entity[@name=$lname]">
<!--	    <xsl:apply-templates select="$arms_in_ccs/arm_entity_in_cc[@name=$lname]" mode="cc_table1"/> -->

            <xsl:apply-templates select="." mode="cc_table_new">
	      <xsl:with-param name="entity_in_ccs" select="$arms_in_ccs"/>
	      <xsl:with-param name="entities_node_set" select="$entities_node_set"/>
	    </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="$ccs" mode="blanks"/>
          </xsl:otherwise>
        </xsl:choose>
      </tr>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="output_cc_mim_row">
    <xsl:param name="entities_node_set"/>
    <xsl:param name="conformance_node_set"/>
    <xsl:variable name="ccs" select="$conformance_node_set/cc"/>
    <xsl:variable name="mims_in_ccs" select="$conformance_node_set/mims_in_ccs"/>
    <xsl:for-each select="$entities_node_set/cc[1]/*">
      <xsl:sort select="@name"/>
      <xsl:variable name="lname" select="@name"/>
      <tr>
        <td align="left">
          <xsl:value-of select="$lname"/>
        </td>
        <!-- output CC1 -->
        <xsl:choose>
          <xsl:when test="../@cc='1'">
            <td>
              <img align="middle" border="0" alt="X"
                src="../../../../images/bullet.gif"/>
            </td>
          </xsl:when>
          <xsl:otherwise>
            <td>&#160;</td>
          </xsl:otherwise>
        </xsl:choose>
        <!-- output rest of CCs 
             check if the entity is referenced in CCs other than 1
             -->
        <xsl:choose>
          <xsl:when test="$mims_in_ccs/mim_entity_in_cc[@name=$lname]  or  $entities_node_set/cc[position()>1]/entity[@name=$lname]">
            <xsl:apply-templates select="." mode="cc_table_new">
	      <xsl:with-param name="entity_in_ccs" select="$mims_in_ccs"/>
	      <xsl:with-param name="entities_node_set" select="$entities_node_set"/>
	    </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="$ccs" mode="blanks"/>
          </xsl:otherwise>
        </xsl:choose>
      </tr>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="cc" mode="blanks">
    <xsl:if test="position() != 1">
      <td>&#160;</td>
    </xsl:if>
  </xsl:template>

  <xsl:template match="arm_entity_in_cc|mim_entity_in_cc" mode="cc_table1">
      <xsl:apply-templates select="/conformance/cc" mode="td_entity">
        <xsl:with-param name="entity_in_cc" select="current()"/>
      </xsl:apply-templates>
  </xsl:template>


  <xsl:template match="arm_entity_in_cc|mim_entity_in_cc" mode="cc_table_new">
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
    <xsl:if test="position() != 1">
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
    </xsl:if>
  </xsl:template>

  <xsl:template match="entity" mode="cc_table_new">
    <xsl:param name="entity_in_ccs"/>
    <xsl:param name="entities_node_set"/>
    <xsl:variable name="lname" select="@name"/>
    <xsl:for-each select="//cc[position() != 1]">
      <xsl:variable name="ipos" select="position()"/>
      <xsl:variable name="cc_pos" select="@cc_pos"/>
      <xsl:variable name="cc_id" select="@cc_id"/>
	<td>
	<xsl:choose>
	  <xsl:when test="../cc/@entity_in_cc='yes' and $entity_in_ccs/*[@name=$lname]/cc_id[@id=$cc_id]">
<img align="middle" border="0" alt="X" src="../../../../images/bullet.gif"/>
	  </xsl:when>
	  <xsl:when test="../cc/@entity_in_cc='no' and $entities_node_set/cc[$ipos + 1]/entity[@name=$lname]">
<img align="middle" border="0" alt="X" src="../../../../images/bullet.gif"/>
	  </xsl:when>
	  <xsl:otherwise>
	    &#160;
	  </xsl:otherwise>
	</xsl:choose>
	</td>
    </xsl:for-each>
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

    <p>
      The conformance class 
      <b>
        <xsl:value-of select="@name"/>
      </b>
      has been declared against the module: 
      <xsl:choose>
        <xsl:when test="$module_ok='true'">
          <xsl:variable name="module_dir">
            <xsl:call-template name="ap_module_directory">
              <xsl:with-param name="application_protocol" select="$module"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="module_node"
            select="document(concat($module_dir,'/module.xml'))/module"/>
          <a href="../../../modules/{$module}/sys/cover{$FILE_EXT}">
            <xsl:call-template name="module_display_name">
              <xsl:with-param name="module" select="$module_node/@name"/>
            </xsl:call-template>
          </a>
          (ISO 10303-<xsl:value-of select="$module_node/@part"/>).
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
    </p>
    <xsl:if test="position()=1">
      <p class="note">
        <small>
          NOTE&#160;&#160;Conformance to 
          <b><xsl:value-of select="@name"/></b>
          requires that all ARM and MIM elements defined in the AP module 
          <xsl:choose>
            <xsl:when test="$module_ok='true'">
              <xsl:variable name="module_dir">
                <xsl:call-template name="ap_module_directory">
                  <xsl:with-param name="application_protocol" select="$module"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:variable name="module_node"
                select="document(concat($module_dir,'/module.xml'))/module"/>              
              (<a href="../../../modules/{$module}/sys/cover{$FILE_EXT}">ISO 10303-<xsl:value-of select="$module_node/@part"/></a>)
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="error_message">
                <xsl:with-param name="message">
                  <xsl:value-of select="concat('Error APCC1: The module ',$module,' does not exist.',
                                        '  Correct CC module_name in ccs.xml')"/>
                </xsl:with-param>
              </xsl:call-template>
              (??),
            </xsl:otherwise>
          </xsl:choose>
          be supported.
        </small>
      </p>
    </xsl:if>
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
    <xsl:if test="$module_ok!='true'">
      <xsl:call-template name="error_message">
        <xsl:with-param name="message">
          <xsl:value-of select="concat('Error APCC1: The module ',$module,' does not exist.',
                                '  Correct CC module_name in ccs.xml')"/>
        </xsl:with-param>
      </xsl:call-template>      
    </xsl:if>

    <xsl:if test="./@from_module!='NO'">
      <!-- output the scope statements from the module -->
      <xsl:if test="$module_ok='true'">
        <xsl:variable name="module_dir">
          <xsl:call-template name="ap_module_directory">
            <xsl:with-param name="application_protocol" select="$module"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="module_xml" select="document(concat($module_dir,'/module.xml'))"/>
        <xsl:if test="$module_xml/module/inscope/li">
          <ul>
            <xsl:apply-templates select="$module_xml/module/inscope/li"/>
          </ul>
        </xsl:if>
      </xsl:if>
    </xsl:if>
        
    <!-- output the scope statements from the AP doc -->
    <xsl:if test="./li">
      <ul>
        <xsl:apply-templates select="li"/>
      </ul>
    </xsl:if>
    
  </xsl:template>


</xsl:stylesheet>
