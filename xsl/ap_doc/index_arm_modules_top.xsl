<?xml version="1.0" encoding="utf-8"?>
<!-- <?xml-stylesheet type="text/xsl" href="../../xsl/document_xsl.xsl" ?>
-->
<!--
$Id: index_arm_modules_top.xsl,v 1.5 2003/05/24 10:21:55 nigelshaw Exp $
  Author:  Nigel Shaw, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: 
  	1) To display a matrix showing which entities are included 
	(either directly or via inheritance) in extensible select types
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		xmlns:exslt="http://exslt.org/common"
                version="1.0">


<!--	<xsl:import href="../../xsl/express.xsl"/>
-->

  <xsl:import href="../../xsl/common.xsl"/>


  <xsl:output method="html"/>

  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>
  
  <xsl:variable name="selected_ap" select="/application_protocol/@directory"/>

  <xsl:variable name="ap_file" 
	    select="concat('../../data/application_protocols/',$selected_ap,'/application_protocol.xml')"/>
	    
  <xsl:variable name="ap_node"
	    select="document($ap_file)"/>

  <xsl:variable name="ap_top_module"
	    select="$ap_node/application_protocol/@module_name"/>




  <xsl:template match="/" >
    <HTML>
    <head>
<!--      <link rel="stylesheet" type="text/css" 
        href="../../../../nav/css/developer.css"/>
-->
      <title>
        <xsl:value-of select="concat('AP Index for ',$selected_ap)"/>
      </title>

    </head>
  <body>

  	<A HREF="frame_index.xml" TARGET="toc" >Back to main index</A>
	<br/>

	<xsl:variable name="top_module_file" 
	    select="concat('../../data/modules/',$ap_top_module,'/arm.xml')"/>

	<xsl:variable name="top_module_node"
	    select="document($top_module_file)/express"/>

	<xsl:variable name="schema-name"
	    select="$top_module_node//schema/@name"/>

	<xsl:variable name="arm_schemas" >
		<xsl:call-template name="depends-on-recurse-no-list-x">
			<xsl:with-param name="todo" select="concat(' ',$schema-name,' ')" />
			<xsl:with-param name="done" select="concat(' ',$schema-name,' ')" />
		</xsl:call-template> 
	</xsl:variable>


      <xsl:choose>
	<xsl:when test="function-available('msxsl:node-set')">


		<xsl:variable name="schemas-node-set" select="msxsl:node-set($arm_schemas)" />

		<xsl:variable name="dep-schemas3">
			<xsl:for-each select="$schemas-node-set//x" >
				<xsl:sort /> 
				<xsl:copy-of select="document(.)" />
			</xsl:for-each>
		</xsl:variable>

		<xsl:variable name="dep-schemas" 
		  	select="msxsl:node-set($dep-schemas3)" />
				

			<xsl:call-template name="modules_index" >
				<xsl:with-param name="this-schema" select="$top_module_node" />
				<xsl:with-param name="called-schemas" select="$dep-schemas" />
			</xsl:call-template>

	</xsl:when>


	<xsl:when test="function-available('exslt:node-set')">

		  <xsl:variable name="schemas-node-set2">
		      <xsl:choose>
			<xsl:when test="2 > string-length($arm_schemas)" >
		        </xsl:when>
		        <xsl:otherwise>
		          <xsl:copy-of select="exslt:node-set($arm_schemas)"/>
		        </xsl:otherwise>
		      </xsl:choose>
		    </xsl:variable>

		<xsl:variable name="dep-schemas" select="document(exslt:node-set($schemas-node-set2)//x)" />

			<xsl:call-template name="modules_index" >
				<xsl:with-param name="this-schema" select="$top_module_node" />
				<xsl:with-param name="called-schemas" select="$dep-schemas" />
			</xsl:call-template>



			</xsl:when>

			</xsl:choose>
  
  </body>
</HTML>
</xsl:template>



<xsl:template name="modules_index" >
	<xsl:param name="this-schema" />
	<xsl:param name="called-schemas" />

	<h3>ARM Modules</h3>
	
<!--	<TABLE width="}">
		<TR >
			<TD> -->

	<xsl:variable name="schema-names">
			<xsl:for-each select="$called-schemas//schema" >
				<xsl:value-of select="concat(' ',@name,' ')" />
			</xsl:for-each>
		</xsl:variable>

			<xsl:call-template name="alph-index">
				<xsl:with-param name="names" select="$schema-names" />
				<xsl:with-param name="file" select="concat('index_arm_modules_inner',$FILE_EXT)" />
				<xsl:with-param name="internal-link-root" select="'letter'" />
			</xsl:call-template>
			<br/>
			<hr/>

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
						<xsl:when test="function-available('exslt:node-set')">../../../</xsl:when>
					<xsl:otherwise>../../../../../</xsl:otherwise>
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
							<xsl:value-of select="concat($dir,'stepmod/data/modules/',$mod,'/arm.xml ')" />
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

<xsl:template match="interface" mode="interface-schemas" >
	<xsl:param name="done" />
	<xsl:if test="not(contains($done,@schema))" >
		<xsl:value-of select="concat(' ',@schema,' ')" /> 
	</xsl:if>
</xsl:template>

<xsl:template name="alph-index" >
	<xsl:param name="names" />
	<xsl:param name="file" />
	<xsl:param name="internal-link-root" />

		<xsl:variable name="name-list" select="translate($names, $LOWER,$UPPER)" />

			<xsl:if test="contains($name-list,' A')" >
				<A HREF="{$file}#{$internal-link-root}-a" target="toc_inner" >A</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' B')" >
				<A HREF="{$file}#{$internal-link-root}-b" target="toc_inner" >B</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' C')" >
				<A HREF="{$file}#{$internal-link-root}-c" target="toc_inner" >C</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' D')" >
				<A HREF="{$file}#{$internal-link-root}-d" target="toc_inner" >D</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' E')" >
				<A HREF="{$file}#{$internal-link-root}-e" target="toc_inner" >E</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' F')" >
				<A HREF="{$file}#{$internal-link-root}-f" target="toc_inner" >F</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' G')" >
				<A HREF="{$file}#{$internal-link-root}-g" target="toc_inner" >G</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' H')" >
				<A HREF="{$file}#{$internal-link-root}-h" target="toc_inner" >H</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' I')" >
				<A HREF="{$file}#{$internal-link-root}-i" target="toc_inner" >I</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' J')" >
				<A HREF="{$file}#{$internal-link-root}-j" target="toc_inner" >J</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' K')" >
				<A HREF="{$file}#{$internal-link-root}-k" target="toc_inner" >K</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' L')" >
				<A HREF="{$file}#{$internal-link-root}-l" target="toc_inner" >L</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' M')" >
				<A HREF="{$file}#{$internal-link-root}-m" target="toc_inner" >M</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' N')" >
				<A HREF="{$file}#{$internal-link-root}-n" target="toc_inner" >N</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' O')" >
				<A HREF="{$file}#{$internal-link-root}-o" target="toc_inner" >O</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' P')" >
				<A HREF="{$file}#{$internal-link-root}-p" target="toc_inner" >P</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' Q')" >
				<A HREF="{$file}#{$internal-link-root}-q" target="toc_inner" >Q</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' R')" >
				<A HREF="{$file}#{$internal-link-root}-r" target="toc_inner" >R</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' S')" >
				<A HREF="{$file}#{$internal-link-root}-s" target="toc_inner" >S</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' T')" >
				<A HREF="{$file}#{$internal-link-root}-t" target="toc_inner" >T</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' U')" >
				<A HREF="{$file}#{$internal-link-root}-u" target="toc_inner" >U</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' V')" >
				<A HREF="{$file}#{$internal-link-root}-v" target="toc_inner" >V</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' W')" >
				<A HREF="{$file}#{$internal-link-root}-w" target="toc_inner" >W</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' X')" >
				<A HREF="{$file}#{$internal-link-root}-x" target="toc_inner" >X</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' Y')" >
				<A HREF="{$file}#{$internal-link-root}-y" target="toc_inner" >Y</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' Z')" >
				<A HREF="{$file}#{$internal-link-root}-z" target="toc_inner" >Z</A>
				<xsl:text> </xsl:text>
			</xsl:if>
</xsl:template>


</xsl:stylesheet>
