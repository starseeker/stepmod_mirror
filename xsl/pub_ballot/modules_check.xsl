<?xml version="1.0" encoding="utf-8"?>
<!--
$ Id: build.xsl,v 1.9 2003/02/26 02:12:17 thendrix Exp $
   Author:  Rob Bodington, Eurostep Limited
   Owner:   Developed by Eurostep Limited http://www.eurostep.com and supplied to NIST under contract.
   Purpose: Perform checks on the modules in a SMRL publication. 
-->

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exslt="http://exslt.org/common"
  exclude-result-prefixes="exslt"
  version="1.0">
  
  <xsl:import href="../../xsl/common.xsl"/>

  <xsl:output method="html" indent="yes"/>
  

  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>
  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  
  <xsl:template match="/" >
    <xsl:apply-templates select="//publication" />
  </xsl:template>

  <xsl:template match="publication">
    <html>
      <body>
        <h1>Modules date check</h1>
        <p><a href="publication_summary{$FILE_EXT}">back</a></p>
        <p>Check that all the modules in the CR have been published and have the published 
          dates agrees with the date in the CR</p>
        <xsl:variable name="pub_dir"
          select="concat('../../publication/part1000/',@directory,'/publication_index.xml')"/>
        <xsl:variable name="publication_index_xml" select="document($pub_dir)"/>
        <xsl:variable name="iso_publication_date" select="normalize-space($publication_index_xml/part1000.publication_index/@date.iso_publication)"/>
        <xsl:variable name="iso_publication_year"
          select="substring-before($iso_publication_date,'-')"/>
        <xsl:if test="string-length($iso_publication_date)=0">
          ERROR X: publication_index.xml the @date.iso_publication attribute has not
            been set<br/>
        </xsl:if>
        <ol>
          <xsl:for-each select="$publication_index_xml//module">
            <xsl:sort select="@name"/>
            <!-- check module exists -->
            <xsl:variable name="module_ok">
              <xsl:call-template name="check_module_exists">
                <xsl:with-param name="module" select="@name"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:if test="$module_ok!='true'">
              <xsl:value-of
                select="concat('ERROR A: Module ', @name,' module does not exist in repository_index.xml.')"/>
              <br/>
            </xsl:if>

            <!-- check the publication years -->
            <xsl:variable name="module_path"
              select="concat('../../data/modules/',@name,'/module.xml')"/>
            <xsl:variable name="module" select="document($module_path)"/>
            <xsl:if test="$module/module/@published!='y'">
              <li>
                <xsl:value-of
                  select="concat('Module ', @name,' - ERROR B: module/@published is: ',$module/module/@published,' should be y.')"
                />
              </li>
            </xsl:if>
            <xsl:if test="$module/module/@publication.year!=$iso_publication_year">
              <li>
                <xsl:value-of
                  select="concat('Module ', @name,' - ERROR C: module/@publication.year is: ',$module/module/@publication.year,' should be ',$iso_publication_year)"
                />
              </li>
            </xsl:if>
            <xsl:if test="$module/module/@publication.date!=$iso_publication_date">
              <li>
                <xsl:value-of
                  select="concat('Module ', @name,' - ERROR D: module/@publication.date is: ',$module/module/@publication.date,' should be ',$iso_publication_date)"
                />
              </li>
            </xsl:if>

            <xsl:if test="$module/module/@status!='TS'">
              <li>
                <xsl:value-of
                  select="concat('Module ', @name,' - ERROR E: module/@status is: ',$module/module/@status,' should be TS')"
                />
              </li>
            </xsl:if>
            <xsl:if test="$module/module/@language!='E'">
              <li>
                <xsl:value-of
                  select="concat('Module ', @name,' - ERROR F: module/@language is: ',$module/module/@language,' should be E')"
                />
              </li>
            </xsl:if>
            <xsl:if test="$module/module/@version!='1'">
              <xsl:choose>
                <xsl:when test="not($module/module/changes)">
                  <li>
                    <xsl:value-of
                      select="concat('Module ', @name,' - ERROR G: there is no change history')"/>
                  </li>
                </xsl:when>

                <xsl:when test="count($module/module/changes/change)+1 != $module/@version">
                  <li>
                    <xsl:value-of
                      select="concat('Module: ',@name,' - Error H: the number of change elements do not correspond to the edition')"
                    />
                  </li>
                </xsl:when>
              </xsl:choose>
            </xsl:if>
          </xsl:for-each>
        </ol>
      </body>
    </html>
  </xsl:template>


</xsl:stylesheet>
