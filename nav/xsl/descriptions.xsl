<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: descriptions.xsl,v 1.4 2002/06/20 13:05:53 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep.
  Purpose: To display the ARM or MIM external descriptions file.
     File gets imported to arm_descriptions.xsl and mim_descriptions.xsl
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="../../xsl/module.xsl"/>

  <xsl:template match="/" >
    <xsl:apply-templates select="./stylesheet_application"/>
  </xsl:template>

  <xsl:template match="stylesheet_application">
    <HTML>
    <head>
      <link rel="stylesheet" type="text/css" 
        href="../../../../nav/css/developer.css"/>
      <title>
        <xsl:value-of select="concat('Development tips for ',@directory)"/>
      </title>

      <script language="JavaScript"><![CDATA[

          function swap(ShowDiv, HideDiv) {
            show(ShowDiv);
            hide(HideDiv);
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
    <xsl:variable 
      name="module_xml_file"
      select="concat('../../data/modules/',@directory,'/module.xml')"/>

    <xsl:variable 
      name="module_nodes"
      select="document($module_xml_file)"/>
    <div class="toc">
      <!-- output the Table of contents banner -->
      <xsl:apply-templates 
        select="$module_nodes/module"
        mode="TOCmultiplePage">
        <xsl:with-param name="module_root" select="'..'"/>
      </xsl:apply-templates>
    </div>
    
    <!-- NOTE - this gets defined when this file is imported
         to arm_descriptions.xsl and mim_descriptions.xsl -->
    <xsl:apply-templates select="." mode="ext_descriptions"/>
  </body>
</HTML>
</xsl:template>



  <xsl:template match="ext_descriptions">
    <xsl:param name="module"/>
    <xsl:param name="module_href"/>
    <xsl:param name="express_file"/>
    <xsl:param name="express_file_href"/>
    <xsl:param name="desc_file"/>
    <h3>External descriptions for Module:     
      <a href="{$module_href}"><xsl:value-of select="$module"/></a>
      <br/>
      EXPRESS file: 
      <a href="{$express_file_href}"><xsl:value-of select="$express_file"/></a>
      <br/>
      Descriptions file: <xsl:value-of select="$desc_file"/>
    </h3>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="ext_description">
    <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>
    <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

    <xsl:variable name="module" 
      select="translate(@module_directory,$UPPER,$LOWER)"/>
    <xsl:variable name="arm_mim"
      select="substring-before(/ext_descriptions/@schema_file,'.xml')"/>
    <xsl:variable name="baselink">
      <xsl:value-of select="concat(/ext_descriptions/@module_directory,':',$arm_mim,':')"/>
    </xsl:variable>


    <hr/>
    <i>Reference: </i>
    <xsl:variable name="href">
      <xsl:call-template name="get_href_from_express_ref">
        <xsl:with-param name="linkend" select="concat($baselink,@linkend)"/>
        <xsl:with-param name="baselink" select="'../../../'"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:call-template name="check_valid_linkend">
      <xsl:with-param name="linkend" select="@linkend"/>
    </xsl:call-template>


    <xsl:choose>
      <xsl:when test="$href=''">
        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="warning_gif"
            select="'../../../../images/warning.gif'"/>
          <xsl:with-param 
            name="message" 
            select="concat('Error d1: ext_description reference=', 
                    @linkend, 
                    ' is incorrectly specified')"/>
        </xsl:call-template>
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <a href="{$href}">
          <xsl:value-of select="./@linkend"/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
    <br/><i>Description: </i>
    <xsl:choose>
      <xsl:when test="string-length(.)">
        <blockquote>
          <xsl:apply-templates/>
        </blockquote>        
      </xsl:when>
      <xsl:otherwise>
        -
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
      
  <!-- overwrite express_ref defined in common.xsl
       calls get_href_from_express_ref with a baselink
       -->
  <xsl:template match="express_ref">
    <xsl:variable name="href">
      <xsl:call-template name="get_href_from_express_ref">
        <xsl:with-param name="baselink" select="'../../../'"/>
        <xsl:with-param name="linkend" select="@linkend"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="item">
      <xsl:call-template name="get_last_section">
        <xsl:with-param name="path" select="@linkend"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$href=''">
        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Error d2: express_ref linkend', 
                    @linkend, 
                    ' is incorrectly specified')"/>
        </xsl:call-template>
        <xsl:choose>
          <xsl:when test="string-length(.)>0">
            <b><xsl:apply-templates/></b>
          </xsl:when>
          <xsl:otherwise>
            <b><xsl:value-of select="$item"/></b>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="string-length(.)>0">
            <a href="{$href}"><b><xsl:apply-templates/></b></a>
          </xsl:when>
          <xsl:otherwise>
            <a href="{$href}"><b><xsl:value-of select="$item"/></b></a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>


  <!-- NOT YET IMPLIMENETD -->
<xsl:template name="check_valid_linkend">
  <xsl:param name="linkend"/>

  <xsl:variable name="no_dots">
    <xsl:call-template name="count_substring">
      <xsl:with-param name="substring" select="'.'"/>
      <xsl:with-param name="string" select="@linkend"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="model" select="document(../../@schema_file)"/>
  <xsl:choose>

    <xsl:when test="$no_dots=0">
      <!-- schema -->
      <xsl:variable name="schema" select="$linkend"/>
      <xsl:variable name="schema_node" 
        select="document(../../@schema_file)"/>
          {<xsl:value-of select="$schema_node"/>}
      <xsl:choose>
        <xsl:when test="$schema_node">

          <xsl:call-template name="error_message">
            <xsl:with-param name="message">
              <xsl:value-of 
                select="concat('Error D1: ',$linkend, 
                        ' does not specify an entity in ', ../../@schema_file)"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
      </xsl:choose>
    </xsl:when>


    <xsl:when test="$no_dots=1">
      <!-- entity or type or rule or function or procedure -->
    </xsl:when>
    <xsl:when test="$no_dots=2">
      <!-- attribute or where rule -->
      <xsl:choose>
        <xsl:when test="contains($linkend,':')">
          <!-- where or unique rule -->
        </xsl:when>
        <xsl:otherwise>
          <!-- attribute -->
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
  </xsl:choose>

</xsl:template>

</xsl:stylesheet>