<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: common.xsl,v 1.26 2003/07/31 07:29:41 robbod Exp $
  Author:  Mike Ward, Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose: Display the main set of frames for an AP document.     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../common.xsl"/>
  <xsl:import href="file_ext.xsl"/>
  <xsl:import href="parameters.xsl"/>
	
  <xsl:template name="ap_module_directory">
    <xsl:param name="application_protocol"/>
    <xsl:variable name="mod_dir">
      <xsl:call-template name="module_name">
        <xsl:with-param name="module" select="$application_protocol"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="concat('../../data/modules/', $mod_dir)"/>
  </xsl:template>
	
  <xsl:template name="application_protocol_directory">
    <xsl:param name="application_protocol"/>
    <xsl:variable name="ap_dir">
      <xsl:call-template name="module_name">
        <xsl:with-param name="module" select="$application_protocol"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="concat('../../data/application_protocols/', $ap_dir)"/>
  </xsl:template>
	
  <xsl:template name="check_application_protocol_exists">
    <xsl:param name="application_protocol"/>
    <xsl:variable name="application_protocol_name">
      <xsl:call-template name="module_name">
        <xsl:with-param name="module" select="$application_protocol"/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="ret_val">
      <xsl:choose>
        <xsl:when test="document('../../repository_index.xml')/repository_index/application_protocols/application_protocol[@name=$application_protocol_name]">
          <xsl:value-of select="'true'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat(' The application_protocol ', $application_protocol_name, ' is not identified as an application_protocol module in repository_index.xml')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$ret_val"/>
  </xsl:template>

	<xsl:template name="idef0_icon">
		<xsl:param name="schema"/>
		<xsl:param name="application_protocol_root" select="'..'"/>
		
		<xsl:variable name="application_protocol_dir">
			<xsl:call-template name="application_protocol_directory">
				<xsl:with-param name="application_protocol" select="$schema"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="href_aam">
			<xsl:value-of select="concat($application_protocol_root,'/aamidef01',$FILE_EXT)"/>
		</xsl:variable>
		&#160;&#160;
		<a href="{$href_aam}">
			<img align="middle" border="0" alt="AAM" src="{$application_protocol_root}/../../../images/ap_doc/aam.gif"/>
		</a>
	</xsl:template>
	
	<xsl:template match="module" mode="TOCbannertitle"/>

        <xsl:template match="application_protocol" mode="TOCbannertitle">
		<xsl:param name="selected"/>
		<xsl:param name="module_root" select="'..'"/>
		<xsl:apply-templates select="." mode="rcs_output_ap">
                  <xsl:with-param name="apdoc_root" select="$module_root"/>
                </xsl:apply-templates>

                <xsl:variable name="ap_module" select="@module_name"/>

		<TABLE cellspacing="0" border="0" width="100%">
			<tr>
                          <td>
                          <xsl:call-template name="output_menubar">
                              <xsl:with-param name="module_root" select="$module_root"/>
                              <xsl:with-param name="module_name" select="@name"/>
                            </xsl:call-template>
                          </td>
			</tr>
			<tr>
				<td valign="MIDDLE">
					<B>Application protocol:
						<xsl:call-template name="protocol_display_name">
							<xsl:with-param name="application_protocol" select="@title"/>
						</xsl:call-template>
					</B>
				</td>
				<td valign="MIDDLE" align="RIGHT">
					<xsl:variable name="stdnumber">
						<xsl:call-template name="get_protocol_pageheader">
							<xsl:with-param name="application_protocol" select="."/>
						</xsl:call-template>
					</xsl:variable>
					<b>
						<xsl:value-of select="$stdnumber"/>
						<xsl:variable name="status" select="string(@status)"/>
						<xsl:if test="$status='TS' or $status='DIS' or $status='IS'">
							<br/>
							&#169; ISO
						</xsl:if>
					</b>
				</td>
			</tr>
		</TABLE>
	</xsl:template>
	

	<xsl:template match="application_protocol" mode="rcs_output_ap">
          <xsl:param name="apdoc_root" select="'..'"/>
          <xsl:variable name="icon_path" select="concat($apdoc_root,'/../../../images/')"/>
          <xsl:if test="$output_rcs='YES'">
            <xsl:variable name="ap_mod_dir">
              <xsl:call-template name="application_protocol_directory">
                <xsl:with-param name="application_protocol" select="@name"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="fldr_gif" select="concat($icon_path,'folder.gif')"/>
            <xsl:variable name="proj_gif" select="concat($icon_path,'project.gif')"/>
            <xsl:variable name="ap_file" select="document(concat($ap_mod_dir,'/application_protocol.xml'))"/>
            <xsl:variable name="ap_date" select="translate($ap_file/application_protocol/@rcs.date,'$','')"/>
            <xsl:variable name="ap_rev" select="translate($ap_file/application_protocol/@rcs.revision,'$','')"/>

            <table cellspacing="0" border="0">
              <tr>
                <td>
                  <p class="rcs">
                    <a href="{$apdoc_root}">
                      <img alt="module folder" border="0" align="middle" src="{$fldr_gif}"/>
                    </a>&#160;
                    <xsl:if test="@development.folder">
                      <xsl:variable name="prjmg_href" 
                        select="concat($apdoc_root,'/',@development.folder,'/projmg',$FILE_EXT)"/>
                      <a href="{$prjmg_href}">
                        <img alt="project management summary" border="0" align="middle" src="{$proj_gif}"/>
                      </a>&#160;
                      <xsl:variable name="issue_href" 
                        select="concat($apdoc_root,'/',@development.folder,'/issues',$FILE_EXT)"/>
                      <xsl:variable name="issues_file" 
                        select="concat($ap_mod_dir,'/',@development.folder,'/issues.xml')"/>

                      <xsl:variable name="open_issues" 
                        select="count(document($issues_file)/issues/issue[@status!='closed'])"/>
                      <xsl:variable name="total_issues"
                        select="count(document($issues_file)/issues/issue)"/>

                      <xsl:variable name="issue_gif">
                        <xsl:choose>
                          <xsl:when test="$open_issues>0">
                            <xsl:value-of select="concat($icon_path,'issues.gif')"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="concat($icon_path,'closed.gif')"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:variable>
                      <xsl:if test="$total_issues > 0">
                        <a href="{$issue_href}">
                          <img alt="issues" border="0" align="middle" src="{$issue_gif}"/>
                          <small>
                            [
                            <xsl:value-of select="$open_issues"/>
                            /
                            <xsl:value-of select="$total_issues"/>
                            ]
                          </small>
                        </a>
                        &#160;
                      </xsl:if>
                    </xsl:if>
                  </p>
                </td>
                <td>
                  <font size="-2">
                    <p class="rcs">
                      <xsl:value-of select=" 'application_protocol.xml' "/>
                    </p>
                  </font>
                </td>
                <td>
                  <font size="-2">
                    <p class="rcs">
                      <xsl:value-of select="concat('(',$ap_date,' ',$ap_rev,')')"/>
                    </p>
                  </font>
                </td>
              </tr>
            </table>
          </xsl:if>
        </xsl:template>

	
	<xsl:template match="img">
          <xsl:param name="alt"/>

  <xsl:variable name="src">
    <xsl:choose>
      <xsl:when test="name(..)='imgfile.content'">
        <xsl:value-of select="@src"/>
      </xsl:when>
<xsl:when test="name(..)='ap.imgfile.content'">
        <xsl:value-of select="@src"/>
      </xsl:when>

      <xsl:otherwise>
        <xsl:value-of select="concat('../',@src)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="alt1">
    <xsl:choose>
      <xsl:when test="string-length($alt)>0">
        <xsl:value-of select="$alt"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@src"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <div align="center">
    <xsl:choose>
      <xsl:when test="img.area">
        <IMG src="{$src}" border="0" usemap="#map" alt="{$alt1}">
          <MAP NAME="map">
            <xsl:apply-templates select="img.area"/>
          </MAP>
        </IMG>        
      </xsl:when>
      <xsl:otherwise>
        <IMG src="{$src}" border="0" alt="{$alt1}"/>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

<!-- RBN - not needed
	<xsl:template match="entity|type|schema|constant" mode="expressg_icon">
		<xsl:param name="original_schema"/>
		<xsl:variable name="schema">
			<xsl:choose>
				<xsl:when test="$original_schema">
					<xsl:value-of select="$original_schema"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="../@name"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="ap_module_dir">
			<xsl:call-template name="ap_module_directory">
				<xsl:with-param name="application_protocol" select="$schema"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="module_name">
			<xsl:call-template name="module_name">
				<xsl:with-param name="module" select="$schema"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="href_expg">
			<xsl:choose>
				<xsl:when test="substring($schema,string-length($schema)-3)='_arm'">
					<xsl:choose>
						<xsl:when test="./graphic.element/@page">
							<xsl:value-of select="concat('../../../modules/', $module_name, '/armexpg',./graphic.element/@page,$FILE_EXT)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat('../../../modules/',$module_name,'/armexpg1',$FILE_EXT)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="substring($schema, string-length($schema)-3)='_mim'">
					<xsl:choose>
						<xsl:when test="./graphic.element/@page">
							<xsl:value-of select="concat('../../../modules/',$module_name,'/mimexpg',./graphic.element/@page,$FILE_EXT)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat('../../../modules/',$module_name,'/mimexpg1',$FILE_EXT)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		&#160;&#160;
		<a href="{$href_expg}">
			<img align="middle" border="0" alt="EXPRESS-G" src="../../../../images/expg.gif"/>
		</a>
	</xsl:template>
-->


	<xsl:template name="ap_expressg_icon">
		<xsl:param name="schema"/>
		<xsl:param name="entity"/>
		<xsl:param name="module_root" select="'..'"/>
		<xsl:param name="mod"/>
		<xsl:variable name="href_expg">
			<xsl:choose>
				<xsl:when test="$entity">
					<xsl:choose>
						<xsl:when test="substring($schema,string-length($schema)-3)='_arm'">
							<xsl:choose>
								<xsl:when test="./graphic.element/@page">
									<xsl:value-of select="concat('../../modules/', $mod, '/armexpg',./graphic.element/@page,$FILE_EXT)"/>                  
			      </xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat('../../modules/', $mod, '/armexpg1', $FILE_EXT)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="substring($schema, string-length($schema)-3)='_mim'">
							<xsl:choose>
								<xsl:when test="./graphic.element/@page">
									<xsl:value-of select="concat('../../modules/', $mod, '/mimexpg',./graphic.element/@page,$FILE_EXT)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat('../../modules/', $mod, '/mimexpg1', $FILE_EXT)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="substring($schema, string-length($schema)-3)='_arm'">
							<xsl:value-of select="concat	($module_root,'/../../modules/', $mod, '/armexpg1', $FILE_EXT)"/>
						</xsl:when>
						<xsl:when test="substring($schema, string-length($schema)-3)='_mim'">
							<xsl:value-of select="concat	($module_root,'/../../modules/', $mod, '/mimexpg1', $FILE_EXT)"/>
						</xsl:when>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		&#160;&#160;
		<a href="{$href_expg}">
			<img align="middle" border="0" alt="EXPRESS-G" src="{$module_root}/../../../images/expg.gif"/>
		</a>
	</xsl:template>

<!-- test the WG number. 
     return a string containing Error if incorrect
     
     -->
<xsl:template name="test_wg_number">
  <xsl:param name="wgnumber"/>
  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="ERR" select="'**************************'"/>

  <xsl:variable name="wgnumber_check"
    select="translate(translate($wgnumber,$LOWER,$UPPER),$UPPER,$ERR)"/>

  <xsl:choose>
    <xsl:when test="not($wgnumber)">
      Error WG-1: No WG number provided.
    </xsl:when>

    <xsl:when test="$wgnumber = 00000">
      <!-- the default provided by mkmodule -->
      Error WG-2: No WG number provided (0 is invalid).
    </xsl:when>
   
    <xsl:when test="contains($wgnumber_check,'*')">
      Error WG-3: WG number must be an integer.
    </xsl:when>
    <xsl:otherwise>
      'OK'
    </xsl:otherwise>
  </xsl:choose>
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
                      ' - MIM Schema level EXPRESS-G diagram ',$number)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of 
              select="concat('Figure A.',$number, 
                      ' - MIM Entity level EXPRESS-G diagram ',($number - 1))"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$fig_no"/>
</xsl:template>

<xsl:template match="application_protocol" mode="meta_data">
  <xsl:param name="clause"/>
  <link rel = "schema.DC"
    href    = "http://www.dublincore.org/documents/2003/02/04/dces/"/>

  <xsl:variable name="protocol_name">
    <xsl:call-template name="protocol_display_name">
      <xsl:with-param name="application_protocol" select="@title"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="stdnumber">
    <xsl:call-template name="get_protocol_stdnumber">
      <xsl:with-param name="application_protocol" select="."/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="apdoc_title">
    <xsl:value-of select="concat('Product data representation and exchange: Application protocol: ', $protocol_name)"/>
  </xsl:variable>
  <xsl:call-template name="meta-elements">
    <xsl:with-param name="name" select="'DC.Title'"/>
    <xsl:with-param name="content" select="$apdoc_title"/>
  </xsl:call-template>

  <xsl:variable name="dc.dates"
    select="normalize-space(substring-after((translate(@rcs.date,'$','')),'Date: '))"/>
  <xsl:call-template name="meta-elements">
    <xsl:with-param name="name" select="'DC.Dates'"/>
    <xsl:with-param name="content" select="$dc.dates"/>
  </xsl:call-template>

  <xsl:variable name="editor_ref" select="./contacts/editor/@ref"/>
  <xsl:variable name="editor_contact"
    select="document('../../data/basic/contacts.xml')/contact.list/contact[@id=$editor_ref]"/>
  <xsl:variable name="dc.contributor">
    <xsl:value-of select="normalize-space(concat($editor_contact/lastname,', ',$editor_contact/firstname))"/>
  </xsl:variable>
  <xsl:call-template name="meta-elements">
    <xsl:with-param name="name" select="'DC.Contributor'"/>
    <xsl:with-param name="content" select="$dc.contributor"/>
  </xsl:call-template>

  <xsl:variable name="projlead_ref" select="./contacts/projlead/@ref"/>
  <xsl:variable name="projlead_contact"
    select="document('../../data/basic/contacts.xml')/contact.list/contact[@id=$projlead_ref]"/>
  <xsl:variable name="dc.creator">
    <xsl:value-of select="normalize-space(concat($projlead_contact/lastname,', ',$projlead_contact/firstname))"/>
  </xsl:variable>
  <xsl:call-template name="meta-elements">
    <xsl:with-param name="name" select="'DC.Creator'"/>
    <xsl:with-param name="content" select="$dc.creator"/>
  </xsl:call-template>

  <xsl:call-template name="meta-elements">
    <xsl:with-param name="name" select="'DC.Description'"/>
    <xsl:with-param name="content" select="concat('The application module ',$protocol_name)"/>
  </xsl:call-template>

  <xsl:variable name="keywords">
    <xsl:apply-templates select="./keywords"/>
  </xsl:variable>
  <xsl:call-template name="meta-elements">
    <xsl:with-param name="name" select="'DC.Subject'"/>
    <xsl:with-param name="content" select="normalize-space($keywords)"/>
  </xsl:call-template>

  <xsl:variable name="wg_group">
    <xsl:call-template name="get_module_wg_group"/>
  </xsl:variable>  
  <xsl:variable name="id"
    select="concat('ISO TC184/SC4/WG',$wg_group,'&#160;N',./@wg.number)"/>
  <xsl:variable name="clause_of">
    <xsl:if test="$clause">
      <xsl:value-of select="concat('Clause of ',$clause)"/>
    </xsl:if>
  </xsl:variable>
  <xsl:call-template name="meta-elements">
    <xsl:with-param name="name" select="'DC.Identifier'"/>
    <xsl:with-param name="content" select="$id"/>
  </xsl:call-template>

  <xsl:call-template name="meta-elements">
    <xsl:with-param name="name" select="'STEPMOD.module.rcs.date'"/>
    <xsl:with-param name="content" select="translate(./@rcs.date,'$','')"/>
  </xsl:call-template>

  <xsl:call-template name="meta-elements">
    <xsl:with-param name="name" select="'STEPMOD.module.rcs.revision'"/>
    <xsl:with-param name="content" select="translate(./@rcs.revision,'$','')"/>
  </xsl:call-template>  
  </xsl:template>

  <xsl:template name="count_figures_from_fundamentals">
    <xsl:variable name="dp_figure_count">
      <xsl:value-of select="count(/application_protocol/purpose/data_plan/imgfile)"/>
    </xsl:variable>
    <xsl:variable name="intro_figure_count">
      <xsl:value-of select="count(/application_protocol/purpose//figure)"/>
    </xsl:variable>
    <xsl:value-of select="$dp_figure_count+$intro_figure_count"/>
  </xsl:template>

  <!-- returns a list of annexes with content as a string with each annex name as a single word(no spaces)
       separated by spaces -->
  <xsl:template match="application_protocol" mode="annex_list" >
    <xsl:variable name="module_dir">
      <xsl:call-template name="ap_module_directory">
        <xsl:with-param name="application_protocol" select="@module_name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="annex_list">
      <xsl:if
        test="document(concat($module_dir,'/module.xml'))/module/arm_lf/express-g">
        <xsl:value-of select="' ARMexpressG '"/>
      </xsl:if>
      <xsl:if
        test="document(concat($module_dir,'/module.xml'))/module/mim_lf/express-g">
        <xsl:value-of select="' MIMexpressG '"/>
      </xsl:if>
      <xsl:value-of select="' computerinterpretablelisting '"/>
      <xsl:if test="./usage_guide">
        <xsl:value-of select="' usageguide '"/>
      </xsl:if>
      <xsl:if test="./tech_disc">
        <xsl:value-of select="' techdisc '"/>
      </xsl:if>
      <xsl:if test="./changes/change_detail">
        <xsl:value-of select="' changedetail '"/>
      </xsl:if>
    </xsl:variable>
    <xsl:value-of select="concat(' ',normalize-space($annex_list),' ')"/>
  </xsl:template>


<xsl:template name="annex_letter" >
  <xsl:param name="annex_name"/>
  <xsl:param name="annex_list"/>
  <!-- returns integer count of position of named annex in list of annexes -->
  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>

  <xsl:variable name="annex" select="concat(translate($annex_name,' ',''),' ')"/>

  <xsl:variable name="pos"
    select="string-length(translate(substring-before($annex_list,$annex),concat($UPPER,$LOWER),''))"/>

  <xsl:value-of select="substring('GHIJK',$pos,1)"/> 
</xsl:template>

<xsl:template match="application_protocol" mode="table_count_cc">
  <xsl:value-of  select="count(//purpose//table)+
                         count(//inscope//table) +
                         count(//outscope//table) +
                         count(//changes/change_summary//table) +
                         count(//inforeqt//table)"/>
</xsl:template>

<xsl:template match="application_protocol" mode="this_edition">
  <xsl:if test="@version!='1'">
    <xsl:variable name="this_edition">
      <xsl:choose>
        <xsl:when test="@version='2'">
          second
        </xsl:when>
        <xsl:when test="@version='3'">
          third
        </xsl:when>
        <xsl:when test="@version='4'">
          fourth
        </xsl:when>
        <xsl:when test="@version='5'">
          fifth
        </xsl:when>
        <xsl:when test="@version='6'">
          sixth
        </xsl:when>
        <xsl:when test="@version='7'">
          seventh
        </xsl:when>
        <xsl:when test="@version='8'">
          eighth
        </xsl:when>
        <xsl:when test="@version='9'">
          ninth
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@version"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$this_edition"/>
  </xsl:if>
</xsl:template>

<xsl:template match="application_protocol" mode="previous_edition">
  <xsl:if test="@version!='1'">
    <xsl:variable name="prev_edition">
      <xsl:choose>
        <xsl:when test="@version='2'">
          first
        </xsl:when>
        <xsl:when test="@version='3'">
          second
        </xsl:when>
        <xsl:when test="@version='4'">
          third
        </xsl:when>
        <xsl:when test="@version='5'">
          fourth
        </xsl:when>
        <xsl:when test="@version='6'">
          fifth
        </xsl:when>
        <xsl:when test="@version='7'">
          sixth
        </xsl:when>
        <xsl:when test="@version='8'">
          seventh
        </xsl:when>
        <xsl:when test="@version='9'">
          eighth
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@previous.revision.number"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
      <xsl:value-of select="$prev_edition"/>
  </xsl:if>
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
    <xsl:value-of select="$stdnumber"/>                
  </xsl:template>


  <!--
       A link to a clause or section in this AP document.
       The format of the linkend attribute is:
       purpose - Clause "Introduction"       
       scope - Clause "1 Scope"
       inforeqt - Clause "4"
       aam - Clause "
       imp_meths
       usage_guide
       tech_disc
       express_arm_lf - A EXPRESS expanded listings 
       express_mim_lf - A EXPRESS expanded listings 
       mim_short_names - Annex B MIM short names 
       object_registration - Annex E Information object registration
       
       -->

  <xsl:template match="clause_ref">
    <xsl:variable name="annex_list">
      <xsl:apply-templates select="." mode="annex_list"/>
    </xsl:variable>

    <!-- remove all whitespace -->
    <xsl:variable
      name="nlinkend"
      select="translate(@linkend,'&#x9;&#xA;&#x20;&#xD;','')"/>

    <xsl:variable name="section_tmp">
      <xsl:choose>
        <xsl:when test="contains($nlinkend,':')">
          <xsl:value-of select="substring-before($nlinkend,':')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$nlinkend"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- now check that section is a valid reference -->
    <xsl:variable name="section">
      <xsl:choose>
        <xsl:when test="$section_tmp='purpose'
                       or $section_tmp='scope'
                       or $section_tmp='inforeqt'
                       or $section_tmp='aam'
                       or $section_tmp='imp_meths'
                       or $section_tmp='usage_guide'
                       or $section_tmp='tech_disc'
                       or $section_tmp='express_arm_lf'
                       or $section_tmp='express_mim_lf'
                       or $section_tmp='mim_short_names'
                       or $section_tmp='object_registration'">
          <xsl:value-of select="$section_tmp"/>
        </xsl:when>
        <xsl:otherwise>
          <!--
               error - will be picked up after the  href variable is set.
               -->
          <xsl:value-of select="'error'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable
      name="nlinkend2"
      select="substring-after($nlinkend,':')"/>

    <xsl:variable name="construct_tmp">
      <xsl:choose>
        <xsl:when test="contains($nlinkend2,':')">
          <xsl:value-of select="substring-before($nlinkend2,':')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$nlinkend2"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable
      name="nlinkend3"
      select="substring-after($nlinkend2,':')"/>

    <xsl:variable name="id">
      <xsl:choose>
        <xsl:when test="contains($nlinkend3,':')">
          <xsl:value-of select="substring-before($nlinkend3,':')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$nlinkend3"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="construct">
      <xsl:choose>
        <!-- test that a valid value is given for construct -->
        <xsl:when test="$construct_tmp='example'
                        or $construct_tmp='note'
                        or $construct_tmp='figure'
                        or $construct_tmp='table'">
          <xsl:choose>
            <!-- test that an id has been given -->
            <xsl:when test="$id!=''">
              <xsl:value-of select="concat('#',$construct_tmp,'_',$id)"/>
            </xsl:when>
            <xsl:otherwise>
              <!--
                   error - will be picked up after the  href variable is set.
                   -->
              <xsl:value-of select="'error'"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>

        <!-- data_plan links dealt with on output below -->
        <xsl:when test="$construct_tmp='data_plan'">
          <xsl:value-of select="'data_plan'"/>
        </xsl:when>

        <xsl:when test="$construct_tmp=''"/>

        <xsl:otherwise>
          <!--
               error - will be picked up after the  href variable is set.
               -->
          <xsl:value-of select="'error'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$section='error'">
        <xsl:call-template name="error_message">
          <xsl:with-param
            name="message"
            select="concat('ERROR clause_ref1: clause_ref linkend #',
                    $nlinkend,
                    '# is incorrectly specified.')"/>
        </xsl:call-template>
      </xsl:when>
      
      <xsl:when test="$section='purpose'">
        <xsl:choose>
          <xsl:when test="$construct='data_plan'">
            <xsl:variable name="dp_file">
              <xsl:call-template name="set_file_ext">
                <xsl:with-param name="filename" 
                  select="//purpose/data_plan/imgfile[position()=$id]/@file"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="figure_count">
              <xsl:call-template name="count_figures_from_fundamentals"/>
            </xsl:variable>
            Figure <a href="../{$dp_file}"><xsl:value-of select="$id"/></a>
          </xsl:when>

          <xsl:when test="string-length($construct)">
            <a href="introduction{$FILE_EXT}{$construct}"><xsl:apply-templates/></a>              
          </xsl:when>
          <xsl:otherwise>
            <a href="introduction{$FILE_EXT}">Introduction</a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      
      <xsl:when test="$section='scope'">
        <xsl:choose>
          <xsl:when test="string-length($construct)">
            <a href="1_scope{$FILE_EXT}"><xsl:apply-templates/></a>
          </xsl:when>
          <xsl:otherwise>
            Clause<a href="1_scope{$FILE_EXT}">1</a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$section='inforeqt'">
        <xsl:choose>
          <xsl:when test="$construct='data_plan'">
            <xsl:variable name="dp_file">
              <xsl:call-template name="set_file_ext">
                <xsl:with-param name="filename" 
                  select="//inforeqt/fundamentals/data_plan/imgfile[$id]/@file"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="figure_count">
              <xsl:call-template name="count_figures_from_fundamentals"/>
            </xsl:variable>
            Figure <a href="../{$dp_file}"><xsl:value-of select="$figure_count+1"/></a>
          </xsl:when>

          <xsl:when test="string-length($construct)">
            <a href="4_info_reqs{$FILE_EXT}"><xsl:apply-templates/></a>
          </xsl:when>
          <xsl:otherwise>
            Clause<a href="4_info_reqs{$FILE_EXT}">4</a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$section='aam'">
        <xsl:choose>
          <xsl:when test="string-length($construct)">
            <a href="annex_aam{$FILE_EXT}"><xsl:apply-templates/></a>
          </xsl:when>
          <xsl:otherwise>
            Annex <a href="annex_aam{$FILE_EXT}">F</a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$section='imp_meths'">
        <xsl:choose>
          <xsl:when test="string-length($construct)">
            <a href="annex_imp_meth{$FILE_EXT}"><xsl:apply-templates/></a>
          </xsl:when>
          <xsl:otherwise>
            Annex <a href="annex_imp_meth{$FILE_EXT}">C</a>  
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$section='usage_guide'">
        <xsl:variable name="annex">
          <xsl:call-template name="annex_letter" >
            <xsl:with-param name="annex_name" select="'usageguide'"/>
            <xsl:with-param name="annex_list" select="$annex_list"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="string-length($construct)">
            <a href="annex_guide{$FILE_EXT}"><xsl:apply-templates/></a>
          </xsl:when>
          <xsl:otherwise>
            Annex <a href="annex_guide{$FILE_EXT}"><xsl:value-of select="$annex"/></a> 
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$section='tech_disc'">
        <xsl:variable name="annex">
          <xsl:call-template name="annex_letter" >
            <xsl:with-param name="annex_name" select="'techdisc'"/>
            <xsl:with-param name="annex_list" select="$annex_list"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="string-length($construct)">
            <a href="annex_tech_disc{$FILE_EXT}"><xsl:apply-templates/></a>
          </xsl:when>
          <xsl:otherwise>
            Annex <a href="annex_tech_disc{$FILE_EXT}"><xsl:value-of select="$annex"/></a> 
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$section='express_arm_lf'">
        <xsl:choose>
          <xsl:when test="string-length($construct)">
            <a href="annex_exp_lf{$FILE_EXT}"><xsl:apply-templates/></a>
          </xsl:when>
          <xsl:otherwise>
            Annex <a href="annex_exp_lf{$FILE_EXT}">A.1</a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$section='express_mim_lf'">
        <xsl:choose>
          <xsl:when test="string-length($construct)">
            <a href="annex_exp_lf{$FILE_EXT}"><xsl:apply-templates/></a>
          </xsl:when>
          <xsl:otherwise>
            Annex <a href="annex_exp_lf{$FILE_EXT}">A.2</a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$section='mim_short_names'">
        <xsl:choose>
          <xsl:when test="string-length($construct)">
            <a href="annex_shortnames{$FILE_EXT}"><xsl:apply-templates/></a>
          </xsl:when>
          <xsl:otherwise>
            Annex <a href="annex_shortnames{$FILE_EXT}">B</a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$section='object_registration'">
        <xsl:choose>
          <xsl:when test="string-length($construct)">
            <a href="annex_obj_reg{$FILE_EXT}"><xsl:apply-templates/></a>
          </xsl:when>
          <xsl:otherwise>
            Annex <a href="annex_obj_reg{$FILE_EXT}">E</a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>


</xsl:stylesheet>

