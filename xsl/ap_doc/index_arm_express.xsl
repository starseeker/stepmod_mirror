<?xml version="1.0" encoding="utf-8"?>
<!-- <?xml-stylesheet type="text/xsl" href="../../xsl/document_xsl.xsl" ?>
-->
<!--
$Id: index_arm_express.xsl,v 1.2 2003/05/22 13:26:35 nigelshaw Exp $
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

  <xsl:variable name="iframe-width"
	    select="170"/>



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
	<B>ARM EXPRESS index</B>

  	<A HREF="frame_index.xml" TARGET="toc" >[main index]</A>
	<br/>

	<xsl:variable name="top_module_file" 
	    select="concat('../../data/modules/',$selected_ap,'/arm.xml')"/>

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
				

			<xsl:call-template name="arm_express_index" >
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

			<xsl:call-template name="arm_express_index" >
				<xsl:with-param name="this-schema" select="$top_module_node" />
				<xsl:with-param name="called-schemas" select="$dep-schemas" />
			</xsl:call-template>



			</xsl:when>

			</xsl:choose>
  
  </body>
</HTML>
</xsl:template>



<xsl:template name="arm_express_index" >
	<xsl:param name="this-schema" />
	<xsl:param name="called-schemas" />


	
	<TABLE width="{$iframe-width}">
		<TR >
			<TD>
<!--	<xsl:for-each select="$called-schemas//entity"  >
		<xsl:sort select="@name" /> 
		<xsl:variable name="first-letter" select="substring(@name,1,1)" />
		<xsl:if test="not(/@name,1,1))" >
			<A HREF="index_arm_express_inner.xml#letter-{$first-letter}" target="index" >
			<xsl:value-of select="$first-letter" /></A>
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:for-each>
-->

		<xsl:variable name="const-names">
			<xsl:for-each select="$called-schemas//constant" >
				<xsl:value-of select="concat(' ',@name,' ')" />
			</xsl:for-each>
		</xsl:variable>

		<xsl:if test="string-length($const-names) > 1" >
			<A HREF="index_arm_express_inner.xml#constants" TARGET="index" ><B>Constants:</B></A>
			<xsl:text> </xsl:text>
			<xsl:call-template name="alph-index">
				<xsl:with-param name="names" select="$const-names" />
				<xsl:with-param name="file" select="'index_arm_express_inner.xml'" />
				<xsl:with-param name="internal-link-root" select="'constant-letter'" />
			</xsl:call-template>
			<br/>
		</xsl:if>


		<xsl:variable name="type-names">
			<xsl:for-each select="$called-schemas//type" >
				<xsl:value-of select="concat(' ',@name,' ')" />
			</xsl:for-each>
		</xsl:variable>

		<xsl:if test="string-length($type-names) > 1" >
			<A HREF="index_arm_express_inner.xml#types" TARGET="index" ><B>Types:</B></A>
			<xsl:text> </xsl:text>
			<xsl:call-template name="alph-index">
				<xsl:with-param name="names" select="$type-names" />
				<xsl:with-param name="file" select="'index_arm_express_inner.xml'" />
				<xsl:with-param name="internal-link-root" select="'type-letter'" />
			</xsl:call-template>
			<br/>
		</xsl:if>

		<xsl:variable name="ent-names">
			<xsl:for-each select="$called-schemas//entity" >
				<xsl:value-of select="concat(' ',@name,' ')" />
			</xsl:for-each>
		</xsl:variable>

		<xsl:if test="string-length($ent-names) > 1" >
			<A HREF="index_arm_express_inner.xml#entities" TARGET="index" ><B>Entities:</B></A>
			<xsl:text> </xsl:text>
			<xsl:call-template name="alph-index">
				<xsl:with-param name="names" select="$ent-names" />
				<xsl:with-param name="file" select="'index_arm_express_inner.xml'" />
				<xsl:with-param name="internal-link-root" select="'entity-letter'" />
			</xsl:call-template>
			<br/>
		</xsl:if>

		<xsl:variable name="fun-names">
			<xsl:for-each select="$called-schemas//function" >
				<xsl:value-of select="concat(' ',@name,' ')" />
			</xsl:for-each>
		</xsl:variable>

		<xsl:if test="string-length($fun-names) > 1" >
			<A HREF="index_arm_express_inner.xml#functions" TARGET="index" ><B>Functions:</B></A>
			<xsl:text> </xsl:text>
			<xsl:call-template name="alph-index">
				<xsl:with-param name="names" select="$fun-names" />
				<xsl:with-param name="file" select="'index_arm_express_inner.xml'" />
				<xsl:with-param name="internal-link-root" select="'function-letter'" />
			</xsl:call-template>
			<br/>
		</xsl:if>

		<xsl:variable name="proc-names">
			<xsl:for-each select="$called-schemas//procedure" >
				<xsl:value-of select="concat(' ',@name,' ')" />
			</xsl:for-each>
		</xsl:variable>

		<xsl:if test="string-length($proc-names) > 1" >
			<A HREF="index_arm_express_inner.xml#procedures" TARGET="index" ><B>Procedures:</B></A>
			<xsl:text> </xsl:text>
			<xsl:call-template name="alph-index">
				<xsl:with-param name="names" select="$proc-names" />
				<xsl:with-param name="file" select="'index_arm_express_inner.xml'" />
				<xsl:with-param name="internal-link-root" select="'procedures-letter'" />
			</xsl:call-template>
			<br/>
		</xsl:if>


		</TD>
			
		</TR>
	</TABLE>

	<br/>
	<IFRAME name="index" src="index_arm_express_inner.xml" height="340" width="{$iframe-width}"
             scrolling="auto" frameborder="1">
	  [Your user agent does not support frames or is currently configured
	  not to display frames. The index you chose is 
	  <A href="index_arm_express_inner.xml">here.</A>]
	</IFRAME>

</xsl:template>


<xsl:template match="schema" mode="module-index" >

		<xsl:variable name="mod-name" select="substring-before(@name,'_arm')" />

		<xsl:variable name="mod-dir" select="concat('../../../stepmod/data/modules/',$mod-name)" />

		
		<A HREF="{$mod-dir}/sys/1_scope.{$FILE_EXT}" ><xsl:value-of select="$mod-name" /></A>
			<br/>
		
</xsl:template>


<xsl:template match="entity" mode="module-index" >

		<xsl:variable name="mod-name" select="substring-before(../@name,'_arm')" />

		<xsl:variable name="mod-dir" select="concat('../../../stepmod/data/modules/',$mod-name)" />

		
		<A HREF="{$mod-dir}/sys/sect_4_info_reqs.{$FILE_EXT}#{../@name}.{@name}" >
		<xsl:value-of select="@name" /></A>
			<br/>
		
</xsl:template>

<xsl:template match="type" mode="module-index" >

		<xsl:variable name="mod-name" select="substring-before(../@name,'_arm')" />

		<xsl:variable name="mod-dir" select="concat('../../../stepmod/data/modules/',$mod-name)" />

		
		<A HREF="{$mod-dir}/sys/sect_4_info_reqs.{$FILE_EXT}#{../@name}.{@name}" >
		<xsl:value-of select="@name" /></A>
			<br/>
		
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
						<xsl:when test="function-available('exslt:node-set')">../../../../</xsl:when>
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
				<A HREF="{$file}#{$internal-link-root}-A" target="index" >A</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' B')" >
				<A HREF="{$file}#{$internal-link-root}-B" target="index" >B</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' C')" >
				<A HREF="{$file}#{$internal-link-root}-C" target="index" >C</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' D')" >
				<A HREF="{$file}#{$internal-link-root}-D" target="index" >D</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' E')" >
				<A HREF="{$file}#{$internal-link-root}-E" target="index" >E</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' F')" >
				<A HREF="{$file}#{$internal-link-root}-F" target="index" >F</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' G')" >
				<A HREF="{$file}#{$internal-link-root}-G" target="index" >G</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' H')" >
				<A HREF="{$file}#{$internal-link-root}-H" target="index" >H</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' I')" >
				<A HREF="{$file}#{$internal-link-root}-I" target="index" >I</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' J')" >
				<A HREF="{$file}#{$internal-link-root}-J" target="index" >J</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' K')" >
				<A HREF="{$file}#{$internal-link-root}-K" target="index" >K</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' L')" >
				<A HREF="{$file}#{$internal-link-root}-L" target="index" >L</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' M')" >
				<A HREF="{$file}#{$internal-link-root}-M" target="index" >M</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' N')" >
				<A HREF="{$file}#{$internal-link-root}-N" target="index" >N</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' O')" >
				<A HREF="{$file}#{$internal-link-root}-O" target="index" >O</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' P')" >
				<A HREF="{$file}#{$internal-link-root}-P" target="index" >P</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' Q')" >
				<A HREF="{$file}#{$internal-link-root}-Q" target="index" >Q</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' R')" >
				<A HREF="{$file}#{$internal-link-root}-R" target="index" >R</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' S')" >
				<A HREF="{$file}#{$internal-link-root}-S" target="index" >S</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' T')" >
				<A HREF="{$file}#{$internal-link-root}-T" target="index" >T</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' U')" >
				<A HREF="{$file}#{$internal-link-root}-U" target="index" >U</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' V')" >
				<A HREF="{$file}#{$internal-link-root}-V" target="index" >V</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' W')" >
				<A HREF="{$file}#{$internal-link-root}-W" target="index" >W</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' X')" >
				<A HREF="{$file}#{$internal-link-root}-X" target="index" >X</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' Y')" >
				<A HREF="{$file}#{$internal-link-root}-Y" target="index" >Y</A>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="contains($name-list,' Z')" >
				<A HREF="{$file}#{$internal-link-root}-Z" target="index" >Z</A>
				<xsl:text> </xsl:text>
			</xsl:if>
</xsl:template>



</xsl:stylesheet>
