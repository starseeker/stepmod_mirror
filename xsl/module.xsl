<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: module.xsl,v 1.10 2001/11/16 09:16:59 robbod Exp $
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
    The following are within scope of this part of ISO 10303: 
  </p>
  <ul>
    <xsl:apply-templates/>
  </ul>
</xsl:template>


<xsl:template match="outscope">
  <p>
    The following are outside the scope of this part of ISO 10303: 
  </p>
  <ul>
    <xsl:apply-templates/>
  </ul>
</xsl:template>


<xsl:template match="module" mode="annexe">
  <xsl:call-template name="clause_header">
    <xsl:with-param name="heading" select="'Annex E'"/>
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

  <h3>Computer Interpretable Listings</h3>
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
    select="concat('./sys/c_arm_expg',$FILE_EXT)"/>
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
    <a href="{$c_expg}">annex C</a>.
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

  <xsl:apply-templates select="uof" mode="toc"/>
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
  <xsl:if test="position()=1">
    <a name="uof">
      <h3>4.1 Units of functionality</h3>
    </a>
    This subclause specifies the units of functionality (UoF) for this part
    ISO 10303 as well as any support elements needed for the application module
    definition. This part of ISO 10303 specifies the following units of
    functionality:  
  </xsl:if>

  <ul>
    <li><xsl:value-of select="@name"/></li>
  </ul>

  <xsl:if test="position()=last()">
    <p>
      This part of ISO 10303 uses no other units of functionality. 
    </p>
    <p>
      The units of functionality and a description of the functions that
      each UoF supports are given below.  
    </p>
  </xsl:if>
</xsl:template>


<xsl:template match="uof" mode="uof_toc">
  <h3>
    <a name="uof">
      <xsl:value-of select="concat('4.1.',position(),' ',@name)"/>
    </a>
  </h3>
  The <xsl:value-of select="@name"/> UoF specifies 
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
  <ul>
    <xsl:apply-templates select="ae" mode="toc"/> 
  </ul>
</xsl:template>

<!-- Output the application element table of contents for the mapping table
     -->
<xsl:template match="ae" mode="toc">
  <xsl:variable name="xref" select="concat('5_mapping',$FILE_EXT,'#',@entity)"/>
  <li>
    <a href="{$xref}">
      <xsl:value-of select="@entity"/>
    </a>
  </li>
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

  <!-- get the default normrefs out of the normrefs.xml database -->
  <xsl:apply-templates 
    select="document('../data/basic/normrefs.xml')/normref.list/normref[@id='ref10303-1.1994']"/>
  <xsl:apply-templates 
    select="document('../data/basic/normrefs.xml')/normref.list/normref[@id='ref10303-11.1994']"/>
  <xsl:apply-templates 
    select="document('../data/basic/normrefs.xml')/normref.list/normref[@id='ref8824-1.1995']"/>

  <!-- output any normrefs defined in the module-->
  <xsl:apply-templates select="./normref.inc"/>
</xsl:template>

<!-- get the normrefs out of the normrefs.xml database -->
<xsl:template match="normref.inc">
  <xsl:variable name="ref" select="@ref"/>
  <xsl:apply-templates 
    select="document('../data/basic/normrefs.xml')/normref.list/normref[@id=$ref]"/>
</xsl:template>

<!-- Output the normative reference -->
<xsl:template match="normref">
  <p>
    <xsl:value-of select="stdref/orgname"/>
    <xsl:value-of select="stdref/stdnumber"/>
    <i>
      <xsl:value-of select="stdref/stdtitle"/>
      <xsl:value-of select="stdref/subtitle"/>
    </i>
  </p>
</xsl:template>

</xsl:stylesheet>
