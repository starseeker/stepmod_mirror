<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_g_change.xsl,v 1.13 2010/02/22 08:57:23 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"                
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:exslt="http://exslt.org/common"
  exclude-result-prefixes="msxsl exslt"
  version="1.0">
  
  <xsl:import href="module.xsl"/>

  <!-- 
       the stylesheet that allows different stylesheets to be applied 
       -->
  <xsl:import href="module_clause.xsl"/>


  <xsl:output method="html"/>

<!-- overwrites the template declared in module.xsl -->
<xsl:template match="module">
  <xsl:variable name="annex_letter">
    <xsl:choose>
      <xsl:when test="//changes and //usage_guide">G</xsl:when>
      <xsl:when test="//changes">F</xsl:when>
      <xsl:otherwise>G</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:call-template name="annex_header">
    <xsl:with-param name="annex_no" select="$annex_letter"/>
    <xsl:with-param name="heading" 
      select="'Change history'"/>
    <xsl:with-param name="aname" select="'annexg'"/>
  </xsl:call-template>
  
  <xsl:variable name="part_no">
    <xsl:choose>
      <xsl:when test="string-length(@part)>0">
        <xsl:value-of select="concat('ISO/TS 10303-',@part)"/>
      </xsl:when>
      <xsl:otherwise>
        ISO/TS 10303-XXXX
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:if test="changes">
    <!-- check that the number of change element corresponds to the edition  -->
    <xsl:if test="count(./changes/change)+1 != ./@version"> 
        <xsl:call-template name="error_message">
          <xsl:with-param name="inline" select="'yes'"/>
          <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
          <xsl:with-param name="message"
            select="concat('Error F1 Change module: ',/module/@name,' The number of change elements do not correspond to the edition')"/>
        </xsl:call-template> 
      </xsl:if>
  </xsl:if>

  <h2>
    <a name="general">
      <xsl:value-of select="concat($annex_letter,'.1 General')"/>
    </a>
  </h2>

  <xsl:choose>
    <xsl:when test="changes">
      <p>
        This annex documents the history of technical modifications made to 
        <xsl:value-of select="concat('ISO/TS 10303-',@part)"/>.
      </p>
      <xsl:apply-templates select="changes"/>
    </xsl:when>
    <xsl:otherwise>
      <p>
        This is the first edition of the part.
      </p>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
  

  <xsl:template match="changes">    
    
    <xsl:variable name="annex_letter">
      <xsl:choose>
        <xsl:when test="//changes and //usage_guide">G</xsl:when>
        <xsl:when test="//changes">F</xsl:when>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:for-each select="change">
      <xsl:sort select="@version"/>
      <xsl:variable name="aname" select="concat('change_',@version)"/>
      <h2>
        <a name="{$aname}">
          <xsl:value-of select="concat($annex_letter,'.',position()+1,' Changes made in edition ',@version)"/>
        </a>
      </h2>
      <h2>
        <a name="summary{@version}">
          <xsl:value-of select="concat($annex_letter,'.',position()+1,'.1 Summary of changes ')"/>
        </a>
      </h2>
      <p>
        <xsl:choose>
          <xsl:when test="@version = /module/@version">This </xsl:when>
          <xsl:otherwise>The </xsl:otherwise>
        </xsl:choose>          
        <xsl:call-template name="number_to_word">
          <xsl:with-param name="number" select="@version"/>
        </xsl:call-template>
        edition of this part of ISO 10303 
        <xsl:choose>
          <xsl:when test="@version = /module/@version">incorporates</xsl:when>
          <xsl:otherwise>incorporated</xsl:otherwise>
        </xsl:choose>         
        the modifications to the 
        <xsl:call-template name="number_to_word">
          <xsl:with-param name="number" select="string(@version - 1)"/>
        </xsl:call-template>
        edition listed below.
      </p>
      <xsl:apply-templates select="./description"/>
      <xsl:apply-templates select="./arm.changes">
        <xsl:with-param name="annex" select="concat($annex_letter,'.',position()+1)"/>
      </xsl:apply-templates>      
      <xsl:apply-templates select="./mapping.changes">
        <xsl:with-param name="annex" select="concat($annex_letter,'.',position()+1)"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="./mim.changes">
        <xsl:with-param name="annex" select="concat($annex_letter,'.',position()+1)"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="./arm_longform.changes">
        <xsl:with-param name="annex" select="concat($annex_letter,'.',position()+1)"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="./mim_longform.changes">
        <xsl:with-param name="annex" select="concat($annex_letter,'.',position()+1)"/>
      </xsl:apply-templates>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="arm.changes">
    <xsl:param name="annex"/>
    <xsl:variable name="aname" select="concat(name(),../@version)"/>
    <h2>
      <a name="{$aname}">
        <xsl:value-of select="concat($annex, '.2 Changes made to the ARM')"/>
      </a>
    </h2><xsl:apply-templates select="./description"/>
    <xsl:apply-templates select="./arm.additions"/>
    <xsl:apply-templates select="./arm.modifications"/>
    <xsl:apply-templates select="./arm.deletions"/>
    <p>
      In addition, modifications have been made to the mapping specification, 
      the MIM schema and the EXPRESS-G diagrams to reflect and be consistent 
      with the modifications of the ARM. 
    </p>
  </xsl:template>
  
  <xsl:template match="mapping.changes">   
    <xsl:param name="annex"/>
    <xsl:variable name="aname" select="concat(name(),../@version)"/>
    <xsl:variable name="section_number" select="count(../arm.changes)+2"/>
    <h2>
      <a name="{$aname}">
        <xsl:value-of select="concat($annex, '.', $section_number,' Changes made to the mapping')"/>
      </a>
    </h2> 
    <xsl:apply-templates select="./description"/>
    <xsl:if test="./mapping.change">
      <p> The following changes have been made to the ARM to MIM mapping:</p>
      <ul>
        <xsl:apply-templates select="mapping.change"/>
      </ul>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="mim.changes">
    <xsl:param name="annex"/>
    <xsl:variable name="section_number" select="count(../arm.changes)+count(../mapping.changes)+2"/>
    <xsl:variable name="aname" select="concat(name(),../@version)"/>
    <h2>
      <a name="{$aname}">
        <xsl:value-of select="concat($annex,'.', $section_number,' Changes made to the MIM')"/>
      </a>
    </h2>    
    <xsl:apply-templates select="./description"/>
    <xsl:apply-templates select="./mim.additions"/>
    <xsl:apply-templates select="./mim.modifications"/>
    <xsl:apply-templates select="./mim.deletions"/>
  </xsl:template>
  
  <xsl:template match="arm_longform.changes">
    <xsl:param name="annex"/>
    <xsl:variable name="section_number" 
      select="count(../arm.changes)+count(../mapping.changes)+count(../mim.changes)+2"/>
    <xsl:variable name="aname" select="concat(name(),../@version)"/>
    <h2>
      <a name="{$aname}">
        <xsl:value-of select="concat($annex, '.',$section_number,' Changes made to the ARM Longform')"/>
      </a>
    </h2><xsl:apply-templates select="./description"/>
    <xsl:apply-templates select="./arm.additions"/>
    <xsl:apply-templates select="./arm.modifications"/>
    <xsl:apply-templates select="./arm.deletions"/>
  </xsl:template>
  
  <xsl:template match="mim_longform.changes">
    <xsl:param name="annex"/>
    <xsl:variable name="section_number" 
      select="count(../arm.changes)+
              count(../mapping.changes)+
              count(../mim.changes)+
              count(../arm_longform.changes)+2"/>
    <xsl:variable name="aname" select="concat(name(),../@version)"/>
    <h2>
      <a name="{$aname}">
        <xsl:value-of select="concat($annex,'.', $section_number,' Changes made to the MIM Longform')"/>
      </a>
    </h2>    
    <xsl:apply-templates select="./description"/>
    <xsl:apply-templates select="./mim.additions"/>
    <xsl:apply-templates select="./mim.modifications"/>
    <xsl:apply-templates select="./mim.deletions"/>
  </xsl:template>
  
  <xsl:template match="arm.additions|arm.modifications|arm.deletions|mim.additions|mim.modifications|mim.deletions" mode="modified.object">
    <xsl:apply-templates select="./modified.object" mode="check_attributes"/>
    
    <xsl:variable name="arm_mim_clause">
      <xsl:choose>
        <xsl:when test="name()='mim.modifications'">5_mim</xsl:when>
        <xsl:when test="name()='mim.deletions'">5_mim</xsl:when>
        <xsl:otherwise>4_info_reqs</xsl:otherwise>
      </xsl:choose>      
    </xsl:variable>
    <xsl:variable name="arm_mim_suffix">
      <xsl:choose>
        <xsl:when test="name()='mim.modifications'">_mim</xsl:when>
        <xsl:when test="name()='mim.deletions'">_mim</xsl:when>
        <xsl:otherwise>_arm</xsl:otherwise>
      </xsl:choose>      
    </xsl:variable>
    
    <xsl:variable name="objects">
      <objects>
        <xsl:for-each select="modified.object[@type='CONSTANT']">
          <xsl:sort select="@name"/>
          <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="modified.object[@type='USE_FROM']">
          <xsl:sort select="@name"/>
          <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="modified.object[@type='REFERENCE_FROM']">
          <xsl:sort select="@name"/>
          <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="modified.object[@type='TYPE']">
          <xsl:sort select="@name"/>
          <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="modified.object[@type='ENTITY']">
          <xsl:sort select="@name"/>
          <xsl:copy-of select="."/>
        </xsl:for-each>        
        <xsl:for-each select="modified.object[@type='SUBTYPE_CONSTRAINT']">
          <xsl:sort select="@name"/>
          <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="modified.object[@type='RULE']">
          <xsl:sort select="@name"/>
          <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="modified.object[@type='FUNCTION']">
          <xsl:sort select="@name"/>
          <xsl:copy-of select="."/>
        </xsl:for-each>
      </objects>
    </xsl:variable>   
    <xsl:choose>
      <xsl:when test="function-available('msxsl:node-set')">
        <xsl:variable name="objectnodes" select="msxsl:node-set($objects)"/>
        <xsl:for-each select="$objectnodes//modified.object">
          <li>
            <xsl:choose>
              <xsl:when test="position()=last()">
                <xsl:apply-templates select=".">
                  <xsl:with-param name="arm_mim_clause" select="$arm_mim_clause"/>
                  <xsl:with-param name="arm_mim_suffix" select="$arm_mim_suffix"/>
                  </xsl:apply-templates>.</xsl:when>
              <xsl:otherwise><xsl:apply-templates select=".">
                <xsl:with-param name="arm_mim_clause" select="$arm_mim_clause"/>
                <xsl:with-param name="arm_mim_suffix" select="$arm_mim_suffix"/>
              </xsl:apply-templates>;</xsl:otherwise>
            </xsl:choose>            
          </li>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="function-available('exslt:node-set')">         
        <xsl:variable name="objectnodes" select="exslt:node-set($objects)"/>
        <xsl:for-each select="$objectnodes//modified.object">
          <li>
            <xsl:choose>
              <xsl:when test="position()=last()">
                <xsl:apply-templates select=".">
                  <xsl:with-param name="arm_mim_clause" select="$arm_mim_clause"/>
                  <xsl:with-param name="arm_mim_suffix" select="$arm_mim_suffix"/>
                </xsl:apply-templates>.</xsl:when>
              <xsl:otherwise><xsl:apply-templates select=".">
                <xsl:with-param name="arm_mim_clause" select="$arm_mim_clause"/>
                <xsl:with-param name="arm_mim_suffix" select="$arm_mim_suffix"/>
              </xsl:apply-templates>;</xsl:otherwise>
              </xsl:choose>
          </li>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>BROWSER NOT SUPPORTED</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template match="modified.object" mode="check_attributes">
    <xsl:if test="@type!='CONSTANT' and
      @type!='USE_FROM' and
      @type!='REFERENCE_FROM' and
      @type!='TYPE' and
      @type!='ENTITY' and
      @type!='SUBTYPE_CONSTRAINT' and
      @type!='RULE' and
      @type!='FUNCTION' or string-length(@type)=0">      
      <xsl:call-template name="error_message">
        <xsl:with-param name="message">
          <xsl:value-of select="concat('Error F4 Change : ',/module/@name,' 
            The modified.object has @type attribute =',@type,' should have a @type attribute = USE_FROM | REFERENCE_FROM | CONSTANT | TYPE | ENTITY | SUBTYPE_CONSTRAINT | RULE | FUNCTION')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>    
  </xsl:template>
  
  <xsl:template name="output_interfaced_items">
    <xsl:param name="interface_type"/>
    <xsl:param name="interface_name"/>
    <xsl:param name="interfaced_items"/>
    <xsl:variable name="output2" 
      select="translate(normalize-space(translate($interfaced_items,',()','   ')),' ',', ')"/>
    <xsl:variable name="output1">
      <xsl:call-template name="output_comma_separated_list">
        <xsl:with-param name="string" 
          select="normalize-space(translate($interfaced_items,',()','   '))"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="concat($interface_type,' ',$interface_name,'(',$output1,')')"/>    
  </xsl:template>
  
    
  <xsl:template match="modified.object">
    <xsl:param name="arm_mim_clause"/>
    <xsl:param name="arm_mim_suffix"/>
    <xsl:variable name="object">
      <xsl:choose>
        <xsl:when test="string-length(@interfaced.items)!=0">
          <xsl:call-template name="output_interfaced_items">
            <xsl:with-param name="interface_type" select="@type"/>
            <xsl:with-param name="interface_name" select="@name"/>
            <xsl:with-param name="interfaced_items" select="@interfaced.items"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="concat(@type,' ',@name)"/></xsl:otherwise>
      </xsl:choose>      
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@moved-to-module"><xsl:variable name="module_ok">
          <xsl:call-template name="check_module_exists">
            <xsl:with-param name="module" select="@moved-to-module"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$module_ok='true'">
            <xsl:value-of select="concat($object,' has been moved to the module ',@moved-to-module)"/>
            <!--<xsl:value-of select="concat($object,' has been moved to the module ')"/>
            <xsl:variable name="module_href"
              select="concat('../../../modules/',@moved-to-module,'/sys/',$arm_mim_clause,$FILE_EXT,'#',@moved-to-module,$arm_mim_suffix,'.',@name)"/>
            <a href="{$module_href}">
              <xsl:value-of select="@moved-to-module"/>
            </a>-->
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="error_message">
              <xsl:with-param name="message">
                <xsl:value-of select="concat('Error F3 Change : ',/module/@name,$module_ok)"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="@moved-to-resource">
        <xsl:variable name="resource_ok">
          <xsl:call-template name="check_resource_exists">
            <xsl:with-param name="schema" select="@moved-to-resource"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$resource_ok='true'">
            <xsl:value-of select="concat($object,' has been moved to the resource ',@moved-to-resource )"/>
            <!--<xsl:variable name="resource_href"
              select="concat('../../../resources/',@moved-to-resource,'/',@moved-to-resource,$FILE_EXT,'#',@name)"/>
            <xsl:value-of select="concat($object,' has been moved to the resource ')"/>
            <a href="{$resource_href}">
              <xsl:value-of select="@moved-to-resource"/>
            </a>-->
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="error_message">
              <xsl:with-param name="message">
                <xsl:value-of select="concat('Error F3 Change : ',/module/@name,$resource_ok)"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$object"/>
        <xsl:apply-templates select="description" mode="modified.object"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="p" mode="position">
    <xsl:value-of select="position()"/>
  </xsl:template>
  
  <xsl:template match="description" mode="modified.object">
    <xsl:if test="string-length(normalize-space(./child::text()[1])!=0)">
        <br/>  
    </xsl:if>    
    <xsl:apply-templates select="."/>
  </xsl:template>
  
  
  <xsl:template match="arm.additions">    
    <p>
      The following ARM EXPRESS declarations and interface specifications have been added: 
    </p>
    <ul>  
      <xsl:apply-templates select="." mode="modified.object"/>
    </ul>
  </xsl:template>
  
  <xsl:template match="arm.modifications">   
    <p>
      The following ARM EXPRESS declarations and interface specifications have been modified:  
    </p>
    <ul>  
      <xsl:apply-templates select="." mode="modified.object"/>
    </ul>
  </xsl:template>
  
  <xsl:template match="arm.deletions">   
    <p>
      The following ARM EXPRESS declarations and interface specifications have been removed: 
    </p>
    <ul>  
      <xsl:apply-templates select="." mode="modified.object"/>
    </ul>
  </xsl:template>
  

  <xsl:template match="mapping.change">
    <li>
      <xsl:apply-templates/>
    </li>
  </xsl:template>
  
  <xsl:template match="mim.additions">    
    <p>
      The following MIM EXPRESS declarations and interface specifications have been added: 
    </p>
    <ul>  
      <xsl:apply-templates select="." mode="modified.object"/>
    </ul>
  </xsl:template>
  
  <xsl:template match="mim.modifications">   
    <p>
      The following MIM EXPRESS declarations and interface specifications have been modified:  
    </p>
    <ul>  
      <xsl:apply-templates select="." mode="modified.object"/>
    </ul>
  </xsl:template>
  
  <xsl:template match="mim.deletions">   
    <p>
      The following MIM EXPRESS declarations and interface specifications have been removed: 
    </p>
    <ul>  
      <xsl:apply-templates select="." mode="modified.object"/>
    </ul>
  </xsl:template>
  
  

</xsl:stylesheet>
