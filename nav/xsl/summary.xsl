<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="../../xsl/document_xsl.xsl" ?>
<!--
$Id: summary.xsl,v 1.5 2003/07/01 08:52:14 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: 
-->

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:saxon="http://icl.com/saxon"
  version="1.0">

  <xsl:import href="../../xsl/module.xsl"/>

  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>

  <xsl:template match="/" >
    <xsl:apply-templates select="./stylesheet_application"/>
  </xsl:template>

  <xsl:template match="stylesheet_application">
    <xsl:variable 
      name="module_xml_file"
      select="concat('../../data/modules/',@directory,'/module.xml')"/>

    <html>
      <link rel="stylesheet" type="text/css"
        href="../../../../nav/css/developer.css"/> 
      <xsl:variable name="title">
        <xsl:apply-templates select="document($module_xml_file)/module"
          mode="title"/>        
      </xsl:variable>
      <title>
        <xsl:value-of select="concat('Development view: ',$title)"/>
      </title>
      <body>
        <xsl:apply-templates select="document($module_xml_file)/module"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="module">
    <xsl:apply-templates select="." mode="banner"/>
    <xsl:apply-templates select="." mode="cover"/>
    <xsl:apply-templates select="./purpose"/>
    <xsl:apply-templates select="./inscope"/>
    <xsl:apply-templates select="./outscope"/>
    <xsl:apply-templates select="./arm"/>
  </xsl:template>

  <xsl:template match="module" mode="banner">
    <div class="toc">
      <!-- output the Table of contents banner -->
      <xsl:apply-templates 
        select="."
        mode="TOCmultiplePage">
        <xsl:with-param name="module_root" select="'..'"/>
      </xsl:apply-templates>
    </div>
  </xsl:template>

  <xsl:template match="module" mode="cover">
    <xsl:variable name="wg_group">
      <xsl:call-template name="get_module_wg_group">
        <xsl:with-param name="module" select="."/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="n_number"
      select="concat('ISO TC184/SC4/WG',$wg_group,'&#160;N',./@wg.number)"/>
    <xsl:variable name="test_wg_number">
      <xsl:call-template name="test_wg_number">
        <xsl:with-param name="wgnumber" select="./@wg.number"/>
      </xsl:call-template>
    </xsl:variable>
    
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

    <h3>       
      <xsl:value-of select="concat('Module: ',$module_name,'&#160;&#160;&#160;',$stdnumber)"/>
    </h3>



    <div class="summarytable">
      <table border="1">
        <tr>
          <td valign="top">
            <xsl:value-of select="concat('WG',$wg_group,'&#160; module number:')"/>
          </td>
          <td valign="top">
            <xsl:value-of select="$n_number"/>
            <xsl:if test="contains($test_wg_number,'Error')">
              <br/>
              <xsl:call-template name="error_message">
                <xsl:with-param name="message">
                  <xsl:value-of select="concat('Error in
                                        module.xml/module/@wg.number - ',
                                        $test_wg_number)"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:if>
          </td>
          
          <xsl:if test="@wg.number.supersedes">
            <td valign="top">Supersedes</td>
            <td valign="top">
              <xsl:choose>
                <xsl:when test="contains(@wg.number.supersedes, 'ISO')">
                  <xsl:value-of select="@wg.number.supersedes"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of 
                    select="concat('ISO&#160;TC184/SC4/WG',$wg_group,'&#160;N',@wg.number.supersedes)"/>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:variable name="test_wg_number_supersedes">
                <xsl:call-template name="test_wg_number">
                  <xsl:with-param name="wgnumber" select="./@wg.number.supersedes"/>
                </xsl:call-template>
              </xsl:variable>
              
              <xsl:if test="contains($test_wg_number_supersedes,'Error')">
                <br/>
                <xsl:call-template name="error_message">
                  <xsl:with-param name="message">
                    <xsl:value-of 
                      select="concat('Error in
                              module.xml/module/@wg.number.supersedes - ',
                              $test_wg_number_supersedes)"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:if>
              
              <xsl:if test="@wg.number.supersedes = @wg.number">
                <br/>
                <xsl:call-template name="error_message">
                  <xsl:with-param name="message">
                    Error in module.xml/module/@wg.number.supersedes - 
                    Error WG-16: New WG number is the same as superseded WG number.
                  </xsl:with-param>
                </xsl:call-template>            
              </xsl:if>
            </td>
          </xsl:if>
        </tr>
        
        <tr>
          <td valign="top">
            <xsl:value-of select="concat('WG',$wg_group,'&#160; ARM number:')"/>
          </td>
          <td valign="top">
            <xsl:value-of
              select="concat('ISO&#160;TC184/SC4/WG',$wg_group,'&#160;N',@wg.number.arm)"/>
          </td>
        </tr>
        
        <tr>
          <td valign="top">
            <xsl:value-of select="concat('WG',$wg_group,'&#160; MIM number:')"/>
          </td>
          <td valign="top">
            <xsl:value-of 
              select="concat('ISO&#160;TC184/SC4/WG',$wg_group,'&#160;N',@wg.number.mim)"/>
          </td>
        </tr>
        
        <tr>
          <td valign="top">
            <b>Publication date:&#x20;</b>
          </td>
          <td valign="top">
            <xsl:choose>
              <xsl:when test="string-length(@publication.year)>0">
                <xsl:value-of select="@publication.year"/>
              </xsl:when>
              <xsl:otherwise>
                -
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        
        <tr>
          <td width="50%" valign="TOP" height="88">
            <a name="contacts"/>
            <xsl:apply-templates select="./contacts/projlead"/>
          </td>
          <td width="50%" valign="TOP" height="88">
            <xsl:apply-templates select="./contacts/editor"/>
          </td>
        </tr>
      </table>
    </div>
  </xsl:template>
    
<xsl:template match="purpose">
  <h3>
    <a name="introduction">
      Introduction
    </a>
  </h3>

  <!-- output any issues -->
  <xsl:apply-templates select=".." mode="output_clause_issue">
    <xsl:with-param name="clause" select="'purpose'"/>
  </xsl:apply-templates>

  <!-- output the introduction -->
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="inscope">
  <xsl:variable name="module_name">
    <xsl:call-template name="module_display_name">
      <xsl:with-param name="module" select="../@name"/>
    </xsl:call-template>           
  </xsl:variable>
  <h3>In scope</h3>
  <p>
    The following are within the scope of 
    <xsl:value-of select="$module_name"/>.
    <a name="inscope"/>
  </p>

  <!-- output any issues -->
  <xsl:apply-templates select=".." mode="output_clause_issue">
    <xsl:with-param name="clause" select="'inscope'"/>
  </xsl:apply-templates>

  <ul>
    <xsl:apply-templates/>
  </ul>
</xsl:template>


<xsl:template match="outscope">
  <h3>Out of scope</h3>
  <xsl:variable name="module_name">
    <xsl:call-template name="module_display_name">
      <xsl:with-param name="module" select="../@name"/>
    </xsl:call-template>           
  </xsl:variable>
  <p>
    <a name="outscope"/>
    The following are outside the scope of 
    <xsl:value-of select="$module_name"/>.
  </p>
  <!-- output any issues -->
  <xsl:apply-templates select=".." mode="output_clause_issue">
    <xsl:with-param name="clause" select="'outscope'"/>
  </xsl:apply-templates>

  <ul>
    <xsl:apply-templates/>
  </ul>
</xsl:template>

<xsl:template match="arm">
  <a name="arm_dict"/>

  <xsl:variable name="arm_nodes" 
    select="document(concat('../../data/modules/',../@name,'/arm.xml'))"/>

  <xsl:if test="$arm_nodes/express/schema/type">
    <a name="arm_dict_types">
      <h3>ARM dictionary - Types</h3>
    </a>
    <xsl:apply-templates select="$arm_nodes/express/schema/type"/>
  </xsl:if>

  <xsl:if test="$arm_nodes/express/schema/entity">
    <a name="arm_dict_entities">
      <h3>ARM dictionary - Entities</h3>
    </a>
    <xsl:apply-templates select="$arm_nodes/express/schema/entity"/>
  </xsl:if>

  <xsl:if test="$arm_nodes/express/schema/rule">
    <a name="arm_dict_rules">
      <h3>ARM dictionary - Rules</h3>
    </a>
    <xsl:apply-templates select="$arm_nodes/express/schema/rule"/>    
  </xsl:if>

  <xsl:if test="$arm_nodes/express/schema/function">
    <a name="arm_dict_rules">
      <h3>ARM dictionary - Functions</h3>
    </a>
    <xsl:apply-templates select="$arm_nodes/express/schema/function"/>    
  </xsl:if>

  <xsl:if test="$arm_nodes/express/schema/procedure">
    <a name="arm_dict_rules">
      <h3>ARM dictionary - Procedure</h3>
    </a>
    <xsl:apply-templates select="$arm_nodes/express/schema/procedure"/>    
  </xsl:if>
  
</xsl:template>

<xsl:template match="entity">
  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="../@name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>    

  <p class="dictionary">
    <a href="../sys/4_info_reqs{$FILE_EXT}#{$aname}">
      <xsl:value-of select="concat(../@name,'.',@name)"/>
    </a>
  </p>
  <div class="dictionary_description">
  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="@name"/>
  </xsl:call-template> 
  <!-- output description from express -->
  <p>
    <xsl:choose>
      <xsl:when test="string-length(./description)>0">
        <xsl:apply-templates select="./description"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="external_description">
          <xsl:call-template name="check_external_description">
            <xsl:with-param name="schema" select="../@name"/>
            <xsl:with-param name="entity" select="@name"/>
          </xsl:call-template>        
        </xsl:variable>
        <xsl:if test="$external_description='false'">
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message" 
              select="concat('Error e4: No description provided for ',@name)"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </p>
</div>
</xsl:template>


<xsl:template match="type" >
  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>    

  <p class="dictionary">
    <a href="../sys/4_info_reqs{$FILE_EXT}#{$aname}">
      <xsl:value-of select="concat(../@name,'.',@name)"/>
    </a>
  </p>
  <div class="dictionary_description">

  <xsl:apply-templates select="./select" mode="description"/>

  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="type" select="./@name"/>
  </xsl:call-template> 
  <!-- output description from express -->

  <p>
    <xsl:choose>
      <xsl:when test="string-length(./description)>0">
        <xsl:apply-templates select="./description"/>
      </xsl:when>
      <xsl:otherwise>

        <!-- 
             disable error checking for selects as boiler plate
             should output text -->
        <xsl:if test="not(./select)">
          <xsl:variable name="external_description">
            <xsl:call-template name="check_external_description">
              <xsl:with-param name="schema" select="../@name"/>
              <xsl:with-param name="entity" select="@name"/>
            </xsl:call-template>        
          </xsl:variable>
          <xsl:if test="$external_description='false'">
            <xsl:call-template name="error_message">
              <xsl:with-param 
                name="message" 
                select="concat('Error e3: No description provided for ',$aname)"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </p>
</div>
</xsl:template>

<xsl:template match="rule">  
  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <p class="dictionary">
    <a href="../sys/4_info_reqs{$FILE_EXT}#{$aname}">
      <xsl:value-of select="concat(../@name,'.',@name)"/>
    </a>
  </p>
  <div class="dictionary_description">

  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="@name"/>
    <xsl:with-param name="type" select="@name"/>
    <xsl:with-param name="rule" select="@name"/>
  </xsl:call-template>
  <!-- output description from express -->
  <xsl:choose>
    <xsl:when test="string-length(./description)>0">
      <xsl:apply-templates select="./description"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="external_description">
        <xsl:call-template name="check_external_description">
          <xsl:with-param name="schema" select="../@name"/>
          <xsl:with-param name="entity" select="@name"/>
        </xsl:call-template>        
      </xsl:variable>
      <xsl:if test="$external_description='false'">
        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Error e13: No description provided for ',$aname)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</div>
</xsl:template>


<xsl:template match="function">
  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>
             
  <p class="dictionary">
    <a href="../sys/4_info_reqs{$FILE_EXT}#{$aname}">
      <xsl:value-of select="concat(../@name,'.',@name)"/>
    </a>
  </p>
  <div class="dictionary_description">
  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="@name"/>
    <xsl:with-param name="type" select="@name"/>
    <xsl:with-param name="function" select="@name"/>
  </xsl:call-template>
  <!-- output description from express -->
  <xsl:choose>
    <xsl:when test="string-length(./description)>0">
      <xsl:apply-templates select="./description"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="external_description">
        <xsl:call-template name="check_external_description">
          <xsl:with-param name="schema" select="../@name"/>
          <xsl:with-param name="entity" select="@name"/>
        </xsl:call-template>        
      </xsl:variable>
      <xsl:if test="$external_description='false'">
        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Error e10: No description provided for ',$aname)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</div>
</xsl:template>



<xsl:template match="procedure">  
  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <p class="dictionary">
    <a href="../sys/4_info_reqs{$FILE_EXT}#{$aname}">
      <xsl:value-of select="concat(../@name,'.',@name)"/>
    </a>
  </p>
  <div class="dictionary_description">
  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="@name"/>
  </xsl:call-template>
  <!-- output description from express -->
  <xsl:choose>
    <xsl:when test="string-length(./description)>0">
      <xsl:apply-templates select="./description"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="external_description">
        <xsl:call-template name="check_external_description">
          <xsl:with-param name="schema" select="../@name"/>
          <xsl:with-param name="entity" select="@name"/>
        </xsl:call-template>        
      </xsl:variable>
      <xsl:if test="$external_description='false'">
        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Error e11: No description provided for ',$aname)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</div>
</xsl:template>


</xsl:stylesheet>