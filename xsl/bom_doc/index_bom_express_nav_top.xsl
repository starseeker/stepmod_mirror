<?xml version="1.0" encoding="utf-8"?>
<!-- <?xml-stylesheet type="text/xsl" href="../../xsl/document_xsl.xsl" ?>
-->
<!--
  Author:  Nigel Shaw, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: 
  	1) To display the index to the full list of ARM EXPRESS constructs for an AP
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		xmlns:exslt="http://exslt.org/common"
                exclude-result-prefixes="msxsl exslt"
                version="1.0">


<!--	<xsl:import href="../../xsl/express.xsl"/>
-->

  <xsl:import href="common.xsl"/>


  <xsl:output method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" indent="yes"/> 

  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>

    <xsl:variable name="selected_bom" select="/business_object_model_clause/@directory"/>
    <xsl:variable name="bom_file" 
      select="concat('../../data/business_object_models/',$selected_bom,'/business_object_model.xml')"/>
    <xsl:variable name="bom-node" select="document($bom_file)"/>

    <xsl:variable name="selected_ap" select="$bom-node/business_object_model/@name"/>
    <xsl:variable name="ap_file" 
      select="concat('../../data/application_protocols/',$selected_ap,'/application_protocol.xml')"/>
    <xsl:variable name="ap_node" select="document($ap_file)"/>


  <xsl:template match="/" >
    <HTML>
    <head>
<!--      <link rel="stylesheet" type="text/css" 
        href="../../../../nav/css/developer.css"/>
-->
<!--      <xsl:apply-templates select="$ap_node/application_protocol" mode="meta_data"/> -->
      <title>
        <xsl:value-of select="concat('AP Index for ',$selected_ap)"/>
      </title>

    </head>
  <body>
  <small> 
 	<A HREF="../../../../data/application_protocols/{$selected_ap}/sys/frame_index{$FILE_EXT}" TARGET="index" >Back to navigation indices</A>
	<BR/>
	<B>BOM EXPRESS Navigation index</B>
	<br/>

    <xsl:variable name="bom_xml_file" 
      select="concat('../../data/business_object_models/',$selected_bom,'/bom.xml')"/>

	<xsl:variable name="bom_node"
	    select="document($bom_xml_file)/express"/>

	<xsl:variable name="schema-name"
	    select="$bom_node//schema/@name"/>


			<xsl:call-template name="arm_express_index" >
				<xsl:with-param name="this-schema" select="$bom_node" />
			</xsl:call-template>
	</small> 
  </body>
</HTML>
</xsl:template>



<xsl:template name="arm_express_index" >
	<xsl:param name="this-schema" />

		<xsl:variable name="const-names">
			<xsl:for-each select="$this-schema//constant" >
				<xsl:value-of select="concat(' ',@name,' ')" />
			</xsl:for-each>
		</xsl:variable>

		<xsl:if test="string-length($const-names) > 1" >
			<A HREF="index_bom_express_nav_inner{$FILE_EXT}#constants" TARGET="toc_inner" ><B>Constants:</B></A>
			<xsl:text> </xsl:text>
			<xsl:call-template name="alph-index">
				<xsl:with-param name="names" select="$const-names" />
				<xsl:with-param name="file" select="concat('index_bom_express_nav_inner',$FILE_EXT)" />
				<xsl:with-param name="internal-link-root" select="'constant-letter'" />
			</xsl:call-template>
			<br/>
		</xsl:if>


		<xsl:variable name="type-names">
			<xsl:for-each select="$this-schema//type" >
				<xsl:value-of select="concat(' ',@name,' ')" />
			</xsl:for-each>
		</xsl:variable>

		<xsl:if test="string-length($type-names) > 1" >
			<A HREF="index_bom_express_nav_inner{$FILE_EXT}#types" TARGET="toc_inner" ><B>Types:</B></A>
			<xsl:text> </xsl:text>
			<xsl:call-template name="alph-index">
				<xsl:with-param name="names" select="$type-names" />
				<xsl:with-param name="file" select="concat('index_bom_express_nav_inner',$FILE_EXT)" />
				<xsl:with-param name="internal-link-root" select="'type-letter'" />
			</xsl:call-template>
			<br/>
		</xsl:if>

		<xsl:variable name="ent-names">
			<xsl:for-each select="$this-schema//entity" >
				<xsl:value-of select="concat(' ',@name,' ')" />
			</xsl:for-each>
		</xsl:variable>

		<xsl:if test="string-length($ent-names) > 1" >
			<A HREF="index_bom_express_nav_inner{$FILE_EXT}#entities" TARGET="toc_inner" ><B>Entities:</B></A>
			<xsl:text> </xsl:text>
			<xsl:call-template name="alph-index">
				<xsl:with-param name="names" select="$ent-names" />
				<xsl:with-param name="file" select="concat('index_bom_express_nav_inner',$FILE_EXT)" />
				<xsl:with-param name="internal-link-root" select="'entity-letter'" />
			</xsl:call-template>
			<br/>
		</xsl:if>

		<xsl:variable name="subc-names">
			<xsl:for-each select="$this-schema//subtype.constraint" >
				<xsl:value-of select="concat(' ',@name,' ')" />
			</xsl:for-each>
		</xsl:variable>

		<xsl:if test="string-length($subc-names) > 1" >
			<A HREF="index_bom_express_nav_inner{$FILE_EXT}#subc" TARGET="toc_inner" ><B>Subtype Constraints:</B></A>
			<xsl:text> </xsl:text>
			<xsl:call-template name="alph-index">
				<xsl:with-param name="names" select="$subc-names" />
				<xsl:with-param name="file" select="concat('index_bom_express_nav_inner',$FILE_EXT)" />
				<xsl:with-param name="internal-link-root" select="'subc-letter'" />
			</xsl:call-template>
			<br/>
		</xsl:if>

		<xsl:variable name="rule-names">
			<xsl:for-each select="$this-schema//rule" >
				<xsl:value-of select="concat(' ',@name,' ')" />
			</xsl:for-each>
		</xsl:variable>

		<xsl:if test="string-length($rule-names) > 1" >
			<A HREF="index_bom_express_nav_inner{$FILE_EXT}#rules" TARGET="toc_inner" ><B>Rules:</B></A>
			<xsl:text> </xsl:text>
			<xsl:call-template name="alph-index">
				<xsl:with-param name="names" select="$rule-names" />
				<xsl:with-param name="file" select="concat('index_bom_express_nav_inner',$FILE_EXT)" />
				<xsl:with-param name="internal-link-root" select="'rule-letter'" />
			</xsl:call-template>
			<br/>
		</xsl:if>

		<xsl:variable name="fun-names">
			<xsl:for-each select="$this-schema//function" >
				<xsl:value-of select="concat(' ',@name,' ')" />
			</xsl:for-each>
		</xsl:variable>

		<xsl:if test="string-length($fun-names) > 1" >
			<A HREF="index_bom_express_nav_inner{$FILE_EXT}#functions" TARGET="toc_inner" ><B>Functions:</B></A>
			<xsl:text> </xsl:text>
			<xsl:call-template name="alph-index">
				<xsl:with-param name="names" select="$fun-names" />
				<xsl:with-param name="file" select="concat('index_bom_express_nav_inner',$FILE_EXT)" />
				<xsl:with-param name="internal-link-root" select="'function-letter'" />
			</xsl:call-template>
			<br/>
		</xsl:if>

		<xsl:variable name="proc-names">
			<xsl:for-each select="$this-schema//procedure" >
				<xsl:value-of select="concat(' ',@name,' ')" />
			</xsl:for-each>
		</xsl:variable>

		<xsl:if test="string-length($proc-names) > 1" >
			<A HREF="index_bom_express_nav_inner{$FILE_EXT}#procedures" TARGET="toc_in	ner" ><B>Procedures:</B></A>
			<xsl:text> </xsl:text>
			<xsl:call-template name="alph-index">
				<xsl:with-param name="names" select="$proc-names" />
				<xsl:with-param name="file" select="concat('index_bom_express_nav_inner',$FILE_EXT)" />
				<xsl:with-param name="internal-link-root" select="'procedures-letter'" />
			</xsl:call-template>
			<br/>
		</xsl:if>

</xsl:template>


<xsl:template match="interface" mode="interface-schemas">
  <xsl:param name="done"/>
  <xsl:variable name="schema" select="concat(' ',@schema,' ')"/>
  <xsl:if test="not(contains($done,$schema))">
    <xsl:value-of select="$schema"/> 
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
