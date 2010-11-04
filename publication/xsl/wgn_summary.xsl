<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: part1000_publication_summary.xsl,v 1.8 2010/02/21 10:29:45 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited http://www.eurostep.com
  Purpose: To display a table summarising the modules in a publication package

-->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:exslt="http://exslt.org/common"
  exclude-result-prefixes="msxsl exslt"
  version="1.0">

  <xsl:import href="../../xsl/ap_doc/common.xsl"/>
  <xsl:import href="../../xsl/res_doc/common.xsl"/>


  <xsl:output 
    method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    indent="yes"
    />

    <xsl:param name="stepmodhome" select="'../../../..'"/>
    <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>
    <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

  <!-- force the application of the stylesheet to the file specified in the
       file attribute -->
  <xsl:template match="/">
    <xsl:variable name="publication_index" 
      select="concat('../part1000/',./publication/@directory,'/publication_index.xml')"/>
    <xsl:apply-templates select="document($publication_index)/part1000.publication_index"/>
  </xsl:template>

  <xsl:template match="part1000.publication_index">
    <HTML>
    <head>
      <title>
        <xsl:value-of select="@name"/>
      </title>
    </head>
      <body>
          <hr/>
        <h2>Part 1000 change request</h2>
        <hr/>
        
        <xsl:variable name="index_file">
          <xsl:choose>
            <xsl:when test="$FILE_EXT='.xml'">
              <xsl:value-of select="concat('publication_summary',$FILE_EXT)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="'index.htm'"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <p><a href="{$index_file}">CR index</a></p>
        <p>This provides a summary of all the modules listing which modules have had ARMs and MIMs 
        changed. It is useful for checking the WG numbers.</p>
        <p>Note: It gets the information about the ARM/MIM changes from the change requests: publication_index.xml</p>
       <hr/>
        
      <xsl:apply-templates select="./modules" mode="table"/>      
    </body>
  </HTML>
  </xsl:template>

  <xsl:template match="modules" mode="table">
    <xsl:variable name="modules">
      <modules>
        <xsl:for-each select="module">
          <xsl:variable name="module_ok">
            <xsl:call-template name="check_module_exists">
              <xsl:with-param name="module" select="@name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="$module_ok='true'">
            <module>
              <xsl:variable name="module_file"
                select="concat('../../data/modules/',@name,'/module.xml')"/>
              <xsl:variable name="module_node" select="document($module_file)/module"/>              
              <xsl:attribute name="name">
                <xsl:value-of select="@name"/>
              </xsl:attribute>
              
              <xsl:attribute name="name.french">
                <xsl:value-of select="$module_node/@name.french"/>
              </xsl:attribute>
              <xsl:attribute name="part">
                <xsl:value-of select="$module_node/@part"/>
              </xsl:attribute>
              <xsl:attribute name="previous.revision.year">
                <xsl:value-of select="$module_node/@previous.revision.year"/>
              </xsl:attribute>              
              <xsl:attribute name="publication.date">
                <xsl:value-of select="$module_node/@publication.date"/>
              </xsl:attribute>              
              <xsl:attribute name="publication.year">
                <xsl:value-of select="$module_node/@publication.year"/>
              </xsl:attribute>              
              <xsl:attribute name="published">        
                <xsl:value-of select="$module_node/@published"/>
              </xsl:attribute>              
              <xsl:attribute name="status">
                <xsl:value-of select="$module_node/@status"/>
              </xsl:attribute>              
              <xsl:attribute name="version">
                <xsl:value-of select="$module_node/@version"/>
              </xsl:attribute>   
              
              <xsl:attribute name="arm.change">
                <xsl:value-of select="./@arm.change"/>
              </xsl:attribute>  
              <xsl:attribute name="mim.change">
                <xsl:value-of select="./@mim.change"/>
              </xsl:attribute>   
              
              <xsl:attribute name="wg.number">
                <xsl:value-of select="$module_node/@wg.number"/>
              </xsl:attribute>            
              <xsl:attribute name="wg.number.arm">
                <xsl:value-of select="$module_node/@wg.number.arm"/>
              </xsl:attribute>            
              <xsl:attribute name="wg.number.mim">
                <xsl:value-of select="$module_node/@wg.number.mim"/>
              </xsl:attribute>             
              </module>
          </xsl:if>
        </xsl:for-each>
      </modules>
    </xsl:variable>
    <p/>
    <h3>      
      <a name="modulenames">Modules sorted by name</a>
    </h3> 
    <p><a href="#index">Index</a></p>
    <table border="1">
      <tr>
        <td><b>Module</b></td>
        <td><b>Part</b></td>
        <td><b>Stage</b></td>
        <td><b>Edition</b></td>
        <td><b>Year of<br/>publication</b></td>   
        <td><b>Date of<br/>publication</b></td> 
        <td><b>Previous year<br/>of publication</b></td>       
        <td><b>Published</b></td>
       <!-- <td><b>Title</b></td>
        <td><b>French title</b></td>
        <td><b>CVS file revisions</b></td>-->
        <td><b>Module WGN</b></td>
        <td><b>ARM changed?</b></td>
        <td><b>ARM WGN</b></td>
        <td><b>MIM changed?</b></td>
        <td><b>MIM WGN</b></td>
      </tr>
           
      <xsl:choose>
        <xsl:when test="function-available('msxsl:node-set')">
          <xsl:variable name="modules_nodes" select="msxsl:node-set($modules)"/>
          <xsl:apply-templates select="$modules_nodes//module" mode="table_row">
            <xsl:sort select="@name"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="function-available('exslt:node-set')">
          <xsl:variable name="modules_nodes" select="exslt:node-set($modules)"/>
          <xsl:apply-templates select="$modules_nodes//module" mode="table_row">
            <xsl:sort select="@name"/>
          </xsl:apply-templates>
        </xsl:when>
      </xsl:choose>
    </table>
 
 
    <h3>      
      <a name="modulenos">Modules sorted by part number</a>
    </h3>
    <p><a href="#index">Index</a></p>
    <table border="1">
      <tr>
        <td><b>Module</b></td>
        <td><b>Part</b></td>
        <td><b>Stage</b></td>
        <td><b>Edition</b></td>
        <td><b>Year of<br/>publication</b></td>   
        <td><b>Date of<br/>publication</b></td> 
        <td><b>Previous year<br/>of publication</b></td>       
        <td><b>Published</b></td><!--
        <td><b>Title</b></td>
        <td><b>French title</b></td>
        <td><b>CVS file revisions</b></td>-->
        <td><b>Module WGN</b></td>
        <td><b>ARM changed?</b></td>
        <td><b>ARM WGN</b></td>
        <td><b>MIM changed?</b></td>
        <td><b>MIM WGN</b></td>
      </tr>
      
      <xsl:choose>
        <xsl:when test="function-available('msxsl:node-set')">
          <xsl:variable name="modules_nodes" select="msxsl:node-set($modules)"/>
          <xsl:apply-templates select="$modules_nodes//module" mode="table_row">
            <xsl:sort select="@part"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="function-available('exslt:node-set')">
          <xsl:variable name="modules_nodes" select="exslt:node-set($modules)"/>
          <xsl:apply-templates select="$modules_nodes//module" mode="table_row">
            <xsl:sort select="@part"/>
          </xsl:apply-templates>
        </xsl:when>
      </xsl:choose>
    </table>
  </xsl:template>
    
  <xsl:template match="module" mode="table_row">
    <xsl:variable name="module_ok">
      <xsl:call-template name="check_module_exists">
        <xsl:with-param name="module" select="@name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$module_ok='true'">
        <xsl:variable name="pub_dir" select="concat($stepmodhome,'/part1000')"/>
        
        <xsl:variable name="mod_dir_name"
          select="concat('iso10303_',./@part)"/>
        
        <tr>
          <!-- Module -->
          <td>
            <xsl:variable name="mod_xref"
              select="concat($pub_dir,'/data/modules/',@name,'/sys/cover.htm')"/>
            <a href="{$mod_xref}">
              <xsl:value-of select="@name"/>
            </a>

            <xsl:variable name="mod_name" select="@name"/>
            <xsl:if test="count(../module[@name=$mod_name])!=1">
              <xsl:call-template name="error_message">
                <xsl:with-param name="message">
                  <xsl:value-of
                    select="concat('Module ',@name,' is duplicated in publication_index.xml')"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:if>
          </td>

          <!-- Part -->
          <td>
            <xsl:choose>
              <xsl:when test="./@part">
                <xsl:value-of select="concat('10303-',./@part)"/>

                <!-- check that the part number in repository_index - that in
                     module -->
                <xsl:variable name="module" select="@name"/>
                <xsl:variable name="repo_mod_number"
                  select="document('../../repository_index.xml')/repository_index/modules/module[@name=$module]/@part"/>
                <xsl:if test="$repo_mod_number != ./@part">
                  <br/>
                  <font color="#FF0000" size="-1"> The part number in repository_index
                      (<xsl:value-of select="$repo_mod_number"/>) does not equal that in module
                      (<xsl:value-of select="./@part"/>). </font>
                </xsl:if>
              </xsl:when>
              <xsl:otherwise> - </xsl:otherwise>
            </xsl:choose>
          </td>

          <!-- Stage -->
          <td>
            <xsl:choose>
              <xsl:when test="string-length(normalize-space(./@status))>0">
                <xsl:value-of select="./@status"/>
              </xsl:when>
              <xsl:otherwise> - </xsl:otherwise>
            </xsl:choose>
          </td>

          <!-- Version -->
          <td>
            <xsl:choose>
              <xsl:when test="string-length(normalize-space(./@version))>0">
                <xsl:value-of select="./@version"/>
              </xsl:when>
              <xsl:otherwise> - </xsl:otherwise>
            </xsl:choose>
          </td>

          <!-- Year -->
          <td>
            <xsl:choose>
              <xsl:when test="string-length(normalize-space(./@publication.year))>0">
                <xsl:value-of select="./@publication.year"/>
              </xsl:when>
              <xsl:otherwise> - </xsl:otherwise>
            </xsl:choose>
          </td>
          <!-- Date -->
          <td>
            <xsl:choose>
              <xsl:when test="string-length(normalize-space(./@publication.date))>0">
                <xsl:value-of select="./@publication.date"/>
              </xsl:when>
              <xsl:otherwise> - </xsl:otherwise>
            </xsl:choose>
          </td>

          <!-- Previous ed date -->
          <td>
            <xsl:choose>
              <xsl:when test="string-length(normalize-space(./@previous.revision.year))>0">
                <xsl:value-of select="./@previous.revision.year"/>
              </xsl:when>
              <xsl:otherwise> - </xsl:otherwise>
            </xsl:choose>
          </td>

          <td>
            <xsl:value-of select="./@published"/>
          </td>

<!--
          <!-\-  Title -\->
          <td>
            <xsl:call-template name="module_display_name">
              <xsl:with-param name="module" select="./@name"/>
            </xsl:call-template>
          </td>
          <!-\- French Title -\->
          <td>
            <xsl:call-template name="module_display_name">
              <xsl:with-param name="module" select="./@name.french"/>
            </xsl:call-template>
          </td>
          <!-\- CVS revisions -\->
          <td>
            <xsl:variable name="cvs_xref"
              select="concat($pub_dir,'/data/modules/',@name,'/publication_record.xml')"/>

            <a href="{$cvs_xref}">publication_record.xml</a>
          </td>-->

          <!--Module WGN-->
          <td><xsl:value-of select="./@wg.number"/></td>

          <!-- ARM changed? -->
          <td><xsl:value-of select="./@arm.change"/></td>

          <!--ARM WGN-->
          <td><xsl:value-of select="./@wg.number.arm"/></td>

          <!--MIM changed?-->
          <td><xsl:value-of select="./@mim.change"/></td>

          <!--MIM WGN-->
          <td><xsl:value-of select="./@wg.number.mim"/></td>
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
              <xsl:value-of select="concat('Error publication1: ', $module_ok)"/>
            </xsl:with-param>
          </xsl:call-template>
        </td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td><!--
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>-->
        
         <!--Module WGN-->
        <td>&#160;</td>
        
        <!-- ARM changed? -->
        <td>&#160;</td>       
        
        <!--ARM WGN-->
        <td>&#160;</td>
        

        <!--MIM changed?-->
        <td>&#160;</td>
        <!--MIM WGN-->
        <td>&#160;</td>
      </tr>      
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>