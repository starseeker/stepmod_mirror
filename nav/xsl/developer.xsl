<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: developer.xsl,v 1.11 2003/01/08 08:26:17 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: A set of imported templates to set up a list of modules
     The importing file will define the modules template which
     displays the list of modules
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="../../xsl/module.xsl"/>

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
        <xsl:value-of select="concat('Development tips for ',@directory)"/>
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

    <xsl:call-template name="get_bib_entries">
      <xsl:with-param name="module" select="@directory"/>
    </xsl:call-template>

    <xsl:call-template name="output_schema_normrefs_entry"/>
 
    
    <h3>References to definitions defined in this module</h3>
    <xsl:choose>
      <xsl:when test="$module_nodes/module/definition">
        The following XML can be used to reference terms defined in this module
        from another module. The XML should be included in the 
        &lt;normrefs&gt; of the module. This will result in the terms being
        included in Clause 3 of the module.
        <xsl:apply-templates select="$module_nodes/module/definition"/>
      </xsl:when>
      <xsl:otherwise>
        There are no definitions defined in this module.
      </xsl:otherwise>
    </xsl:choose>
    <h3>References to module sections</h3>
    The following XML constructs can be used to reference sections of the
    module.
    <xsl:apply-templates 
      select="$module_nodes/module" mode="linkend">
      <xsl:with-param name="section" select="'Introduction'"/>
      <xsl:with-param name="link_section" select="'introduction'"/>
      <xsl:with-param name="href" 
        select="concat('../../../modules/',@directory,'/sys/introduction',$FILE_EXT)"/>
    </xsl:apply-templates>

    <xsl:apply-templates 
      select="$module_nodes/module" mode="linkend">
      <xsl:with-param name="section" select="'Scope'"/>
      <xsl:with-param name="link_section" select="'1_scope'"/>
      <xsl:with-param name="href" 
        select="concat('../../../modules/',@directory,'/sys/1_scope',$FILE_EXT,'#scope')"/>
    </xsl:apply-templates>

    <xsl:apply-templates 
      select="$module_nodes/module" mode="linkend">
      <xsl:with-param name="section" select="'In Scope'"/>
      <xsl:with-param name="link_section" select="'1_inscope'"/>
      <xsl:with-param name="href" 
        select="concat('../../../modules/',@directory,'/sys/1_scope',$FILE_EXT,'#inscope')"/>
    </xsl:apply-templates>

    <xsl:apply-templates 
      select="$module_nodes/module" mode="linkend">
      <xsl:with-param name="section" select="'Out of Scope'"/>
      <xsl:with-param name="link_section" select="'1_outscope'"/>
      <xsl:with-param name="href" 
        select="concat('../../../modules/',@directory,'/sys/1_scope',$FILE_EXT,'#outscope')"/>
    </xsl:apply-templates>

    <h3>References to ARM EXPRESS types</h3>
    The following XML constructs can be used to reference ARM types.
    <xsl:variable 
      name="arm_xml_file"
      select="concat('../../data/modules/',@directory,'/arm.xml')"/>
    <xsl:apply-templates 
      select="document($arm_xml_file)/express/schema/type">
      <xsl:with-param name="clause" 
        select="concat('../sys/4_info_reqs',$FILE_EXT)"/>
    </xsl:apply-templates>

    <h3>References to ARM EXPRESS entities</h3>
    The following XML constructs can be used to reference ARM entities.
    <xsl:apply-templates 
      select="document($arm_xml_file)/express/schema/entity">
      <xsl:with-param name="clause" 
        select="concat('../sys/4_info_reqs',$FILE_EXT)"/>
    </xsl:apply-templates>

    <xsl:variable
      name="mim_xml_file"
      select="concat('../../data/modules/',@directory,'/mim.xml')"/>
    <h3>References to MIM EXPRESS types</h3>
    The following XML constructs can be used to reference MIM types.
    <xsl:apply-templates 
      select="document($mim_xml_file)/express/schema/type">
      <xsl:with-param name="clause" 
        select="concat('../sys/5_mim',$FILE_EXT)"/>
    </xsl:apply-templates>

    <h3>References to MIM EXPRESS entities</h3>
    The following XML constructs can be used to reference MIM entities.
    <xsl:apply-templates 
      select="document($mim_xml_file)/express/schema/entity">
      <xsl:with-param name="clause" 
        select="concat('../sys/5_mim',$FILE_EXT)"/>
    </xsl:apply-templates>
  </body>
</HTML>
</xsl:template>

<xsl:template match="module">
  <h2>Useful information for developer</h2>
</xsl:template>


<xsl:template match="definition">
  <p class="hrefname">
    <xsl:value-of select="term"/>
  </p>
  <p class="hrefhref">
    <xsl:value-of select="concat('&lt;normref.inc module.name=&quot;',../@name,'&quot;&gt;')"/><br/>
    <xsl:value-of select="concat('&#160;&#160;&lt;term.ref linkend=&quot;', term/@id, '&quot;/&gt;')"/><br/>
    <xsl:value-of select="'&lt;/normref.inc&gt;'"/><br/>
  </p>
</xsl:template>


<xsl:template match="entity|type">
  <xsl:param name="clause"/>
  <xsl:variable name="linkend" select="concat(../@name, '.', @name)"/>
  <xsl:variable name="href" 
    select="translate(concat($clause,'#',$linkend),$UPPER,$LOWER)"/>
  <p class="hrefname">
    <xsl:value-of select="concat(name(),': ')"/>
    <a href="{$href}">
      <xsl:value-of select="@name"/>
    </a>
  </p>
  <p class="hrefhref">
    <xsl:call-template name="output_express_ref">
      <xsl:with-param name="schema" select="../@name"/>
      <xsl:with-param name="linkend" select="$linkend"/>
    </xsl:call-template>
  </p>
  <xsl:apply-templates select="enumeration"/>
  <xsl:apply-templates select="explicit"/>
  <xsl:apply-templates select="derived"/>
  <xsl:apply-templates select="inverse"/>
</xsl:template>

<xsl:template match="explicit|derived|inverse">
  <xsl:param name="clause"/>
  <xsl:variable name="linkend" 
    select="concat(../../@name,'.',../@name,'.',@name)"/>
  <xsl:variable name="href" 
    select="translate(concat($clause,'#',$linkend),$UPPER,$LOWER)"/>
  <p class="attrname">
        attribute: <a href="{$href}">
      <xsl:value-of select="@name"/>
    </a>
  </p>
  <p class="attrhref">
    <xsl:call-template name="output_express_ref">
      <xsl:with-param name="schema" select="../../@name"/>
      <xsl:with-param name="linkend" select="$linkend"/>
    </xsl:call-template>
  </p>
</xsl:template>

<xsl:template match="enumeration">
  <xsl:param name="clause"/>
  <xsl:call-template name="output_enums">
    <xsl:with-param name="clause" select="$clause"/>
    <xsl:with-param name="str" select="normalize-space(@items)"/>
  </xsl:call-template> 
</xsl:template>

<xsl:template name="output_enums">
  <xsl:param name="clause"/>
  <xsl:param name="str"/>
  <xsl:variable name="break_char" select="' '"/>
  <xsl:choose>
    <xsl:when test="contains($str,$break_char)">
      <xsl:variable name="substr" 
        select="substring-before($str,$break_char)"/>
      <xsl:call-template name="output_enum_item">
        <xsl:with-param name="clause" select="$clause"/>
        <xsl:with-param name="enum_value" select="$substr"/>
      </xsl:call-template> 
      
      <xsl:variable name="rest" select="substring-after($str,$break_char)"/>
      <xsl:call-template name="output_enums">
        <xsl:with-param name="clause" select="$clause"/>
        <xsl:with-param name="str" select="$rest"/>
      </xsl:call-template> 
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="output_enum_item">
        <xsl:with-param name="clause" select="$clause"/>
        <xsl:with-param name="enum_value" select="$str"/>
      </xsl:call-template> 
    </xsl:otherwise>        
  </xsl:choose>
</xsl:template>

<xsl:template name="output_enum_item">
  <xsl:param name="enum_value"/>
  <xsl:param name="clause"/>
  <xsl:variable name="schema" select="../../@name"/>
  <xsl:variable name="enum_type" select="../@name"/>
  <xsl:variable name="linkend" 
    select="concat($schema,'.',$enum_type,'.',$enum_value)"/>
  <xsl:variable name="href"
    select="translate(concat($clause,'#',$linkend),$UPPER,$LOWER)"/> 

  <p class="attrname">
        item: <a href="{$href}">
      <xsl:value-of select="$enum_value"/>
    </a>
  </p>
  <p class="attrhref">
    <xsl:call-template name="output_express_ref">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="linkend" select="$linkend"/>
    </xsl:call-template>
  </p>
</xsl:template>


<xsl:template name="output_express_ref">
  <xsl:param name="schema"/>
  <xsl:param name="linkend"/>
  <xsl:param name="rule"/>
  <xsl:variable name="arm_mim">
    <xsl:choose>
      <xsl:when test="contains($schema,'_arm')">
        <xsl:value-of select="'arm'"/>
      </xsl:when>
      <xsl:when test="contains($schema,'_mim')">
        <xsl:value-of select="'mim'"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="module">
    <xsl:call-template name="module_name">
      <xsl:with-param name="module" select="$schema"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of 
      select="concat('&lt;express_ref linkend=&quot;',
              $module,':',$arm_mim,':',$linkend,'&quot;/&gt;')"/>  
</xsl:template>


<xsl:template match="module" mode="linkend">
  <xsl:param name="section"/>
  <xsl:param name="link_section"/>
  <xsl:param name="href"/>
  <p class="hrefname">
    <xsl:value-of select="$section"/>
  </p>
  <xsl:variable name="linkend" 
    select="concat('&lt;module_ref linkend=&quot;',
            @name,':',$link_section,'&quot;/&gt;')"/>
  <p class="hrefhref">
    <a href="{$href}">
      <xsl:value-of select="$linkend"/>
    </a>
  </p>
</xsl:template>


<!-- output any modules referenced in informative text -->
<xsl:template name="get_bib_entries">
  <xsl:param name="module"/>

  <xsl:variable 
      name="module_xml_file"
      select="concat('../../data/modules/',$module,'/module.xml')"/>

  <xsl:variable name="nodes" select="document($module_xml_file)"/>

  <xsl:variable name="modules_list1">
    <xsl:apply-templates 
      select="$nodes/module/purpose//express_ref|$nodes/module/purpose//module_ref">
      <xsl:with-param name="current_module" select="$module"/>
    </xsl:apply-templates>
  </xsl:variable>

  <xsl:variable name="modules_list2">
    <xsl:apply-templates 
      select="$nodes/module/inscope//note//express_ref|$nodes/module/inscope//example//express_ref|$nodes/module/inscope//note//module_ref|$nodes/module/inscope//example//module_ref">
      <xsl:with-param name="modules_list" select="$modules_list1"/>
      <xsl:with-param name="current_module" select="$module"/>
    </xsl:apply-templates>
  </xsl:variable>
  <xsl:variable name="modules_list22" 
    select="concat($modules_list1,$modules_list2)"/>

  <xsl:variable name="modules_list3">
    <xsl:apply-templates 
      select="$nodes/module/outscope//note//express_ref|$nodes/module/outscope//example//express_ref|$nodes/module/outscope//note//module_ref|$nodes/module/outscope//example//module_ref">
      <xsl:with-param name="modules_list" select="$modules_list22"/>
      <xsl:with-param name="current_module" select="$module"/>
    </xsl:apply-templates>
  </xsl:variable>
  <xsl:variable name="modules_list33" 
    select="concat($modules_list22,$modules_list3)"/>


  <xsl:variable
    name="arm_xml_file"
    select="concat('../../data/modules/',$module,'/arm.xml')"/>

  <xsl:variable
    name="arm_express_nodes"
    select="document(string($arm_xml_file))"/>

  <xsl:variable name="arm_desc_xml_file">
    <xsl:choose>
      <xsl:when 
        test="$arm_express_nodes/express[string-length(@description.file)>0]">
        <xsl:value-of 
          select="concat('../../data/modules/',$module,'/arm_descriptions.xml')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of 
          select="concat('../../data/modules/',$module,'/arm.xml')"/>        
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
      
  <xsl:variable name="arm_nodes" 
    select="document(string($arm_desc_xml_file))"/>

  <xsl:variable name="modules_list4">
    <xsl:apply-templates 
      select="$arm_nodes//note//express_ref|$arm_nodes//example//express_ref|$arm_nodes//note//module_ref|$arm_nodes//example//module_ref">
      <xsl:with-param name="modules_list" select="$modules_list33"/>
      <xsl:with-param name="current_module" select="$module"/>
    </xsl:apply-templates>
  </xsl:variable>
  <xsl:variable name="modules_list44" 
    select="concat($modules_list33,$modules_list4)"/>

  <xsl:variable 
      name="mim_xml_file"
      select="concat('../../data/modules/',$module,'/mim.xml')"/>

  <xsl:variable
    name="mim_express_nodes"
    select="document(string($mim_xml_file))"/>

  <xsl:variable name="mim_desc_xml_file">
    <xsl:choose>
      <xsl:when 
        test="$mim_express_nodes/express[string-length(@description.file)>0]">
        <xsl:value-of 
          select="concat('../../data/modules/',$module,'/mim_descriptions.xml')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of 
          select="concat('../../data/modules/',$module,'/mim.xml')"/>        
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="mim_nodes" 
    select="document(string($mim_desc_xml_file))"/>

  <xsl:variable name="modules_list5">
    <xsl:apply-templates 
      select="$mim_nodes//note//express_ref|$mim_nodes//example//express_ref|$mim_nodes//note//module_ref|$mim_nodes//example//module_ref">
      <xsl:with-param name="modules_list" select="$modules_list44"/>
      <xsl:with-param name="current_module" select="$module"/>
    </xsl:apply-templates>
  </xsl:variable>
  <xsl:variable name="modules_list55" 
    select="concat($modules_list44,$modules_list5)"/>

  <xsl:variable name="modules_list6">
    <xsl:apply-templates 
      select="$nodes/module/usage_guide//express_ref|$nodes/module/usage_guide//module_ref">
      <xsl:with-param name="modules_list" select="$modules_list55"/>
      <xsl:with-param name="current_module" select="$module"/>
    </xsl:apply-templates>
  </xsl:variable>
  <xsl:variable name="modules_list66" 
    select="concat($modules_list55,$modules_list6)"/>

  
  <!-- now process the modules -->
  <xsl:variable name="modules_list">
    <xsl:call-template name="remove_duplicates">
      <xsl:with-param name="list" select="$modules_list66"/>
    </xsl:call-template>
  </xsl:variable>


  <xsl:variable name="mim_interfaced_modules">
    <xsl:apply-templates
      select="$mim_express_nodes/express//interface" 
      mode="get_schema"/>    
  </xsl:variable>
  <xsl:variable name="arm_interfaced_modules">
    <xsl:apply-templates
      select="$arm_express_nodes/express//interface" 
      mode="get_schema"/>    
  </xsl:variable>

  <xsl:variable name="interfaced_modules" 
    select="concat(' ',$module,' ',$arm_interfaced_modules,$mim_interfaced_modules)"/>
    

  <xsl:variable name="nmodules_list1">
    <xsl:call-template name="prune_normrefs_from_bib_entries">
      <xsl:with-param name="modules_list" 
        select="concat(' ',$modules_list,' ')"/>
      <xsl:with-param name="interfaced_modules"
        select="$interfaced_modules"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="nmodules_list"
    select="normalize-space($nmodules_list1)"/>
  <!--
  m:{<xsl:value-of select="$modules_list"/>}:{<xsl:value-of select="$interfaced_modules"/>}<br/>

  nm:{<xsl:value-of select="$nmodules_list"/>}<br/>
-->

  <xsl:choose>
    <xsl:when test="string-length($nmodules_list)>0">
      <h3>Bibliography entries</h3>
      The following modules are referenced in informative 
      content
      (foreword, introduction, note, example, or informative annex).
      These module should be added as 
      <a href="../sys/biblio{$FILE_EXT}">
        bibliographic 
      </a>
      entries.
      <ul>
        <xsl:call-template name="output_bib_entry">
          <xsl:with-param name="modules_list" 
            select="concat($nmodules_list,' ')"/>
        </xsl:call-template>
      </ul>
     
    </xsl:when>
    <xsl:otherwise>
      <h3>Bibliography entries</h3>
      There are no modules referenced in informative 
      content
      (foreword, introduction, note, example, or informative annex).
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="interface" mode="get_schema">
  <xsl:variable name="module">
    <xsl:call-template name="module_name">
      <xsl:with-param name="module" select="@schema"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="concat(' ',$module,' ')"/>
</xsl:template>


<xsl:template name="prune_normrefs_from_bib_entries">
  <xsl:param name="modules_list"/>
  <xsl:param name="ok_modules_list"/>
  <xsl:param name="interfaced_modules"/>
  <xsl:variable name="module">
    <xsl:call-template name="module_name">
      <xsl:with-param name="module" 
        select="substring-before($modules_list,' ')"/>
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:variable name="module_item" select="concat(' ',$module,' ')"/>
  <xsl:variable name="rest" 
    select="substring-after($modules_list,' ')"/>

  <xsl:variable name="nmodules_list">
    <xsl:choose>
      <xsl:when test="not(contains($interfaced_modules, $module_item))">
        <xsl:value-of select="concat($ok_modules_list,' ',$module,' ')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$ok_modules_list"/>      
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="string-length($rest)>1">
      <xsl:call-template name="prune_normrefs_from_bib_entries">
        <xsl:with-param name="modules_list" select="$rest"/>
        <xsl:with-param name="ok_modules_list" select="$nmodules_list"/>
        <xsl:with-param name="interfaced_modules"
          select="$interfaced_modules"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$nmodules_list"/>      
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="output_bib_entry">
  <xsl:param name="modules_list"/>
  <xsl:variable name="module">
    <xsl:call-template name="module_name">
      <xsl:with-param name="module" 
        select="substring-before($modules_list,' ')"/>
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:variable name="rest" 
    select="substring-after($modules_list,' ')"/>
  <li>
    <a href="../../{$module}/sys/1_scope{$FILE_EXT}">
      <xsl:value-of select="$module"/>
    </a>
  </li>

  <xsl:if test="string-length($rest)>1">
    <xsl:call-template name="output_bib_entry">
      <xsl:with-param name="modules_list" select="$rest"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="express_ref|module_ref">
  <xsl:param name="modules_list"/>
  <xsl:param name="current_module"/>
  <xsl:variable
    name="nlinkend"
    select="translate(@linkend,'&#x9;&#xA;&#x20;&#xD;','')"/>
  <xsl:variable
    name="module"
    select="substring-before($nlinkend,':')"/>
  <xsl:variable name="module_str">
    <xsl:choose>
      <xsl:when test="$module=$current_module"/>
      <xsl:otherwise>
        <xsl:value-of select="concat(' ',$module,' ')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="concat($modules_list,$module_str)"/>
</xsl:template>


<xsl:template name="output_schema_normrefs_entry">
  <h3>Normative references</h3>

  <xsl:variable
    name="mim_xml_file"
    select="concat('../../data/modules/',@directory,'/mim.xml')"/>
  <xsl:variable 
    name="mim_nodes"
    select="document($mim_xml_file)"/>
  <xsl:choose>
    <xsl:when test="not($mim_nodes/express/schema/interface[not(substring(@schema,(string-length(@schema)-3))='_mim')])">
      There are no Common resources interfaced to in the MIM.
    </xsl:when>
    <xsl:otherwise>
      The following Common Resource schemas have been interfaced to in the
      MIM. These must be included as Normative references.
      Note that the normative references for the interfaced modules are
      generated automatically.
      <ul>
        <xsl:apply-templates 
          select="$mim_nodes/express/schema/interface[not(substring(@schema,(string-length(@schema)-3))='_mim')]"/>
      </ul>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="interface">
  <xsl:variable name="schema" select="string(@schema)"/>

  <xsl:choose>
    <xsl:when 
      test="$REPO_NODES/repository_index/resources/resource[@name=$schema]">
      <xsl:variable name="ir_doc" 
        select="concat('../../data/resources/',$schema,'/',$schema,'.xml')"/>
      <xsl:variable name="ir_ref"
        select="document($ir_doc)/express/@reference"/>
      <li>
        <xsl:value-of select="concat($schema,' in ',$ir_ref)"/>
      </li>
    </xsl:when>
    <xsl:otherwise>
      <li>
        <xsl:value-of select="$schema"/> - not found in repository_index.xml
      </li>
    </xsl:otherwise>
  </xsl:choose>
  
</xsl:template>

<xsl:template name="get_bib_entriesx">
  <xsl:param name="module"/>

  <xsl:variable 
      name="module_xml_file"
      select="concat('../../data/modules/',$module,'/module.xml')"/>
  <xsl:variable name="nodes" select="document($module_xml_file)"/>

  <xsl:variable
    name="arm_xml_file"
    select="concat('../../data/modules/',$module,'/arm.xml')"/>
  <xsl:variable name="arm_desc_xml_file">
    <xsl:choose>
      <xsl:when 
        test="document($arm_xml_file)/express[string-length(@description.file)>0]">
        <xsl:value-of 
          select="concat('../../data/modules/',$module,'/arm_descriptions.xml')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of 
          select="concat('../../data/modules/',$module,'/arm.xml')"/>        
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
      
  [<xsl:value-of select="$arm_desc_xml_file"/>]
  <xsl:value-of select="document(string($arm_desc_xml_file))"/>

  <xsl:variable 
      name="mim_xml_file"
      select="concat('../../data/modules/',$module,'/mim.xml')"/>

  <xsl:variable name="mim_desc_xml_file">
    <xsl:choose>
      <xsl:when 
        test="document(string($mim_xml_file))/express[string-length(@description.file)>0]">
        <xsl:value-of 
          select="concat('../../data/modules/',$module,'/mim_descriptions.xml')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of 
          select="concat('../../data/modules/',$module,'/mim.xml')"/>        
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  [[<xsl:value-of 
          select="$mim_desc_xml_file"/>]]     


</xsl:template>
</xsl:stylesheet>
