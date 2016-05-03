<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_2_refs.xsl,v 1.16 2012/11/01 19:01:48 mikeward Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep .
  Purpose: Output the refs section as a web page
     
     ******************
     Warning - this replaces the code for normative references in modules.xsl
     We still need to delete code called by 
    <xsl:call-template name="output_normrefs">
    <xsl:with-param name="module_number" select="./@part"/>
    <xsl:with-param name="current_module" select="."/>
    </xsl:call-template>
  See: 
     ******************
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"                
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:exslt="http://exslt.org/common"
  xmlns:saxon="http://icl.com/saxon"
  extension-element-prefixes="saxon" 
  exclude-result-prefixes="msxsl exslt saxon"
  version="1.0">
  

  <xsl:import href="module.xsl"/>

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
  <xsl:import href="module_clause.xsl"/>


  <xsl:output method="html"/>


  <!-- added by MWD 2016-05-03 -->
  <xsl:template match="resource">
    
    <h2>2 Normative references</h2>
    
    <p>
      The following referenced documents are indispensable for the application of
      this document. For dated references, only the edition cited applies. For
      undated references, the latest edition of the referenced document
      (including any amendments) applies.
    </p>
    
   <!-- collect up all the normrefs for the module into a normref_nodes node
    set, then sort and output them 
    The list comprises:
    All default normrefs listed in ../data/basic/normrefs_default.xml
    All normrefs explicitly included in the module by normref.inc
    All default normrefs that define terms for which abbreviations are provided and listed in ../data/basic/abbreviations_default.xml
    All modules referenced by a USE FROM in the ARM
    All modules referenced by a USE FROM in the MIM
    All integrated resources referenced by a USE FROM in the MIM
  -->
    <xsl:variable name="normref_list">
      <!-- <normref_nodes> 
        A node set used to collect up all the normative references 
        These are then sorted an output -->
      <xsl:element name="normref_nodes">
        <!-- for some reason I cannot pass a parameter in apply-templates
          when applied to a node set, hence storing it in the XML -->
        <xsl:attribute name="current_module_status">
          <xsl:value-of select="string(@status)"/>
        </xsl:attribute>
        
        <!-- collect default normative reference -->
        <xsl:apply-templates select="document('../data/basic/normrefs_default.xml')/normrefs"
          mode="generate_node"> </xsl:apply-templates>
        
        <!-- collect normative references explicitly referenced in the module -->
        <xsl:apply-templates select="normrefs/normref.inc" mode="generate_node"/>
        <xsl:apply-templates select="normrefs/normref" mode="generate_node"/>
        
        <!-- collect normative references that define terms for which abbreviations are provided
          and listed in ../data/basic/abbreviations_default.xml -->
        <xsl:apply-templates
          select="document('../data/basic/abbreviations_default.xml')/abbreviations/abbreviation.inc"
          mode="generate_node"/>
        <xsl:apply-templates select="abbreviations/abbreviation.inc" mode="generate_node"/>
        
        
        
        
      </xsl:element>
      <!--  </normref_nodes> -->
    </xsl:variable>

<!--
    <xsl:for-each select="msxsl:node-set($normref_list)/*">
      <p>
	<xsl:copy-of select="."/>
      </p>
    </xsl:for-each>

    <saxon:output href="c:/temp/normref_list.xml" method="xml">
      <xsl:copy-of select="$normref_list"/>
    </saxon:output>
-->

    <xsl:choose>
      <xsl:when test="function-available('msxsl:node-set')">
        <xsl:variable name="normref_nodes" select="msxsl:node-set($normref_list)"/>
        <xsl:apply-templates select="$normref_nodes" mode="output_normrefs"/>
      </xsl:when>
      <xsl:when test="function-available('exslt:node-set')">
        <xsl:variable name="normref_nodes" select="exslt:node-set($normref_list)"/>
        <xsl:apply-templates select="$normref_nodes" mode="output_normrefs"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message> Only support SAXON and MXSL XSL parsers. </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="module">
    
    <h2>2 Normative references</h2>
    
    <p>
      The following referenced documents are indispensable for the application of
      this document. For dated references, only the edition cited applies. For
      undated references, the latest edition of the referenced document
      (including any amendments) applies.
    </p>
    
    <!-- collect up all the normrefs for the module into a normref_nodes node
    set, then sort and output them 
    The list comprises:
    All default normrefs listed in ../data/basic/normrefs_default.xml
    All normrefs explicitly included in the module by normref.inc
    All default normrefs that define terms for which abbreviations are provided and listed in ../data/basic/abbreviations_default.xml
    All modules referenced by a USE FROM in the ARM
    All modules referenced by a USE FROM in the MIM
    All integrated resources referenced by a USE FROM in the MIM
  -->
    <xsl:variable name="normref_list">
      <!-- <normref_nodes> 
        A node set used to collect up all the normative references 
        These are then sorted an output -->
      <xsl:element name="normref_nodes">
        <!-- for some reason I cannot pass a parameter in apply-templates
          when applied to a node set, hence storing it in the XML -->
        <xsl:attribute name="current_module_status">
          <xsl:value-of select="string(@status)"/>
        </xsl:attribute>
        
        <!-- collect default normative reference -->
        <xsl:apply-templates select="document('../data/basic/normrefs_default.xml')/normrefs"
          mode="generate_node"> </xsl:apply-templates>
        
        <!-- collect normative references explicitly referenced in the module -->
        <xsl:apply-templates select="normrefs/normref.inc" mode="generate_node"/>
        <xsl:apply-templates select="normrefs/normref" mode="generate_node"/>
        
        <!-- collect normative references that define terms for which abbreviations are provided
          and listed in ../data/basic/abbreviations_default.xml -->
        <xsl:apply-templates
          select="document('../data/basic/abbreviations_default.xml')/abbreviations/abbreviation.inc"
          mode="generate_node"/>
        <xsl:apply-templates select="abbreviations/abbreviation.inc" mode="generate_node"/>
        
        <!-- collect normative reference implicit in the module through a USE FROM in the ARM -->
        <xsl:variable name="module_dir">
          <xsl:call-template name="module_directory">
            <xsl:with-param name="module" select="/module/@name"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="arm_xml" select="concat($module_dir,'/arm.xml')"/>
        <xsl:apply-templates select="document($arm_xml)/express/schema/interface"
          mode="generate_node"/>
        
        <!-- collect normative reference implicit in the module through a USE FROM in the MIM -->
        <xsl:variable name="mim_xml" select="concat($module_dir,'/mim.xml')"/>
        <xsl:apply-templates select="document($mim_xml)/express/schema/interface"
          mode="generate_node"/>
      </xsl:element>
      <!--  </normref_nodes> -->
    </xsl:variable>
    
    <!--
    <xsl:for-each select="msxsl:node-set($normref_list)/*">
      <p>
	<xsl:copy-of select="."/>
      </p>
    </xsl:for-each>
    
    <saxon:output href="c:/temp/normref_list.xml" method="xml">
      <xsl:copy-of select="$normref_list"/>
    </saxon:output>
-->
    
    <xsl:choose>
      <xsl:when test="function-available('msxsl:node-set')">
        <xsl:variable name="normref_nodes" select="msxsl:node-set($normref_list)"/>
        <xsl:apply-templates select="$normref_nodes" mode="output_normrefs"/>
      </xsl:when>
      <xsl:when test="function-available('exslt:node-set')">
        <xsl:variable name="normref_nodes" select="exslt:node-set($normref_list)"/>
        <xsl:apply-templates select="$normref_nodes" mode="output_normrefs"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message> Only support SAXON and MXSL XSL parsers. </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!-- generate the normref node for included/referenced normrefs in a module -->
<xsl:template match="normref.inc" mode="generate_node">
  <xsl:variable name="ref" select="@normref"/>
  <xsl:apply-templates 
    select="document('../data/basic/normrefs.xml')/normref.list/normref[@id=$ref]"
    mode="generate_node">
  </xsl:apply-templates>
</xsl:template>

<!-- deep copy of any node -->
<xsl:template match="@*|node()" mode="copy">
  <xsl:copy>
    <xsl:apply-templates select="@*" mode="copy"/>
    <xsl:apply-templates mode="copy"/>
  </xsl:copy>  
</xsl:template>

<!-- generate the normref node  -->
<xsl:template match="normref" mode="generate_node">
  <normref>
    <xsl:attribute name="id">
      <xsl:variable name="stdno" select="normalize-space(stdref/stdnumber)"/>
      <xsl:choose>
        
        <xsl:when test="contains($stdno,'-')">
          
          <xsl:variable name="stdno_prefix" select="substring-before($stdno, '-')"/>
          <xsl:variable name="stdno_suffix" select="substring-after($stdno, '-')"/>
          <!--<xsl:variable name="part_no_length" select="string-length($stdno_suffix)"/>
          <xsl:variable name="std_no_length" select="string-length($stdno_prefix)"/>
          <xsl:variable name="no_of_leading_zeros" select="number(6 - $part_no_length)"/>
          <xsl:variable name="no_of_leading_zeros_std_no" select="number(6 - $std_no_length)"/>-->
          
          <xsl:variable name="stdno_prefix_leading_zeros">
            <xsl:call-template name="get_leading_zeros">
              <xsl:with-param name="no_of_leading_zeros_param" select="number(6 - string-length($stdno_prefix))"/>
            </xsl:call-template>
          </xsl:variable>
          
          <xsl:variable name="stdno_suffix_leading_zeros">
            <xsl:call-template name="get_leading_zeros">
              <xsl:with-param name="no_of_leading_zeros_param" select="number(6 - string-length($stdno_suffix))"/>
            </xsl:call-template>
          </xsl:variable>
               
          <!-- MWD -->
          <xsl:value-of select="concat($stdno_prefix_leading_zeros, $stdno_prefix, $stdno_suffix_leading_zeros, $stdno_suffix)"/>
          <!--<xsl:value-of select="concat($leading_zeros_std_no, $stdno_prefix, $leading_zeros, $stdno_suffix)"/>--><!-- MWD $leading_zeros_std_no added -->
          
        </xsl:when>
        
       
        
       <!-- <xsl:when test="contains($stdno,'10303-')">
          
          <xsl:variable name="part_no_length" select="string-length(substring-after($stdno, '-'))"/>
          <xsl:variable name="no_of_leading_zeros" select="number(5 - $part_no_length)"/>
          <xsl:variable name="leading_zeros">
            <xsl:choose>
              <xsl:when test="$no_of_leading_zeros=1">0</xsl:when>
              <xsl:when test="$no_of_leading_zeros=2">00</xsl:when>
              <xsl:when test="$no_of_leading_zeros=3">000</xsl:when>
              <xsl:when test="$no_of_leading_zeros=4">0000</xsl:when>
              <xsl:when test="$no_of_leading_zeros=5">00000</xsl:when>
            </xsl:choose>
          </xsl:variable>
          
          <xsl:value-of select="concat('10303',$leading_zeros, substring-after($stdno,'10303-'))"/>
        </xsl:when>
        
        <xsl:when test="contains($stdno,'13584-')">
          
          <xsl:variable name="part_no_length" select="string-length(substring-after($stdno, '-'))"/>
          <xsl:variable name="no_of_leading_zeros" select="number(5 - $part_no_length)"/>
          <xsl:variable name="leading_zeros">
            <xsl:choose>
              <xsl:when test="$no_of_leading_zeros=1">0</xsl:when>
              <xsl:when test="$no_of_leading_zeros=2">00</xsl:when>
              <xsl:when test="$no_of_leading_zeros=3">000</xsl:when>
              <xsl:when test="$no_of_leading_zeros=4">0000</xsl:when>
              <xsl:when test="$no_of_leading_zeros=5">00000</xsl:when>
            </xsl:choose>
          </xsl:variable>
          
          <xsl:value-of select="concat('13584',$leading_zeros, substring-after($stdno,'13584-'))"/>
        </xsl:when>-->
        <xsl:otherwise>
          <!--<xsl:variable name="std_no_length" select="string-length($stdno)"/>
          <xsl:variable name="no_of_leading_zeros_std_no" select="number(6 - $std_no_length)"/>
          <xsl:variable name="leading_zeros_std_no">
            <xsl:choose>
              <xsl:when test="$no_of_leading_zeros_std_no=1">0</xsl:when>
              <xsl:when test="$no_of_leading_zeros_std_no=2">00</xsl:when>
              <xsl:when test="$no_of_leading_zeros_std_no=3">000</xsl:when>
              <xsl:when test="$no_of_leading_zeros_std_no=4">0000</xsl:when>
              <xsl:when test="$no_of_leading_zeros_std_no=5">00000</xsl:when>
            </xsl:choose>
          </xsl:variable>-->
          
          <xsl:variable name="stdno_leading_zeros">
            <xsl:call-template name="get_leading_zeros">
              <xsl:with-param name="no_of_leading_zeros_param" select="number(6 - string-length($stdno))"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:value-of select="concat($stdno_leading_zeros, $stdno)"/>
          <!--<xsl:value-of select="concat($leading_zeros_std_no, $stdno)"/>-->
          <!--<xsl:value-of select="$stdno"/>-->
        </xsl:otherwise>
      </xsl:choose>     
    </xsl:attribute>
    <xsl:attribute name="group">
      <xsl:apply-templates select="." mode="group"/>
    </xsl:attribute>
    <xsl:apply-templates select="./*" mode="copy"/>
  </normref>  
</xsl:template>
  
<xsl:template name="get_leading_zeros">
  <xsl:param name="no_of_leading_zeros_param"/>
  <xsl:choose>
    <xsl:when test="$no_of_leading_zeros_param=1">0</xsl:when>
    <xsl:when test="$no_of_leading_zeros_param=2">00</xsl:when>
    <xsl:when test="$no_of_leading_zeros_param=3">000</xsl:when>
    <xsl:when test="$no_of_leading_zeros_param=4">0000</xsl:when>
    <xsl:when test="$no_of_leading_zeros_param=5">00000</xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="normref" mode="group">
  <xsl:variable name="orgname" select="normalize-space(./stdref/orgname)"/>
  <xsl:choose>
    <xsl:when test="$orgname='ISO'">AISO</xsl:when>
    <xsl:when test="$orgname='ISO/TS'">AISO</xsl:when>
    <xsl:when test="$orgname='ISO/IEC'">BIEC</xsl:when>
    <xsl:when test="$orgname='IEC'">CIEC</xsl:when>
    <xsl:otherwise>DOTHER</xsl:otherwise>
  </xsl:choose>  
</xsl:template>

  
  <xsl:template match="abbreviation.inc" mode="generate_node">
  <xsl:variable name="abbr.inc" select="@linkend"/>
  <xsl:variable name="abbr" 
    select="document('../data/basic/abbreviations.xml')/abbreviation.list/abbreviation[@id=$abbr.inc]"/>
  <xsl:choose>
    <xsl:when test="$abbr/term.ref/@normref">
      <xsl:variable name="ref" select="$abbr/term.ref/@normref"/>
      <xsl:apply-templates 
        select="document('../data/basic/normrefs.xml')/normref.list/normref[@id=$ref]"
        mode="generate_node">
      </xsl:apply-templates>
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
</xsl:template>


<xsl:template match="interface" mode="generate_node">
  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="schema_lcase" select="translate(@schema,$UPPER, $LOWER)"/>
  <xsl:variable name="ARM_or_MIM"
    select="substring($schema_lcase,string-length($schema_lcase)-3)"/>

  <xsl:choose>
    <!-- Interface to ARM and MIM schema -->
    <xsl:when test="$ARM_or_MIM='_arm' or $ARM_or_MIM='_mim'">
      <xsl:variable name="module"
        select="substring($schema_lcase,0,string-length($schema_lcase)-3)"/>
  
      <xsl:variable name="module_dir">
        <xsl:call-template name="module_directory">
          <xsl:with-param name="module" select="$module"/>
        </xsl:call-template>
      </xsl:variable>
      
      <xsl:variable name="module_xml" select="concat($module_dir,'/module.xml')"/>
      
      <xsl:variable name="module_ok">
        <xsl:call-template name="check_module_exists">
          <xsl:with-param name="module" select="$module"/>
        </xsl:call-template>
      </xsl:variable>
      
      <xsl:choose>
        <xsl:when test="$module_ok='true'">
          <xsl:apply-templates select="document($module_xml)" mode="generate_node"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="error_message">
            <xsl:with-param name="message">
              <xsl:value-of select="concat('Interface error 1: ', $module_ok)"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <!-- Interface to RESOURCE schema -->
      <xsl:otherwise>
        <xsl:variable name="ir_ok">
          <xsl:call-template name="check_resource_exists">
            <xsl:with-param name="schema" select="$schema_lcase"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="$ir_ok='true'">
          <xsl:variable name="ir_ref"
            select="document(concat('../data/resources/',
            $schema_lcase,'/',$schema_lcase,'.xml'))/express/@reference"
          />
          <xsl:variable name="ir_refn1" select="normalize-space($ir_ref)"/>   
          <xsl:variable name="ir_refn2">
            <xsl:choose>
              <xsl:when test="starts-with($ir_refn1,'ISO 10303-')">
                <xsl:value-of select="concat('10303',normalize-space(substring-after($ir_refn1,'-')))"/>
              </xsl:when>
              <xsl:when test="starts-with($ir_refn1,'IS0 10303')">
                <xsl:value-of select="concat('10303',normalize-space(substring-after($ir_refn1,'10303')))"/>
              </xsl:when>
              <xsl:when test="starts-with($ir_refn1,'10303-')">
                <xsl:value-of select="concat('10303',normalize-space(substring-after($ir_refn1,'10303-')))"/>
              </xsl:when>
              <xsl:otherwise><xsl:value-of select="$ir_refn1"/></xsl:otherwise>
            </xsl:choose>            
          </xsl:variable> 
          <xsl:variable name="normref.inc">
            <xsl:choose>
              <xsl:when test="starts-with($ir_ref,'ISO 10303-')">
                <xsl:value-of select="concat('ref10303-',normalize-space(substring-after($ir_refn1,'-')))"/>
              </xsl:when>
              <xsl:when test="starts-with($ir_ref,'IS0 10303')">
                <xsl:value-of select="concat('ref10303-',normalize-space(substring-after($ir_refn1,'10303')))"/>
              </xsl:when>
              <xsl:when test="starts-with($ir_ref,'10303-')">
                <xsl:value-of select="concat('ref10303-',normalize-space(substring-after($ir_refn1,'10303-')))"/>
              </xsl:when>
              <xsl:otherwise><xsl:value-of select="$ir_refn1"/></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="normref.list" select="document('../data/basic/normrefs.xml')/normref.list"/>
          
          <xsl:apply-templates 
            select="$normref.list/normref[@id=$normref.inc]"
            mode="generate_node">
          </xsl:apply-templates>
          <xsl:if test="count($normref.list/normref[@id=$normref.inc])=0"><xsl:element name="normref.resource">            
            <xsl:attribute name="id">
              <xsl:value-of select="$ir_refn2"/>
            </xsl:attribute>
            <xsl:attribute name="interfaced_schema">
                <xsl:value-of select="$schema_lcase"/>
              </xsl:attribute>
              <xsl:attribute name="express_reference">
                <xsl:value-of select="$ir_ref"/>
              </xsl:attribute>
              <xsl:attribute name="module">
                <xsl:value-of select="../@name"/>
              </xsl:attribute>
              <xsl:attribute name="normref.inc">
                <xsl:value-of select="$normref.inc"/>
              </xsl:attribute>
            </xsl:element>            
          </xsl:if>
        </xsl:if>
      </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="module" mode="generate_node">
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
  
  <!-- 
       Note, if the standard has a status of CD or CD-TS it has not been
       published - so overide what ever is the @publication.year 
       -->
  <xsl:variable name="pub_year">
    <xsl:choose>
      <xsl:when test="@status='CD' or @status='CD-TS'">&#8212;</xsl:when>
      <xsl:when test="@published='n'">&#8212;</xsl:when>
      <xsl:when test="string-length(@publication.year)">
        <xsl:value-of select="@publication.year"/>
      </xsl:when>
      <xsl:otherwise>
        &lt;publication.year&gt;
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="orgname">
    <xsl:choose>
      <xsl:when test="@status='IS'">
        <xsl:value-of select="'ISO'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('ISO/',@status)"/>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:variable>

  <xsl:variable name="isonumber" select="concat('10303-',@part)"/>
 
  <xsl:variable name="stdtitle"
    select="concat('Industrial automation systems and integration ',
            '&#8212; Product data representation and exchange ')"/>
  
  <xsl:variable name="module_name">
    <xsl:call-template name="module_display_name">
      <xsl:with-param name="module" select="@name"/>
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:element name="normref">
    <xsl:attribute name="id">
          <xsl:variable name="part_no_length" select="string-length(@part)"/>
          <xsl:variable name="no_of_leading_zeros" select="number(6 - $part_no_length)"/>
          
          <xsl:variable name="leading_zeros">
            <xsl:call-template name="get_leading_zeros">
              <xsl:with-param name="no_of_leading_zeros_param" select="$no_of_leading_zeros"/>
            </xsl:call-template>
            <!--<xsl:choose>
              <xsl:when test="$no_of_leading_zeros=1">0</xsl:when>
              <xsl:when test="$no_of_leading_zeros=2">00</xsl:when>
              <xsl:when test="$no_of_leading_zeros=3">000</xsl:when>
              <xsl:when test="$no_of_leading_zeros=4">0000</xsl:when>
              <xsl:when test="$no_of_leading_zeros=5">00000</xsl:when>
            </xsl:choose>-->
          </xsl:variable>
          
      <xsl:value-of select="concat('10303', $leading_zeros, @part)"/>
    </xsl:attribute>
    <xsl:attribute name="group">AISO</xsl:attribute>
    <stdref>
      <orgname><xsl:value-of select="$orgname"/></orgname>
      <pubdate><xsl:value-of select="$pub_year"/></pubdate>
      <stdnumber><xsl:value-of select="$isonumber"/></stdnumber>
      <stdtitle>Industrial automation systems and integration &#8212; Product data representation and exchange </stdtitle>
      <subtitle><xsl:value-of select="concat('&#8212; Part ',$part,': Application module: ', $module_name,'.')"/></subtitle>
    </stdref>
  </xsl:element>
</xsl:template>

  
<!-- outputs the norm refs that have been collected into the normref_nodes
     node set. The normrefs are sorted on output  -->
<xsl:template match="normref_nodes" mode="output_normrefs">
  
  <xsl:apply-templates select="normref" mode="output_html">    
    <xsl:sort select="@group" data-type="text"/>
    <xsl:sort select="@id" data-type="text"/>
  </xsl:apply-templates>
  <xsl:apply-templates select="normref.resource" mode="check_resources"/>
  
  <xsl:if test="normref/stdref[@published='n']">
    <table width="200">
      <tr>
        <td><hr/></td>
      </tr>
      <tr>
        <td>
          <a name="tobepub">
            <sup>1)</sup> To be published.
          </a>
        </td>
      </tr>
    </table>
  </xsl:if>
</xsl:template>

  <xsl:template match="normref.resource" mode="check_resources">
    <xsl:variable name="id" select="@id"/>
    <xsl:variable name="normrefs" select="../normref[@id=$id]"/>
    <xsl:if test="count(../normref[@id=$id])=0">      
      <xsl:call-template name="error_message">
        <xsl:with-param name="message">
          <xsl:value-of select="concat('Normref error 2: ', @module, ' references the schema ',@interfaced_schema,'. Add a normative reference to the IR in data/basic/normrefs.xml ',@normref.inc)"/>
        </xsl:with-param>
      </xsl:call-template>        
    </xsl:if>
  </xsl:template>
  
<!-- output the normref to HTML -->
  <xsl:template match="normref" mode="output_html">
    <xsl:variable name="id" select="@id"/>
    <xsl:if test="count(following-sibling::normref[@id=$id])=0">
      <xsl:variable name="stdnumber" select="concat(stdref/orgname,'&#160;',stdref/stdnumber)"/>
      <xsl:variable name="current_module_status" select="../@current_module_status"/>
      
      <p>
        <xsl:value-of select="$stdnumber"/>
        <xsl:if test="stdref[@published='n']">
          <sup><a href="#tobepub">1</a>)</sup>
        </xsl:if>,&#160; <i>
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
        <!--<xsl:value-of select="$id"/>-->
      </p>
    </xsl:if>
  </xsl:template>

  
</xsl:stylesheet>

