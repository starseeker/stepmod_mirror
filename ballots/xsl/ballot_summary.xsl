<?xml version="1.0" encoding="utf-8"?>
<!--
$Id: ballot_summary.xsl,v 1.3 2002/06/20 17:06:13 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited http://www.eurostep.com
  Purpose: To display a table summarising the modules in a ballot package

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">


  <xsl:import href="../../xsl/common.xsl"/>


  <xsl:output 
    method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    indent="yes"
    />


  <!-- force the application of the stylesheet to the file specified in the
       file attribute -->
  <xsl:template match="/">
    <xsl:variable name="ballot_index" 
      select="concat('../ballots/',./ballot/@directory,'/ballot_index.xml')"/>
    <xsl:apply-templates select="document($ballot_index)/ballot_index"/>
  </xsl:template>



<xsl:template match="ballot_index">
  <HTML>
    <head>
      <title>
        <xsl:value-of select="@name"/>
      </title>
    </head>
    <body>

      <xsl:call-template name="output_menubar">
        <xsl:with-param name="module_root" select="'.'"/>
        <xsl:with-param name="module_name" select="@name"/>
      </xsl:call-template>
      <hr/>

      <table>
        <tr>
          <td>Ballot package:</td>
          <td><xsl:value-of select="@name"/></td>
        </tr>
        <tr>
          <td>Description:</td>
          <td><xsl:value-of select="@description"/></td>
        </tr>
        <tr>
          <td>Ballot package WG number:</td>
          <td><xsl:value-of select="@wg.number.ballot_package"/></td>
        </tr>
        <tr>
          <td>Ballot package comments:</td>
          <td><xsl:value-of select="@wg.number.ballot_package_comment"/></td>
        </tr>
      </table>
      <hr/>
      <table border="1">
        <tr>
          <td><b>Ballot package</b></td>
          <td><b>Module</b></td>
          <td><b>Part</b></td>
          <td><b>Version</b></td>
          <td><b>Status</b></td>
          <td><b>Year</b></td>
        </tr>
        <xsl:apply-templates select="./*/module"/>
      </table>
    </body>
  </HTML>
</xsl:template>

<xsl:template match="module">

  <xsl:variable name="module_ok">
    <xsl:call-template name="check_module_exists">
      <xsl:with-param name="module" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$module_ok='true'">

      <xsl:variable name="module_file"
        select="concat('../../data/modules/',@name,'/module.xml')"/>
      <xsl:variable name="module_node"
        select="document($module_file)/module"/>
      <tr>
        <!-- Ballot package -->
        <td>
          <xsl:choose>
            <xsl:when test="../@id">
              <xsl:value-of select="concat(../@id,' - ',../@name)"/>    
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="../@name"/> 
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Module -->
        <td>
          <xsl:variable name="mod_xref"
            select="concat('../../../data/modules/',@name,'/sys/1_scope',$FILE_EXT)"/>
          <a href="{$mod_xref}">
            <xsl:value-of select="@name"/>
          </a>
        </td>

        <!-- Part -->
        <td>
          <xsl:choose>
            <xsl:when test="$module_node/@part">
              <xsl:value-of select="concat('10303-',$module_node/@part)"/>

              <!-- check that the part number in repository_index - that in
                   module -->
              <xsl:variable name="module" select="@name"/>
              <xsl:variable name="repo_mod_number"
                select="document('../../repository_index.xml')/repository_index/modules/module[@name=$module]/@part"/>
              <xsl:if test="$repo_mod_number != $module_node/@part">
                <br/>
                <font color="#FF0000" size="-1">
                  The part number in repository_index
                  (<xsl:value-of select="$repo_mod_number"/>)
                does not equal that in module 
                (<xsl:value-of select="$module_node/@part"/>).
              </font>
              </xsl:if>
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
              test="string-length(normalize-space($module_node/@version))>0">
              <xsl:value-of select="$module_node/@version"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
        </td>

        <!-- Status -->
        <td>
          <xsl:choose>
            <xsl:when 
              test="string-length(normalize-space($module_node/@status))>0">
              <xsl:value-of select="$module_node/@status"/>
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
              test="string-length(normalize-space($module_node/@publication.year))>0">
              <xsl:value-of select="$module_node/@publication.year"/>
            </xsl:when>
            <xsl:otherwise>
              -
            </xsl:otherwise>
          </xsl:choose>
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
              <xsl:value-of select="concat('Error ballot1: ', $module_ok)"/>
            </xsl:with-param>
          </xsl:call-template>
        </td>
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


<xsl:template name="get_contact_name">
  <xsl:param name="ref"/>
  <xsl:variable name="contact"
    select="document('../../data/basic/contacts.xml')/contact.list/contact[@id=$ref]"/>
  <xsl:choose>
    <xsl:when test="$contact">
      <xsl:value-of select="concat($contact/firstname,' ',$contact/lastname)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="'-'"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


</xsl:stylesheet>