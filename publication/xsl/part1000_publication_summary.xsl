<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: part1000_publication_summary.xsl,v 1.13 2015/08/28 08:56:37 mikeward Exp $
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
    <xsl:variable name="pub_dir" select="./publication/@directory"/>
    
    <xsl:variable name="publication_index" 
      select="concat('../part1000/', $pub_dir,'/publication_index.xml')"/>
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
      <table>
        <tr>
          <td>Publication set name:</td>
          <td><xsl:value-of select="@name"/></td>
        </tr>
        <tr>
          <td>Date submitted to ISO:</td>
          <td><xsl:value-of select="@date.iso_submission"/></td>
        </tr>
        <tr>
          <td>Date published by ISO:</td>
          <td><xsl:value-of select="@date.iso_publication"/></td>
        </tr>
        <tr>
          <td>Publication set working group:</td>
          <td><xsl:value-of select="@sc4.working_group"/></td>
        </tr>

        <tr>
          <td>Publication set WG number:</td>
          <xsl:variable name="wgroup">
            <xsl:choose>
              <xsl:when test="contains(@sc4.working_group,'WG')">
                <xsl:value-of select="normalize-space(substring-after(@sc4.working_group,'WG'))"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="normalize-space(@sc4.working_group)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <td><xsl:value-of select="concat('WG',$wgroup,' N', @wg.number.publication_set)"/></td>
        </tr>
        <tr>
          <td>Publication project leader:</td>
          <td>
              <xsl:apply-templates select="./contacts/projlead"
                mode="no_address"/>
          </td>
        </tr>
        <tr>
          <td>Description:</td>
          <td><xsl:value-of select="@description"/><xsl:value-of select="./description"/></td>
        </tr>
      </table>
      <hr/>
        
        <p><a name="index">Index</a></p>
        <ul>
          <li>
            <!-- NOTE - not all packages have normref_check file -->

            <a href="bibliography_check{$FILE_EXT}">All bibliographies</a>
          </li>
          <li>
            <!-- NOTE - not all packages have normref_check file --> SC4: All normative references
              <a href="normref_check{$FILE_EXT}">check</a>
          </li>
          <li>
            <a> SC4: Modules error check <a href="modules_check{$FILE_EXT}">check</a>
            </a>
          </li>
          <li>
            <a> SC4: Modules summary <a href="wgn_summary{$FILE_EXT}">check</a>
            </a>
          </li>
          <li>
            <a href="#modulenames">Modules sorted by name</a>
          </li>
          <li>
            <a href="#modulenos">Modules sorted by part number</a>
          </li>
          
          <li>
            <a href="#delmodulenames">Deleted Modules sorted by name</a>
          </li>
          <xsl:if test="//resource_docs/resource_doc">
          <li>
            <a href="#resourcenames">Resources sorted by name</a><!-- MWD --> 
          </li>
          <li>
            <a href="#resourcenos">Resources sorted by part number</a><!-- MWD --> 
          </li>
          </xsl:if>
          <xsl:if test="//deleted.resource_docs/resource_doc">
            <li>
              <a href="#delresourcenames">Deleted Resources sorted by name</a><!-- MWD --> 
            </li>
          </xsl:if>
        </ul>
        
        <xsl:apply-templates select="./modules" mode="table"/>    
        <xsl:apply-templates select="./deleted.modules" mode="table"/>
        <xsl:apply-templates select="./resource_docs" mode="table"/> <!-- MWD -->   
        <xsl:apply-templates select="./deleted.resource_docs" mode="table"/>  <!-- MWD -->         
    </body>
  </HTML>
  </xsl:template>
  
  <xsl:template match="deleted.modules" mode="table">
    <h3>
      <a name="delmodulenames">Deleted Modules sorted by name</a>
    </h3>
    <p>
      <a href="#index">Index</a>
    </p>
    <table border="1">
      <tr>
        <td>
          <b>Module</b>
        </td>
        <td>
          <b>Team</b>
        </td>
        <td>
          <b>Collector Bug</b>
        </td>
      </tr>
      <xsl:for-each select="module">
        <xsl:sort select="@name"/>
        <tr>
          <!-- Module -->
          <td>
            <xsl:value-of select="@name"/>
          </td>
          <td>
            <xsl:value-of select="@team"/>
          </td>
          <td>
            <xsl:value-of select="@collector_bug"/>
          </td>
        </tr>
      </xsl:for-each>
    </table>
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
              
              <xsl:variable name="part" select="$module_node/@part"/>
              
              <xsl:attribute name="part">
                <xsl:value-of select="$part"/>
              </xsl:attribute>
              
              <xsl:variable name="partNoLength" select="string-length($part)"/>
              <xsl:variable name="partNoWithLeadingZeros">
                <xsl:choose>
                  <xsl:when test="$partNoLength=1"><xsl:value-of select="concat('000000', $part)"/></xsl:when>
                  <xsl:when test="$partNoLength=2"><xsl:value-of select="concat('00000', $part)"/></xsl:when>
                  <xsl:when test="$partNoLength=3"><xsl:value-of select="concat('0000', $part)"/></xsl:when>
                  <xsl:when test="$partNoLength=4"><xsl:value-of select="concat('000', $part)"/></xsl:when>
                  <xsl:when test="$partNoLength=5"><xsl:value-of select="concat('00', $part)"/></xsl:when>
                  <xsl:when test="$partNoLength=6"><xsl:value-of select="concat('0', $part)"/></xsl:when>
                  <xsl:otherwise><xsl:value-of select="@part"/></xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              
              <xsl:attribute name="partNoWithLeadingZeros">
                <xsl:value-of select="$partNoWithLeadingZeros"/>
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
              <xsl:attribute name="collector_bug">
                <xsl:value-of select="@collector_bug"/>
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
        <td><b>Title</b></td>
        <td><b>French title</b></td>
        <td><b>CVS file revisions</b></td>
        <td><b>Collector Bug</b></td>
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
        <td><b>Published</b></td>
        <td><b>Title</b></td>
        <td><b>French title</b></td>
        <td><b>CVS file revisions</b></td>
        <td><b>Collector Bug</b></td>
      </tr>
      
      <xsl:choose>
        <xsl:when test="function-available('msxsl:node-set')">
          <xsl:variable name="modules_nodes" select="msxsl:node-set($modules)"/>
          <xsl:apply-templates select="$modules_nodes//module" mode="table_row">
            <xsl:sort select="@partNoWithLeadingZeros"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="function-available('exslt:node-set')">
          <xsl:variable name="modules_nodes" select="exslt:node-set($modules)"/>
          <xsl:apply-templates select="$modules_nodes//module" mode="table_row">
            <xsl:sort select="@partNoWithLeadingZeros"/>
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
                   <xsl:value-of select="concat('Module ',@name,' is duplicated in publication_index.xml')"/>
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
                  <font color="#FF0000" size="-1">
                    The part number in repository_index
                    (<xsl:value-of select="$repo_mod_number"/>)
                  does not equal that in module 
                  (<xsl:value-of select="./@part"/>).
                </font>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>
        
        <!-- Stage -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space(./@status))>0">
              <xsl:value-of select="./@status"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>
        
          <!-- Version -->
          <td>
            <xsl:choose>
              <xsl:when 
                test="string-length(normalize-space(./@version))>0">
                <xsl:value-of select="./@version"/>
              </xsl:when>
              <xsl:otherwise>
                -
              </xsl:otherwise>
            </xsl:choose>
          </td>
          
          <!-- Year -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space(./@publication.year))>0">
              <xsl:value-of select="./@publication.year"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>
          <!-- Date -->
          <td>
            <xsl:choose>
              <xsl:when 
                test="string-length(normalize-space(./@publication.date))>0">
                <xsl:value-of select="./@publication.date"/>
              </xsl:when>
              <xsl:otherwise>
                -
              </xsl:otherwise>
            </xsl:choose>
          </td>
          
        <!-- Previous ed date -->
          <td>
            <xsl:choose>
              <xsl:when 
                test="string-length(normalize-space(./@previous.revision.year))>0">
                <xsl:value-of select="./@previous.revision.year"/>
              </xsl:when>
              <xsl:otherwise>
                -
              </xsl:otherwise>
            </xsl:choose>
          </td>
           
        <td>
          <xsl:value-of select="./@published"/>          
        </td>
          
          
          <!--  Title -->
          <td>
            <xsl:call-template name="module_display_name">
              <xsl:with-param name="module" select="./@name"/>
            </xsl:call-template>            
          </td>
          <!-- French Title -->
          <td>
            <xsl:call-template name="module_display_name">
              <xsl:with-param name="module" select="./@name.french"/>
            </xsl:call-template> 
          </td>
        <!-- CVS revisions -->
        <td>
          <xsl:variable name="cvs_xref"
            select="concat($pub_dir,'/data/modules/',@name,'/publication_record.xml')"/>
          
          <a href="{$cvs_xref}">publication_record.xml</a>
        </td>
          <!-- bug -->
          <td>
            <xsl:value-of select="./@collector_bug"/>  
          </td>
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
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
        <td>&#160;</td>
      </tr>      
    </xsl:otherwise>
  </xsl:choose>
  </xsl:template>
  
  <!-- MWD -->
  
  <xsl:template match="resource_docs" mode="table">
    <xsl:variable name="resources">
      <resources>
        <xsl:for-each select="resource_doc">
          <xsl:variable name="resource_doc_ok">
            <xsl:call-template name="check_resource_doc_exists">
              <xsl:with-param name="resource_doc" select="@name"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="$resource_doc_ok='true'">
            <resource>
              <xsl:variable name="resource_file"
                select="concat('../../data/resource_docs/',@name,'/resource.xml')"/>
              <xsl:variable name="resource_node" select="document($resource_file)/resource"/>              
              <xsl:attribute name="name">
                <xsl:value-of select="@name"/>
              </xsl:attribute>
              
              <xsl:attribute name="name.french">
                <xsl:value-of select="$resource_node/@name.french"/>
              </xsl:attribute>
              
              <xsl:variable name="part" select="$resource_node/@part"/>
              
              <xsl:attribute name="part">
                <xsl:value-of select="$part"/>
              </xsl:attribute>
              
              <xsl:variable name="partNoLength" select="string-length($part)"/>
              <xsl:variable name="partNoWithLeadingZeros">
                <xsl:choose>
                  <xsl:when test="$partNoLength=1"><xsl:value-of select="concat('000000', $part)"/></xsl:when>
                  <xsl:when test="$partNoLength=2"><xsl:value-of select="concat('00000', $part)"/></xsl:when>
                  <xsl:when test="$partNoLength=3"><xsl:value-of select="concat('0000', $part)"/></xsl:when>
                  <xsl:when test="$partNoLength=4"><xsl:value-of select="concat('000', $part)"/></xsl:when>
                  <xsl:when test="$partNoLength=5"><xsl:value-of select="concat('00', $part)"/></xsl:when>
                  <xsl:when test="$partNoLength=6"><xsl:value-of select="concat('0', $part)"/></xsl:when>
                  <xsl:otherwise><xsl:value-of select="@part"/></xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              
              <xsl:attribute name="partNoWithLeadingZeros">
                <xsl:value-of select="$partNoWithLeadingZeros"/>
              </xsl:attribute> 
              
              <xsl:attribute name="previous.revision.year">
                <xsl:value-of select="$resource_node/@previous.revision.year"/>
              </xsl:attribute>              
              <xsl:attribute name="publication.date">
                <xsl:value-of select="$resource_node/@publication.date"/>
              </xsl:attribute>              
              <xsl:attribute name="publication.year">
                <xsl:value-of select="$resource_node/@publication.year"/>
              </xsl:attribute>              
              <xsl:attribute name="published">        
                <xsl:value-of select="$resource_node/@published"/>
              </xsl:attribute>              
              <xsl:attribute name="status">
                <xsl:value-of select="$resource_node/@status"/>
              </xsl:attribute>              
              <xsl:attribute name="version">
                <xsl:value-of select="$resource_node/@version"/>
              </xsl:attribute>
              <xsl:attribute name="collector_bug">
                <xsl:value-of select="@collector_bug"/>
              </xsl:attribute>
            </resource>
          </xsl:if>
        </xsl:for-each>
      </resources>
    </xsl:variable>
    <p/>
    <h3>      
      <a name="resourcenames">Resources sorted by name</a>
    </h3> 
    <p><a href="#index">Index</a></p>
    <table border="1">
      <tr>
        <td><b>Resource</b></td>
        <td><b>Part</b></td>
        <td><b>Stage</b></td>
        <td><b>Edition</b></td>
        <td><b>Year of<br/>publication</b></td>   
        <td><b>Date of<br/>publication</b></td> 
        <td><b>Previous year<br/>of publication</b></td>       
        <td><b>Published</b></td>
        <td><b>Title</b></td>
        <td><b>CVS file revisions</b></td>
        <td><b>Collector Bug</b></td>
      </tr>
      
      
      
      <xsl:choose>
        <xsl:when test="function-available('msxsl:node-set')">
          <xsl:variable name="resource_nodes" select="msxsl:node-set($resources)"/>
          <xsl:apply-templates select="$resource_nodes//resource" mode="table_row">
            <xsl:sort select="@name"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="function-available('exslt:node-set')">
          <xsl:variable name="resource_nodes" select="exslt:node-set($resources)"/>
          <xsl:apply-templates select="$resource_nodes//resource" mode="table_row">
            <xsl:sort select="@name"/>
          </xsl:apply-templates>
        </xsl:when>
      </xsl:choose>
    </table>
    
    
    <h3>      
      <a name="resourcenos">Resources sorted by part number</a>
    </h3>
    <p><a href="#index">Index</a></p>
    <table border="1">
      <tr>
        <td><b>Resource</b></td>
        <td><b>Part</b></td>
        <td><b>Stage</b></td>
        <td><b>Edition</b></td>
        <td><b>Year of<br/>publication</b></td>   
        <td><b>Date of<br/>publication</b></td> 
        <td><b>Previous year<br/>of publication</b></td>       
        <td><b>Published</b></td>
        <td><b>Title</b></td>
        <td><b>CVS file revisions</b></td>
        <td><b>Collector Bug</b></td>
      </tr>
      
     
      
      
      <xsl:choose>
        <xsl:when test="function-available('msxsl:node-set')">
          <xsl:variable name="resource_nodes" select="msxsl:node-set($resources)"/>
          <xsl:apply-templates select="$resource_nodes//resource" mode="table_row">
            <xsl:sort select="@partNoWithLeadingZeros"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="function-available('exslt:node-set')">
          <xsl:variable name="resource_nodes" select="exslt:node-set($resources)"/>
          <xsl:apply-templates select="$resource_nodes//resource" mode="table_row">
            <xsl:sort select="@partNoWithLeadingZeros"/>
          </xsl:apply-templates>
        </xsl:when>
      </xsl:choose>
    </table>
  </xsl:template>
  
  <xsl:template match="resource" mode="table_row">
    
    <xsl:variable name="resource_ok">
      <xsl:call-template name="check_resource_doc_exists">
        <xsl:with-param name="resource_doc" select="@name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$resource_ok='true'">
        <xsl:variable name="pub_dir" select="concat($stepmodhome,'/part1000')"/>
        
        <xsl:variable name="res_dir_name"
          select="concat('iso10303_',./@part)"/>
        
        <tr>
          <!-- Resource -->
          <td>
            <xsl:variable name="res_xref"
              select="concat($pub_dir,'/data/resource_docs/',@name,'/sys/cover.htm')"/>
            <a href="{$res_xref}">
              <xsl:value-of select="@name"/>
            </a>
            
            <xsl:variable name="res_name" select="@name"/>            
            <xsl:if test="count(../resource[@name=$res_name])!=1">
              <xsl:call-template name="error_message">
                <xsl:with-param name="message">
                  <xsl:value-of select="concat('Resource ',@name,' is duplicated in publication_index.xml')"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:if>
          </td>
          
          <!-- Part -->
          <td>
            <xsl:choose>
              <xsl:when test="./@part">
                <xsl:value-of select="concat('10303-',./@part)"/>
                
                <!-- check that the part number in repository_index -->
                <xsl:variable name="resource_doc" select="@name"/>
                <xsl:variable name="repo_res_number"
                  select="document('../../repository_index.xml')/repository_index/resource_docs/resource_doc[@name=$resource_doc]/@part"/>
                <xsl:if test="$repo_res_number != ./@part">
                  <br/>
                  <font color="#FF0000" size="-1">
                    The part number in repository_index
                    (<xsl:value-of select="$repo_res_number"/>)
                    does not equal that in resource 
                    (<xsl:value-of select="./@part"/>).
                  </font>
                </xsl:if>
              </xsl:when>
              <xsl:otherwise>
                -
              </xsl:otherwise>
            </xsl:choose>
          </td>
          
          <!-- Stage -->
          <td>
            <xsl:choose>
              <xsl:when 
                test="string-length(normalize-space(./@status))>0">
                <xsl:value-of select="./@status"/>
              </xsl:when>
              <xsl:otherwise>
                -
              </xsl:otherwise>
            </xsl:choose>
          </td>
          
          <!-- Version -->
          <td>
            <xsl:choose>
              <xsl:when 
                test="string-length(normalize-space(./@version))>0">
                <xsl:value-of select="./@version"/>
              </xsl:when>
              <xsl:otherwise>
                -
              </xsl:otherwise>
            </xsl:choose>
          </td>
          
          <!-- Year -->
          <td>
            <xsl:choose>
              <xsl:when 
                test="string-length(normalize-space(./@publication.year))>0">
                <xsl:value-of select="./@publication.year"/>
              </xsl:when>
              <xsl:otherwise>
                -
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <!-- Date -->
          <td>
            <xsl:choose>
              <xsl:when 
                test="string-length(normalize-space(./@publication.date))>0">
                <xsl:value-of select="./@publication.date"/>
              </xsl:when>
              <xsl:otherwise>
                -
              </xsl:otherwise>
            </xsl:choose>
          </td>
          
          <!-- Previous ed date -->
          <td>
            <xsl:choose>
              <xsl:when 
                test="string-length(normalize-space(./@previous.revision.year))>0">
                <xsl:value-of select="./@previous.revision.year"/>
              </xsl:when>
              <xsl:otherwise>
                -
              </xsl:otherwise>
            </xsl:choose>
          </td>
          
          <td>
            <xsl:value-of select="./@published"/>          
          </td>
          
          
          <!--  Title -->
          <td>
            <xsl:call-template name="resource_doc_display_name">
              <xsl:with-param name="part_no" select="concat('10303-',./@part)"/>
            </xsl:call-template>  
            
          </td>
         
          <!-- CVS revisions -->
          <td>
            <xsl:variable name="cvs_xref"
              select="concat($pub_dir,'/data/resource_docs/',@name,'/publication_record.xml')"/>
            
            <a href="{$cvs_xref}">publication_record.xml</a>
          </td>
          <!-- bug -->
          <td>
            <xsl:value-of select="./@collector_bug"/>  
          </td>
        </tr>
      </xsl:when>
      <!-- resource does not exist in repository index -->
      <xsl:otherwise>
        <tr>
          <td>
            <xsl:value-of select="../@name"/>
          </td>
          <td>
            <xsl:value-of select="@name"/>
            <xsl:call-template name="error_message">
              <xsl:with-param name="message">
                <xsl:value-of select="concat('Error publication1: ', $resource_ok)"/>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td>&#160;</td>
          <td>&#160;</td>
          <td>&#160;</td>
          <td>&#160;</td>
          <td>&#160;</td>
          <td>&#160;</td>
          <td>&#160;</td>
        </tr>      
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="check_resource_doc_exists">
    <xsl:param name="resource_doc"/>
    <!-- the name of the resource_doc directory should be in lower case -->
    <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>
    <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
    <xsl:variable name="lresource_doc" select="translate($resource_doc,$UPPER,$LOWER)"/>
    <xsl:variable name="ret_val">
      <xsl:choose>
        <xsl:when test="document('../../repository_index.xml')/repository_index/resource_docs/resource_doc[@name=$lresource_doc]">
          <xsl:value-of select="'true'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat(' The resource document ', $lresource_doc, ' is not identified as a resource document in repository_index.xml')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$ret_val"/>
  </xsl:template>
  
  <xsl:template name="resource_doc_display_name">
    <xsl:param name="part_no"/>
    
    <xsl:variable name="partRef" select="concat('ref', $part_no)"/>
    
    <xsl:variable name="normrefs" select="document(string('../../data/basic/normrefs.xml'))"/>
    <xsl:variable name="rawSubtitle" select="$normrefs//normref[@id=$partRef]/stdref/subtitle"/>
    <xsl:variable name="normSubtitle" select="normalize-space(string($rawSubtitle))"/>
    <xsl:variable name="truncatedSubtitle" select="substring-after($normSubtitle, 'Integrated generic resource: ')"/>
    <xsl:value-of select="$truncatedSubtitle"/>
  </xsl:template>
  
  <xsl:template match="deleted.resource_docs" mode="table">
    <h3>
      <a name="delresourcenames">Deleted Resources sorted by name</a>
    </h3>
    <p>
      <a href="#index">Index</a>
    </p>
    <table border="1">
      <tr>
        <td>
          <b>Resource</b>
        </td>
        <td>
          <b>Collector Bug</b>
        </td>
      </tr>
      <xsl:for-each select="resource_doc">
        <xsl:sort select="@name"/>
        <tr>
          <!-- Resource -->
          <td>
            <xsl:value-of select="@name"/>
          </td>
          <!-- bug -->
          <td>
            <xsl:value-of select="./@collector_bug"/>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

</xsl:stylesheet>