<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: module.xsl,v 1.18 2002/01/04 18:58:51 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">



  <xsl:import href="module_toc.xsl"/>

  <xsl:import href="sect_4_express.xsl"/>


  <xsl:output 
    method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    indent="yes"
    />



<xsl:template match="/">
  <HTML>
    <HEAD>
      <!-- apply a cascading stylesheet.
           the stylesheet will only be applied if the parameter output_css
           is set in parameter.xsl 
           -->
      <xsl:call-template name="output_css">
        <xsl:with-param name="path" select="'../../../css/'"/>
      </xsl:call-template>
      <TITLE>
        <!-- output the module page title -->
        <xsl:apply-templates select="./module" mode="title"/>
      </TITLE>
    </HEAD>
    <BODY>
      <xsl:apply-templates select="./module" mode="TOCsinglePage"/>
      <xsl:apply-templates select="./module" />
    </BODY>
  </HTML>
</xsl:template>

<xsl:template match="module">
  <xsl:apply-templates select="." mode="coverpage"/>
  <xsl:apply-templates select="." mode="foreword"/>
  <xsl:apply-templates/>
</xsl:template>

<!-- Outputs the cover page -->
<xsl:template match="module" mode="coverpage">
  COVER PAGE
</xsl:template>


<!-- Outputs the foreword -->
<xsl:template match="module" mode="foreword">
  <xsl:call-template name="clause_header">
    <xsl:with-param name="heading" select="'Foreword'"/>
    <xsl:with-param name="aname" select="'foreword'"/>
  </xsl:call-template>
  <p>
    <xsl:choose>
      <xsl:when test="string-length(@part)>0">
        <xsl:value-of select="concat('ISO/TS 10303-',@part)"/>
      </xsl:when>
      <xsl:otherwise>
        ISO/TS 10303-<font color="#FF0000"><b>XXXX</b></font>
      </xsl:otherwise>
    </xsl:choose>
    was prepared by Technical Committee ISO/TC 184, 
    <i>Industrial automation systems and integration,</i>
    Subcommittee SC4, <i>Industrial data.</i>
  </p>
  <p>
    This International Standard is organized as a series of parts, each
    published separately. The structure of this International Standard is
    described in ISO 10303-1. Each part of this International Standard is a
    member of one of the following series: description methods, implementation
    methods, conformance testing methodology and framework, integrated generic
    resources, integrated application resources, application protocols,
    abstract test suites, application interpreted constructs, and application
    modules. This part is a member of the application modules series. 
  </p>
  <p>
    A complete list of parts of ISO 10303 is available from the Internet: 
  </p>
  <blockquote>
    <A HREF="http://www.nist.gov/sc4/editing/step/titles/">
      &lt;http://www.nist.gov/sc4/editing/step/titles/&gt;
    </A>.
  </blockquote>
  <p>
    Annexes A and B form an integral part of this part of ISO 10303. Annexes C,
    D, E, and F are for information only.  
  </p> 
</xsl:template>

<xsl:template match="purpose">
  <xsl:call-template name="clause_header">
    <xsl:with-param name="heading" select="'Introduction'"/>
    <xsl:with-param name="aname" select="'introduction'"/>
  </xsl:call-template>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="inscope">
  <xsl:call-template name="clause_header">
    <xsl:with-param name="heading" select="'1 Scope'"/>
    <xsl:with-param name="aname" select="'scope'"/>
  </xsl:call-template>
  <p>
    This part of ISO 10303 specifies the application module for 
    <xsl:value-of select="../@name"/>.
    <a name="inscope"/>
    The following are within scope of this part of ISO 10303: 
  </p>
  <ul>
    <xsl:apply-templates/>
  </ul>
</xsl:template>


<xsl:template match="outscope">
  <p>
    <a name="outscope"/>
    The following are outside the scope of this part of ISO 10303: 
  </p>
  <ul>
    <xsl:apply-templates/>
  </ul>
</xsl:template>


<xsl:template match="module" mode="annexe">
  <xsl:call-template name="annex_header">
    <xsl:with-param name="annex_no" select="'E'"/>
    <xsl:with-param name="heading" 
      select="'Computer Interpretable Listings'"/>
    <xsl:with-param name="aname" select="'annexe'"/>
  </xsl:call-template>

  <xsl:variable name="arm">
    <xsl:choose>
      <xsl:when test="$FILE_EXT='.xml'">
        <xsl:value-of select="'e_exp_arm.xml'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'e_exp_arm.htm'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="mim">
    <xsl:choose>
      <xsl:when test="$FILE_EXT='.xml'">
        <xsl:value-of select="'e_exp_mim.xml'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'e_exp_mim.htm'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="mim_lf">
    <xsl:choose>
      <xsl:when test="$FILE_EXT='.xml'">
        <xsl:value-of select="'e_exp_mim_lf.xml'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'e_exp_mim_lf.htm'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <p>
    This annex references a listing of the EXPRESS entity names and
    corresponding short names as specified or referenced in this part of ISO
    10303. It also provides a listing of each EXPRESS schema specified in this
    part of ISO 10303 without comments or other explanatory text. These
    listings are available in computer-interpretable form in Table E-1 and can
    be found at the following URLs:
  </p>
  <blockquote>
    Short names:
    <a href="http://www.mel.nist.gov/div826/subject/apde/snr">
      http://www.mel.nist.gov/div826/subject/apde/snr
    </a>
    <br/>
    EXPRESS: 
    <a href="http://www.mel.nist.gov/step/parts/part1006/TS/">
      http://www.mel.nist.gov/step/parts/part1006/TS/
    </a>
  </blockquote>
  
  <b>
    <font size="4">
      <p align="center">
        Table E.1 - ARM to MIM EXPRESS short and long form listing
      </p>
    </font>
  </b>
  <br/>


  <CENTER>
    <TABLE BORDER="1" CELLSPACING="1">
        <TR>
          <TD VALIGN="MIDDLE" ROWSPAN="2">
            <P>&#160;</P>
          </TD>
          <TD VALIGN="MIDDLE" ALIGN="CENTER" ROWSPAN="2"><B>ARM</B></TD>
          <TD VALIGN="MIDDLE" ALIGN="CENTER" COLSPAN="2"><B>MIM</B></TD>
        </TR>
        <TR>
          <TD VALIGN="MIDDLE"><B>Short form</B></TD>
          <TD VALIGN="MIDDLE"><B>Long form</B></TD>
        </TR>
        <TR>
          <TD VALIGN="MIDDLE">HTML version</TD>
          <TD VALIGN="MIDDLE"><A HREF="{$arm}">ARM EXPRESS</A></TD>
          <TD VALIGN="MIDDLE"><A HREF="{$mim}">MIM SF EXPRESS</A></TD>
          <TD VALIGN="MIDDLE"><A HREF="{$mim_lf}">MIM LF EXPRESS</A></TD>
        </TR>
        <TR>
          <TD VALIGN="MIDDLE">Text version</TD>
          <TD VALIGN="MIDDLE"><A HREF="../arm.exp">ARM EXPRESS text</A></TD>
          <TD VALIGN="MIDDLE"><A HREF="../mim.exp">MIM SF EXPRESS text</A></TD>
          <TD VALIGN="MIDDLE"><A HREF="../mim_lf.exp">MIM LF EXPRESS text</A></TD>
        </TR>
      </TABLE>
    </CENTER>

    <UL>
      <LI><A HREF="short_names.txt">Short Names</A></LI>
    </UL>

    <P>
      If there is difficulty accessing these sites, contact ISO Central
      Secretariat or contact the ISO TC184/SC4 Secretariat directly at:
      sc4sec@cme.nist.gov.
    </P>

    <BLOCKQUOTE>
      NOTE The information provided in computer-interpretable form at the
      above URLs is informative. The information that is contained in the body of
      this part of ISO 10303 is normative. 
    </BLOCKQUOTE>

</xsl:template>


<xsl:template match="arm">
  <xsl:call-template name="clause_header">
    <xsl:with-param name="heading" select="'4 Information requirements'"/>
    <xsl:with-param name="aname" select="'arm'"/>
  </xsl:call-template>
  <xsl:variable name="c_expg"
    select="concat('./c_arm_expg',$FILE_EXT)"/>
  <xsl:variable name="sect51" 
    select="concat('./5_mim',$FILE_EXT)"/>

  <p>
    This clause specifies the information requirements for 
    <xsl:value-of select="../@name"/>
    module.
  </p>
  <p>
    The information requirements are specified as a set of units of
    functionality, objects. The information requirements are defined using the
    terminology of the subject area of this application module.
  </p>
  <blockquote>
    NOTE 1 A graphical representation of the information requirements is
    given in 
    <a href="{$c_expg}">Annex C</a>.
  </blockquote>

  <blockquote>
    NOTE 2 The mapping specification is specified in 
    <a href="{$sect51}#mapping">5.1</a> which shows how
    the information requirements are met using the integrated resources of ISO
    10303. The use of the integrated resources introduces additional
    requirements which are common to application modules and application
    protocols. 
  </blockquote>

  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="../@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="arm_xml"
    select="concat($module_dir,'/arm.xml')"/>

  <!-- there is only one schema in a module -->
  <xsl:variable 
    name="schema_name" 
    select="document($arm_xml)/express/schema/@name"/>

  <xsl:variable name="xref">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>

  <code>
    <u>EXPRESS specification: </u>
    <br/>    <br/>
    *)
    <br/>    <br/>
    <a name="{$xref}">
      SCHEMA <xsl:value-of select="concat($schema_name,';')"/>
  </a>
  <br/>    <br/>
    (*
  </code>

  <a name="uof">
    <h3>4.1 Units of functionality</h3>
  </a>
  This subclause specifies the units of functionality (UoF) for this part
  ISO 10303 as well as any support elements needed for the application module
  definition. This part of ISO 10303 specifies the following units of
  functionality:    
  <ul>
    <xsl:apply-templates select="uof" mode="toc"/>
  </ul>
  <!-- output any UoFs in other modules -->
  <xsl:choose>
    <xsl:when test="(./uoflink)">
      <p>
        This part of ISO 10303 uses the following units of functionality:
      </p>
      <ul>
        <xsl:apply-templates select="./uoflink"/>
      </ul>
    </xsl:when>
    <xsl:otherwise>
      <p>
        This part of ISO 10303 uses no other units of functionality. 
      </p>        
    </xsl:otherwise>
  </xsl:choose>
  <p>
    The units of functionality and a description of the functions that
    each UoF supports are given below.  
  </p>
  
  <xsl:apply-templates select="uof" mode="uof_toc"/>

  <!-- output all the EXPRESS specifications -->
  <!-- display the EXPRESS for the interfaces in the ARM.
       The template is in sect4_express.xsl -->
  <xsl:apply-templates 
    select="document($arm_xml)/express/schema/interface"/>

  <!-- display the constant EXPRESS. The template is in sect4_express.xsl -->
  <xsl:apply-templates 
    select="document($arm_xml)/express/schema/constant"/>

  <!-- display the EXPRESS for the types in the schema.
       The template is in sect4_express.xsl -->
  <xsl:apply-templates 
    select="document($arm_xml)/express/schema/type"/>
  
  <!-- display the EXPRESS for the entities in the ARM.
       The template is in sect4_express.xsl -->
  <xsl:apply-templates 
    select="document($arm_xml)/express/schema/entity"/>

  <!-- display the EXPRESS for the functions in the ARM
       The template is in sect4_express.xsl -->
  <xsl:apply-templates 
    select="document($arm_xml)/express/schema/function"/>

  <!-- display the EXPRESS for the entities in the ARM. 
       The template is in sect4_express.xsl -->
  <xsl:apply-templates 
    select="document($arm_xml)/express/schema/rule"/>

  <!-- display the EXPRESS for the procedures in the ARM. 
       The template is in sect4_express.xsl -->
  <xsl:apply-templates 
    select="document($arm_xml)/express/schema/procedure"/>

  
  <code>
    <br/>    <br/>
    *)
    <br/>    <br/>
    END_SCHEMA;
    <br/>    <br/>
    (*
  </code>

</xsl:template>
<xsl:template match="uof" mode="toc">
  <xsl:variable name="href" select="concat('#uof',@name)"/>
  <li>
    <a href="{$href}">
      <xsl:choose>
        <xsl:when test="position()!=last()">
          <xsl:value-of select="concat(@name,';')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat(@name,'.')"/>        
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </li>
</xsl:template>

<xsl:template match="uoflink">
  <li>
    <xsl:choose>
      <xsl:when test="position()!=last()">
        <xsl:value-of select="concat(@linkend,';')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat(@linkend,'.')"/>        
      </xsl:otherwise>
    </xsl:choose>
  </li>
</xsl:template>

<xsl:template match="uof" mode="uof_toc">
  <h3>
    <xsl:variable name="name" select="concat('uof',@name)"/>
    <a name="{$name}">
      <xsl:value-of select="concat('4.1.',position(),' ',@name)"/>
    </a>
  </h3>
  <!-- The <xsl:value-of select="@name"/> UoF specifies -->
  <xsl:apply-templates select="description"/>

  <p>
    The following application objects are defined in the
    <xsl:value-of select="@name"/> UoF: 
  </p>

  <ul>
    <xsl:apply-templates select="uof.ae"/>
  </ul>

</xsl:template>

<xsl:template match="uof.ae">
  <li>
    <xsl:choose>
      <xsl:when test="position()!=last()">
        <xsl:value-of select="concat(@entity,';')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat(@entity,'.')"/>        
      </xsl:otherwise>
    </xsl:choose>
  </li>
</xsl:template>




<xsl:template match="mim">
  <xsl:call-template name="clause_header">
    <xsl:with-param name="heading" select="'5 Module interpreted model'"/>
    <xsl:with-param name="aname" select="'mim'"/>
  </xsl:call-template>

  <h3>
    <a name="mapping">5.1 Mapping specification</a>
  </h3>
  <xsl:apply-templates select="../mapping_table" mode="toc"/>

  <h3>
    <a name="mim_express">5.2 MIM EXPRESS short listing</a>
  </h3>
  <p>
    This clause specifies the EXPRESS schema that uses elements from the
    integrated resources, application interpreted constructs or application
    modules and contains the types, entity specializations, rules, and
    functions that are specific to this part of ISO 10303. This clause also
    specifies modifications to the textual material for constructs that are
    imported from the integrated resources. The definitions and EXPRESS
    provided in the integrated resources or application interpreted constructs
    for constructs used in the MIM may include select list items and subtypes
    which are not imported into the MIM. Requirements stated in the integrated
    resources or application interpreted constructs which refer to such items
    and subtypes apply exclusively to those items which are imported into the
    MIM. 
  </p>

  <!-- output all the EXPRESS specifications -->
  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="../@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable 
    name="mim_xml"
    select="concat($module_dir,'/mim.xml')"/>

  <xsl:variable 
    name="schema_name" 
    select="document($mim_xml)/express/schema/@name"/>


  <xsl:variable name="xref">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>

  <code>
    <u>EXPRESS specification: </u>
    <br/>    <br/>
    *)
    <br/>    <br/>
    <a name="{$xref}">
      SCHEMA <xsl:value-of select="concat($schema_name,';')"/>
  </a>
    <br/>    <br/>
    (*
  </code>


  <!-- display the EXPRESS for the interfaces in the MIM.
       The template is in sect4_express.xsl -->
  <!-- there is only one schema in a module -->
  <xsl:apply-templates 
    select="document($mim_xml)/express/schema/interface"/>

  <!-- display the constant EXPRESS. The template is in sect4_express.xsl -->
  <xsl:apply-templates 
    select="document($mim_xml)/express/schema[@name=$schema_name]/constant"/>

  <!-- display the EXPRESS for the types in the schema.
       The template is in sect4_express.xsl -->
  <xsl:apply-templates 
    select="document($mim_xml)/express/schema/type"/>

  
  <!-- display the EXPRESS for the entities in the MIM.
       The template is in sect4_express.xsl -->
  <xsl:apply-templates 
    select="document($mim_xml)/express/schema/entity"/>

  <!-- display the EXPRESS for the functions in the MIM
       The template is in sect4_express.xsl -->
  <xsl:apply-templates 
    select="document($mim_xml)/express/schema/function"/>

  <!-- display the EXPRESS for the entities in the MIM. 
       The template is in sect4_express.xsl -->
  <xsl:apply-templates 
    select="document($mim_xml)/express/schema/rule"/>

  <!-- display the EXPRESS for the procedures in the MIM. 
       The template is in sect4_express.xsl -->
  <xsl:apply-templates 
    select="document($mim_xml)/express/schema/procedure"/>

  <code>
    <br/>    <br/>
    *)
    <br/>    <br/>
    END_SCHEMA;
    <br/>    <br/>
    (*
  </code>

</xsl:template>

<xsl:template match="mapping_table" mode="toc">
    <xsl:apply-templates select="ae" mode="toc"/> 
</xsl:template>

<!-- Output the application element table of contents for the mapping table
     -->
<xsl:template match="ae" mode="toc">
  <xsl:variable name="xref" 
    select="concat('5_mapping',$FILE_EXT,'#',@entity)"/>
  <xsl:variable name="sect_no">
    <xsl:number/>
  </xsl:variable>
  <h3>
    <xsl:value-of select="concat('5.1.',$sect_no,' ')"/>
    <a href="{$xref}"><xsl:value-of select="@entity"/></a>
  </h3>
</xsl:template>





<!-- build a list of normrefs that are used by the module.
     The list comprises:
     All default normrefs listed in ../data/basic/normrefs.xml
     All normrefs explicitly included in the module by normref.inc
     All normrefs that define terms for which abbreviations are provided
     All modules referenced by a USE FROM in the ARM
     All modules referenced by a USE FROM in the MIM
     All integrated resources referenced by a USE FROM in the MIM
-->
<xsl:template name="normrefs_list">

  <!-- get all default normrefs listed in ../data/basic/normrefs.xml -->
  <xsl:variable name="normref_list1">
    <xsl:call-template name="get_normref">
      <xsl:with-param 
        name="normref_nodes" 
        select="document('../data/basic/normrefs_default.xml')/normrefs/normref.inc"/>
      <xsl:with-param 
        name="normref_list" 
        select="''"/>
    </xsl:call-template>    
  </xsl:variable>

  <!--
  <xsl:message>
    l1:<xsl:value-of select="$normref_list1"/>:l1
  </xsl:message>
  -->

  <!-- get all normrefs explicitly included in the module by normref.inc -->
  <xsl:variable name="normref_list2">
    <xsl:call-template name="get_normref">
      <xsl:with-param 
        name="normref_nodes" 
        select="/module/normrefs/normref.inc"/>
      <xsl:with-param 
        name="normref_list" 
        select="$normref_list1"/>
    </xsl:call-template>    
  </xsl:variable>

  <!--
  <xsl:message>
    l2:<xsl:value-of select="$normref_list2"/>:l2
  </xsl:message>
  -->

  <!-- get all normrefs that define terms for which abbreviations are
       provided.
       Get the abbreviation.inc from abbreviations_default.xml, 
       get the referenced abbreviation from abbreviations.xml
       then get the normref in which the term is defined
       -->
  <xsl:variable name="normref_list3">
    <xsl:call-template name="get_normrefs_from_abbr">
      <xsl:with-param 
        name="abbrvinc_nodes" 
        select="document('../data/basic/abbreviations_default.xml')/abbreviations/abbreviation.inc"/>
      <xsl:with-param 
        name="normref_list" 
        select="$normref_list2"/>
    </xsl:call-template>    
  </xsl:variable>

  <!--
  <xsl:message>
    l3:<xsl:value-of select="$normref_list3"/>:l3
  </xsl:message>
  -->

  <!-- get all modules referenced by a USE FROM in the ARM -->
  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="/module/@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="arm_xml"
    select="concat($module_dir,'/arm.xml')"/>

  <xsl:variable name="normref_list4">
    <xsl:call-template name="get_normrefs_from_schema">
      <xsl:with-param 
        name="interface_nodes" 
        select="document($arm_xml)/express/schema/interface"/>
      <xsl:with-param 
        name="normref_list" 
        select="$normref_list3"/>
    </xsl:call-template>
  </xsl:variable>

  <!--
  <xsl:message>
    l4:<xsl:value-of select="$normref_list4"/>:l4
  </xsl:message>
  -->

  <!-- get all modules referenced by a USE FROM in the MIM -->
  <xsl:variable name="mim_xml"
    select="concat($module_dir,'/mim.xml')"/>

  <xsl:variable name="normref_list5">
    <xsl:call-template name="get_normrefs_from_schema">
      <xsl:with-param 
        name="interface_nodes" 
        select="document($mim_xml)/express/schema/interface"/>
      <xsl:with-param 
        name="normref_list" 
        select="$normref_list4"/>
    </xsl:call-template>
  </xsl:variable>

  <!--
  <xsl:message>
    l5:<xsl:value-of select="$normref_list5"/>:l5
  </xsl:message>
  -->
  <xsl:value-of select="concat($normref_list5,',')"/>

</xsl:template>

<!-- given a list of normref nodes, add the ids of the normrefs to the
     normref_list, if not already a member. ids in normref_list are
     separated by a , -->
<xsl:template name="get_normref">
  <xsl:param name="normref_nodes"/>
  <xsl:param name="normref_list"/>
  
  <xsl:variable name="normref_list_ret">
    <xsl:choose>
      <xsl:when test="$normref_nodes">

        <xsl:variable name="first">
          <xsl:choose>
            <xsl:when test="$normref_nodes[1]/@normref">
              <xsl:value-of 
                select="concat('normref:',$normref_nodes[1]/@normref)"/>
            </xsl:when>
            <xsl:when test="$normref_nodes[1]/@module.name">
              <xsl:value-of 
                select="concat('module:',$normref_nodes[1]/@module.name)"/>
            </xsl:when>            
            <xsl:when test="$normref_nodes[1]/@resource.name">
              <xsl:value-of 
                select="concat('module:',$normref_nodes[1]/@resource.name)"/>
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
          <xsl:with-param 
            name="normref_nodes" 
            select="$normref_nodes[position()!=1]"/>
          <xsl:with-param 
            name="normref_list" 
            select="$normref_list1"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- end of recursion -->
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
        <xsl:variable name="abbr" 
          select="document('../data/basic/abbreviations.xml')/abbreviation.list/abbreviation[@id=$abbr.inc]"/>


        <xsl:variable name="first">
          <xsl:choose>
            <xsl:when test="$abbr/term.ref/@normref">
              <xsl:value-of 
                select="concat('normref:',$abbr/term.ref/@normref)"/>
            </xsl:when>
            <xsl:when test="$abbr/term.ref/@module.name">
              <xsl:value-of 
                select="concat('module:',$abbr/term.ref/@module.name)"/>
            </xsl:when>            
            <xsl:when test="$abbr/term.ref/@resource.name">
              <xsl:value-of 
                select="concat('module:',$abbr/term.ref/@resource.name)"/>
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
          <xsl:with-param 
            name="abbrvinc_nodes" 
            select="$abbrvinc_nodes[position()!=1]"/>
          <xsl:with-param 
            name="normref_list" 
            select="$normref_list1"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- end of recursion -->
        <xsl:value-of select="$normref_list"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:value-of select="$normref_list_ret"/>

</xsl:template>


<!-- 
     given a list of interface nodes defined in an express schema,
     add the names of the modules referenced by the interface to the list
     of normative references.
     -->
<xsl:template name="get_normrefs_from_schema">
  <xsl:param name="interface_nodes"/>
  <xsl:param name="normref_list"/>

  <xsl:variable name="normref_list_ret">
    <xsl:choose>
      <xsl:when test="$interface_nodes">
        <xsl:variable name="schema" select="$interface_nodes[1]/@schema"/>
        <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
        <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
        <xsl:variable name="schema_lcase"
          select="translate($schema,$UPPER, $LOWER)"/>
        
        <xsl:variable name="module_name">
          <xsl:choose>
            <xsl:when test="contains($schema_lcase,'_arm')">
              <xsl:value-of 
                select="concat('module:',substring-before($schema_lcase,'_arm'))"/>
            </xsl:when>
            <xsl:when test="contains($schema_lcase,'_mim')">
              <xsl:value-of 
                select="concat('module:',substring-before($schema_lcase,'_mim'))"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of 
                select="concat('resource:',$schema_lcase)"/>          
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
          <xsl:with-param 
            name="interface_nodes" 
            select="$interface_nodes[position()!=1]"/>
          <xsl:with-param 
            name="normref_list" 
            select="$normref_list1"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- end of recursion -->
        <xsl:value-of select="$normref_list"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$normref_list_ret"/>
</xsl:template>


<!-- add a normref id to the set of normref ids. -->
<xsl:template name="add_normref">
  <xsl:param name="normref"/>
  <xsl:param name="normref_list"/>
  <!-- end the list with a , -->
  <xsl:variable name="normref_list_term"
    select="concat($normref_list,',')"/>
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
</xsl:template>
     



<!-- Output the standard set of normative references and then any added by
     the module
     -->
<xsl:template match="normrefs">
  <h3>2 Normative references</h3>
  The following normative documents contain provisions which, through
  reference in this text, constitute provisions of this International
  Standard. For dated references, subsequent amendments to, or revisions of,
  any of these publications do not apply. However, parties to agreements
  based on this International Standard are encouraged to investigate the
  possibility of applying the most recent editions of the normative documents
  indicated below. For undated references, the latest edition of the
  normative document referred to applies. Members of ISO and IEC maintain
  registers of currently valid International Standards. 

  <!-- output the normative reference explicitly defined in the module -->
  <xsl:apply-templates select="./normref"/>

  <!-- output the default normative reference and any implicit in the
       module through the ARM and MIM -->
  <xsl:call-template name="output_normrefs"/>

</xsl:template>


<!-- output the default normative reference and any implicit in the
     module through the ARM and MIM -->
<xsl:template name="output_normrefs">
  <xsl:variable name="normrefs">
    <xsl:call-template name="normrefs_list"/>
  </xsl:variable>

  <xsl:call-template name="output_normrefs_rec">
    <xsl:with-param name="normrefs" select="$normrefs"/>
  </xsl:call-template>  

  <!-- output a footnote to say that the normative reference has not been
       published -->
  <xsl:call-template name="output_unpublished_normrefs">
    <xsl:with-param name="normrefs" select="$normrefs"/>
  </xsl:call-template>
  
</xsl:template>

<xsl:template name="output_normrefs_rec">
  <xsl:param name="normrefs"/>
  <xsl:choose>
    <xsl:when test="$normrefs">
      <xsl:variable 
        name="first"
        select="substring-before(substring-after($normrefs,','),',')"/>
      <xsl:variable 
        name="rest"
        select="substring-after(substring-after($normrefs,','),',')"/>      

      <xsl:choose>
        <xsl:when test="contains($first,'normref:')">
          <xsl:variable 
            name="normref" 
            select="substring-after($first,'normref:')"/>
          <xsl:apply-templates 
            select="document('../data/basic/normrefs.xml')/normref.list/normref[@id=$normref]"/>
        </xsl:when>

        <xsl:when test="contains($first,'module:')">
          <xsl:variable 
            name="module" 
            select="substring-after($first,'module:')"/>

          <xsl:variable name="module_dir">
            <xsl:call-template name="module_directory">
              <xsl:with-param name="module" select="$module"/>
            </xsl:call-template>
          </xsl:variable>

          <xsl:variable name="module_xml" 
            select="concat($module_dir,'/module.xml')"/>

          <!-- output the normative reference derived from the module -->
          <xsl:apply-templates 
            select="document($module_xml)/module" mode="normref"/>

        </xsl:when>

        <xsl:when test="contains($first,'resource:')">
          <xsl:variable 
            name="resource" 
            select="substring-after($first,'resource:')"/>
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
    <!-- end of recursion -->
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
      <xsl:when test="/module/normrefs/normref/stdref[@published='n']">
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
    <p>1) To be published.</p>
  </xsl:if>
</xsl:template>

<xsl:template name="output_unpublished_normrefs_rec">
  <xsl:param name="normrefs"/>

  <xsl:choose>
    <xsl:when test="$normrefs">
      <xsl:variable 
        name="first"
        select="substring-before(substring-after($normrefs,','),',')"/>
      <xsl:variable 
        name="rest"
        select="substring-after(substring-after($normrefs,','),',')"/>      
      
      <xsl:variable name="footnote">
        <xsl:choose>
          <xsl:when test="contains($first,'normref:')">
            <xsl:variable 
              name="normref" 
              select="substring-after($first,'normref:')"/>
            <xsl:choose>
              <xsl:when
test="document('../data/basic/normrefs.xml')/normref.list/normref[@id=$normref]/stdref[@published='n']">
                <xsl:value-of select="'y'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'n'"/>
              </xsl:otherwise>
            </xsl:choose>

          </xsl:when>

          <xsl:when test="contains($first,'module:')">
            <xsl:variable 
              name="module" 
              select="substring-after($first,'module:')"/>
            
            <xsl:variable name="module_dir">
              <xsl:call-template name="module_directory">
                <xsl:with-param name="module" select="$module"/>
              </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="module_xml" 
              select="concat($module_dir,'/module.xml')"/>

            <xsl:choose>
              <xsl:when test="document($module_xml)/module[@published='n']">
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
          <!-- only recurse if no unpublished standard found -->      
          <xsl:call-template name="output_unpublished_normrefs_rec">
            <xsl:with-param name="normrefs" select="$rest"/>
          </xsl:call-template>        
        </xsl:when>
        <xsl:otherwise>
          <!-- footnote found so stop -->
          <xsl:value-of select="'y'"/>
        </xsl:otherwise>
      </xsl:choose>
      
    </xsl:when>
    <xsl:otherwise>
      <!-- end of recursion -->
      <!-- <xsl:value-of select="$footnote"/> -->
      <xsl:value-of select="'n'"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<!-- get the normrefs out of the normrefs.xml database -->
<xsl:template match="normref.inc">
  <xsl:variable name="ref" select="@ref"/>
  <xsl:apply-templates 
    select="document('../data/basic/normrefs.xml')/normref.list/normref[@id=$ref]"/>
</xsl:template>

<xsl:template name="output_resource_normref">
  <xsl:param name="resource_schema"/>
  <p>
    <xsl:call-template name="error_message">
      <xsl:with-param name="message">
        <xsl:value-of select="concat('XSL not implemented - MIM uses schema', 
                              $resource_schema, 
                              'Need to include Integrated resource that
defines it. Use: normref.inc')"/>
      </xsl:with-param>
    </xsl:call-template>
  </p>
</xsl:template>

<xsl:template match="module" mode="normref">
  <p>

    <xsl:variable name="part">
      <xsl:choose>
        <xsl:when test="string-length(@part)>0">
          <xsl:value-of select="@part"/>
        </xsl:when>
        <xsl:otherwise>
          &lt;part&gt;
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="stdnumber">
      <xsl:call-template name="get_module_stdnumber">
        <xsl:with-param name="module" select="."/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="orgname" select="'ISO'"/>
    <xsl:variable name="stdtitle"
      select="concat('Industrial automation systems and integration',
              '- Product data representation and exchange')"/>
    <xsl:variable name="subtitle"
      select="concat('- Part ',$part,': Application module ', @name)"/>
    
    <xsl:value-of select="$orgname"/>
    <xsl:value-of select="$stdnumber"/>

    <xsl:if test="@published='n'">
      <sup>1</sup>
    </xsl:if>
    <i>
      <xsl:value-of select="$stdtitle"/>
      <xsl:value-of select="$subtitle"/>
    </i>
  </p>
</xsl:template>

<!-- Output the normative reference -->
<xsl:template match="normref">
  <p>
    <xsl:value-of select="stdref/orgname"/>
    <xsl:value-of select="stdref/stdnumber"/>
    <xsl:if test="stdref[@published='n']">
      <sup>1</sup>
    </xsl:if>
    <i>
      <xsl:value-of select="stdref/stdtitle"/>
      <xsl:value-of select="stdref/subtitle"/>
    </i>
  </p>
</xsl:template>


<!-- Output the standard set of abbreviations and then any added by
     the module
     -->
<xsl:template name="output_abbreviations">
  <xsl:param name="section"/>
  <xsl:if test="/module/abbreviations">
    <h3>
      <xsl:value-of select="concat('3.',$section)"/> Abbreviations
    </h3>
    <xsl:apply-templates select="/module/abbreviations" mode="output"/>
  </xsl:if>
</xsl:template>

  

<!-- Output the standard set of abbreviations and then any added by
     the module
     -->
<xsl:template match="abbreviations" mode="output">
  <p>
    For the purposes of this part of ISO 10303, the following abbreviations
    apply:
  </p>
  <table width="80%">
  <!-- get the default abbreviations out of the abbreviations_default.xml
       database -->
  <xsl:apply-templates 
    select="document('../data/basic/abbreviations_default.xml')/abbreviations/abbreviation.inc"/>

  <!-- output any abbreviations defined in the module-->
  <xsl:apply-templates select="/module/abbreviations/abbreviation"/>

  <!-- output any abbreviations defined in the module-->
  <xsl:apply-templates select="/module/abbreviations/abbreviation.inc"/>

  </table>
</xsl:template>

<!-- get the abbreviations out of the abbreviations.xml database -->
<xsl:template match="abbreviation.inc">
  <xsl:variable name="ref" select="@linkend"/>
  <xsl:variable 
    name="abbrev" 
    select="document('../data/basic/abbreviations.xml')/abbreviation.list/abbreviation[@id=$ref]"/>
  <xsl:choose>
    <xsl:when test="$abbrev">
      <xsl:apply-templates select="$abbrev"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="error_message">
        <xsl:with-param name="message">
          <xsl:value-of select="concat('abbreviation.inc ',$ref, 'not found: ')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>


<!-- output the abbreviation. The term is defined in the normative
     references -->
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
  <xsl:variable 
    name="term"
    select="document('../data/basic/normrefs.xml')/normref.list/normref/term[@id=$termref]"/>
  <xsl:choose>
    <xsl:when test="$term">
      <xsl:value-of select="$term"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="error_message">
        <xsl:with-param name="message">
          <xsl:value-of select="concat('term.ref ',$termref, 'not found: ')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="term" mode="abbreviation">
  <xsl:value-of select="."/>
</xsl:template>

<!-- output the normative references, terms, definitions and abbreviations -->
<xsl:template name="output_terms">
  <!-- get a list of normative references that have terms defined -->
  <xsl:variable name="normrefs">
    <xsl:call-template name="normrefs_terms_list"/>
  </xsl:variable>

  <!-- output the included terms -->
  <xsl:call-template name="output_normrefs_terms_rec">
    <xsl:with-param name="normrefs" select="$normrefs"/>
    <xsl:with-param name="section" select="0"/>
  </xsl:call-template>

  <xsl:variable name="def_section">
    <xsl:call-template name="length_normrefs_list">
      <xsl:with-param name="normrefs_list" select="$normrefs"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- output any definitions defined in this module -->
  <xsl:if test="/module/definition">
    <!-- output the section head first -->
    <xsl:call-template name="output_module_term_section">
      <xsl:with-param name="module" select="/module"/>
      <xsl:with-param name="section" select="concat('3.',$def_section+1)"/>
    </xsl:call-template>
    For the purposes of this part of ISO 10303, 
    the following definitions apply:
  </xsl:if>

  <!-- increment the section number depending on whether a definition
       section has been output -->
  <xsl:variable name="def_section1">
    <xsl:choose>
      <xsl:when test="/module/definition">
        <xsl:value-of select="$def_section+1"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$def_section"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:apply-templates select="/module/definition">
    <xsl:with-param name="section" select="concat('3.',$def_section1)"/>
  </xsl:apply-templates>

  <xsl:call-template name="output_abbreviations">
    <xsl:with-param name="section" select="$def_section1+1"/>
  </xsl:call-template>
</xsl:template>


<!-- Given a list of normative references, output any terms from them -->
<xsl:template name="output_normrefs_terms_rec">
  <xsl:param name="normrefs"/>
  <xsl:param name="section"/>
  <xsl:choose>
    <xsl:when test="$normrefs">

      <xsl:variable 
        name="first"
        select="substring-before(substring-after($normrefs,','),',')"/>
      <xsl:variable 
        name="section_no"
        select="$section+1"/>
      <xsl:variable 
        name="rest"
        select="substring-after(substring-after($normrefs,','),',')"/>      

      <xsl:choose>
        <xsl:when test="contains($first,'normref:')">
          <xsl:variable 
            name="ref" 
            select="substring-after($first,'normref:')"/>
          <xsl:variable 
            name="normref"
            select="document('../data/basic/normrefs.xml')/normref.list/normref[@id=$ref]"/>

          <!-- get the number of the standard -->      
          <xsl:variable name="stdnumber" select="$normref/stdref/stdnumber"/>
          
          <!-- output the section header for the normative reference that is
               defining terms -->
          
          <h3>
            <xsl:value-of select="concat('3.',$section_no,
                                  ' Terms defined in ', $stdnumber)"/>
          </h3>
          For the purposes of this part of ISO 10303, 
          the following terms defined in 
          <xsl:value-of select="$stdnumber"/>
          apply:
          <ul>
            <!-- now output the terms -->
            <xsl:apply-templates 
              select="document('../data/basic/normrefs_default.xml')/normrefs/normref.inc[@normref=$ref]/term.ref" mode="normref"/>
            <xsl:apply-templates 
              select="/module/normrefs/normref.inc[@normref=$ref]/term.ref"
               mode="normref"/>
          </ul>
        </xsl:when>

        <!-- a term defined in another module -->
        <xsl:when test="contains($first,'module:')">
          <xsl:variable 
            name="module" 
            select="substring-after($first,'module:')"/>

          <xsl:variable name="module_dir">
            <xsl:call-template name="module_directory">
              <xsl:with-param name="module" select="$module"/>
            </xsl:call-template>
          </xsl:variable>

          <xsl:variable name="module_xml" 
            select="concat($module_dir,'/module.xml')"/>

          <xsl:variable name="stdnumber">
            <xsl:call-template name="get_module_stdnumber">
              <xsl:with-param name="module" select="document($module_xml)/module"/>
            </xsl:call-template>
          </xsl:variable>

          <!-- output the section header for the normative reference that is
               defining terms -->
          
          <h3>
            <xsl:value-of select="concat('3.',$section_no,
                                  ' Terms defined in ', $stdnumber)"/>
          </h3>
          For the purposes of this part of ISO 10303, 
          the following terms defined in 
          <xsl:value-of select="$stdnumber"/>
          apply:
          <ul>
            <!-- now output the terms -->
            <xsl:apply-templates 
              select="/module/normrefs/normref.inc[@module.name=$module]/term.ref" 
              mode="module"/>
          </ul>
          

        </xsl:when>

        <xsl:when test="contains($first,'resource:')">
          <xsl:variable 
            name="resource" 
            select="substring-after($first,'resource:')"/>
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

  <!-- get all default normrefs listed in ../data/basic/normrefs.xml -->
  <xsl:variable name="normref_list1">
    <xsl:call-template name="get_normref_term">
      <xsl:with-param 
        name="normref_nodes" 
        select="document('../data/basic/normrefs_default.xml')/normrefs/normref.inc"/>
      <xsl:with-param 
        name="normref_list" 
        select="''"/>
    </xsl:call-template>    
  </xsl:variable>

  <!-- get all normrefs explicitly included in the module by normref.inc -->
  <xsl:variable name="normref_list2">
    <xsl:call-template name="get_normref_term">
      <xsl:with-param 
        name="normref_nodes" 
        select="/module/normrefs/normref.inc"/>
      <xsl:with-param 
        name="normref_list" 
        select="$normref_list1"/>
    </xsl:call-template>    
  </xsl:variable>

  <!-- get all normrefs that define terms for which abbreviations are
       provided.
       Get the abbreviation.inc from abbreviations_default.xml, 
       get the referenced abbreviation from abbreviations.xml
       then get the normref in which the term is defined

  <xsl:variable name="normref_list3">
    <xsl:call-template name="get_normrefs_from_abbr">
      <xsl:with-param 
        name="abbrvinc_nodes" 
        select="document('../data/basic/abbreviations_default.xml')/abbreviations/abbreviation.inc"/>
      <xsl:with-param 
        name="normref_list" 
        select="$normref_list2"/>
    </xsl:call-template>    
  </xsl:variable>

  <xsl:message>
    l3:<xsl:value-of select="$normref_list3"/>:l3
  </xsl:message>
  -->

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
                <xsl:when test="$normref_nodes[1]/@module.name">
                  <xsl:value-of 
                    select="concat('module:',$normref_nodes[1]/@module.name)"/>
                </xsl:when>            
                <xsl:when test="$normref_nodes[1]/@resource.name">
                  <xsl:value-of 
                    select="concat('module:',$normref_nodes[1]/@resource.name)"/>
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

<!-- return the number of normrefs in the list -->
<xsl:template name="length_normrefs_list">
  <xsl:param name="normrefs_list"/>
  <xsl:variable name="section1">
    <xsl:call-template name="count_substring">
      <xsl:with-param name="substring" select="','"/>
      <xsl:with-param name="string" select="$normrefs_list"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="floor($section1 div 2)"/>
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
          <font color="#FF0000">
            &lt;publication.year&gt;
          </font>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="orgname" select="'ISO'"/>
    <xsl:variable name="stdnumber"
      select="concat('10303-',$part,':',$pub_year,'(',$language,') ')"/>
    <xsl:value-of select="$stdnumber"/>
</xsl:template>



<!-- output the section header for terms defined in a module -->
<xsl:template name="output_module_term_section">
  <xsl:param name="module"/>
  <xsl:param name="section"/>
  
  <xsl:variable name="stdnumber">
    <xsl:call-template name="get_module_stdnumber">
      <xsl:with-param name="module" select="$module"/>
    </xsl:call-template>
  </xsl:variable>
  <h3><xsl:value-of select="concat($section,' Terms defined in ',$stdnumber)"/></h3>
  </xsl:template>


  <xsl:template match="term.ref" mode="module">
    <xsl:variable name="module" select="../@module.name"/>

    <xsl:variable name="module_dir">
      <xsl:call-template name="module_directory">
        <xsl:with-param name="module" select="$module"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="module_xml" 
      select="concat($module_dir,'/module.xml')"/>

    <xsl:variable 
      name="ref"
      select="@linkend"/>
    <xsl:variable 
      name="term"
      select="document($module_xml)/module/definition/term[@id=$ref]"/>

    <xsl:choose>
      <xsl:when test="$term">
        <li><xsl:apply-templates select="$term"/></li>
      </xsl:when>
      <xsl:otherwise>
        <li>
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message"
              select="concat('Can not find term referenced by: ',$ref)"/>
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
      select="document('../data/basic/normrefs.xml')/normref.list/normref/term[@id=$ref]"/>
    <xsl:choose>
      <xsl:when test="$term">
        <li><xsl:apply-templates select="$term"/></li>
      </xsl:when>
      <xsl:otherwise>
        <li>
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message"
              select="concat('Can not find term referenced by: ',$ref)"/>
          </xsl:call-template>
        </li>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="definition">
    <xsl:param name="section"/>
    <h4>
      <xsl:value-of select="$section"/>.<xsl:number/>
      <xsl:apply-templates select="term"/>
    </h4>
    <xsl:apply-templates select="def"/>
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
  <xsl:variable name="number">
    <xsl:number/>
  </xsl:variable>
  <xsl:variable name="fig_no">
    <xsl:choose>
      <xsl:when test="name(../..)='arm'">
        <xsl:value-of 
          select="concat('Figure C.',$number, 
                  ' - ARM EXPRESS-G diagram ',$number)"/> 
      </xsl:when>
      <xsl:when test="name(../..)='mim'">
        <xsl:value-of 
          select="concat('Figure D.',$number, 
                  ' - MIM EXPRESS-G diagram ',$number)"/> 
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="file">
    <xsl:call-template name="set_file_ext">
      <xsl:with-param name="filename" select="@file"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="href" select="concat('../',$file)"/>
  <li>
    <a href="{$href}"><xsl:value-of select="$fig_no"/></a>
  </li>
</xsl:template>


<xsl:template match="bibliography">
  <!-- output the defaults -->
  <xsl:apply-templates 
    select="document('../data/basic/bibliography_default.xml')/bibliography/bibitem.inc"/>
  <xsl:apply-templates select="./bibitem"/>
  <xsl:apply-templates select="./bibitem.inc"/>
</xsl:template>

<xsl:template match="bibitem">
  <p>
    [<xsl:number/>] <xsl:apply-templates select="orgname"/>
    <xsl:apply-templates select="orgname"/>
    <xsl:apply-templates select="pubdate"/>
    <xsl:apply-templates select="stdnumber"/>
    <xsl:apply-templates select="stdtitle"/>
    <xsl:apply-templates select="stdsubtitle"/>
    <xsl:apply-templates select="ulink"/>
  </p>
</xsl:template>

<xsl:template match="bibitem.inc">
  <xsl:variable name="ref" select="@ref"/>
  <xsl:variable name="bibitem" 
    select="document('../data/basic/bibliography.xml')/bibitem.list/bibitem[@id=$ref]"/>
  

  <xsl:choose>
    <xsl:when test="$bibitem">
      <xsl:apply-templates select="$bibitem"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="error_message">
        <xsl:with-param 
          name="message"
          select="concat('Can not find bibitem referenced by: ',$ref,
                  'in ../data/basic/bibliography.xml')"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="orgname">
  <xsl:value-of select="."/>,
</xsl:template>

<xsl:template match="pubdate">
  <xsl:value-of select="."/>,
</xsl:template>

<xsl:template match="stdnumber">
  <xsl:value-of select="."/>,
</xsl:template>

<xsl:template match="subtitle">
  <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="stdtitle">
  <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="ulink">
  <xsl:variable name="href" select="."/>
  <br/><a href="{$href}"><xsl:value-of select="$href"/></a>
</xsl:template>



</xsl:stylesheet>
