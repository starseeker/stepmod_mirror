<?xml version="1.0" encoding="utf-8"?>
<!-- <?xml-stylesheet type="text/xsl" href="../../xsl/document_xsl.xsl" ?>
-->
<!--
$Id: index_mim_modules_top.xsl,v 1.4 2003/06/16 08:23:38 nigelshaw Exp $
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

  	<A HREF="frame_index{$FILE_EXT}" TARGET="toc" >Back to main index</A>
	<br/>

	<xsl:variable name="top_module_file" 
	    select="concat('../../data/modules/',$ap_top_module,'/mim.xml')"/>

	<xsl:variable name="top_module_node"
	    select="document($top_module_file)/express"/>

	<xsl:variable name="schema-name"
	    select="$top_module_node//schema/@name"/>

	<xsl:variable name="mim_schemas" >
		<xsl:call-template name="depends-on-recurse-mim-x">
			<xsl:with-param name="todo" select="concat(' ',$schema-name,' ')" />
			<xsl:with-param name="done" select="' '" />
		</xsl:call-template> 
	</xsl:variable>


      <xsl:choose>
	<xsl:when test="function-available('msxsl:node-set')">


		<xsl:variable name="schemas-node-set" select="msxsl:node-set($mim_schemas)" />

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
			<xsl:when test="2 > string-length($mim_schemas)" >
		        </xsl:when>
		        <xsl:otherwise>
		          <xsl:copy-of select="exslt:node-set($mim_schemas)"/>
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

	<h3>MIM Modules</h3>
	

	<xsl:variable name="schema-names">
			<xsl:for-each select="$called-schemas//schema[contains(@name,'_mim')]" >
				<xsl:value-of select="concat(' ',@name,' ')" />
			</xsl:for-each>
		</xsl:variable>

			<xsl:call-template name="alph-index">
				<xsl:with-param name="names" select="$schema-names" />
				<xsl:with-param name="file" select="concat('index_mim_modules_inner',$FILE_EXT)" />
				<xsl:with-param name="internal-link-root" select="'letter'" />
			</xsl:call-template>
			<br/>
			<hr/>

</xsl:template>


<xsl:template match="schema" mode="module-index" >

		<xsl:variable name="mod-name" select="substring-before(@name,'_mim')" />

		<xsl:variable name="mod-dir" select="concat($STEPMOD_DATA_MODULES,$mod-name)" />

		
		<A HREF="{$mod-dir}/sys/1_scope{$FILE_EXT}" ><xsl:value-of select="$mod-name" /></A>
			<br/>
		
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
			<xsl:when test="function-available('exslt:node-set')" >
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
