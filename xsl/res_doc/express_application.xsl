<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
     $Id: express_application.xsl,v 1.2 2002/03/04 07:54:07 robbod Exp $

  Author: Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep and supplied to NIST under contract.
  Purpose: 
     Used to display the information about the application that generated
     the EXPRESS.
-->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>

  <xsl:output method="html"/>



<!--
     Insert META data about the application that generated the Express XML
-->
<xsl:template match="application" mode="meta">
  <xsl:variable 
    name="name" 
    select="concat(@name,' ',@version)"/>
  <xsl:variable name="source" select="@source"/>

  <xsl:call-template name="meta-elements">
    <xsl:with-param name="name" select="'GENERATOR'"/>
    <xsl:with-param name="content" select="$name"/>
  </xsl:call-template>

  <xsl:call-template name="meta-elements">
    <xsl:with-param name="name" select="'EXPRESS-FILE'"/>
    <xsl:with-param name="content" select="@source"/>
  </xsl:call-template>

</xsl:template>



<xsl:template match="application" mode="body">
  <xsl:variable 
    name="name" 
    select="concat(@name,' ',@version)"/>
  <xsl:variable name="source" select="@source"/>

  <hr/>
  <table>
    <tr>
      <td>Application:</td>
      <td>
        <xsl:value-of select="$name"/>
      </td>
    </tr>
    <tr>
      <td>Express:</td>
      <td>
        <xsl:value-of select="@source"/>
      </td>        
    </tr>
  </table>
  <hr/>
</xsl:template>

</xsl:stylesheet>

