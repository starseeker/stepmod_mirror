<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: descriptions.xsl,v 1.4 2002/06/20 13:05:53 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep.
  Purpose: To display the ARM external descriptions file.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="./descriptions.xsl"/>

  <xsl:template match="stylesheet_application" mode="ext_descriptions">
    <xsl:variable 
      name="arm_desc_file"
      select="document(concat('../../data/modules/',@directory,'/arm.xml'))/express/@description.file"/>
    <xsl:choose>
      <xsl:when test="$arm_desc_file">
        <xsl:apply-templates 
          select="document($arm_desc_file)/ext_descriptions">
          <xsl:with-param name="module" select="@directory"/>
          <xsl:with-param name="module_href" 
            select="concat('../sys/introduction',$FILE_EXT)"/>
          <xsl:with-param name="express_file" select="'arm.xml'"/>
          <xsl:with-param name="express_file_href" 
            select="concat('../sys/4_info_reqs',$FILE_EXT,'#types')"/>
          <xsl:with-param name="desc_file" select="$arm_desc_file"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        No external descriptions provided.
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


</xsl:stylesheet>