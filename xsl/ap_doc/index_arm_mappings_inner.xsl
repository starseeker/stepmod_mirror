<?xml version="1.0" encoding="utf-8"?>
<!-- <?xml-stylesheet type="text/xsl" href="../../xsl/document_xsl.xsl" ?>
-->
<!--
$Id: index_arm_mappings_inner.xsl,v 1.3 2003/05/23 14:50:13 nigelshaw Exp $
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


  <xsl:variable name="selected_ap" select="/application_protocol/@directory"/>

  <xsl:output method="html"/>

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
   <small>

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
				<xsl:sort /> <!-- added sort here which is not in the saxon version below -->
				<xsl:copy-of select="document(.)" />
			</xsl:for-each> -->
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
  </small>
  </body>
</HTML>
</xsl:template>



<xsl:template name="modules_index" >
	<xsl:param name="this-schema" />
	<xsl:param name="called-schemas" />

<!--	<xsl:apply-templates select="$called-schemas//schema" mode="module-index" >
		<xsl:sort select="@name" />		
	</xsl:apply-templates>
-->
		<xsl:call-template name="alph-list">
			<xsl:with-param name="items" select="$called-schemas//entity" />
			<xsl:with-param name="internal-link-root" select="'letter'" />
		</xsl:call-template>


</xsl:template>


<xsl:template match="entity" mode="module-index" >

		<xsl:variable name="mod-name" select="translate(substring-before(../@name,'_arm'),$UPPER,$LOWER)" />

		<xsl:variable name="mod-dir" select="concat('../../../../../stepmod/data/modules/',$mod-name)" />
		<xsl:variable name="lc-ent" select="translate(@name,$UPPER,$LOWER)"/>

		<br/>
		<A HREF="{$mod-dir}/sys/5_mapping{$FILE_EXT}#aeentity{$lc-ent}" TARGET="content">
			<xsl:value-of select="@name"/>
		</A>
		<br/>
		<xsl:apply-templates select="explicit" mode="module-index" />

		
		
</xsl:template>

<xsl:template match="explicit" mode="module-index" >

		<xsl:variable name="mod-name" select="translate(substring-before(../../@name,'_arm'),$UPPER,$LOWER)" />

		<xsl:variable name="mod-dir" select="concat('../../../../../stepmod/data/modules/',$mod-name)" />
		<xsl:variable name="lc-ent" select="translate(../@name,$UPPER,$LOWER)"/>

		&#160;&#160;<A HREF="{$mod-dir}/sys/5_mapping{$FILE_EXT}#aeentity{$lc-ent}aaattribute{@name}" TARGET="content">
		<xsl:value-of select="concat(' ',../@name,'.',@name)"/>
		</A>
		<br/>

<!-- if attribute points to an extensible select then may have further mappings in other modules -->
		
		<xsl:if test="./typename[select]" >
			&#160;&#160; SELECT TYPE HERE!
			<br/>
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

<xsl:template name="alph-list" >
	<xsl:param name="items" />
	<xsl:param name="internal-link-root" />

		<xsl:variable name="name-list" >
			<xsl:for-each select="$items">
				<xsl:value-of select="concat(' ',translate(@name, $LOWER,$UPPER),' ')" />
			</xsl:for-each>
		</xsl:variable>

			<xsl:if test="contains($name-list,' A')" >
				<br/>
				<A NAME="{$internal-link-root}-a"  ><B>A</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='A']" mode="module-index" >
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' B')" >
				<br/>
				<A NAME="{$internal-link-root}-b"  ><B>B</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='B']" mode="module-index" >
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' C')" >
				<br/>
				<A NAME="{$internal-link-root}-c"  ><B>C</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='C']" mode="module-index" >
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' D')" >
				<br/>
				<A NAME="{$internal-link-root}-d"  ><B>D</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='D']" mode="module-index" >
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' E')" >
				<br/>
				<A NAME="{$internal-link-root}-e"  ><B>E</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='E']" mode="module-index" >
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' F')" >
				<br/>
				<A NAME="{$internal-link-root}-f"  ><B>F</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='F']" mode="module-index" >
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' G')" >
				<br/>
				<A NAME="{$internal-link-root}-g"  ><B>G</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='G']" mode="module-index" >
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' H')" >
				<br/>
				<A NAME="{$internal-link-root}-h"  ><B>H</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='H']" mode="module-index" >
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' I')" >
				<br/>
				<A NAME="{$internal-link-root}-i"  ><B>I</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='I']" mode="module-index" >
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' J')" >
				<br/>
				<A NAME="{$internal-link-root}-j"  ><B>J</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='J']" mode="module-index" >
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' K')" >
				<br/>
				<A NAME="{$internal-link-root}-k"  ><B>K</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='K']" mode="module-index" >
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' L')" >
				<br/>
				<A NAME="{$internal-link-root}-l"  ><B>L</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='L']" mode="module-index" >
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' M')" >
				<br/>
				<A NAME="{$internal-link-root}-m"  ><B>M</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='M']" mode="module-index" >
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' N')" >
				<br/>
				<A NAME="{$internal-link-root}-n"  ><B>N</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='N']" mode="module-index" >
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' O')" >
				<br/>
				<A NAME="{$internal-link-root}-o"  ><B>O</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='O']" mode="module-index" >
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' P')" >
				<br/>
				<A NAME="{$internal-link-root}-p"  ><B>P</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='P']" mode="module-index" >
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' Q')" >
				<br/>
				<A NAME="{$internal-link-root}-q"  ><B>Q</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='Q']" mode="module-index" >
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' R')" >
				<br/>
				<A NAME="{$internal-link-root}-r"  ><B>R</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='R']" mode="module-index" >
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' S')" >
				<br/>
				<A NAME="{$internal-link-root}-s"  ><B>S</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='S']" mode="module-index" >
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' T')" >
				<br/>
				<A NAME="{$internal-link-root}-t"  ><B>T</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='T']" mode="module-index" >
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' U')" >
				<br/>
				<A NAME="{$internal-link-root}-u"  ><B>U</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='U']" mode="module-index" >
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' V')" >
			
				<br/>
				<A NAME="{$internal-link-root}-v"  ><B>V</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='V']" mode="module-index" >
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' W')" >
				<br/>
				<A NAME="{$internal-link-root}-w"  ><B>W</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='W']" mode="module-index" >
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' X')" >
				<br/>
				<A NAME="{$internal-link-root}-x"  ><B>X</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='X']" mode="module-index" >
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' Y')" >
				<br/>
				<A NAME="{$internal-link-root}-y"  ><B>Y</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='Y']" mode="module-index" >
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' Z')" >
				<br/>
				<A NAME="{$internal-link-root}-z"  ><B>Z</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='Z']" mode="module-index" >
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
</xsl:template>



</xsl:stylesheet>
