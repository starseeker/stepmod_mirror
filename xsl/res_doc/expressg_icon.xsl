<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: expressg_icon.xsl,v 1.7 2003/07/28 07:28:41 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep
  Purpose: Read the are maps in an image and create a node list. This is
     then used to determine the EXPRESSG page on which an entity is drawn.
-->
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:exslt="http://exslt.org/common"
  exclude-result-prefixes="msxsl exslt"
  version="1.0">

  <xsl:import href="common.xsl"/>

  <xsl:output method="html"/>


  <xsl:template name="make_schema_expressg_node_set">
    <!-- this needs to be redone so as to get to the resource-->       
    <expg_nodes>
      <xsl:choose>
        <xsl:when test="/resource_clause">
          <xsl:variable name="resdoc_dir">
            <xsl:call-template name="resdoc_directory">
              <xsl:with-param name="resdoc" select="/resource_clause/@directory"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="resdoc" select="concat($resdoc_dir,'/resource.xml')"/>
          <xsl:variable name="resdoc_xml" select="document($resdoc)"/>
          <xsl:apply-templates 
            select="$resdoc_xml/resource/schema/express-g/imgfile" mode="mk_node"/>
        </xsl:when>
        <xsl:when test="/resource">
          <xsl:apply-templates 
            select="/resource/schema/express-g/imgfile" mode="mk_node"/>
        </xsl:when>
      </xsl:choose>
    </expg_nodes>    
  </xsl:template>


  <xsl:template name="get_schema_expressg_file">
    <xsl:param name="object"/>
    <xsl:choose>
      <xsl:when test="function-available('msxsl:node-set')">
        <xsl:variable name="schema_expressg_node_set" select="msxsl:node-set($schema_expressg)"/>
        <xsl:apply-templates
          select="$schema_expressg_node_set/expg_nodes/object[@object=$object]" mode="get_file"/>
      </xsl:when>
      <xsl:when test="function-available('exslt:node-set')">
        <xsl:variable name="schema_expressg_node_set" select="exslt:node-set($schema_expressg)"/>
        <xsl:apply-templates
          select="$schema_expressg_node_set/expg_nodes/object[@object=$object]" mode="get_file"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="get_schema_expressg_href">
    <xsl:param name="object"/>
    <xsl:choose>
      <xsl:when test="function-available('msxsl:node-set')">
        <xsl:variable name="schema_expressg_node_set" select="msxsl:node-set($schema_expressg)"/>
        <xsl:apply-templates
          select="$schema_expressg_node_set/expg_nodes/object[@object=$object]" mode="get_href"/>
      </xsl:when>
      <xsl:when test="function-available('exslt:node-set')">
        <xsl:variable name="schema_expressg_node_set" select="exslt:node-set($schema_expressg)"/>
        <xsl:apply-templates
          select="$schema_expressg_node_set/expg_nodes/object[@object=$object]" mode="get_href"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="object" mode="get_href">
    <xsl:value-of select="@href"/>
  </xsl:template>

  <xsl:template match="object" mode="get_file">
    <xsl:value-of select="@file"/>
  </xsl:template>


  <!-- build the node set of expressg objects -->
  <xsl:template match="imgfile" mode="mk_node">
    <xsl:variable name="img_file"
      select="concat('../../data/resources/',../../@name,'/',./@file)"/>
    <xsl:variable name="img_file_xml" select="document($img_file)"/>
    <xsl:variable name="schema" select="../../@name"/>
    <xsl:apply-templates
      select="$img_file_xml/imgfile.content/img/img.area" mode="mk_node">
      <xsl:with-param name="schema" select="$schema"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="img.area" mode="mk_node">
    <xsl:param name="schema"/>

    <xsl:variable name="uobject"
      select="normalize-space(substring-after(substring-after(@href,'#'),'.'))"/>
    <xsl:variable name="object"
        select="translate($uobject,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>

    <xsl:if test="string-length($object)!=0">
      <!-- the first page should be the schema page so should not have any
           entities on it -->
      <xsl:variable name="schema1"
        select="normalize-space(substring-before(substring-after(@href,'#'),'.'))"/>

      <xsl:variable name="lschema"
        select="translate($schema1,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>

      <xsl:if test="$schema = $lschema">
        <!-- only need to identify the hrefs to objects defined in this
             schema --> 
        <xsl:variable name="file">
          <xsl:call-template name="set_file_ext">
            <xsl:with-param name="filename" select="/imgfile.content/@file"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="resource" select="$lschema"/>



        <xsl:element name="object">
          <xsl:attribute name="file">
            <xsl:value-of select="$file"/>
          </xsl:attribute>
          <xsl:attribute name="object">
            <xsl:value-of select="$object"/>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="concat('../../../resources/',$resource,'/',$file)"/>
          </xsl:attribute>
        </xsl:element>
      </xsl:if>
    </xsl:if>

  </xsl:template>
  

  <xsl:template name="expressg_icon">
    <xsl:param name="schema"/>
    <xsl:param name="entity"/>
    <xsl:param name="resdoc_root" select="'..'"/>
    <xsl:variable name="resdoc_dir">
      <xsl:call-template name="resdoc_directory">
        <xsl:with-param name="resdoc" select="$schema"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="lentity"
      select="translate(normalize-space($entity),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/> 


    <xsl:choose>
      <xsl:when test="$lentity"> 
          <xsl:variable name="href_expg">
            <xsl:call-template name="get_schema_expressg_href">
              <xsl:with-param name="object" select="$lentity"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="string-length($href_expg)=0">
              <xsl:variable name="error_msg"
                select="concat('Error EG1: There is no EXPRESS-G reference for:',$lentity,' - check schema_diagexpg files')"/>
              <xsl:call-template name="error_message">
                <xsl:with-param name="inline" select="'yes'"/>
                <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
                <xsl:with-param name="message" select="$error_msg"/>
              </xsl:call-template>   
            </xsl:when>
            <xsl:otherwise>
              &#160;&#160;<a href="{$href_expg}">
              <img align="middle" border="0" 
                alt="EXPRESS-G" src="{$resdoc_root}/../../../images/expg.gif"/></a>
            </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="href_expg">
            <xsl:value-of select="concat($resdoc_root,'/schema_diagexpg1',$FILE_EXT)"/>
      </xsl:variable>
      &#160;&#160;<a href="{$href_expg}">
      <img align="middle" border="0" 
        alt="EXPRESS-G" src="{$resdoc_root}/../../../images/expg.gif"/>
       </a>
     </xsl:otherwise>
   </xsl:choose>
 </xsl:template>


  <!-- display the expressg Icon for an express construct -->
  <xsl:template match="entity|type|schema|constant|subtype.constraint" mode="expressg_icon">
    <!-- the entity may be being referenced from another module
         in which case the schema needs to be explicit.
         This only happens in the mapping tables when and ARM object is
         being remapped from another module. -->
    <xsl:param name="original_schema"/>
    <xsl:param name="resdoc_root" select="'..'"/>
    
    <xsl:variable name="schema">
      <xsl:choose>
        <!-- original_module specified then the ARM object is declared in
             another module -->
        <xsl:when test="$original_schema">
          <xsl:value-of select="$original_schema"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="../@name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
   
    <xsl:variable name="entity" select="@name"/>
    <xsl:call-template name="expressg_icon">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="entity" select="$entity"/>
      <xsl:with-param name="resdoc_root" select="$resdoc_root"/>
    </xsl:call-template>

  </xsl:template>

</xsl:stylesheet>