<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: ballot_summary.xsl,v 1.30 2005/02/08 00:29:45 thendrix Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited http://www.eurostep.com
  Purpose: To display a table summarising the modules in a ballot package

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

 <xsl:import href="../../xsl/common.xsl"/> 
 <!-- RBN - Commented out to avoid duplication of  ERROR_CHECK_LIST_ITEMS
      <xsl:import href="../../xsl/res_doc/common.xsl"/>  
      -->
 

  <xsl:output 
    method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    indent="yes"
    />

    <xsl:param name="stepmodhome" select="'../../..'"/>
    <xsl:param name="date" select="''"/>
    <xsl:variable name="formatted_date"
      select="concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2) )"/>


    <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>
    <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

  <!-- force the application of the stylesheet to the file specified in the
       file attribute -->





  <xsl:template match="/">
 
    <xsl:variable name="ballot_index" 
      select="concat('../ballots/',./ballot/@directory,'/ballot_index.xml')"/>

    <xsl:apply-templates select="document($ballot_index)/ballot_index"/>
  </xsl:template>



<xsl:template match="ballot_index">
  <!-- removed per wg12 convener
  <xsl:variable name="resdoc_xref"
    select="concat($stepmodhome,'/data/resource_docs/',.//resource/@name,'/sys/cover',$FILE_EXT)"/>
-->
  <xsl:variable name="ballot_title">
    <xsl:choose>
      <xsl:when test="./@title or ./title">
        <xsl:value-of select="./@title"/><xsl:value-of select="./title"/>              </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="/ballot_index/@name"/>
        </xsl:otherwise>
      </xsl:choose>            
    </xsl:variable>

  <HTML>
    <head>
      <!-- removed at request of wg12 convener.
      <xsl:if test="./ballot_package/resource">
          <meta http-equiv="Refresh" content="0;URL={$resdoc_xref}"/>
      </xsl:if>
-->
      <xsl:call-template name="meta_data">
        <xsl:with-param name="clause" select="$ballot_title"/>
      </xsl:call-template>
      <title>
        <xsl:value-of select="$ballot_title"/>    
      </title>

    </head>
    <body>
      <!-- As there is only one entry no point
      <xsl:call-template name="output_menubar">
        <xsl:with-param name="module_root" select="'.'"/>
        <xsl:with-param name="module_name" select="@name"/>
      </xsl:call-template>
      -->


      <hr/>
      <table>
        <tr>
          <td>Ballot cycle name:</td>
          <td><xsl:value-of select="@name"/></td>
        </tr>
        <tr>
          <td>Title:</td>
          <td>
        <xsl:value-of select="$ballot_title"/>    
          </td>
        </tr>
        <tr>
          <td>Date:</td>
<td><xsl:value-of select="$formatted_date"/></td>
        </tr>
        <tr>
          <td>Description:</td>
          <td><xsl:value-of select="@description"/><xsl:value-of select="./description"/></td>
        </tr>
        <tr>
          <td>Ballot cycle  WG number:</td>
          <td><xsl:value-of select="@wg.number.ballot_package"/></td>
        </tr>
        <tr>
          <td>Ballot cycle project leader:</td>
          <td>
              <xsl:apply-templates select="./contacts/projlead"
                mode="no_address"/>
          </td>
        </tr>

        <tr>
          <td>Ballot cycle comments:</td>
          <td><xsl:value-of select="@wg.number.ballot_package_comment"/></td>
        </tr>
      </table>
      <hr/>
      <p>
        <!-- NOTE - not all packages have normref_check file -->
        Normative reference 
        <a href="normref_check{$FILE_EXT}">check</a>
      </p>

      <xsl:if test="./ballot_package/module">
        <xsl:call-template name="module_table_hdr"/>
      </xsl:if>

      <xsl:if test="./ballot_package/ap_doc">
        <xsl:call-template name="ap_doc_table_hdr"/>
      </xsl:if>

      <xsl:if test="./ballot_package/res_doc">
        <xsl:call-template name="resource_table_hdr"/>
      </xsl:if>

    </body>
  </HTML>
</xsl:template>

<xsl:template name="ap_doc_table_hdr">
  <p/>
  <table border="1">
    <tr>
      <td><b>AP document part package</b></td>
      <td><b>AP document part</b></td>
      <td><b>Part</b></td>
      <td><b>Edition</b></td>
      <td><b>Stage</b></td>
      <td><b>Year of<br/>Publication</b></td>
      <td><b>Abstract</b></td>
    </tr>
    <xsl:apply-templates select="//*/ap_doc"/>
  </table>
</xsl:template>

<xsl:template match="ap_doc">
  <xsl:variable name="apdoc_ok">
    <!-- not yet implemented 
    <xsl:call-template name="check_apdoc_exists">
      <xsl:with-param name="resdoc" select="@name"/>
    </xsl:call-template> -->
    <xsl:value-of select="'true'"/>
  </xsl:variable>

  <xsl:variable name="apdoc_file" select="concat('../../data/application_protocols/',@name,'/application_protocol.xml')"/>
  <xsl:variable name="apdoc_node" select="document($apdoc_file)/application_protocol"/>
    
  <xsl:choose>
    <xsl:when test="$apdoc_ok='true'">
      <tr>
        <!-- Ballot package -->
        <td>
          <xsl:choose>
            <xsl:when test="../@id">
              <xsl:value-of select="concat(../@id,' - ',../@name)"/>    
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="../@name"/> 
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <!-- AP document package -->
        <td>
          <xsl:variable name="apdoc_xref"
            select="concat($stepmodhome,'/data/application_protocols/',@name,'/home',$FILE_EXT)"/>
          <a href="{$apdoc_xref}">
            <!-- changed to avoid changing folder for 203  <xsl:value-of select="@name"/>  -->
            <xsl:value-of select="$apdoc_node/@title"/> 
          </a>
        </td>
        <!-- Part -->
        <td>
         <xsl:choose>
           <xsl:when test="$apdoc_node/@part">
             <xsl:value-of select="concat('10303-',$apdoc_node/@part)"/>
             
             <!-- check that the part number in repository_index - that in
                  module -->
             <xsl:variable name="apdoc" select="@name"/>
             <xsl:variable name="repo_apdoc_number"
               select="document('../../repository_index.xml')/repository_index/application_protocols/application_protocol[@name=$apdoc]/@part"/>
             <xsl:if test="$repo_apdoc_number != $apdoc_node/@part">
               <br/>
               <font color="#FF0000" size="-1">
                 The part number in repository_index
                 (<xsl:value-of select="$repo_apdoc_number"/>)
                 does not equal that in module 
                 (<xsl:value-of select="$apdoc_node/@part"/>).
                </font>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Version -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($apdoc_node/@version))>0">
              <xsl:value-of select="$apdoc_node/@version"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Status -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($apdoc_node/@status))>0">
              <xsl:value-of select="$apdoc_node/@status"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Year -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($apdoc_node/@publication.year))>0">
              <xsl:value-of select="$apdoc_node/@publication.year"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Abstract -->
        <td>
          <xsl:variable name="abstract_xref"
            select="concat('./abstracts/ap_abstract_',@name,$FILE_EXT)"/>
          <a href="{$abstract_xref}">
            abstract
          </a>
        </td>

      </tr>
    </xsl:when>
  </xsl:choose>
</xsl:template>


<xsl:template name="resource_table_hdr">
  <p/>
  <table border="1">
    <tr>
      <td><b>Resource part package</b></td>
      <td><b>Resource part</b></td>
      <td><b>Part</b></td>
      <td><b>Edition</b></td>
      <td><b>Stage</b></td>
      <td><b>Year of<br/>Publication</b></td>
    </tr>
    <xsl:apply-templates select="//*/res_doc"/>
  </table>
</xsl:template>



  <!-- RBN - 
       COPIED FROM stepmod/xsl/res_doc/common.xsl to avoid duplication of
       ERROR_CHECK_LIST_ITEMS
       given the name of a resource document , return the name of resource document - dont ask
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

  <!-- RBN - 
       COPIED FROM stepmod/xsl/res_doc/common.xsl to avoid duplication of
       ERROR_CHECK_LIST_ITEMS
       given the name of a resource doc, check to see whether it has been
       included in the repository_index.xml file
       Return true or if not found, an error message.
       -->
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
            test="document('../../repository_index.xml')/repository_index/resource_docs/resource_doc[@name=$resdoc_name]">
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

<xsl:template match="res_doc">
  <xsl:variable name="resdoc_ok">
    <xsl:call-template name="check_resdoc_exists">
      <xsl:with-param name="resdoc" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="resdoc_xref"
    select="concat($stepmodhome,'/data/resource_docs/',@name,'/sys/cover',$FILE_EXT)"/>

  <xsl:choose>
    <xsl:when test="$resdoc_ok='true'">
      <xsl:variable name="resdoc_file"
        select="concat('../../data/resource_docs/',@name,'/resource.xml')"/>
      <xsl:variable name="resdoc_node"
        select="document($resdoc_file)/resource"/>
      <tr>
        <!-- Ballot package -->
        <td>
          <xsl:choose>
            <xsl:when test="../@id">
              <xsl:value-of select="concat(../@id,' - ',../@name)"/>    
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="../@name"/> 
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <!-- Resource part -->
        <td>
          <a href="{$resdoc_xref}">
            <xsl:value-of select="@name"/>
          </a>
        </td>

        <!-- Part -->
        <td>
          <xsl:choose>
            <xsl:when test="$resdoc_node/@part">
              <xsl:value-of select="concat('10303-',$resdoc_node/@part)"/>

              <!-- check that the part number in repository_index - that in
                   module -->
              <xsl:variable name="resdoc" select="@name"/>
              <xsl:variable name="repo_resdoc_number"
                select="document('../../repository_index.xml')/repository_index/resource_docs/resource_doc[@name=$resdoc]/@part"/>
              <xsl:if test="$repo_resdoc_number != $resdoc_node/@part">
                <br/>
                <font color="#FF0000" size="-1">
                  The part number in repository_index
                  (<xsl:value-of select="$repo_resdoc_number"/>)
                does not equal that in resource part 
                (<xsl:value-of select="$resdoc_node/@part"/>).
              </font>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Version -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($resdoc_node/@version))>0">
              <xsl:value-of select="$resdoc_node/@version"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Status -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($resdoc_node/@status))>0">
              <xsl:value-of select="$resdoc_node/@status"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Year -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($resdoc_node/@publication.year))>0">
              <xsl:value-of select="$resdoc_node/@publication.year"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
    </xsl:when>

    <!-- resdoc does not exist in repository index -->
    <xsl:otherwise>
      <tr>
        <td>
          <xsl:value-of select="../@name"/>
        </td>
        <td>
          <xsl:value-of select="@name"/>
          <xsl:call-template name="error_message">
            <xsl:with-param name="message">
              <xsl:value-of select="concat('Error ballot1: ', $resdoc_ok)"/>
            </xsl:with-param>
          </xsl:call-template>
        </td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
      </tr>      
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="module_table_hdr">
  <p/>
  <table border="1">
    <tr>
      <td><b>Module package</b></td>
      <td><b>Module</b></td>
      <td><b>Part</b></td>
      <td><b>Edition</b></td>
      <td><b>Stage</b></td>
      <td><b>Year of<br/>Publication</b></td>
      <td><b>Abstract</b></td>
      <td><b>ARM EXPRESS</b></td>
      <td><b>ARM LF EXPRESS</b></td>          
      <td><b>MIM EXPRESS</b></td>
      <td><b>MIM LF EXPRESS</b></td>
    </tr>
    <xsl:apply-templates select="//*/module"/>
  </table>
</xsl:template>

<xsl:template match="module">

  <xsl:variable name="module_ok">
    <xsl:call-template name="check_module_exists">
      <xsl:with-param name="module" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$module_ok='true'">

      <xsl:variable name="module_file"
        select="concat('../../data/modules/',@name,'/module.xml')"/>
      <xsl:variable name="module_node"
        select="document($module_file)/module"/>
      <tr>
        <!-- Ballot package -->
        <td>
          <xsl:choose>
            <xsl:when test="../@id">
              <xsl:value-of select="concat(../@id,' - ',../@name)"/>    
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="../@name"/> 
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Module -->
        <td>
          <xsl:variable name="mod_xref"
            select="concat($stepmodhome,'/data/modules/',@name,'/sys/cover',$FILE_EXT)"/>
          <a href="{$mod_xref}">
            <xsl:value-of select="@name"/>
          </a>
        </td>

        <!-- Part -->
        <td>
          <xsl:choose>
            <xsl:when test="$module_node/@part">
              <xsl:value-of select="concat('10303-',$module_node/@part)"/>

              <!-- check that the part number in repository_index - that in
                   module -->
              <xsl:variable name="module" select="@name"/>
              <xsl:variable name="repo_mod_number"
                select="document('../../repository_index.xml')/repository_index/modules/module[@name=$module]/@part"/>
              <xsl:if test="$repo_mod_number != $module_node/@part">
                <br/>
                <font color="#FF0000" size="-1">
                  The part number in repository_index
                  (<xsl:value-of select="$repo_mod_number"/>)
                does not equal that in module 
                (<xsl:value-of select="$module_node/@part"/>).
              </font>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Version -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($module_node/@version))>0">
              <xsl:value-of select="$module_node/@version"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Status -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($module_node/@status))>0">
              <xsl:value-of select="$module_node/@status"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Year -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($module_node/@publication.year))>0">
              <xsl:value-of select="$module_node/@publication.year"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Abstract -->
        <td>
          <xsl:variable name="abstract_xref"
            select="concat($stepmodhome,'/data/modules/',@name,'/sys/abstract',$FILE_EXT)"/>
          <a href="{$abstract_xref}">
            abstract
          </a>
        </td>

        <xsl:variable name="status"
          select="translate(translate($module_node/@status,$UPPER,$LOWER),'-_ ','')"/>        
        <!-- ARM express -->
        <td>
          <xsl:variable name="armfile"
            select="concat('part',
                    $module_node/@part,
                    $status, '_wg',
                    $module_node/@sc4.working_group,'n',
                    $module_node/@wg.number.arm,
                    'arm.exp')"/>
          <xsl:variable name="arm_href" select="concat('express/',$armfile)"/>
          <a href="{$arm_href}">
            <xsl:value-of select="$armfile"/>
          </a>
        </td>


        <!-- ARM Long form express -->
        <xsl:choose>
          <xsl:when test="$module_node/@wg.number.arm_lf">
            <td>
              <xsl:variable name="arm_lf_file"
                select="concat('part',
                        $module_node/@part,
                        $status, '_wg',
                        $module_node/@sc4.working_group,'n',
                        $module_node/@wg.number.arm_lf,
                        'arm_lf.exp')"/>
              <xsl:variable name="arm_lf_href" select="concat('express/',$arm_lf_file)"/>
              <a href="{$arm_lf_href}">
                <xsl:value-of select="$arm_lf_file"/>
              </a>
            </td>
          </xsl:when>
          <xsl:otherwise>
            <td>
              No Long Form
            </td>
          </xsl:otherwise>
        </xsl:choose>


        <!-- MIM express -->
        <td>
          <xsl:variable name="mimfile"
            select="concat('part',
                    $module_node/@part,
                    $status, '_wg',
                    $module_node/@sc4.working_group,'n',
                    $module_node/@wg.number.mim,
                    'mim.exp')"/>
          <xsl:variable name="mim_href" select="concat('express/',$mimfile)"/>
          <a href="{$mim_href}">
            <xsl:value-of select="$mimfile"/>
          </a>
        </td>


        <!-- MIM Long form express -->
        <xsl:choose>
          <xsl:when test="$module_node/@wg.number.mim_lf">
            <td>
              <xsl:variable name="mim_lf_file"
                select="concat('part',
                        $module_node/@part,
                        $status, '_wg',
                        $module_node/@sc4.working_group,'n',
                        $module_node/@wg.number.mim_lf,
                        'mim_lf.exp')"/>
              <xsl:variable name="mim_lf_href" select="concat('express/',$mim_lf_file)"/>
              <a href="{$mim_lf_href}">
                <xsl:value-of select="$mim_lf_file"/>
              </a>
            </td>
          </xsl:when>
          <xsl:otherwise>
            <td>
              No Long Form
            </td>
          </xsl:otherwise>
        </xsl:choose>
      </tr>
    </xsl:when>

    <!-- module does not exist in repository index -->
    <xsl:otherwise>
      <tr>
        <td>
          <xsl:value-of select="../@name"/>
        </td>
        <td>
          <xsl:value-of select="@name"/>
          <xsl:call-template name="error_message">
            <xsl:with-param name="message">
              <xsl:value-of select="concat('Error ballot1: ', $module_ok)"/>
            </xsl:with-param>
          </xsl:call-template>
        </td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
      </tr>      
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="get_contact_name">
  <xsl:param name="ref"/>
  <xsl:variable name="contact"
    select="document('../../data/basic/contacts.xml')/contact.list/contact[@id=$ref]"/>
  <xsl:choose>
    <xsl:when test="$contact">
      <xsl:value-of select="concat($contact/firstname,' ',$contact/lastname)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="'-'"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="meta_data" >
  <xsl:param name="clause"/>
  <link rel = "schema.DC"
    href    = "http://www.dublincore.org/documents/2003/02/04/dces/"/>
      <xsl:variable name="ballot_name" select="./@name"/>
      <xsl:variable name="stdnumber"  select="./@wg.number.ballot_package"/>

 
  <xsl:call-template name="meta-elements">
    <xsl:with-param name="name" select="'DC.Title'"/>
    <xsl:with-param name="content" select="$clause"/>
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
    <xsl:with-param name="content"><xsl:value-of select="@description"/><xsl:value-of select="./description"/></xsl:with-param>
  </xsl:call-template>

  <xsl:variable name="keywords">
ISO SC4 STEP ballot 
    <xsl:apply-templates select="./keywords"/>
  </xsl:variable>
  <xsl:call-template name="meta-elements">
    <xsl:with-param name="name" select="'DC.Subject'"/>
    <xsl:with-param name="content" select="normalize-space($keywords)"/>
  </xsl:call-template>

  <xsl:variable name="id"
    select="./@wg.number.ballot_package"/>

  <xsl:call-template name="meta-elements">
    <xsl:with-param name="name" select="'DC.Identifier'"/>
    <xsl:with-param name="content" select="$id"/>
  </xsl:call-template>

  <xsl:call-template name="meta-elements">
    <xsl:with-param name="name" select="'STEPMOD.resource.rcs.date'"/>
    <xsl:with-param name="content" select="translate(./@rcs.date,'$','')"/>
  </xsl:call-template>

  <xsl:call-template name="meta-elements">
    <xsl:with-param name="name" select="'STEPMOD.resource.rcs.revision'"/>
    <xsl:with-param name="content" select="translate(./@rcs.revision,'$','')"/>
  </xsl:call-template>

  </xsl:template>

</xsl:stylesheet>