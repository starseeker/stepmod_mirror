<!--
$Id: part1000_publication_summary.xsl,v 1.2 2009/07/15 16:33:54 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited http://www.eurostep.com
  Purpose: To display a table summarising the modules in an SMRL change request
    This is then to be copied into the SMRL to do a link check
-->

<!-- 
     java -jar c:/apps/saxon6-5-5/saxon.jar -o ../part1000/CR00001/part1000form.htm ../part1000/CR00001/publication_index.xml part1000CRform.xsl
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
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
  <xsl:param name="link" select="true"/>
    <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>
    <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

  <xsl:template match="/">
    <xsl:apply-templates select="part1000.publication_index"/>
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
        <h2>SMRL change request: <xsl:value-of select="@name"/></h2>
        <hr/>
      <xsl:apply-templates select="./modules" mode="table_hdr"/>      
    </body>
  </HTML>
</xsl:template>

  <xsl:template match="modules" mode="table_hdr">
    <p/>
    <table border="1">
      <tr>
        <td><b>Part</b></td>
        <td><b>Edition</b></td>
        <td><b>Name</b></td>
      </tr>
      <xsl:apply-templates select="./module" mode="table_row">
        <xsl:sort select="@name"/>
      </xsl:apply-templates>
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
        <xsl:variable name="module_file"
          select="concat('../../data/modules/',@name,'/module.xml')"/>
        <xsl:variable name="module_node"
          select="document($module_file)/module"/>
        <xsl:variable name="pub_dir" select="concat($stepmodhome,'/part1000')"/>
        
        <xsl:variable name="mod_dir_name"
          select="concat('iso10303_',$module_node/@part)"/>
        
        <tr>
          <!-- Part -->
          <td>
            <xsl:value-of select="concat('10303-',$module_node/@part)"/>
          </td>
          
          <!-- Edition --> 
          <td>
            <xsl:value-of select="$module_node/@version"/>
          </td>
          <!-- Name -->
          <td>
            <xsl:variable name="href" select="concat('data/modules/',@name,'/sys/introduction.htm')"/>
            <a href="{$href}"><xsl:value-of select="@name"/></a>
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
      </tr>      
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

 </xsl:stylesheet>