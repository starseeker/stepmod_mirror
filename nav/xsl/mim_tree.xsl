<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="../../xsl/document_xsl.xsl" ?>
<!--
$Id: mim_tree.xsl,v 1.2 2003/02/14 10:45:21 nigelshaw Exp $
  Author:  Nigel Shaw, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: 
  	1) To present a long form ARM schema for a module 
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		xmlns:saxon="http://icl.com/saxon"
                version="1.0">

	<xsl:import href="../../xsl/express.xsl"/>



  <xsl:output method="html"/>

  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>
	
	<xsl:variable name="mod_dir_from_5mvxml" select="//module_clause/@directory"/><!-- MWD added -->

  <xsl:variable name="mod_file" 
  	select="concat('../../data/modules/', $mod_dir_from_5mvxml,'/module.xml')"/><!-- MWD modified -->
	    
  <xsl:variable name="module_node"
	    select="document($mod_file)"/>


  <xsl:template match="/" >
    <xsl:apply-templates select="./stylesheet_application"/>
  </xsl:template>

  <xsl:template match="stylesheet_application">
    <HTML>
    <head>
      <link rel="stylesheet" type="text/css" 
        href="../../../../nav/css/developer.css"/>
      <title>
        <xsl:value-of select="concat('MIM tree for module: ',@directory)"/>
      </title>

    </head>
  <body>

	<xsl:variable name="mim_file" 
	    select="concat('../../data/modules/',@directory,'/mim.xml')"/>

	<xsl:variable name="mim_node"
	    select="document($mim_file)/express"/>

	<xsl:variable name="schema-name"
	    select="$mim_node//schema/@name"/>

			
	<xsl:variable name="schemas" >
		<xsl:call-template name="depends-on-recurse-mim-x">
			<xsl:with-param name="todo" select="concat(' ',$schema-name,' ')" />
			<xsl:with-param name="done" select="concat(' ',$schema-name,' ')" />
		</xsl:call-template>
	</xsl:variable>

	SCHEMA <xsl:value-of select="$schema-name" /> Depends on the following schemas

		<blockquote>
			<xsl:call-template name="depends-on-recurse-mim">
				<xsl:with-param name="todo" select="concat(' ',$schema-name,' ')" />
				<xsl:with-param name="done" select="concat(' ',$schema-name,' ')" />
			</xsl:call-template>
		</blockquote>
	<hr/>
		<xsl:value-of select="$schemas" />
  </body>
</HTML>
</xsl:template>


<xsl:template name="depends-on-recurse-mim" >
	<xsl:param name="todo" select="' '"/>
	<xsl:param name="done" />
	<!--
	For each interfaced schema:
		Check if not already done
		Otherwise output and add to todo
	-->

	<xsl:variable name="this-schema" select="substring-before(concat(normalize-space($todo),' '),' ')" />
		<xsl:if test="$this-schema" >

			<xsl:if test="not(contains($done,concat(' ',$this-schema,' ')))" >
			<xsl:value-of select="concat($this-schema,' ')" />
			<br/>
			</xsl:if>

<!-- open up the relevant schema  - which can be a resource or a mim schema -->

	<xsl:variable name="file_name" >
		<xsl:choose>
			<xsl:when test="function-available('msxsl:node-set')" >
			<xsl:choose>
				<xsl:when test="substring-before($this-schema,'_mim')" >
			    		<xsl:value-of select="concat('../../../modules/',substring-before($this-schema,'_mim'),'/mim.xml')" />
				</xsl:when>
				<xsl:when test="substring-before($this-schema,'_schema')" >
			    <xsl:value-of select="concat('../../../resources/',$this-schema,'/',$this-schema,'.xml')" />
				</xsl:when>
				<xsl:when test="starts-with($this-schema,'aic_')" >
			    <xsl:value-of select="concat('../../../resources/',$this-schema,'/',$this-schema,'.xml')" />
				</xsl:when>
				<xsl:otherwise>
				BAD SCHEMA name !!! <xsl:value-of select="$this-schema"/>
				</xsl:otherwise>
			</xsl:choose>
			</xsl:when>
			<xsl:when test="function-available('saxon:node-set')" >
			<xsl:choose>
				<xsl:when test="substring-before($this-schema,'_mim')" >
			    		<xsl:value-of select="concat('../../data/modules/',substring-before($this-schema,'_mim'),'/mim.xml')" />
				</xsl:when>
				<xsl:when test="substring-before($this-schema,'_schema')" >
			    <xsl:value-of select="concat('../../data/resources/',$this-schema,'/',$this-schema,'.xml')" />
				</xsl:when>
				<xsl:when test="starts-with($this-schema,'aic_')" >
			    <xsl:value-of select="concat('../../data/resources/',$this-schema,'/',$this-schema,'.xml')" />
				</xsl:when>
				<xsl:otherwise>
				BAD SCHEMA name !!! <xsl:value-of select="$this-schema"/>
				</xsl:otherwise>
			</xsl:choose>
			</xsl:when>
		</xsl:choose>
			</xsl:variable>


			<xsl:variable name="mim-node"
			    select="document($file_name)/express"/>


<!-- get the list of schemas for this level that have not already been done -->

			<xsl:variable name="my-kids" >
				<xsl:if test="not(contains($done,concat(' ',$this-schema,' ')))" >
					<xsl:apply-templates select="$mim-node//interface" mode="interface-schemas" >
						<xsl:with-param name="done" select="$done" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:variable>

			<blockquote>
			Children: <xsl:value-of select="$my-kids" />
			</blockquote>
			
			<xsl:variable name="after" select="normalize-space(concat(substring-after($todo, $this-schema),$my-kids))" />


			<xsl:if test="$after" >
				<xsl:call-template name="depends-on-recurse-mim">
					<xsl:with-param name="todo" select="$after" />
					<xsl:with-param name="done" select="concat($done,' ',$this-schema,' ')" />
				</xsl:call-template>

	
			</xsl:if>

		</xsl:if>

</xsl:template>

<xsl:template match="interface" mode="interface-schemas" >
	<xsl:param name="done" />
	<xsl:if test="not(contains($done,concat(' ',@schema,' ')))" >
		<xsl:value-of select="concat(' ',translate(@schema,$UPPER,$LOWER),' ')" /> 
	</xsl:if>
</xsl:template>

<xsl:template name="depends-on-recurse-mim-x" >
	<xsl:param name="todo" select="' '"/>
	<xsl:param name="done" />
	<!--
	For each interfaced schema:
		Check if not already done
		Otherwise output and add to todo
	-->

	<xsl:variable name="this-schema" select="substring-before(concat(normalize-space($todo),' '),' ')" />

		<xsl:if test="$this-schema" >


<!-- open up the relevant schema  - which can be a resource or a mim schema -->

	<xsl:variable name="file_name" >
		<xsl:choose>
			<xsl:when test="function-available('msxsl:node-set')" >
			<xsl:choose>
				<xsl:when test="substring-before($this-schema,'_mim')" >
			    		<xsl:value-of select="concat('../../../modules/',substring-before($this-schema,'_mim'),'/mim.xml')" />
				</xsl:when>
				<xsl:when test="substring-before($this-schema,'_schema')" >
			    <xsl:value-of select="concat('../../../resources/',$this-schema,'/',$this-schema,'.xml')" />
				</xsl:when>
				<xsl:when test="starts-with($this-schema,'aic_')" >
			    <xsl:value-of select="concat('../../../resources/',$this-schema,'/',$this-schema,'.xml')" />
				</xsl:when>
				<xsl:otherwise>
				BAD SCHEMA name !!! <xsl:value-of select="$this-schema"/>
				</xsl:otherwise>
			</xsl:choose>
			</xsl:when>
			<xsl:when test="function-available('saxon:node-set')" >
			<xsl:choose>
				<xsl:when test="substring-before($this-schema,'_mim')" >
			    		<xsl:value-of select="concat('../../data/modules/',substring-before($this-schema,'_mim'),'/mim.xml')" />
				</xsl:when>
				<xsl:when test="substring-before($this-schema,'_schema')" >
			    <xsl:value-of select="concat('../../data/resources/',$this-schema,'/',$this-schema,'.xml')" />
				</xsl:when>
				<xsl:when test="starts-with($this-schema,'aic_')" >
			    <xsl:value-of select="concat('../../data/resources/',$this-schema,'/',$this-schema,'.xml')" />
				</xsl:when>
				<xsl:otherwise>
				BAD SCHEMA name !!! <xsl:value-of select="$this-schema"/>
				</xsl:otherwise>
			</xsl:choose>
			</xsl:when>
		</xsl:choose>
			</xsl:variable>

			<xsl:if test="not(contains($done,concat(' ',$this-schema,' ')))" >
				<x><xsl:value-of select="translate($file_name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
				'abcdefghijklmnopqrstuvwxyz')" /></x>
			</xsl:if>



			<xsl:variable name="mim-node"
			    select="document($file_name)/express"/>


<!-- get the list of schemas for this level that have not already been done -->

			<xsl:variable name="my-kids" >
				<xsl:if test="not(contains($done,concat(' ',$this-schema,' ')))" >
					<xsl:apply-templates select="$mim-node//interface" mode="interface-schemas" >
						<xsl:with-param name="done" select="$done" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:variable>

			<xsl:variable name="after" select="normalize-space(concat(substring-after($todo, $this-schema),$my-kids))" />


			<xsl:if test="$after" >
				<xsl:call-template name="depends-on-recurse-mim-x">
					<xsl:with-param name="todo" select="$after" />
					<xsl:with-param name="done" select="concat($done,' ',$this-schema,' ')" />
				</xsl:call-template>

	
			</xsl:if>

		</xsl:if>

</xsl:template>



</xsl:stylesheet>
