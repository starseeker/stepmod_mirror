<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: definitions.xsl,v 1.2 2002/09/30 12:59:43 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited under contract to NIST
  Purpose: Create an index on definitions defined in the modules.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:saxon="http://icl.com/saxon"
  extension-element-prefixes="msxsl saxon"
  version="1.0">

  <xsl:import href="../../xsl/common.xsl"/>

  <xsl:output method="html"/>


  <xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

  <xsl:template match="/" >
    <xsl:apply-templates select="./stylesheet_application"/>
  </xsl:template>

  <xsl:template match="stylesheet_application">
    <xsl:apply-templates select="document('../../repository_index.xml')/repository_index"/>
  </xsl:template>

<xsl:template match="repository_index">
  <HTML>
    <head>
      <link rel="stylesheet" type="text/css" href="./css/nav.css"/>
      <title>
        Definition index
      </title>

      <script language="JavaScript"><![CDATA[

          function swap(ShowDiv, HideDiv) {
            show(ShowDiv) ;
            hide(HideDiv) ;
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
      <xsl:variable name="def_nodes_unsorted">
        <xsl:element name="definitions">
          <xsl:apply-templates select="./modules/module" mode="get_definition"/> 
          <xsl:apply-templates select="./application_protocols/application_protocol" mode="get_definition"/>
          <xsl:apply-templates select="./resource_docs/resource_doc" mode="get_definition"/> 
        </xsl:element>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="function-available('msxsl:node-set')">
          <xsl:variable 
            name="def_node_set_unsorted" 
            select="msxsl:node-set($def_nodes_unsorted)"/>

          <xsl:variable name="def_nodes">
            <xsl:element name="definitions">
              <xsl:apply-templates select="$def_node_set_unsorted/definitions/definition_node"
                mode="copy">
                <xsl:sort select="@term"/>
              </xsl:apply-templates>
            </xsl:element>
          </xsl:variable>
          
          <xsl:variable 
            name="def_node_set" 
            select="msxsl:node-set($def_nodes)"/>


          <xsl:for-each select="$def_node_set/definitions/definition_node">
            <xsl:variable name="letter" 
              select="translate(substring(@term,1,1), $lower, $upper)"/>
            
            <xsl:if test="not($letter = 
                          translate(substring(preceding-sibling::definition_node[1]/@term,1,1),
                          $lower, $upper))">
              <p class="alpha">
                <A NAME="{$letter}">
                  <xsl:value-of select="$letter"/>
                </A>
              </p>
            </xsl:if>
            <xsl:apply-templates select="."/>
          </xsl:for-each>
        </xsl:when>

        <xsl:when test="function-available('saxon:node-set')">
          <xsl:variable 
            name="def_node_set_unsorted" 
            select="saxon:node-set($def_nodes_unsorted)"/>

          <xsl:variable name="def_nodes">
            <xsl:element name="definitions">
              <xsl:apply-templates select="$def_node_set_unsorted/definitions/definition_node"
                mode="copy">
                <xsl:sort select="@term"/>
              </xsl:apply-templates>
            </xsl:element>
          </xsl:variable>
          
          <xsl:variable 
            name="def_node_set" 
            select="saxon:node-set($def_nodes)"/>


          <xsl:for-each select="$def_node_set/definitions/definition_node">
            <xsl:variable name="letter" 
              select="translate(substring(@term,1,1), $lower, $upper)"/>
            
            <xsl:if test="not($letter = 
                          translate(substring(preceding-sibling::definition_node[1]/@term,1,1),
                          $lower, $upper))">
              <p class="alpha">
                <A NAME="{$letter}">
                  <xsl:value-of select="$letter"/>
                </A>
              </p>
            </xsl:if>
            <xsl:apply-templates select="."/>
          </xsl:for-each>
        </xsl:when>

        <xsl:otherwise>
          XSL require node-set function.
          Currently checks for SAXON MSXML3
        </xsl:otherwise>
      </xsl:choose>
    </body>
  </HTML>
</xsl:template>

<xsl:template match="module" mode="get_definition">
  <xsl:apply-templates select="document(concat('../../data/modules/',@name,'/module.xml'))/module/definition/term">
    <xsl:with-param name="href_root" select="'../data/modules/'"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="resource_doc" mode="get_definition">
  <xsl:apply-templates select="document(concat('../../data/resource_docs/',@name,'/resource.xml'))/resource/definition/term">
    <xsl:with-param name="href_root" select="'../data/resource_docs/'"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="application_protocol" mode="get_definition">
  <xsl:apply-templates 
    select="document(concat('../../data/application_protocols/',@name,'/application_protocol.xml'))/application_protocol/definition/term">
    <xsl:with-param name="href_root" select="'../data/application_protocols/'"/>
  </xsl:apply-templates>
</xsl:template>



<xsl:template match="term">
  <xsl:param name="href_root"/>
  <xsl:variable name="nterm" select="normalize-space(.)"/>
  <xsl:element name="definition_node">
    <xsl:attribute name="id">
      <xsl:value-of select="@id"/>
    </xsl:attribute>
    <xsl:attribute name="term">
      <xsl:value-of select="$nterm"/>
    </xsl:attribute>
    <xsl:attribute name="href_root">
      <xsl:value-of select="$href_root"/>
    </xsl:attribute>
    <xsl:attribute name="module">
      <xsl:value-of select="../../@name"/>
    </xsl:attribute>
  </xsl:element>
</xsl:template>

<xsl:template match="definition_node">
  <xsl:variable name="href" 
    select="concat(@href_root,@module,'/sys/3_defs',$FILE_EXT,'#term-',@term)"/>
  <p class="menulist">
    <a href="{$href}" target="content">
      <xsl:value-of select="@term"/>
    </a>
  </p>
</xsl:template>
  
<xsl:template match="definition_node" mode="copy">
  <xsl:copy-of select="."/>
</xsl:template>

</xsl:stylesheet>