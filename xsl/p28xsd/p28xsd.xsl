<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: p28xsd.xsl,v 1.7 2004/04/22 20:41:23 mikeward Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to UK MOD under contract.
  Purpose: To apply the XSL that generates the XSD from the arm_lf
     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		xmlns:exslt="http://exslt.org/common"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="msxsl exslt"
                version="1.0">


  <xsl:import href="modXML2schema.xsl"/>
  <xsl:import href="../common.xsl"/>

  <xsl:output method="html"/>

  <xsl:template match="/" >
    <xsl:apply-templates select="./module_clause" />
  </xsl:template>


  <xsl:template match="module_clause">
    <xsl:variable 
      name="module_xml"
      select="document(concat('../../data/modules/',@directory,'/module.xml'))"/>
    <HTML>
      <HEAD>
        <link
          rel="stylesheet"
          type="text/css"
          href="../../../../css/stepmod.css"/>
        <xsl:apply-templates select="$module_xml/module" mode="meta_data"/>

        <TITLE>
          <!-- output the module page title -->
          <xsl:apply-templates 
            select="$module_xml/module"
            mode="title"/>
        </TITLE> 
      </HEAD>
      <BODY>
        <h3>
          ISO 10303 P28 XML Schema for:
          <a href="./sys/introduction{$FILE_EXT}"><xsl:value-of select="@directory"/></a>
        </h3>
        <p>
          <b>WARNING:</b>
        </p>
        <p>
          <b>
            This xml schema is based on the 2004 CD draft of ISO 10303-28 Edition 2. It
            is subject to further change and is awaiting resolution of technical
            issues. Do not use.
          </b>
        </p>
        <xsl:choose>
          <xsl:when test="$module_xml/module/arm_lf">
            <xsl:variable name="arm_lf" select="document(concat('../../data/modules/',@directory,'/arm_lf.xml'))"/>
            <xsl:variable name="p28_xml">
              <xsl:apply-templates select="$arm_lf/express"/>
            </xsl:variable>            
            <xsl:choose>
              <xsl:when test="function-available('msxsl:node-set')">
                <xsl:variable name="p28_node_set" select="msxsl:node-set($p28_xml)"/>
                <xsl:apply-templates select="$p28_node_set" mode="schema"/>
              </xsl:when>
              <xsl:when test="function-available('exslt:node-set')">
                <xsl:variable name="p28_node_set" select="exslt:node-set($p28_xml)"/>
                <xsl:apply-templates select="$p28_node_set" mode="schema"/>
              </xsl:when>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="error_message">
              <xsl:with-param 
                name="message" 
                select="concat('Error IMPL1: The module ',../@directory,' must have a long form')"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </BODY>
    </HTML>
  </xsl:template>
  
  <!-- xsl:template match="/" mode="schema">
    <xsl:call-template name="generate_xsd">
      <xsl:with-param name="schema_node_param" select="."/>
      <xsl:with-param name="indent_param" select="string('')"/>
    </xsl:call-template>		
  </xsl:template>

	<xsl:template name="generate_xsd">
		<xsl:param name="schema_node_param"/>
		<xsl:param name="indent_param"/>
		<xsl:variable name="new_indent" select="concat($indent_param, '&#160;&#160;&#160;&#160;')"/>
		<xsl:for-each select="$schema_node_param/*">
			<xsl:variable name="element_name" select="name()"/>
			<xsl:value-of select="$indent_param"/>&lt;<xsl:value-of select="$element_name"/>
			<xsl:for-each select="namespace::*">
				<xsl:value-of select="string(' ')"/>
				<xsl:if test="not(../ancestor::*[namespace::*[name() = name(current()) and . = current()]][last()])">
					<xsl:if test=".!='http://www.w3.org/XML/1998/namespace'">
						<xsl:choose>
							<xsl:when test="name()">xmlns:<xsl:value-of select="name()" /></xsl:when>
	            					<xsl:otherwise>xmlns</xsl:otherwise>
	            				</xsl:choose>
	            				<xsl:text />=&quot;<xsl:value-of select="." />&quot;<xsl:text />
	            			</xsl:if>
	            		</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="./@*">
				<xsl:value-of select="string(' ')"/>
				<xsl:value-of select="name()"/>=&quot;<xsl:value-of select="."/>&quot;<xsl:text/>
			</xsl:for-each>&gt;<xsl:text/>
			
			<br/>
			<xsl:choose>
				<xsl:when test="$new_indent='&#160;&#160;&#160;&#160;'">
					<br/>
				</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
			<xsl:variable name="content" select="text()"/>
			<xsl:if test="$content">
				<xsl:value-of select="$new_indent"/>
				<xsl:value-of select="$content"/>
				<br/>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="./*">
					<xsl:call-template name="generate_xsd">
						<xsl:with-param name="schema_node_param" select="."/>
						<xsl:with-param name="indent_param" select="$new_indent"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
			<xsl:value-of select="$indent_param"/>&lt;/<xsl:value-of select="$element_name"/>&gt;<br/>
			<xsl:choose>
				<xsl:when test="$indent_param='&#160;&#160;&#160;&#160;'">
					<br/>
				</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template -->

<xsl:template match="xs:schema" mode="schema">
		&lt;<xsl:value-of select="string('xs:schema')"/>
				<xsl:for-each select="namespace::*">
					<xsl:value-of select="string(' ')"/>
					<xsl:if test=".!='http://www.w3.org/XML/1998/namespace'">
						<xsl:choose>
							<xsl:when test="name()">xmlns:<xsl:value-of select="name()" /></xsl:when>
		            				<xsl:otherwise>xmlns</xsl:otherwise>
		            			</xsl:choose>
	            				<xsl:text />=&quot;<xsl:value-of select="." />&quot;<xsl:text />
	           			</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="./@*">
					<xsl:value-of select="string(' ')"/>
					<xsl:value-of select="name()"/>=&quot;<xsl:value-of select="."/>&quot;<xsl:text/>
				</xsl:for-each>&gt;<xsl:text/><br/>
				<xsl:apply-templates select="./*" mode="content"/>
			&lt;/<xsl:value-of select="string('xs:schema')"/>&gt;<br/>
	</xsl:template>
	
	<xsl:template match="*" mode="content">
		<xsl:variable name="indent">
			<xsl:for-each select="ancestor ::*">&#160;&#160;&#160;&#160;</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="comment" select="comment()"/>
		<xsl:if test="string-length($comment) > 0">
			<xsl:value-of select="concat($indent, '&lt;!-- ', $comment, ' --&gt;')"/><br/>
		</xsl:if>
		<xsl:variable name="element_name" select="name()"/>
		<xsl:value-of select="$indent"/>&lt;<xsl:value-of select="$element_name"/>
			<xsl:for-each select="./@*">
				<xsl:value-of select="string(' ')"/>
				<xsl:value-of select="name()"/>=&quot;<xsl:value-of select="."/>&quot;<xsl:text/>
			</xsl:for-each>&gt;<xsl:text/>
			<br/>
			<xsl:variable name="content" select="text()"/>
			<xsl:if test="$content">
				<xsl:value-of select="$content"/>
				<br/>
			</xsl:if>
			<xsl:if test="./*">
				<xsl:apply-templates select="./*" mode="content"/>
			</xsl:if>
			
		<xsl:value-of select="$indent"/>&lt;/<xsl:value-of select="$element_name"/>&gt;<br/>	
	</xsl:template>


</xsl:stylesheet>

