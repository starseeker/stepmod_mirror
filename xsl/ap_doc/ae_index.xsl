<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="document_xsl.xsl" ?>
<!--
$Id: ae_index.xsl,v 1.3 2003/07/28 07:31:54 robbod Exp $
-->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
	xmlns:saxon="http://icl.com/saxon" 
        exclude-result-prefixes="msxsl exslt"
	version="1.0"
>

	<xsl:import href="express.xsl"/>
	<xsl:import href="express_link.xsl"/>
	<xsl:output method="html"/>
	
	<xsl:variable name="relative_root" select="'../../../../'"/>
	<xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
	<xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>
	<xsl:variable name="mod_file" 
				select="concat('../../data/modules/',/application_protocol[1]/@name,'/module.xml')"/>
	<xsl:variable name="module_node" select="document($mod_file)"/>
	
	
	<xsl:template match="/" mode="index">
		<html>
			<xsl:apply-templates select="./express"/>
		</html>
	</xsl:template>

  	<xsl:template match="express">
	<xsl:variable name="ap_name" select="substring-before(translate(./schema/@name,$UPPER,$LOWER),'_arm')"/>
    	<h3>
		<xsl:value-of select="concat('Index of ARM long form data types and source schemas for ', $ap_name, ' Application Protocol')"/>
	</h3>
	<xsl:variable name="arm_file" select="concat('../../data/modules/', $ap_name, '/arm.xml')"/>
	<xsl:variable name="arm_node" select="document($arm_file)/express"/>
	<xsl:variable name="schema-name" select="$arm_node//schema/@name"/>
		
	<xsl:variable name="schemas" >
		<xsl:call-template name="depends-on-recurse-no-list-x">
			<xsl:with-param name="todo" select="concat(' ',$schema-name,' ')" />
			<xsl:with-param name="done" select="concat(' ',$schema-name,' ')" />
		</xsl:call-template>
	</xsl:variable>
	
	<!-- small>
		NOTE: The index below include all entities referenced by USE FROMs, but does not include entities referenced by extensible selects. 
	</small -->
	
	<br/>
	<br/>
	
	<blockquote>
		<xsl:choose>
			<xsl:when test="function-available('msxsl:node-set')">
				<xsl:variable name="schemas-node-set" select="msxsl:node-set($schemas)"/>
				<xsl:variable name="dep-schemas3">
					<xsl:for-each select="$schemas-node-set//x">
						<xsl:copy-of select="document(.)"/>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="dep-schemas" select="msxsl:node-set($dep-schemas3)" />
				<h4>schemas</h4>
				
                          <xsl:apply-templates select="$dep-schemas//schema" mode="link">
					<xsl:sort select="@name"/>
				</xsl:apply-templates>

				<!-- xsl:apply-templates select="$arm_node//constant | $dep-schemas//constant" mode="code">
					
				</xsl:apply-templates -->
				
				<br/><h4>types</h4>
				<xsl:apply-templates select="$arm_node//type | $dep-schemas//type " mode="link">
					<xsl:sort select="@name"/>
				</xsl:apply-templates>
			
				<br/><h4>entities</h4>
				<xsl:apply-templates select="$arm_node//entity | $dep-schemas//entity" mode="link">
					<xsl:sort select="@name"/>
				</xsl:apply-templates>

				<!-- xsl:apply-templates select="$arm_node//entity | $dep-schemas//entity " mode="code">
					<xsl:sort select="@name"/>
				</xsl:apply-templates -->

				<!-- xsl:apply-templates select="$arm_node//subtype.constraint | $dep-schemas//subtype.constraint" mode="code">
					<xsl:sort select="@name"/>
				</xsl:apply-templates -->
				
				<!-- xsl:apply-templates select="$arm_node//rule | $dep-schemas//rule" mode="code">
					<xsl:sort select="@name"/>
				</xsl:apply-templates -->
				
				<!-- xsl:apply-templates select="$arm_node//function | $dep-schemas//function" mode="code">
					<xsl:sort select="@name"/>
				</xsl:apply-templates>
				
				<xsl:apply-templates select="$arm_node//procedure | $dep-schemas//procedure" mode="code">
					<xsl:sort select="@name"/>
				</xsl:apply-templates -->
			</xsl:when>
			
			<xsl:when test="function-available('saxon:node-set')">
				<xsl:variable name="schemas-node-set2">
					<xsl:choose>
						<xsl:when test="2 > string-length($schemas)">
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of select="saxon:node-set($schemas)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:variable name="dep-schemas" select="document($schemas-node-set2//x)"/>
				<xsl:apply-templates select="$arm_node//constant | $dep-schemas//constant" mode="code">
					<xsl:sort select="@name"/>
				</xsl:apply-templates>
				
				<xsl:apply-templates select="$arm_node//type | $dep-schemas//type" mode="code">
					<xsl:sort select="@name"/>
				</xsl:apply-templates>

			<xsl:apply-templates select="$arm_node//entity | $dep-schemas//entity " mode="code">
				<xsl:sort select="@name" />
			</xsl:apply-templates>

			<xsl:apply-templates select="$arm_node//subtype.constraint | $dep-schemas//subtype.constraint " 
						mode="code">
				<xsl:sort select="@name" />
			</xsl:apply-templates>

			<xsl:apply-templates select="$arm_node//rule | $dep-schemas//rule " 
						mode="code">
				<xsl:sort select="@name" />
			</xsl:apply-templates>

			<xsl:apply-templates select="$arm_node//function | $dep-schemas//function " 
						mode="code">
				<xsl:sort select="@name" />
			</xsl:apply-templates>

			<xsl:apply-templates select="$arm_node//procedure | $dep-schemas//procedure " 
						mode="code">
				<xsl:sort select="@name" />
			</xsl:apply-templates>


		</xsl:when>
		</xsl:choose>

	</blockquote>
	
	<br/>
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


<xsl:template match="interface" mode="interface-schemas">
  <xsl:param name="done"/>
  <xsl:variable name="schema" select="concat(' ',@schema,' ')"/>
  <xsl:if test="not(contains($done,$schema))" >
    <xsl:value-of select="$schema"/> 
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
				<xsl:variable name="mod" 
				select="substring-before(translate($this-schema,$UPPER,$LOWER),'_arm')" />
<!-- notes:
msxml needs addresses relative to the original xml file
saxon needs addresses relative to the xsl file.
msxml Only seems to pick up on first file - treating parameter to document() differently from saxon.
-->

				<xsl:variable name="dir" >
					<xsl:choose>
						<xsl:when test="function-available('saxon:node-set')">../../</xsl:when>
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
							<xsl:value-of select="concat($dir,'data/modules/',$mod,'/arm.xml ')" />
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
  <xsl:param name="done"/>
  <xsl:variable name="schema" select="concat(' ',@schema,' ')"/>
  <xsl:if test="not(contains($done,$schema))" >
    <x><xsl:value-of select="@schema" /></x> 
  </xsl:if>
</xsl:template>

<!-- ROB added link to schemas 
     Note - this relies on global variable relative_root
-->
<xsl:template match="schema" mode="link">
  <xsl:call-template name="link_schema">
    <xsl:with-param 
      name="schema_name" 
      select="@name"/>
    <xsl:with-param name="clause" select="'section'"/>
  </xsl:call-template><br/>
</xsl:template>

	<xsl:template match="entity" mode="link">
		<xsl:call-template name="link_object">
			<xsl:with-param name="object_name" select="@name"/>
			<xsl:with-param name="object_used_in_schema_name" select="../../@name"/>
			<xsl:with-param name="clause" select="'section'"/>
		</xsl:call-template>
		<br/>
	</xsl:template>

</xsl:stylesheet>
