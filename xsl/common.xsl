<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: common.xsl,v 1.33 2002/04/19 07:43:10 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     Templates that are common to most other stylesheets
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
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
      <link
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

  <xsl:choose>
    <xsl:when test="$output_rcs">
      <xsl:variable
        name="date"
        select="translate(@rcs.date,'$','')"/>
      <xsl:variable
        name="rev"
        select="translate(@rcs.revision,'$','')"/>
      <xsl:value-of
        select="concat($lpart,' :- ',@name,'  (',$date,' ',$rev,')')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of
        select="concat($lpart,' :- ',@name)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

  <!-- output RCS version control information -->
<xsl:template name="rcs_output">
  <xsl:param name="module" select="@name"/>
  <xsl:if test="$output_rcs">
    <xsl:variable name="mod_dir">
      <xsl:call-template name="module_directory">
        <xsl:with-param name="module" select="$module"/>
      </xsl:call-template>
    </xsl:variable>

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
          <font size="-2">
            <xsl:value-of select="'module.xml'"/>
          </font>
        </td>
        <td>
          <font size="-2">
            <xsl:value-of select="concat('(',$module_date,' ',$module_rev,')')"/>
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
            <xsl:value-of select="'arm.xml'"/>
          </font>
        </td>
        <td>
          <font size="-2">
            <xsl:value-of select="concat('(', $arm_date,' ',$arm_rev,')')"/>
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
            <xsl:value-of select="'mim.xml'"/>
          </font>
        </td>
        <td>
          <font size="-2">
            <xsl:value-of select="concat('(',$mim_date,' ',$mim_rev,')')"/>
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

  <!-- output RCS version control information -->
  <xsl:call-template name="rcs_output">
    <xsl:with-param name="module" select="@name"/>
  </xsl:call-template>

  <TABLE cellspacing="0" border="0" width="100%">
    <TR>
      <TD valign="MIDDLE">
        <B>
          Application module:
          <xsl:call-template name="module_display_name">
            <xsl:with-param name="module" select="@name"/>
          </xsl:call-template>
        </B>
      </TD>
      <TD valign="MIDDLE">
        <xsl:variable name="stdnumber">
          <xsl:call-template name="get_module_stdnumber">
            <xsl:with-param name="module" select="."/>
          </xsl:call-template>
        </xsl:variable>
        <b>
          <xsl:value-of select="$stdnumber"/>
        </b>
      </TD>
    </TR>
  </TABLE>
</xsl:template>



<!-- output the clause heading -->
<xsl:template name="clause_header">
  <xsl:param name="heading"/>
  <xsl:param name="aname"/>
  <H3>
    <A NAME="{$aname}">
      <xsl:value-of select="$heading"/>
    </A>
  </H3>
</xsl:template>

<!-- output the Annex heading -->
<xsl:template name="annex_header">
  <xsl:param name="heading"/>
  <xsl:param name="annex_no"/>
  <xsl:param name="title"/>
  <xsl:param name="aname"/>
  <xsl:param name="informative" select="'informative'"/>
  <center>
    <h3>
      <A NAME="{$aname}">
        <xsl:value-of select="concat('Annex ', $annex_no)"/>
      </A>
    </h3>
    (<xsl:value-of select="$informative"/>)
    <h3><xsl:value-of select="$heading"/></h3>
  </center>
</xsl:template>



<xsl:template match="description">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="note" >
  <xsl:variable name="aname">
    <xsl:choose>
      <xsl:when test="@id">
        <xsl:value-of select="concat('note:',@id)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('note:',@number)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <p>
    <small>
      <a name="{$aname}">
        <xsl:value-of select="concat('NOTE ',./@number,' ')"/></a>&#160;&#160;
        <xsl:apply-templates/>
    </small>
  </p>
</xsl:template>

<xsl:template match="example" >
  <xsl:variable name="aname">
    <xsl:choose>
      <xsl:when test="@id">
        <xsl:value-of select="concat('example:',@id)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('example:',@number)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <p>
    <small>
    <a name="{$aname}">
      <xsl:value-of select="concat('EXAMPLE ',@number,' ')"/></a>&#160;&#160;
    <xsl:apply-templates/>
  </small>
</p>
</xsl:template>


  <xsl:template match="figure">
    <xsl:variable name="number">
      <xsl:number/>
    </xsl:variable>

    <xsl:variable name="aname">
      <xsl:choose>
        <xsl:when test="@id">
          <xsl:value-of select="concat('figure:',@id)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('figure:',$number)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>


    <xsl:apply-templates select="./img"/>
    <center>
      <a name="{$aname}">
        <xsl:value-of select="concat('Figure ',$number,
                              ' - ')"/></a>&#160;&#160;<xsl:apply-templates select="./title"/>
    </center>

  </xsl:template>

<xsl:template match="title">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="img">
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
  <center>
    <IMG src="{$src}" border="0" usemap="#map">
      <MAP NAME="map">
        <xsl:apply-templates select="img.area"/>
      </MAP>
    </IMG>
  </center>
</xsl:template>

<xsl:template match="img.area">
  <xsl:variable name="shape" select="@shape"/>
  <xsl:variable name="coords" select="@coords"/>
  <xsl:variable name="href">
    <xsl:choose>
      <xsl:when test="contains(@href,'xml')">
        <xsl:value-of select="concat(substring-before(@href,'.xml'),
                              $FILE_EXT,
                              substring-after(@href,'.xml'))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@href"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <AREA shape="{$shape}" coords="{$coords}" href="{$href}"/>
</xsl:template>

<!--
     An unordered list
     -->
<xsl:template match="ul" >
  <ul>
    <xsl:apply-templates/>
  </ul>
</xsl:template>
<xsl:template match="UL" >
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
     A list item
     -->
<xsl:template match="li" >
  <li>
    <xsl:apply-templates/>
  </li>
</xsl:template>
<xsl:template match="LI" >
  <li>
    <xsl:apply-templates/>
  </li>
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
<xsl:template match="p">
  <!-- if a paragraph is specified immediately after NOTE of EXAMPLE, then
       ignore it
       -->
  <xsl:choose>
    <xsl:when test="position()=1 and (name(..)='note' or name(..)='example')" >
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <p>
        <xsl:apply-templates/>
      </p>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
<xsl:template match="P">
  <!-- if a paragraph is specified immediately after NOTE of EXAMPLE, then
       ignore it
       -->
  <xsl:choose>
    <xsl:when test="position()=1 and (name(..)='note' or name(..)='example')" >
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <p>
        <xsl:apply-templates/>
      </p>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="b|B">
  <b>
    <xsl:apply-templates/>
  </b>
</xsl:template>


<xsl:template match="i|I">
  <i>
    <xsl:apply-templates/>
  </i>
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

<xsl:template match="screen" >
  <pre>
    <xsl:apply-templates />
  </pre>
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
              select="concat('ERROR:  the module ', $module_name,
                      ' is not identified as a module in repository_index.xml')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:value-of select="$ret_val"/>
  </xsl:template>



  <!-- output a warning message. If $inline is yes then the error message
       will be included  in the HTML output.
       NOTE - this gets overridden if $INLINE_ERRORS defined in
       parameters.xsl is 'no'
       -->
  <xsl:template name="error_message">
    <xsl:param name="message"/>
    <xsl:param name="inline" select="'yes'"/>
    <xsl:param name="warning_gif"
      select="'../../../../images/warning.gif'"/>

    <xsl:message>
      <xsl:value-of select="$message"/>
    </xsl:message>
    <xsl:if test="contains($INLINE_ERRORS,'yes')">
      <xsl:if test="contains($inline,'yes')">
        <br/>
        <IMG
          SRC="{$warning_gif}" ALT="[warning:]"
          align="absbottom" border="0"
          width="20" height="20"/>
        <font color="#FF0000" size="-1">
          <i>
            <xsl:value-of select="$message"/>
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
    <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
    <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>

    <xsl:variable name="first_char"
      select="substring(translate($module,$LOWER,$UPPER),1,1)"/>

    <xsl:variable name="module_name"
      select="concat($first_char,
              translate(substring($module,2),'_',' '))"/>
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


  <!-- a reference to an EXPRESS construct in a module ARM or MIM or in the
       Integrated Resource. The format of the linkend attribute that
       defines the reference is:
     <module>:mim|arm:<schema>.<entity|type|function|constant>.<attribute>|wr:<whererule>|ur:<uniquerule>

     where:
      <module> - the name of the module
       arm - links to the arm documentation
       arm_express - links to the arm express
       mim - links to the mim documentation
       mim_express - links to the mim express
       ir - links to the ir express

     e.g. work_order:arm:work_order_arm.Activity.name

     To address an EXPRESS construct in an Integrated Resource schema:
     <ir>:ir:<schema>.<entity|type|function|constant>.<attribute>|wr:<whererule>|ur:<uniquerule>
-->
  <xsl:template match="express_ref">
    <xsl:variable name="href">
      <xsl:call-template name="get_href_from_express_ref">
        <xsl:with-param name="linkend" select="@linkend"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="item">
      <xsl:call-template name="get_last_section">
        <xsl:with-param name="path" select="@linkend"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$href=''">
        <xsl:call-template name="error_message">
          <xsl:with-param
            name="message"
            select="concat('express_ref linkend',
                    @linkend,
                    ' is incorrectly specified')"/>
        </xsl:call-template>
        <xsl:choose>
          <xsl:when test="string-length(.)>0">
            <b><xsl:apply-templates/></b>
          </xsl:when>
          <xsl:otherwise>
            <b><xsl:value-of select="$item"/></b>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="string-length(.)>0">
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

    <xsl:variable
      name="module"
      select="substring-before($nlinkend,':')"/>

    <xsl:variable
      name="nlinkend1"
      select="substring-before(substring-after($nlinkend,':'),':')"/>

    <xsl:variable name="arm_mim_ir">
      <xsl:choose>
        <xsl:when test="$nlinkend1='arm'
                        or $nlinkend1='arm_express'
                        or $nlinkend1='mim'
                        or $nlinkend1='mim_express'
                        or $nlinkend1='ir_express'">
          <xsl:value-of select="$nlinkend1"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- error found, do nothing until href variable is set -->
          <xsl:value-of select="''"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable
      name="express_ref"
      select="translate(substring-after(substring-after($nlinkend,':'),':'),
              'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>

    <xsl:variable name="href">
      <xsl:choose>
        <xsl:when test="$module='' or $arm_mim_ir=''">
          <!--
               error do nothing as the error will be picked up after the
               href variable is set.
               -->
        </xsl:when>
        <xsl:when test="$arm_mim_ir='ir_express'">
          <xsl:value-of
            select="concat($baselink,'resources/',$module,'/',
                    $module,$FILE_EXT,'#',$express_ref)"/>
        </xsl:when>
        <xsl:when test="$arm_mim_ir='arm'">
          <xsl:value-of
            select="concat($baselink,'modules/',$module,
                    '/sys/4_info_reqs',$FILE_EXT,'#',$express_ref)"/>
        </xsl:when>

        <xsl:when test="$arm_mim_ir='arm_express'">
          <xsl:value-of
            select="concat($baselink,'modules/',$module,
                    '/arm',$FILE_EXT,'#',$express_ref)"/>
        </xsl:when>

        <xsl:when test="$arm_mim_ir='mim'">
          <xsl:value-of
            select="concat($baselink,'modules/',$module,
                    '/sys/5_mim',$FILE_EXT,'#',$express_ref)"/>
        </xsl:when>


        <xsl:when test="$arm_mim_ir='mim_express'">
          <xsl:value-of
            select="concat($baselink,'modules/',$module,
                    '/mim',$FILE_EXT,'#',$express_ref)"/>
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

    <xsl:variable name="module">
      <xsl:choose>
        <xsl:when test="contains($nlinkend,':')">
          <xsl:value-of select="substring-before($nlinkend,':')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$nlinkend"/>
        </xsl:otherwise>
      </xsl:choose>
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
                        or $section_tmp='4_rules'
                        or $section_tmp='4_functions'
                        or $section_tmp='4_procedures'
                        or $section_tmp='5_mapping'
                        or $section_tmp='5_mim_express'
                        or $section_tmp='5_interfaces'
                        or $section_tmp='5_constants'
                        or $section_tmp='5_types'
                        or $section_tmp='5_entities'
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
                        or $construct_tmp='figure'">
          <xsl:choose>
            <!-- test that an id has been given -->
            <xsl:when test="$id!=''">
              <xsl:value-of select="concat('#',$construct_tmp,':',$id)"/>
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
          <xsl:value-of
            select="concat('../../../modules/',$module,
                    '/sys/2_refs',$FILE_EXT)"/>
        </xsl:when>
        <xsl:when test="$section='3_definition'">
          <xsl:value-of
            select="concat('../../../modules/',$module,
                    '/sys/3_defs',$FILE_EXT)"/>
        </xsl:when>
        <xsl:when test="$section='3_abbreviations'">
          <xsl:value-of
            select="concat('../../../modules/',$module,
                    '/sys/3_defs',$FILE_EXT)"/>
        </xsl:when>
        <xsl:when test="$section='4_uof'">
          <xsl:value-of
            select="concat('../../../modules/',$module,
                    '/sys/4_info_reqs',$FILE_EXT,'#uof')"/>
        </xsl:when>
        <xsl:when test="$section='4_interfaces'">
          <xsl:value-of
            select="concat('../../../modules/',$module,
                    '/sys/4_info_reqs',$FILE_EXT,'#interfaces')"/>
        </xsl:when>
        <xsl:when test="$section='4_constants'">
          <xsl:value-of
            select="concat('../../../modules/',$module,
                    '/sys/4_info_reqs',$FILE_EXT,'#constants')"/>
        </xsl:when>
        <xsl:when test="$section='4_types'">
          <xsl:value-of
            select="concat('../../../modules/',$module,
                    '/sys/4_info_reqs',$FILE_EXT,'#types')"/>
        </xsl:when>
        <xsl:when test="$section='4_entities'">
          <xsl:value-of
            select="concat('../../../modules/',$module,
                    '/sys/4_info_reqs',$FILE_EXT,'#entities')"/>
        </xsl:when>
        <xsl:when test="$section='4_rules'">
          <xsl:value-of
            select="concat('../../../modules/',$module,
                    '/sys/4_info_reqs',$FILE_EXT,'#rules')"/>
        </xsl:when>
        <xsl:when test="$section='4_functions'">
          <xsl:value-of
            select="concat('../../../modules/',$module,
                    '/sys/4_info_reqs',$FILE_EXT,'#functions')"/>
        </xsl:when>
        <xsl:when test="$section='4_procedures'">
          <xsl:value-of
            select="concat('../../../modules/',$module,
                    '/sys/4_info_reqs',$FILE_EXT,'#procedures')"/>
        </xsl:when>
        <xsl:when test="$section='5_mapping'">
          <xsl:value-of
            select="concat('../../../modules/',$module,
                    '/sys/5_mim',$FILE_EXT,'#mapping')"/>
        </xsl:when>
        <xsl:when test="$section='5_mim_express'">
          <xsl:value-of
            select="concat('../../../modules/',$module,
                    '/sys/5_mim',$FILE_EXT,'#mim_express')"/>
        </xsl:when>
        <xsl:when test="$section='5_interfaces'">
          <xsl:value-of
            select="concat('../../../modules/',$module,
                    '/sys/5_mim',$FILE_EXT,'#interfaces')"/>
        </xsl:when>
        <xsl:when test="$section='5_constants'">
          <xsl:value-of
            select="concat('../../../modules/',$module,
                    '/sys/5_mim',$FILE_EXT,'#constants')"/>
        </xsl:when>
        <xsl:when test="$section='5_types'">
          <xsl:value-of
            select="concat('../../../modules/',$module,
                    '/sys/5_mim',$FILE_EXT,'#types')"/>
        </xsl:when>
        <xsl:when test="$section='5_entities'">
          <xsl:value-of
            select="concat('../../../modules/',$module,
                    '/sys/5_mim',$FILE_EXT,'#entities')"/>
        </xsl:when>
        <xsl:when test="$section='5_rules'">
          <xsl:value-of
            select="concat('../../../modules/',$module,
                    '/sys/5_mim',$FILE_EXT,'#rules')"/>
        </xsl:when>
        <xsl:when test="$section='5_functions'">
          <xsl:value-of
            select="concat('../../../modules/',$module,
                    '/sys/5_mim',$FILE_EXT,'#functions')"/>
        </xsl:when>
        <xsl:when test="$section='5_procedures'">
          <xsl:value-of
            select="concat('../../../modules/',$module,
                    '/sys/5_mim',$FILE_EXT,'#procedures')"/>
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
            select="concat('module_ref linkend ',
                    $nlinkend,
                    ' is incorrectly specified')"/>
        </xsl:call-template>
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <a href="{$href}"><xsl:apply-templates/></a>
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



  <!-- Output a string, replacing all the carriage returns with
       HTML br
       -->
  <xsl:template name="output_string_with_linebreaks">
    <xsl:param name="string"/>

    <xsl:variable name="nstring"
      select="translate( $string,'&#xA;&#xD;','&#xA;')"/>

    <xsl:choose>
      <xsl:when test="contains($nstring,'&#xA;')">
        <xsl:variable
          name="first"
          select="substring-before($nstring,'&#xA;')"/>
        <xsl:variable
          name="rest"
          select="substring-after($nstring,'&#xA;')"/>

        <xsl:value-of select="$first"/><br/>
        <xsl:call-template name="output_string_with_linebreaks">
          <xsl:with-param name="string" select="$rest"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$nstring"/>
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
        <xsl:value-of select="$module/@status"/>
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

    <xsl:variable name="pub_year">
      <xsl:choose>
        <xsl:when test="string-length($module/@publication.year)">
          <xsl:value-of select="$module/@publication.year"/>
        </xsl:when>
        <xsl:otherwise>
          &lt;publication.year&gt;
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="orgname" select="'ISO'"/>

<!--
      select="concat($orgname,'/',$status,' 10303-',$part,':',$pub_year,'(',$language,') ')"/>
-->
    <xsl:variable name="stdnumber"

      select="concat($orgname,'/',$status,' 10303-',$part,':',$pub_year)"/>
		<xsl:value-of select="$stdnumber"/>
</xsl:template>


<!-- given a string xxx.ccc.qqq return the value after the last . -->
<xsl:template name="get_last_section">
  <xsl:param name="path"/>
  <xsl:choose>
    <xsl:when test="contains($path,'.')">
      <xsl:call-template name="get_last_section">
        <xsl:with-param name="path" select="substring-after($path,'.')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$path"/>
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
  
  <xsl:variable name="module_ok">
    <xsl:call-template name="check_module_exists">
      <xsl:with-param name="module" select="$module_section"/>
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:variable 
    name="nlinkend1"
    select="substring-before(substring-after($nlinkend,':'),':')"/>
  
  <xsl:variable name="arm_mim_ir_section">
    <xsl:choose>
      <xsl:when test="$nlinkend1='arm'
                      or $nlinkend1='arm_express'
                      or $nlinkend1='mim'
                      or $nlinkend1='mim_express'
                      or $nlinkend1='ir_express'">
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
        <xsl:value-of select="concat('express_ref linkend', 
                              $linkend, 
                              ' is incorrectly specified. 
                              Need to specify :arm: :arm_express: :mim: :ir_express')"/>
      </xsl:when>
      <xsl:when test="$module_section=''">
        <xsl:value-of select="concat('express_ref linkend', 
                              $linkend, 
                              ' is incorrectly specified.
                              Need to specify the module first')"/>
      </xsl:when>
      <xsl:when test="$module_ok!='true'">
        <xsl:value-of select="concat('express_ref linkend', 
                              $linkend, 
                              ' is incorrectly specified.', $module_ok)"/>
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

  <xsl:variable 
    name="nlinkend"
    select="translate($linkend,'&#x9;&#xA;&#x20;&#xD;','')"/>
  
  <xsl:variable 
    name="express_ref" 
    select="translate(substring-after(substring-after($nlinkend,':'),':'),
            'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
  

</xsl:template>

  
</xsl:stylesheet>


