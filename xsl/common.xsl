<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: common.xsl,v 1.194 2016/08/22 13:48:19 mikeward Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose: Templates that are common to most other stylesheets
-->

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:exslt="http://exslt.org/common"
  exclude-result-prefixes="msxsl exslt"
  version="1.0">



  <!--
       Template to determine whether the output is XML or HTML
       Sets variable global FILE_EXT
  -->

  <xsl:import href="file_ext.xsl"/>

  <!-- parameters that control the output -->
  <xsl:import href="parameters.xsl"/>

  <xsl:output method="html"/>

<!--
     Output a cascading stylesheet. The stylesheet is specified in the
     global parameter: output_css in parameter.xsl, so to prevent a
     cascading stylesheet being used set output_css to ''
     To override this and force a cascading stylesheet set
     overide_css
     -->

<xsl:template name="output_css">
  <xsl:param name="path"/>
  <xsl:param name="override_css"/>
  <xsl:choose>
    <xsl:when test="$override_css">
      <xsl:variable name="hpath"
      select="concat($path,$override_css)"/>
      <link
        rel="stylesheet"
        type="text/css"
        href="{$hpath}"/>
    </xsl:when>
    <xsl:when test="$output_css">
      <xsl:variable name="hpath"
        select="concat($path,$output_css)"/>
      <linkg
        rel="stylesheet"
        type="text/css"
        href="{$hpath}"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<!--
     Output an HTML meta element for inclusion in the header of the HTML file
-->

<xsl:template name="meta-elements">
  <xsl:param name="name" />
  <xsl:param name="content" />
  <xsl:element name="META">
    <xsl:attribute name="name">
      <xsl:value-of select="$name"/>
    </xsl:attribute>
    <xsl:attribute name="content">
      <xsl:value-of select="$content"/>
    </xsl:attribute>
  </xsl:element>
</xsl:template>



<!--

     Output the module title - used to create the HTML TITLE

     If the global parameter: output_rcs in parameter.xsl

     is set, then RCS version control information is displayed

-->

<xsl:template match="module" mode="title">

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



  <!-- no longer permitted

  <xsl:choose>

    <xsl:when test="$output_rcs">

      <xsl:variable

        name="date"

        select="translate(@rcs.date,'$','')"/>

      <xsl:variable

        name="rev"

        select="translate(@rcs.revision,'$','')"/>

      <xsl:value-of

        select="concat(@status,' ',$lpart,' :- ',@name,'  (',$date,' ',$rev,')')"/>

    </xsl:when>

    <xsl:otherwise>

      <xsl:value-of

        select="concat($lpart,' :- ',@name)"/>

    </xsl:otherwise>

  </xsl:choose> -->



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



</xsl:template>





<xsl:template match="module" mode="meta_data">

  <xsl:param name="clause"/>

  <link rel = "schema.DC"

    href    = "http://www.dublincore.org/documents/2003/02/04/dces/"/>



  <xsl:variable name="module_name">

    <xsl:call-template name="module_display_name">

      <xsl:with-param name="module" select="./@name"/>

    </xsl:call-template>           

  </xsl:variable>

    

  <xsl:variable name="stdnumber">

    <xsl:call-template name="get_module_pageheader">

      <xsl:with-param name="module" select="."/>

    </xsl:call-template>

  </xsl:variable>

  <xsl:variable name="module_title">

    <xsl:value-of select="concat('Product data representation and exchange: Application module: ', $module_name)"/>

  </xsl:variable>

  <xsl:call-template name="meta-elements">

    <xsl:with-param name="name" select="'DC.Title'"/>

    <xsl:with-param name="content" select="$module_title"/>

  </xsl:call-template>



  <xsl:variable name="dc.dates"

    select="normalize-space(substring-after((translate(@rcs.date,'$/',' -')),'Date:'))"/>

  <xsl:call-template name="meta-elements">

    <xsl:with-param name="name" select="'DC.Dates'"/>

    <xsl:with-param name="content" select="$dc.dates"/>

  </xsl:call-template>



  <xsl:variable name="published"

    select="@publication.date"/>

  <xsl:call-template name="meta-elements">

    <xsl:with-param name="name" select="'DC.Published'"/>

    <xsl:with-param name="content" select="$published"/>

  </xsl:call-template>





  <xsl:variable name="editor_ref" select="./contacts/editor/@ref"/>

  <xsl:variable name="editor_contact"

    select="document('../data/basic/contacts.xml')/contact.list/contact[@id=$editor_ref]"/>

  <xsl:variable name="dc.contributor">

    <xsl:value-of select="normalize-space(concat($editor_contact/lastname,', ',$editor_contact/firstname))"/>

  </xsl:variable>

  <xsl:call-template name="meta-elements">

    <xsl:with-param name="name" select="'DC.Contributor'"/>

    <xsl:with-param name="content" select="$dc.contributor"/>

  </xsl:call-template>



  <xsl:variable name="projlead_ref" select="./contacts/projlead/@ref"/>

  <xsl:variable name="projlead_contact"

    select="document('../data/basic/contacts.xml')/contact.list/contact[@id=$projlead_ref]"/>

  <xsl:variable name="dc.creator">

    <xsl:value-of select="normalize-space(concat($projlead_contact/lastname,', ',$projlead_contact/firstname))"/>

  </xsl:variable>

  <xsl:call-template name="meta-elements">

    <xsl:with-param name="name" select="'DC.Creator'"/>

    <xsl:with-param name="content" select="$dc.creator"/>

  </xsl:call-template>



  <xsl:call-template name="meta-elements">

    <xsl:with-param name="name" select="'DC.Description'"/>

    <xsl:with-param name="content" select="concat('The application module ',$module_name)"/>

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

    select="concat('ISO/TC 184/SC 4/WG ',$wg_group,' N',./@wg.number)"/>

  <xsl:variable name="clause_of">

    <xsl:if test="$clause">

      <xsl:value-of select="concat('Clause of ',$clause)"/>

    </xsl:if>

  </xsl:variable>

  <xsl:call-template name="meta-elements">

    <xsl:with-param name="name" select="'DC.Identifier'"/>

    <xsl:with-param name="content" select="$id"/>

  </xsl:call-template>



  <xsl:variable name="supersedes"

    select="concat('ISO/TC 184/SC 4/WG ',$wg_group,' N',./@wg.number.supersedes)"/>

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

    <xsl:with-param name="name" select="'STEPMOD.module.rcs.date'"/>

    <xsl:with-param name="content" select="normalize-space(translate(./@rcs.date,'$/',' -'))"/>

  </xsl:call-template>



  <xsl:call-template name="meta-elements">

    <xsl:with-param name="name" select="'STEPMOD.module.rcs.revision'"/>

    <xsl:with-param name="content" select="normalize-space(translate(./@rcs.revision,'$',''))"/>

  </xsl:call-template>

  

  <xsl:variable name="revstring" select="'Revision:'"/>

  <xsl:call-template name="meta-elements">

    <xsl:with-param name="name" select="'PART1000.module.rcs.revision'"/>

    <xsl:with-param name="content" select="concat('$',string($revstring),' $')"/>

  </xsl:call-template>

  <xsl:variable name="datestring" select="'Date:'"/>

  <xsl:call-template name="meta-elements">

    <xsl:with-param name="name" select="'PART1000.module.rcs.date'"/>

    <xsl:with-param name="content" select="concat('$',string($datestring),' $')"/>

  </xsl:call-template>



  <!-- now get meta data for arm and mim -->

  <xsl:variable name="module_dir">

    <xsl:call-template name="module_directory">

      <xsl:with-param name="module" select="./@name"/>

    </xsl:call-template>

  </xsl:variable>

  <xsl:variable name="arm_xml" select="concat($module_dir,'/arm.xml')"/>

  <xsl:variable name="arm_express" select="document($arm_xml)/express"/>

  <xsl:call-template name="meta-elements">

    <xsl:with-param name="name" select="'STEPMOD.arm.rcs.revision'"/>

    <xsl:with-param name="content" select="normalize-space(translate($arm_express/@rcs.revision,'$',''))"/>

  </xsl:call-template>



  <xsl:variable name="mim_xml" select="concat($module_dir,'/mim.xml')"/>

  <xsl:variable name="mim_express" select="document($mim_xml)/express"/>

  <xsl:call-template name="meta-elements">

    <xsl:with-param name="name" select="'STEPMOD.mim.rcs.revision'"/>

    <xsl:with-param name="content" select="normalize-space(translate($mim_express/@rcs.revision,'$',''))"/>

  </xsl:call-template>

  </xsl:template>





  <!-- output RCS version control information -->

<xsl:template name="rcs_output">

  <xsl:param name="module" select="@name"/>

  <!-- the relative path in HTML from the file calling to the module

       directory -->

  <xsl:param name="module_root" select="'..'"/>



  <xsl:variable name="icon_path" select="concat($module_root,'/../../../images/')"/>



  <xsl:if test="$output_rcs='YES'">

    <xsl:variable name="mod_dir">

      <xsl:call-template name="module_directory">

        <xsl:with-param name="module" select="$module"/>

      </xsl:call-template>

    </xsl:variable>



    <xsl:variable name="fldr_gif" select="concat($icon_path,'folder.gif')"/>

    <xsl:variable name="proj_gif" select="concat($icon_path,'project.gif')"/>



    <table cellspacing="0" border="0">

      <xsl:variable

        name="module_file"

        select="concat($mod_dir,'/module.xml')"/>

      <xsl:variable

        name="module_date"

        select="translate(document($module_file)/module/@rcs.date,'$','')"/>

      <xsl:variable

        name="module_rev"

        select="translate(document($module_file)/module/@rcs.revision,'$','')"/>

      <tr>

        <td>

          <p class="rcs">

          <a href="{$module_root}">

            <img alt="module folder" 

              border="0"

              align="middle"

              src="{$fldr_gif}"/>

          </a>&#160;



          <xsl:if test="@development.folder">

            <xsl:variable name="prjmg_href"

              select="concat($module_root,'/',@development.folder,'/projmg',$FILE_EXT)"/>

            <a href="{$prjmg_href}">

              <img alt="project management summary" 

                border="0"

                align="middle"

                src="{$proj_gif}"/>

            </a>&#160;

            <xsl:variable name="issue_href"

              select="concat($module_root,'/',@development.folder,'/issues',$FILE_EXT)"/>

            <xsl:variable name="issues_file" 

              select="concat($mod_dir,'/',@development.folder,'/issues.xml')"/>

 

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

               <img alt="issues" 

                 border="0"

                 align="middle"

                 src="{$issue_gif}"/>

               <small>[<xsl:value-of select="$open_issues"/>/<xsl:value-of select="$total_issues"/>]</small>

             </a>&#160;

           </xsl:if>

          </xsl:if>

        </p>

        </td>

        <td>

          <font size="-2">

            <p class="rcs">Module edition:</p>

          </font>

        </td>

        <td>

          <font size="-2">

            <p class="rcs">

              <xsl:value-of select="@version"/>

            </p>

          </font>

        </td>

        <td>&#160;&#160;</td>

        <td>

          <font size="-2">

            <p class="rcs">

              <xsl:value-of select="'module.xml'"/>

            </p>

          </font>

        </td>

        <td>

          <font size="-2">

            <p class="rcs">

              <xsl:value-of select="concat('(',$module_date,' ',$module_rev,')')"/>

            </p>

          </font>

        </td>

        <td>&#160;&#160;</td>

      <xsl:variable

        name="arm_file"

        select="concat($mod_dir,'/arm.xml')"/>

      <xsl:variable

        name="arm_date"

        select="translate(document($arm_file)/express/@rcs.date,'$','')"/>

      <xsl:variable

        name="arm_rev"

        select="translate(document($arm_file)/express/@rcs.revision,'$','')"/>



        <td>

          <font size="-2">

            <p class="rcs">

              <xsl:value-of select="'arm.xml'"/>

            </p>

          </font>

        </td>

        <td>

          <font size="-2">

            <p class="rcs">

              <xsl:value-of select="concat('(', $arm_date,' ',$arm_rev,')')"/>

            </p>

          </font>

        </td>

        <td>&#160;&#160;</td>



      <xsl:variable

        name="mim_file"

        select="concat($mod_dir,'/mim.xml')"/>

      <xsl:variable

        name="mim_date"

        select="translate(document($mim_file)/express/@rcs.date,'$','')"/>

      <xsl:variable

        name="mim_rev"

        select="translate(document($mim_file)/express/@rcs.revision,'$','')"/>



        <td>

          <font size="-2">

            <p class="rcs">

              <xsl:value-of select="'mim.xml'"/>

            </p>

          </font>

        </td>

        <td>

          <font size="-2">

            <p class="rcs">

              <xsl:value-of select="concat('(',$mim_date,'

',$mim_rev,')')"/>

            </p>

          </font>

        </td>

      </tr>

    </table>

  </xsl:if>

</xsl:template>



<!--

     Output the title for a table of contents banner for a module

     displayed on separate pages

     If the global parameter: output_rcs in parameter.xsl

     is set, then RCS version control information is displayed

-->

<xsl:template match="module" mode="TOCbannertitle">

  <!-- the entry that has been selected -->

  <xsl:param name="selected"/>

  <xsl:param name="module_root" select="'..'"/>



  <!-- output RCS version control information -->

  <xsl:call-template name="rcs_output">

    <xsl:with-param name="module" select="@name"/>

    <xsl:with-param name="module_root" select="$module_root"/>

  </xsl:call-template>



  <TABLE cellspacing="0" border="0" width="100%">

    <TR>

      <TD>

        <!-- RBN - this xref is here to aid navigation, it may need to be

             removed for the ISO process 

        <A HREF="{$module_root}/../../../repository_index{$FILE_EXT}">

          Module repository

        </A><BR/>

        -->

        <xsl:call-template name="output_menubar">

          <xsl:with-param name="module_root" select="$module_root"/>

          <xsl:with-param name="module_name" select="@name"/>



        </xsl:call-template>

      </TD>

    </TR>

    <TR>

      <TD valign="MIDDLE">

        <B>

          Application module:

          <xsl:call-template name="module_display_name">

            <xsl:with-param name="module" select="@name"/>

          </xsl:call-template>

        </B>

      </TD>

      <TD valign="MIDDLE" align="RIGHT">

        <xsl:variable name="stdnumber">

          <xsl:call-template name="get_module_pageheader">

            <xsl:with-param name="module" select="."/>

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

      </TD>

    </TR>

  </TABLE>

</xsl:template>







<!-- output the clause heading -->

<xsl:template name="clause_header">

  <xsl:param name="heading"/>

  <xsl:param name="aname"/>

  <H2>

    <A NAME="{$aname}">

      <xsl:value-of select="$heading"/>

    </A>

  </H2>

</xsl:template>



<!-- output the Annex heading -->

<xsl:template name="annex_header">

  <xsl:param name="heading"/>

  <xsl:param name="annex_no"/>

  <xsl:param name="title"/>

  <xsl:param name="aname"/>

  <xsl:param name="informative" select="'informative'"/>

  <div align="center">

    <h2>

      <A NAME="{$aname}">

        <xsl:value-of select="concat('Annex ', $annex_no)"/>

      </A><br/>

    (<xsl:value-of select="$informative"/>)<br/><br/>

      <xsl:value-of select="$heading"/>

    </h2>

  </div>

</xsl:template>





<xsl:template match="description">

  <xsl:apply-templates/>

</xsl:template>





<xsl:template match="example">

  <xsl:variable name="text_str" select="normalize-space(text())"/>

  <xsl:choose>

    <!-- expect the example to be plain text, or if starts with <p> not to

         contain any block elements.start with <p>. If not flag an error -->

    <xsl:when test="string-length($text_str) != 0 and ./child::*[name()='p'

or name()='screen' or name()='ul' or name()='example' or name()='note' or name()='figure']">

      <xsl:call-template name="error_message">

        <xsl:with-param 

          name="message" 

          select="concat('Error EX1: Examples containing block elements such as ', name(./child::*[name()='p' or name()='screen' or name()='ul' or name()='note' or name()='example']), ' should start with p not text#Currently starts with:#',$text_str)"/>

      </xsl:call-template>

      EXAMPLE

    </xsl:when>

    <xsl:when test="string-length($text_str) != 0">

      <xsl:variable name="aname">

        <xsl:choose>

          <xsl:when test="@id">

            <xsl:value-of select="concat('example_',@id)"/>

          </xsl:when>

          <xsl:otherwise>

            <xsl:value-of select="concat('example_',@number)"/>

          </xsl:otherwise>

        </xsl:choose>

      </xsl:variable>

      <p class="example">

        <small>

          <a name="{$aname}">

            <xsl:value-of select="concat('EXAMPLE&#160;',@number)"/></a>&#160;&#160;

            <xsl:apply-templates/>

          </small>

        </p>  

    </xsl:when>

    <!-- check that the first element is p or ul-->

    <xsl:when test="name(child::*[1]) != 'p'">

      <xsl:call-template name="error_message">

        <xsl:with-param 

          name="message" 

          select="concat('Error EX2: Examples should start with p or ul element not ', name(./child::*[1]))"/>

      </xsl:call-template>

      EXAMPLE

    </xsl:when>

    <xsl:otherwise>

      <xsl:apply-templates select="./p[1]" mode="first_paragraph_example">

        <xsl:with-param name="id" select="@id"/>

        <xsl:with-param name="number" select="@number"/>

      </xsl:apply-templates>

      <xsl:apply-templates select="./child::*[position() &gt; 1]"/>

    </xsl:otherwise>

  </xsl:choose>

</xsl:template>



<!-- called from <example> to deal with first paragraph -->

<xsl:template match="p" mode="first_paragraph_example">

  <xsl:param name="id"/>

  <xsl:param name="number"/>

  <xsl:variable name="aname">

    <xsl:choose>

      <xsl:when test="$id">

        <xsl:value-of select="concat('example_',$id)"/>

      </xsl:when>

      <xsl:otherwise>

        <xsl:value-of select="concat('example_',$number)"/>

      </xsl:otherwise>

    </xsl:choose>

  </xsl:variable>

  <xsl:apply-templates select="." mode="check_html"/>

  <p class="example">

    <small>

      <a name="{$aname}">

        <xsl:value-of select="concat('EXAMPLE&#160;',$number)"/></a>&#160;&#160;

      <xsl:apply-templates/>

    </small>

  </p>  

</xsl:template>





<xsl:template match="note">

  <xsl:variable name="text_str" select="normalize-space(text())"/>

  <xsl:choose>

    <!-- expect the note to start with <p> If not flag an error -->

    <xsl:when test="string-length($text_str) != 0 and ./child::*[name()='p' or name()='screen' or name()='ul' or name()='note' or name='example']">

      <xsl:call-template name="error_message">

        <xsl:with-param 

          name="message" 

          select="concat('Error NOTE1: Notes containing block elements

                  such as &lt;',

                  name(./child::*[name()='p' or name()='screen' or name()='ul' or name()='note' or name()='example']),

                  '&gt; should start with &lt;p&gt; not text#Currently starts with:#',$text_str)"/>

      </xsl:call-template>

      NOTE

    </xsl:when>

    <xsl:when test="string-length($text_str) != 0">

      <xsl:variable name="aname">

        <xsl:choose>

          <xsl:when test="@id">

            <xsl:value-of select="concat('note_',@id)"/>

          </xsl:when>

          <xsl:otherwise>

            <xsl:value-of select="concat('note_',@number)"/>

          </xsl:otherwise>

        </xsl:choose>

      </xsl:variable>

      <p class="note">

        <small>

          <a name="{$aname}">

            <xsl:value-of select="concat('NOTE&#160;',@number)"/></a>&#160;&#160;

            <xsl:apply-templates/>

          </small>

        </p>  

    </xsl:when>

    <!-- check that the first element is p -->

    <xsl:when test="string(name(child::*[1])) != 'p'">

      <xsl:call-template name="error_message">

        <xsl:with-param 

          name="message" 

          select="concat('Error NOTE2: Notes start with p element not ', name(./child::*[1]))"/>

      </xsl:call-template>

      EXAMPLE

    </xsl:when>



    <xsl:otherwise>

      <xsl:apply-templates select="./p[1]" mode="first_paragraph_note">

        <xsl:with-param name="id" select="@id"/>

        <xsl:with-param name="number" select="@number"/>

      </xsl:apply-templates>

      <xsl:apply-templates select="./child::*[position() &gt; 1]"/>

    </xsl:otherwise>

  </xsl:choose>

</xsl:template>



<!-- called from <note> to deal with first paragraph -->

<xsl:template match="p" mode="first_paragraph_note">

  <xsl:param name="id"/>

  <xsl:param name="number"/>

  <xsl:variable name="aname">

    <xsl:choose>

      <xsl:when test="$id">

        <xsl:value-of select="concat('note_',$id)"/>

      </xsl:when>

      <xsl:otherwise>

        <xsl:value-of select="concat('note_',$number)"/>

      </xsl:otherwise>

    </xsl:choose>

  </xsl:variable>

  <xsl:apply-templates select="." mode="check_html"/>

  <xsl:choose>

    <xsl:when test="name(../..)='example'">

      <!-- already small -->

      <p class="note">

        <a name="{$aname}">

          <xsl:value-of select="concat('NOTE&#160;',$number)"/></a>&#160;&#160;

          <xsl:apply-templates/>

      </p>

    </xsl:when>

    <xsl:otherwise>

      <p class="note">

        <small>

          <a name="{$aname}">

            <xsl:value-of select="concat('NOTE&#160;',$number)"/></a>&#160;&#160;

            <xsl:apply-templates/>

          </small>

        </p>  

    </xsl:otherwise>

  </xsl:choose>

</xsl:template>



<xsl:template match="figure">

  <xsl:variable name="number">

    <xsl:choose>

      <xsl:when test="@number">

        <xsl:value-of select="@number"/>

      </xsl:when>

      <xsl:otherwise>

        <xsl:number/>

      </xsl:otherwise>

    </xsl:choose>

  </xsl:variable>



    <xsl:variable name="aname">

      <xsl:call-template name="table_aname">

        <xsl:with-param name="table" select="."/>

        <xsl:with-param name="number" select="@number"/>

        <xsl:with-param name="id" select="@id"/>

      </xsl:call-template>

    </xsl:variable>



    <xsl:variable name="title">

      <xsl:value-of select="concat('Figure ',$number,

                            '&#160;&#8212;&#160;&#160;',./title)"/>

    </xsl:variable>

    <br/><br/>

    <a name="{$aname}"/>

      <xsl:apply-templates select="./img">

        <xsl:with-param name="alt" select="$title"/>

      </xsl:apply-templates>

    <br/>

    <div align="center">

      <b>

        <xsl:value-of select="$title"/>

      </b>

    </div>

    <br/>

  </xsl:template>



<xsl:template match="title">

  <xsl:apply-templates/>

</xsl:template>



<xsl:template match="img">

  <xsl:param name="alt"/>

  <!-- if the img has been defined in a separate file within the element

       imgfile.content, then the src path is OK.

       If the img has been defined in the module documentation, then the

       XSL has been invoked from a file in the sys directory, hence the

       path needs to go up to the module directory -->

  

  <xsl:variable name="src">

    <xsl:choose>

      <xsl:when test="name(..)='imgfile.content'">

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

  

  <xsl:choose>

    <xsl:when test="starts-with(@src,'../')">

      <xsl:call-template name="error_message">

        <xsl:with-param 

          name="message" 

          select="concat('Error IMG: All images must be stored in the same folder as the module.#

                  Copy the image to the module folder and remove the ../ from#

                  &lt;img src=&quot;',@src,'&quot;/&gt;')"/>

      </xsl:call-template>

    </xsl:when>

    <xsl:otherwise>

      <div align="center">

        <xsl:choose>

          <xsl:when test="./@usemap">

            <xsl:variable name="map1" select="./@usemap"/>

            <xsl:variable name="name1" select="./map/@name"/>

            <img src="{$src}" border="0" usemap="{$map1}" alt="{$alt1}">

              <map name="{$name1}">

                <xsl:for-each select="./map/area">

                  <xsl:variable name="shape1" select="./@shape"/>

                  <xsl:variable name="coords1" select="./@coords"/>

                  <xsl:variable name="alt2" select="./@alt"/>

                  <xsl:variable name="href2" select="./@href"/>

                  <area shape="{$shape1}" coords="{$coords1}" alt="{$alt2}" href="{$href2}"/>

                </xsl:for-each>

              </map>

            </img> 

          </xsl:when>

          <xsl:when test="img.area">

            <IMG src="{$src}" border="0" usemap="#map" alt="{$alt1}">

              <MAP ID="map" name="map">

                <xsl:apply-templates select="img.area"/>

              </MAP>

            </IMG>        

          </xsl:when>

          <xsl:otherwise>

            <IMG src="{$src}" border="0" alt="{$alt1}"/>

          </xsl:otherwise>

        </xsl:choose>

      </div>

    </xsl:otherwise>

  </xsl:choose>

</xsl:template>



<xsl:template match="img.area">

  <xsl:variable name="shape">

    <xsl:choose>

      <xsl:when test="string(@shape)='polygon' or

                      string(@shape)='POLYGON'">

        <xsl:value-of select="'poly'"/>

      </xsl:when>

      <xsl:otherwise>

        <xsl:value-of select="@shape"/>

      </xsl:otherwise>

    </xsl:choose>

  </xsl:variable>

  <xsl:variable name="coords" select="@coords"/>

  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>

  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>



  <xsl:variable name="href">

    <xsl:choose>

      <xsl:when test="contains(@href,'xml')">

        <xsl:value-of select="translate(concat(substring-before(@href,'.xml'),

                              $FILE_EXT,

                              substring-after(@href,'.xml')),$UPPER,$LOWER)"/>

      </xsl:when>

      <xsl:otherwise>

        <xsl:value-of select="@href"/>

      </xsl:otherwise>

    </xsl:choose>

  </xsl:variable>



  <!--<xsl:if test="(substring-before($href,'/') = '.' or substring-before($href,'/') = '') and not(contains(substring-after($href,'/'),'/')) and not(contains(../../@file,'expg1.xml'))" >
    <xsl:call-template name="error_message">
      <xsl:with-param name="inline" select="'no'"/>
      <xsl:with-param name="message">
        <xsl:value-of select="concat('Warning IM3: diagram contains offpage reference to ',substring-after($href,'/'),'. Check this and counterpart on referenced diagram.')"/>
      </xsl:with-param>
      <xsl:with-param name="warning_gif" select="'../../../images/warning.gif'"/>
    </xsl:call-template>
  </xsl:if> this test removed MWD as per bug 5544 -->

  <AREA shape="{$shape}" coords="{$coords}" href="{$href}" alt="{$href}"/>

</xsl:template>



<!--

     An unordered list

     -->

<xsl:template match="ul|UL">

  <ul>

    <xsl:apply-templates/>

  </ul>

</xsl:template>



<!--

     An ordered list

     -->

<xsl:template match="ol" >

  <xsl:variable

    name="type"

    select="@type"/>

  <xsl:choose>

    <xsl:when test="$type">

      <ol type="{$type}">

        <xsl:apply-templates/>

      </ol>

    </xsl:when>

    <xsl:otherwise>

      <ol>

        <xsl:apply-templates/>

      </ol>

    </xsl:otherwise>

  </xsl:choose>

</xsl:template>

<xsl:template match="OL" >

  <xsl:variable

    name="type"

    select="@type"/>

  <xsl:choose>

    <xsl:when test="$type">

      <ol type="{$type}">

        <xsl:apply-templates/>

      </ol>

    </xsl:when>

    <xsl:otherwise>

      <ol>

        <xsl:apply-templates/>

      </ol>

    </xsl:otherwise>

  </xsl:choose>

</xsl:template>



<!--

     A list item - called from scope statements where there are clear rules

     for the punctuation of a list

     -->

<xsl:template match="li|LI">

  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>

  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>



  <!-- make sure that the LI is in a UL OL or INSCOPE -->

  <xsl:variable name="parent" select="translate(name(..),$UPPER,$LOWER)"/>



  <xsl:choose>

    <xsl:when test="not($parent='ul' or $parent='ol' or $parent='ul' or $parent='inscope' or $parent='outscope' or $parent='abstract')">

      <xsl:call-template name="error_message">

        <xsl:with-param 

          name="message" 

          select="concat('Error LI1: The parent element of &lt;li&gt;, must be a &lt;ul&gt;,&lt;ol&gt;, &lt;inscope&gt;, &lt;outscope&gt; not ',$parent)"/>

            </xsl:call-template>

    </xsl:when>

  </xsl:choose>



  <xsl:choose>

    <xsl:when test="$ERROR_CHECK_LIST_ITEMS = 'NO'">

      <li>

        <xsl:choose>

          <xsl:when test="./ancestor::*[name()='example' or name()='note']">

            <small>

              <xsl:apply-templates/>

            </small>

          </xsl:when>

          <xsl:otherwise>

            <xsl:apply-templates/>

          </xsl:otherwise>

        </xsl:choose>

      </li>

    </xsl:when>

    <xsl:otherwise>

      <!-- get the text or the text of the last paragraph. Ignore examples and

           notes -->

      <xsl:variable name="item1">

        <xsl:apply-templates select="." mode="flatten"/>

      </xsl:variable>

      <xsl:variable name="item" select="normalize-space($item1)"/>

      <xsl:variable name="position">

        <!-- use number rather than position as SAXON gives wrong results -->

        <xsl:number/>

      </xsl:variable>

      <!-- use count rather than last as SAXON gives wrong results -->

      <xsl:variable name="last" select="count(../li)"/>

      <xsl:variable name="terminator">

        <xsl:choose>

          <xsl:when test="$position=$last">

            <xsl:value-of select="'.'"/>

          </xsl:when>

          <xsl:otherwise>

            <xsl:value-of select="';'"/>

          </xsl:otherwise>

        </xsl:choose>

      </xsl:variable>  

      <li>

        <xsl:choose>

          <xsl:when test="contains($item,'**')">

            <!-- the list item contains a sub list, so allow other terminators -->

          </xsl:when>

          <xsl:when test="substring($item,string-length($item))!=$terminator">

            <xsl:call-template name="error_message">

              <xsl:with-param 

                name="message" 

                select="concat('Error b1: Item in list should end with',$terminator)"/>

            </xsl:call-template>

          </xsl:when>

        </xsl:choose>

        <xsl:choose>

          <xsl:when test="./ancestor::*[name()='example' or name()='note']">

            <small>

              <xsl:apply-templates/>

            </small>

          </xsl:when>

          <xsl:otherwise>

            <xsl:apply-templates/>

          </xsl:otherwise>

        </xsl:choose>

      </li>

    </xsl:otherwise>

  </xsl:choose>

</xsl:template>









<xsl:template match="example|note|b|i|sup|sub" mode="flatten"/>

<xsl:template match="ul" mode="flatten">

 **

</xsl:template>



<xsl:template match="p" mode="flatten">

  <xsl:value-of select="."/>

</xsl:template>





<!--

     A definition list

     -->

<xsl:template match="dl">

  <dl>

    <xsl:apply-templates/>

  </dl>

</xsl:template>



<!--

     A definition term

     -->

<xsl:template match="dt">

  <dt>

    <xsl:apply-templates/>

  </dt>

</xsl:template>



<!--

     A definition desription

     -->

<xsl:template match="dd">

  <dd>

    <xsl:apply-templates/>

  </dd>

</xsl:template>



<!--

     A paragraph

     -->

<xsl:template match="p|P">

  <xsl:apply-templates select="." mode="check_html"/>

  <xsl:choose>

    <xsl:when test="./ancestor::*[name()='example' or name()='note']">

      <p>

        <small>

          <xsl:apply-templates/>

        </small>

      </p>      

    </xsl:when>

    <xsl:otherwise>

      <p>

        <xsl:apply-templates/>

      </p>

    </xsl:otherwise>

  </xsl:choose>

</xsl:template>



<!-- 

     flag an error if a paragraph contains another <p> or <ul> or <screen>

     as these will lead to invalid HTML -->

<xsl:template match="p|P" mode="check_html">

  <xsl:if test="./child::*[name()='p' or name()='ul' or name='screen']">

    <xsl:call-template name="error_message">

      <xsl:with-param 

        name="message" 

        select="'Error HTM1: A paragraph should not enclose a &lt;p&gt; or &lt;ul&gt; or &lt;screen&gt;. Close the &lt;p&gt; first'"/>

    </xsl:call-template>

  </xsl:if>

</xsl:template>







<xsl:template match="a">

  <!-- <a href="{@href}" target="_blank"> MWD 2016-08-22 -->
  <a href="{@href}" target="_self">
  <xsl:variable name="link_name">
    <xsl:apply-templates/>
  </xsl:variable>
<xsl:value-of select="$link_name"/>

    <xsl:choose>
      <xsl:when test="string-length($link_name) > 0">
        <!-- link alread has a name so don't add another -->
      </xsl:when>
        

      <xsl:when test="string-length(text()) > 0" >

      (<xsl:value-of select="@href"/>)

    </xsl:when>

    <xsl:otherwise>

            <xsl:value-of select="@href"/>

    </xsl:otherwise>

    </xsl:choose>

  </a>

</xsl:template>



<xsl:template match="b|B">

  <b>

    <xsl:apply-templates/>

  </b>

</xsl:template>



<xsl:template match="tt">

  <tt>

    <xsl:apply-templates/>

  </tt>

</xsl:template>





<xsl:template match="i|I">

  <i>

    <xsl:apply-templates/>

  </i>

</xsl:template>



<!-- added template to display eqn  and bigeqn RJG March 2012 -->

<xsl:template match="eqn" >

  <font size="+1">

   <p align="center"> 

    <xsl:apply-templates/>

    </p>

  </font>

</xsl:template>



<xsl:template match="bigeqn" >

  <font size="+2">

   <p align="center"> 

    <xsl:apply-templates/>

    </p>

  </font>

</xsl:template>



<!-- subscript -->

<xsl:template match="sub|SUB" >

  <sub>

    <xsl:apply-templates/>

  </sub>

</xsl:template>





<!-- superscript -->

<xsl:template match="sup|SUP" >

  <sup>

    <xsl:apply-templates/>

  </sup>

</xsl:template>



<xsl:template match="screen">

  <xsl:choose>

    <xsl:when test="./ancestor::*[name()='example' or name()='note']">

      <pre>

        <!-- should makethis a small font, but if you include <small> here

             it creates invalid HTML -->

          <xsl:apply-templates/>



      </pre>

    </xsl:when>

    <xsl:otherwise>

      <pre>

        <xsl:apply-templates/>

      </pre>      

    </xsl:otherwise>

  </xsl:choose>

</xsl:template>





<xsl:template match="table">

  <xsl:variable name="aname">

    <xsl:call-template name="table_aname">

      <xsl:with-param name="table" select="."/>

      <xsl:with-param name="number" select="@number"/>

      <xsl:with-param name="id" select="@id"/>

    </xsl:call-template>

  </xsl:variable>



  <p align="center">

    <b>

      Table 

      <a name="{$aname}">

        <xsl:value-of select="@number"/> &#8212; <xsl:value-of

        select="@caption"/>

      </a>

    </b>

  </p>

  <div align="center">

    <table border="1" cellpadding="2" cellspacing="0">

      <xsl:apply-templates/>

    </table>

  </div>

</xsl:template>



<xsl:template match="td">

  <xsl:variable name="node" select="string(name(.))"/>

  <xsl:element name="{$node}">

    <!-- copy across the attributes -->

    <xsl:copy-of select="@*"/>    

    <xsl:if test="string-length(./text())=0" > 

      <xsl:value-of select="string('&#x00A0;')" />

      </xsl:if>

      <xsl:apply-templates/>

  </xsl:element>

</xsl:template>

  

  <xsl:template match="br">

    <xsl:variable name="node" select="string(name(.))"/>

    <xsl:element name="{$node}">

      <!-- copy across the attributes -->

      <xsl:copy-of select="@*"/>    

      <xsl:if test="string-length(./text())=0" > 

        <xsl:value-of select="string('&#x00A0;')" />

      </xsl:if>

    </xsl:element>

  </xsl:template>



<xsl:template match="tr">

  <xsl:variable name="node" select="string(name(.))"/>

  <xsl:element name="{$node}">

    <!-- copy across the attributes -->

    <xsl:copy-of select="@*"/>    

      <xsl:apply-templates/>

  </xsl:element>

</xsl:template>



<xsl:template match="th">

  <xsl:element name="th">

    <!-- copy across the attributes -->

    <xsl:copy-of select="@*"/>    

    <p align="center"><b><xsl:apply-templates/></b></p>

  </xsl:element>

</xsl:template>





  <xsl:template name="remove_word">

    <xsl:param name="list"/>

    <xsl:param name="word"/>    

    <xsl:variable

      name="first"

      select="substring-before($list,$word)"/>

    <xsl:variable

      name="rest"

      select="substring-after($list,$word)"/>

    <xsl:value-of select="normalize-space(concat($first,$rest))"/>

</xsl:template>



<!-- Given a string representing a space separated list, remove all

     duplicate words

-->

  <!--

       Removes all duplicate words from the list

       -->

  <xsl:template name="remove_duplicates">

    <xsl:param name="list" />

    <xsl:call-template name="remove_duplicates_rec">

      <xsl:with-param name="list"

        select="concat(normalize-space($list),' ')" />

      <xsl:with-param name="return_list" select="' '" />

    </xsl:call-template>

  </xsl:template>

  <xsl:template name="remove_duplicates_rec">

    <xsl:param name="list" />

    <xsl:param name="return_list" />

    <xsl:variable

      name="first"

      select="substring-before($list,' ')" />

    <xsl:variable

      name="rest"

      select="substring-after($list,' ')" />

    <xsl:choose>

      <!-- only one word left -->

      <xsl:when test="not($first)" >

        <xsl:choose>

          <!-- check that the word has not already been found -->

          <xsl:when test="contains($return_list,concat(' ',$list,' '))">

            <xsl:value-of select="normalize-space($return_list)" />

          </xsl:when>

          <xsl:otherwise>

            <xsl:value-of select="normalize-space(concat($return_list,' ',$list))" />

          </xsl:otherwise>

        </xsl:choose>

      </xsl:when>

      <xsl:when test="contains($return_list,concat(' ',$first,' '))" >

        <xsl:call-template name="remove_duplicates_rec">

          <xsl:with-param name="list" select="$rest" />

          <xsl:with-param name="return_list" select="$return_list" />

        </xsl:call-template>

      </xsl:when>

      <xsl:otherwise>

        <xsl:call-template name="remove_duplicates_rec">

          <xsl:with-param name="list" select="$rest" />

          <xsl:with-param name="return_list" select="concat($return_list,$first,' ')" />

        </xsl:call-template>

      </xsl:otherwise>

    </xsl:choose>

  </xsl:template>



  <!-- given the name of a module, check to see whether it has been

       included in the repository_index.xml file

       Return true or if not found, an error message.

       -->

  <xsl:template name="check_module_exists">

    <xsl:param name="module"/>



    <xsl:variable name="module_name">

      <xsl:call-template name="module_name">

        <xsl:with-param name="module" select="$module"/>

      </xsl:call-template>

    </xsl:variable>



    <xsl:variable name="ret_val">

        <xsl:choose>

          <xsl:when

            test="document('../repository_index.xml')/repository_index/modules/module[@name=$module_name]">

            <xsl:value-of select="'true'"/>

          </xsl:when>

          <xsl:otherwise>

            <xsl:value-of

              select="concat(' The module ', $module_name,

                      ' is not identified as a module in repository_index.xml')"/>

          </xsl:otherwise>

        </xsl:choose>

      </xsl:variable>

      <xsl:value-of select="$ret_val"/>

  </xsl:template>

  

  <!-- given the name of a module, check to see whether it has been

    included in the repository_index.xml file

    Return true or if not found, an error message.

  -->

  <xsl:template name="check_bom_doc_exists">

    <xsl:param name="bom_doc"/>

    

    <xsl:variable name="bom_name">

      <xsl:call-template name="module_name">

        <xsl:with-param name="module" select="$bom_doc"/>

      </xsl:call-template>

    </xsl:variable>

    

    <xsl:variable name="ret_val">

      <xsl:choose>

        <xsl:when

          test="document('../repository_index.xml')/repository_index/business_object_models/business_object_model[@name=$bom_name]">

          <xsl:value-of select="'true'"/>

        </xsl:when>

        <xsl:otherwise>

          <xsl:value-of

            select="concat(' The Business object model ', $bom_name,

            ' is not identified as a business_object_model in repository_index.xml')"/>

        </xsl:otherwise>

      </xsl:choose>

    </xsl:variable>

    <xsl:value-of select="$ret_val"/>

  </xsl:template>

  



  <!-- given the name of a schema, check to see whether it has bee

       included in the repository_index.xml file as an

       integrated resource

       Return true or if not found, an error message.

       -->

  <xsl:template name="check_resource_exists">

    <xsl:param name="schema"/>



    <!-- the name of the resource directory should be in lower case -->

    <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>

    <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

    <xsl:variable name="lschema" select="translate($schema,$UPPER,$LOWER)"/>

    <xsl:variable name="ret_val">

        <xsl:choose>

          <xsl:when

            test="document('../repository_index.xml')/repository_index/resources/resource[@name=$lschema]">

            <xsl:value-of select="'true'"/>

          </xsl:when>

          <xsl:otherwise>

            <xsl:value-of

              select="concat(' The schema ', $lschema,

                      ' is not identified as a resource in repository_index.xml')"/>

          </xsl:otherwise>

        </xsl:choose>

      </xsl:variable>

      <xsl:value-of select="$ret_val"/>

  </xsl:template>



  <xsl:template name="check_reference_exists">

    <xsl:param name="schema"/>



    <!-- the name of the resource directory should be in lower case -->

    <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>

    <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

    <xsl:variable name="lschema" select="translate($schema,$UPPER,$LOWER)"/>

    <xsl:variable name="ret_val">

        <xsl:choose>

          <xsl:when

            test="document('../repository_index.xml')/repository_index/resources/resource[@name=$lschema]">

            <xsl:value-of select="'true'"/>

          </xsl:when>

          <xsl:otherwise>

            <xsl:value-of

              select="concat(' The schema ', $lschema,

                      ' is not identified as a resource in repository_index.xml')"/>

          </xsl:otherwise>

        </xsl:choose>

      </xsl:variable>

      <xsl:value-of select="$ret_val"/>

  </xsl:template>







  <xsl:template name="check_resdoc_exists">

    <xsl:param name="resdoc"/>



    <xsl:variable name="resdoc_name">

      <xsl:call-template name="resdoc_name">

        <xsl:with-param name="resdoc" select="$resdoc"/>

      </xsl:call-template>

    </xsl:variable>

    <xsl:variable name="ret_val">

        <xsl:choose>

          <xsl:when

            test="document('../repository_index.xml')/repository_index/resource_docs/resource_doc[@name=$resdoc_name]">

            <xsl:value-of select="'true'"/>

          </xsl:when>

          <xsl:otherwise>

            <xsl:value-of

              select="concat(' The resource document ', $resdoc_name,

                      ' is not identified as a resource document  in repository_index.xml')"/>

          </xsl:otherwise>

        </xsl:choose>

      </xsl:variable>

      <xsl:value-of select="$ret_val"/>

  </xsl:template>





  <!-- output a warning message. If $inline is yes then the error message

       will be included  in the HTML output.

       NOTE - this gets overridden if $INLINE_ERRORS defined in

       parameters.xsl is 'no'

       A line break can be inserted into the string by inserting a #

       -->

  <xsl:template name="error_message">

    <xsl:param name="message"/>

    <xsl:param name="inline" select="'yes'"/>

    <xsl:param name="linebreakchar" select="'#'"/>

    <xsl:param name="warning_gif"

      select="'../../../../images/warning.gif'"/>

    

    <xsl:message>

      <xsl:value-of select="translate($message,$linebreakchar,'&#010;')"/>
      
    </xsl:message>

    <xsl:if test="contains($INLINE_ERRORS,'yes')">

      <xsl:if test="contains($inline,'yes')">

        <br/>

        <IMG

          SRC="{$warning_gif}" ALT="[warning:]"

          align="bottom" border="0"

width="20" height="20"/>
        
       

        <font color="#FF0000" size="-1">

          <i>

            <xsl:call-template name="output_line_breaks">

              <xsl:with-param name="str" select="$message"/>

              <xsl:with-param name="break_char" select="'#'"/>

              <xsl:with-param name="replace_break_char" select="'true'"/>

            </xsl:call-template>

          </i>

        </font>

        <br/>

      </xsl:if>

    </xsl:if>

  </xsl:template>



  <!-- given the name of a module, or module arm or mim schema

       return the name of the module as it is to be displayed

       i.e First character uppercase, then whitespace

       -->

  <xsl:template name="module_display_name">

    <xsl:param name="module"/>



    <xsl:variable name="mod_dir">

      <xsl:call-template name="module_name">

        <xsl:with-param name="module" select="$module"/>

      </xsl:call-template>

    </xsl:variable>

    <!-- Note the use of Latin characters -->

    <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ&#192;&#193;&#194;&#195;&#196;&#197;&#198;&#199;&#200;&#201;&#202;&#203;&#204;&#205;&#206;&#207;&#208;&#209;&#210;&#211;&#212;&#213;&#214;&#216;&#217;&#218;&#219;&#220;&#221;&#376;&#222;</xsl:variable>

<xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz&#224;&#225;&#226;&#227;&#228;&#229;&#230;&#231;&#232;&#233;&#234;&#235;&#236;&#237;&#238;&#239;&#240;&#241;&#242;&#243;&#244;&#245;&#246;&#248;&#249;&#250;&#251;&#252;&#253;&#255;&#254;</xsl:variable>



    <xsl:variable name="first_char"

      select="substring(translate($module,$LOWER,$UPPER),1,1)"/>

    <xsl:variable name="module_name1"

      select="concat($first_char,

              translate(substring($module,2),'_',' '))"/>



    <xsl:variable name="ap_sect1" select="substring($module_name1,1,2)"/>

    <xsl:variable name="ap_sect2" select="translate(substring($module_name1,3,3),'0123456789','##########')"/>





    <xsl:variable name="module_name2">

      <xsl:choose>

        <xsl:when test="$ap_sect2='###' and $ap_sect1 = 'Ap'">

          <xsl:value-of select="concat('AP',substring($module_name1,3))"/>

        </xsl:when>

        <xsl:otherwise>

          <xsl:value-of select="$module_name1"/>

        </xsl:otherwise>

      </xsl:choose>

    </xsl:variable>



    <xsl:variable name="module_name">

      <xsl:choose>

        <xsl:when test="contains($module_name2,' 3d ')">

          <xsl:value-of select="concat(substring-before($module_name2,' 3d '),' 3D ',substring-after($module_name2,' 3d '))"/>

        </xsl:when>

        <xsl:when test="contains($module_name2,' 2d ')">

          <xsl:value-of select="concat(substring-before($module_name2,' 2d '),' 2D ',substring-after($module_name2,' 2d '))"/>

        </xsl:when>



        <xsl:when test="contains($module_name2,' 3d') and string-length(substring-after($module_name2,' 3d'))=0">

          <xsl:value-of select="concat(substring-before($module_name2,' 3d'),' 3D')"/>

        </xsl:when>



        <xsl:when test="contains($module_name2,' 2d') and string-length(substring-after($module_name2,' 2d'))=0">

          <xsl:value-of select="concat(substring-before($module_name2,' 2d'),' 2D')"/>

        </xsl:when>



        <xsl:when test="contains($module_name2,'3d ') and string-length(substring-before($module_name2,'3d '))=0">

          <xsl:value-of select="concat('3D ', substring-after($module_name2,'3d '))"/>

        </xsl:when>



        <xsl:when test="contains($module_name2,'2d ') and string-length(substring-before($module_name2,'2d '))=0">

          <xsl:value-of select="concat('2D ', substring-after($module_name2,'2d '))"/>

        </xsl:when>





        <xsl:otherwise>

          <xsl:value-of select="$module_name2"/>

        </xsl:otherwise>







      </xsl:choose>

    </xsl:variable>



    <xsl:value-of select="$module_name"/>

  </xsl:template>



  <xsl:template name="protocol_display_name">

    <xsl:param name="application_protocol"/>



    <xsl:variable name="mod_dir">

      <xsl:call-template name="module_name">

        <xsl:with-param name="module" select="$application_protocol"/>

      </xsl:call-template>

    </xsl:variable>

    <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

    <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>



    <xsl:variable name="first_char"

      select="substring(translate($application_protocol,$LOWER,$UPPER),1,1)"/>



    <xsl:variable name="module_name"

      select="concat($first_char,

              translate(substring($application_protocol,2),'_',' '))"/>

    <xsl:value-of select="$module_name"/>



  </xsl:template>



  <!-- given the name of a module, or module arm or mim schema

       return the name of the module

       -->

  <xsl:template name="module_name">

    <xsl:param name="module"/>

    <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

    <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>

    <xsl:variable name="module_lcase"

      select="translate(

              normalize-space(translate($module,$UPPER, $LOWER)),

              '&#x20;','_')"/>

    <xsl:variable name="mod_name">

      <xsl:choose>

        <xsl:when test="contains($module_lcase,'_arm')">

          <xsl:value-of select="substring-before($module_lcase,'_arm')"/>

        </xsl:when>

        <xsl:when test="contains($module_lcase,'_mim')">

          <xsl:value-of select="substring-before($module_lcase,'_mim')"/>

        </xsl:when>

        <xsl:when test="contains($module_lcase,'_bom')">

          <xsl:value-of select="substring-before($module_lcase,'_bom')"/>

        </xsl:when>

        <xsl:otherwise>

          <xsl:value-of select="string($module_lcase)"/>

        </xsl:otherwise>

      </xsl:choose>

    </xsl:variable>

    <xsl:value-of select="$mod_name"/>

  </xsl:template>



  <!-- given the name of a module, or module arm or mim schema

       return the directory part

-->

  <xsl:template name="module_directory">

    <xsl:param name="module"/>

    <xsl:variable name="mod_dir">

      <xsl:call-template name="module_name">

        <xsl:with-param name="module" select="$module"/>

      </xsl:call-template>

    </xsl:variable>

    <xsl:value-of select="concat('../data/modules/',$mod_dir)"/>

  </xsl:template>







  <!-- given the name of a module, return the name of the arm or mim schema

       -->

  <xsl:template name="schema_name">

    <xsl:param name="module_name"/>

    <xsl:param name="arm_mim" select="'arm'"/>

    <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

    <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>

    <xsl:variable name="first_char" 

      select="translate(substring($module_name,1,1),$LOWER,$UPPER)"/>

    <xsl:value-of 

      select="concat($first_char,substring($module_name,2),'_',$arm_mim)"/>

  </xsl:template>













  <!-- given the name of a resource or schema , return the name of resource

       -->

  <xsl:template name="resource_name">

    <xsl:param name="resource"/>

    <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

    <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>

    <xsl:variable name="resource_lcase"

      select="translate(

              normalize-space(translate($resource,$UPPER, $LOWER)),

              '&#x20;','_')"/>

    <xsl:variable name="name">

      <xsl:choose>

        <xsl:when test="contains($resource_lcase,'_schema')">

          <xsl:value-of select="substring-before($resource_lcase,'_schema')"/>

        </xsl:when>

        <xsl:when test="contains($resource_lcase,'aic_')">

          <xsl:value-of select="substring-after($resource_lcase,'aic_')"/>

        </xsl:when>

        <xsl:otherwise>

          <xsl:value-of select="string($resource_lcase)"/>

        </xsl:otherwise>

      </xsl:choose>

    </xsl:variable>

    <xsl:value-of select="$name"/>

  </xsl:template>





  <!-- given the name of a resource document , return the name of resource document - dont ask

       -->

  <xsl:template name="resdoc_name">

    <xsl:param name="resdoc"/>

    <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

    <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>

    <xsl:variable name="first_char" 

      select="translate(substring($resdoc,1,1),$UPPER,$LOWER)"/>

    <xsl:value-of 

      select="concat($first_char,substring($resdoc,2))"/>

  </xsl:template>





  <!-- given the name of a resource doc or resource  - that is minus the _schema

       return the name as it is to be displayed

       i.e First character uppercase, then whitespace

       -->

  <xsl:template name="res_display_name">

    <xsl:param name="res"/>

    <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

    <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>



    <xsl:variable name="first_char"

      select="substring(translate($res,$LOWER,$UPPER),1,1)"/>



    <xsl:variable name="res_name"

      select="concat($first_char,

              translate(substring($res,2),'_',' '))"/>

    <xsl:value-of select="$res_name"/>



  </xsl:template>



  <!-- given the name of a resource return the schema name

       -->

  <xsl:template name="res_schema_name">

    <xsl:param name="resource"/>

    <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

    <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>

    <xsl:variable name="resource_lcase"

      select="translate(

              normalize-space(translate($resource,$UPPER, $LOWER)),

              '&#x20;','_')"/>

    <xsl:variable name="res_name">

          <xsl:value-of select="substring-before($resource_lcase,'_schema')"/>

          <xsl:value-of select="substring-after($resource_lcase,'aic_')"/>

    </xsl:variable>

    <xsl:value-of select="$res_name"/>

  </xsl:template>



  <!-- given the name of a resource doc

       return the resource doc directory - unlike module no need to lower case the name.

-->



  <xsl:template name="resdoc_directory">

    <xsl:param name="resdoc"/>

    <xsl:value-of select="concat('../../data/resource_docs/',$resdoc)"/>

  </xsl:template>





  <!-- given the name of a resource

       return the directory

-->

  <xsl:template name="resource_directory">

    <xsl:param name="resource"/>

    <xsl:value-of select="concat('../../data/resources/',$resource)"/>

  </xsl:template>



  <!-- given the name of a resource

       return the resource file path

-->





  <xsl:template name="resource_file">

    <xsl:param name="resource"/>

    <xsl:value-of select="concat('../data/resources/',$resource,'/',$resource,'.xml')"/>

  </xsl:template>





  <!-- given the name of a resource expg file

       return the resource expg file path

-->





  <xsl:template name="resource_expg_file">

    <xsl:param name="resource"/>

    <xsl:param name="expg_file"/>

    <xsl:value-of select="concat('../data/resources/',$resource,'/',$expg_file)"/>

  </xsl:template>



  <!-- return the target for an express entity

       This will be of the form schema.entity.attribute

       -->

  <xsl:template name="express_a_name">

    <xsl:param name="section1" select="''"/>

    <xsl:param name="section2" select="''"/>

    <xsl:param name="section3" select="''"/>

    <xsl:param name="section3separator" select="'.'"/>

    <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

    <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>



    <xsl:variable name="s1"

      select="normalize-space(translate($section1,$UPPER,$LOWER))"/>

    <xsl:variable name="s2"

      select="normalize-space(translate($section2,$UPPER,$LOWER))"/>

    <xsl:variable name="s3"

      select="normalize-space(translate($section3,$UPPER,$LOWER))"/>



    <xsl:choose>

      <xsl:when test="$s3">

        <xsl:value-of select="concat($s1,'.',$s2,$section3separator,$s3)"/>

      </xsl:when>

      <xsl:when test="$s2">

        <xsl:value-of select="concat($s1,'.',$s2)"/>

      </xsl:when>

      <xsl:when test="$s1">

        <xsl:value-of select="$s1"/>

      </xsl:when>

    </xsl:choose>



  </xsl:template>





  <!-- a reference to an EXPRESS construct in a module ARM or MIM or in

       a standard outside of STEPMOD -->

  <xsl:template match="express_extref">

    <b>

      <xsl:value-of select="@linkend"/>

    </b>

    defined in 

    <xsl:value-of select="@standard"/>

  </xsl:template>





  <!-- a reference to an EXPRESS construct in a module ARM or MIM or in the

       Integrated Resource. The format of the linkend attribute that

       defines the reference is:

       <module>:<link_type>:<schema>.<entity|type|function|constant>.<attribute>|wr:<whererule>|ur:<uniquerule>



     where:

      <module> - the name of the module

      <link_type>

       arm - links to the arm documentation

       arm_express - links to the arm express

       mim - links to the mim documentation

       mim_express - links to the mim express

       mim_lf_express - links to the mim long form express

       ir - links to the ir express



     e.g. work_order:arm:work_order_arm.Activity.name



     To address an EXPRESS construct in an Integrated Resource schema:

     <ir>:ir:<schema>.<entity|type|function|constant>.<attribute>|wr:<whererule>|ur:<uniquerule>

-->

  <xsl:template match="express_ref">



    <xsl:call-template name="check_express_ref">

      <xsl:with-param name="linkend" select="@linkend"/>

    </xsl:call-template>



    <xsl:variable name="href">

      <xsl:call-template name="get_href_from_express_ref">

        <xsl:with-param name="linkend" select="@linkend"/>

      </xsl:call-template>

      

    </xsl:variable>



    <xsl:variable name="last_section">

      <xsl:call-template name="get_last_section">

        <xsl:with-param name="path" select="@linkend"/>

      </xsl:call-template>

    </xsl:variable>



    <xsl:variable name="item">

      <!-- if the express_ref is of the form

           linkend="state_type_schema:ir_express:state_type_schema" -->

      <xsl:choose>        

        <xsl:when test="contains($last_section,':ir_express:')">

          <xsl:value-of select="substring-after($last_section,':ir_express:')"/>

        </xsl:when>

      <!-- if the express_ref is of the form

           linkend="state:ir:state_type_schema" -->



        <xsl:when test="contains($last_section,':ir:')">

          <xsl:value-of select="substring-after($last_section,':ir:')"/>

        </xsl:when>



      <!-- if the express_ref is of the form

           linkend="" -->

        <xsl:when test="contains($last_section,':mim:')">

          <xsl:value-of select="substring-after($last_section,':mim:')"/>

        </xsl:when>



      <!-- if the express_ref is of the form

           linkend="" -->

        <xsl:when test="contains($last_section,':arm:')">

          <xsl:value-of select="substring-after($last_section,':arm:')"/>

        </xsl:when>



        <xsl:when test="contains($last_section,':mim_lf_express:')">

          <xsl:value-of select="substring-after($last_section,':mim_lf_express:')"/>

        </xsl:when>



        <xsl:when test="contains($last_section,':arm_lf_express:')">

          <xsl:value-of select="substring-after($last_section,':arm_lf_express:')"/>

        </xsl:when>

        

        <!-- if the express_ref is of the form

          linkend="" -->

        <xsl:when test="contains($last_section,':bom:')">

          <xsl:value-of select="substring-after($last_section,':bom:')"/>

        </xsl:when>



        <xsl:otherwise>

          <xsl:value-of select="$last_section"/>

        </xsl:otherwise>

      </xsl:choose>

    </xsl:variable>



    <xsl:choose>

      <xsl:when test="$href=''">

        <xsl:call-template name="error_message">

          <xsl:with-param

            name="message"

            select="concat('ERROR c2: express_ref linkend #',

                    @linkend,

                    '# is incorrectly specified.')"/>

        </xsl:call-template>

      

        <xsl:choose>

          <xsl:when test="string-length(normalize-space(.))>0">

            <b><xsl:apply-templates/></b>

          </xsl:when>

          <xsl:otherwise>

            <b><xsl:value-of select="$item"/></b>

          </xsl:otherwise>

        </xsl:choose>

      </xsl:when>

      <xsl:otherwise>

        <xsl:choose>

          <xsl:when test="string-length(normalize-space(.))>0">

            <a href="{$href}"><b><xsl:apply-templates/></b></a>

          </xsl:when>

          <xsl:otherwise>

            <a href="{$href}"><b><xsl:value-of select="$item"/></b></a>

          </xsl:otherwise>

        </xsl:choose>

      </xsl:otherwise>

    </xsl:choose>

  </xsl:template>









   <xsl:template name="get_href_from_express_ref">
     <xsl:param name="linkend"/>
     <!-- the relative path to be added to the url -->
     <xsl:param name="baselink" select="'../../../'"/>
     
    <!-- remove all whitespace -->
    <xsl:variable
      name="nlinkend"
      select="translate($linkend,'&#x9;&#xA;&#x20;&#xD;','')"/>
     
    <xsl:variable name="module">
      <xsl:call-template name="module_name">
        <xsl:with-param name="module" select="substring-before($nlinkend,':')"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- BOM -->
    <xsl:variable name="model">
       <xsl:call-template name="model_name2">
         <xsl:with-param name="model_param" select="substring-before($nlinkend,':')"/>
       </xsl:call-template>
    </xsl:variable>

    <xsl:variable
      name="nlinkend1"
      select="substring-before(substring-after($nlinkend,':'),':')"/>
     
     <!--<xsl:variable name="stringLengthOfNlinkend" select="$nlinkend1"/>
     <xsl:variable name="stringLengthOfNlinkendMinus_schema" select="stringLengthOfNlinkend - 6"/>
     <xsl:variable name="_schema_suffix" select="substring($nlinkend1, $stringLengthOfNlinkend)"/>
-->
    <xsl:variable name="arm_mim_ir">
      <xsl:choose>
        <xsl:when test="$nlinkend1='arm'
                        or $nlinkend1='arm_lf_express'
                        or $nlinkend1='arm_express'
                        or $nlinkend1='mim'
                        or $nlinkend1='mim_lf_express'
                        or $nlinkend1='mim_express'
                        or $nlinkend1='ir_express'
						            or $nlinkend1='ir'
						            or $nlinkend1='bom'
						            or starts-with($nlinkend1,'aic')
						            or contains($nlinkend1,'_schema')
					">
          <!--
          or $_schema_suffix='_schema'
          or contains($nlinkend1,'_schema'
          -->
          <xsl:value-of select="$nlinkend1"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- error found, do nothing until href variable is set -->
          <xsl:value-of select="''"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="express_ref" select="translate(substring-after(substring-after($nlinkend,':'),':'), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>

    <xsl:variable name="href">
      <xsl:choose>
        <xsl:when test="$module='' or $arm_mim_ir=''">
          
          <!--
               error do nothing as the error will be picked up after the
               href variable is set.
               -->
        </xsl:when>

        <xsl:when test="$arm_mim_ir='ir_express'">
          <xsl:value-of select="concat($baselink,'resources/',$module,'/', $module,$FILE_EXT,'#',$express_ref)"/>
        </xsl:when>

        <xsl:when test="$arm_mim_ir='ir'">
          <!-- get the name and position of the resource_part containing the schema. -->
          <xsl:variable name="schema" select="substring-before($express_ref,'.')"/>
          <xsl:variable name="resdoc_xml" select="document(concat('../data/resource_docs/',$module,'/resource.xml'))"/>
          <xsl:variable name="temp" >
            <xsl:for-each select="$resdoc_xml/resource//schema">
              <xsl:if test="@name=$schema">
                <xsl:value-of select="concat($baselink,'resource_docs/',$module, '/sys/', position()+3,'_schema',$FILE_EXT,'#',$express_ref)"/>
              </xsl:if>
            </xsl:for-each>
          </xsl:variable>
          <xsl:value-of select="$temp"/>
        </xsl:when>

        <xsl:when test="$arm_mim_ir='arm'">
          <xsl:value-of select="concat($baselink,'modules/',$module, '/sys/4_info_reqs',$FILE_EXT,'#',$express_ref)"/>
        </xsl:when>

        <!-- BOM -->
        <xsl:when test="$arm_mim_ir='bom'">
          <xsl:value-of select="concat($baselink,'business_object_models/',$model, '/sys/4_info_reqs',$FILE_EXT,'#',$express_ref)"/>
        </xsl:when>

        <xsl:when test="$arm_mim_ir='arm_express'">
          <xsl:value-of select="concat($baselink,'modules/',$module, '/arm',$FILE_EXT,'#',$express_ref)"/>
        </xsl:when>

        <xsl:when test="$arm_mim_ir='mim'">
          <xsl:value-of select="concat($baselink,'modules/',$module, '/sys/5_mim',$FILE_EXT,'#',$express_ref)"/>
        </xsl:when>

        <xsl:when test="$arm_mim_ir='mim_express'">
          <xsl:value-of select="concat($baselink,'modules/',$module, '/mim',$FILE_EXT,'#',$express_ref)"/>
        </xsl:when>

        <xsl:when test="$arm_mim_ir='mim_lf_express'">
          <xsl:value-of select="concat($baselink,'modules/',$module, '/sys/e_exp_mim_lf',$FILE_EXT,'#',$express_ref)"/>
        </xsl:when>

        <xsl:when test="$arm_mim_ir='arm_lf_express'">
           <xsl:value-of select="concat($baselink,'modules/',$module, '/sys/e_exp_arm_lf',$FILE_EXT,'#',$express_ref)"/>
        </xsl:when>
        
        <xsl:when test="starts-with($nlinkend1,'aic')">
          <xsl:value-of select="concat($baselink,'resources/',$module, '/', $module, $FILE_EXT, '#',$express_ref)"/>
        </xsl:when>
        
        <xsl:when test="contains($nlinkend1, '_schema')">
          <xsl:value-of select="concat($baselink,'resources/',$module, '/', $module, $FILE_EXT, '#',$express_ref)"/>
        </xsl:when>
        
      </xsl:choose>
    </xsl:variable>

    <xsl:value-of select="$href"/>

  </xsl:template>



  <!-- A reference to a section of the module.

       The format of the linkend attribute that defines the reference is:

       <module>:<section>:<construct>:<id>



     where:

      <module> is the name of the module

      <section> is either:

         introduction

         1_scope

         1_inscope

         1_outscope

         2_normrefs

         3_definition

         3_abbreviations

         4_uof

         4_interfaces

         4_constants

         4_types

         4_entities

				 4_subtype_constraints

         4_rules

         4_functions

         4_procedures

         5_mapping

         5_mim_express

         5_interfaces

         5_constants

         5_types

         5_entities

         5_rules

         5_functions

         5_procedures

         f_usage_guide

      <construct> is optional and is either:

         figure

         note

         example

         table

      <id> if a construct is given, then id is the identifier for the

           construct.

      -->

  <xsl:template match="module_ref">

    <!-- remove all whitespace -->

    <xsl:variable

      name="nlinkend"

      select="translate(@linkend,'&#x9;&#xA;&#x20;&#xD;','')"/>



    <xsl:variable name="module_sect">

      <xsl:choose>

        <xsl:when test="contains($nlinkend,':')">

          <xsl:value-of select="substring-before($nlinkend,':')"/>

        </xsl:when>

        <xsl:otherwise>

          <xsl:value-of select="$nlinkend"/>

        </xsl:otherwise>

      </xsl:choose>

    </xsl:variable>



    <xsl:variable name="module">

      <xsl:call-template name="module_name">

        <xsl:with-param name="module" select="$module_sect"/>

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

                        or $section_tmp='4_uof'

                        or $section_tmp='4_interfaces'

                        or $section_tmp='4_constants'

                        or $section_tmp='4_types'

                        or $section_tmp='4_entities'

												or $section_tmp='4_subtype_constraints'

                        or $section_tmp='4_rules'

                        or $section_tmp='4_functions'

                        or $section_tmp='4_procedures'

                        or $section_tmp='5_mapping'

                        or $section_tmp='5_mim_express'

                        or $section_tmp='5_interfaces'

                        or $section_tmp='5_constants'

                        or $section_tmp='5_types'

                        or $section_tmp='5_entities'

                        or $section_tmp='5_subtype_constraints'

                        or $section_tmp='5_rules'

                        or $section_tmp='5_functions'

                        or $section_tmp='5_procedures'

                        or $section_tmp='f_usage_guide'">

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

        <xsl:when test="$module=''">

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

            select="concat('../../../modules/',$module,'/sys/introduction',

                    $FILE_EXT)"/>

        </xsl:when>

        <xsl:when test="$section='introduction'">

          <xsl:value-of

            select="concat('../../../modules/',$module,'/sys/introduction',

                    $FILE_EXT,$construct)"/>

        </xsl:when>



        <xsl:when test="$section='1_scope'">

          <xsl:choose>

            <xsl:when test="$construct">

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/1_scope',$FILE_EXT,$construct)"/>

            </xsl:when>

            <xsl:otherwise>

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/1_scope',$FILE_EXT,'#scope')"/>

            </xsl:otherwise>

          </xsl:choose>

        </xsl:when>



        <xsl:when test="$section='1_inscope'">

          <xsl:choose>

            <xsl:when test="$construct=''">

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/1_scope',$FILE_EXT,'#inscope')"/>

            </xsl:when>

            <xsl:otherwise>

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/1_scope',$FILE_EXT,$construct)"/>

            </xsl:otherwise>

          </xsl:choose>

        </xsl:when>



        <xsl:when test="$section='1_outscope'">

          <xsl:choose>

            <xsl:when test="$construct=''">

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/1_scope',$FILE_EXT,'#outscope')"/>

            </xsl:when>

            <xsl:otherwise>

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/1_scope',$FILE_EXT,$construct)"/>

            </xsl:otherwise>

          </xsl:choose>

        </xsl:when>



        <xsl:when test="$section='2_normrefs'">

          <xsl:choose>

            <xsl:when test="$construct=''">

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/2_refs',$FILE_EXT)"/>

            </xsl:when>

            <xsl:otherwise>

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/2_refs',$FILE_EXT,$construct)"/>

            </xsl:otherwise>

          </xsl:choose>

        </xsl:when>



        <xsl:when test="$section='3_definition'">

          <xsl:choose>

            <xsl:when test="$construct=''">

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/3_defs',$FILE_EXT)"/>

            </xsl:when>

            <xsl:otherwise>

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/3_defs',$FILE_EXT,$construct)"/>

            </xsl:otherwise>

          </xsl:choose>

        </xsl:when>



        <xsl:when test="$section='3_abbreviations'">

          <xsl:choose>

            <xsl:when test="$construct=''">

          <xsl:value-of

            select="concat('../../../modules/',$module,

                    '/sys/3_defs',$FILE_EXT)"/>

        </xsl:when>

            <xsl:otherwise>

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/3_defs',$FILE_EXT,$construct)"/>

            </xsl:otherwise>

          </xsl:choose>

        </xsl:when>



        <xsl:when test="$section='4_uof'">

          <xsl:choose>

            <xsl:when test="$construct=''">

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/4_info_reqs',$FILE_EXT,'#uof')"/>

            </xsl:when>

            <xsl:otherwise>

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/4_info_reqs',$FILE_EXT,$construct)"/>

            </xsl:otherwise>

          </xsl:choose>

        </xsl:when>



        <xsl:when test="$section='4_interfaces'">

          <xsl:choose>

            <xsl:when test="$construct=''">

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/4_info_reqs',$FILE_EXT,'#interfaces')"/>

            </xsl:when>

            <xsl:otherwise>

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/4_info_reqs',$FILE_EXT,$construct)"/>

            </xsl:otherwise>

          </xsl:choose>

        </xsl:when>



        <xsl:when test="$section='4_constants'">

          <xsl:choose>

            <xsl:when test="$construct=''">

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/4_info_reqs',$FILE_EXT,'#constants')"/>

            </xsl:when>

            <xsl:otherwise>

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/4_info_reqs',$FILE_EXT,$construct)"/>

            </xsl:otherwise>

          </xsl:choose>

        </xsl:when>



        <xsl:when test="$section='4_types'">

          <xsl:choose>

            <xsl:when test="$construct=''">

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/4_info_reqs',$FILE_EXT,'#types')"/>

            </xsl:when>

            <xsl:otherwise>

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/4_info_reqs',$FILE_EXT,$construct)"/>

            </xsl:otherwise>

          </xsl:choose>

        </xsl:when>



        <xsl:when test="$section='4_entities'">

          <xsl:choose>

            <xsl:when test="$construct=''">

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/4_info_reqs',$FILE_EXT,'#entities')"/>

            </xsl:when>

            <xsl:otherwise>

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/4_info_reqs',$FILE_EXT,$construct)"/>

            </xsl:otherwise>

          </xsl:choose>

        </xsl:when>

				

        <xsl:when test="$section='4_subtype_constraints'">

          <xsl:choose>

            <xsl:when test="$construct=''">

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/4_info_reqs',$FILE_EXT,'#subtype_constraints')"/>

            </xsl:when>

            <xsl:otherwise>

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/4_info_reqs',$FILE_EXT,$construct)"/>

            </xsl:otherwise>

          </xsl:choose>

        </xsl:when>

 

        <xsl:when test="$section='4_rules'">

          <xsl:choose>

            <xsl:when test="$construct=''">

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/4_info_reqs',$FILE_EXT,'#rules')"/>              

            </xsl:when>

            <xsl:otherwise>

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/4_info_reqs',$FILE_EXT,$construct)"/>              

            </xsl:otherwise>

          </xsl:choose>

        </xsl:when>



        <xsl:when test="$section='4_functions'">

          <xsl:choose>

            <xsl:when test="$construct=''">

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/4_info_reqs',$FILE_EXT,'#functions')"/>

            </xsl:when>

            <xsl:otherwise>

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/4_info_reqs',$FILE_EXT,$construct)"/>

            </xsl:otherwise>

          </xsl:choose>

        </xsl:when>



        <xsl:when test="$section='4_procedures'">

          <xsl:choose>

            <xsl:when test="$construct=''">

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/4_info_reqs',$FILE_EXT,'#procedures')"/>

            </xsl:when>

            <xsl:otherwise>

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/4_info_reqs',$FILE_EXT,$construct)"/>

            </xsl:otherwise>

          </xsl:choose>

        </xsl:when>



        <xsl:when test="$section='5_mapping'">

          <xsl:choose>

            <xsl:when test="$construct=''">

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/5_mapping',$FILE_EXT,'#mapping')"/>

            </xsl:when>

            <xsl:otherwise>

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/5_mapping',$FILE_EXT,$construct)"/>

            </xsl:otherwise>

          </xsl:choose>

        </xsl:when>



        <xsl:when test="$section='5_mim_express'">

          <xsl:choose>

            <xsl:when test="$construct=''">

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/5_mim',$FILE_EXT,'#mim_express')"/>

            </xsl:when>

            <xsl:otherwise>

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/5_mim',$FILE_EXT,$construct)"/>

            </xsl:otherwise>

          </xsl:choose>

        </xsl:when>



        <xsl:when test="$section='5_interfaces'">

          <xsl:choose>

            <xsl:when test="$construct=''">

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/5_mim',$FILE_EXT,'#interfaces')"/>              

            </xsl:when>

            <xsl:otherwise>

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/5_mim',$FILE_EXT,$construct)"/>

            </xsl:otherwise>

          </xsl:choose>

        </xsl:when>



        <xsl:when test="$section='5_constants'">

          <xsl:choose>

            <xsl:when test="$construct=''">

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/5_mim',$FILE_EXT,'#constants')"/>

            </xsl:when>

            <xsl:otherwise>

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/5_mim',$FILE_EXT,$construct)"/>

            </xsl:otherwise>

          </xsl:choose>

        </xsl:when>



        <xsl:when test="$section='5_types'">

          <xsl:choose>

            <xsl:when test="$construct=''">

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/5_mim',$FILE_EXT,'#types')"/>

            </xsl:when>

            <xsl:otherwise>

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/5_mim',$FILE_EXT,$construct)"/>

            </xsl:otherwise>

          </xsl:choose>

        </xsl:when>



        <xsl:when test="$section='5_entities'">

          <xsl:choose>

            <xsl:when test="$construct=''">

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/5_mim',$FILE_EXT,'#entities')"/>

            </xsl:when>

            <xsl:otherwise>

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/5_mim',$FILE_EXT,$construct)"/>

            </xsl:otherwise>

          </xsl:choose>

        </xsl:when>



        <xsl:when test="$section='5_subtype_constraints'">

          <xsl:choose>

            <xsl:when test="$construct=''">

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/5_mim',$FILE_EXT,'#subtype_constraints')"/>

            </xsl:when>

            <xsl:otherwise>

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/5_mim',$FILE_EXT,$construct)"/>

            </xsl:otherwise>

          </xsl:choose>

        </xsl:when>



        <xsl:when test="$section='5_rules'">

          <xsl:choose>

            <xsl:when test="$construct=''">

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/5_mim',$FILE_EXT,'#rules')"/>

            </xsl:when>

            <xsl:otherwise>

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/5_mim',$FILE_EXT,$construct)"/>

            </xsl:otherwise>

          </xsl:choose>

        </xsl:when>



        <xsl:when test="$section='5_functions'">

          <xsl:choose>

            <xsl:when test="$construct=''">

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/5_mim',$FILE_EXT,'#functions')"/>

            </xsl:when>

            <xsl:otherwise>

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/5_mim',$FILE_EXT,$construct)"/>

            </xsl:otherwise>

          </xsl:choose>

        </xsl:when>



        <xsl:when test="$section='5_procedures'">

          <xsl:choose>

            <xsl:when test="$construct=''">

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/5_mim',$FILE_EXT,'#procedures')"/>

            </xsl:when>

            <xsl:otherwise>

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/5_mim',$FILE_EXT,$construct)"/>

            </xsl:otherwise>

          </xsl:choose>

        </xsl:when>



        <xsl:when test="$section='f_usage_guide'">

          <xsl:choose>

            <xsl:when test="$construct">

              <xsl:value-of

                select="concat('../../../modules/',$module,

                    '/sys/f_guide',$FILE_EXT,$construct)"/>

            </xsl:when>

            <xsl:otherwise>

              <xsl:value-of

                select="concat('../../../modules/',$module,

                        '/sys/f_guide',$FILE_EXT,'#annexf')"/>

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

            <xsl:variable name="module_name">

              <xsl:call-template name="module_display_name">

                <xsl:with-param name="module" select="$module"/>

              </xsl:call-template>

            </xsl:variable>

            <a href="{$href}"><xsl:value-of select="$module_name"/></a>

          </xsl:otherwise>

        </xsl:choose>

      </xsl:otherwise>

    </xsl:choose>

  </xsl:template>



  <!-- count the number of characters in string -->

  <xsl:template name="count_substring">

    <xsl:param name="substring"/>

    <xsl:param name="string"/>

    <xsl:param name="cnt" select="0"/>



    <xsl:choose>

      <xsl:when test="$string">

        <xsl:variable name="rest" select="substring($string,2)"/>

        <xsl:variable name="cnt1">

          <xsl:choose>

            <xsl:when test="starts-with($string,$substring)">

              <xsl:value-of select="$cnt+1"/>

            </xsl:when>

            <xsl:otherwise>

              <xsl:value-of select="$cnt"/>

            </xsl:otherwise>

          </xsl:choose>

        </xsl:variable>



        <xsl:call-template name="count_substring">

          <xsl:with-param name="substring" select="$substring"/>

          <xsl:with-param name="string" select="$rest"/>

          <xsl:with-param name="cnt" select="$cnt1"/>

        </xsl:call-template>

      </xsl:when>

      <xsl:otherwise>

        <xsl:value-of select="$cnt"/>

      </xsl:otherwise>

    </xsl:choose>

  </xsl:template>



  

  <!-- remove any whitespace characters from the start of a string -->

  <xsl:template name="remove_trailing_whitespace">

    <xsl:param name="string"/>

    <xsl:choose>

      <xsl:when test="starts-with($string,'&#xA;')">

        <xsl:call-template name="remove_trailing_whitespace">

          <xsl:with-param name="string" 

            select="substring-after($string,'&#xA;')"/>

        </xsl:call-template>

      </xsl:when>

      <xsl:when test="starts-with($string,'&#xD;')">

        <xsl:call-template name="remove_trailing_whitespace">

          <xsl:with-param name="string" 

            select="substring-after($string,'&#xD;')"/>

        </xsl:call-template>

      </xsl:when>

      <xsl:when test="starts-with($string,'&#x20;')">

        <xsl:call-template name="remove_trailing_whitespace">

          <xsl:with-param name="string" 

            select="substring-after($string,'&#x20;')"/>

        </xsl:call-template>

      </xsl:when>

      <xsl:when test="starts-with($string,'&#x9;')">

        <xsl:call-template name="remove_trailing_whitespace">

          <xsl:with-param name="string" 

            select="substring-after($string,'&#x9;')"/>

        </xsl:call-template>

      </xsl:when>

      <xsl:otherwise>

        <xsl:value-of select="$string"/>

      </xsl:otherwise>

    </xsl:choose>

  </xsl:template>





  <!-- remove any whitespace characters from the end of a string -->

  <xsl:template name="remove_end_whitespace">

    <xsl:param name="string"/>

    <xsl:choose>

      <xsl:when test="substring($string, string-length($string))='&#xA;'">

        <xsl:call-template name="remove_end_whitespace">

          <xsl:with-param name="string" 

            select="substring($string,1,string-length($string)-1)"/>

        </xsl:call-template>

      </xsl:when>

      <xsl:when test="substring($string, string-length($string))='&#xD;'">

        <xsl:call-template name="remove_end_whitespace">

          <xsl:with-param name="string" 

            select="substring($string,1,string-length($string)-1)"/>

        </xsl:call-template>

      </xsl:when>

      <xsl:when test="substring($string, string-length($string))='&#x20;'">

        <xsl:call-template name="remove_end_whitespace">

          <xsl:with-param name="string" 

            select="substring($string,1,string-length($string)-1)"/>

        </xsl:call-template>

      </xsl:when>

      <xsl:when test="substring($string, string-length($string))='&#x9;'">

        <xsl:call-template name="remove_end_whitespace">

          <xsl:with-param name="string" 

            select="substring($string,1,string-length($string)-1)"/>

        </xsl:call-template>

      </xsl:when>

      <xsl:otherwise>

        <xsl:value-of select="$string"/>

      </xsl:otherwise>

    </xsl:choose>

  </xsl:template>





  <!-- remove any whitespace characters from the start and end of a string -->

  <xsl:template name="remove_start_end_whitespace">

    <xsl:param name="string"/>

    <xsl:variable name="string1">

      <xsl:call-template name="remove_end_whitespace">

        <xsl:with-param name="string" select="$string"/>

      </xsl:call-template>

    </xsl:variable>

    <xsl:call-template name="remove_trailing_whitespace">

      <xsl:with-param name="string" select="$string1"/>

    </xsl:call-template>

  </xsl:template>





  <!-- Given a list of words, return a string, replacing all the whitespace with

       ,

       -->

  <xsl:template name="output_comma_separated_list">

    <xsl:param name="string"/>

    <xsl:variable name="nstring" select="normalize-space($string)"/>

    <xsl:choose>

      <xsl:when test="contains($nstring,' ')">

        <xsl:variable

          name="first"

          select="substring-before($nstring,' ')"/>

        <xsl:variable

          name="rest"

          select="substring-after($nstring,' ')"/>



        <xsl:value-of select="concat($first,', ')"/>

        <xsl:call-template name="output_comma_separated_list">

          <xsl:with-param name="string" select="$rest"/>

        </xsl:call-template>

      </xsl:when>

      <xsl:otherwise>

        <xsl:value-of select="$nstring"/>

      </xsl:otherwise>

    </xsl:choose>



  </xsl:template>









  <!-- Output a string, replacing all the carriage returns with

       HTML br

       -->

  <xsl:template name="output_string_with_linebreaks">
    <xsl:param name="string"/>
    <xsl:variable name="nstring" select="translate($string,'&#xA;&#xD;','&#xA;')"/>
      
    <xsl:variable name="nstring-with-any-initial-nl-removed">
          <xsl:choose>
            <xsl:when test="starts-with($nstring, '&#xA;')">
              <xsl:value-of select="substring-after($nstring, '&#xA;')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$nstring"/>
            </xsl:otherwise>
          </xsl:choose>
    </xsl:variable>
    
    <xsl:choose>
      <xsl:when test="contains($nstring-with-any-initial-nl-removed,'&#xA;')">
        <xsl:variable name="first" select="substring-before($nstring-with-any-initial-nl-removed,'&#xA;')"/>
        <xsl:variable name="rest" select="substring-after($nstring-with-any-initial-nl-removed,'&#xA;')"/>
        <xsl:value-of select="$first"/><br/>
        <xsl:call-template name="output_string_with_linebreaks">
           <xsl:with-param name="string" select="$rest"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$nstring-with-any-initial-nl-removed"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>







<!-- return the standard number of the module -->

<xsl:template name="get_module_stdnumber">

  <xsl:param name="module"/>

  <xsl:variable name="part">

    <xsl:choose>

      <xsl:when test="string-length($module/@part)>0">

        <xsl:value-of select="$module/@part"/>

      </xsl:when>

        <xsl:otherwise>

          &lt;part&gt;

        </xsl:otherwise>

      </xsl:choose>

    </xsl:variable>



   <xsl:variable name="status">

    <xsl:choose>

      <xsl:when test="string-length($module/@status)>0">

        <xsl:value-of select="string($module/@status)"/>

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

        <xsl:when test="string-length($module/@publication.year)">

          <xsl:value-of select="$module/@publication.year"/>

        </xsl:when>

        <xsl:otherwise>

          &lt;publication.year&gt;

        </xsl:otherwise>

      </xsl:choose>

    </xsl:variable>



    <xsl:variable name="orgname" select="'ISO'"/>



    <xsl:value-of 

      select="concat($orgname,'/',$status,' 10303-',$part,':',$pub_year)"/>

			

</xsl:template>



<xsl:template name="get_module_stdnumber_undated">

  <xsl:param name="module"/>

  <xsl:variable name="part">

    <xsl:choose>

      <xsl:when test="string-length($module/@part)>0">

        <xsl:value-of select="$module/@part"/>

      </xsl:when>

        <xsl:otherwise>

          &lt;part&gt;

        </xsl:otherwise>

      </xsl:choose>

    </xsl:variable>



   <xsl:variable name="status">

    <xsl:choose>

      <xsl:when test="string-length($module/@status)>0">

        <xsl:choose>

          <xsl:when test="starts-with(string($module/@status),'CD-TS')">TS</xsl:when>

          <xsl:otherwise>

            <xsl:value-of select="string($module/@status)"/>

          </xsl:otherwise>

        </xsl:choose>

      </xsl:when>

      <xsl:otherwise>

        &lt;status&gt;

      </xsl:otherwise>

    </xsl:choose>

   </xsl:variable>



    <xsl:variable name="orgname" select="'ISO'"/>



    <xsl:value-of 

      select="concat($orgname,'/',$status,' 10303-',$part)"/>		

</xsl:template>





<xsl:template name="get_protocol_dated_stdnumber">

  <xsl:param name="application_protocol"/>

  <xsl:variable name="part">

    <xsl:choose>

      <xsl:when test="string-length($application_protocol/@part)>0">

        <xsl:value-of select="$application_protocol/@part"/>

      </xsl:when>

      <xsl:otherwise>

        &lt;part&gt;

      </xsl:otherwise>

    </xsl:choose>

  </xsl:variable>



   <xsl:variable name="status">

    <xsl:choose>

      <xsl:when test="string-length($application_protocol/@status)>0">

        <xsl:value-of select="string($application_protocol/@status)"/>

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

        <xsl:when test="string-length($application_protocol/@publication.year)">

          <xsl:value-of select="$application_protocol/@publication.year"/>

        </xsl:when>

        <xsl:otherwise>

          &lt;publication.year&gt;

        </xsl:otherwise>

      </xsl:choose>

    </xsl:variable>



    <xsl:variable name="orgname" select="'ISO'"/>

    <xsl:choose>

      <xsl:when test="$status='IS'">

        <xsl:value-of select="concat($orgname,' 10303-',$part,':',$pub_year)"/>        

      </xsl:when>

      <xsl:otherwise>

        <xsl:value-of select="concat($orgname,'/',$status,' 10303-',$part,':',$pub_year)"/>        

      </xsl:otherwise>

    </xsl:choose>

  </xsl:template>





<xsl:template name="get_protocol_stdnumber">

  <xsl:param name="application_protocol"/>

  <xsl:variable name="part">

    <xsl:choose>

      <xsl:when test="string-length($application_protocol/@part)>0">

        <xsl:value-of select="$application_protocol/@part"/>

      </xsl:when>

      <xsl:otherwise>

        &lt;part&gt;

      </xsl:otherwise>

    </xsl:choose>

  </xsl:variable>



   <xsl:variable name="status">

    <xsl:choose>

      <xsl:when test="string-length($application_protocol/@status)>0">

        <xsl:value-of select="string($application_protocol/@status)"/>

      </xsl:when>

        <xsl:otherwise>

          &lt;status&gt;

        </xsl:otherwise>

      </xsl:choose>

    </xsl:variable>



    <xsl:variable name="orgname" select="'ISO'"/>

 

   <xsl:variable name="stdnumber">

      <xsl:choose>

        <xsl:when test="$status='IS'">

          <xsl:value-of 

            select="concat($orgname,' 10303-',$part)"/>

        </xsl:when>

        <xsl:otherwise>

          <xsl:value-of 

            select="concat($orgname,'/',$status,' 10303-',$part)"/>          

        </xsl:otherwise>

      </xsl:choose>

    </xsl:variable>



    <xsl:value-of select="$stdnumber"/>



</xsl:template>



<!-- the number of the document for display as a page heaer.

     Used on the cover page and every page header. -->

<xsl:template name="get_module_pageheader">

  <xsl:param name="module"/>

  <xsl:variable name="part">

    <xsl:choose>

      <xsl:when test="string-length($module/@part)>0">

        <xsl:value-of select="$module/@part"/>

      </xsl:when>

        <xsl:otherwise>

          &lt;part&gt;

        </xsl:otherwise>

      </xsl:choose>

    </xsl:variable>



   <xsl:variable name="status">

    <xsl:choose>

      <xsl:when test="string-length($module/@status)>0">

        <xsl:value-of select="string($module/@status)"/>

      </xsl:when>

        <xsl:otherwise>

          &lt;status&gt;

        </xsl:otherwise>

      </xsl:choose>

    </xsl:variable>



    <xsl:variable name="language">

      <xsl:choose>

        <xsl:when test="string-length($module/@language)">

          <xsl:value-of select="$module/@language"/>

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

        <xsl:when test="string-length($module/@publication.year)">

          <xsl:value-of select="$module/@publication.year"/>

        </xsl:when>

        <xsl:otherwise>

          &lt;publication.year&gt;

        </xsl:otherwise>

      </xsl:choose>

    </xsl:variable>



    <xsl:variable name="orgname" select="'ISO'"/>



    <xsl:variable name="stdnumber">

      <xsl:choose>

        <xsl:when test="$status='IS'">

          <xsl:value-of 

            select="concat($orgname,' 10303-',$part,':',$pub_year,'(',$language,') ')"/>

        </xsl:when>

        <xsl:when test="$status='TS' or $status='FDIS'">

          <xsl:value-of 

            select="concat($orgname,'/',$status,' 10303-',$part,':',$pub_year,'(',$language,') ')"/>

        </xsl:when>

        <xsl:otherwise>

          <xsl:value-of 

            select="concat($orgname,'/',$status,' 10303-',$part)"/>          

        </xsl:otherwise>

      </xsl:choose>

    </xsl:variable>



    <xsl:value-of select="$stdnumber"/>



</xsl:template>



<!-- e.g. ISO 10303-203 -->

<xsl:template name="get_protocol_iso_number">

  <xsl:param name="application_protocol"/>

  <xsl:variable name="part">

    <xsl:choose>

      <xsl:when test="string-length($application_protocol/@part)>0">

        <xsl:value-of select="$application_protocol/@part"/>

      </xsl:when>

      <xsl:otherwise>

        XXXX

      </xsl:otherwise>

    </xsl:choose>

  </xsl:variable>

  <xsl:value-of select="concat('ISO&#160;10303-',$part)"/>

</xsl:template>



<xsl:template name="get_protocol_pageheader">

  <xsl:param name="application_protocol"/>

  <xsl:variable name="part">

    <xsl:choose>

      <xsl:when test="string-length($application_protocol/@part)>0">

        <xsl:value-of select="$application_protocol/@part"/>

      </xsl:when>

        <xsl:otherwise>

          &lt;part&gt;

        </xsl:otherwise>

      </xsl:choose>

    </xsl:variable>



   <xsl:variable name="status">

    <xsl:choose>

      <xsl:when test="string-length($application_protocol/@status)>0">

        <xsl:value-of select="string($application_protocol/@status)"/>

      </xsl:when>

        <xsl:otherwise>

          &lt;status&gt;

        </xsl:otherwise>

      </xsl:choose>

    </xsl:variable>



    <xsl:variable name="language">

      <xsl:choose>

        <xsl:when test="string-length($application_protocol/@language)">

          <xsl:value-of select="$application_protocol/@language"/>

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

        <xsl:when test="string-length($application_protocol/@publication.year)">

          <xsl:value-of select="$application_protocol/@publication.year"/>

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



<xsl:template name="get_module_iso_number">

  <xsl:param name="module"/>

  <xsl:variable name="mod_dir">

    <xsl:call-template name="module_directory">

      <xsl:with-param name="module" select="$module"/>

    </xsl:call-template>

  </xsl:variable>

  <xsl:variable name="part">

    <xsl:value-of

      select="document(concat($mod_dir,'/module.xml'))/module/@part"/>

  </xsl:variable>

  <xsl:variable name="status">

    <xsl:value-of

      select="document(concat($mod_dir,'/module.xml'))/module/@status"/>

  </xsl:variable>

  <xsl:value-of select="concat('ISO/',$status,'&#160;10303-',$part)"/>

</xsl:template>







<xsl:template name="get_module_wg_group">

  <xsl:choose>

    <xsl:when test="string-length(/module/@sc4.working_group)>0">

      <xsl:value-of select="normalize-space(/module/@sc4.working_group)"/>

    </xsl:when>

    <xsl:when test="/application_protocol">

      <xsl:value-of select="string('3')"/>

    </xsl:when>

    <xsl:otherwise>

      <xsl:value-of select="string('12')"/>

    </xsl:otherwise>

  </xsl:choose>

</xsl:template>



<xsl:template name="test_module_wg_group">

  <xsl:param name="module"/>

  <xsl:variable name="wg_group">

    <xsl:call-template name="get_module_wg_group"/>

  </xsl:variable>

  

  <xsl:if test="not($wg_group = '12' or $wg_group = '3')">

    <xsl:call-template name="error_message">

      <xsl:with-param name="message">

        <xsl:value-of select="concat('Error in

                              module.xml/module/@sc4.working_group - ',

                              $wg_group,' Should be 12 or 3')"/>

      </xsl:with-param>

    </xsl:call-template>

  </xsl:if>

</xsl:template>







<!-- 

     given a string xxx.ccc.qqq return the value after the last . 

     The . is the divider

-->

<xsl:template name="get_last_section">  

  <xsl:param name="path"/>

  <xsl:param name="divider" select="'.'"/>

  <xsl:choose>

    <xsl:when test="contains($path,$divider)">

      <xsl:call-template name="get_last_section">

        <xsl:with-param name="path" select="substring-after($path,$divider)"/>

        <xsl:with-param name="divider" select="$divider"/>

      </xsl:call-template>

    </xsl:when>

    <xsl:otherwise>

      <xsl:value-of select="$path"/>

    </xsl:otherwise>

  </xsl:choose>

</xsl:template>







<xsl:template name="check_express_ref">

  <xsl:param name="linkend"/>

  <xsl:variable name="first_sect">

    <xsl:call-template name="check_express_ref_first_section">

      <xsl:with-param name="linkend" select="$linkend"/>

    </xsl:call-template>

  </xsl:variable>



  <xsl:choose>

    <xsl:when test="$first_sect = 'OK'">

      

      <!-- remove all whitespace -->

      <xsl:variable

        name="nlinkend"

        select="translate($linkend,'&#x9;&#xA;&#x20;&#xD;','')"/>



      <xsl:variable

        name="module"

        select="substring-before($nlinkend,':')"/>

      

      <xsl:variable

        name="model"

        select="substring-before($nlinkend,':')"/>



	  <xsl:variable 

		  name="module_section" 

		  select="substring-before($nlinkend,':')"/>





	  <xsl:variable 

		  name="nlinkend1"

		  select="substring-before(substring-after($nlinkend,':'),':')"/>



	  <xsl:variable name="mod_dir">

		<xsl:choose>

		  <xsl:when test="$nlinkend1='arm' or $nlinkend1='mim' 

		    or $nlinkend1='arm_express' or $nlinkend1='mim_express'

		    or $nlinkend1='arm_lf_express' or $nlinkend1='mim_lf_express'">

			<xsl:call-template name="module_directory">

			  <xsl:with-param name="module" select="$module"/>

			</xsl:call-template>



		  </xsl:when>

		  

		  <xsl:when test="$nlinkend1='bom'"><!-- BOM -->

		    <xsl:call-template name="model_directory2">

		      <xsl:with-param name="model" select="$model"/>

		      </xsl:call-template>

		  </xsl:when>

		  

		  <xsl:otherwise>

        <xsl:call-template name="resource_directory">

          <xsl:with-param name="module" select="$module"/>

        </xsl:call-template>

		  </xsl:otherwise>

		</xsl:choose>

      </xsl:variable>



      <xsl:variable name="express_path"

        select="substring-after(substring-after($nlinkend,':'),':')"/>

      

      <xsl:variable name="schema">

        <xsl:choose>

          <xsl:when test="contains($express_path,'.')">

            <xsl:value-of select="substring-before($express_path,'.')"/>

          </xsl:when>

          <xsl:otherwise>

            <xsl:value-of select="$express_path"/>

          </xsl:otherwise>

        </xsl:choose>

      </xsl:variable>



      <xsl:variable name="express_path1"

        select="substring-after($express_path,'.')"/>

      

      <xsl:variable name="entity_type">

        <xsl:choose>

          <xsl:when test="contains($express_path1,'.')">

            <xsl:value-of select="substring-before($express_path1,'.')"/>

          </xsl:when>

          <xsl:otherwise>

            <xsl:value-of select="$express_path1"/>

          </xsl:otherwise>

        </xsl:choose>

      </xsl:variable>



      <xsl:variable name="express_path2"

        select="substring-after($express_path1,'.')"/>



      <xsl:variable name="attribute">

        <xsl:choose>

          <xsl:when test="starts-with($express_path2,'wr:') 

                          or starts-with($express_path2,'ur:')">

            <xsl:value-of select="''"/>

          </xsl:when>

          <xsl:otherwise>

            <xsl:value-of select="$express_path2"/>

          </xsl:otherwise>

        </xsl:choose>

      </xsl:variable>



      <xsl:variable name="wr">

        <xsl:choose>

          <xsl:when test="starts-with($express_path2,'wr:')">

            <xsl:value-of select="substring-after($express_path2,'wr:')"/>

          </xsl:when>

          <xsl:otherwise>

            <xsl:value-of select="''"/>

          </xsl:otherwise>

        </xsl:choose>

      </xsl:variable>



      <xsl:variable name="ur">

        <xsl:choose>

          <xsl:when test="starts-with($express_path2,'ur:')">

            <xsl:value-of select="substring-after($express_path2,'ur:')"/>

          </xsl:when>

          <xsl:otherwise>

            <xsl:value-of select="''"/>

          </xsl:otherwise>

        </xsl:choose>

      </xsl:variable>







      <xsl:variable name="arm_mim_res"

        select="substring-before(substring-after($nlinkend,':'),':')"/>



      <xsl:variable name="express_file">

        <xsl:choose>

          <xsl:when test="$arm_mim_res='arm'

                          or $arm_mim_res='arm_express'">

            <xsl:value-of select="concat($mod_dir,'/arm.xml')"/>

          </xsl:when>

          <xsl:when test="$arm_mim_res='mim'

                          or $arm_mim_res='mim_express'">

            <xsl:value-of select="concat($mod_dir,'/mim.xml')"/>

          </xsl:when>

          <xsl:when test="$arm_mim_res='mim_lf_express'">

            <xsl:value-of select="concat($mod_dir,'/mim_lf.xml')"/>

          </xsl:when>

          <xsl:when test="$arm_mim_res='arm_lf_express'">

            <xsl:value-of select="concat($mod_dir,'/arm_lf.xml')"/>

          </xsl:when>

          <xsl:when test="$arm_mim_res='ir_express' or $arm_mim_res='ir' or $arm_mim_res='resdoc'">     

            <xsl:value-of select="concat('../data/resources/',$schema,'/',$schema,'.xml')"/>     

          </xsl:when>

          <xsl:when test="$arm_mim_res='reference'">

            <xsl:value-of select="concat('../data/reference/',$schema,'/',$schema,'.xml')"/>

          </xsl:when>

          <xsl:when test="$arm_mim_res='bom'"><!-- BOM -->

            <xsl:value-of select="concat($mod_dir,'/bom.xml')"/>

          </xsl:when>

        </xsl:choose>

      </xsl:variable>



      <xsl:variable name="express_nodes"

        select="document(string($express_file))"/>

      <xsl:choose>

        <xsl:when test="string-length($wr) != 0">

          <xsl:if test="not($express_nodes/express/schema[@name=$schema]/entity[@name=$entity_type]/where[@label=$wr])">

            <xsl:call-template name="error_message">

              <xsl:with-param name="message" 

                select="concat('Error ER-4: The express_ref linkend #', 

                        $linkend, 

                        '# is incorrectly specified. 

                        #The WHERE rule does not exist.

                        #Note linkend is case sensitive.')"/>

            </xsl:call-template>

          </xsl:if>

        </xsl:when>



        <xsl:when test="string-length($ur) != 0">

          <xsl:if test="not($express_nodes/express/schema[@name=$schema]/entity[@name=$entity_type]/unique[@label=$ur])">

            <xsl:call-template name="error_message">

              <xsl:with-param name="message" 

                select="concat('Error ER-5: The express_ref linkend ', 

                        $linkend, 

                        '# is incorrectly specified.# 

                        The UNIQUE rule does not exist.

                        #Note linkend is case sensitive.')"/>

            </xsl:call-template>

          </xsl:if>

        </xsl:when>



        <xsl:when test="string-length($attribute) != 0">

          <xsl:if

            test="not($express_nodes/express/schema[@name=$schema]/entity[@name=$entity_type]/explicit[@name=$attribute]

                  or 

                  $express_nodes/express/schema[@name=$schema]/entity[@name=$entity_type]/inverse[@name=$attribute]

                  or

                  $express_nodes/express/schema[@name=$schema]/entity[@name=$entity_type]/derived[@name=$attribute]

                  or

                  $express_nodes/express/schema[@name=$schema]/type[@name=$entity_type]/enumeration/@items[contains(.,$attribute)]

)">

            <xsl:call-template name="error_message">

              <xsl:with-param name="message" 

                select="concat('Error ER-6: The express_ref linkend# ', 

                        $linkend, 

                        '# is incorrectly specified. 

                        The attribute ', $attribute, ' does not exist.#

                        Note linkend

is case sensitive.')"/>

            </xsl:call-template>

          </xsl:if>

        </xsl:when>





        <xsl:when test="string-length($entity_type) != 0">

          <xsl:if

            test="not(

                  $express_nodes/express/schema[@name=$schema]/constant[@name=$entity_type]

                  or

                  $express_nodes/express/schema[@name=$schema]/type[@name=$entity_type]

                  or

				  $express_nodes/express/schema[@name=$schema]/entity[@name=$entity_type]

                  or 

                  $express_nodes/express/schema[@name=$schema]/subtype.constraint[@name=$entity_type]

                  or

                  $express_nodes/express/schema[@name=$schema]/rule[@name=$entity_type]

                  or 

                  $express_nodes/express/schema[@name=$schema]/function[@name=$entity_type]

                  or

                  $express_nodes/express/schema[@name=$schema]/procedure[@name=$entity_type]

                  )">

            <xsl:call-template name="error_message">

              <xsl:with-param name="message" 

                select="concat('Error ER-7: The express_ref linkend#', 

                              $linkend, 

                              '# is incorrectly specified.# 

                        The data type ', $schema,'.',$entity_type,' does not exist.#Note linkend

is case sensitive.')"/>

            </xsl:call-template>

            

          </xsl:if>



        </xsl:when>



        <xsl:when test="string-length($schema) != 0">

          <xsl:if

            test="not($express_nodes/express/schema[@name=$schema])">

            <xsl:call-template name="error_message">

              <xsl:with-param name="message" 

                select="concat('Error ER-8: The express_ref linkend# ', 

                        $linkend, 

                        '# is incorrectly specified.# 

                        The schema does not exist.

                        #Note linkend

is case sensitive.')"/>

            </xsl:call-template>

          </xsl:if>

        </xsl:when>





        <xsl:otherwise>

            <xsl:call-template name="error_message">

              <xsl:with-param name="message" 

                select="concat('Error ER-9: The express_ref linkend #', 

                        $linkend, 

                        '# is incorrectly specified.')"/>

            </xsl:call-template>          

        </xsl:otherwise>



      </xsl:choose>



    </xsl:when>



    <xsl:otherwise>

      <xsl:call-template name="error_message">

        <xsl:with-param name="message" select="$first_sect"/>
        

      </xsl:call-template>

    </xsl:otherwise>

  </xsl:choose>

</xsl:template>

 

<!-- 

     Return an error message if the linkend of an express_ref is incorrect 

     Just checks the first section i.e module:arm: 

-->

<xsl:template name="check_express_ref_first_section">

  <xsl:param name="linkend"/>

  

  <xsl:variable 

    name="nlinkend"

    select="translate($linkend,'&#x9;&#xA;&#x20;&#xD;','')"/>

  

  <xsl:variable 

    name="module_section" 

    select="substring-before($nlinkend,':')"/>



  <xsl:variable 

    name="resdoc_section" 

    select="substring-before($nlinkend,':')"/>

  

  <!-- BOM -->

  <xsl:variable 

    name="model_section" 

    select="substring-before($nlinkend,':')"/>



  <xsl:variable 

    name="nlinkend1"

    select="substring-before(substring-after($nlinkend,':'),':')"/>





  <xsl:variable name="module_resource_ok">

    <xsl:choose>

      <xsl:when test="$nlinkend1='arm'

                      or $nlinkend1='arm_express'

                      or $nlinkend1='arm_lf_express'

                      or $nlinkend1='mim'

                      or $nlinkend1='mim_express'

                      or $nlinkend1='mim_lf_express'">

        <xsl:call-template name="check_module_exists">

          <xsl:with-param name="module" select="$module_section"/>

        </xsl:call-template>

      </xsl:when>

      <xsl:when test="$nlinkend1='resdoc' or $nlinkend1='ir'">

        <xsl:call-template name="check_resdoc_exists">

          <xsl:with-param name="resdoc" select="$resdoc_section"/>

        </xsl:call-template>

      </xsl:when>

      <xsl:when test="$nlinkend1='ir_express'">

        <xsl:call-template name="check_resource_exists">

          <xsl:with-param name="schema" select="$module_section"/>

        </xsl:call-template>

      </xsl:when>

      <xsl:when test="$nlinkend1='reference'">

<!--        <xsl:call-template name="check_reference_exists">

          <xsl:with-param name="schema" select="$module_section"/>

        </xsl:call-template>  -->

        <xsl:value-of select="'true'"/>

      </xsl:when>

      <!-- BOM -->

      <xsl:when test="$nlinkend1='bom'">

        <xsl:value-of select="'true'"/>

      </xsl:when>

      <xsl:otherwise>

        <xsl:value-of select="'false'"/>

      </xsl:otherwise>

    </xsl:choose>

  </xsl:variable>

  

  

  

  <xsl:variable name="arm_mim_ir_section">

    <xsl:choose>

      <xsl:when test="$nlinkend1='arm'

                      or $nlinkend1='arm_express'

                      or $nlinkend1='arm_lf_express'

                      or $nlinkend1='mim'

                      or $nlinkend1='mim_express'

                      or $nlinkend1='mim_lf_express'

                      or $nlinkend1='ir'

                      or $nlinkend1='ir_express'

                      or $nlinkend1='reference'

                      or $nlinkend1='bom'"><!-- BOM -->

        <xsl:value-of select="$nlinkend1"/>

      </xsl:when>

      <xsl:otherwise>

        <!-- error found, do nothing until linkend_ok variable is set -->

        <xsl:value-of select="''"/>

      </xsl:otherwise>

    </xsl:choose>

  </xsl:variable>

  

  

  <xsl:variable name="linkend_ok">

    <xsl:choose>

      <xsl:when test="$arm_mim_ir_section=''">

        <xsl:value-of select="concat('Error ER-1: The express_ref linkend ', 

                              $linkend, 

                              ' is incorrectly specified. 

                              Need to specify :arm: :arm_express: :mim: :ir_express')"/>

      </xsl:when>

      <xsl:when test="$module_section=''">

        <xsl:value-of select="concat('Error ER-2: express_ref linkend ', 

                              $linkend, 

                              ' is incorrectly specified.

                              Need to specify the module first')"/>

      </xsl:when>

      <xsl:when test="$module_resource_ok!='true'">

        <xsl:value-of select="concat('Error ER-3: express_ref linkend ', 

                              $linkend, 

                              ' is incorrectly specified.', $module_resource_ok)"/>

      </xsl:when>

      <xsl:otherwise>

        <xsl:value-of select="'OK'"/>

      </xsl:otherwise>

    </xsl:choose>

  </xsl:variable>

  <xsl:value-of select="$linkend_ok"/>

</xsl:template>

  



<!-- 

     Return an error message if the linkend of an express_ref is incorrect 

-->

<xsl:template name="check_express_path">

  <xsl:param name="linkend"/>

</xsl:template>





  <!-- 

       Output a menubar at the top of the page.

       The menu bar is defined in a menubar file specified by the parameter 

       menubar_file defined in menubar_params.xsl

       -->

  <xsl:template name="output_menubar">

    <xsl:param name="module_root"/>

    <xsl:param name="module_name"/>

    <!-- overwrites the menubar file defined in menubar_params.xsl -->

    <xsl:param name="new_menubar_file"/>

    <!-- the relative path from XSL directory to stepmod -->

    <xsl:param name="xsl_path" select="'..'"/>



    <xsl:variable name="rel_menubar_file">

      <xsl:choose>

        <xsl:when test="string-length($new_menubar_file)>0">

          <xsl:value-of select="concat($xsl_path,'/',$new_menubar_file)"/>

        </xsl:when>

        <xsl:otherwise>

          <xsl:value-of select="concat($xsl_path,'/',$menubar_file)"/>

        </xsl:otherwise>

      </xsl:choose>

    </xsl:variable>

    <!--    <xsl:message>

      mb:<xsl:value-of select="$rel_menubar_file"/>

    </xsl:message>  -->

    <!-- no idea why I need to force a string here -->

    <xsl:apply-templates

      select="document(string($rel_menubar_file))/menubar">

      <xsl:with-param name="module_root" select="$module_root"/>

      <xsl:with-param name="module_name" select="$module_name"/>

    </xsl:apply-templates>

  </xsl:template>



  <xsl:template match="menubar">

    <xsl:param name="module_root"/>

    <xsl:param name="module_name"/>

    <small>

      <xsl:apply-templates select="menuitem|menubreak|menuspace">

        <xsl:with-param name="module_root" select="$module_root"/>

        <xsl:with-param name="module_name" select="$module_name"/>

    </xsl:apply-templates>

    </small>

  </xsl:template>



  <xsl:template match="menubreak">

    <br/>

  </xsl:template>



  <xsl:template match="menuspace">

    <xsl:value-of select="."/>

  </xsl:template>



  <xsl:template match="menuitem">

    <xsl:param name="module_root"/>

    <xsl:param name="module_name"/>

    <xsl:variable name="url">

      <xsl:choose>

        <xsl:when test="@relative.url">

          <xsl:variable name="relurl">

            <xsl:choose>

              <xsl:when test="starts-with(@relative.url,'..')">

                <xsl:value-of select="concat('/',@relative.url)"/>

              </xsl:when>

              <xsl:otherwise>

                <xsl:value-of select="@relative.url"/>

              </xsl:otherwise>

            </xsl:choose>

          </xsl:variable> <!-- relurl -->



          <xsl:choose>

            <xsl:when test="contains($relurl,'.xml')">

              <xsl:value-of 

                select="concat($module_root,

                        substring-before($relurl,'.xml'),

                        $FILE_EXT,

                        substring-after($relurl,'.xml'))"/>

            </xsl:when>

            <xsl:otherwise>

              <xsl:value-of 

                select="concat($module_root,$relurl)"/>

            </xsl:otherwise>

          </xsl:choose>

        </xsl:when>



        <xsl:when test="@module.url">

          <xsl:variable name="relurl1">

            <xsl:choose>

              <xsl:when test="starts-with(@module.url,'..')">

                <xsl:value-of select="concat('/',@module.url)"/>

              </xsl:when>

              <xsl:otherwise>

                <xsl:value-of select="@module.url"/>

              </xsl:otherwise>

            </xsl:choose>

          </xsl:variable> <!-- relurl -->



          <xsl:variable name="relurl2">

            <xsl:choose>

              <xsl:when test="contains($relurl1,'.xml')">

                <xsl:value-of 

                  select="concat($module_root,

                          substring-before($relurl1,'.xml'),

                          $FILE_EXT,

                          substring-after($relurl1,'.xml'))"/>

              </xsl:when>

              <xsl:otherwise>

                <xsl:value-of 

                  select="concat($module_root,$relurl1)"/>

              </xsl:otherwise>

            </xsl:choose>

          </xsl:variable> <!-- relurl2 -->



          <xsl:value-of select="concat(

                                substring-before($relurl2, '{' ),

                                $module_name,

                                substring-after($relurl2, '}' ) )"/>

        </xsl:when>



        <xsl:when test="@absolute.url">

          <xsl:value-of select="@absolute.url"/>

        </xsl:when>

        <xsl:otherwise>

          ERROR

        </xsl:otherwise>

      </xsl:choose>

    </xsl:variable> <!-- url -->





    <xsl:choose>

      <xsl:when test="contains($url,'ERROR')">

        <xsl:call-template name="error_message">

          <xsl:with-param

            name="message"

            select="concat('ERROR mb1: The menubar #',

                    $menubar_file ,' must contain a path.')"/>

        </xsl:call-template>

      </xsl:when>

      

      <xsl:when test="@img">

        <xsl:variable name="item" select="@item"/>

        <xsl:variable name="img">

          <xsl:choose>

            <xsl:when test="starts-with(@img,'..')">

              <xsl:value-of select="concat($module_root,'/',@img)"/>

            </xsl:when>

            <xsl:otherwise>

              <xsl:value-of select="concat($module_root,@img)"/>

            </xsl:otherwise>

          </xsl:choose>

        </xsl:variable>

        <a href="{$url}">

          <img alt="{$item}" border="0" align="middle" src="{$img}"/>

        </a>

      </xsl:when>



      <xsl:otherwise>

        <a href="{$url}">

          <xsl:value-of select="@item"/>

        </a>

      </xsl:otherwise>

    </xsl:choose>



    <xsl:choose>

      <xsl:when test="string-length(@img)!= 0">

        &#160;&#160;&#160;

      </xsl:when>

      <xsl:when test="position() != last()">

        &#160;&#124;&#160;        

      </xsl:when>

    </xsl:choose>

  </xsl:template>



  <!-- check the schema name starts with Upper case and rest is lower case

       the schema ends in _arm or _mim -->



<xsl:template name="check_schema_name">

    <xsl:param name="arm_mim_schema"/>

    <xsl:param name="schema_name"/>

        <xsl:variable name="_arm_mim_schema">

	  <xsl:choose>

	    <xsl:when test="not($arm_mim_schema='aic')">

	      <xsl:value-of select="concat('_',$arm_mim_schema)"/>

	    </xsl:when>

	    <xsl:when test="$arm_mim_schema='aic'">

	      <xsl:value-of select="concat($arm_mim_schema,'_')"/>

	    </xsl:when>

	  </xsl:choose>

	</xsl:variable>

    <!-- check that the schema name ends in _arm or _mim or _schema or starts with aic_ -->

    <xsl:if 

      test="substring($schema_name, string-length($schema_name)- string-length($arm_mim_schema)) != $_arm_mim_schema  and  substring($schema_name,1 ,string-length($_arm_mim_schema)) != $_arm_mim_schema">

      <xsl:call-template name="error_message">

        <xsl:with-param 

          name="message" 

          select="concat('Error q1: ',$arm_mim_schema,' schema ',$schema_name,' must start or end in', $_arm_mim_schema)"/>

      </xsl:call-template>

    </xsl:if>



    <!-- check that the schema name starts with Uppercase and rest is

         lower case -->

    <xsl:variable name="test">

      <xsl:call-template name="check_upper_lower_case">

        <xsl:with-param name="str" select="$schema_name"/>

        <xsl:with-param name="arm_mim_schema" select="$arm_mim_schema"/>

      </xsl:call-template>

    </xsl:variable>

    <xsl:if test="$test = -1">

      <xsl:call-template name="error_message">

        <xsl:with-param 

          name="message" 

          select="concat('Error q2: ',$arm_mim_schema,' schema ',$schema_name,' incorrectly

                  named. First letter must uppercase, rest is lower case')"/>

      </xsl:call-template>    

    </xsl:if>

  </xsl:template>





  <!-- return 1 if the first letter in the string is Upper case and all the

       rest are lower case -->



  <xsl:template name="check_upper_lower_case">

    <xsl:param name="str"/>

    <xsl:param name="arm_mim_schema"/>

    <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'"/>

    <xsl:choose>

      <xsl:when test="$arm_mim_schema='schema' or $arm_mim_schema='aic' " >

        <xsl:call-template name="check_all_lower_case">

          <xsl:with-param name="str" select="$str"/>

        </xsl:call-template>

      </xsl:when>

      <xsl:otherwise>

          <xsl:choose>

            <xsl:when test="contains($UPPER,substring($str,1,1))">

              <xsl:call-template name="check_all_lower_case">

          <xsl:with-param name="str" select="substring($str,2)"/>

        </xsl:call-template>

      </xsl:when>

      <xsl:otherwise>

        <!-- failed -->

        -1

      </xsl:otherwise>

          </xsl:choose>

    </xsl:otherwise>

  </xsl:choose>

  </xsl:template>





  <!-- check the entity name starts with Upper case and rest is lower case -->

  <xsl:template name="check_arm_entity_name">

    <xsl:param name="entity_name"/>

    <xsl:variable name="test">

      <xsl:call-template name="check_upper_lower_case">

        <xsl:with-param name="str" select="$entity_name"/>

      </xsl:call-template>

    </xsl:variable>

    <xsl:if test="$test = -1">

      <xsl:call-template name="error_message">

        <xsl:with-param 

          name="message" 

          select="concat('Error q3: the entity ',$entity_name,' incorrectly

                  named.#First letter must uppercase, rest is lower case')"/>

      </xsl:call-template>    

    </xsl:if>

  </xsl:template>





  <!-- check that the type name is all lower case -->

  <xsl:template name="check_type_name">

    <xsl:param name="type_name"/>

    <xsl:variable name="test">

      <xsl:call-template name="check_all_lower_case">

        <xsl:with-param name="str" select="$type_name"/>

      </xsl:call-template>

    </xsl:variable>

    <xsl:if test="$test = -1">

      <xsl:call-template name="error_message">

        <xsl:with-param 

          name="message" 

          select="concat('Error q4: the type ',$type_name,' incorrectly

                  named.#Should be all lower case')"/>

      </xsl:call-template>    

    </xsl:if>

  </xsl:template>



  <!-- check that the mim entity name is all lower case -->

  <xsl:template name="check_mim_entity_name">

    <xsl:param name="entity_name"/>

    <xsl:variable name="test">

      <xsl:call-template name="check_all_lower_case">

        <xsl:with-param name="str" select="$entity_name"/>

      </xsl:call-template>

    </xsl:variable>

    <xsl:if test="$test = -1">

      <xsl:call-template name="error_message">

        <xsl:with-param 

          name="message" 

          select="concat('Error q5: the entity ',$entity_name,' incorrectly

                  named.# Should be all lower case.')"/>

      </xsl:call-template>    

    </xsl:if>

  </xsl:template>







  <!-- return 1 if all the letters in string are lower case -->

  <xsl:template name="check_all_lower_case">

    <xsl:param name="str"/>

    <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_0123456789'"/>

    <xsl:variable name="first" select="substring($str,1,1)"/>

    <xsl:variable name="rest" select="substring($str,2)"/>

    <xsl:choose>

      <xsl:when test="contains($LOWER,$first)">

        <xsl:choose>

          <xsl:when test="$rest">

            <xsl:call-template name="check_all_lower_case">

              <xsl:with-param name="str" select="$rest"/>

            </xsl:call-template>

          </xsl:when>

          <xsl:otherwise>

            <!-- tested all the string -->

            1 

          </xsl:otherwise>

        </xsl:choose>

      </xsl:when>

      <xsl:otherwise>

        -1

      </xsl:otherwise>

    </xsl:choose>

  </xsl:template>



  <!-- return the HREF to a table -->

  <xsl:template name="table_href">

    <xsl:param name="table" select="."/>



    <xsl:variable name="file">

      <xsl:call-template name="in_file">

        <xsl:with-param name="table_fig_node" select="$table"/>

      </xsl:call-template>

    </xsl:variable>



    <xsl:variable name="aname">

      <xsl:call-template name="table_aname"/>

    </xsl:variable>

    <xsl:value-of select="concat($file,'#',$aname)"/>

  </xsl:template>





  <!-- Return the A name with which a TABLE or FIGURE will tagged -->

  <xsl:template name="table_aname">

    <xsl:param name="table" select="."/>

    <xsl:param name="number" select="./@number"/>

    <xsl:param name="id" select="./@id"/>



    <xsl:variable name="aname">

      <xsl:choose>

        <xsl:when test="$id">

          <xsl:value-of select="concat(name($table),'_',$id)"/>

        </xsl:when>

        <xsl:otherwise>          

          <xsl:value-of select="concat(name($table),'_',$number)"/>

        </xsl:otherwise>

      </xsl:choose>

    </xsl:variable>

    <xsl:value-of select="$aname"/>   

  </xsl:template>





  <!-- return the file that any table or figure XML element is in -->

  <xsl:template name="in_file">

    <xsl:param name="table_fig_node"/>



    <xsl:choose>

      <xsl:when test="$table_fig_node/ancestor::purpose[1]">

        <xsl:value-of select="concat('introduction',$FILE_EXT)"/>

      </xsl:when>

      <xsl:when test="$table_fig_node/ancestor::scope[1]">

        <xsl:value-of select="concat('scope',$FILE_EXT)"/>

      </xsl:when>

      <xsl:when test="$table_fig_node/ancestor::inscope[1]|$table_fig_node/ancestor::outscope[1]">

        <xsl:value-of select="concat('1_scope',$FILE_EXT)"/>

      </xsl:when>

      <xsl:when test="$table_fig_node/ancestor::ext_descriptions[1][@schema_file='arm.xml']">

        <xsl:value-of select="concat('4_info_reqs',$FILE_EXT)"/>

      </xsl:when>



      <xsl:when test="$table_fig_node/ancestor::schema">

        <xsl:variable name="schema" select="$table_fig_node/ancestor::schema/@name"/>

        <xsl:choose>

          <xsl:when test="substring($schema,string-length($schema)-3)='_arm'">

            <xsl:value-of select="concat('4_info_reqs',$FILE_EXT)"/>

          </xsl:when>

          <xsl:when test="substring($schema,string-length($schema)-3)='_mim'">

            <xsl:value-of select="concat('5_mim',$FILE_EXT)"/>

          </xsl:when>

          <xsl:when test="substring($schema,string-length($schema)-6)='_schema'">

            <xsl:value-of select="concat(count($table_fig_node/ancestor::schema/preceding-sibling::schema)+4,'_schema',$FILE_EXT)"/>

          </xsl:when>

          <xsl:otherwise>

			<xsl:value-of select="concat('',$FILE_EXT)"/>

          </xsl:otherwise>

        </xsl:choose>

      </xsl:when>



      <xsl:when test="$table_fig_node/ancestor::ext_descriptions[1][@schema_file='mim.xml']">

        <xsl:value-of select="concat('5_mim',$FILE_EXT)"/>

      </xsl:when>

			

      <xsl:when test="$table_fig_node/ancestor::refdata[1]">

        <xsl:value-of select="concat('6_refdata',$FILE_EXT)"/>

      </xsl:when>



			

      <xsl:when test="$table_fig_node/ancestor::usage_guide[1]">

        <xsl:value-of select="concat('f_guide',$FILE_EXT)"/>

      </xsl:when>



      <xsl:when test="$table_fig_node/ancestor::tech_discussion[1]">

        <xsl:value-of select="concat('tech_discussion',$FILE_EXT)"/>

      </xsl:when>



      <xsl:when test="$table_fig_node/ancestor::examples[1]">

        <xsl:value-of select="concat('examples',$FILE_EXT)"/>

      </xsl:when>



      <xsl:when test="$table_fig_node/ancestor::add_scope[1]">

        <xsl:value-of select="concat('add_scope',$FILE_EXT)"/>

      </xsl:when>



    </xsl:choose>

  </xsl:template>





  <!-- display the expressg Icon for an express construct -->

  <!-- Note replaced with code in expressg_icon.xsl -->

  <xsl:template match="entity|type|schema|constant|subtype.constraint" mode="expressg_icon">

    <!-- the entity may be being referenced from another module

         in which case the schema needs to be explicit.

         This only happens in the mapping tables when and ARM object is

         being remapped from another module. -->

    <xsl:param name="original_schema"/>

    <xsl:variable name="schema">

      <xsl:choose>

        <!-- original_module specified then the ARM object is declared in

             another module -->

        <xsl:when test="$original_schema">

          <xsl:value-of select="$original_schema"/>

        </xsl:when>

        <xsl:otherwise>

          <xsl:value-of select="../@name"/>

        </xsl:otherwise>

      </xsl:choose>

    </xsl:variable>



    <xsl:variable name="module_dir">

      <xsl:call-template name="module_directory">

        <xsl:with-param name="module" select="$schema"/>

      </xsl:call-template>

    </xsl:variable>



    <xsl:variable name="module_name">

      <xsl:call-template name="module_name">

        <xsl:with-param name="module" select="$schema"/>

      </xsl:call-template>

    </xsl:variable>

    

    <xsl:variable name="model_name">

      <xsl:call-template name="model_name2">

        <xsl:with-param name="model_param" select="$schema"/>

      </xsl:call-template>

    </xsl:variable>



    <xsl:variable name="href_expg">

      <xsl:choose>

        <xsl:when test="substring($schema,string-length($schema)-3)='_arm'">

          <xsl:choose>

            <xsl:when test="./graphic.element/@page">

              <xsl:value-of select="concat('../../',$module_name,'/armexpg',./graphic.element/@page,$FILE_EXT)"/>                  

            </xsl:when>

            <xsl:otherwise>

              <xsl:value-of select="concat('../../',$module_name,'/armexpg1',$FILE_EXT)"/>

            </xsl:otherwise>

          </xsl:choose>   

        </xsl:when>

        

        <xsl:when test="substring($schema, string-length($schema)-3)='_bom'">

          <xsl:choose>

            <xsl:when test="./graphic.element/@page">

              <xsl:value-of select="concat('../../',$model_name,'/bomexpg',./graphic.element/@page,$FILE_EXT)"/>

            </xsl:when>

            <xsl:otherwise>

              <xsl:value-of select="concat('../../',$model_name,'/bomexpg1',$FILE_EXT)"/>

            </xsl:otherwise>

          </xsl:choose>

        </xsl:when>

        

        

        <xsl:when test="substring($schema, string-length($schema)-3)='_mim'">

          <xsl:choose>

            <xsl:when test="./graphic.element/@page">

              <xsl:value-of select="concat('../../',$module_name,'/mimexpg',./graphic.element/@page,$FILE_EXT)"/>

            </xsl:when>

            <xsl:otherwise>

              <xsl:value-of select="concat('../../',$module_name,'/mimexpg1',$FILE_EXT)"/>

            </xsl:otherwise>

          </xsl:choose>

        </xsl:when>

      </xsl:choose>

    </xsl:variable>



    &#160;&#160;<a href="{$href_expg}">

      <img align="middle" border="0" 

        alt="EXPRESS-G" src="../../../../images/expg.gif"/>

    </a>



  </xsl:template>





  <!-- Note replaced with code in expressg_icon.xsl -->

  <xsl:template name="expressg_icon">

    <xsl:param name="schema"/>

    <xsl:param name="entity"/>

    <xsl:param name="module_root" select="'..'"/>

    <xsl:variable name="module_dir">

      <xsl:call-template name="module_directory">

        <xsl:with-param name="module" select="$schema"/>

      </xsl:call-template>

    </xsl:variable>  



    <xsl:variable name="href_expg">

      <xsl:choose>

        <xsl:when test="$entity">

          <xsl:choose>

            <xsl:when test="substring($schema,string-length($schema)-3)='_arm'">

              <xsl:choose>

                <xsl:when test="./graphic.element/@page">

                  <xsl:value-of select="concat('../armexpg',./graphic.element/@page,$FILE_EXT)"/>                  

                </xsl:when>

                <xsl:otherwise>

                  <xsl:value-of select="concat('../armexpg1',$FILE_EXT)"/>

                </xsl:otherwise>

              </xsl:choose>



            </xsl:when>

            <xsl:when test="substring($schema, string-length($schema)-3)='_mim'">

              <xsl:choose>

                <xsl:when test="./graphic.element/@page">

                  <xsl:value-of select="concat('../mimexpg',./graphic.element/@page,$FILE_EXT)"/>

                </xsl:when>

                <xsl:otherwise>

                  <xsl:value-of select="concat('../mimexpg1',$FILE_EXT)"/>

                </xsl:otherwise>

              </xsl:choose>



            </xsl:when>      

          </xsl:choose>

        </xsl:when>

        

        <xsl:otherwise>

          <xsl:choose>

            <xsl:when test="substring($schema, string-length($schema)-3)='_arm'">

              <xsl:value-of select="concat($module_root,'/armexpg1',$FILE_EXT)"/>

            </xsl:when>

            <xsl:when test="substring($schema, string-length($schema)-3)='_mim'">

              <xsl:value-of select="concat($module_root,'/mimexpg1',$FILE_EXT)"/>

            </xsl:when>      

          </xsl:choose>        

        </xsl:otherwise>

      </xsl:choose>

    </xsl:variable>

    &#160;&#160;<a href="{$href_expg}">

      <img align="middle" border="0" 

        alt="EXPRESS-G" src="{$module_root}/../../../images/expg.gif"/>

    </a>



  </xsl:template>



  <!-- given a string, output the string with line breaks after the specified

       character (break_char) that occurs immediately before a specified

       number of characters (length).

       If replace_break_char = true then replace the break-char with <br/>

       otherwise the break char is output.

       -->

  <xsl:template name="output_line_breaks">

    <xsl:param name="str"/>

    <xsl:param name="break_char"/>

    <xsl:param name="replace_break_char" select="'false'"/>

    <xsl:param name="indent" select="''"/>

    <xsl:choose>

      <xsl:when test="contains($str,$break_char)">

        <xsl:variable name="substr" 

          select="substring-before($str,$break_char)"/>

        <xsl:choose>

          <xsl:when test="$replace_break_char != 'false'">

            <xsl:value-of select="concat($indent,$substr)"/><br/>

          </xsl:when>

          <xsl:otherwise>

            <xsl:value-of select="concat($indent,$substr,$break_char)"/><br/>

          </xsl:otherwise>

        </xsl:choose>

        <xsl:call-template name="output_line_breaks">

          <xsl:with-param name="str" select="substring-after($str,$break_char)"/>

          <xsl:with-param name="break_char" select="$break_char"/>

          <xsl:with-param name="replace_break_char" select="$replace_break_char"/>

          <xsl:with-param name="indent" select="'&#160;&#160;&#160;&#160;'"/>

        </xsl:call-template> 

      </xsl:when>

      <xsl:otherwise>

        <xsl:value-of select="concat($indent,$str)"/>

      </xsl:otherwise>        

    </xsl:choose>

  </xsl:template>







  <!--

       Given a string, return the substring immediately before the last 

       specified character (char) )

       e.g.       

       get_string_before("1,2,3,4,5",",") returns 1,2,3,4

       -->

  <xsl:template name="get_string_before">

    <xsl:param name="str"/>

    <xsl:param name="char"/>

    <xsl:param name="previous_str" select="''"/>

    <xsl:variable name="first" select="substring-before($str,$char)"/>

    <xsl:variable name="rest" select="substring-after($str,$char)"/>

    <xsl:variable name="prev">

      <xsl:choose>

        <xsl:when test="$previous_str=''">

          <xsl:value-of select="$first"/>

        </xsl:when>

        <xsl:otherwise>

          <xsl:value-of select="concat($previous_str,$char,$first)"/>

        </xsl:otherwise>

      </xsl:choose>

    </xsl:variable>



    <xsl:choose>

      <xsl:when test="$first='' and $previous_str=''">

        <!-- string does not contain char -->

        <xsl:value-of select="$str"/>

      </xsl:when>

      <xsl:when test="contains($rest,$char)">

        <!-- still a char in the string so recurse -->

        <xsl:call-template name="get_string_before">

          <xsl:with-param name="str" select="substring-after($str,$char)"/>

          <xsl:with-param name="char" select="$char"/>

          <xsl:with-param name="previous_str" select="$prev"/>

        </xsl:call-template>

      </xsl:when>

      <xsl:otherwise>

        <!-- rest of the string does not contain a char so stop -->

        <xsl:value-of select="$prev"/>

      </xsl:otherwise>

    </xsl:choose>

  </xsl:template>



  <!-- given a string, return the opening paren at the start -->

  <xsl:template name="get_open_paren">

    <xsl:param name="str"/>

    <xsl:param name="previous_str" select="''"/>



    <xsl:variable name="nstr" 

      select="translate(normalize-space($str),' ','')"/>

    <xsl:choose>

      <xsl:when test="substring($nstr,1,1)='('">

        <xsl:variable name="prev" 

          select="concat($previous_str,'(')"/>

        <xsl:call-template name="get_open_paren">

          <xsl:with-param name="str" select="substring-after($nstr,'(')"/>

          <xsl:with-param name="previous_str" select="$prev"/>

        </xsl:call-template>

      </xsl:when>

      <xsl:otherwise>

        <xsl:value-of select="$previous_str"/>

      </xsl:otherwise>

    </xsl:choose>

  </xsl:template>



  <xsl:template name="first_uppercase">

    <xsl:param name="string"/>

    <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

    <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>

    <xsl:variable name="first_char" 

      select="translate(substring($string,1,1),$LOWER,$UPPER)"/>

    <xsl:value-of 

      select="concat($first_char,

              translate(substring($string,2),$UPPER,$LOWER))"/>

  </xsl:template>



  <!-- generate a string of length no_chars mad up of chars -->

  <xsl:template name="string_n_chars">

    <xsl:param name="char"/>

    <xsl:param name="no_chars"/>

    <xsl:param name="str" select="''"/>

    <xsl:choose>

      <xsl:when test="$no_chars>0">

        <xsl:call-template name="string_n_chars">

          <xsl:with-param name="char" select="$char"/>

          <xsl:with-param name="no_chars" select="$no_chars - 1"/>

          <xsl:with-param name="str" select="concat($str,$char)"/>

        </xsl:call-template>

      </xsl:when>

      <xsl:otherwise>

        <xsl:value-of select="$str"/>

      </xsl:otherwise>

    </xsl:choose>

  </xsl:template>





  <!-- given a string, return the first word, where any non ALPHA character 

       is a word space-->

  <xsl:template name="get_word">

    <xsl:param name="str"/>



    <xsl:variable name="nstr" 

      select="translate(normalize-space($str),

              '[](){}+=-,; ',

              '************')"/>

    <!-- if string starts with * there is some leading white space -->

    <xsl:choose>

      <xsl:when test="substring($nstr,1,1)='*'">

        <xsl:call-template name="get_word">

          <xsl:with-param name="str" select="substring-after($nstr,'*')"/>

        </xsl:call-template>

      </xsl:when>

      <xsl:otherwise>

        <xsl:value-of select="substring-before($nstr,'*')"/>

      </xsl:otherwise>

    </xsl:choose>

  </xsl:template>





  <!-- given a string, delete the first word, and return the rest of the

       string where any non ALPHA character is a word space-->

  <xsl:template name="get_after_word">

    <xsl:param name="str"/>

    <xsl:variable name="word">

      <xsl:call-template name="get_word">

        <xsl:with-param name="str" select="$str"/>

      </xsl:call-template>

    </xsl:variable>

    <xsl:value-of select="substring-after($str,$word)"/>

  </xsl:template>



  <!-- given a string, return all non ALPHA character upto first ALPH

       character -->

  <xsl:template name="get_before_word">

    <xsl:param name="str"/>

    <xsl:variable name="word">

      <xsl:call-template name="get_word">

        <xsl:with-param name="str" select="$str"/>

      </xsl:call-template>

    </xsl:variable>

    <xsl:value-of select="substring-before($str,$word)"/>

  </xsl:template>



<xsl:template match="projlead">

  <xsl:variable name="ref" select="@ref"/>

  <xsl:variable name="projlead"

    select="document('../data/basic/contacts.xml')/contact.list/contact[@id=$ref]"/>

  <b>Project leader: </b>

  <xsl:choose>

    <xsl:when test="$projlead">

      <xsl:apply-templates select="$projlead"/>      

    </xsl:when>

    <xsl:otherwise>

      <xsl:call-template name="error_message">

        <xsl:with-param name="message">

          Error 1: No contact provided for project leader.

        </xsl:with-param>

      </xsl:call-template>

    </xsl:otherwise>

  </xsl:choose>

</xsl:template>



<xsl:template match="projlead" mode="no_address">

  <xsl:variable name="ref" select="@ref"/>

  <xsl:variable name="projlead"

    select="document('../data/basic/contacts.xml')/contact.list/contact[@id=$ref]"/>

  <xsl:choose>

    <xsl:when test="$projlead">

      <xsl:apply-templates select="$projlead" mode="no_address"/>      

    </xsl:when>

    <xsl:otherwise>

      <xsl:call-template name="error_message">

        <xsl:with-param name="message">

          Error 1: No contact provided for project leader.

        </xsl:with-param>

      </xsl:call-template>

    </xsl:otherwise>

  </xsl:choose>

</xsl:template>



<xsl:template match="projlead" mode="name">

  <xsl:variable name="ref" select="@ref"/>

  <xsl:variable name="projlead"

    select="document('../data/basic/contacts.xml')/contact.list/contact[@id=$ref]"/>

  <xsl:choose>

    <xsl:when test="$projlead">

      <xsl:apply-templates select="$projlead" mode="name"/>      

    </xsl:when>

    <xsl:otherwise>

      <xsl:call-template name="error_message">

        <xsl:with-param name="message">

          Error 1: No contact provided for project leader.

        </xsl:with-param>

      </xsl:call-template>

    </xsl:otherwise>

  </xsl:choose>

</xsl:template>



<xsl:template match="editor">

  <xsl:variable name="ref" select="@ref"/>

  <xsl:variable name="editor"

    select="document('../data/basic/contacts.xml')/contact.list/contact[@id=$ref]"/>

  <b>Project editor: </b>

  <xsl:choose>

    <xsl:when test="$editor">

      <xsl:apply-templates select="$editor"/>      

    </xsl:when>

    <xsl:otherwise>

      <xsl:call-template name="error_message">

        <xsl:with-param name="message">

          Error 2: No contact provided for project editor.

        </xsl:with-param>

      </xsl:call-template>

    </xsl:otherwise>

  </xsl:choose>

</xsl:template>





<xsl:template match="editor" mode="no_address">

  <xsl:variable name="ref" select="@ref"/>

  <xsl:variable name="editor"

    select="document('../data/basic/contacts.xml')/contact.list/contact[@id=$ref]"/>

  <xsl:choose>

    <xsl:when test="$editor">

      <xsl:apply-templates select="$editor"  mode="no_address"/>      

    </xsl:when>

    <xsl:otherwise>

      <xsl:call-template name="error_message">

        <xsl:with-param name="message">

          Error 2: No contact provided for project editor.

        </xsl:with-param>

      </xsl:call-template>

    </xsl:otherwise>

  </xsl:choose>

</xsl:template>



<xsl:template match="editor" mode="name">

  <xsl:variable name="ref" select="@ref"/>

  <xsl:variable name="editor"

    select="document('../data/basic/contacts.xml')/contact.list/contact[@id=$ref]"/>

  <xsl:choose>

    <xsl:when test="$editor">

      <xsl:apply-templates select="$editor"  mode="name"/>      

    </xsl:when>

    <xsl:otherwise>

      <xsl:call-template name="error_message">

        <xsl:with-param name="message">

          Error 2: No contact provided for project editor.

        </xsl:with-param>

      </xsl:call-template>

    </xsl:otherwise>

  </xsl:choose>

</xsl:template>





<xsl:template match="developer" mode="name">

  <xsl:variable name="ref" select="@ref"/>

  <xsl:variable name="developer"

    select="document('../data/basic/contacts.xml')/contact.list/contact[@id=$ref]"/>

  <xsl:choose>

    <xsl:when test="$developer">

      <xsl:apply-templates select="$developer" mode="name"/>      

    </xsl:when>

    <xsl:otherwise>

      <xsl:call-template name="error_message">

        <xsl:with-param name="message">

          Error 1: No contact provided for developer.

        </xsl:with-param>

      </xsl:call-template>

    </xsl:otherwise>

  </xsl:choose>

</xsl:template>





<xsl:template match="contact">

  <xsl:apply-templates select="firstname"/>

  &#160;

  <xsl:apply-templates select="lastname"/>

  <br/>

  <xsl:apply-templates select="." mode="address"/>

  <br/>

  <xsl:apply-templates select="phone"/>

  <xsl:apply-templates select="fax"/>

  <xsl:apply-templates select="email"/>

</xsl:template>





<xsl:template match="contact" mode="no_address">

  <xsl:apply-templates select="firstname"/>

  &#160;

  <xsl:apply-templates select="lastname"/>

  <br/>

  <xsl:apply-templates select="phone"/>

  <xsl:apply-templates select="email"/>

</xsl:template>



<xsl:template match="contact" mode="name">

  <xsl:apply-templates select="firstname"/>

  &#160;

  <xsl:apply-templates select="lastname"/>

</xsl:template>





<xsl:template match="firstname | lastname">

  <xsl:value-of select="."/>

</xsl:template>



<xsl:template match="contact" mode="address">

  <b>Address: </b>

  <xsl:apply-templates select="./affiliation"/>

  <xsl:apply-templates select="./street"/>

  <xsl:apply-templates select="./pobox"/>

  <xsl:apply-templates select="./city"/>

  <xsl:apply-templates select="./state"/>

  <xsl:apply-templates select="./postcode"/>

  <xsl:apply-templates select="./country"/>

</xsl:template>





<xsl:template match="affiliation">

  <xsl:value-of select="."/> <br/>

</xsl:template>



<xsl:template match="street">

  <xsl:value-of select="."/> <br/>

</xsl:template>



<xsl:template match="pobox">

  <xsl:value-of select="."/> <br/>

</xsl:template>



<xsl:template match="city">

  <xsl:value-of select="."/> <br/>

</xsl:template>



<xsl:template match="state">

  <xsl:value-of select="."/> <br/>

</xsl:template>



<xsl:template match="postcode">

  <xsl:value-of select="."/> <br/>

</xsl:template>



<xsl:template match="country">

  <xsl:value-of select="."/> <br/>

</xsl:template>



<xsl:template match="phone">

  <b>Telephone: </b>

  <xsl:value-of select="."/>

  <br/>

</xsl:template>



<xsl:template match="fax">

  <b>Telefacsimile: </b>

  <xsl:value-of select="."/>

  <br/>

</xsl:template>



<xsl:template match="email">

  <xsl:variable name="mailto" select="concat('mailto:',.)"/>

  <b>Electronic mail: </b>

  <a href="{$mailto}">

    <xsl:value-of select="."/>

  </a>

  <br/>

</xsl:template>





<!-- given a space separated list, return an alphabetically sorted list -->

<xsl:template name="sort_list">

  <xsl:param name="list"/>



  <xsl:variable name="nodes">

    <xsl:call-template name="list_to_nodes">

      <xsl:with-param name="string" select="$list"/>

    </xsl:call-template>

  </xsl:variable>



  <xsl:variable name="sorted">

    <xsl:choose>

      <xsl:when test="function-available('msxsl:node-set')">

        <xsl:variable name="nodes_set" select="msxsl:node-set($nodes)"/>

        <xsl:for-each select="$nodes_set//x">

          <xsl:sort/>

          <xsl:value-of select="concat(' ',.,' ')"/>

        </xsl:for-each>

      </xsl:when>

      <xsl:when test="function-available('exslt:node-set')">

        <xsl:variable name="nodes_set" select="exslt:node-set($nodes)"/>

        <xsl:for-each select="$nodes_set//x">

          <xsl:sort/>

          <xsl:value-of select="concat(' ',.,' ')"/>

        </xsl:for-each>

      </xsl:when>

    </xsl:choose>

  </xsl:variable>

  <xsl:value-of select="normalize-space($sorted)"/>

</xsl:template>



<!-- used by sort_list to convert a space separated list into a list of

     nodes -->

<xsl:template name="list_to_nodes">

  <xsl:param name="string"/>

  <xsl:variable name="nstring" select="normalize-space($string)"/>

  <xsl:choose>

    <xsl:when test="contains($nstring,' ')">

      <xsl:variable

        name="first"

        select="substring-before($nstring,' ')"/>

      <xsl:variable

        name="rest"

        select="substring-after($nstring,' ')"/>

      

      <x><xsl:value-of select="$first"/></x>

      <xsl:call-template name="list_to_nodes">

        <xsl:with-param name="string" select="$rest"/>

      </xsl:call-template>

    </xsl:when>

    <xsl:otherwise>

      <x><xsl:value-of select="$nstring"/></x>

    </xsl:otherwise>

  </xsl:choose>  

</xsl:template>



  <!-- Flag a warning if the defnition starts with a an the

    A phrase should NOT end in a period -->

  <xsl:template match="def" mode="check_phrase">

    <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

    <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>

    <xsl:variable name="defn" select="translate(normalize-space(text()), $LOWER, $UPPER)"/>   

    

    <xsl:if test="substring($defn,string-length($defn))='.'">

      <xsl:call-template name="error_message">

        <xsl:with-param 

          name="message" 

          select="'Error defn1: definition should be a phrase and so should not end in a period.'"/>

      </xsl:call-template>

    </xsl:if>

    <xsl:choose>

      <xsl:when test="starts-with($defn, 'A ')">        

        <xsl:call-template name="error_message">

          <xsl:with-param 

            name="message" 

            select="concat('Error defn2, module: ',/*/@name,' - definition should not start with an article i.e A or a.')"/>

        </xsl:call-template>

      </xsl:when>

      <xsl:when test="starts-with($defn, 'AN ')">        

        <xsl:call-template name="error_message">

          <xsl:with-param 

            name="message" 

            select="concat('Error defn2, module: ',/*/@name,' - definition should not start with an article i.e An or an.')"/>

        </xsl:call-template>

      </xsl:when>

      <xsl:when test="starts-with($defn, 'THE ')">        

        <xsl:call-template name="error_message">

          <xsl:with-param 

            name="message" 

            select="concat('Error defn2, module: ',/*/@name,' - definition should not start with an article i.e The or the.')"/>

        </xsl:call-template>

      </xsl:when>

    </xsl:choose>

  </xsl:template>

  



<!-- Flag a warning if the description is not a phrase.

     A phrase should NOT end in a period -->

<xsl:template match="description" mode="check_phrase">

  <xsl:variable name="defn" select="normalize-space(text())"/>

  <xsl:if test="substring($defn,string-length($defn))='.'">

    <xsl:call-template name="error_message">

      <xsl:with-param 

        name="message" 

        select="'Error defn1: definition should be a phrase and so should not end in a period.'"/>

    </xsl:call-template>

  </xsl:if>

</xsl:template>



<xsl:template name="no_node_set">

        Currently configured to support  SAXON, IE 6.0  or later,  and MSXSL XSLT parsers.	Your parser is from <xsl:element name="a">

<xsl:attribute name="href"><xsl:value-of select="system-property('xsl:vendor-url')"/></xsl:attribute>

<xsl:value-of select="system-property('xsl:vendor')"/> 

</xsl:element> and supports xslt version &#x22;<xsl:value-of select="system-property('xsl:version')"/>&#x22; 



</xsl:template>





<xsl:template match="resource" mode="type">

  <xsl:choose>

	<xsl:when test="@part >  500">

	  Application interpreted construct</xsl:when>

	<xsl:when test="@part >  99">

	  Integrated application resource</xsl:when>

	<xsl:when test="@part &lt;  99">

	  Integrated generic resource</xsl:when>

	<xsl:otherwise>

	  <xsl:call-template name="error_message">

		<xsl:with-param 

			name="message" 

			select="concat('Error : unknown type,  part number:', @part)"/>

	  </xsl:call-template>

	</xsl:otherwise>

  </xsl:choose>

</xsl:template>



<xsl:template match="resource" mode="display_french_doctype">

  <xsl:variable name="doctype">

    <xsl:apply-templates select="." mode="doctype"/>

  </xsl:variable>

  <xsl:choose>

	<xsl:when test="$doctype='aic'">

	  Construction interpr&#233;t&#233;e d'application</xsl:when>

	<xsl:when test="$doctype='iar'">

	  Ressources d'application int&#233;gr&#233;es</xsl:when>

	<xsl:when test="$doctype='igr'">

	  Ressources g&#233;n&#233;riques int&#233;gr&#233;es</xsl:when>

	<xsl:otherwise>

	  <xsl:call-template name="error_message">

		<xsl:with-param 

			name="message" 

			select="concat('Error : unknown type: ', $doctype)"/>

	  </xsl:call-template>

	</xsl:otherwise>

  </xsl:choose>

</xsl:template>



<xsl:template match="resource" mode="display_doctype">

  <xsl:variable name="doctype">

    <xsl:apply-templates select="." mode="doctype"/>

  </xsl:variable>

  <xsl:choose>

	<xsl:when test="$doctype='aic'">

	  Application interpreted construct</xsl:when>

	<xsl:when test="$doctype='iar'">

	  Integrated application resource</xsl:when>

	<xsl:when test="$doctype='igr'">

	  Integrated generic resource</xsl:when>

	<xsl:otherwise>

	  <xsl:call-template name="error_message">

		<xsl:with-param 

			name="message" 

			select="concat('Error : unknown type: ', $doctype)"/>

	  </xsl:call-template>

	</xsl:otherwise>

  </xsl:choose>

</xsl:template>





<xsl:template match="resource|module|application_protocol" mode="doctype">

  <xsl:choose>

	<xsl:when test="name(.)='application_protocol'">ap</xsl:when>

	<xsl:when test="name(.)='module'">am</xsl:when>

	<xsl:when test="name(.)='resource' and @part > 499 and ./schema[starts-with(@name,'aic_')] ">aic</xsl:when>

	<xsl:when test="name(.)='resource' and @part >  99">iar</xsl:when>

	<xsl:when test="name(.)='resource' and @part &lt;  99">igr</xsl:when>

	<xsl:otherwise>

	  <xsl:call-template name="error_message">

		<xsl:with-param 

			name="message" 

			select="concat('Error : unknown type,  part number:', @part)"/>

	  </xsl:call-template>

	</xsl:otherwise>

  </xsl:choose>

</xsl:template>



<xsl:template match="code">

  <code>

    <xsl:apply-templates/>

  </code>

</xsl:template>



<xsl:template name="number_to_word">

  <xsl:param name="number"/>

  <xsl:choose>

    <xsl:when test="$number='1'">first</xsl:when>

    <xsl:when test="$number='2'">second</xsl:when>

    <xsl:when test="$number='3'">third</xsl:when>

    <xsl:when test="$number='4'">fourth</xsl:when>

    <xsl:when test="$number='5'">fifth</xsl:when>

    <xsl:when test="$number='6'">sixth</xsl:when>

    <xsl:when test="$number='7'">seventh</xsl:when>

    <xsl:when test="$number='8'">eighth</xsl:when>

    <xsl:when test="$number='9'">ninth</xsl:when>

    <xsl:when test="$number='10'">tenth</xsl:when>

    <xsl:when test="$number='11'">eleventh</xsl:when>

    <xsl:when test="$number='12'">twelfth</xsl:when>

    <xsl:when test="$number='13'">thirteenth</xsl:when>

    <xsl:when test="$number='14'">fourteenth</xsl:when>

    <xsl:when test="$number='15'">fifteenth</xsl:when>

    <xsl:when test="$number='16'">sixteenth</xsl:when>

    <xsl:when test="$number='17'">seventeenth</xsl:when>

    <xsl:when test="$number='18'">eighteenth</xsl:when>

    <xsl:when test="$number='19'">nineteenth</xsl:when>

    <xsl:when test="$number='20'">twentieth</xsl:when>

    <xsl:when test="$number='21'">twenty first</xsl:when>

    <xsl:when test="$number='22'">twenty second</xsl:when>

    <xsl:when test="$number='23'">twenty third</xsl:when>

    <xsl:otherwise>

      <xsl:call-template name="error_message">

        <xsl:with-param name="inline" select="'yes'"/>

        <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>

        <xsl:with-param name="message"

          select="concat('Error F2 version error: ',/module/@name,' The number (',$number,') is not recognized. Either update sect_g_change.xsl or module.xml')"/>

      </xsl:call-template> 

      

    </xsl:otherwise>

  </xsl:choose>

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

        <xsl:when test="document('../repository_index.xml')/repository_index/application_protocols/application_protocol[@name=$application_protocol_name]">

          <xsl:value-of select="'true'"/>

        </xsl:when>

        <xsl:otherwise>

          <xsl:value-of select="concat(' The application_protocol ', $application_protocol_name, ' is not identified as an application_protocol module in repository_index.xml')"/>

        </xsl:otherwise>

      </xsl:choose>

    </xsl:variable>

    <xsl:value-of select="$ret_val"/>

  </xsl:template>





<!--  <xsl:template name="application_protocol_directory">

    <xsl:param name="application_protocol"/>

    <xsl:variable name="ap_dir">

      <xsl:call-template name="module_name">

        <xsl:with-param name="module" select="$application_protocol"/>

      </xsl:call-template>

    </xsl:variable>

    <xsl:value-of select="concat('../../data/application_protocols/', $ap_dir)"/>

  </xsl:template>-->

  

  

  

  

  <!-- output the module as a bibliography entry -->

  <xsl:template match="module" mode="bibitem">

    <xsl:variable name="part">

      <xsl:choose>

        <xsl:when test="string-length(@part)>0">

          <xsl:value-of select="@part"/>

        </xsl:when>

        <xsl:otherwise> &lt;part&gt; </xsl:otherwise>

      </xsl:choose>

    </xsl:variable>

    <xsl:variable name="stdnumber">

      <xsl:call-template name="get_module_stdnumber_undated">

        <xsl:with-param name="module" select="."/>

      </xsl:call-template>

    </xsl:variable>

    <xsl:variable name="stdtitle"

      select="concat('Industrial automation systems and integration ',

      '&#8212; Product data representation and exchange ')"/>

    <xsl:variable name="module_name">

      <xsl:call-template name="module_display_name">

        <xsl:with-param name="module" select="@name"/>

      </xsl:call-template>

    </xsl:variable>

    <xsl:variable name="subtitle"

      select="concat('&#8212; Part ',$part,': Application module: ', $module_name,'.')"/>

    <!-- Printing of standard line starts here -->

    <xsl:value-of select="$stdnumber"/>

    <xsl:choose>

      <!-- if the module is a TS or IS module and is referring to a CD or CD-TS module -->

      <xsl:when

        test="( string(./@status)='TS' or 

        string(./@status)='IS') and

        ( string(./@status)='CD' or string(./@status)='CD-TS')"

        > &#160;<sup><a href="#derogation">2</a>)</sup>

      </xsl:when>

      <!-- 

        See 

        http://locke.dcnicn.com/bugzilla/iso10303/show_bug.cgi?id=3401#c5        

      <xsl:when test="@published='n'">&#160;<sup><a href="#tobepub">1</a>)</sup>

      </xsl:when> -->

    </xsl:choose>,&#160; <i>

      <xsl:value-of select="$stdtitle"/>

      <xsl:value-of select="$subtitle"/>

    </i>

  </xsl:template>

 

  <!-- output the AP as a bibliography entry -->

  <xsl:template match="application_protocol" mode="bibitem">

    <xsl:variable name="part">

      <xsl:choose>

        <xsl:when test="string-length(@part)>0">

          <xsl:value-of select="@part"/>

        </xsl:when>

        <xsl:otherwise> &lt;part&gt; </xsl:otherwise>

      </xsl:choose>

    </xsl:variable>

    <xsl:variable name="stdnumber">

      <xsl:call-template name="get_protocol_stdnumber">

        <xsl:with-param name="application_protocol" select="."/>

      </xsl:call-template>

    </xsl:variable>

    <xsl:variable name="stdtitle"

      select="concat('Industrial automation systems and integration ',

      '&#8212; Product data representation and exchange ')"/>

    <xsl:variable name="ap_name">

      <xsl:call-template name="protocol_display_name">

        <xsl:with-param name="application_protocol" select="@name"/>

      </xsl:call-template>

    </xsl:variable>

    <xsl:variable name="subtitle"

      select="concat('&#8212; Part ',$part,': Application protocol: ', $ap_name,'.')"/>

    <!-- Printing of standard line starts here -->

    <xsl:value-of select="$stdnumber"/>

    <xsl:choose>

      <!-- if the module is a TS or IS module and is referring to a CD or CD-TS module -->

      <xsl:when

        test="( string(./@status)='TS' or 

        string(./@status)='IS') and

        ( string(./@status)='CD' or string(./@status)='CD-TS')"

        > &#160;<sup><a href="#derogation">2</a>)</sup>

      </xsl:when>

      <!-- 

        See 

        http://locke.dcnicn.com/bugzilla/iso10303/show_bug.cgi?id=3401#c5        

        

      <xsl:when test="@published='n'">&#160;<sup><a href="#tobepub">1</a>)</sup>

      </xsl:when> -->

    </xsl:choose>,&#160; <i>

      <xsl:value-of select="$stdtitle"/>

      <xsl:value-of select="$subtitle"/>

    </i>

  </xsl:template>

  

  <!-- output the resource document as a bibliography entry -->

  <xsl:template match="resource" mode="bibitem">

    <xsl:variable name="part">

      <xsl:choose>

        <xsl:when test="string-length(@part)>0">

          <xsl:value-of select="@part"/>

        </xsl:when>

        <xsl:otherwise> &lt;part&gt; </xsl:otherwise>

      </xsl:choose>

    </xsl:variable>

    <xsl:variable name="stdnumber">

      <xsl:call-template name="get_protocol_stdnumber">

        <xsl:with-param name="application_protocol" select="."/>

      </xsl:call-template>

    </xsl:variable>

    <xsl:variable name="stdtitle"

      select="concat('Industrial automation systems and integration ',

      '&#8212; Product data representation and exchange ')"/>

    <xsl:variable name="ap_name">

      <xsl:call-template name="protocol_display_name">

        <xsl:with-param name="application_protocol" select="@name"/>

      </xsl:call-template>

    </xsl:variable>

    <xsl:variable name="subtitle"

      select="concat('&#8212; Part ',$part,': Integrated generic resource: ', $ap_name,'.')"/>

    <!-- Printing of standard line starts here -->

    <xsl:value-of select="$stdnumber"/>

    <xsl:choose>

      <!-- if the module is a TS or IS module and is referring to a CD or CD-TS module -->

      <xsl:when

        test="( string(./@status)='TS' or 

        string(./@status)='IS') and

        ( string(./@status)='CD' or string(./@status)='CD-TS')"

        > &#160;<sup><a href="#derogation">2</a>)</sup>

      </xsl:when>

      <!-- 

        See 

        http://locke.dcnicn.com/bugzilla/iso10303/show_bug.cgi?id=3401#c5        

        -->

      <xsl:when test="@published='n'">&#160;<sup><a href="#tobepub">1</a>)</sup>

      </xsl:when>

    </xsl:choose>,&#160; <i>

      <xsl:value-of select="$stdtitle"/>

      <xsl:value-of select="$subtitle"/>

    </i>

  </xsl:template>

  

  <!-- 

      used to display the URL in a n bibliographic entry 

      Used by:

      sect_biblio.xsl

      ap_doc/sect_biblio.xsl

      

  -->

  <xsl:template match="ulink">

    <xsl:text>Available from the World Wide Web: </xsl:text>

    <xsl:variable name="href" select="normalize-space(.)"/>

    &lt;<a href="{$href}"><xsl:value-of select="$href"/></a>&gt;<xsl:text/>

  </xsl:template>

  

  <!-- BOM -->

  <xsl:template name="model_directory2">

    <xsl:param name="model"/>

    

    <xsl:variable name="model_dir">

      <xsl:call-template name="model_name2">

        <xsl:with-param name="model_param" select="$model"/>

      </xsl:call-template>

    </xsl:variable>

    

    <xsl:value-of select="concat('../data/business_object_models/', $model_dir)"/>

    <!--<xsl:value-of select="string('../data/business_object_models/managed_model_based_3d_engineering')"/>-->

  </xsl:template>

  

  <!-- BOM -->

  <xsl:template name="model_name2">

    <xsl:param name="model_param"/>

    <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

    <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>

    <xsl:variable name="model_lcase"

      select="translate(

      normalize-space(translate($model_param,$UPPER, $LOWER)),

      '&#x20;','_')"/>

    <!-- hack to cope with fact that begining of linkend does not necessarily end with 'bom' (not sure why there is no similar problem with '_arm' or '_mim') -->

    <xsl:variable name="mod_name">

      <xsl:choose>

        <xsl:when test="contains($model_lcase,'_bom')">

          <xsl:value-of select="substring-before($model_lcase,'_bom')"/>

        </xsl:when>

        <xsl:otherwise>

          <xsl:value-of select="string($model_lcase)"/>

        </xsl:otherwise>

      </xsl:choose>

      <xsl:value-of select="substring-before($model_lcase,'_bom')"/>

    </xsl:variable>

    <xsl:value-of select="$mod_name"/>

  </xsl:template>

  

</xsl:stylesheet>

