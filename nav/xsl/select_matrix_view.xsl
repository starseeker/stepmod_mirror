<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="../../xsl/document_xsl.xsl" ?>
<!--
$Id: select_matrix_view.xsl,v 1.6 2003/11/25 08:35:14 robbod Exp $
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

	<xsl:import href="../../xsl/express.xsl"/>

<!--  <xsl:import href="../../xsl/common.xsl"/>
-->


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
        <xsl:value-of select="concat('ARM Select types matrix for ',@directory)"/>
      </title>

    </head>
  <body>
  <H1> <xsl:value-of select="concat('ARM Select types matrix for ',@directory)"/>
  </H1>

  <p>
	This presents one or more tables showing which entities are included in each extensible select. <br/>
	"Y" indicates that the entity is directly referenced by a select type declaration.  <br/>
	"S" indicates that the entity is a subtype of an entity that is directly referenced by a select type declaration.
  </p>
  <p>
  	The tables feature a maximum of 200 entities. If there are more than 200 entities a further table will appear. 
	This is to avoid hitting limits on numbers of columns in pasting into spreadsheets.
  </p>

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
				

			<xsl:call-template name="select-matrix" >
				<xsl:with-param name="this-schema" select="$arm_node" />
				<xsl:with-param name="called-schemas" select="$dep-schemas" />
			</xsl:call-template>

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

			<xsl:call-template name="select-matrix" >
				<xsl:with-param name="this-schema" select="$arm_node" />
				<xsl:with-param name="called-schemas" select="$dep-schemas" />
			</xsl:call-template>



			</xsl:when>

			</xsl:choose>

  
  </body>
</HTML>
</xsl:template>



<xsl:template name="select-matrix" >
	<xsl:param name="this-schema" />
	<xsl:param name="called-schemas" />
	<xsl:param name="start" select="1" />


	<xsl:variable name="all-entities" select="$this-schema//entity | $called-schemas//entity" />

	<xsl:variable name="this-pass-entities" 
		select="$all-entities[(position() - $start + 1) > 0 and 201 > (position()-$start + 1) ]" />
          <br/>
  <TABLE border="3">
  
	<!-- output the header row -->
	<THEAD>
	<TR>
		<TD>.</TD> <!-- empty top left corner -->

			<xsl:for-each select="$this-pass-entities" >
				<xsl:sort select="@name" />
				
				<TD>
				<xsl:value-of select="@name" />
				</TD>

			</xsl:for-each>

	</TR>
	</THEAD>

	<TBODY>

			<xsl:for-each select="$this-schema//type[select/@extensible='YES'][not(select/@basedon)]
				| $called-schemas//type[select/@extensible='YES'][not(select/@basedon)]" >
				<xsl:sort select="@name" />
				<TR>

				<TD>
				<xsl:value-of select="@name" />
				</TD>


					<xsl:variable name="sel-items">
						<xsl:apply-templates select="." mode="basedon">
							<xsl:with-param name="this-schema" select="$this-schema"/>
							<xsl:with-param name="called-schemas" select="$called-schemas" />
							<xsl:with-param name="done" select="' '" />
						</xsl:apply-templates>
					</xsl:variable>

					<xsl:variable name="direct-list" select="concat(' ',$sel-items,' ')" />

					<xsl:variable name="subs">
						<xsl:apply-templates select="$this-schema//entity[
						contains($sel-items, concat(' ',@name,' '))]
							| $called-schemas//entity[
						contains($sel-items, concat(' ',@name,' '))]"
						mode="subtypes">
							<xsl:with-param name="this-schema" select="$this-schema"/>
							<xsl:with-param name="called-schemas" select="$called-schemas" />
							<xsl:with-param name="done" select="' '" />
							<xsl:with-param name="output" select="concat(' ',$sel-items,' ')" />
						</xsl:apply-templates>
					</xsl:variable>
					
					<xsl:variable name="subs-list" select="concat(' ',$subs,' ')" />


				<xsl:for-each select="$this-pass-entities" >
					<xsl:sort select="@name" />
					<xsl:variable name="this-ent" select="concat(' ',@name,' ')" />
					<TD border="3">
					<xsl:choose>
						<xsl:when test="contains($direct-list,$this-ent)">
							Y
						</xsl:when >
						<xsl:when test="contains($subs-list,$this-ent)">
							S
						</xsl:when >
						<xsl:otherwise>.
						</xsl:otherwise>
					</xsl:choose>				
					</TD>
				</xsl:for-each>
				</TR>
			</xsl:for-each>

	</TBODY>
  </TABLE>
  <br/>

	<xsl:if test="count($this-schema//entity | $called-schemas//entity) > $start + 200" >

			<xsl:call-template name="select-matrix" >
				<xsl:with-param name="this-schema" select="$this-schema" />
				<xsl:with-param name="called-schemas" select="$called-schemas" />
				<xsl:with-param name="start" select="$start + 200" />
			</xsl:call-template>

	</xsl:if>
  
</xsl:template>

<!--

<xsl:template match="type" mode="basedon">
	<xsl:param name="this-schema" />
	<xsl:param name="called-schemas" />
	<xsl:param name="done" select="' '" />

	<xsl:variable name="this_select" select="@name" />

	<xsl:if test="not(contains($done, concat(' ',@name,' ')))" >
	
		<xsl:if test="select/@selectitems" >
			<xsl:value-of select="concat(' ',select/@selectitems)" /> 
			<br/>
		</xsl:if>

		<xsl:apply-templates select="$this-schema//type[select/@basedon=$this_select] 
							| $called-schemas//type[select/@basedon=$this_select]" 
						mode="basedon">
			<xsl:with-param name="this-schema" select="$this-schema"/>
			<xsl:with-param name="called-schemas" select="$called-schemas" />
			<xsl:with-param name="done" select="concat($done,' ',$this_select,' ')" />
		</xsl:apply-templates>

	</xsl:if>

</xsl:template>
-->

<xsl:template match="type" mode="basedon">
	<xsl:param name="this-schema" />
	<xsl:param name="called-schemas" />
	<xsl:param name="done" select="' '" />

	<xsl:variable name="this_select" select="@name" />

	<xsl:if test="not(contains($done, concat(' ',@name,' ')))" >

	<xsl:variable name="items" select="concat(' ',select/@selectitems,' ')" />
	<xsl:choose>
		<xsl:when test="select/@selectitems and ($called-schemas//type[contains($items,
			concat(' ',@name,' '))] or $this-schema//type[contains($items,
			concat(' ',@name,' '))]) " >
		<!-- need to recurse to deal with the select-items in this select -->

			<xsl:call-template name="select-item-recurse" >
				<xsl:with-param name="items" select="$items" />
				<xsl:with-param name="this-schema" select="$this-schema"/>
				<xsl:with-param name="called-schemas" select="$called-schemas" />
				<xsl:with-param name="done" select="concat($done,' ',$this_select,' ')" />
			</xsl:call-template>


		</xsl:when>
		<xsl:when test="select/@selectitems" >
			<xsl:value-of select="concat(' ',select/@selectitems)" /> 
			<br/>			
		</xsl:when>
	</xsl:choose>

		<xsl:apply-templates select="$this-schema//type[select/@basedon=$this_select] 
							| $called-schemas//type[select/@basedon=$this_select]" 
						mode="basedon">
			<xsl:with-param name="this-schema" select="$this-schema"/>
			<xsl:with-param name="called-schemas" select="$called-schemas" />
			<xsl:with-param name="done" select="concat($done,' ',$this_select,' ')" />
		</xsl:apply-templates>

	</xsl:if>

</xsl:template>

<xsl:template name="select-item-recurse" >
	<xsl:param name="items" />
	<xsl:param name="this-schema" />
	<xsl:param name="called-schemas" />
	<xsl:param name="done" select="' '" />

	<!-- get first item -->

	<xsl:variable name="this-item" select="substring-before(concat(normalize-space($items),' '),' ')" />

	<xsl:if test="string-length($this-item)> 0" >

		<xsl:variable name="this-type" select="$this-schema//type[select][@name=$this-item]
					| $called-schemas//type[select][@name=$this-item]" />

		<xsl:choose>
			<xsl:when test="$this-type" >


<!-- this goes up the tree from the select -->
				<xsl:apply-templates select="$this-type" 
						mode="basedon">
					<xsl:with-param name="this-schema" select="$this-schema"/>
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="done" select="$done" />
				</xsl:apply-templates>

<!-- this goes down the tree from the select below (if it exists) -->

				<xsl:variable name="this-based-on" select="$this-type/@basedon"/>

				<xsl:if test="$this-based-on" >
					<xsl:apply-templates select="$this-based-on" mode="basedon-down">
						<xsl:with-param name="this-schema" select="$this-schema"/>
						<xsl:with-param name="called-schemas" select="$called-schemas" />
						<xsl:with-param name="done" select="$done" />
					</xsl:apply-templates>
				</xsl:if>

				<xsl:call-template name="select-item-recurse" >
					<xsl:with-param name="items" select="substring-after($items,$this-item)" />
					<xsl:with-param name="this-schema" select="$this-schema"/>
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="done" select="concat($done,' ',$this-item,' ')" />
				</xsl:call-template>

			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat(' ',$this-item)" />

				<xsl:call-template name="select-item-recurse" >
					<xsl:with-param name="items" select="substring-after($items,$this-item)" />
					<xsl:with-param name="this-schema" select="$this-schema"/>
					<xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:with-param name="done" select="$done" />
				</xsl:call-template>


			</xsl:otherwise>

		</xsl:choose>

	</xsl:if>
	
</xsl:template>


<xsl:template match="type" mode="basedon-down">
	<xsl:param name="this-schema" />
	<xsl:param name="called-schemas" />
	<xsl:param name="done" select="' '" />

	<xsl:variable name="this_select" select="@name" />
	<xsl:variable name="this_base" select="@basedon" />

	<xsl:if test="not(contains($done, concat(' ',@name,' ')))" >
	
		<xsl:if test="select/@selectitems" >
			<xsl:value-of select="concat(' ',select/@selectitems)" /> <!-- [<xsl:value-of select="./@name" />] -->
			<br/>
		</xsl:if>

		<xsl:apply-templates select="$this-schema//type[select][@name=$this_base] 
							| $called-schemas//type[select][@name=$this_base]" 
						mode="basedon-down">
			<xsl:with-param name="this-schema" select="$this-schema"/>
			<xsl:with-param name="called-schemas" select="$called-schemas" />
			<xsl:with-param name="done" select="concat($done,' ',$this_select,' ')" />
		</xsl:apply-templates>

	</xsl:if>

</xsl:template>

<xsl:template match="entity" mode="subtypes">
	<xsl:param name="this-schema" />
	<xsl:param name="called-schemas" />
	<xsl:param name="done" select="' '" />
	<xsl:param name="output" select="' '" />

	<xsl:variable name="this_entity" select="concat(' ',@name,' ')" />

	<xsl:if test="not(contains($done, $this_entity))" >

		<xsl:if test="not(contains($output, $this_entity))" >
			<xsl:value-of select="$this_entity" /> 
		</xsl:if>

		<xsl:apply-templates select="$this-schema//entity[
							contains(concat(' ',@supertypes,' '),$this_entity)] 
							| $called-schemas//entity[
							contains(concat(' ',@supertypes,' '),$this_entity)]" 
						mode="subtypes">
			<xsl:with-param name="this-schema" select="$this-schema"/>
			<xsl:with-param name="called-schemas" select="$called-schemas" />
			<xsl:with-param name="done" select="concat($done,$this_entity)" />
			<xsl:with-param name="output" select="concat($output,$this_entity)" />
		</xsl:apply-templates>

	</xsl:if>

</xsl:template>

<xsl:template match="x" >
	<br/>x: <xsl:value-of select="." />
</xsl:template>

<xsl:template match="explicit" mode="used-by">
	<xsl:value-of select="concat(' ',../@name,'.',@name)" />
	<br/>
</xsl:template>

<xsl:template match="explicit" mode="used-by-select-out">
	<xsl:value-of select="concat(' ',../@name,'.',@name,' : ', typename/@name)" />
	<br/>
</xsl:template>


<xsl:template match="explicit" mode="used-by-select">
	<xsl:param name="called-schemas" />

	<xsl:variable name="this-type" select="typename/@name" /> 

	<xsl:choose>
	<xsl:when test="../../type[select][@name=$this-type]">

		<xsl:apply-templates select="." mode="used-by-select-out" />

	</xsl:when>
	<xsl:when test="$called-schemas//type[select][@name=$this-type]">

		<xsl:apply-templates select="." mode="used-by-select-out" />

	</xsl:when>
	</xsl:choose>
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
				<xsl:variable name="mod" 
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
                                  <xsl:variable name="prefix">
                                    <xsl:call-template name="get_last_section">
                                      <xsl:with-param name="path" select="$this-schema"/>
                                      <xsl:with-param name="divider" select="'_'"/>
                                    </xsl:call-template>
                                  </xsl:variable>
                                  <xsl:choose>
                                    <xsl:when test="$prefix='schema'">
                                      <xsl:value-of 
                                        select="concat($dir,'data/resources/',$this-schema,'/',$this-schema,'.xml ')"/>
                                    </xsl:when>
                                    <xsl:when test="starts-with($this-schema,'aic_')">
                                      <xsl:value-of 
                                        select="concat($dir,'data/resources/',$this-schema,'/',$this-schema,'.xml ')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:value-of select="concat($dir,'data/modules/',$mod,'/arm.xml ')"/>
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


<xsl:template name="filter-word-list-negated" >
	<xsl:param name="allowed-list" />
	<xsl:param name="word-list" />

	<!-- outputs all words from word-list that are NOT in allowed-list -->

	<!-- get first item in list -->

	<xsl:variable name="first" select="substring-before(concat(normalize-space($word-list),' '),' ')" />

	<xsl:if test="$first" >

		<xsl:if test="not(contains(concat(' ',$allowed-list,' '),concat(' ',$first,' ')))" >
			<xsl:value-of select="concat(' ',$first,' ')" /> 
		</xsl:if>

		<xsl:call-template name="filter-word-list-negated">
			<xsl:with-param name="allowed-list" select="$allowed-list" />
			<xsl:with-param name="word-list" select="substring-after($word-list,$first)" />
		</xsl:call-template>

	</xsl:if>

</xsl:template>



<xsl:template match="type" mode="find-top-select">
	<xsl:param name="top-schema" />
	<xsl:param name="called-schemas" />

	<xsl:variable name="this-select" select="@name" />
<!--		PP<xsl:value-of select="$this-select" />PP<br/> -->

	<xsl:if test="$top-schema//type[select/@basedon=$this-select]">

		<xsl:for-each select="$top-schema//type[select/@basedon=$this-select]">
			<xsl:value-of select="concat(' ',@name,' ')" />
		</xsl:for-each>


	</xsl:if>

		<xsl:apply-templates select="$called-schemas//type[select/@basedon=$this-select]" mode="find-top-select">
			<xsl:with-param name="top-schema" select="$top-schema" />
			<xsl:with-param name="called-schemas" select="$called-schemas" />		
		</xsl:apply-templates>
	
</xsl:template>


</xsl:stylesheet>
