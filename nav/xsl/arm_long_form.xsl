<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="../../xsl/document_xsl.xsl" ?>
<!--
$Id: arm_long_form.xsl,v 1.3 2002/11/25 16:40:49 nigelshaw Exp $
  Author:  Nigel Shaw, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: 
  	1) To present a long form ARM schema for a module 
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		xmlns:exslt="http://exslt.org/common"
		version="1.0">

	<xsl:import href="../../xsl/express.xsl"/>



  <xsl:output method="html"/>

  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>

  <xsl:variable name="mod_file" 
	    select="concat('../../data/modules/',/stylesheet_application[1]/@directory,'/module.xml')"/>
	    
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
        <xsl:value-of select="concat('ARM long form schema for module: ',@directory)"/>
      </title>

    </head>
  <body>

	<xsl:variable name="arm_file" 
	    select="concat('../../data/modules/',@directory,'/arm.xml')"/>

	<xsl:variable name="arm_node"
	    select="document($arm_file)/express"/>

	<xsl:variable name="schema-name"
	    select="$arm_node//schema/@name"/>

			
	<xsl:variable name="schemas" >
		<xsl:call-template name="depends-on-recurse-no-list-x">
			<xsl:with-param name="todo" select="concat(' ',$schema-name,' ')" />
			<xsl:with-param name="done" select="concat(' ',$schema-name,' ')" />
		</xsl:call-template>
	</xsl:variable>
	<b>	
	Note: The schema below is a pseudo long form constructed on the
        assumption that all USE constructs call out the complete schema. 
	</b>
	<br/>
	<br/>
	SCHEMA <xsl:value-of select="concat(@directory,'_arm_lf; ')" />
	<blockquote>

	      <xsl:choose>
		<xsl:when test="function-available('msxsl:node-set')">

	        	<xsl:variable name="schemas-node-set" select="msxsl:node-set($schemas)" />

			<xsl:variable name="dep-schemas3">
				<xsl:for-each select="$schemas-node-set//x" >
					<xsl:copy-of select="document(.)" />
				</xsl:for-each>
			</xsl:variable>

			<xsl:variable name="dep-schemas" 
			  	select="msxsl:node-set($dep-schemas3)" />
				
			<xsl:apply-templates select="$arm_node//constant | $dep-schemas//constant " mode="annotated-code">
				<xsl:sort select="@name" />
			</xsl:apply-templates>

			<xsl:apply-templates select="$arm_node//type | $dep-schemas//type " mode="annotated-code">
				<xsl:sort select="@name" />
			</xsl:apply-templates>

			<xsl:apply-templates select="$arm_node//entity | $dep-schemas//entity " mode="annotated-code">
				<xsl:sort select="@name" />
			</xsl:apply-templates>

			<xsl:apply-templates select="$arm_node//subtype.constraint | $dep-schemas//subtype.constraint " 
						mode="annotated-code">
				<xsl:sort select="@name" />
			</xsl:apply-templates>

			<xsl:apply-templates select="$arm_node//rule | $dep-schemas//rule " 
						mode="annotated-code">
				<xsl:sort select="@name" />
			</xsl:apply-templates>

			<xsl:apply-templates select="$arm_node//function | $dep-schemas//function " 
						mode="annotated-code">
				<xsl:sort select="@name" />
			</xsl:apply-templates>

			<xsl:apply-templates select="$arm_node//procedure | $dep-schemas//procedure " 
						mode="annotated-code">
				<xsl:sort select="@name" />
			</xsl:apply-templates>


		</xsl:when>


		<xsl:when test="function-available('exslt:node-set')">

			  <xsl:variable name="schemas-node-set2">
			      <xsl:choose>
				<xsl:when test="2 > string-length($schemas)" >
			        </xsl:when>
			        <xsl:otherwise>
			          <xsl:copy-of select="exslt:node-set($schemas)"/>
			        </xsl:otherwise>
			      </xsl:choose>
			    </xsl:variable>



			<xsl:variable name="dep-schemas" select="document(exslt:node-set($schemas-node-set2)//x)" /> 


			<xsl:apply-templates select="$arm_node//constant | $dep-schemas//constant " mode="annotated-code">
				<xsl:sort select="@name" />
			</xsl:apply-templates>

			<xsl:apply-templates select="$arm_node//type | $dep-schemas//type " mode="annotated-code">
				<xsl:sort select="@name" />
			</xsl:apply-templates>

			<xsl:apply-templates select="$arm_node//entity | $dep-schemas//entity " mode="annotated-code">
				<xsl:sort select="@name" />
			</xsl:apply-templates>

			<xsl:apply-templates select="$arm_node//subtype.constraint | $dep-schemas//subtype.constraint " 
						mode="annotated-code">
				<xsl:sort select="@name" />
			</xsl:apply-templates>

			<xsl:apply-templates select="$arm_node//rule | $dep-schemas//rule " 
						mode="annotated-code">
				<xsl:sort select="@name" />
			</xsl:apply-templates>

			<xsl:apply-templates select="$arm_node//function | $dep-schemas//function " 
						mode="annotated-code">
				<xsl:sort select="@name" />
			</xsl:apply-templates>

			<xsl:apply-templates select="$arm_node//procedure | $dep-schemas//procedure " 
						mode="annotated-code">
				<xsl:sort select="@name" />
			</xsl:apply-templates>


		</xsl:when>

              </xsl:choose>

	</blockquote>
	END_SCHEMA; <xsl:value-of select="concat('-- ',@directory,'_arm_lf; ')" />
	<br/>
  
  </body>
</HTML>
</xsl:template>


<xsl:template name="depends-on-recurse-no-list" >
	<xsl:param name="todo" select="' '"/>
	<xsl:param name="done" />
	<!--
	For each interfaced schema:
		Check if not already done
		Otherwise output and add to todo
	-->

	<xsl:variable name="this-schema" select="substring-before(concat(normalize-space($todo),' '),' ')" />

		<xsl:if test="$this-schema" >

			<xsl:if test="not(contains($done,$this-schema))" >
			<xsl:value-of select="concat($this-schema,' ')" />
			<br/>
			</xsl:if>

<!-- open up the relevant schema -->

			<xsl:variable name="arm_file" 
			    select="concat('../../data/modules/',substring-before($this-schema,'_arm'),'/arm.xml')"/>

			<xsl:variable name="arm-node"
			    select="document($arm_file)/express"/>


<!-- get the list of schemas for this level that have not already been done -->

			<xsl:variable name="my-kids" >
				<xsl:apply-templates select="$arm-node//interface" mode="interface-schemas" >
					<xsl:with-param name="done" select="$done" />
				</xsl:apply-templates>
			</xsl:variable>

			<xsl:variable name="after" select="normalize-space(concat(substring-after($todo, $this-schema),$my-kids))" />


			<xsl:if test="$after" >
				<xsl:call-template name="depends-on-recurse-no-list">
					<xsl:with-param name="todo" select="$after" />
					<xsl:with-param name="done" select="concat($done,' ',$this-schema,' ')" />
				</xsl:call-template>

	
			</xsl:if>

		</xsl:if>

</xsl:template>

<xsl:template match="*" mode="annotated-code" >
	<xsl:variable name="addr" select="concat('../../',
			translate(substring-before(../@name,'_arm'),$UPPER,$LOWER),'/sys/4_info_reqs.xml#',
			translate(concat(../@name,'.',@name),$UPPER,$LOWER))" />

	<br/>
	(* <A href="{$addr}"><xsl:value-of select="@name"	/></A> from schema <xsl:value-of select="../@name" /> *)
	<br/>

	<xsl:apply-templates select="." mode="code"/>

</xsl:template>



<xsl:template match="interface" mode="interface-schemas" >
	<xsl:param name="done" />
	<xsl:if test="not(contains($done,@schema))" >
		<xsl:value-of select="concat(' ',@schema,' ')" /> 
	</xsl:if>
</xsl:template>

<xsl:template name="depends-on-recurse-no-list-x" >
	<xsl:param name="todo" select="' '"/>
	<xsl:param name="done" />
	<!--
	For each interfaced schema:
		Check if not already done
		Otherwise output and add to todo
	-->

	<xsl:variable name="this-schema" select="substring-before(concat(normalize-space($todo),' '),' ')" />

		<xsl:if test="$this-schema" >

			<xsl:if test="not(contains($done,$this-schema))" >
				<xsl:variable name="modname" 
				select="substring-before(translate($this-schema,$UPPER,$LOWER),'_arm')" />
<!-- notes:
msxml needs addresses relative to the original xml file
saxon needs addresses relative to the xsl file.
msxml Only seems to pick up on first file - treating parameter to document() differently from saxon.
-->

				<xsl:variable name="dir" >
					<xsl:choose>
						<xsl:when test="function-available('exslt:node-set')">../../</xsl:when>
						<xsl:otherwise>../../../../</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>


				<x>
					<xsl:choose>
						<xsl:when test="contains($this-schema,'_schema')">
							<xsl:value-of 
			select="concat($dir,'data/resources/',$this-schema,'/',$this-schema,'.xml ')" />
						</xsl:when>
						<xsl:when test="starts-with($this-schema,'aic_')">
							<xsl:value-of 
			select="concat($dir,'data/resources/',$this-schema,'/',$this-schema,'.xml ')" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat($dir,'data/modules/',$modname,'/arm.xml ')" />
						</xsl:otherwise>
					</xsl:choose>
				</x>
			</xsl:if>

<!-- open up the relevant schema -->

			<xsl:variable name="arm_file" 
			    select="concat('../../data/modules/',
			    		translate(substring-before($this-schema,'_arm'),$UPPER,$LOWER),'/arm.xml')"/>

			<xsl:variable name="arm-node"
			    select="document($arm_file)/express"/>


<!-- get the list of schemas for this level that have not already been done -->

			<xsl:variable name="my-kids" >
				<xsl:apply-templates select="$arm-node//interface" mode="interface-schemas" >
					<xsl:with-param name="done" select="$done" />
				</xsl:apply-templates>
			</xsl:variable>

		<xsl:variable name="after" select="normalize-space(concat(substring-after($todo, $this-schema),$my-kids))" />


			<xsl:if test="$after" >
				<xsl:call-template name="depends-on-recurse-no-list-x">
					<xsl:with-param name="todo" select="$after" />
					<xsl:with-param name="done" select="concat($done,' ',$this-schema,' ')" />
				</xsl:call-template>

	
			</xsl:if>

		</xsl:if>

</xsl:template>

<xsl:template match="interface" mode="interface-schemas-x" >
	<xsl:param name="done" />
	<xsl:if test="not(contains($done,@schema))" >
		<x><xsl:value-of select="@schema" /></x> 
	</xsl:if>
</xsl:template>

</xsl:stylesheet>
