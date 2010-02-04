<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_g_change.xsl,v 1.2 2010/02/04 16:53:43 robbod Exp $
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
        A change history has not been provided.
      </p>
    </xsl:otherwise>
  </xsl:choose>
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
          <xsl:value-of select="concat($annex_letter,'.',position()+1,' Changes made to edition ',@version)"/>
        </a>
      </h2>
      <h2>
        <a name="{$aname}">
          <xsl:value-of select="concat($annex_letter,'.',position()+1,'.1 Summary of changes ')"/>
        </a>
      </h2>
      <p>
        The 
        <xsl:call-template name="number_to_word">
          <xsl:with-param name="number" select="@version"/>
        </xsl:call-template>
        edition of this part of ISO 10303 incorporated the modifications to the 
        <xsl:call-template name="number_to_word">
          <xsl:with-param name="number" select="@version - 1"/>
        </xsl:call-template>
        edition listed below.
      </p>
      <xsl:apply-templates select="./description"/>
      <xsl:apply-templates select="./arm.changes">
        <xsl:with-param name="annex" select="concat($annex_letter,'.',position()+2)"/>
      </xsl:apply-templates>      
      <xsl:apply-templates select="./mapping.changes">
        <xsl:with-param name="annex" select="concat($annex_letter,'.',position()+2)"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="./mim.changes">
        <xsl:with-param name="annex" select="concat($annex_letter,'.',position()+2)"/>
      </xsl:apply-templates>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="arm.changes">
    <xsl:param name="annex"/>
    <xsl:variable name="aname" select="concat('arm_',@version)"/>
    <h2>
      <a name="{$aname}">
        <xsl:value-of select="concat($annex,'.1 Changes made to the ARM')"/>
      </a>
    </h2>
    <xsl:apply-templates select="./description"/>
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
    <xsl:variable name="aname" select="concat('map_',@version)"/>
    <h2>
      <a name="{$aname}">
        <xsl:value-of select="concat($annex,'.1 Changes made to the mapping')"/>
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
    <xsl:variable name="annex_number">
      <xsl:choose>
        <xsl:when test="../arm.changes">
          <xsl:value-of select="concat($annex,'.2')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($annex,'.1')"/>
        </xsl:otherwise>
      </xsl:choose>      
    </xsl:variable>
    <xsl:variable name="aname" select="concat('mim_',@version)"/>
    <h2>
      <a name="{$aname}">
        <xsl:value-of select="concat($annex_number,' Changes made to the MIM')"/>
      </a>
    </h2>    
    <xsl:apply-templates select="./description"/>
    <xsl:apply-templates select="./mim.additions"/>
    <xsl:apply-templates select="./mim.modifications"/>
    <xsl:apply-templates select="./mim.deletions"/>
  </xsl:template>
  
  <xsl:template match="arm.additions|arm.modifications|arm.deletions|mim.additions|mim.modifications|mim.deletions" mode="modified.object">
   
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
              <xsl:when test="position()=last()"><xsl:apply-templates select="."/>.</xsl:when>
              <xsl:otherwise><xsl:apply-templates select="."/>;</xsl:otherwise>
            </xsl:choose>            
          </li>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="function-available('exslt:node-set')">         
        <xsl:variable name="objectnodes" select="exslt:node-set($objects)"/>
        <xsl:for-each select="$objectnodes//modified.object">
          <li>
            <xsl:choose>
              <xsl:when test="position()=last()"><xsl:apply-templates select="."/>.</xsl:when>
              <xsl:otherwise><xsl:apply-templates select="."/>;</xsl:otherwise>
            </xsl:choose>            
          </li>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>BROWSER NOT SUPPORTED</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="modified.object">
    <xsl:choose>
      <xsl:when test="@moved-to-module">
        <xsl:variable name="module_href"
          select="concat('../../../modules/',@moved-to-module,'/sys/5_mim',$FILE_EXT,'#',@moved-to-module,'_mim.',@name)"/>
        <xsl:variable name="module_ok">
          <xsl:call-template name="check_module_exists">
            <xsl:with-param name="module" select="@moved-to-module"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$module_ok='true'">
            <xsl:value-of select="concat(@type,' ',@name, ' has been moved to the module ')"/>
            <a href="{$module_href}">
              <xsl:value-of select="@moved-to-module"/>
            </a>            
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
        <xsl:variable name="resource_href"
          select="concat('../../../modules/',@moved-to-resource,'/sys/5_mim',$FILE_EXT,'#',@moved-to-module,'_mim.',@name)"/>
        <xsl:variable name="resource_ok">
          <xsl:call-template name="check_resource_exists">
            <xsl:with-param name="schema" select="@moved-to-resource"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$resource_ok='true'">
            <xsl:value-of select="concat(@type,' ',@name, ' has been moved to the resource ')"/>
            <a href="{$resource_href}">
              <xsl:value-of select="@moved-to-resource"/>
            </a>
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
        <xsl:value-of select="concat(@type,' ',@name)"/>
        <xsl:apply-templates select="description"/>
      </xsl:otherwise>
    </xsl:choose>
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
