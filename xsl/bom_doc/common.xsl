<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: common.xsl,v 1.6 2012/12/19 10:30:56 robbod Exp $
  Author:  Mike Ward, Eurostep Limited
  Owner:   Developed by Eurostep Limited.
  Purpose: Display the main set of frames for a BOM document.     
-->

<!-- BOM -->


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../common.xsl"/>
  <xsl:import href="file_ext.xsl"/>
  <xsl:import href="parameters.xsl"/>
  
 <xsl:template name="business_object_model_directory">
    <xsl:param name="business_object_model"/>
    <xsl:variable name="bom_dir">
      <xsl:call-template name="business_object_model_name">
        <xsl:with-param name="business_object_model" select="$business_object_model"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="concat('../../data/business_object_models/', $bom_dir)"/>
  </xsl:template>
  
  <xsl:template name="check_model_exists">
    <xsl:param name="model"/>
    
     <xsl:variable name="model_title" select="//business_object_model/@title"/>
          
    <xsl:variable name="ret_val">
      <xsl:choose>
        <xsl:when
          test="document('../../repository_index.xml')/repository_index/business_object_models/business_object_model[@name=$model]">
          <xsl:value-of select="'true'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of
            select="concat(' The business object model ', $model_title,
            ' is not identified as a model in repository_index.xml')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$ret_val"/>
  </xsl:template>
  
  <xsl:template name="business_object_model_name">
    <xsl:param name="business_object_model"/>
    <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
    <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
    <xsl:variable name="first_char" 
      select="translate(substring($business_object_model,1,1),$UPPER,$LOWER)"/>
    <xsl:value-of 
      select="concat($first_char,substring($business_object_model,2))"/>
  </xsl:template>
  
  <xsl:template name="get_model_stdnumber">
    <xsl:param name="model"/>
    <xsl:variable name="part">
      <xsl:choose>
        <xsl:when test="string-length($model/@part)>0">
          <xsl:value-of select="$model/@part"/>
        </xsl:when>
        <xsl:otherwise>
          &lt;part&gt;
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="status">
      <xsl:choose>
        <xsl:when test="string-length($model/@status)>0">
          <xsl:value-of select="string($model/@status)"/>
        </xsl:when>
        <xsl:otherwise>
          &lt;status&gt;
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <!-- 
      Note, if the standard has a status of CD or CD-TS it has not been
      published - so overide what ever is the @publication.year 
    -->
    
    <xsl:variable name="pub_year">
      <xsl:choose>
        <xsl:when test="$status='CD' or $status='CD-TS'">&#8212;</xsl:when>
        <xsl:when test="string-length($model/@publication.year)">
          <xsl:value-of select="$model/@publication.year"/>
        </xsl:when>
        <xsl:otherwise>
          &lt;publication.year&gt;
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="orgname" select="'ISO'"/>
    
    <xsl:value-of select="concat($orgname,'/',$status,' 10303-',$part,':',$pub_year)"/>
    
  </xsl:template>
  
 
  <xsl:template match="business_object_model" mode="meta_data">
    <xsl:param name="clause"/>
    <link rel = "schema.DC" href="http://www.dublincore.org/documents/2003/02/04/dces/"/>
    
   <xsl:variable name="model_name" select="./@title"/>
       
    <xsl:variable name="stdnumber">
      <xsl:call-template name="get_model_pageheader">
        <xsl:with-param name="business_object_model" select="."/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="model_title">
      <xsl:value-of select="concat('Product data representation and exchange: Business object model: ', $model_name)"/>
    </xsl:variable>
    
     <xsl:call-template name="meta-elements">
      <xsl:with-param name="name" select="'DC.Title'"/>
      <xsl:with-param name="content" select="$model_title"/>
    </xsl:call-template>
    
   <xsl:variable name="dc.dates" select="normalize-space(substring-after((translate(@rcs.date,'$/',' -')),'Date:'))"/>
    
    <xsl:call-template name="meta-elements">
      <xsl:with-param name="name" select="'DC.Dates'"/>
      <xsl:with-param name="content" select="$dc.dates"/>
    </xsl:call-template>
    
    <xsl:variable name="published" select="@publication.date"/>
    
    <xsl:call-template name="meta-elements">
      <xsl:with-param name="name" select="'DC.Published'"/>
      <xsl:with-param name="content" select="$published"/>
    </xsl:call-template>
        
    <xsl:variable name="editor_ref" select="./contacts/editor/@ref"/>
        
    <xsl:variable name="editor_contact" select="document('../../data/basic/contacts.xml')/contact.list/contact[@id=$editor_ref]"/>
        
    <xsl:variable name="dc.contributor">
      <xsl:value-of select="normalize-space(concat($editor_contact/lastname,', ',$editor_contact/firstname))"/>
    </xsl:variable>
    
    <xsl:call-template name="meta-elements">
      <xsl:with-param name="name" select="'DC.Contributor'"/>
      <xsl:with-param name="content" select="$dc.contributor"/>
    </xsl:call-template>
    
    <xsl:variable name="projlead_ref" select="./contacts/projlead/@ref"/>
    
    <xsl:variable name="projlead_contact" select="document('../../data/basic/contacts.xml')/contact.list/contact[@id=$projlead_ref]"/>
    
    <xsl:variable name="dc.creator">
      <xsl:value-of select="normalize-space(concat($projlead_contact/lastname,', ',$projlead_contact/firstname))"/>
    </xsl:variable>
    
    <xsl:call-template name="meta-elements">
      <xsl:with-param name="name" select="'DC.Creator'"/>
      <xsl:with-param name="content" select="$dc.creator"/>
    </xsl:call-template>
    
    <xsl:call-template name="meta-elements">
      <xsl:with-param name="name" select="'DC.Description'"/>
      <xsl:with-param name="content" select="concat('The business object model: ',$model_name)"/>
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
    
    <xsl:variable name="id" select="concat('ISO/TC 184/SC 4/WG ',$wg_group,' N',./@wg.number)"/>
   
    <xsl:variable name="clause_of">
      <xsl:if test="$clause">
        <xsl:value-of select="concat('Clause of ',$clause)"/>
      </xsl:if>
    </xsl:variable>
    
    <xsl:call-template name="meta-elements">
      <xsl:with-param name="name" select="'DC.Identifier'"/>
      <xsl:with-param name="content" select="$id"/>
    </xsl:call-template>
    
    <xsl:variable name="supersedes" select="concat('ISO/TC 184/SC 4/WG ',$wg_group,' N',./@wg.number.supersedes)"/>
    
    <xsl:call-template name="meta-elements">
      <xsl:with-param name="name" select="'DC.Replaces'"/>
      <xsl:with-param name="content" select="$supersedes"/>
    </xsl:call-template>
    
    <xsl:call-template name="meta-elements">
      <xsl:with-param name="name" select="'SC4.version'"/>
      <xsl:with-param name="content" select="./@version"/>
    </xsl:call-template>
    
    <xsl:variable name="checklist.internal_review" select="concat('ISO/TC 184/SC 4/WG ',$wg_group,' N',./@checklist.internal_review)"/>
    
    <xsl:call-template name="meta-elements">
      <xsl:with-param name="name" select="'SC4.checklist.internal_review'"/>
      <xsl:with-param name="content" select="$checklist.internal_review"/>
    </xsl:call-template>
    
    <xsl:variable name="checklist.project_leader" select="concat('ISO/TC 184/SC 4/WG ',$wg_group,' N',./@checklist.project_leader)"/>
    
    <xsl:call-template name="meta-elements">
      <xsl:with-param name="name" select="'SC4.checklist.project_leader'"/>
      <xsl:with-param name="content" select="$checklist.project_leader"/>
    </xsl:call-template>
    
    <xsl:variable name="checklist.convener" select="concat('ISO/TC 184/SC 4/WG ',$wg_group,' N',./@checklist.convener)"/>
    
    <xsl:call-template name="meta-elements">
      <xsl:with-param name="name" select="'SC4.checklist.convener'"/>
      <xsl:with-param name="content" select="$checklist.convener"/>
    </xsl:call-template>
        
   <xsl:call-template name="meta-elements">
     <xsl:with-param name="name" select="'STEPMOD.model.rcs.date'"/>
      <xsl:with-param name="content" select="normalize-space(translate(./@rcs.date,'$/',' -'))"/>
    </xsl:call-template>
    
   <xsl:call-template name="meta-elements">
      <xsl:with-param name="name" select="'STEPMOD.model.rcs.revision'"/>
      <xsl:with-param name="content" select="normalize-space(translate(./@rcs.revision,'$',''))"/>
    </xsl:call-template>
    
    <xsl:variable name="revstring" select="'Revision:'"/>
    
    <xsl:call-template name="meta-elements">
      <xsl:with-param name="name" select="'PART1000.model.rcs.revision'"/>
      <xsl:with-param name="content" select="concat('$',string($revstring),' $')"/>
    </xsl:call-template>
    
    <xsl:variable name="datestring" select="'Date:'"/>
    
    <xsl:call-template name="meta-elements">
      <xsl:with-param name="name" select="'PART1000.model.rcs.date'"/>
      <xsl:with-param name="content" select="concat('$',string($datestring),' $')"/>
    </xsl:call-template>    
    
  </xsl:template>
 
  <xsl:template name="business_object_model_display_name">
    <xsl:param name="model"/>
    <xsl:variable name="bom_dir">
      <xsl:call-template name="business_object_model_directory">
        <xsl:with-param name="business_object_model" select="$model"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
    <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
    <xsl:variable name="first_char" select="substring(translate($model,$LOWER,$UPPER),1,1)"/>
    <xsl:variable name="business_object_model_name" select="concat($first_char, translate(substring($model,2),'_',' '))"/>
    <xsl:value-of select="$business_object_model_name"/>
  </xsl:template>
  
  
  <!--<xsl:template name="idef0_icon">
    <xsl:param name="schema"/>
    <xsl:param name="business_object_model_root" select="'..'"/>
    
    <xsl:variable name="business_object_model_dir">
      <xsl:call-template name="business_object_model_directory">
        <xsl:with-param name="business_object_model" select="$schema"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="imgfile_xml"
      select="document(concat($business_object_model_dir,'/business_object_model.xml'))//idef0/imgfile[1]/@file"/>

    <xsl:variable name="imgfile">
      <xsl:call-template name="set_file_ext">
        <xsl:with-param name="filename" select="$imgfile_xml"/> 
      </xsl:call-template>
    </xsl:variable>
  

    <xsl:variable name="href_aam">
      <xsl:value-of select="concat($business_object_model_root,'/',$imgfile)"/>
    </xsl:variable>
    &#160;&#160;
    <a href="{$href_aam}">
      <img align="middle" border="0" alt="AAM" src="{$business_object_model_root}/../../../images/ap_doc/aam.gif"/>
    </a>
  </xsl:template>-->
	
  <!--<xsl:template match="business_object_model" mode="TOCbannertitle"/>-->

  <xsl:template match="business_object_model" mode="TOCbannertitle">
		<xsl:param name="selected"/>
    <xsl:param name="business_object_model_root" select="'..'"/>
		<xsl:apply-templates select="." mode="rcs_output_ap">
		  <xsl:with-param name="bomdoc_root" select="$business_object_model_root"/>
                </xsl:apply-templates>

    <xsl:variable name="bom_module" select="@business_object_model_name"/>

		<TABLE cellspacing="0" border="0" width="100%">
			<tr>
                          <td>
                          <!--<xsl:call-template name="output_menubar">
                            <xsl:with-param name="business_object_model_root" select="$business_object_model_root"/>
                            <xsl:with-param name="business_object_model_name" select="@name"/>
                            </xsl:call-template>-->
                          </td>
			</tr>
			<tr>
				<td valign="MIDDLE">
					<B>Business object model:
					  <!--<xsl:call-template name="business_object_model_display_name">
						  <xsl:with-param name="business_object_model" select="@title"/>
						</xsl:call-template>-->
					</B>
				</td>
				<td valign="MIDDLE" align="RIGHT">
					<xsl:variable name="stdnumber">
						<!--<xsl:call-template name="get_model_pageheader">
						  <xsl:with-param name="business_object_model" select="."/>
						</xsl:call-template>-->
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
	

  <xsl:template match="business_object_model" mode="rcs_output_bom">
          <xsl:param name="bomdoc_root" select="'..'"/>
          <xsl:variable name="icon_path" select="concat($bomdoc_root,'/../../../images/')"/>
         <!-- <xsl:if test="$output_rcs='YES'">
            <xsl:variable name="ap_mod_dir">
              <xsl:call-template name="business_object_model_directory">
                <xsl:with-param name="business_object_model" select="@name"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="fldr_gif" select="concat($icon_path,'folder.gif')"/>
            <xsl:variable name="proj_gif" select="concat($icon_path,'project.gif')"/>
            <xsl:variable name="ap_file" select="document(concat($ap_mod_dir,'/business_object_model.xml'))"/>
            <xsl:variable name="ap_date" select="translate($ap_file/business_object_model/@rcs.date,'$','')"/>
            <xsl:variable name="ap_rev" select="translate($ap_file/business_object_model/@rcs.revision,'$','')"/>

            <table cellspacing="0" border="0">
              <tr>
                <td>
                  <p class="rcs">
                    <a href="{$bomdoc_root}">
                      <img alt="module folder" border="0" align="middle" src="{$fldr_gif}"/>
                    </a>&#160;
                    <xsl:if test="@development.folder">
                      <xsl:variable name="prjmg_href" 
                        select="concat($bomdoc_root,'/',@development.folder,'/projmg',$FILE_EXT)"/>
                      <a href="{$prjmg_href}">
                        <img alt="project management summary" border="0" align="middle" src="{$proj_gif}"/>
                      </a>&#160;
                      <xsl:variable name="issue_href" 
                        select="concat($bomdoc_root,'/',@development.folder,'/issues',$FILE_EXT)"/>
                      <!-\-<xsl:variable name="issues_file" 
                        select="concat($bom_dir, '/', @development.folder, '/issues.xml')"/>
                      -\->
                      
                      <xsl:variable name="issues_file" 
                        select="concat('/', @development.folder, '/issues.xml')"/>
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
                      <xsl:value-of select=" 'business_object_model.xml' "/>
                    </p>
                  </font>
                </td>
                <td>
                  <font size="-2">
                    <p class="rcs">
                      <!-\-<xsl:value-of select="concat('(',$bom_date,' ',$bom_rev,')')"/>-\->
                    </p>
                  </font>
                </td>
              </tr>
            </table>
          </xsl:if>-->
        </xsl:template>

	
	<xsl:template match="img">
          <xsl:param name="alt"/>

  <xsl:variable name="src">
    <xsl:choose>
      <xsl:when test="name(..)='imgfile.content'">
        <xsl:value-of select="@src"/>
      </xsl:when>
<xsl:when test="name(..)='bom.imgfile.content'">
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
          <MAP ID="map" NAME="map">
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
			<xsl:value-of select="concat('../../modules/', $mod, '/bomexpg',./graphic.element/@page,$FILE_EXT)"/>                  
		      </xsl:when>
		      <xsl:otherwise>
			<xsl:value-of select="concat('../../modules/', $mod, '/bomexpg1', $FILE_EXT)"/>
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
		  <xsl:when test="substring($schema, string-length($schema)-3)='_bom'">
		    <xsl:value-of select="concat	($module_root,'/../../business_object_models/', $mod, '/bomexpg1', $FILE_EXT)"/>
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
  <xsl:variable name="model" select="//business_object_model/@name"/>
  <xsl:variable name="href" select="concat('../../../business_object_models/', $model, '/', $file)"/>
  
    <a href="{$href}" target="_self">
	<xsl:apply-templates select="." mode="title"/>
    </a>
  
  <br/>
</xsl:template>

<xsl:template match="imgfile" mode="title">
  <xsl:variable name="number">
    <xsl:number/>
  </xsl:variable>
  <xsl:variable name="fig_no">
    <xsl:choose>
      <xsl:when test="name(../..)='bom'">
        <xsl:choose>
          <xsl:when test="$number=1">
            <xsl:value-of 
              select="concat('Figure C.',$number, 
                      ' - BOM Schema level EXPRESS-G diagram ',$number)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of 
              select="concat('Figure C.',$number, 
                      ' - BOM Entity level EXPRESS-G diagram ',($number - 1))"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$fig_no"/>
</xsl:template>


  <xsl:template name="count_figures_from_fundamentals">
    <xsl:variable name="dp_figure_count">
      <xsl:value-of select="count(/business_object_model/purpose/data_plan/imgfile)"/>
    </xsl:variable>
    <xsl:variable name="intro_figure_count">
      <xsl:value-of select="count(/business_object_model/purpose//figure)"/>
    </xsl:variable>
    <xsl:value-of select="$dp_figure_count+$intro_figure_count"/>
  </xsl:template>

  <!-- returns a list of annexes with content as a string with each annex name as a single word(no spaces)
       separated by spaces -->
  <xsl:template match="business_object_model" mode="annex_list" >
    <xsl:variable name="module_dir">
      <xsl:call-template name="business_object_model_directory">
        <xsl:with-param name="business_object_model" select="@module_name"/>
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

  <xsl:value-of select="substring('GHIJKL',$pos,1)"/> 
</xsl:template>

<xsl:template match="business_object_model" mode="table_count_cc">
  <xsl:value-of  select="count(//purpose//table)+
                         count(//inscope//table) +
                         count(//outscope//table) +
                         count(//changes/change_summary//table) +
                         count(//inforeqt//table)"/>
</xsl:template>

<xsl:template match="business_object_model" mode="this_edition">
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

<xsl:template match="business_object_model" mode="previous_edition">
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
    The concept of priority between homonym templates is used to display either the business object model
       file content or the ap module file content -->
  
  <!--<xsl:template match="business_object_model" mode="title">
    <xsl:variable name="stdnumber">
      <xsl:call-template name="get_model_pageheader">
        <xsl:with-param name="business_object_model" select="."/>
      </xsl:call-template>
    </xsl:variable>
    
   
    
    <xsl:variable name="model_name">
      <!-\-<xsl:call-template name="model_display_name">
        <xsl:with-param name="business_object_model" select="@name"/>
      </xsl:call-template>-\->
    </xsl:variable>
    <xsl:value-of select="$stdnumber"/>                
  </xsl:template>-->

  <xsl:template name="get_model_pageheader">
    <xsl:param name="business_object_model"/>
    <xsl:variable name="part">
      <xsl:choose>
        <xsl:when test="string-length($business_object_model/@part)>0">
          <xsl:value-of select="$business_object_model/@part"/>
        </xsl:when>
        <xsl:otherwise>
          &lt;part&gt;
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="status">
      <xsl:choose>
        <xsl:when test="string-length($business_object_model/@status)>0">
          <xsl:value-of select="string($business_object_model/@status)"/>
        </xsl:when>
        <xsl:otherwise>
          &lt;status&gt;
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="language">
      <xsl:choose>
        <xsl:when test="string-length($business_object_model/@language)">
          <xsl:value-of select="$business_object_model/@language"/>
        </xsl:when>
        <xsl:otherwise>
          E
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <!-- 
      Note, if the standard has a status of CD or CD-TS it has not been
      published - so overide what ever is the @publication.year 
    -->
    <xsl:variable name="pub_year">
      <xsl:choose>
        <xsl:when test="$status='CD' or $status='CD-TS'">-</xsl:when>
        <xsl:when test="string-length($business_object_model/@publication.year)">
          <xsl:value-of select="$business_object_model/@publication.year"/>
        </xsl:when>
        <xsl:otherwise>
          &lt;publication.year&gt;
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="orgname" select="'ISO'"/>
    
    <xsl:variable name="stdnumber">
      <xsl:choose>
        <xsl:when test="$status='FDIS' or $status='TS'">
          <xsl:value-of 
            select="concat($orgname,'/',$status,' 10303-',$part,':',$pub_year,'(',$language,') ')"/>
        </xsl:when>
        <xsl:when test="$status='IS'">
          <xsl:value-of 
            select="concat($orgname,' 10303-',$part,':',$pub_year,'(',$language,') ')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of 
            select="concat($orgname,'/',$status,' 10303-',$part)"/>          
        </xsl:otherwise>
      </xsl:choose>
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
                       or $section_tmp='definition'
                       or $section_tmp='inforeqt'
                       or $section_tmp='fundamentals'
                       or $section_tmp='aam'
                       or $section_tmp='conformance'
                       or $section_tmp='imp_meths'
                       or $section_tmp='usage_guide'
                       or $section_tmp='change_detail'
                       or $section_tmp='tech_disc'
                       or $section_tmp='express_arm_lf'
                       or $section_tmp='express_mim_lf'
                       or $section_tmp='mim_short_names'
                       or $section_tmp='object_registration'
                       or $section_tmp='detailed_changes'
                       or $section_tmp='bibliography'">
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
          <xsl:value-of select="normalize-space(substring-before($nlinkend2,':'))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="normalize-space($nlinkend2)"/>
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
                        or $construct_tmp='table'
                        or $construct_tmp='cc'
                        or $construct_tmp='co'                        
                        or $construct_tmp='bibitem'">
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

        <!-- AAM definition don't have construct as prefix -->
        <xsl:when test="$construct_tmp='activity'
                        or $construct_tmp='icom'">
          <xsl:choose>
            <!-- test that an id has been given -->
            <xsl:when test="$id!=''">
              <xsl:value-of select="concat('#',$id)"/>
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

        <xsl:when test="string-length($construct_tmp)=0"/>
          

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
        <!--<xsl:call-template name="error_message">
          <xsl:with-param
            name="message"
            select="concat('ERROR clause_ref1: clause_ref linkend #',
                    $nlinkend,
                    '# is incorrectly specified.')"/>
        </xsl:call-template>-->
      </xsl:when>
      
      <xsl:when test="$section='purpose'">
        <xsl:choose>
          <xsl:when test="$construct='data_plan'">
            <xsl:variable name="dp_file">
              <!--<xsl:call-template name="set_file_ext">
                <xsl:with-param name="filename" 
                  select="//purpose/data_plan/imgfile[position()=$id]/@file"/>
              </xsl:call-template>-->
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
            Clause <a href="1_scope{$FILE_EXT}">1</a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$section='definition'">
        <xsl:variable name="def_href" select="concat('term-',substring-after(@linkend,':'))"/>
        <xsl:choose>
          <xsl:when test="string-length($construct)">
            <a href="3_defs{$FILE_EXT}#{$def_href}"><xsl:apply-templates/></a>
          </xsl:when>
          <xsl:otherwise>
            Clause <a href="3_defs{$FILE_EXT}"></a>
          </xsl:otherwise>
        </xsl:choose>

      </xsl:when>

      <xsl:when test="$section='inforeqt'">
        <xsl:choose>
          <xsl:when test="$construct='data_plan'">
            <xsl:variable name="dp_file">
              <!--<xsl:call-template name="set_file_ext">
                <xsl:with-param name="filename" 
                  select="//inforeqt/fundamentals/data_plan/imgfile[$id]/@file"/>
              </xsl:call-template>-->
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
            Clause <a href="4_info_reqs{$FILE_EXT}">4</a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$section='fundamentals'">
        <xsl:choose>
          <xsl:when test="$construct='data_plan'">
            <xsl:variable name="dp_file">
              <!--<xsl:call-template name="set_file_ext">
                <xsl:with-param name="filename" 
                  select="//inforeqt/fundamentals/data_plan/imgfile[$id]/@file"/>
              </xsl:call-template>-->
            </xsl:variable>
            <xsl:variable name="figure_count">
              <xsl:call-template name="count_figures_from_fundamentals"/>
            </xsl:variable>
            Figure <a href="../{$dp_file}"><xsl:value-of select="$figure_count+1"/></a>
          </xsl:when>

          <xsl:when test="string-length($construct)!=0">
            <a href="4_info_reqs{$FILE_EXT}"><xsl:apply-templates/></a>
          </xsl:when>
          <xsl:otherwise>
            Clause <a href="4_info_reqs{$FILE_EXT}#41">4.1</a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$section='aam'">
        <xsl:choose>
          <xsl:when test="string-length($construct)">
            <a href="annex_aam{$FILE_EXT}{$construct}"><xsl:apply-templates/></a>
          </xsl:when>
          <xsl:otherwise>
            Annex <a href="annex_aam{$FILE_EXT}{$construct}"><xsl:value-of select="concat('F.',$id)"/></a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$section='conformance'">
        <xsl:choose>
          <xsl:when test="string-length($construct)">
            <a href="6_ccs{$FILE_EXT}{$construct}"><xsl:apply-templates/></a>
          </xsl:when>
          <xsl:otherwise>
            Clause <a href="6_ccs{$FILE_EXT}{$construct}"><xsl:value-of select="concat('6.',$id)"/></a>
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

      <xsl:when test="$section='detailed_changes'">
        <xsl:choose>
          <xsl:when test="string-length($construct)">
            <a href="annex_changes{$FILE_EXT}"><xsl:apply-templates/></a>
          </xsl:when>
          <xsl:otherwise>
            Annex <a href="annex_changes{$FILE_EXT}">H</a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$section='bibliography'">
        <xsl:choose>
          <xsl:when test="string-length($construct)">
            <a href="biblio{$FILE_EXT}{$construct}">
	    <xsl:apply-templates/>
	    <xsl:apply-templates select="." mode="bibitem"><xsl:with-param name="id" select="$id"/>
	    </xsl:apply-templates></a>
          </xsl:when>
          <xsl:otherwise>
            the Bibliography <a href="biblio{$FILE_EXT}"></a> 
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

    </xsl:choose>
  </xsl:template>


  <xsl:template match="clause_ref" mode="bibitem">
    <xsl:param name="id" />
    <!-- output the defaults -->
  <xsl:choose>
    <xsl:when test="document('../../data/basic/ap_doc/bibliography_default.xml')/bibliography/bibitem.inc[@ref=$id]">[ <xsl:value-of select="count(document('../../data/basic/ap_doc/bibliography_default.xml')/bibliography/bibitem.inc[@ref=$id])"/>]</xsl:when>
    <xsl:when test="/business_object_model/bibliography/bibitem.inc[@ref=$id]">[<xsl:value-of 
    select="count(/business_object_model/bibliography/bibitem.inc[@ref=$id]/preceding-sibling::*) + count(document('../../data/basic/ap_doc/bibliography_default.xml')/bibliography/bibitem.inc) + 1"/>]</xsl:when>
    <xsl:otherwise>
      <xsl:variable name="err">
      <!--<xsl:call-template name="error_message">
        <xsl:with-param 
          name="message"
          select="concat('Error 14: Can not find bibitem referenced by: ',$id,
                  ' in ../../data/basic/ap_doc/bibliography_default.xml or in bibliography')"/>
      </xsl:call-template>-->
      </xsl:variable>
      <xsl:value-of select="$err"/>
    </xsl:otherwise>
  </xsl:choose>


    <xsl:apply-templates 
	select="document('../../data/basic/ap_doc/bibliography_default.xml')/bibliography/bibitem.inc"/>

    <!-- 
	 count how many bitiem.incs are in
	 ../data/basic/bibliography_default.xml 
	 and start the numbering of the bibitem from there
    -->
    <xsl:variable name="bibitem_inc_cnt" 
		  select="count(document('../../data/basic/ap_doc/bibliography_default.xml')/bibliography/bibitem.inc)"/>

    <xsl:apply-templates select="./bibitem">
      <xsl:with-param name="number_start" select="$bibitem_inc_cnt"/>
    </xsl:apply-templates>

    <!-- 
	 count how many bitiem.incs are in the current document add that to
	 the default bibitem.inc and bibitem in current document and start
	 counting from there
    -->
    <xsl:variable name="bibitem_cnt" 
		  select="count(./bibitem)+$bibitem_inc_cnt"/>

    <xsl:apply-templates select="./bibitem.inc">
      <xsl:with-param name="number_start" select="$bibitem_cnt"/>
    </xsl:apply-templates>
  </xsl:template>


  <xsl:template match="bibitem" mode="number">
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
    <xsl:value-of select="$number"/>
  </xsl:template>

  <xsl:template match="annex_clause">
    <xsl:variable name="title" select="@title"/>
    <xsl:variable name="sect_no">
      <xsl:apply-templates select="." mode="number"/>
    </xsl:variable>
    <xsl:variable name="annex">
      <xsl:choose>
        <xsl:when test="ancestor::*[name()='tech_disc']">techdisc</xsl:when>
        <xsl:when test="ancestor::*[name()='usage_guide']">usageguide</xsl:when>
        <xsl:when test="ancestor::*[name()='change_detail']">changedetail</xsl:when>
        <xsl:otherwise>ERROR</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>


    <xsl:if test="$annex='ERROR'">
      <!--<xsl:call-template name="error_message">
        <xsl:with-param
          name="message"
          select="'ERROR annex_clause: You can only use annex_clause in tech_disc and usage_guide and change_detail'"/>
      </xsl:call-template>-->      
    </xsl:if>

    <xsl:variable name="annex_list">
      <xsl:apply-templates select="//business_object_model" mode="annex_list"/>
    </xsl:variable>

    <xsl:variable name="annex_letter">
      <xsl:call-template name="annex_letter" >
        <xsl:with-param name="annex_name" select="$annex"/>
        <xsl:with-param name="annex_list" select="$annex_list"/>
      </xsl:call-template>
    </xsl:variable>
    
    <h2>
      <a name="{$title}">
        <xsl:value-of select="concat($annex_letter,'.',$sect_no,' ',$title)"/>
      </a>
    </h2>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="annex_clause" mode="number">
    <xsl:param name="sect_no" select="''"/>

    <xsl:variable name="current_sect_no">
      <xsl:number/>
    </xsl:variable>

    <xsl:variable name="sect_no_string">
      <xsl:choose>
        <xsl:when test="$sect_no=''">
          <xsl:value-of select="$current_sect_no"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($current_sect_no,'.',$sect_no)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="parent::*[name()='annex_clause']">
        <xsl:apply-templates select="parent::*[name()='annex_clause']" mode="number">
          <xsl:with-param name="sect_no" select="$sect_no_string"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$sect_no_string"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  
  <!--<xsl:template match="business_object_model" mode="title">
    <xsl:variable
      name="lpart">
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
      <xsl:call-template name="get_module_stdnumber">
        <xsl:with-param name="module" select="."/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="module_name">
      <xsl:call-template name="module_display_name">
        <xsl:with-param name="module" select="@name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="concat($stdnumber,' ',$module_name)"/>
    
    </xsl:template>-->
  
  <xsl:template name="check_business_object_model_exists">
    <xsl:param name="model"/> 
    <xsl:variable name="ret_val">
        <xsl:choose>
        <xsl:when test="document('../../repository_index.xml')/repository_index/business_object_models/business_object_model[@name=$model]">
          <xsl:value-of select="'true'"/>
        </xsl:when>
      <xsl:otherwise>
          <xsl:value-of select="concat(' The business object model ', $model, ' is not identified as a resource in repository_index.xml')"/>
        </xsl:otherwise>
        </xsl:choose> 
    </xsl:variable>
    <xsl:value-of select="$ret_val"/>
  </xsl:template>
  
  <!-- BOM -->
  <xsl:template match="bom_ref">
    <!-- remove all whitespace -->
    <xsl:variable
      name="nlinkend"
      select="translate(@linkend,'&#x9;&#xA;&#x20;&#xD;','')"/>

    <xsl:variable name="bom_sect">
      <xsl:choose>
        <xsl:when test="contains($nlinkend,':')">
          <xsl:value-of select="substring-before($nlinkend,':')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$nlinkend"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="model">
      <xsl:call-template name="business_object_model_name">
        <xsl:with-param name="business_object_model" select="$bom_sect"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable
      name="nlinkend1"
      select="substring-after($nlinkend,':')"/>

    <xsl:variable name="section_tmp">
      <xsl:choose>
        <xsl:when test="contains($nlinkend1,':')">
          <xsl:value-of select="substring-before($nlinkend1,':')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$nlinkend1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- now check that section is a valid reference -->
    <xsl:variable name="section">
      <xsl:choose>
        <xsl:when test="$section_tmp='introduction'
                        or $section_tmp='1_scope'
                        or $section_tmp='1_inscope'
                        or $section_tmp='1_outscope'
                        or $section_tmp='2_normrefs'
                        or $section_tmp='3_definition'
                        or $section_tmp='3_abbreviations'
                        or $section_tmp='4_general'
                        or $section_tmp='4_capabilities'
                        or $section_tmp='4_fundamentals'
                        or $section_tmp='4_interfaces'
                        or $section_tmp='4_constants'
                        or $section_tmp='4_types'
                        or $section_tmp='4_entities'
												or $section_tmp='4_subtype_constraints'
                        or $section_tmp='4_rules'
                        or $section_tmp='4_functions'
                        or $section_tmp='4_procedures'
                        or $section_tmp='5_mappings'">
                       
                        
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
      select="substring-after($nlinkend1,':')"/>

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
        <xsl:when test="$construct_tmp=''"/>

        <xsl:otherwise>
          <!--
               error - will be picked up after the  href variable is set.
               -->
          <xsl:value-of select="'error'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>


    <xsl:variable name="href">
      <xsl:choose>
        <xsl:when test="$model=''">
          <!--
               error do nothing as the error will be picked up after the
               href variable is set.
               -->
        </xsl:when>
        <xsl:when test="$section='error'">
          <!--
               error do nothing as the error will be picked up after the
               href variable is set.
               -->
        </xsl:when>
        <xsl:when test="$construct='error'">
          <!--
               error do nothing as the error will be picked up after the
               href variable is set.
               -->
        </xsl:when>
        <xsl:when test="$section=''">
          <xsl:value-of
            select="concat('../../../business_object_models/',$model,'/sys/introduction',
                    $FILE_EXT)"/>
        </xsl:when>
        <xsl:when test="$section='introduction'">
          <xsl:value-of
            select="concat('../../../business_object_models/',$model,'/sys/introduction', $FILE_EXT, $construct)"/>
        </xsl:when>

        <xsl:when test="$section='1_scope'">
          <xsl:choose>
            <xsl:when test="$construct">
              <xsl:value-of
                select="concat('../../../business_object_models/',$model, '/sys/1_scope',$FILE_EXT,$construct)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="concat('../../../business_object_models/',$model, '/sys/1_scope',$FILE_EXT,'#scope')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>

        <xsl:when test="$section='1_inscope'">
          <xsl:choose>
            <xsl:when test="$construct=''">
              <xsl:value-of
                select="concat('../../../business_object_models/',$model, '/sys/1_scope',$FILE_EXT,'#inscope')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="concat('../../../business_object_models/',$model, '/sys/1_scope',$FILE_EXT,$construct)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>

        <xsl:when test="$section='1_outscope'">
          <xsl:choose>
            <xsl:when test="$construct=''">
              <xsl:value-of
                select="concat('../../../business_object_models/',$model, '/sys/1_scope',$FILE_EXT,'#outscope')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="concat('../../../business_object_models/',$model, '/sys/1_scope',$FILE_EXT,$construct)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>

        <xsl:when test="$section='2_normrefs'">
          <xsl:choose>
            <xsl:when test="$construct=''">
              <xsl:value-of
                select="concat('../../../business_object_models/',$model, '/sys/2_refs',$FILE_EXT)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="concat('../../../business_object_models/',$model, '/sys/2_refs',$FILE_EXT,$construct)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>

        <xsl:when test="$section='3_definition'">
          <xsl:choose>
            <xsl:when test="$construct=''">
              <xsl:value-of
                select="concat('../../../business_object_models/',$model, '/sys/3_defs',$FILE_EXT)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="concat('../../../business_object_models/',$model, '/sys/3_defs',$FILE_EXT,$construct)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>

        <xsl:when test="$section='3_abbreviations'">
          <xsl:choose>
            <xsl:when test="$construct=''">
          <xsl:value-of
            select="concat('../../../business_object_models/',$model, '/sys/3_defs',$FILE_EXT)"/>
        </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="concat('../../../business_object_models/',$model, '/sys/3_defs',$FILE_EXT,$construct)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        
        <xsl:when test="$section='4_general'">
          <xsl:choose>
            <xsl:when test="$construct=''">
              <xsl:value-of
                select="concat('../../../business_object_models/',$model,
                '/sys/4_info_reqs',$FILE_EXT,'#general')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="concat('../../../business_object_models/',$model,
                '/sys/4_info_reqs',$FILE_EXT,$construct)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>

        <xsl:when test="$section='4_capabilities'">
          <xsl:choose>
            <xsl:when test="$construct=''">
              <xsl:value-of
                select="concat('../../../business_object_models/',$model,
                '/sys/4_info_reqs',$FILE_EXT,'#capabilities')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="concat('../../../business_object_models/',$model,
                        '/sys/4_info_reqs',$FILE_EXT,$construct)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        
        <xsl:when test="$section='4_fundamentals'">
          <xsl:choose>
            <xsl:when test="$construct=''">
              <xsl:value-of
                select="concat('../../../business_object_models/',$model,
                '/sys/4_info_reqs',$FILE_EXT,'#fundamentals')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="concat('../../../business_object_models/',$model,
                '/sys/4_info_reqs',$FILE_EXT,$construct)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>

        <xsl:when test="$section='4_interfaces'">
          <xsl:choose>
            <xsl:when test="$construct=''">
              <xsl:value-of
                select="concat('../../../business_object_models/',$model,
                        '/sys/4_info_reqs',$FILE_EXT,'#interfaces')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="concat('../../../business_object_models/',$model,
                        '/sys/4_info_reqs',$FILE_EXT,$construct)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>

        <xsl:when test="$section='4_constants'">
          <xsl:choose>
            <xsl:when test="$construct=''">
              <xsl:value-of
                select="concat('../../../business_object_models/',$model,
                        '/sys/4_info_reqs',$FILE_EXT,'#constants')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="concat('../../../business_object_models/',$model,
                        '/sys/4_info_reqs',$FILE_EXT,$construct)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>

        <xsl:when test="$section='4_types'">
          <xsl:choose>
            <xsl:when test="$construct=''">
              <xsl:value-of
                select="concat('../../../business_object_models/',$model,
                        '/sys/4_info_reqs',$FILE_EXT,'#types')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="concat('../../../business_object_models/',$model,
                        '/sys/4_info_reqs',$FILE_EXT,$construct)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>

        <xsl:when test="$section='4_entities'">
          <xsl:choose>
            <xsl:when test="$construct=''">
              <xsl:value-of
                select="concat('../../../business_object_models/',$model,
                        '/sys/4_info_reqs',$FILE_EXT,'#entities')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="concat('../../../business_object_models/',$model,
                        '/sys/4_info_reqs',$FILE_EXT,$construct)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
				
        <xsl:when test="$section='4_subtype_constraints'">
          <xsl:choose>
            <xsl:when test="$construct=''">
              <xsl:value-of
                select="concat('../../../business_object_models/',$model,
                        '/sys/4_info_reqs',$FILE_EXT,'#subtype_constraints')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="concat('../../../business_object_models/',$model,
                        '/sys/4_info_reqs',$FILE_EXT,$construct)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
 
        <xsl:when test="$section='4_rules'">
          <xsl:choose>
            <xsl:when test="$construct=''">
              <xsl:value-of
                select="concat('../../../business_object_models/',$model,
                        '/sys/4_info_reqs',$FILE_EXT,'#rules')"/>              
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="concat('../../../business_object_models/',$model,
                        '/sys/4_info_reqs',$FILE_EXT,$construct)"/>              
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>

        <xsl:when test="$section='4_functions'">
          <xsl:choose>
            <xsl:when test="$construct=''">
              <xsl:value-of
                select="concat('../../../business_object_models/',$model,
                        '/sys/4_info_reqs',$FILE_EXT,'#functions')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="concat('../../../business_object_models/',$model,
                        '/sys/4_info_reqs',$FILE_EXT,$construct)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>

        <xsl:when test="$section='4_procedures'">
          <xsl:choose>
            <xsl:when test="$construct=''">
              <xsl:value-of
                select="concat('../../../business_object_models/',$model,
                        '/sys/4_info_reqs',$FILE_EXT,'#procedures')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="concat('../../../business_object_models/',$model,
                        '/sys/4_info_reqs',$FILE_EXT,$construct)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>

        <xsl:when test="$section='5_mappings'">
          <xsl:choose>
            <xsl:when test="$construct=''">
              <xsl:value-of
                select="concat('../../../business_object_models/',$model,
                        '/sys/5_main',$FILE_EXT,'#mappings')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="concat('../../../business_object_models/',$model,
                        '/sys/5_main',$FILE_EXT,$construct)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>

        

        
        <xsl:otherwise>
          <!--
               error - will be picked up after the  href variable is set.
               -->
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- debug
    [sect:<xsl:value-of select="$section"/>]
    [module:<xsl:value-of select="$module"/>]
    [href:<xsl:value-of select="$href"/>]
    [construct:<xsl:value-of select="$construct"/>]
         -->
    <xsl:choose>
      <xsl:when test="$href=''">
        <xsl:call-template name="error_message">
          <xsl:with-param
            name="message"
            select="concat('ERROR c3: module_ref linkend #',
                    $nlinkend,
                    '# is incorrectly specified.')"/>
        </xsl:call-template>
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="string-length(.)>0">
            <a href="{$href}"><xsl:apply-templates/></a>
          </xsl:when>
          <xsl:otherwise>
            <!--<xsl:variable name="model_name">
              <xsl:call-template name="module_display_name">
                <xsl:with-param name="module" select="$module"/>
              </xsl:call-template>
            </xsl:variable>-->
            <a href="{$href}"><xsl:value-of select="$model"/></a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>

