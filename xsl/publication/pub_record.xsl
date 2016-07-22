<?xml version="1.0" encoding="utf-8"?>
<!--
$ Id: build.xsl,v 1.9 2003/02/26 02:12:17 thendrix Exp $
   Author:  Rob Bodington, Eurostep Limited
   Owner:   Developed by Eurostep Limited http://www.eurostep.com and supplied to NIST under contract.
   Purpose: To output publication_record.xml. A list of the file revisions
     of a published module.
     Invoked by the ANT publication 
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
  
  <xsl:output method="xml" indent="yes" doctype-system="../../../../../../dtd/publication_record.dtd"/>

<!-- 
     This parameter is passed in from ANT build. 
     Contains the contents of: <module>/CVS/Entries
     Note - XSL cannot read text files, so need to read them to properties
-->
<xsl:param name="CVS_dir_dot_entry"/>

<!-- 
     This parameter is passed in from ANT build. 
     Contains the contents of: <module>/sys/CVS/Entries
     Note - XSL cannot read text files, so need to read them to properties
-->
<xsl:param name="CVS_dir_sys_entry"/>

<!-- 
     This parameter is passed in from ANT build. 
     Contains the contents of: <module>/dvlp/CVS/Entries
     Note - XSL cannot read text files, so need to read them to properties
-->
<xsl:param name="CVS_dir_dvlp_entry"/>

<!-- 
     This parameter is passed in from Saxon. 
     The CVS tag
-->
<xsl:param name="CVS_tag"/>

<!-- 
     This parameter is passed in from Saxon. 
     The CVS tag
-->
<xsl:param name="PUBLICATION_DATE"/>

  <xsl:template match="application_protocol">
    <xsl:variable name="edition" select="@version"/>
    
    <publication_record>
      <application_protocols>
        <xsl:apply-templates select="." mode="published_part">
          <xsl:with-param name="edition" select="$edition"/>
        </xsl:apply-templates>
      </application_protocols>
    </publication_record>
  </xsl:template>

  <xsl:template match="resource">
    <xsl:variable name="edition" select="@version"/>
    <publication_record>
      <resource_doc>
        <xsl:apply-templates select="." mode="published_part">
          <xsl:with-param name="edition" select="$edition"/>
        </xsl:apply-templates>
      </resource_doc>
    </publication_record>
  </xsl:template>

  <xsl:template match="express">
    <publication_record>
      <resource_schema>
        <xsl:apply-templates select="schema" mode="published_part">
          <xsl:with-param name="edition" select="xxx"/>
        </xsl:apply-templates>
      </resource_schema>
    </publication_record>
  </xsl:template>

  <xsl:template match="module">
    <!--
    <xsl:variable name="module_xml"
      select="document(concat('../../data/modules/',@name,'/module.xml'))"/> -->
    <xsl:variable name="edition" select="@version"/>
    <publication_record>
      <modules>
        <xsl:apply-templates select="." mode="published_part">
          <xsl:with-param name="edition" select="$edition"/>
        </xsl:apply-templates>
      </modules>
    </publication_record>
  </xsl:template>
  
  <xsl:template match="business_object_model">
    <!--
      <xsl:variable name="module_xml"
      select="document(concat('../../data/modules/',@name,'/module.xml'))"/> -->
    <xsl:variable name="edition" select="@version"/>
    <publication_record>
      <business_object_models>
        <xsl:apply-templates select="." mode="published_part">
          <xsl:with-param name="edition" select="$edition"/>
        </xsl:apply-templates>
      </business_object_models>
    </publication_record>
  </xsl:template>

  <xsl:template match="module|application_protocol|resource|business_object_model" mode="published_part">
    <xsl:param name="edition"/>
    <xsl:element name="published_part">
      <xsl:attribute name="name">
        <xsl:value-of select="@name"/>              
      </xsl:attribute>
      <edition version="{$edition}" cvs_tag="{$CVS_tag}">
        <iso_record date_submitted="{$PUBLICATION_DATE}" date_published="yyyy-mm-dd"/>
        <directory name=".">
          <xsl:call-template name="entries_to_xml">
            <xsl:with-param name="entries" select="$CVS_dir_dot_entry"/>
          </xsl:call-template>
        </directory>
        <directory name="dvlp">
          <xsl:call-template name="entries_to_xml">
            <xsl:with-param name="entries" select="$CVS_dir_dvlp_entry"/>
          </xsl:call-template>
        </directory>
        <directory name="sys">
          <xsl:call-template name="entries_to_xml">
            <xsl:with-param name="entries" select="$CVS_dir_sys_entry"/>
          </xsl:call-template>
        </directory>
      </edition>
    </xsl:element>
  </xsl:template>

  <xsl:template match="express" mode="published_part">
    <xsl:apply-templates select="schema"  mode="published_part"/>
  </xsl:template>

  <xsl:template match="schema" mode="published_part">
    <xsl:param name="edition"/>
    <xsl:element name="published_part">
      <xsl:attribute name="name">
        <xsl:value-of select="@name"/>              
      </xsl:attribute>
      <edition version="{$edition}" cvs_tag="{$CVS_tag}">
        <iso_record date_submitted="{$PUBLICATION_DATE}" date_published="yyyy-mm-dd"/>
        <directory name=".">
          <xsl:call-template name="entries_to_xml">
            <xsl:with-param name="entries" select="$CVS_dir_dot_entry"/>
          </xsl:call-template>
        </directory>
      </edition>
    </xsl:element>
  </xsl:template>

  <xsl:template name="entries_to_xml">
    <xsl:param name="entries"/>
    <xsl:variable name="line" select="normalize-space(substring-before($entries,'&#xD;'))"/>
    <xsl:variable name="rest" select="substring-after($entries,'&#xD;')"/>
    <xsl:choose>
      <xsl:when test="$line">
        <xsl:if test="substring($line,1,1)='/'">
          <!-- a file entry -->
          <xsl:variable name="file_name" select="substring-before(substring-after($line,'/'),'/')"/>
          <xsl:variable name="revision" select="substring-before(substring-after(substring-after($line,$file_name),'/'),'/')"/>
          <xsl:variable name="date" select="substring-before(substring-after(substring-after($line,$revision),'/'),'/')"/>
          <xsl:element name="file">
            <xsl:attribute name="name">
              <xsl:value-of select="$file_name"/>              
            </xsl:attribute>
            <xsl:attribute name="cvs_revision">
              <xsl:value-of select="$revision"/>
            </xsl:attribute>
            <xsl:attribute name="cvs_date">
              <xsl:value-of select="$date"/>
            </xsl:attribute>
          </xsl:element>
        </xsl:if>
        <xsl:call-template name="entries_to_xml">
          <xsl:with-param name="entries" select="$rest"/>
        </xsl:call-template>        
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
