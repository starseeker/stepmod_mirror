<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
     $Id: application_protocol.xsl,v 1.20 2003/05/21 14:37:13 robbod Exp $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="../module.xsl"/>
	<xsl:import href="application_protocol_toc.xsl"/>
	<xsl:import href="sect_4_express.xsl"/>
	<xsl:import href="projmg/issues.xsl"/>
	<xsl:output method="html" doctype-system="http://www.w3.org/TR/html4/loose.dtd" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" indent="yes"/>

	<xsl:template match="/">
          <HTML>
			<HEAD>
      	<TITLE>
       		 		<xsl:apply-templates select="./application_protocol" mode="title"/>
      	</TITLE>
			</HEAD>
    			<BODY>
      				<xsl:apply-templates select="./application_protocol" mode="TOCsinglePage"/>
      				<xsl:apply-templates select="./application_protocol"/>
    			</BODY>
  		</HTML>
	</xsl:template>
	
	<!-- The templates for the display of each clause are partly in the files sect_xxx.xsl 
	The concept of priority between homonym templates is used to display either the application protocol
	file content or the ap module file content -->
	
	<xsl:template match="application_protocol" mode="title">
		<xsl:variable name="lpart">
			<xsl:choose>
				<xsl:when test="string-length(@part)>0">
					<xsl:value-of select="@part"/>
				</xsl:when>
				<xsl:otherwise>
					XXXX
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
                <!-- no longer permitted
		<xsl:choose>
			<xsl:when test="$output_rcs">
				<xsl:variable  name="date" select="translate(@rcs.date,'$','')"/>
				<xsl:variable name="rev" select="translate(@rcs.revision,'$','')"/>
				<xsl:value-of select="concat($lpart,' :- ',@name,'  (',$date,' ',$rev,')')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($lpart,' :- ',@name)"/>
			</xsl:otherwise>
		</xsl:choose> -->

                <xsl:variable name="stdnumber">
                  <xsl:call-template name="get_protocol_stdnumber">
                    <xsl:with-param name="application_protocol" select="."/>
                  </xsl:call-template>
                </xsl:variable>
                
                <xsl:variable name="protocol_name">
                  <xsl:call-template name="protocol_display_name">
                    <xsl:with-param name="application_protocol" select="@name"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat($stdnumber,' ',$protocol_name)"/>                
	</xsl:template>

  <xsl:template match="inscope">
    <p>
      <a name="inscope"/> 
      The following are within the scope of this part of ISO 10303: 
    </p>

    <xsl:variable name="module" select="/application_protocol/@module_name"/>
    <xsl:variable name="module_ok">
      <xsl:call-template name="check_module_exists">
        <xsl:with-param name="module" select="/application_protocol/@module_name"/>
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
              <xsl:value-of select="concat('Error AP1: The module ',$module,' does not exist.',
                                    '  Correct application_protocol module_name in application_protocol.xml')"/>
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
		
  <xsl:template match="outscope">
    <p>
      <a name="outscope"/>
      The following are outside the scope of this part of ISO 10303: 
    </p>
    <xsl:variable name="module" select="/application_protocol/@module_name"/>
    <xsl:variable name="module_ok">
      <xsl:call-template name="check_module_exists">
        <xsl:with-param name="module" select="/application_protocol/@module_name"/>
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
              <xsl:value-of select="concat('Error AP1: The module',$module,' does not exist.',
                                    '  Correct application_protocol module_name in application_protocol.xml')"/>
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

<!-- Annex G -->
	<xsl:template match="application_protocol" mode="annexg">
		<xsl:call-template name="annex_header">
			<xsl:with-param name="annex_no" select="'G'"/>
			<xsl:with-param name="heading" select="'Computer interpretable listings'"/>
			<xsl:with-param name="aname" select="'annexg'"/>
		</xsl:call-template>
		
			<xsl:variable name="ap_mod_dir">
		 <xsl:value-of select="concat('../../../modules/',@module_name)"/>
		</xsl:variable>
		<xsl:variable name="arm">
		 <xsl:value-of select="concat($ap_mod_dir,'/arm',$FILE_EXT)"/>
		</xsl:variable>
		
<!-- 		<xsl:variable name="arm_lf">
			<xsl:choose>
				<xsl:when test="$FILE_EXT='.xml'">
					<xsl:value-of select="'g_exp_arm_lf.xml'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'g_exp_arm_lf.htm'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable> -->

		<xsl:variable name="mim">
		 <xsl:value-of select="concat($ap_mod_dir,'/mim',$FILE_EXT)"/>
		</xsl:variable>
		
<!-- 		<xsl:variable name="aim_lf">
			<xsl:choose>
				<xsl:when test="$FILE_EXT='.xml'">
					<xsl:value-of select="'g_exp_aim_lf.xml'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'g_exp_aim_lf.htm'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable> -->
		
		<xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
		<xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>
		<xsl:variable name="aim_schema" select="translate(concat(@name,'_mim'),$LOWER, $UPPER)"/>
		<xsl:variable name="ap" select="translate(@name, $UPPER, $LOWER)"/>
		<xsl:variable name="names_url" select="'http://www.tc184-sc4.org/Short_Names/'"/>
		<xsl:variable name="parts_url" select="'http://www.tc184-sc4.org/EXPRESS/'"/>
		<p>
This annex references a listing of the EXPRESS entity names and corresponding short names as specified or referenced in this part of ISO 10303. 
This listing can also be found at the following URL:
		</p>
		<blockquote>
			Short names:&lt;
			<a href="{$names_url}">
				<xsl:value-of select="$names_url"/>
			</a>&gt;<br/>
		</blockquote>
		<p>
This annex also provides a listing of the EXPRESS schemas, ARM and MIM short-form, that specify in a modular form, the data structures standardized within this part of ISO 10303. 
These listings are available in computer-interpretable form from Table G.1 and can be found at the following URLs:
		</p>
		<blockquote>
			EXPRESS:&lt;
			<a href="{$parts_url}">
				<xsl:value-of select="$parts_url"/>
			</a>&gt;
		</blockquote>
	
		<div align="center">
			<a name="table_g1">
				<b>
<!-- 					<xsl:choose>
						<xsl:when test="./mim_lf or ./arm_lf">
							Table G.1 &#8212; ARM to AIM EXPRESS short and long form listings
						</xsl:when>
						<xsl:otherwise>
							Table G.1 &#8212; ARM and MIM EXPRESS listings
						</xsl:otherwise>
					</xsl:choose>
 -->
							Table G.1 &#8212; ARM and MIM EXPRESS listings
				</b>
			</a>
		</div>
			
		<br/>
		
		<div align="center">
			<table border="1" cellspacing="1">
				<tr>
					<td>
						<b>
							Description
						</b>
					</td>
					<td>
						<b>
							File
						</b>
					</td>
					<td>
						<b>
							File
						</b>
					</td>
					<td>
						<b>
							Identifier
						</b>
					</td>
				</tr>
				<tr>
					<td>EXPRESS ARM short form </td>
					<td>
						<a href="{$arm}">
							<xsl:value-of select="concat('arm',$FILE_EXT)"/>
						</a>
					</td>
					<xsl:call-template name="output_express_links">
						<xsl:with-param name="wgnumber" select="./@wg.number.arm"/>
						<xsl:with-param name="file" select="'arm.exp'"/>
						<xsl:with-param name="file_name" select="'arm.exp'"/>
						<xsl:with-param name="ap_module" select="@module_name"/>
					</xsl:call-template>
				</tr>
				<tr>
					<xsl:apply-templates select="arm_lf" mode="annexg"/>
				</tr>
				<tr>
					<td>EXPRESS MIM short form
					</td>

					<td>
						<a href="{$mim}">
							<xsl:value-of select="concat('mim',$FILE_EXT)"/>
						</a>
					</td>
					<xsl:call-template name="output_express_links">
						<xsl:with-param name="wgnumber" select="./@wg.number.mim"/>
						<xsl:with-param name="file" select="'mim.exp'"/>
						<xsl:with-param name="file_name" select="'mim.exp'"/>
						<xsl:with-param name="ap_module" select="@module_name"/>
					</xsl:call-template>
				</tr>
				<tr>
					<xsl:apply-templates select="." mode="annexg_aim_lf"/>
				</tr>
			</table>
		</div>
		<p>
			If there is difficulty accessing these sites, contact ISO Central Secretariat or contact the ISO TC184/SC4 Secretariat directly at: 
			<a href="mailto:sc4sec@tc184-sc4.org">
				sc4sec@tc184-sc4.org
			</a>.
		</p>
		<p class="note">
			<small>
				NOTE&#160;&#160;The information provided in computer-interpretable form at the above URLs is informative. The information that is contained in the body of this part of ISO 10303 is normative.
			</small>
		</p>
	</xsl:template>

	<xsl:template name="output_express_links">
		<xsl:param name="wgnumber"/>
		<xsl:param name="file"/>
		<xsl:param name="file_name"/>
		<xsl:param name="ap_module"/>
		<td>
			<a href="../../../modules/{$ap_module}/{$file}"><xsl:value-of select="$file_name"/></a>
  		</td>
		<td>
<!-- 			<xsl:variable name="test_wg_number">
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
						aim
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="contains($test_wg_number,'Error')">
					<xsl:call-template name="error_message">
						<xsl:with-param name="message">
							<xsl:value-of select="concat('(Error in application_protocol.xml/application_protocol/@wg.number.',$type,' - ',
                                  $test_wg_number)"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat('WG3 N',$wgnumber)"/>
				</xsl:otherwise>
			</xsl:choose>-->
		</td> 
	</xsl:template>
	
<!-- 	<xsl:template match="arm_lf" mode="annexg">
		<xsl:variable name="module_name" select="../@module_name"/>
		<xsl:variable name="arm_lf">
			<xsl:choose>
				<xsl:when test="$FILE_EXT='.xml'">
					<xsl:value-of select="'g_exp_arm_lf.xml'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'g_exp_arm_lf.htm'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="arm_lf_exp">
			<xsl:value-of select="concat('../../../modules/', $module_name, '/arm_lf.exp')"/>
		</xsl:variable>
		<tr>
			<td>
				ARM long form EXPRESS
			</td>
			<td>
				<a href="{$arm_lf}">
					<xsl:value-of select="concat('arm_lf',$FILE_EXT)"/>
				</a>
			</td>
			<td>
				<a href="{$arm_lf_exp}">
					arm_lf.exp
				</a>
			</td>
			<td align="center">
				&#8212;
			</td>
		</tr>
	</xsl:template> -->
	
	<xsl:template match="application_protocol" mode="annexg_aim_lf">
			<xsl:variable name="test_wg_number">
				<xsl:call-template name="test_wg_number">
					<xsl:with-param name="wgnumber" select="@wg.number.mim"/>
				</xsl:call-template>
			</xsl:variable>
					
<!-- 		<xsl:variable name="module_name" select="../@module_name"/> -->
		<xsl:variable name="aim_lf">
			<xsl:choose>
				<xsl:when test="$FILE_EXT='.xml'">
					<xsl:value-of select="'a_exp_aim_lf.xml'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'a_exp_aim_lf.htm'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="aim_lf_exp" select="'../aim_lf.exp'"/> 
<!-- 		<xsl:variable name="aim_lf_exp">
			<xsl:value-of select="concat('../../../modules/', $module_name, '/aim_lf.exp')"/>
		</xsl:variable>
 -->		<tr>
			<td>EXPRESS AIM long form
			</td>
			<td>
				<a href="{$aim_lf}">
					<xsl:value-of select="concat('aim_lf',$FILE_EXT)"/>
				</a>
			</td>
			<td>
				<a href="{$aim_lf_exp}">
					aim_lf.exp
				</a>
			</td>
			<td align="center">
			<xsl:choose>
				<xsl:when test="contains($test_wg_number,'Error')">
					<xsl:call-template name="error_message">
						<xsl:with-param name="message">
							<xsl:value-of select="concat('(Error in application_protocol.xml/application_protocol/@wg.number.mim',' - ',
                                  $test_wg_number)"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat('WG3 N',@wg.number.mim)"/>
				</xsl:otherwise>
			</xsl:choose>
			</td>
		</tr>
	</xsl:template>
	
	
	<xsl:template match="arm">
		<xsl:variable name="f_expg" select="concat('./f_arm_expg',$FILE_EXT)"/>
		<xsl:variable name="sect51" select="concat('./5_mim',$FILE_EXT)"/>
		
		<xsl:variable name="current_application_protocol">
			<xsl:call-template name="module_display_name">
				<xsl:with-param name="module" select="../@name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="part_no" select="../@part"/>
		<xsl:variable name="ap_module_dir">
			<xsl:call-template name="ap_module_directory">
				<xsl:with-param name="application_protocol" select="../@module_name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="sect_4" select="concat('../../../modules/', $ap_module_dir, '/sys/4_info_reqs', $FILE_EXT)"/>
		
		<xsl:variable name="ap_dir">
			<xsl:call-template name="application_protocol_directory">
				<xsl:with-param name="application_protocol" select="../@name"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="arm_xml" select="concat($ap_module_dir,'/arm.xml')"/>
		<xsl:variable name="ap_file" select="concat($ap_dir, '/application_protocol.xml')"/>
		
		<!--		<xsl:variable name="schema_name" select="document($arm_xml)/express/schema/@name"/>
		<xsl:call-template name="check_schema_name">
			<xsl:with-param name="arm_mim" select="'arm'"/>
			<xsl:with-param name="schema_name" select="$schema_name"/>
		</xsl:call-template>
		<xsl:variable name="xref">
			<xsl:call-template name="express_a_name">
				<xsl:with-param name="section1" select="$schema_name"/>
			</xsl:call-template>
		</xsl:variable>
		 code>
			<u>
				EXPRESS specification: 
			</u>
			<br/>
			<br/>
			*)
			<br/>
			<br/>
			<a name="{$xref}">
				SCHEMA 
				<xsl:value-of select="concat($schema_name,';')"/>
			</a>
			<br/>
			<br/>
			(*
		</code>
		-->
			



		<h3><a name="#42">4.2&#160;Information requirements model</a></h3>
		<h4>4.2.1&#160;Application reference model specification</h4>
		<p>
			The detailed information requirements for this AP are defined in 
			<a href="{$sect_4}">Clause 4 of ISO 10303-<xsl:value-of select="$part_no"/></a>.
		</p>
		<note number="1">
			The Application Object index contains a complete list of all Application objects identified in the information requirements in 
			ISO 10303-<xsl:value-of select="$part_no"/>.
		</note>
		<note number="2">
			The module index contains a complete list of all the modules used in this part of ISO 10303.
		</note>
		<h4>4.2.2&#160;Model overview</h4>
		<p>
			The following sub-clauses contain an overview of the requirements contained in ISO 10303-<xsl:value-of select="$part_no"/> as represented in the following list of modules:
		</p>

		
		<!-- xsl:apply-templates select="document('../../data/application_protocols/nut_and_bolt/sys/module_index.xml')"/ -->
		
		<!-- p>
			<xsl:apply-templates select="uof" mode="toc"/>
		</p>
		<xsl:choose>
			<xsl:when test="(./uoflink)">
				<p>
					This part of ISO 10303 also includes the following units of functionality: 
				</p>
				<ul>
					<xsl:apply-templates select="./uoflink" mode="toc"/>
				</ul>
			</xsl:when>
			<xsl:otherwise>
				<p>
					This part of ISO 10303 also includes the units of functionality defined in the application modules that are 
					imported with the USE FROM statements specified in clause 4.2.
				</p>
			</xsl:otherwise>
		</xsl:choose>
		<p>
			The content of the units of functionality is listed below.
		</p>
		<xsl:apply-templates select="uof" mode="uof_toc"/>
		<xsl:apply-templates select="uoflink" mode="uof_toc"/>
		<xsl:apply-templates select="document($arm_xml)/express/schema/interface"/>
		<xsl:apply-templates select="document($arm_xml)/express/schema/constant"/>
		<xsl:apply-templates select="document($arm_xml)/express/schema/type"/>
		<xsl:apply-templates select="document($arm_xml)/express/schema/entity"/>
		<xsl:apply-templates select="document($arm_xml)/express/schema/function"/>
		<xsl:apply-templates select="document($arm_xml)/express/schema/rule"/>
		<xsl:apply-templates select="document($arm_xml)/express/schema/procedure"/>
		<code>
			<br/>
			<br/>
			*)
			<br/>
			<br/>
			END_SCHEMA;
			<br/>
			<br/>
			(*
			</code -->
	</xsl:template>
	
	<xsl:template match="uof" mode="uof_toc">
		<h3>
			<xsl:variable name="name" select="concat('uof',@name)"/>
			<a name="{$name}">
				<xsl:value-of select="concat('4.1.',position(),' ',@name)"/>
			</a>
		</h3>
		<!-- The <xsl:value-of select="@name"/> UoF specifies -->
		<xsl:choose>
			<xsl:when test="string-length(./description) > 0">
				<xsl:apply-templates select="description"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="error_message">
					<xsl:with-param name="message" select="concat('Error 3: No description provided for UoF ',@name)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		<p>
			The following application objects are defined in the <xsl:value-of select="@name"/> UoF: 
		</p>
		<ul>
			<xsl:apply-templates select="uof.ae"/>
		</ul>
	</xsl:template>
	
	<xsl:template match="uoflink" mode="uof_toc">
		<xsl:variable name="application_protocol" select="@application_protocol"/>
		<xsl:variable name="uof" select="@uof"/>
		<xsl:variable name="xref" select="concat('../../',$application_protocol,'/sys/4_info_reqs',$FILE_EXT,'#uof',$uof)"/>
		<xsl:variable name="current_application_protocol">
		
			<xsl:call-template name="module_display_name">
				<xsl:with-param name="module" select="/application_protocol/@name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="name" select="concat('uof',$uof)"/>	
		<h3>
			<a name="{$name}">
				<xsl:value-of select="concat('4.1.',position()+count(../uof),' ',$uof)"/>
			</a>
		</h3>
		<p>
		The <b>$name</b> UoF is defined in the
		<a href="{$xref}">
			<xsl:call-template name="module_display_name">
				<xsl:with-param name="module" select="$application_protocol"/>
			</xsl:call-template>
		</a> application protocol. 
		</p>
		<p>
		The following application entities of this UoF are referenced in the 
		<xsl:value-of select="$current_application_protocol"/>
		application protocol:
		</p>
		<xsl:variable name="ap_mod_dir">
			<xsl:call-template name="ap_module_directory">
				<xsl:with-param name="application_protocol" select="$application_protocol"/>
    			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="application_protocol_ok">
			<xsl:call-template name="check_application_protocol_exists">
				<xsl:with-param name="application_protocol" select="$application_protocol"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$application_protocol_ok='true'">
				<!-- check that the UoF is named correctly -->
				<xsl:choose>
					<xsl:when test="document(concat($ap_mod_dir,'/module.xml'))/module/arm/uof[@name=$uof]">
						<ul>
							<xsl:apply-templates select="document(concat($ap_mod_dir,'/module.xml'))/module/arm/uof[@name=$uof]/uof.ae"/>
						</ul>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="error_message">
							<xsl:with-param name="message">
								<xsl:value-of select="concat('Error 18: The UoF ',$uof, ' cannot be found in application_protocol',$application_protocol)"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="error_message">
					<xsl:with-param name="message">
						<xsl:value-of select="concat('Error 5: ', $application_protocol_ok)"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template match="uof.ae">
		<xsl:param name="module"/>
			
	  	<xsl:variable name="module_name">
	    		<xsl:choose>
	      			<xsl:when test="$module">
					<xsl:value-of select="$module"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/module/@name"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="ap_module_dir">
			<xsl:call-template name="ap_module_directory">
				<xsl:with-param name="application_protocol" select="/module/@name"/>
			</xsl:call-template>
		</xsl:variable>
	  	<xsl:variable name="arm" select="concat($ap_module_dir,'/arm.xml')"/>
		<xsl:variable name="ae" select="@entity"/>
		<xsl:variable name="schema_name">
			<xsl:call-template name="schema_name">
				<xsl:with-param name="module_name" select="/module/@name"/>
	      				<xsl:with-param name="arm_mim" select="'arm'"/>
	    			</xsl:call-template>
		</xsl:variable>
  		<xsl:choose>
	    		<xsl:when test="document($arm)/express/schema[entity/@name=$ae or type/@name=$ae]">
	      			<li>
					<xsl:choose>
						<xsl:when test="position()!=last()">
							<a href="#{$schema_name}.{$ae}">
								<xsl:value-of select="$ae"/>
							</a>;
						</xsl:when>
						<xsl:otherwise>
							<a href="#{$schema_name}.{$ae}">
								<xsl:value-of select="$ae"/>
							</a>.
						</xsl:otherwise>
					</xsl:choose>
				</li>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="error_message">
					<xsl:with-param name="message">
						<xsl:value-of select="concat('Error 6: uof.ae error: The application object ',$ae,' cannot be found in module ',/module/	@name )"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="mim">
		<h3>
			<a name="aim_express">5.2 AIM EXPRESS short listing</a>
		</h3>
		<p>
This clause specifies the interpreted EXPRESS schema of this application protocol. It uses elements from the common resources or from the application
    modules and defines the EXPRESS constructs that are specific to this part of ISO 10303.
		</p>
		<p>
			The following restrictions apply to the use, in this schema, of constructs defined in common resources or in application modules:
		</p>
		<ul>
			<li>
				Use of a supertype entity does not make applicable any of its specializations, unless the specialization is also imported in the AIM schema.
			</li>
			<li>
				Use of a SELECT type does not make applicable any of its listed types unless the listed type is also imported in the AIM schema.
			</li>
		</ul>
		<xsl:variable name="ap_module_dir">
			<xsl:call-template name="ap_module_directory">
				<xsl:with-param name="application_protocol" select="../@module_name"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="application_protocol_dir">
			<xsl:call-template name="application_protocol_directory">
				<xsl:with-param name="application_protocol" select="../@name"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="aim_xml" select="concat($ap_module_dir,'/mim.xml')"/>
		<xsl:variable name="schema_name" select="document($aim_xml)/express/schema/@name"/>
		<xsl:variable name="xref">
			<xsl:call-template name="express_a_name">
				<xsl:with-param name="section1" select="$schema_name"/>
			</xsl:call-template>
		</xsl:variable>
		<code>
			<u>
				EXPRESS specification:
			</u>
			<br/>
			<br/>
			*)
			<br/>
			<br/>
			<a name="{$xref}">
				SCHEMA
				<xsl:value-of select="concat($schema_name,';')"/>
			</a>
		</code>
		<xsl:apply-templates select="document($aim_xml)/express/schema/interface"/>
		<xsl:apply-templates select="document($aim_xml)/express/schema[@name=$schema_name]/constant"/>
		<xsl:call-template name="imported_constructs">
			<xsl:with-param name="desc_item" select="document($aim_xml)/express/schema/interface/described.item[@kind='CONSTANT']"/>
		</xsl:call-template>
		<xsl:apply-templates select="document($aim_xml)/express/schema/type"/>
		<xsl:call-template name="imported_constructs">
			<xsl:with-param name="desc_item" select="document($aim_xml)/express/schema/interface/described.item[@kind='TYPE']"/>
		</xsl:call-template>
		<xsl:apply-templates select="document($aim_xml)/express/schema/entity"/>
		<xsl:call-template name="imported_constructs">
			<xsl:with-param name="desc_item" select="document($aim_xml)/express/schema/interface/described.item[@kind='ENTITY']"/>
		</xsl:call-template>
		<xsl:apply-templates select="document($aim_xml)/express/schema/function"/>
		<xsl:call-template name="imported_constructs">
			<xsl:with-param name="desc_item" select="document($aim_xml)/express/schema/interface/described.item[@kind='FUNCTION']"/>
		</xsl:call-template>
		<xsl:apply-templates select="document($aim_xml)/express/schema/rule"/>
		<xsl:call-template name="imported_constructs">
			<xsl:with-param name="desc_item" select="document($aim_xml)/express/schema/interface/described.item[@kind='RULE']"/>
		</xsl:call-template>
		<xsl:apply-templates select="document($aim_xml)/express/schema/procedure"/>
		<xsl:call-template name="imported_constructs">
			<xsl:with-param name="desc_item" select="document($aim_xml)/express/schema/interface/described.item[@kind='PROCEDURE']"/>
		</xsl:call-template>
		<code>
			<br/>
			<br/>
			*)
			<br/>
			<br/>
			END_SCHEMA;
			<br/>
			<br/>
			(*
		</code>
	</xsl:template>

	<!-- xsl:template match="ae" mode="toc">
		<xsl:variable name="xref" select="concat('5_mapping',$FILE_EXT,'#',@entity)"/>
		<xsl:variable name="sect_no">
			<xsl:number/>
		</xsl:variable>
		<h3>
			<xsl:value-of select="concat('5.1.',$sect_no,' ')"/>
			<a href="{$xref}">
				<xsl:value-of select="@entity"/>
			</a>
		</h3>
	</xsl:template -->


	<xsl:template name="normrefs_list">
	
		<xsl:variable name="normref_list1">
			<xsl:call-template name="get_normref">
				<xsl:with-param name="normref_nodes" select="document('../../data/basic/ap_doc/normrefs_default.xml')/normrefs/normref.inc"/>
				<xsl:with-param name="normref_list" select="''"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="normref_list2">
			<xsl:call-template name="get_normref">
				<xsl:with-param name="normref_nodes" select="/application_protocol/normrefs/normref.inc"/>
				<xsl:with-param name="normref_list" select="$normref_list1"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="normref_list3">
			<xsl:call-template name="get_normrefs_from_abbr">
				<xsl:with-param name="abbrvinc_nodes" select="document('../../data/basic/ap_doc/abbreviations_default.xml')/abbreviations/abbreviation.inc"/>
				<xsl:with-param name="normref_list" select="$normref_list2"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:value-of select="concat($normref_list3, ',')"/>

		
		<!-- xsl:variable name="ap_module_dir">
			<xsl:call-template name="ap_module_directory">
				<xsl:with-param name="application_protocol" select="/application_protocol/@name"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="arm_xml" select="concat($ap_module_dir,'/arm.xml')"/>
		<xsl:variable name="normref_list4">
			<xsl:call-template name="get_normrefs_from_schema">
				<xsl:with-param name="interface_nodes" select="document($arm_xml)/express/schema/interface"/>
				<xsl:with-param name="normref_list" select="$normref_list3"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="aim_xml" select="concat($ap_module_dir,'/mim.xml')"/>
		<xsl:variable name="normref_list5">
			<xsl:call-template name="get_normrefs_from_schema">
				<xsl:with-param name="interface_nodes" select="document($aim_xml)/express/schema/interface"/>
				<xsl:with-param name="normref_list" select="$normref_list4"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="concat($normref_list5,',')"/ -->
	</xsl:template>
	
	<xsl:template name="get_normref">
		<xsl:param name="normref_nodes"/>
		<xsl:param name="normref_list"/>
		<xsl:variable name="normref_list_ret">
			<xsl:choose>
				<xsl:when test="$normref_nodes">
					<xsl:variable name="first">
						<xsl:choose>
							<xsl:when test="$normref_nodes[1]/@normref">
								<xsl:value-of select="concat('normref:',$normref_nodes[1]/@normref)"/>
							</xsl:when>
							<xsl:when test="$normref_nodes[1]/@module.name">
								<xsl:value-of select="concat('module:',$normref_nodes[1]/@module.name)"/>
							</xsl:when>
							<xsl:when test="$normref_nodes[1]/@resource.name">
								<xsl:value-of select="concat('resource:',$normref_nodes[1]/@resource.name)"/>
							</xsl:when>
							<xsl:when test="$normref_nodes[1]/@application_protocol.name">
								<xsl:value-of select="concat('application_protocol:',$normref_nodes[1]/@application_protocol.name)"/>
							</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="normref_list1">
						<xsl:call-template name="add_normref">
							<xsl:with-param name="normref" select="$first"/>
							<xsl:with-param name="normref_list" select="$normref_list"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:call-template name="get_normref">
						<xsl:with-param name="normref_nodes" select="$normref_nodes[position()!=1]"/>
						<xsl:with-param name="normref_list" select="$normref_list1"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$normref_list"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$normref_list_ret"/>
	</xsl:template>
	
<!-- given a list of abbreviation.inc nodes, add the ids of the normrefs to the
     normref_list, if not already a member. ids in normref_list are
     separated by a , -->
	<xsl:template name="get_normrefs_from_abbr">
		<xsl:param name="abbrvinc_nodes"/>
		<xsl:param name="normref_list"/>
		<xsl:variable name="normref_list_ret">
			<xsl:choose>
				<xsl:when test="$abbrvinc_nodes">
					<xsl:variable name="abbr.inc" select="$abbrvinc_nodes[1]/@linkend"/>
					<xsl:variable name="abbr" select="document('../../data/basic/abbreviations.xml')/abbreviation.list/abbreviation[@id=$abbr.inc]"/>
					<xsl:variable name="first">
						<xsl:choose>
							<xsl:when test="$abbr/term.ref/@normref">
								<xsl:value-of select="concat('normref:',$abbr/term.ref/@normref)"/>
							</xsl:when>
							<xsl:when test="$abbr/term.ref/@module.name">
								<xsl:value-of select="concat('module:',$abbr/term.ref/@module.name)"/>
							</xsl:when> 
							<xsl:when test="$abbr/term.ref/@application_protocol.name">
								<xsl:value-of select="concat('application_protocol:',$abbr/term.ref/@application_protocol.name)"/>
							</xsl:when>
							<xsl:when test="$abbr/term.ref/@resource.name">
								<xsl:value-of select="concat('resource:',$abbr/term.ref/@resource.name)"/>
							</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="normref_list1">
						<xsl:call-template name="add_normref">
							<xsl:with-param name="normref" select="$first"/>
							<xsl:with-param name="normref_list" select="$normref_list"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:call-template name="get_normrefs_from_abbr">
						<xsl:with-param name="abbrvinc_nodes" select="$abbrvinc_nodes[position()!=1]"/>
						<xsl:with-param name="normref_list" select="$normref_list1"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$normref_list"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$normref_list_ret"/>
	</xsl:template>


	<!-- DELETE? -->
	<!-- xsl:template name="get_normrefs_from_schema">
		<xsl:param name="interface_nodes"/>
		<xsl:param name="normref_list"/>
		<xsl:variable name="normref_list_ret">
			<xsl:choose>
				<xsl:when test="$interface_nodes">
					<xsl:variable name="schema" select="$interface_nodes[1]/@schema"/>
					<xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
					<xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
					<xsl:variable name="schema_lcase" select="translate($schema,$UPPER, $LOWER)"/>
					<xsl:variable name="module_name">
						<xsl:choose>
							<xsl:when test="contains($schema_lcase,'_arm')">
								<xsl:value-of select="concat('module:',substring-before($schema_lcase,'_arm'))"/>
							</xsl:when>
							<xsl:when test="contains($schema_lcase,'_aim')">
								<xsl:value-of select="concat('module:',substring-before($schema_lcase,'_aim'))"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat('resource:',$schema_lcase)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="normref_list1">
						<xsl:call-template name="add_normref">
							<xsl:with-param name="normref" select="$module_name"/>
							<xsl:with-param name="normref_list" select="$normref_list"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:call-template name="get_normrefs_from_schema">
						<xsl:with-param name="interface_nodes" select="$interface_nodes[position()!=1]"/>
						<xsl:with-param name="normref_list" select="$normref_list1"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$normref_list"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$normref_list_ret"/>
	</xsl:template -->


	<!-- DELETE? -->
	<!-- xsl:template name="add_normref">
		<xsl:param name="normref"/>
		<xsl:param name="normref_list"/>
		<xsl:variable name="normref_list_term" select="concat($normref_list,',')"/>
		<xsl:variable name="normref_list1">
			<xsl:choose>
				<xsl:when test="contains($normref_list_term, concat(',',$normref,','))">
					<xsl:value-of select="$normref_list"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat($normref_list,',',$normref,',')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$normref_list1"/>
	</xsl:template -->
     

	<xsl:template name="prune_normrefs_list">
		<xsl:param name="normrefs_list"/>
		<xsl:param name="pruned_normrefs_list" select="''"/>
		<xsl:param name="pruned_normrefs_ids" select="''"/>
		
		<xsl:choose>
			<xsl:when test="$normrefs_list">
				<xsl:variable name="first" select="substring-before(substring-after($normrefs_list,','),',')"/>
				<xsl:variable name="rest" select="substring-after(substring-after($normrefs_list,','),',')"/>
				<xsl:variable name="add_to_pruned_normrefs_ids">
					<xsl:choose>
						<xsl:when test="contains($first,'normref:')">
							<xsl:variable name="id" select="substring-after($first,'normref:')"/>
							<xsl:variable name="normref">
								<xsl:apply-templates select="document('../../data/basic/normrefs.xml')/normref.list/normref[@id=$id]" 	mode="prune_normrefs_list"/>
							</xsl:variable>
							<xsl:value-of select="$normref"/>
						</xsl:when>
						<xsl:when test="contains($first,'module:')">
							<xsl:variable name="module" select="substring-after($first, 'module:')"/>
							
							<xsl:variable name="ap_mod_dir">
		            <xsl:call-template name="ap_module_directory">
		      				<xsl:with-param name="application_protocol" select="$module"/>
		    				</xsl:call-template>
							</xsl:variable>
							
							<xsl:variable name="ap_module_xml" select="concat($ap_mod_dir,'/module.xml')"/>
							
							<xsl:variable name="normref">
								<xsl:apply-templates select="document($ap_module_xml)/module" mode="prune_normrefs_list"/>
							</xsl:variable>
							<xsl:if test="not(contains($pruned_normrefs_ids,$normref))">
								<xsl:value-of select="$normref"/>
							</xsl:if>
						</xsl:when>
						
						<xsl:when test="contains($first, 'application_protocol:')">
							<xsl:variable name="application_protocol" select="substring-after($first, 'application_protocol:')"/>
							<xsl:variable name="ap_mod_dir">
		           <xsl:call-template name="application_protocol_directory">
		      			<xsl:with-param name="application_protocol" select="$application_protocol"/>
		    			 </xsl:call-template>
							</xsl:variable>
							<xsl:variable name="ap_xml" select="concat($ap_mod_dir,'/application_protocol.xml')"/>
							<xsl:variable name="normref">
								<xsl:apply-templates select="document($ap_xml)/application_protocol" mode="prune_normrefs_list"/>
							</xsl:variable>
							<xsl:if test="not(contains($pruned_normrefs_ids,$normref))">
								<xsl:value-of select="$normref"/>
							</xsl:if>
						</xsl:when>

						<xsl:when test="contains($first,'resource:')">
							<xsl:variable name="resource" select="substring-after($first,'resource:')"/>
							<xsl:value-of select="$resource"/>
						</xsl:when>
						
						<xsl:otherwise/>
						
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="new_pruned_normrefs_ids">
					<xsl:choose>
						<xsl:when test="string-length($add_to_pruned_normrefs_ids)>0">
							<xsl:value-of select="concat($pruned_normrefs_ids,',',$add_to_pruned_normrefs_ids,',')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$pruned_normrefs_ids"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="new_pruned_normrefs_list">
					<xsl:choose>
						<xsl:when test="string-length($add_to_pruned_normrefs_ids)>0">
							<xsl:value-of select="concat($pruned_normrefs_list,',',$first,',')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$pruned_normrefs_list"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:call-template name="prune_normrefs_list">
					<xsl:with-param name="normrefs_list" select="$rest"/>
					<xsl:with-param name="pruned_normrefs_list" select="$new_pruned_normrefs_list"/>
					<xsl:with-param name="pruned_normrefs_ids" select="$new_pruned_normrefs_ids"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$pruned_normrefs_list"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- DELETE? -->
	<!-- xsl:template match="normref" mode="prune_normrefs_list">
		<xsl:value-of select="concat(./stdref/stdnumber,./stdref/pubdate)"/>
	</xsl:template -->

	<xsl:template match="module" mode="prune_normrefs_list"/>
	
	<xsl:template match="application_protocol" mode="prune_normrefs_list">
		<xsl:value-of select="concat('10303-',./@part,./@publication.year)"/>
	</xsl:template>

	<xsl:template name="output_normrefs">
		<xsl:param name="application_protocol_number"/>
		<xsl:param name="current_application_protocol"/>
		<h3>
			2 Normative references
		</h3>
		<p>
			The following normative documents contain provisions which, through
			reference in this text, constitute provisions of this International
			Standard. For dated references, subsequent amendments to, or revisions of,
			any of these publications do not apply. However, parties to agreements
			based on this International Standard are encouraged to investigate the
			possibility of applying the most recent editions of the normative documents
			indicated below. For undated references, the latest edition of the
			normative document referred to applies. Members of ISO and IEC maintain
			registers of currently valid International Standards.
		</p>
		
		<xsl:call-template name="output_default_normrefs">
			<xsl:with-param name="module_number" select="$application_protocol_number"/>
			<xsl:with-param name="current_module" select="$current_application_protocol"/>
		</xsl:call-template>
		
	</xsl:template>
	
	<!-- DELETE? -->
	<!-- xsl:template name="output_default_normrefs">
  		<xsl:param name="module_number"/>
  		<xsl:param name="current_module"/>

  		<xsl:variable name="normrefs">
    			<xsl:call-template name="normrefs_list"/>
  		</xsl:variable>

		<xsl:variable name="pruned_normrefs">
			<xsl:call-template name="prune_normrefs_list">
				<xsl:with-param name="normrefs_list" select="$normrefs"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:call-template name="output_normrefs_rec">
			<xsl:with-param name="normrefs" select="$pruned_normrefs"/>
			<xsl:with-param name="module_number" select="$module_number"/>
			<xsl:with-param name="current_module" select="$current_module"/>
		</xsl:call-template>
						
		<xsl:call-template name="output_unpublished_normrefs">
			<xsl:with-param name="normrefs" select="$normrefs"/>
		</xsl:call-template>
		
		<xsl:call-template name="output_derogated_normrefs">
			<xsl:with-param name="normrefs" select="$normrefs"/>
			<xsl:with-param name="current_module" select="$current_module"/>
		</xsl:call-template>
	</xsl:template -->

	<xsl:template match="normref.inc" mode="ap_refs">
		<xsl:param name="current_application_protocol"/>
		<xsl:variable name="ref" select="@normref"/>
		<xsl:apply-templates select="document('../../data/basic/normrefs.xml')/normref.list/normref[@id=$ref]">
			<xsl:with-param name="current_module" select="$current_application_protocol"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="normref.inc">
		<xsl:param name="current_module"/>
		<xsl:variable name="ref" select="@normref"/>
		<xsl:apply-templates select="document('../../data/basic/normrefs.xml')/normref.list/normref[@id=$ref]">
			<xsl:with-param name="current_module" select="$current_module"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template name="output_normrefs_rec">
		<xsl:param name="module_number"/>
  		<xsl:param name="current_module"/>
		<xsl:param name="normrefs"/>

		<xsl:choose>
			<xsl:when test="$normrefs">				
			<xsl:variable name="first" select="substring-before(substring-after($normrefs,','),',')"/>
				<xsl:variable name="rest" select="substring-after(substring-after($normrefs,','),',')"/>
				<xsl:choose>
					<xsl:when test="contains($first, 'normref:')">
						<xsl:variable name="normref" select="substring-after($first, 'normref:')"/>
						<xsl:variable name="normref_node" select="document('../../data/basic/normrefs.xml')/normref.list/normref[@id=$normref]"/>
						<xsl:choose>
							<xsl:when test="$normref_node">

								<xsl:variable name="part_no" select="substring-after($normref_node/stdref/stdnumber,'-')"/>
								
								<xsl:if test="$module_number!=$part_no">
									<xsl:apply-templates select="document('../../data/basic/normrefs.xml')/normref.list/normref[@id=$normref]">
										<xsl:with-param name="current_module" select="$current_module"/>
									</xsl:apply-templates>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="error_message">
									<xsl:with-param name="message">
										<xsl:value-of select="concat('Error 7: ', $normref, 'not found')"/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					
					<xsl:when test="contains($first,'module:')">
						<xsl:variable name="module" select="substring-after($first,'module:')"/>
						<xsl:variable name="ap_mod_dir">
							<xsl:call-template name="ap_module_directory">
								<xsl:with-param name="module" select="$module"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="module_xml" select="concat($ap_mod_dir,'/module.xml')"/>
						<xsl:choose>
							<xsl:when test="document($module_xml)/module[@published='n']">
								<xsl:value-of select="'y'"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="'n'"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>

					<xsl:when test="contains($first, 'application_protocol:')">
						<xsl:variable name="application_protocol" select="substring-after($first, 'application_protocol:')"/>
						<xsl:variable name="application_protocol_dir">
							<xsl:call-template name="application_protocol_directory">
								<xsl:with-param name="application_protocol" select="$application_protocol"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="application_protocol_xml" select="concat($application_protocol_dir,'/application_protocol.xml')"/>
						
						<xsl:apply-templates select="document($application_protocol_xml)/application_protocol" mode="normref"/>
					</xsl:when>
					<xsl:when test="contains($first,'resource:')">
						<xsl:variable name="resource" select="substring-after($first,'resource:')"/>
						<xsl:call-template name="output_resource_normref">
							<xsl:with-param name="resource_schema" select="$resource"/>
						</xsl:call-template>
					</xsl:when>
					
				</xsl:choose>
				<xsl:call-template name="output_normrefs_rec">
					<xsl:with-param name="normrefs" select="$rest"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
    

<!-- output a footnote to say that the normative reference has not been
     published 
     Check the normative references in the nodule, then all the auto
     generated normrefs. These should be passed as a parameter the value of
     which is deduced by: template name="normrefs_list"
-->
	<xsl:template name="output_unpublished_normrefs">
		<xsl:param name="normrefs"/>
		<xsl:variable name="footnote">
			<xsl:choose>
				<xsl:when test="/application_protocol/normrefs/normref/stdref[@published='n']">
					<xsl:value-of select="'y'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="output_unpublished_normrefs_rec">
						<xsl:with-param name="normrefs" select="$normrefs"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="$footnote='y'">
			<p>
				<a name="tobepub">
					1) To be published.
				</a>
			</p>
		</xsl:if>
	</xsl:template>

	<xsl:template name="output_unpublished_normrefs_rec">
		<xsl:param name="normrefs"/>
		<xsl:choose>
			<xsl:when test="$normrefs">
				<xsl:variable name="first" select="substring-before(substring-after($normrefs,','),',')"/>
				<xsl:variable name="rest" select="substring-after(substring-after($normrefs,','),',')"/>
				<xsl:variable name="footnote">
					<xsl:choose>
						<xsl:when test="contains($first,'normref:')">
							<xsl:variable name="normref" select="substring-after($first,'normref:')"/>
							<xsl:choose>
								<xsl:when test="document('../../data/basic/normrefs.xml')/normref.list/normref[@id=$normref]/stdref[@published='n']">
									<xsl:value-of select="'y'"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="'n'"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						
						<xsl:when test="contains($first,'module:')">
							<xsl:variable name="module" select="substring-after($first,'module:')"/>
							<xsl:variable name="ap_module_dir">
								<xsl:call-template name="ap_module_directory">
									<xsl:with-param name="application_protocol" select="$module"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="module_xml" select="concat($ap_module_dir,'/module.xml')"/>
							<xsl:choose>
								<xsl:when test="document($module_xml)/module[@published='n']">
									<xsl:value-of select="'y'"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="'n'"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						
						<xsl:when test="contains($first, 'application_protocol:')">
							<xsl:variable name="application_protocol" select="substring-after($first, 'application_protocol:')"/>
							<xsl:variable name="application_protocol_dir">
								<xsl:call-template name="application_protocol_directory">
									<xsl:with-param name="application_protocol" select="$application_protocol"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="application_protocol_xml" select="concat($application_protocol_dir,'/application_protocol.xml')"/>
							<xsl:choose>
								<xsl:when test="document($application_protocol_xml)/application_protocol[@published='n']">
									<xsl:value-of select="'y'"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="'n'"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="'n'"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$footnote='n'">
						<xsl:call-template name="output_unpublished_normrefs_rec">
							<xsl:with-param name="normrefs" select="$rest"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="'y'"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'n'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="normref.inc">
		<xsl:param name="current_module"/>
		<xsl:variable name="ref" select="@ref"/>
		<xsl:apply-templates select="document('../../data/basic/normrefs.xml')/normref.list/normref[@id=$ref]">
			<xsl:with-param name="current_module" select="$current_module"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- DELETE? NO-->
	<xsl:template match="normref">
		<xsl:param name="current_module"/>
		<xsl:variable name="stdnumber">
			<xsl:choose>
				<xsl:when test="stdref/pubdate">
					<xsl:value-of select="concat(stdref/orgname,'&#160;',stdref/stdnumber,':',stdref/pubdate)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat(stdref/orgname,'&#160;',stdref/stdnumber,':-')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<p>
			<xsl:value-of select="$stdnumber"/>
			<xsl:if test="stdref[@published='n']">
				<sup>
					<a href="#tobepub">
						1
					</a>
				</sup>
			</xsl:if>
			,&#160;
			<i>
				<xsl:value-of select="stdref/stdtitle"/>
				<xsl:variable name="subtitle" select="normalize-space(stdref/subtitle)"/>
				<xsl:choose>
					<xsl:when test="substring($subtitle, string-length($subtitle)) != '.'">
						<xsl:value-of select="concat($subtitle,'.')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$subtitle"/>
					</xsl:otherwise>
				</xsl:choose>
			</i>
		</p>
	</xsl:template>

	<xsl:template name="output_abbreviations">
		<xsl:param name="section"/>
		<h3>
			<xsl:value-of select="concat('3.',$section)"/> Abbreviations
		</h3>
		<p>
			For the purposes of this part of ISO 10303, the following abbreviations apply:
		</p>
		<table width="80%">
			<xsl:apply-templates select="document('../../data/basic/ap_doc/abbreviations_default.xml')/abbreviations/abbreviation.inc"/>
			<xsl:apply-templates select="/application_protocol/abbreviations" mode="output"/>
		</table>
	</xsl:template>
	
	<xsl:template match="abbreviations" mode="output">
		<xsl:apply-templates select="/application_protocol/abbreviations/abbreviation"/>
		<xsl:apply-templates select="/application_protocol/abbreviations/abbreviation.inc"/>
	</xsl:template>
  
	<xsl:template match="abbreviation.inc">
		<xsl:variable name="ref" select="@linkend"/>
		<xsl:variable name="abbrev" select="document('../../data/basic/abbreviations.xml')/abbreviation.list/abbreviation[@id=$ref]"/>
		<xsl:choose>
			<xsl:when test="$abbrev">
				<xsl:apply-templates select="$abbrev"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="error_message">
					<xsl:with-param name="message">
						<xsl:value-of select="concat('Error 9: abbreviation.inc ',$ref, 'not found: ')"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="abbreviation">
		<tr>
			<td>
				<xsl:value-of select="acronym"/>
			</td>
			<td>
				<xsl:apply-templates select="./term" mode="abbreviation"/>
				<xsl:apply-templates select="term.ref" mode="abbreviation"/>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="term.ref" mode="abbreviation">
		<xsl:variable name="termref" select="./@linkend"/>
		<xsl:variable name="normref" select="./@normref"/>
		<xsl:variable name="term" select="document('../../data/basic/normrefs.xml')/normref.list/normref/term[@id=$termref]"/>
		<xsl:choose>
			<xsl:when test="$term">
				<xsl:value-of select="normalize-space($term)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="error_message">
					<xsl:with-param name="message">
						<xsl:value-of select="concat('Error 10: term.ref ',$termref, 'not found: ')"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="output_terms">
		<xsl:param name="application_protocol_number"/>
		
		<xsl:variable name="normrefs">
			<xsl:call-template name="normrefs_terms_list"/>
		</xsl:variable>
		
		<xsl:call-template name="output_normrefs_terms_rec">
			<xsl:with-param name="normrefs" select="$normrefs"/>
			<xsl:with-param name="normref_ids" select="$normrefs"/>
			<xsl:with-param name="section" select="0"/>
			<xsl:with-param name="module_number" select="$application_protocol_number"/>
		</xsl:call-template>
		
		<xsl:variable name="def_section">
			<xsl:call-template name="length_normrefs_list">
				<xsl:with-param name="module_number" select="$application_protocol_number"/>
				<xsl:with-param name="normrefs_list" select="$normrefs"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:if test="/application_protocol/definition">
			<xsl:call-template name="output_application_protocol_term_section">
				<xsl:with-param name="application_protocol" select="/application_protocol"/>
				<xsl:with-param name="section" select="concat('3.',$def_section+1)"/>
			</xsl:call-template>
			For the purposes of this part of ISO 10303, the following definitions apply:
		</xsl:if>
		
		<xsl:variable name="def_section1">
			<xsl:choose>
				<xsl:when test="/application_protocol/definition">
					<xsl:value-of select="$def_section+1"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$def_section"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:apply-templates select="/application_protocol/definition">
			<xsl:with-param name="section" select="concat('3.',$def_section1)"/>
			<xsl:sort select="term"/>
		</xsl:apply-templates>
		
		<xsl:call-template name="output_abbreviations">
			<xsl:with-param name="section" select="$def_section1+1"/>
		</xsl:call-template>
		
	</xsl:template>

	<xsl:template name="output_normrefs_terms_rec">
		<xsl:param name="normrefs"/>
  		<xsl:param name="normref_ids"/>
		<xsl:param name="section"/>
		<xsl:param name="module_number"/>
		<xsl:param name="current_module"/>
		<xsl:choose>
		
			<xsl:when test="$normrefs">
				<xsl:variable name="first" select="substring-before(substring-after($normrefs,','),',')"/>
				<xsl:variable name="section_no" select="$section+1"/>
				<xsl:variable name="rest" select="substring-after(substring-after($normrefs,','),',')"/>
				<xsl:choose>
					<xsl:when test="contains($first, 'normref:')">
						<xsl:variable name="ref" select="substring-after($first, 'normref:')"/>
						<xsl:variable name="normref" select="document('../../data/basic/normrefs.xml')/normref.list/normref[@id=$ref]"/>
						<xsl:variable name="stdnumber" select="concat($normref/stdref/orgname, ' ',$normref/stdref/stdnumber)"/>
						<h3>
							<xsl:value-of select="concat('3.',$section_no, ' Terms defined in ',$stdnumber)"/>
						</h3>
						For the purposes of this part of ISO 10303, the following terms defined in <xsl:value-of select="$stdnumber"/> apply:
						<ul>
							<xsl:apply-templates select="document('../../data/basic/ap_doc/normrefs_default.xml')/normrefs/normref.inc[@normref=$ref]/term.ref" mode="normref"/>
							<xsl:apply-templates select="/application_protocol/normrefs/normref.inc[@normref=$ref]/term.ref"
               mode="normref"/>
						</ul>
					</xsl:when>
					
					<xsl:when test="contains($first, 'module:')">
						<xsl:variable name="module" select="substring-after($first, 'module:')"/>
						<xsl:variable name="ap_module_dir">
							<xsl:call-template name="ap_module_directory">
								<xsl:with-param name="application_protocol" select="$module"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="module_ok">
							<xsl:call-template name="check_module_exists">
								<xsl:with-param name="module" select="$module"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="$module_ok='true'">
								<xsl:variable name="module_xml" select="concat($ap_module_dir, '/module.xml')"/>
								<xsl:variable name="normrefid" select="concat('10303-',document($module_xml)/module/@part)"/>
								<xsl:if test="not(contains($normref_ids, $normrefid))">
									<xsl:variable name="module_node" select="document($module_xml)/module"/>
									<xsl:variable name="stdnumber" select="concat('ISO/',$module_node/@status,'&#160;10303-',$module_node/@part)"/>
									<h3>
										<xsl:value-of select="concat('3.',$section_no, ' Terms defined in ', $stdnumber)"/>
									</h3>
For the purposes of this part of ISO 10303, the following terms defined in <xsl:value-of select="$stdnumber"/> apply:
									<ul>
										<xsl:apply-templates select="/module/normrefs/normref.inc[@module.name=$module]/term.ref" mode="module"/>
									</ul>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="error_message">
									<xsl:with-param name="message">
										<xsl:value-of select="concat('Error ref 2: ', $module_ok,' Check the normatives references')"/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>		
			
					<xsl:when test="contains($first, 'application_protocol:')">
						<xsl:variable name="application_protocol" select="substring-after($first, 'application_protocol:')"/>
						<xsl:variable name="application_protocol_dir">
							<xsl:call-template name="application_protocol_directory">
								<xsl:with-param name="application_protocol" select="$application_protocol"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="application_protocol_xml" select="concat($application_protocol_dir,'/application_protocol.xml')"/>
						<xsl:variable name="stdnumber">
							<xsl:call-template name="get_module_stdnumber">
								<xsl:with-param name="module" select="document($application_protocol_xml)/application_protocol"/>
							</xsl:call-template>
						</xsl:variable>
						<!-- output the section header for the normative reference that is defining terms -->
						<h3>
							<xsl:value-of select="concat('3.',$section_no, ' Terms defined in ', $stdnumber)"/>
						</h3>
						For the purposes of this part of ISO 10303, the following terms defined in <xsl:value-of select="$stdnumber"/> apply:
						<ul>
							<!-- now output the terms -->
							<xsl:apply-templates select="/application_protocol/normrefs/normref.inc[@application_protocol.name=$application_protocol]/term.ref" mode="application_protocol"/>
						</ul>
					</xsl:when>
					<xsl:when test="contains($first,'resource:')">
						<xsl:variable name="resource" select="substring-after($first,'resource:')"/>
						<!-- should never get here -->
					</xsl:when>
				</xsl:choose>
				<xsl:call-template name="output_normrefs_terms_rec">
					<xsl:with-param name="normrefs" select="$rest"/>
					<xsl:with-param name="section" select="$section_no"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<!-- end of recursion -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

<!-- build a list of normrefs that are used by the module and have terms
     defined in them 
     The list comprises:
     All default normrefs listed in ../data/basic/normrefs.xml
     All normrefs explicitly included in the module by normref.inc
-->

	<xsl:template name="normrefs_terms_list">
		
		<xsl:variable name="normref_list1">
			<xsl:call-template name="get_normref_term">
				<xsl:with-param name="normref_nodes" select="document('../../data/basic/ap_doc/normrefs_default.xml')/normrefs/normref.inc"/>
				<xsl:with-param name="normref_list" select="''"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="normref_list2">
			<xsl:call-template name="get_normref_term">
				<xsl:with-param name="normref_nodes" select="/application_protocol/normrefs/normref.inc"/>
				<xsl:with-param name="normref_list" select="$normref_list1"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:value-of select="concat($normref_list2,',')"/>
	</xsl:template>


<!-- given a list of normref nodes, add the ids of the normrefs to the
     normref_list, if not already a member. ids in normref_list are
     separated by a , -->
<xsl:template name="get_normref_term">
  <xsl:param name="normref_nodes"/>
  <xsl:param name="normref_list"/>
  
  <xsl:variable name="normref_list_ret">
    <xsl:choose>
      <xsl:when test="$normref_nodes">
        <xsl:choose>
          <xsl:when test="$normref_nodes[1]/term.ref">
            <!-- only add the normref if it is defining terms -->
            <xsl:variable name="first">
              <xsl:choose>
                <xsl:when test="$normref_nodes[1]/@normref">
                  <xsl:value-of 
                    select="concat('normref:',$normref_nodes[1]/@normref)"/>
                </xsl:when>
                <xsl:when test="$normref_nodes[1]/@application_protocol.name">
                  <xsl:value-of 
                    select="concat('application_protocol:',$normref_nodes[1]/@application_protocol.name)"/>
                </xsl:when>            
                <xsl:when test="$normref_nodes[1]/@resource.name">
                  <xsl:value-of 
                    select="concat('application_protocol:',$normref_nodes[1]/@resource.name)"/>
                </xsl:when>            
              </xsl:choose>
            </xsl:variable>
            
            <xsl:variable name="normref_list1">
              <xsl:call-template name="add_normref">
                <xsl:with-param name="normref" select="$first"/>
                <xsl:with-param name="normref_list" select="$normref_list"/>
              </xsl:call-template>
            </xsl:variable>
            
            <xsl:call-template name="get_normref_term">
              <xsl:with-param 
                name="normref_nodes" 
                select="$normref_nodes[position()!=1]"/>
              <xsl:with-param 
                name="normref_list" 
                select="$normref_list1"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="get_normref_term">
              <xsl:with-param 
                name="normref_nodes" 
                select="$normref_nodes[position()!=1]"/>
              <xsl:with-param 
                name="normref_list" 
                select="$normref_list"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!-- end of recursion -->
        <xsl:value-of select="$normref_list"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$normref_list_ret"/>
</xsl:template>

<!--DELETE?-->
<!-- xsl:template name="length_normrefs_list">
  <xsl:param name="normrefs_list"/>
  <xsl:variable name="section1">
    <xsl:call-template name="count_substring">
      <xsl:with-param name="substring" select="','"/>
      <xsl:with-param name="string" select="$normrefs_list"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="floor($section1 div 2)"/>
</xsl:template -->


	<xsl:template name="output_application_protocol_term_section">
		<xsl:param name="application_protocol"/>
		<xsl:param name="section"/>
		<xsl:variable name="stdnumber">
		<xsl:call-template name="get_module_stdnumber">
      <xsl:with-param name="module" select="$application_protocol"/>
    </xsl:call-template>
  </xsl:variable>
  <h3><xsl:value-of select="concat($section,' Terms defined in ',$stdnumber)"/></h3>
  </xsl:template>


  <xsl:template match="term.ref" mode="application_protocol">
    <xsl:variable name="application_protocol" select="../@application_protocol.name"/>

    <xsl:variable name="application_protocol_dir">
      <xsl:call-template name="application_protocol_directory">
        <xsl:with-param name="application_protocol" select="$application_protocol"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="application_protocol_xml" 
      select="concat($application_protocol_dir,'/application_protocol.xml')"/>

    <xsl:variable 
      name="ref"
      select="@linkend"/>
    <xsl:variable 
      name="term"
      select="document($application_protocol_xml)/application_protocol/definition/term[@id=$ref]"/>

    <xsl:choose>
      <xsl:when test="$term">
        <xsl:choose>
          <xsl:when test="position()=last()">
            <li><xsl:apply-templates select="$term"/>.</li>
          </xsl:when>
          <xsl:otherwise>
            <li><xsl:apply-templates select="$term"/>.</li>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <li>
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message"
              select="concat('Error 11: Can not find term referenced by: ',$ref)"/>
          </xsl:call-template>
        </li>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="term.ref"  mode="normref">
    <xsl:variable 
      name="ref"
      select="@linkend"/>
    <xsl:variable 
      name="term"
      select="document('../../data/basic/normrefs.xml')/normref.list/normref/term[@id=$ref]"/>
    <xsl:choose>
      <xsl:when test="$term">
        <xsl:choose>
          <xsl:when test="position()=last()">
            <li><xsl:apply-templates select="$term"/>.</li>
          </xsl:when>
          <xsl:otherwise>
            <li><xsl:apply-templates select="$term"/>;</li>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <li><xsl:call-template name="error_message">
            <xsl:with-param 
              name="message"
              select="concat('Error 12: Can not find term referenced by: ',$ref)"/>
          </xsl:call-template>
        </li>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="definition">
    <xsl:param name="section"/>
    <h4>
      <!-- <xsl:value-of select="$section"/>.<xsl:number/><br/> -->
      <xsl:value-of select="concat($section,'.',position())"/><br/> 
      <xsl:apply-templates select="term"/>
    </h4>
    <xsl:apply-templates select="def"/>
  </xsl:template>
  
  <xsl:template match="def">
    <xsl:apply-templates/>
  </xsl:template>

<xsl:template match="usage_guide">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="express-g">
  <ul>
    <xsl:apply-templates select="imgfile|img" mode="expressg"/>
  </ul>
</xsl:template>

<xsl:template match="imgfile" mode="expressg">
  <xsl:variable name="file">
    <xsl:call-template name="set_file_ext">
      <xsl:with-param name="filename" select="@file"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="module" select="../../../../module/@name"/>
  <xsl:variable name="href" select="concat('../../../modules/', $module, '/', $file)"/>
  <li>
    <a href="{$href}">
	<xsl:apply-templates select="." mode="title"/>
    </a>
  </li>
</xsl:template>

<xsl:template match="imgfile" mode="title">
  <xsl:variable name="number">
    <xsl:number/>
  </xsl:variable>
  <xsl:variable name="fig_no">
    <xsl:choose>
      <xsl:when test="name(../..)='arm'">
        <xsl:choose>
          <xsl:when test="$number=1">
            <xsl:value-of 
              select="concat('Figure F.',$number, 
                      ' - ARM Schema level EXPRESS-G diagram ',$number)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of 
              select="concat('Figure F.',$number, 
                      ' - ARM Entity level EXPRESS-G diagram ',($number - 1))"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="name(../..)='mim'">
        <xsl:choose>
          <xsl:when test="$number=1">
            <xsl:value-of 
              select="concat('Figure A.',$number, 
                      ' - AIM Schema level EXPRESS-G diagram ',$number)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of 
              select="concat('Figure A.',$number, 
                      ' - AIM Entity level EXPRESS-G diagram ',($number - 1))"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$fig_no"/>
</xsl:template>


<xsl:template match="bibliography">
  <!-- output the defaults -->
  <xsl:apply-templates 
    select="document('../../data/basic/bibliography_default.xml')/bibliography/bibitem.inc"/>

  <!-- 
       count how many bitiem.incs are in
       ../data/basic/bibliography_default.xml 
       and start the numbering of the bibitem from there
       -->
  <xsl:variable name="bibitem_inc_cnt" 
    select="count(document('../../data/basic/bibliography_default.xml')/bibliography/bibitem.inc)"/>
  <xsl:apply-templates select="./bibitem">
    <xsl:with-param name="number_start" select="$bibitem_inc_cnt"/>
  </xsl:apply-templates>

  <!-- 
       count how many bitiem.incs are in the current document add that to
       the default bibitem.inc and bibitem in current document and start
       counting from there
       -->
  <xsl:variable name="bibitem_cnt" 
    select="count(./bibitem)"/>

  <xsl:apply-templates select="./bibitem.inc">
    <xsl:with-param name="number_start" select="$bibitem_cnt+1"/>
  </xsl:apply-templates>
</xsl:template>


<xsl:template match="bibitem">
  <!-- the value from which to start the counting. -->
  <xsl:param name="number_start" select="0"/>

  <!-- 
       the value to be used for the number. This is used if the bibitem
       is being displayed from a bibitem.inc
       -->
  <xsl:param name="number_inc" select="0"/>

  <xsl:variable name="number">
    <!-- if the number is provided, use it, else count -->
    <xsl:choose>
      <xsl:when test="$number_inc>0">
        <xsl:value-of select="$number_inc"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:number count="bibitem"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <p>
    [<xsl:value-of select="$number_start+$number"/>] 
	<!--	<xsl:apply-templates select="orgname"/> 
    <xsl:apply-templates select="orgname"/>   -->
    <xsl:apply-templates select="stdnumber"/>
    <xsl:apply-templates select="stdtitle"/>
    <xsl:apply-templates select="subtitle"/>
    <xsl:apply-templates select="pubdate"/>
    <xsl:apply-templates select="ulink"/>
  </p>
</xsl:template>


<xsl:template match="bibitem.inc">
  <!-- the value from which to start the counting. -->
  <xsl:param name="number_start" select="0"/>

  <xsl:variable name="ref" select="@ref"/>
  <xsl:variable name="bibitem" 
    select="document('../../data/basic/bibliography.xml')/bibitem.list/bibitem[@id=$ref]"/>
  
  <xsl:choose>
    <xsl:when test="$bibitem">
      <xsl:apply-templates select="$bibitem">
        <xsl:with-param name="number_start" select="$number_start"/>
        <xsl:with-param name="number_inc" select="position()"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="error_message">
        <xsl:with-param 
          name="message"
          select="concat('Error 13: Can not find bibitem referenced by: ',$ref,
                  'in ../data/basic/bibliography.xml')"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates />
</xsl:template>
</xsl:stylesheet>
