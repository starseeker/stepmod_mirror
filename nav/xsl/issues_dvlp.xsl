<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: issues_dvlp.xsl,v 1.3 2003/01/10 11:46:22 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: A set of imported templates to set up a list of modules
     The importing file will define the modules template which
     displays the list of modules
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">


  <xsl:import href="../../xsl/sect_5_mapping.xsl"/>
  <xsl:import href="../../xsl/sect_4_express.xsl"/>

  <xsl:output method="html"/>

  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>

  <xsl:variable name="REPO_NODES" 
    select="document('../../repository_index.xml')"/>

  <xsl:template match="/" >
    <xsl:apply-templates select="./stylesheet_application"/>
  </xsl:template>

  <xsl:template match="stylesheet_application">
    <HTML>
    <head>
      <link rel="stylesheet" type="text/css" 
        href="../../../../nav/css/developer.css"/>
      <title>
        <xsl:value-of select="concat('XML templates for issues against ',@directory)"/>
      </title>

      <script language="JavaScript"><![CDATA[

          function swap(ShowDiv, HideDiv) {
            show(ShowDiv);
            hide(HideDiv);
          }

          function show(DivID) {
            DivID.style.display="block";
          }

          function hide(DivID) {
            DivID.style.display="none";
          }
      ]]></script>
    </head>
    <body>
    <xsl:variable 
      name="module_xml_file"
      select="concat('../../data/modules/',@directory,'/module.xml')"/>

    <xsl:variable 
      name="module_nodes"
      select="document($module_xml_file)"/>

    <div class="toc">
      <!-- output the Table of contents banner -->
      <xsl:apply-templates 
        select="$module_nodes/module"
        mode="TOCmultiplePage">
        <xsl:with-param name="module_root" select="'..'"/>
      </xsl:apply-templates>
    </div>

    <h3>Introduction</h3>
    This page provides a set of XML templates that can be used to raise
    issues against the module.
    <p>
      The issues should be added to:<br/>
      <code>
        <a href="../dvlp/issues.xml">
          <xsl:value-of
            select="concat('stepmod/data/modules/',$module_nodes/module/@name,'/dvlp/issues.xml')"/>
        </a>
      </code>
    </p>
    <p>
      Each issue has the following attributes:
    </p>
    <dl>
      <dd>
        <tt>id</tt> An identifier for the issue that is unique to the
      issues.xml file.
      </dd>
      <dd>
        <tt>category</tt> The category of issue. May be:
        <tt>editorial, minor_technical, major_technical, repository</tt>
      </dd>
      <dd>
        <tt>by</tt> The person who raised the issue.
      </dd>
      <dd>
        <tt>status</tt> The status of the issue. Either <tt>open</tt> or <tt>closed</tt>.
      </dd>
    </dl>

    <ul>
      <li><a href="#general">General issues</a></li>
      <li><a href="#keywords">Keyword issues</a></li>
      <li><a href="#contacts">Contacts issues</a></li>
      <li><a href="#purpose">Purpose issues</a></li>
      <li><a href="#inscope">Inscope issues</a></li>
      <li><a href="#outscope">Outscope issues</a></li>
      <li><a href="#normrefs">Normrefs issues</a></li>
      <li><a href="#definition">Definition issues</a></li>
      <li><a href="#abbreviations">Abbreviations issues</a></li>
      <li><a href="#arm">ARM issues</a></li>
      <li><a href="#mim">MIM issues</a></li>
      <li><a href="#mapping">Mapping issues</a></li>
    </ul>

    <a name="general">
      <h3>XML for general issues</h3>
    </a>
    The following XML constructs can be used to identify general issues
    against the module.
    <xsl:call-template name="output_issue">
      <xsl:with-param name="type" select="'general'"/>
    </xsl:call-template>

    <a name="keywords">
      <h3>XML for keywords issues - Clause: Cover page</h3>
    </a>
    The following XML constructs can be used to identify issues against
    keywords (module.xml/module/keywords).
    <xsl:call-template name="output_issue">
      <xsl:with-param name="type" select="'keywords'"/>
    </xsl:call-template>

    <a name="contacts">
      <h3>XML for contacts issues - Clause: Cover page</h3>
    </a>
    The following XML constructs can be used to identify issues against
    the module contacts  (module.xml/module/contacts)
    <xsl:call-template name="output_issue">
      <xsl:with-param name="type" select="'contacts'"/>
    </xsl:call-template>

    <a name="purpose">
      <h3>XML for introduction issues -  Clause: Introduction</h3>
    </a>
    The following XML constructs can be used to identify issues
    against the module introduction (module.xml/module/purpose).
    <xsl:call-template name="output_issue">
      <xsl:with-param name="type" select="'purpose'"/>
    </xsl:call-template>

    <a name="inscope">
      <h3>XML for inscope issues -  Clause: Scope (In scope)</h3>
    </a>
    The following XML constructs can be used to identify issues against the in scope
    statement of the module (module.xml/module/inscope).
    <xsl:call-template name="output_issue">
      <xsl:with-param name="type" select="'inscope'"/>
    </xsl:call-template>

    <a name="outscope">
      <h3>XML for inscope issues -  Clause: Scope (Out of scope)</h3>
    </a>
    The following XML constructs can be used to identify issues against the
    out of scope statement of the module (module.xml/module/outscope).
    <xsl:call-template name="output_issue">
      <xsl:with-param name="type" select="'outscope'"/>
    </xsl:call-template>

    <a name="normrefs">
      <h3>XML for Normative reference issues -  Clause: 2 Normative references</h3>
    </a>
    The following XML constructs can be used to identify issues against
    the normrefs in the module (module.xml/module/normrefs).
    <xsl:call-template name="output_issue">
      <xsl:with-param name="type" select="'normrefs'"/>
    </xsl:call-template>

    <a name="definition">
      <h3>XML for Definition issues -  Clause: 3 Terms, definitions and abbreviations </h3>
    </a>
    The following XML constructs can be used to identify issues against
    the definition in the module (module.xml/module/definition).
    <xsl:call-template name="output_issue">
      <xsl:with-param name="type" select="'definition'"/>
    </xsl:call-template>

    <a name="abbreviations">
      <h3>XML for abbreviations issues -  Clause: 3 Terms, definitions and abbreviations </h3>
    </a>
    The following XML constructs can be used to identify issues against
    the abbreviations in the module (module.xml/module/abbreviations).
    <xsl:call-template name="output_issue">
      <xsl:with-param name="type" select="'abbreviations'"/>
    </xsl:call-template>

    <a name="arm">
      <h3>XML for issues against the ARM - Clause: 4 Information requirements</h3>
    </a>

    The following XML constructs can be used to identify issues
    against the module ARM.

    <xsl:variable 
      name="arm_xml_file"
      select="concat('../../data/modules/',@directory,'/arm.xml')"/>

    <xsl:apply-templates
      select="document($arm_xml_file)/express/schema/type">
      <xsl:with-param name="arm_mim" select="'arm'"/>
      <xsl:with-param name="clause"  select="concat('../sys/4_info_reqs',$FILE_EXT)"/>
    </xsl:apply-templates>

    <xsl:apply-templates select="document($arm_xml_file)/express/schema/entity">
      <xsl:with-param name="arm_mim"  select="'arm'"/>
      <xsl:with-param name="clause" select="concat('../sys/4_info_reqs',$FILE_EXT)"/>
    </xsl:apply-templates>

    <a name="mim">
      <h3>XML for issues against the MIM - Clause: 5 Module interpreted model</h3>
    </a>
    The following XML constructs can be used to identify issues
    against the module MIM.

    <xsl:variable 
      name="mim_xml_file"
      select="concat('../../data/modules/',@directory,'/mim.xml')"/>

    <xsl:apply-templates
      select="document($mim_xml_file)/express/schema/type">
      <xsl:with-param name="arm_mim" select="'mim'"/>
      <xsl:with-param name="clause"  select="concat('../sys/5_mim',$FILE_EXT)"/>
    </xsl:apply-templates>

    <xsl:apply-templates select="document($mim_xml_file)/express/schema/entity">
      <xsl:with-param name="arm_mim"  select="'mim'"/>
      <xsl:with-param name="clause" select="concat('../sys/5_mim',$FILE_EXT)"/>
    </xsl:apply-templates>

    <a name="mapping">
      <h3>XML for issues against the mappings</h3>
    </a>
    The following XML constructs can be used to identify issues
    against the mapping.
    <xsl:apply-templates
      select="$module_nodes/module/mapping_table/ae"/>

  </body>
</HTML>
</xsl:template>



<xsl:template name="output_issue">
  <xsl:param name="type"/>
  <xsl:param name="linkend"/>
  <p class="xml">
    &lt;!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ --&gt;<br/>
    &lt;issue&#160;&#160;id=""<br/>
    &#160;&#160;type="<xsl:value-of select="$type"/>"<br/>
    <xsl:if test="string-length($linkend)>0">
      &#160;&#160;linkend="<xsl:value-of select="$linkend"/>"<br/>
    </xsl:if>
    &#160;&#160;category="editorial"<br/>
    &#160;&#160;by=""<br/>
    &#160;&#160;date=""<br/>
    &#160;&#160;status="open"<br/>
    &#160;&#160;seds="no"&gt;<br/>
    Issue description goes here.<br/>
    &lt;/issue&gt;<br/>
</p>
</xsl:template>


<xsl:template match="entity|type">
  <xsl:param name="clause"/>
  <xsl:param name="arm_mim"/>

  <xsl:variable name="clause_number">
    <xsl:call-template name="express_clause_number">
      <xsl:with-param name="clause" select="name()"/>
      <xsl:with-param name="schema_name" select="../@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="linkend" select="concat(../@name, '.', @name)"/>
  <xsl:variable name="href" 
    select="translate(concat($clause,'#',$linkend),$UPPER,$LOWER)"/>
  <p class="issuetitle">
    Clause: <a href="{$href}">
      <xsl:value-of select="concat($clause_number,'.', position(),'&#160;',@name)"/>
    </a>
  </p>
  

  <xsl:call-template name="output_issue">
    <xsl:with-param name="type" select="$arm_mim"/>
    <xsl:with-param name="linkend" select="$linkend"/>
  </xsl:call-template>

  <xsl:apply-templates select="explicit">
    <xsl:with-param name="clause" select="$clause"/>
    <xsl:with-param name="arm_mim" select="$arm_mim"/>
  </xsl:apply-templates>

  <xsl:apply-templates select="derived">
    <xsl:with-param name="clause" select="$clause"/>
    <xsl:with-param name="arm_mim" select="$arm_mim"/>
  </xsl:apply-templates>

  <xsl:apply-templates select="inverse">
    <xsl:with-param name="clause" select="$clause"/>
    <xsl:with-param name="arm_mim" select="$arm_mim"/>
  </xsl:apply-templates>

</xsl:template>


<xsl:template match="explicit|derived|inverse">
  <xsl:param name="clause"/>
  <xsl:param name="arm_mim"/>
  <xsl:variable name="linkend" 
    select="concat(../../@name,'.',../@name,'.',@name)"/>
  <xsl:variable name="href" 
    select="translate(concat($clause,'#',$linkend),$UPPER,$LOWER)"/>
  <p class="issuetitle">
    attribute: <a href="{$href}">
    <xsl:value-of select="concat(../@name,'.',@name)"/>
    </a>
  </p>
  <xsl:call-template name="output_issue">
    <xsl:with-param name="type" select="$arm_mim"/>
    <xsl:with-param name="linkend" select="$linkend"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="ae">

  <xsl:variable name="linkend" select="concat('ae entity=', @entity)"/>

  <xsl:variable name="ae_map_aname">
    <xsl:apply-templates select="." mode="map_attr_aname"/>  
  </xsl:variable>

  <xsl:variable name="href" 
    select="concat('../sys/5_mapping',$FILE_EXT,'#',$ae_map_aname)"/>

  <xsl:variable name="sect_no">
    <xsl:number/>
  </xsl:variable>

  <p class="issuetitle">
    Clause: <a href="{$href}">
      <xsl:value-of select="concat('5.1.',$sect_no,' ',@entity)"/>
    </a>
  </p>
  
  <xsl:call-template name="output_issue">
    <xsl:with-param name="type" select="mapping_table"/>
    <xsl:with-param name="linkend" select="$linkend"/>
  </xsl:call-template>

  <xsl:apply-templates select="./aa">
    <xsl:with-param name="sect" select="concat('5.1.',$sect_no)"/>
  </xsl:apply-templates>


</xsl:template>


<xsl:template match="aa">
  <xsl:param name="sect"/>

  <xsl:variable name="aa_map_aname">
    <xsl:apply-templates select="." mode="map_attr_aname"/>  
  </xsl:variable>

  <xsl:variable name="href" 
    select="concat('../sys/5_mapping',$FILE_EXT,'#',$aa_map_aname)"/>

  <xsl:variable name="sect_no" select="concat($sect,'.',position())"/>

  <xsl:variable name="title">
    <xsl:choose>
      <xsl:when test="@assertion_to">
        <xsl:value-of select="concat($sect_no,' ',../@entity,' to ', @assertion_to,' (as ',@attribute,')')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat($sect_no,' ',@attribute)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="linkend">
    <xsl:choose>
      <xsl:when test="@assertion_to">
        <xsl:value-of select="concat('ae entity=', ../@entity,' aa attribute=',@attribute,' assertion_to=',@assertion_to)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('ae entity=', ../@entity,' aa attribute=',@attribute)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <p class="issuetitle">
    Clause: 
    <a href="{$href}">
      <xsl:value-of select="$title"/>
    </a>
  </p>
  
  <xsl:call-template name="output_issue">
    <xsl:with-param name="type" select="'mapping_table'"/>
    <xsl:with-param name="linkend" select="$linkend"/>
  </xsl:call-template>

</xsl:template>

</xsl:stylesheet>
