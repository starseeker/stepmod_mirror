<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
     $Id: resdoc_index.xsl,v 1.6 2003/02/03 13:53:32 robbod Exp $

  Author: Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep and supplied to NIST under contract.
  Purpose: 
     Used to display the index of modules and integrated resources in the
     module repository.  Normally called from: stepmod/repository_index.xml
-->


<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>

<xsl:import href="../repository_index.xsl"/>


<xsl:variable name="warning_gif" select="'./images/warning.gif'" />

<xsl:template match="resource" mode="output">
  <xsl:variable name="xref" select="concat('./data/resources/',@name,'/',@name,$FILE_EXT)"/>

 <xsl:if test="contains(string(@name),'nut_and_bolt_')" >
        <IMG
          SRC="{$warning_gif}" ALT="[warning:]"
          align="absbottom" border="0"
          width="20" height="20"/>
        <font color="#FF0000" size="-1">
           <i>Demo only! </i>
         </font>
       </xsl:if>

  <a href="{$xref}">
    <font size="-1">
      <b><xsl:value-of select="@name"/></b>
    </font>
  </a>
  <br/>
</xsl:template>

<xsl:template match="repository_index" >
  <HTML>
    <HEAD>
      <!-- apply a cascading stylesheet.
           the stylesheet will only be applied if the parameter output_css
           is set in parameter.xsl 
           -->
      <xsl:call-template name="output_css">
        <xsl:with-param name="override_css" select="'stepmod.css'"/>
        <xsl:with-param name="path" select="'./css/'"/>
      </xsl:call-template>
      <TITLE>Module repository</TITLE>
    </HEAD>
    <BODY>
      <table width="600">
        <tr>
          <td>
            <h2>
              <a name="alphatop">
                Alphabetical list of Modules
              </a>
            </h2>
          </td>
          <td>
            <h2>
              <a href="help/index.htm">
                Help
              </a>
            </h2>
          </td>
          <td>
            <h2>
              <a href="ballots/index{$FILE_EXT}">
                Ballots
              </a>
            </h2>
          </td>
        </tr>
      </table>
      <p>      
      <!--
      <font size="-1">
      NB This is a test page. Contents may not be up-to-date and links may not always work. The repository can be found  at <a href="repository_index{$FILE_EXT}">
        <xsl:value-of select="concat('repository_index',$FILE_EXT)"/> </a>
    </font>
    -->
  </p>
  <font size="-1">
  <b>
    The use of this page is deprecated. 
    <br/>
    It has been replaced by a significantly improved navigation facility available at: 
    <br/>
    <a href="nav/index{$FILE_EXT}">
      <xsl:value-of select="concat('./nav/index',$FILE_EXT)"/>        
    </a>
  </b>
</font>
      <xsl:variable name="module_mid_point"
        select="(count(./modules/module)+1) div 2"/>

      <blockquote>
        <table width="90%" cellspacing="0" cellpadding="4">
          <tr>
            <td valign="top">
              <xsl:apply-templates select="./modules/module" mode="col1">
                <xsl:with-param name="mid_point" select="$module_mid_point"/>
                <xsl:sort select="@name"/>
              </xsl:apply-templates>
            </td>
            <td valign="top">
              <xsl:apply-templates select="./modules/module" mode="col2">
                <xsl:with-param name="mid_point" select="$module_mid_point"/>
                <xsl:sort select="@name"/>
              </xsl:apply-templates>
            </td>
          </tr>
        </table>
      </blockquote>
      <h2>
        <a name="alphatop">
          Alphabetical list of Common Resource schemas
        </a>
      </h2>
      <xsl:variable name="resource_mid_point"
        select="(count(./resources/resource)+1) div 2"/>

      <blockquote>
        <table width="90%" cellspacing="0" cellpadding="4">
          <tr>
            <td valign="top">
              <xsl:apply-templates select="./resources/resource" mode="col1">
                <xsl:with-param name="mid_point" select="$resource_mid_point"/>
                <xsl:sort select="@name"/>
              </xsl:apply-templates>
            </td>
            <td valign="top">
              <xsl:apply-templates select="./resources/resource" mode="col2">
                <xsl:with-param name="mid_point" select="$resource_mid_point"/>
                <xsl:sort select="@name"/>
              </xsl:apply-templates>
            </td>
          </tr>
        </table>
      </blockquote>
      <xsl:apply-templates select="./application_protocols"/>

      <h2>
        <a name="alphatop">
          Alphabetical list of Integrated Resources
        </a>
      </h2>

      <xsl:variable name="resource_doc_mid_point"
        select="(count(./resource_docs/resource_doc)+1) div 2"/>

      <blockquote>
        <table width="90%" cellspacing="0" cellpadding="4">
          <tr>
            <td valign="top">
              <xsl:apply-templates select="./resource_docs/resource_doc" mode="col1">
                <xsl:with-param name="mid_point" select="$resource_doc_mid_point"/>
                <xsl:sort select="@name"/>
              </xsl:apply-templates>
            </td>
            <td valign="top">
              <xsl:apply-templates select="./resource_docs/resource_doc" mode="col2">
                <xsl:with-param name="mid_point" select="$resource_doc_mid_point"/>
                <xsl:sort select="@name"/>
              </xsl:apply-templates>
            </td>
          </tr>
        </table>
      </blockquote>
      <xsl:apply-templates select="./resource_docs"/>



    </BODY>
  </HTML>
</xsl:template>


<xsl:template match="resource_doc" mode="col1">
  <xsl:param name="mid_point"/>
  <xsl:if test="not(position()>$mid_point)">
    <xsl:apply-templates select="." mode="output"/>
  </xsl:if>
</xsl:template>

<xsl:template match="resource_doc" mode="col2">
  <xsl:param name="mid_point"/>
  <xsl:if test="position()>$mid_point">
    <xsl:apply-templates select="."  mode="output"/>
  </xsl:if>
</xsl:template>
	
<xsl:template match="resource_doc" mode="output">
  <xsl:variable name="xref" 
    select="concat('./data/resource_docs/',@name,'/sys/introduction',$FILE_EXT)"/>
  <xsl:variable name="part">
    <xsl:call-template name="get_resource_doc_part">
      <xsl:with-param name="resdoc_name" select="@name"/>
    </xsl:call-template>
  </xsl:variable>
 <xsl:if test="string(@name)='nutty_bolts'">
        <IMG
          SRC="{$warning_gif}" ALT="[warning:]"
          align="absbottom" border="0"
          width="20" height="20"/>
        <font color="#FF0000" size="-1">
           <i>Demo only! </i>
         </font>
       </xsl:if>
  
       <a href="{$xref}">
    <font size="-1">
      <b>
               <xsl:value-of select="@name"/>
        (
        <xsl:value-of select="$part"/>
        )
      </b>
    </font>
  </a>
  <xsl:variable name="xref5" select="concat('./data/resource_docs/',@name,'/sys/4_info_reqs',$FILE_EXT)"/>
   <xsl:variable name="resdoc_directory" select="concat('./data/resource_docs/',@name)"/>
  <table cellspacing="0" cellpadding="1">
    <tr>
      <td>&#160;&#160;&#160;&#160;</td>
      <td>
        <font size="-2">
          <a href="{aim_expg}">Schema intefaces</a>
        </font>
      </td>
      
      <td>
        <font size="-2">
          <a href="{$resdoc_directory}">
            <img alt="resdoc folder" border="0" align="middle" src="./images/folder.gif"/>
          </a>
        </font>
      </td>
    </tr>
  </table>
</xsl:template>


<xsl:template name="get_resource_doc_part">
  <xsl:value-of select="@part"/>
</xsl:template>

</xsl:stylesheet>



