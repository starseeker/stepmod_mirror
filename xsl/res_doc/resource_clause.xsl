<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: resource_clause.xsl,v 1.3 2003/01/24 21:00:24 thendrix Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST under contract.
  Purpose:
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
  
  <xsl:template match="/" >
    <xsl:apply-templates select="./resource_clause" />
  </xsl:template>


  <xsl:template match="resource_clause">
    <!-- the XML file to which the stylesheet will be applied 
         NOTE: that the path used by document is relative to the directory
         of this xsl file
         -->
    
 
    <xsl:variable 
      name="resource_xml"
      select="document(concat('../../data/resource_docs/',@directory,'/resource.xml'))"/>

    <HTML>
      <HEAD>
        <!-- apply a cascading stylesheet.
             The stylesheet will only be applied if the parameter output_css
             is set in parameter.xsl 
             -->
        <xsl:call-template name="output_css">
          <xsl:with-param name="path" select="'../../../../css/'"/>
        </xsl:call-template>

        <xsl:apply-templates select="$resource_xml/resource" mode="meta_data"/>

        <TITLE>
          <!-- output the resource page title -->
          <xsl:apply-templates 
            select="$resource_xml/resource"
            mode="title"/>
        </TITLE>
      </HEAD>
      <BODY>
        <!-- debug <xsl:message><xsl:value-of select="$global_xref_list"/></xsl:message> -->
        <!-- output the Table of contents banner -->
        <xsl:apply-templates 
          select="$resource_xml/resource"
          mode="TOCmultiplePage"/>

        <xsl:choose>
          <xsl:when test="@pos">
            <!--           <xsl:value-of select="@pos"/> -->
            <xsl:apply-templates select="$resource_xml/resource">
             <xsl:with-param name="pos" select="string(@pos)"/>
           </xsl:apply-templates>
         </xsl:when>
         <xsl:otherwise>
           <xsl:apply-templates select="$resource_xml/resource"/>
         </xsl:otherwise>
       </xsl:choose>
</BODY>
    </HTML>
  </xsl:template>


</xsl:stylesheet>
