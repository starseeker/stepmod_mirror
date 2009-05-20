<?xml version="1.0" encoding="utf-8"?>
<!-- <?xml-stylesheet type="text/xsl" href="../../xsl/document_xsl.xsl" ?>
-->
<!--
$Id: index_arm_modules_inner.xsl,v 1.15 2004/12/29 14:29:24 robbod Exp $
  Author:  Nigel Shaw, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: 
  	1) To display a matrix showing which entities are included 
	(either directly or via inheritance) in extensible select types
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		xmlns:exslt="http://exslt.org/common"
                exclude-result-prefixes="msxsl exslt"
                version="1.0">


<!--	<xsl:import href="../../xsl/express.xsl"/>
-->

  <xsl:import href="common.xsl"/>


  <xsl:variable name="selected_ap" select="/application_protocol/@directory"/>

  <xsl:output method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" indent="yes"/> 


  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>

  <xsl:variable name="ap_file" 
	    select="concat('../../data/application_protocols/',$selected_ap,'/application_protocol.xml')"/>
	    
  <xsl:variable name="ap_node"
	    select="document($ap_file)"/>

  <xsl:variable name="ap_top_module"
	    select="$ap_node/application_protocol/@module_name"/>

  <xsl:variable name="iframe-width"
	    select="150"/>

  <xsl:variable name="top_module_file" 
	    select="concat('../../data/modules/',$ap_top_module,'/arm.xml')"/>


	<xsl:template match="/">
		<HTML>
			<head>
				<!--      <link rel="stylesheet" type="text/css" 
             href="../../../../nav/css/developer.css"/>
             -->
				<xsl:apply-templates select="$ap_node" mode="meta_data"/>
				<title>
					<xsl:value-of select="concat('AP Index for ',$selected_ap)"/>
				</title>
			</head>
			<body>
				<xsl:apply-templates select="/" mode="index"/>
			</body>
		</HTML>
	</xsl:template>

	<xsl:template match="/" mode="index">
		<small>
			<a HREF="frame_index{$FILE_EXT}" TARGET="index">Back to navigation indices</a>
			<br/>
			<b>Module ARMs </b>
			<br/>
			<br/>
			<xsl:variable name="top_module_node" select="document($top_module_file)/express"/>
			<xsl:variable name="schema-name" select="$top_module_node//schema/@name"/>
			<xsl:variable name="arm_schemas">
				<xsl:call-template name="depends-on-recurse-no-list-x">
					<xsl:with-param name="todo" select="concat(' ',$schema-name,' ')"/>
					<xsl:with-param name="done" select="' '"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="function-available('msxsl:node-set')">
					<xsl:variable name="schemas-node-set" select="msxsl:node-set($arm_schemas)"/>
					<xsl:variable name="dep-schemas3">
						<xsl:for-each select="$schemas-node-set//x">
							<xsl:sort/>
							<!-- added sort here which is not in the saxon version below -->
							<xsl:copy-of select="document(.)"/>
						</xsl:for-each>
					</xsl:variable>

					<xsl:variable name="dep-schemas" select="msxsl:node-set($dep-schemas3)"/>
					<xsl:call-template name="modules_index">
						<xsl:with-param name="this-schema" select="$top_module_node"/>
						<xsl:with-param name="called-schemas" select="$dep-schemas"/>
					</xsl:call-template>
				</xsl:when>

				<xsl:when test="function-available('exslt:node-set')">
					<xsl:variable name="schemas-node-set" select="exslt:node-set($arm_schemas)"/>
					<xsl:variable name="dep-schemas3">
						<xsl:for-each select="$schemas-node-set//x">
							<xsl:sort/>
							<xsl:copy-of select="document(.)"/>
						</xsl:for-each>
					</xsl:variable>

					<xsl:variable name="dep-schemas" select="exslt:node-set($dep-schemas3)"/>

					<xsl:call-template name="modules_index">
						<xsl:with-param name="this-schema" select="$top_module_node"/>
						<xsl:with-param name="called-schemas" select="$dep-schemas"/>
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
		</small>
	</xsl:template>

	<xsl:template name="modules_index">
		<xsl:param name="this-schema"/>
		<xsl:param name="called-schemas"/>
		<xsl:variable name="parts">
			<parts>
				<xsl:for-each select="$called-schemas//schema">
					<xsl:variable name="module">
						<xsl:call-template name="module_name">
							<xsl:with-param name="module" select="@name"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="module_xml"
						select="concat('../../data/modules/',$module,'/module.xml')"/>
					<part> 
						<xsl:attribute name="number">
							<xsl:value-of
								select="document($module_xml)/module/@part"/>
						</xsl:attribute>
						<xsl:attribute name="name">
							<xsl:value-of select="$module"/>
						</xsl:attribute>						
					</part>
				</xsl:for-each>
			</parts>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="function-available('msxsl:node-set')">
				<xsl:variable name="parts-node-set" select="msxsl:node-set($parts)"/>
				<xsl:for-each select="$parts-node-set//part">
					<xsl:sort select="@number"/>
					<a href="../../../modules/{@name}/sys/1_scope{$FILE_EXT}" target="info">
						<xsl:value-of select="concat(@number,' ',@name)"/>
					</a>
					<br/>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="function-available('exslt:node-set')">
				<xsl:variable name="parts-node-set" select="exslt:node-set($parts)"/>
				<xsl:for-each select="$parts-node-set//part">
					<xsl:sort select="@number"/>
					<a href="../../../modules/{@name}/sys/1_scope{$FILE_EXT}" target="info">
						<xsl:value-of select="concat(@number,' ',@name)"/>
					</a>
					<br/>
				</xsl:for-each>
			</xsl:when>
		</xsl:choose>
		
	</xsl:template>

	<xsl:template name="depends-on-recurse-no-list-x">
		<xsl:param name="todo" select="' '"/>
		<xsl:param name="done"/>
		<!--
	For each interfaced schema:
		Check if not already done
		Otherwise output and add to todo
	-->

		<xsl:variable name="this-schema"
			select="substring-before(concat(normalize-space($todo),' '),' ')"/>

		<xsl:if test="$this-schema">

			<xsl:if test="not(contains($done,$this-schema))">
				<xsl:variable name="mod"
					select="substring-before(translate($this-schema,$UPPER,$LOWER),'_arm')"/>
				<!-- notes:
msxml needs addresses relative to the original xml file
saxon needs addresses relative to the xsl file.
msxml Only seems to pick up on first file - treating parameter to document() differently from saxon.
-->

				<xsl:variable name="dir">
					<xsl:choose>
						<xsl:when test="function-available('exslt:node-set')">../../../</xsl:when>
						<xsl:otherwise>../../../../../</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<x>
					<xsl:variable name="prefix">
						<xsl:call-template name="get_last_section">
							<xsl:with-param name="path" select="$this-schema"/>
							<xsl:with-param name="divider" select="'_'"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="$prefix='schema'">
							<xsl:value-of
								select="concat($dir,'data/resources/',$this-schema,'/',$this-schema,'.xml ')"
							/>
						</xsl:when>
						<xsl:when test="starts-with($this-schema,'aic_')">
							<xsl:value-of
								select="concat($dir,'data/resources/',$this-schema,'/',$this-schema,'.xml ')"
							/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of
								select="concat($dir,'stepmod/data/modules/',$mod,'/arm.xml ')"/>
						</xsl:otherwise>
					</xsl:choose>
				</x>
			</xsl:if>

			<!-- open up the relevant schema -->

			<xsl:variable name="arm_file"
				select="concat('../../data/modules/',
			    		translate(substring-before($this-schema,'_arm'),$UPPER,$LOWER),'/arm.xml')"/>

			<xsl:variable name="arm-node" select="document($arm_file)/express"/>


			<!-- get the list of schemas for this level that have not already been done -->

			<xsl:variable name="my-kids">
				<xsl:apply-templates select="$arm-node//interface" mode="interface-schemas">
					<xsl:with-param name="done" select="$done"/>
				</xsl:apply-templates>
			</xsl:variable>

			<xsl:variable name="after"
				select="normalize-space(concat(substring-after($todo, $this-schema),$my-kids))"/>


			<xsl:if test="$after">
				<xsl:call-template name="depends-on-recurse-no-list-x">
					<xsl:with-param name="todo" select="$after"/>
					<xsl:with-param name="done" select="concat($done,' ',$this-schema,' ')"/>
				</xsl:call-template>


			</xsl:if>

		</xsl:if>

	</xsl:template>

	<xsl:template match="interface" mode="interface-schemas">
		<xsl:param name="done"/>
		<xsl:variable name="schema" select="concat(' ',@schema,' ')"/>
		<xsl:if test="not(contains($done,$schema))">
			<xsl:value-of select="$schema"/>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
