<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_6_ccs.xsl 1660 2007-11-12 14:28:33Z GiedriusLiutkus $
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
  <xsl:variable name="cc_index" select="1"/>
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
    
    <h2>
      <a name="$6.1">
        <xsl:value-of select="concat('6.1',' Conformance classes')"/> 
      </a>
    </h2>
   
    <xsl:choose>
      <xsl:when test="count($ccs_xml/conformance/cc)=1">
        <p>
          This part of ISO 10303 provides for only one conformance class that may be
          supported by an implementation: 
        </p>
        <ul>
          <xsl:apply-templates
            select="$ccs_xml/conformance/cc" mode="summary"/>
        </ul>        

        <p>
          Support for a particular conformance class requires support of all the mandatory elements specified
          in that class.
          <xsl:choose>
            <xsl:when test="$module_ok='true'">
              <xsl:variable name="module_dir">
                <xsl:call-template name="ap_module_directory">
                  <xsl:with-param name="application_protocol" select="$module"/>
                </xsl:call-template>
              </xsl:variable>
	      <xsl:variable name="module_node"
			    select="document(concat($module_dir,'/module.xml'))/module"/> 
<!--	      (<a href="../../../modules/{$module}/sys/cover{$FILE_EXT}">ISO 10303-<xsl:value-of select="$module_node/@part"/></a>). -->
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
      <xsl:when test="count($ccs_xml/conformance/cc)>1">
        <p>
          This part of ISO 10303 provides for a number of conformance classes that may be
          supported by an implementation: 
        </p>  
        <ul>
          <xsl:apply-templates
            select="$ccs_xml/conformance/cc" mode="summary"/>
        </ul>        
        <p>
          Support for a particular conformance class requires support of all the mandatory elements specified
          in that class.
        </p>
      </xsl:when>  
      <xsl:otherwise>
        No conformance class defined.
      </xsl:otherwise> 
    </xsl:choose>

    <xsl:variable name="table_count">
      <xsl:apply-templates select="." mode="table_count_cc"/>
    </xsl:variable>
    <xsl:if test="count($ccs_xml/conformance/cc)>0"> 
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

    <xsl:apply-templates select="$ccs_xml/conformance/cc" mode="scope">
      <xsl:with-param name="top_module" select="$module"/>
    </xsl:apply-templates>

      <!-- Conformance Options -->
      <xsl:if test="count($ccs_xml/conformance/co) > 0">
        <xsl:apply-templates
          select="$ccs_xml/conformance" mode="co_summary"/>  
      </xsl:if>
      <xsl:apply-templates select="$ccs_xml/conformance/co" mode="summary"/> 
      <!-- ENDOF Conformance Options -->    
      
    <xsl:apply-templates select="$ccs_xml/conformance" mode="tables">
      <xsl:with-param name="table_number" select="$table_count+1"/>
      <xsl:with-param name="top_module" select="$module"/>
    </xsl:apply-templates>
    </xsl:if> 

  </xsl:template>

  <xsl:template match="conformance" mode="tables">
    <xsl:param name="table_number" select="0"/>
    <xsl:param name="top_module"/>
    <div align="center">
      <p>
        <b>
          <a name="cc_arm_table">
            Table 
            <xsl:value-of select="$table_number"/>
            &#8212; Conformance class(es) and option(s) ARM elements
          </a>
        </b>
      </p>
    </div>
    <xsl:apply-templates select="." mode="arm_table">
      <xsl:with-param name="top_module" select="$top_module"/>
    </xsl:apply-templates>

    <div align="center">
      <p>
        <b>
          <a name="cc_mim_table">
            Table 
            <xsl:value-of select="$table_number+1"/>
            &#8212; Conformance class(es) and option(s) MIM elements
          </a>
        </b>
      </p>
    </div>
    <xsl:apply-templates select="." mode="mim_table">
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

  <xsl:template match="conformance" mode="mim_table">
    <xsl:param name="top_module"/>
    <xsl:variable name="no_of_ccs" select="count(/conformance/cc)"/>
    <xsl:variable name="no_of_cos" select="count(/conformance/co)"/>
    <div align="center">
      <table border="1" cellspacing="1">
        <tr>
          <td rowspan="2"><b>MIM entity</b></td>
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
        <xsl:apply-templates select="." mode="cc_mim_table">
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
  
  <!-- the first conformance class is the complete module, so list all the
       entities from the long form -->
  <xsl:template match="conformance" mode="cc_mim_table">
    <xsl:param name="top_module"/>
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
        
        <xsl:variable name="ap_mim_lf"
          select="document(concat($ap_module_dir,'/mim_lf.xml'))"/> 
        <xsl:if test="count($ap_mim_lf//entity)=0">
          <xsl:call-template name="error_message">
            <xsl:with-param name="message">
              <xsl:value-of select="concat('Error APCC2: The module
                ',$top_module,' does not have an MIM
long form defined. This is required in order to present the first
conformance class')"/>
          </xsl:with-param> 
        </xsl:call-template>
        </xsl:if> 

        <!-- collect entities and sort -->
        <xsl:variable name="entities">
          <!-- Now we are no longer dependent on CC, we have explicit top_schema where we take entities from -->
          <xsl:element name="top_schema">
            <xsl:for-each select="$ap_mim_lf//entity">
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
		  <xsl:when test="//mim_entity_in_cc/cc_id[@id=$cc_id]">
		    <xsl:value-of select="'yes'"/>
		  </xsl:when>
		  <xsl:otherwise>
		    <xsl:value-of select="'no'"/>
		  </xsl:otherwise>
		</xsl:choose>
	      </xsl:attribute>
	      <xsl:if test="$lf_exists='true'">
	        <xsl:variable name="mim_lf" select="document(concat('../../data/modules/',@module,'/mim_lf.xml'))"/>
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
	      </xsl:if>  
	      <xsl:for-each select="//mim_entity_in_cc"> 
		<!-- only add if not in cc1 long form -->
		<xsl:variable name="lname" select="@name"/>
	           <xsl:for-each select="@module">
	             <xsl:variable name="mim_xml">
	               "document(concat('../../data/modules/',@module,'/mim.xml'))"
	             </xsl:variable>
	             <xsl:if test="not($mim_xml//entity[@name=$lname])">
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
                  <xsl:when test="//mim_entity_in_cc/co_ref[@name=$co_name]">
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
            <xsl:value-of select="concat('Error APCC1: The module ',$top_module,' does not exist.',
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

  <xsl:template name="output_cc_mim_row">
    <xsl:param name="entities_node_set"/>
    <xsl:param name="conformance_node_set"/>
    <xsl:variable name="ccs" select="$conformance_node_set/cc"/>
    <xsl:variable name="cos" select="$conformance_node_set/co"/>
    <xsl:variable name="top_module" select="$conformance_node_set/top_module"/>
    <xsl:variable name="mims_in_ccs" select="$conformance_node_set/mims_in_ccs"/>
    <xsl:for-each select="$entities_node_set/top_schema/*">
      <xsl:sort select="@name"/>
      <xsl:variable name="lname" select="@name"/>
      <tr>
        <td align="left">
          <xsl:value-of select="$lname"/>
        </td>
        <!-- output CC1 -->
<!--        <xsl:choose>
          <xsl:when test="../@cc='1'">
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
          <xsl:when test="$mims_in_ccs/mim_entity_in_cc[@name=$lname]  or  $entities_node_set/cc/entity[@name=$lname] or $entities_node_set/co/entity[@name=$lname]">            
            <xsl:apply-templates select="." mode="cc_table_new">
	      <xsl:with-param name="entity_in_ccs" select="$mims_in_ccs"/>
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

  <xsl:template match="cc" mode="blanks">
<!--    <xsl:if test="position() != 1"> -->
      <td>&#160;</td>
<!--    </xsl:if> -->
  </xsl:template>

  <xsl:template match="co" mode="blanks">
      <td>&#160;</td>
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
    <xsl:param name="top_module"/>    
    <xsl:variable name="top_module_ok">
      <xsl:call-template name="check_module_exists">
        <xsl:with-param name="module" select="$top_module"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="module_ok">
      <xsl:call-template name="check_module_exists">
        <xsl:with-param name="module" select="@module"/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="aname" select="concat('cc_',@id)"/>

    <h3>
      <a name="{$aname}">
        <xsl:value-of select="concat('6.1.',position(),' Conformance class for ',@name,' (',@id,')')"/> 
      </a>
    </h3>

    <p>
      The conformance class 
      <b>
        <xsl:value-of select="@name"/>
      </b>
      has been declared against  
      <xsl:choose>
        <xsl:when test="$module_ok='true'">
          the application module
          <xsl:variable name="module_dir">
            <xsl:call-template name="ap_module_directory">
              <xsl:with-param name="application_protocol" select="@module"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="module_node"
            select="document(concat($module_dir,'/module.xml'))/module"/>
          <a href="../../../modules/{@module}/sys/cover{$FILE_EXT}">
            <xsl:call-template name="module_display_name">
              <xsl:with-param name="module" select="$module_node/@name"/>
            </xsl:call-template>
          </a>,
          ISO/<xsl:value-of select="$module_node/@status"/> 10303 -<xsl:value-of select="$module_node/@part"/>.
        </xsl:when>
        <xsl:when test="$top_module_ok='true'">
          the application module
          <xsl:variable name="module_dir">
            <xsl:call-template name="ap_module_directory">
              <xsl:with-param name="application_protocol" select="$top_module"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="module_node"
            select="document(concat($module_dir,'/module.xml'))/module"/>
          <a href="../../../modules/{$top_module}/sys/cover{$FILE_EXT}">
            <xsl:call-template name="module_display_name">
              <xsl:with-param name="module" select="$module_node/@name"/>
            </xsl:call-template>
          </a>,
          ISO/<xsl:value-of select="$module_node/@status"/> 10303 -<xsl:value-of select="$module_node/@part"/>.
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="error_message">
            <xsl:with-param name="message">
              <xsl:value-of select="concat('Error APCC1: The module ',$top_module,' does not exist.',
                                    '  Correct CC module_name in ccs.xml')"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </p>
    <xsl:apply-templates select="./inscope"/>
    <p>
      <xsl:apply-templates select="description"/>
    </p> 
    <xsl:variable name="module_count" select="count(module)"/>
    <xsl:if test="$module_count > 0">
      Conformance to this conformance class requires support of all ARM and MIM elements defined in application modules:
      <ul>       
      <xsl:for-each select="module">
        <xsl:variable name="module_dir">
          <xsl:call-template name="ap_module_directory">
            <xsl:with-param name="application_protocol" select="@name"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="module_node"
        select="document(concat($module_dir,'/module.xml'))/module"/>
      <li>
        <xsl:choose>
          <xsl:when test="position() != $module_count">
            <a href="../../../modules/{@name}/sys/cover{$FILE_EXT}">
              <xsl:call-template name="module_display_name">
                <xsl:with-param name="module" select="$module_node/@name"/>
              </xsl:call-template>
            </a>,
            ISO/<xsl:value-of select="$module_node/@status"/> 10303-<xsl:value-of select="$module_node/@part"/>;
          </xsl:when>
          <xsl:otherwise>
            <a href="../../../modules/{@name}/sys/cover{$FILE_EXT}">
              <xsl:call-template name="module_display_name">
                <xsl:with-param name="module" select="$module_node/@name"/>
              </xsl:call-template>
            </a>,
            ISO/<xsl:value-of select="$module_node/@status"/> 10303-<xsl:value-of select="$module_node/@part"/>.
          </xsl:otherwise>
        </xsl:choose>
      </li>
      </xsl:for-each>        
      </ul>
    </xsl:if>
    
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
  <!-- GL added support for Conformance options -->
  <xsl:template match="co" mode="summary">
      <p>
      Conformance option <xsl:value-of select="@id"/> (<xsl:value-of select="@name"/>) has the following modules:
      <xsl:for-each select="module">
          <li>
            <xsl:value-of select="@name"/>
          </li>
      </xsl:for-each>
     </p>    
    <p>
      <xsl:for-each select="arms_in_co">
        <xsl:if test="count(arm_entity_in_co) > 0">
          Conformance option also have the following entities:
          <xsl:for-each select="arm_entity_in_co">
            <li>
              <xsl:value-of select="@name"/>
            </li>
          </xsl:for-each>
        </xsl:if>
      </xsl:for-each>        
    </p>
  </xsl:template>

  <xsl:variable name="no_of_co" select="count(/conformance/co)"/>
  
<!-- Real introduction into Conformance options -->
  <xsl:template match="conformance" mode="co_summary">
    <h2>
      <a name="6.2">
        <xsl:value-of select="concat('6.2',' Conformance options')"/> 
      </a>
    </h2> 
    <p>
    Implementations may choose to implement some of the following conformance options 
    in addition to one or more of the above conformance classes.
    </p> <p>
    Conformance to a particular conformance option requires that all ARM and MIM 
    elements defined as part of that option be supported. 
    Table 
    <a href="#cc_arm_table">
      <xsl:value-of select="1"/>
    </a>
    defines the conformance options to which each ARM element belongs. 
    Table
    <a href="#cc_mim_table">
      <xsl:value-of select="2"/>
    </a>
    defines the conformance options to which each MIM element belongs.
    </p>
  </xsl:template>

  <xsl:template match="co" mode="summary">
    <xsl:variable name="aname" select="concat('co_',translate(@name,'&#x9;&#xA;&#x20;&#xD;',''))"/>
    <h3>
      <a name="{$aname}">
        <xsl:value-of select="concat('6.2.',position(),'  Conformance option for ',@name,' (co',position(),')')"/> 
      </a>
    </h3>
    <p>
      <xsl:apply-templates select="description"/>
    </p>
    <p>
    <!-- CO referencing other COs-->
      <xsl:variable name="count_of_cos" select="count(co_ref)"/>      
    <xsl:if test="$count_of_cos > 0">
      Conformance to this conformance option requires also support of the underlying conformance
      <xsl:choose>
        <xsl:when test="$count_of_cos > 1">
          options:
          <ul>
          <xsl:for-each select="co_ref">
            <li>
              <xsl:choose>
                <xsl:when test="$count_of_cos != position()">
                  <a href="#{concat('co_',translate(@name,'&#x9;&#xA;&#x20;&#xD;',''))}">
                    <xsl:value-of select="@name"/>
                  </a>;
                </xsl:when>
                <xsl:otherwise>
                  <a href="#{concat('co_',translate(@name,'&#x9;&#xA;&#x20;&#xD;',''))}">
                    <xsl:value-of select="@name"/>
                  </a>.
                </xsl:otherwise>
              </xsl:choose>
            </li>
          </xsl:for-each>
          </ul>
        </xsl:when>
        <xsl:otherwise>
          option <a href="#{concat('co_',translate(co_ref/@name,'&#x9;&#xA;&#x20;&#xD;',''))}"> <xsl:value-of select="co_ref/@name"/> </a>.
        </xsl:otherwise>
      </xsl:choose>  
    </xsl:if>
    </p>  
    <!-- CO referencing modules-->
    <xsl:variable name="count_of_modules" select="count(module)"/>    
    <xsl:if test="$count_of_modules > 0">
        Conformance to this conformance option requires support of the elements defined in application module(s):
        <ul>        
        <xsl:for-each select="module">
          <xsl:variable name="module_dir">
            <xsl:call-template name="ap_module_directory">
              <xsl:with-param name="application_protocol" select="@name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="module_node"
            select="document(concat($module_dir,'/module.xml'))/module"/>
          
            <xsl:choose>
              <xsl:when test="@completness='complete'">
                <li>
                  <xsl:choose>
                    <xsl:when test="$count_of_modules != position()">
                      <a href="../../../modules/{@name}/sys/cover{$FILE_EXT}">
                        <xsl:call-template name="module_display_name">
                          <xsl:with-param name="module" select="$module_node/@name"/>
                        </xsl:call-template>
                      </a>,
                      ISO/<xsl:value-of select="$module_node/@status"/> 10303-<xsl:value-of select="$module_node/@part"/>, all ARM and MIM elements;
                    </xsl:when>  
                    <xsl:otherwise>
                      <a href="../../../modules/{@name}/sys/cover{$FILE_EXT}">
                        <xsl:call-template name="module_display_name">
                          <xsl:with-param name="module" select="$module_node/@name"/>
                        </xsl:call-template>
                      </a>,
                      ISO/<xsl:value-of select="$module_node/@status"/> 10303-<xsl:value-of select="$module_node/@part"/>, all ARM and MIM elements.
                    </xsl:otherwise>
                  </xsl:choose>
                </li> 
              </xsl:when>
              <xsl:when test="@completness = 'selective'">
                <xsl:variable name="arm_entity_count" select="count(arm_entity)"/>
                <xsl:choose>
                  <xsl:when test="$arm_entity_count > 0">
                <li>
                  <a href="../../../modules/{@name}/sys/cover{$FILE_EXT}">
                    <xsl:call-template name="module_display_name">
                      <xsl:with-param name="module" select="$module_node/@name"/>
                    </xsl:call-template>
                  </a>,
                      ISO/<xsl:value-of select="$module_node/@status"/> 10303-<xsl:value-of select="$module_node/@part"/>, selective ARM element(s):
                </li>
                <ul>
                <xsl:for-each select="arm_entity">
                  <li> 
                    <xsl:choose>
                      <xsl:when test="$arm_entity_count != position()">
                        <xsl:apply-templates select="express_ref"/>;
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:apply-templates select="express_ref"/>.
                      </xsl:otherwise>
                    </xsl:choose>
                  </li>
                </xsl:for-each>
                </ul>
                  </xsl:when> 
                </xsl:choose>
                <xsl:variable name="mim_entity_count" select="count(mim_entity)"/>
                <xsl:choose>
                  <xsl:when test="$mim_entity_count > 0">
                <li>
                  <a href="../../../modules/{@name}/sys/cover{$FILE_EXT}">
                    <xsl:call-template name="module_display_name">
                      <xsl:with-param name="module" select="$module_node/@name"/>
                    </xsl:call-template>
                  </a>,
                  ISO/<xsl:value-of select="$module_node/@status"/> 10303-<xsl:value-of select="$module_node/@part"/>, selective MIM element(s):
                </li>
                <ul>                  
                  <xsl:for-each select="mim_entity">
                    <li> 
                      <xsl:choose>
                        <xsl:when test="$mim_entity_count != position()">
                          <xsl:apply-templates select="express_ref"/>;
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:apply-templates select="express_ref"/>.
                        </xsl:otherwise>
                      </xsl:choose>
                    </li>
                  </xsl:for-each>
                </ul> 
               </xsl:when> 
             </xsl:choose>
              </xsl:when>  
              <xsl:otherwise>
                <xsl:variable name="arm_entity_count" select="count(arm_entity)"/>
                <xsl:choose>
                  <xsl:when test="$arm_entity_count > 0">
                <li>
                  <a href="../../../modules/{@name}/sys/cover{$FILE_EXT}">
                    <xsl:call-template name="module_display_name">
                      <xsl:with-param name="module" select="$module_node/@name"/>
                    </xsl:call-template>
                  </a>,
                  ISO/<xsl:value-of select="$module_node/@status"/> 10303-<xsl:value-of select="$module_node/@part"/>, all ARM elements, except:
                </li>
                <ul>
                  <xsl:for-each select="arm_entity">
                    <li> 
                      <xsl:choose>
                        <xsl:when test="$arm_entity_count != position()">
                          <xsl:apply-templates select="express_ref"/>;
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:apply-templates select="express_ref"/>.
                        </xsl:otherwise>
                      </xsl:choose>
                    </li>
                  </xsl:for-each>
                </ul>
                  </xsl:when>
                  <xsl:otherwise>
                    <li>
                      <a href="../../../modules/{@name}/sys/cover{$FILE_EXT}">
                        <xsl:call-template name="module_display_name">
                          <xsl:with-param name="module" select="$module_node/@name"/>
                        </xsl:call-template>
                      </a>,
                      ISO/<xsl:value-of select="$module_node/@status"/> 10303-<xsl:value-of select="$module_node/@part"/>, all ARM elements;
                    </li>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:variable name="mim_entity_count" select="count(mim_entity)"/>
                <xsl:choose>
                  <xsl:when test="$mim_entity_count > 0">
                <li>
                  <a href="../../../modules/{@name}/sys/cover{$FILE_EXT}">
                    <xsl:call-template name="module_display_name">
                      <xsl:with-param name="module" select="$module_node/@name"/>
                    </xsl:call-template>
                  </a>,
                  ISO/<xsl:value-of select="$module_node/@status"/> 10303-<xsl:value-of select="$module_node/@part"/>, all MIM elements, except:
                </li>                  
                <ul>
                  <xsl:for-each select="mim_entity">
                    <li> 
                      <xsl:choose>
                        <xsl:when test="$mim_entity_count != position()">
                          <xsl:apply-templates select="express_ref"/>;
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:apply-templates select="express_ref"/>.
                        </xsl:otherwise>
                      </xsl:choose>
                    </li>
                  </xsl:for-each>
                </ul> 
                  </xsl:when>
                  <xsl:otherwise>
                    <li>
                      <a href="../../../modules/{@name}/sys/cover{$FILE_EXT}">
                        <xsl:call-template name="module_display_name">
                          <xsl:with-param name="module" select="$module_node/@name"/>
                        </xsl:call-template>
                      </a>,
                      ISO/<xsl:value-of select="$module_node/@status"/> 10303-<xsl:value-of select="$module_node/@part"/>, all MIM elements
                    </li>            
                    	<xsl:choose>      
								<xsl:when test="$count_of_modules != position()">;</xsl:when>
                  	<xsl:otherwise>.</xsl:otherwise>
							</xsl:choose>							
                  </xsl:otherwise>
                  </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        </ul>          
      </xsl:if>
    <p/>
    <!-- CO referencing entities explicitly -->
    <xsl:if test="count(arm_entity) > 0">
      The conformance option <xsl:value-of select="@id"/> also requires support of 
      <xsl:choose>
        <xsl:when test="count(arm_entity) > 1">
          those entities:
          <xsl:for-each select="arm_entity">
            <li>
              <xsl:apply-templates select="express_ref"/>
            </li>
          </xsl:for-each>              
        </xsl:when>
        <xsl:otherwise>
          this entity - <xsl:apply-templates select="arm_entity/express_ref"/>.
        </xsl:otherwise>
      </xsl:choose>  
    </xsl:if>
    
  </xsl:template>

  <xsl:template match="conformance" mode="arm_co_table">
    <xsl:variable name="no_of_cos" select="count(/conformance/co)"/>
    <div align="center">
      <table border="1" cellspacing="1">
        <tr>
          <td rowspan="2"><b>ARM entity  <xsl:value-of select="$no_of_cos"/></b></td>
          <td colspan="{$no_of_cos}">
            <b>Conformance option</b>
          </td>
        </tr>
        <tr>
          <xsl:apply-templates select="/conformance/co" mode="td_title"/>
        </tr>
<!--        <xsl:apply-templates select="." mode="co_arm_table"/> -->
      </table>
    </div>
  </xsl:template>

  <xsl:template match="co" mode="td_title">
    <xsl:variable name="href" select="concat('co_',translate(@name,'&#x9;&#xA;&#x20;&#xD;',''))"/> <!-- position())"/> -->
    <td>
      <b>
        <a href="#{$href}">
          co<xsl:value-of select="position()"/>
        </a>
      </b>
    </td>
  </xsl:template>

</xsl:stylesheet>
