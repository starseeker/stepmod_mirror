<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_5_mapping.xsl,v 1.26 2002/06/19 06:54:38 robbod Exp $
  Author:  Rob Bodington, Nigel Shaw Eurostep Limited
  Owner:   Developed by Eurostep in conjunction with PLCS Inc
  Purpose:
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">



<xsl:template match="mapping_table" mode="check_all_arm_mapped">
  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="/module/@name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="ae_nodes" select="./ae"/>
  <xsl:for-each
    select="document(concat($module_dir,'/arm.xml'))/express/schema/entity">
    <xsl:variable name="entity" select="@name"/>
    <xsl:if test="not($ae_nodes[@entity=$entity])">
      <xsl:call-template name="error_message">
        <xsl:with-param 
          name="message" 
          select="concat('Error mc5: the entity ',$entity,' has not been mapped.')"/>
      </xsl:call-template>    

    </xsl:if>
  </xsl:for-each>
</xsl:template>


<xsl:template name="check_entity_exists">
  <xsl:param name="entity"/>
  <xsl:if test="$check_mapping='yes'">
    <xsl:if
      test="not(contains($global_xref_list,concat('.',$entity,'|')))">
      <xsl:call-template name="error_message">
        <xsl:with-param 
          name="message" 
          select="concat('Error mc1: the entity ',$entity,' has not been
                  interfaced from an integrated resource or MIM.')"/>
      </xsl:call-template>    
    </xsl:if>
  </xsl:if>
</xsl:template>


<xsl:template name="check_valid_attribute">
  <xsl:param name="entity"/>
  <xsl:param name="attribute"/>
  <!-- not yet implemented -->
</xsl:template>


<xsl:template match="refpath|aimelt" mode="check_ref_path_old">
  <xsl:if test="not(string(.)='PATH')">
    <!-- make sure that refpath ends in $ -->
    <xsl:variable name="refpath" 
      select="translate(concat(.,'$'),'&#xA;&#xD;','$')"/>
    <!-- process line at a time -->
    <xsl:call-template name="check_ref_path_line">
      <xsl:with-param name="refpath" select="$refpath"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>
<xsl:template match="aimelt" mode="check_aimelt">
</xsl:template>

<xsl:template match="refpath" mode="check_ref_path">
  <xsl:variable name="refpath">
    <xsl:call-template name="parse_refpath"/>
  </xsl:variable>
</xsl:template>

<xsl:template name="parse_refpath">
  <xsl:element name="refpaths">
    xxxx
  </xsl:element>
</xsl:template>

<xsl:template name="refpath">
qqqqq
</xsl:template>

</xsl:stylesheet>

