<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: definitions.xsl,v 1.1 2002/09/30 10:24:33 robbod Exp $
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
        Keywords index
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
      <xsl:variable name="keywd_nodes_unsorted">
        <xsl:element name="keywords">
          <xsl:apply-templates 
            select="./modules/module" mode="get_keyword"/>
        </xsl:element>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="function-available('msxsl:node-set')">
          <xsl:variable 
            name="keywd_node_set_unsorted" 
            select="msxsl:node-set($keywd_nodes_unsorted)"/>

          <xsl:variable name="keywd_nodes">
            <xsl:element name="keywords">
              <xsl:apply-templates select="$keywd_node_set_unsorted/keywords/keyword_node"
                mode="copy">
                <xsl:sort select="@keyword"/>
              </xsl:apply-templates>
            </xsl:element>
          </xsl:variable>
          
          <xsl:variable 
            name="keywd_node_set" 
            select="msxsl:node-set($keywd_nodes)"/>

          <xsl:for-each select="$keywd_node_set/keywords/keyword_node">
            <xsl:variable name="letter" 
              select="translate(substring(@keyword,1,1), $lower, $upper)"/>
            
            <xsl:if test="not($letter = 
                          translate(substring(preceding-sibling::keyword_node[1]/@keyword,1,1),
                          $lower, $upper))">
              <p class="alpha">
                <A NAME="{$letter}">
                  <xsl:value-of select="$letter"/>
                </A>
              </p>
            </xsl:if>
            <!-- only output the first keyword in tree -->
            <xsl:if test="not(preceding-sibling::keyword_node[1]/@keyword=@keyword)">
              <xsl:apply-templates select="."/>
            </xsl:if>
          </xsl:for-each>
        </xsl:when>

        <xsl:when test="function-available('saxon:node-set')">
          <xsl:variable 
            name="keywd_node_set_unsorted" 
            select="saxon:node-set($keywd_nodes_unsorted)"/>

          <xsl:variable name="keywd_nodes">
            <xsl:element name="keywords">
              <xsl:apply-templates select="$keywd_node_set_unsorted/keywords/keyword_node"
                mode="copy">
                <xsl:sort select="@keyword"/>
              </xsl:apply-templates>
            </xsl:element>
          </xsl:variable>
          
          <xsl:variable 
            name="keywd_node_set" 
            select="saxon:node-set($keywd_nodes)"/>

          <xsl:for-each select="$keywd_node_set/keywords/keyword_node">
            <xsl:variable name="letter" 
              select="translate(substring(@keyword,1,1), $lower, $upper)"/>
            
            <xsl:if test="not($letter = 
                          translate(substring(preceding-sibling::keyword_node[1]/@keyword,1,1),
                          $lower, $upper))">
              <p class="alpha">
                <A NAME="{$letter}">
                  <xsl:value-of select="$letter"/>
                </A>
              </p>
            </xsl:if>
            <!-- only output the first keyword in tree -->
            <xsl:if test="not(preceding-sibling::keyword_node[1]/@keyword=@keyword)">
              <xsl:apply-templates select="."/>
            </xsl:if>
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


<xsl:template match="module" mode="get_keyword">
  <xsl:apply-templates 
    select="document(concat('../../data/modules/',@name,'/module.xml'))/module/keywords"/>
</xsl:template>

<xsl:template match="keywords">
  <xsl:call-template name="parse_keywords">
    <xsl:with-param name="keywords" select="."/>
    <xsl:with-param name="module" select="../@name"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="parse_keywords">
  <xsl:param name="keywords"/>
  <xsl:param name="module"/>
  <xsl:variable name="nkeywords" select="normalize-space($keywords)"/>
  <xsl:choose>

    <xsl:when test="contains($nkeywords,',')">
      <xsl:variable name="keyword"
        select="substring-before($nkeywords,',')"/>
      <xsl:variable name="rest"
        select="substring-after($nkeywords,',')"/>

      <xsl:element name="keyword_node">
        <xsl:attribute name="keyword">
          <xsl:value-of select="normalize-space($keyword)"/>
        </xsl:attribute>
        <xsl:attribute name="module">
          <xsl:value-of select="$module"/>
        </xsl:attribute>
      </xsl:element>
      <xsl:if test="string-length($rest)>0">
        <xsl:call-template name="parse_keywords">
          <xsl:with-param name="keywords" select="$rest"/>
          <xsl:with-param name="module" select="$module"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:when>

    <xsl:otherwise>
      <xsl:element name="keyword_node">
        <xsl:attribute name="keyword">
          <xsl:value-of select="$nkeywords"/>
        </xsl:attribute>
        <xsl:attribute name="module">
          <xsl:value-of select="$module"/>
        </xsl:attribute>
      </xsl:element>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="keyword_node">
  <xsl:variable name="keyword" select="@keyword"/>
    <xsl:variable name="nkeyword" 
      select="translate(@keyword,'&#x20;&#x9;&#xA;&#xD;()-,.[]{}','')"/>
  <xsl:variable name="open_keyword" select="concat('open_', $nkeyword)"/>
  <xsl:variable name="closed_keyword" select="concat('closed_', $nkeyword)"/>


  <!-- Keyword menu (OPEN) -->
  <div id="{$open_keyword}" style="display:none">
    <p class="menulist">
      <a href="javascript:swap({$closed_keyword}, {$open_keyword});">
        <img src="../images/minus.gif" alt="Close menu" 
          border="false" align="middle"/>    
      </a>
      <xsl:value-of select="$keyword"/>
    </p>
    <p class="menuitem">Modules:</p>
    <xsl:apply-templates 
      select="../keyword_node[@keyword=$keyword]"
      mode="modules"/>
  </div>

  <!-- keyword menu (CLOSED) -->
  <div id="{$closed_keyword}">
    <p class="menulist">
      <a href="javascript:swap({$open_keyword}, {$closed_keyword});">
        <img src="../images/plus.gif" alt="Open menu" 
          border="false" align="middle"/>    
      </a>
      <xsl:value-of select="$keyword"/>
    </p>
  </div>

</xsl:template>

<xsl:template match="keyword_node" mode="modules">
  <xsl:variable name="href" 
    select="concat('../data/modules/',@module,'/sys/cover',$FILE_EXT)"/>
  <p class="menuitem">
    &#160;&#160;&#160;<a href="{$href}" target="content">
      <xsl:value-of select="@module"/>
    </a>
  </p>
</xsl:template>


<xsl:template match="keyword_node" mode="copy">
  <xsl:copy-of select="."/>
</xsl:template>

</xsl:stylesheet>