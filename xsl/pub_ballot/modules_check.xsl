<?xml version="1.0" encoding="utf-8"?>
<!--
$ Id: build.xsl,v 1.9 2003/02/26 02:12:17 thendrix Exp $
   Author:  Rob Bodington, Eurostep Limited
   Owner:   Developed by Eurostep Limited http://www.eurostep.com and supplied to NIST under contract.
   Purpose: Perform checks on the modules in a SMRL publication. 
-->

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:exslt="http://exslt.org/common"
  exclude-result-prefixes="msxsl exslt"
  version="1.0">
  
  <xsl:import href="../../xsl/common.xsl"/>

  <xsl:output method="html" indent="yes"/>
  

  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>
  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="cr_index" select="document('../../publication/part1000/cr_index.xml')"/>        
  <xsl:variable name="crs">
    <crs>
      <xsl:for-each select="$cr_index//part1000.change_request">
        <cr>
          <xsl:attribute name="cr.name">
            <xsl:value-of select="@name"/>
          </xsl:attribute>
          <xsl:attribute name="cr.date.iso_publication">
            <xsl:value-of select="@date.iso_publication"/>
          </xsl:attribute>
          <xsl:variable name="pub_dir"
            select="concat('../../publication/part1000/',@name,'/publication_index.xml')"/>
          <xsl:variable name="publication_index_xml" select="document($pub_dir)"/>
          <modules>
            <xsl:for-each select="$publication_index_xml//modules/module">
              <module>
                <xsl:attribute name="name">
                  <xsl:value-of select="@name"/>
                </xsl:attribute>
                <xsl:attribute name="team">
                  <xsl:value-of select="@team"/>
                </xsl:attribute>
              </module>
            </xsl:for-each>
          </modules>
        </cr>
      </xsl:for-each>
    </crs>
  </xsl:variable>
   
  <xsl:template match="/">        
    <xsl:apply-templates select="//publication" />
  </xsl:template>

  <xsl:template match="publication">
    <html>
      <body>
        <xsl:variable name="pub_dir"
          select="concat('../../publication/part1000/',@directory,'/publication_index.xml')"/>
        <xsl:variable name="publication_index_xml" select="document($pub_dir)"/>
        <h1><xsl:value-of select="concat('CR ',$publication_index_xml/part1000.publication_index/@name,':- Modules date check')"/></h1>
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
        <p>Check that all the modules in the CR have been published and have the published 
        dates agrees with the date in the CR</p>
        <p><a name="top"><b>Top</b></a></p>
        <ul>
          <li><a href="#errors.all">All errors</a></li>
          <li><a href="#errors.dates">Publication date errors</a></li>
        </ul>
        <xsl:variable name="iso_publication_date" select="normalize-space($publication_index_xml/part1000.publication_index/@date.iso_publication)"/>
        <xsl:variable name="iso_publication_year"
          select="substring-before($iso_publication_date,'-')"/>
        <xsl:if test="string-length($iso_publication_date)=0">
          <xsl:call-template name="error_message">
            <xsl:with-param name="message" select="'ERROR X: publication_index.xml the @date.iso_publication attribute has not been set'"/>
          </xsl:call-template>
        </xsl:if>
        
        <xsl:variable name="errors">
          <modules>
            <xsl:for-each select="$publication_index_xml//modules/module">
              <xsl:sort select="@name"/>
              <module>
                <xsl:attribute name="name">
                  <xsl:value-of select="@name"/>
                </xsl:attribute>                
                <xsl:attribute name="team">
                  <xsl:value-of select="@team"/>
                </xsl:attribute>
                <!-- check module exists -->
                <xsl:variable name="module_ok">
                  <xsl:call-template name="check_module_exists">
                    <xsl:with-param name="module" select="@name"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:if test="$module_ok!='true'">
                  <error>
                    <xsl:attribute name="error.type">missing_module</xsl:attribute>
                    <xsl:attribute name="error.number">'ERROR A'</xsl:attribute>
                    <xsl:attribute name="error.message">
                      <xsl:value-of
                        select="concat('Module ', @name,' - ERROR A:  module does not exist in repository_index.xml.')"
                      />
                    </xsl:attribute>
                  </error>
                </xsl:if>

                <!-- check the publication years -->
                <xsl:variable name="module_path"
                  select="concat('../../data/modules/',@name,'/module.xml')"/>
                <xsl:variable name="module" select="document($module_path)"/>
                <xsl:attribute name="part">
                  <xsl:value-of select="$module/module/@part"/>
                </xsl:attribute>
                <xsl:if test="$module/module/@published!='y'">
                  <error>
                    <xsl:attribute name="error.type">published</xsl:attribute>
                    <xsl:attribute name="error.number">'ERROR B'</xsl:attribute>
                    <xsl:attribute name="error.message">
                      <xsl:value-of
                        select="concat('Module ', @name,' - ERROR B: module/@published is: ',$module/module/@published,' should be y.')"
                      />
                    </xsl:attribute>
                  </error>
                </xsl:if>
                
                <xsl:if test="$module/module/@publication.year!=$iso_publication_year">
                  <error>
                    <xsl:attribute name="error.type">publication.year</xsl:attribute>
                    <xsl:attribute name="error.number">'ERROR C'</xsl:attribute>
                    <xsl:attribute name="error.message">
                      <xsl:value-of
                        select="concat('Module ', @name,' - ERROR C: module/@publication.year is: ',$module/module/@publication.year,' should be ',$iso_publication_year)"
                      />
                    </xsl:attribute>
                  </error>
                </xsl:if>
                <xsl:if test="$module/module/@publication.date!=$iso_publication_date">
                  <error>
                    <xsl:attribute name="error.type">publication.date</xsl:attribute>
                    <xsl:attribute name="error.number">'ERROR D'</xsl:attribute>
                    <xsl:attribute name="error.message">
                      <xsl:value-of
                        select="concat('Module ', @name,' - ERROR D: module/@publication.date is: ',$module/module/@publication.date,' should be ',$iso_publication_date)"/>
                    </xsl:attribute>
                  </error>
                </xsl:if>

                <xsl:if test="$module/module/@status!='TS'">
                  <error>
                    <xsl:attribute name="error.type">status</xsl:attribute>
                    <xsl:attribute name="error.number">'ERROR E'</xsl:attribute>
                    <xsl:attribute name="error.message">
                      <xsl:value-of
                        select="concat('Module ', @name,' - ERROR E: module/@status is: ',$module/module/@status,' should be TS')"/>
                    </xsl:attribute>
                  </error>
                </xsl:if>
                <xsl:if test="$module/module/@language!='E'">
                  <error>
                    <xsl:attribute name="error.type">language</xsl:attribute>
                    <xsl:attribute name="error.number">'ERROR D'</xsl:attribute>
                    <xsl:attribute name="error.message">
                      <xsl:value-of
                        select="concat('Module ', @name,' - ERROR F: module/@language is: ',$module/module/@language,' should be E')"/>
                    </xsl:attribute>
                  </error>
                </xsl:if>
                <xsl:if test="$module/module/@version!='1'">
                  <xsl:choose>
                    <xsl:when test="not($module/module/changes)">
                      <error>
                        <xsl:attribute name="error.type">changes.no</xsl:attribute>
                        <xsl:attribute name="error.number">'ERROR G'</xsl:attribute>
                        <xsl:attribute name="error.message">
                          <xsl:value-of
                            select="concat('Module ', @name,' - ERROR G: there is no change history')"/>
                        </xsl:attribute>
                      </error>
                    </xsl:when>

                    <xsl:when test="count($module/module/changes/change)+1 != $module/@version">
                      <error>
                        <xsl:attribute name="error.type">changes.count</xsl:attribute>
                        <xsl:attribute name="error.number">'ERROR H'</xsl:attribute>
                        <xsl:attribute name="error.message">
                          <xsl:value-of
                            select="concat('Module: ',@name,' - Error H: the number of change elements do not correspond to the edition')"/>
                        </xsl:attribute>
                      </error>
                    </xsl:when>
                  </xsl:choose>
                </xsl:if>
                <xsl:variable name="pub_version" select="./@version"/>
                <xsl:choose>
                  <xsl:when test="string-length($pub_version)!=0">
                    <xsl:if test="$module/module/@version!=$pub_version">
                      <error>
                        <xsl:attribute name="error.type">edition</xsl:attribute>
                        <xsl:attribute name="error.number">'ERROR I'</xsl:attribute>
                        <xsl:attribute name="error.message">
                          <xsl:value-of
                            select="concat('Module: ',@name,' - Error I: the module version in publication_index.xml (',$pub_version,'), does not correspond to the version in the module.xml(',$module/module/@version,')')"
                          />
                        </xsl:attribute>
                      </error>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>                    
                    <error>
                      <xsl:attribute name="error.type">edition</xsl:attribute>
                      <xsl:attribute name="error.number">'ERROR J'</xsl:attribute>
                      <xsl:attribute name="error.message">
                        <xsl:value-of
                          select="concat('Module: ',@name,' - Error J: there is no module version in publication_index.xml')"
                        />
                      </xsl:attribute>
                    </error>
                  </xsl:otherwise>
                </xsl:choose>
                
                
              </module>
            </xsl:for-each>
          </modules>
        </xsl:variable>  
        
        <xsl:choose>
          <xsl:when test="function-available('msxsl:node-set')">
            <xsl:variable name="modules_nodes" select="msxsl:node-set($errors)"/>
            <xsl:apply-templates select="." mode="output">
              <xsl:with-param name="modules_nodes" select="$modules_nodes"/>
            </xsl:apply-templates>
          </xsl:when>
          <xsl:when test="function-available('exslt:node-set')">
            <xsl:variable name="modules_nodes" select="exslt:node-set($errors)"/>
            <xsl:apply-templates select="." mode="output">
              <xsl:with-param name="modules_nodes" select="$modules_nodes"/>
            </xsl:apply-templates>
          </xsl:when>
        </xsl:choose>
      </body>
    </html>
  </xsl:template>


  <xsl:template match="publication" mode="output">
    <xsl:param name="modules_nodes"/>
    
    <!-- All errors -->
    <hr/>
    <a name="errors.all"><H1>All errors</H1></a>
    <ul>
      <li><a href="#top">Top</a></li>
      <li><a href="#summary.modules">modules</a></li>
      <li><a href="#details.modules">details</a></li>
    </ul>
    <h3><a name="summary.modules">Modules with errors - summary</a></h3>
    <xsl:for-each select="$modules_nodes/modules/module">
      <xsl:sort select="@team"/>
      <xsl:sort select="@name"/>
      <xsl:if test="./error">
        <xsl:value-of select="@team"/><a href="#modall.{@name}"><xsl:value-of select="concat(': ',@name,' ISO 10303-',@part)"/></a>
        <xsl:apply-templates select="." mode="CR"/>
        <br/>              
      </xsl:if>
    </xsl:for-each>
    
    <h3><a name="details.modules">Modules with errors - details</a></h3>
    <xsl:for-each select="$modules_nodes/modules/module">
      <xsl:sort select="@name"/>
      <xsl:variable name="module_href" select="concat('../../../../data/modules/',@name,'/sys/cover',$FILE_EXT)"/>
      <xsl:if test="./error">
        <h2>
          <a name="modall.{@name}"><xsl:value-of select="concat(@team,': ',@name,' ISO 10303-',@part)"/></a>
        </h2>
        <xsl:choose>
          <xsl:when test="error[@error.type='publication.year' or @error.type='publication.date' or @error.type='published']">
            [<a href="#top">Top</a>&#160;<a href="#moddate.{@name}">Date errors</a>&#160;<a href="{$module_href}">Module</a>&#160;]
          </xsl:when>
          <xsl:otherwise>[<a href="#top">Top</a>&#160;No date errors]</xsl:otherwise>
        </xsl:choose>                
        <p>Module in change requests: <xsl:apply-templates select="." mode="CR"/></p>
        <xsl:apply-templates select="error"/>
      </xsl:if>
    </xsl:for-each>
    
    <!-- Publication date errors -->
    <hr/>
    <a name="errors.dates"><H1>Publication date errors</H1></a>
    <a href="#index">index</a><br/>
    
    <xsl:for-each select="$modules_nodes/modules/module">
      <xsl:sort select="@team"/>
      <xsl:sort select="@name"/>
      <xsl:if
        test="./error[@error.type='publication.year' or @error.type='publication.date' or @error.type='published']">
        <xsl:value-of select="@team"/>
        <a href="#moddate.{@name}">
          <xsl:value-of select="concat(': ',@name,' ISO 10303-',@part)"/>
        </a>
        <xsl:apply-templates select="." mode="CR"/>
        <br/>
      </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="$modules_nodes/modules/module">
      <xsl:sort select="@team"/>
      <xsl:sort select="@name"/>
      <xsl:if test="./error[@error.type='publication.year' or @error.type='publication.date' or @error.type='published']">
        <h2>
          <a name="moddate.{@name}"><xsl:value-of select="concat(@team,': ',@name,' ISO 10303-',@part,' - date error')"/></a> 
        </h2>
        [<a href="#top">Top</a>&#160;<a href="#modall.{@name}">All errors</a>&#160;]                        
        <p>Module in change requests: <xsl:apply-templates select="." mode="CR"/></p>
        <xsl:apply-templates select="."/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="error">
    <xsl:call-template name="error_message">
      <xsl:with-param name="message" select="./@error.message"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="module" mode="CR">
    <xsl:choose>
      <xsl:when test="function-available('msxsl:node-set')">
        <xsl:variable name="crs_nodes" select="msxsl:node-set($crs)"/>
        <xsl:apply-templates select="." mode="outputCR">
          <xsl:with-param name="crs_nodes" select="$crs_nodes"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="function-available('exslt:node-set')">
        <xsl:variable name="crs_nodes" select="exslt:node-set($crs)"/>
        <xsl:apply-templates select="." mode="outputCR">
          <xsl:with-param name="crs_nodes" select="$crs_nodes"/>
        </xsl:apply-templates>
      </xsl:when>      
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="module" mode="outputCR">
    <xsl:param name="crs_nodes"/>
    <xsl:variable name="module_name" select="@name"/>
    <xsl:if test="$crs_nodes//module[@name=$module_name]">&#160;[</xsl:if>
    <xsl:for-each select="$crs_nodes//module[@name=$module_name]">
      <xsl:value-of select="concat('&#160;',../../@cr.name)"/>
    </xsl:for-each>
    <xsl:if test="$crs_nodes//module[@name=$module_name]">&#160;]</xsl:if>
  </xsl:template>
  
</xsl:stylesheet>
