<?xml version="1.0" encoding="utf-8"?>
<!-- <?xml-stylesheet type="text/xsl" href="../../xsl/document_xsl.xsl" ?>
-->
<!--
  Author:  Nigel Shaw, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: 
  	1) To display an index of the BOM EXPRESS with navigation aids
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		xmlns:exslt="http://exslt.org/common"
                exclude-result-prefixes="msxsl exslt"
                version="1.0">


<!--	<xsl:import href="../../xsl/express.xsl"/>
-->


<xsl:import href="../expressg_icon.xsl"/> 

  <xsl:output method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" indent="yes"/> 

  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>

  <xsl:variable name ="STEPMOD_DATA_MODULES" select="'../../../../data/business_object_models/'" />

 

    <xsl:variable name="selected_bom" select="/business_object_model_clause/@directory"/>
  <xsl:variable name="bom_xml_file" select="concat('../../data/business_object_models/',$selected_bom,'/bom.xml')"/>

  <xsl:variable name="iframe-width"
	    select="150"/>

    <xsl:variable name="bom_file" 
      select="concat('../../data/business_object_models/',$selected_bom,'/business_object_model.xml')"/>
    <xsl:variable name="bom-node" select="document($bom_file)"/>
    <xsl:variable name="selected_ap" select="$bom-node/business_object_model/@name"/>
    <xsl:variable name="ap_file" 
      select="concat('../../data/application_protocols/',$selected_ap,'/application_protocol.xml')"/>
    <xsl:variable name="ap_node" select="document($ap_file)"/>
   
  <xsl:variable name="bom_expressg"  >
    <xsl:call-template name="make_bom_expressg_node_set"/>
    </xsl:variable>
  <xsl:variable name ="arm_expressg"  />
  <xsl:variable name ="mim_expressg"  />

  <xsl:variable name="ap_top_module"
	    select="$ap_node/application_protocol/@module_name"/>

  <xsl:variable name="root2dir"
	    select="$STEPMOD_DATA_MODULES"/>

  <xsl:variable name="top_module_file" 
	    select="concat('../../data/business_object_models/',$ap_top_module,'/arm.xml')"/>

    <xsl:variable name="bom_xml_node" select="document($bom_xml_file)"/>



  <xsl:template match="/" >
    <HTML>
    <head>
<!--      <link rel="stylesheet" type="text/css" 
        href="../../../../nav/css/developer.css"/>
-->
<!--      <xsl:apply-templates select="$ap_node" mode="meta_data"/> -->
      <title>
	      <xsl:value-of select="concat('BOM EXPRESSS Navigation Index for ',$ap_node/application_protocol/@title)"/>
      </title>

    </head>
  <body>
    <xsl:apply-templates select="/" mode="arm_express"/>	

  </body>
</HTML>
</xsl:template>

	<xsl:template match="/" mode="arm_express">

		<xsl:variable name="schema-name" select="$bom_xml_node//schema/@name"/>


				<xsl:call-template name="index_arm_express_inner">
					<xsl:with-param name="called-schemas" select="$bom_xml_node"/>
					<xsl:with-param name="expressg" select="$bom_expressg"/>
				</xsl:call-template>

</xsl:template>

<xsl:template name="index_arm_express_inner" >
	<xsl:param name="called-schemas" />
	<xsl:param name="expressg"/>		
	
	<xsl:if test="$called-schemas//constant" >
		<br/>
		<A name="constants"><b>Constants</b></A>
		<br/>
		<xsl:call-template name="alph-list">
			<xsl:with-param name="items" select="$called-schemas//constant" />
			<xsl:with-param name="internal-link-root" select="'constant-letter'" />
			<xsl:with-param name="called-schemas" select="$called-schemas" />
		</xsl:call-template>
	</xsl:if>

	<xsl:if test="$called-schemas//type" >
		<br/>
                  <A name="types"><b>Types</b></A>
		<br/>
		<xsl:call-template name="alph-list">
			<xsl:with-param name="items" select="$called-schemas//type" />
			<xsl:with-param name="internal-link-root" select="'type-letter'" />
                        <xsl:with-param name="expressg" select="$expressg"/>
			<xsl:with-param name="called-schemas" select="$called-schemas" />
		</xsl:call-template>
	</xsl:if>

	<xsl:if test="$called-schemas//entity" >
		<br/>
		<A name="entities"><b>Entities</b></A>
		<br/>
		<xsl:call-template name="alph-list">
			<xsl:with-param name="items" select="$called-schemas//entity" />
			<xsl:with-param name="internal-link-root" select="'entity-letter'" />
                        <xsl:with-param name="expressg" select="$expressg" />
			<xsl:with-param name="called-schemas" select="$called-schemas" />
		</xsl:call-template>
	</xsl:if>

	<xsl:if test="$called-schemas//subtype.constraint" >
		<br/>
		<A name="subc"><b>Subtype Constraints</b></A>
		<br/>
		<xsl:call-template name="alph-list">
			<xsl:with-param name="items" select="$called-schemas//subtype.constraint" />
			<xsl:with-param name="internal-link-root" select="'subc-letter'" />
                        <xsl:with-param name="expressg" select="$expressg" />
			<xsl:with-param name="called-schemas" select="$called-schemas" />
		</xsl:call-template>
	</xsl:if>

	<xsl:if test="$called-schemas//rule" >
		<br/>
		<A name="rules"><b>Rules</b></A>
		<br/>
		<xsl:call-template name="alph-list">
			<xsl:with-param name="items" select="$called-schemas//rule" />
			<xsl:with-param name="internal-link-root" select="'rule-letter'" />
			<xsl:with-param name="called-schemas" select="$called-schemas" />
		</xsl:call-template>
	</xsl:if>


	<xsl:if test="$called-schemas//function" >
		<br/>
		<A name="functions"><b>Functions</b></A>
		<br/>
		<xsl:call-template name="alph-list">
			<xsl:with-param name="items" select="$called-schemas//function" />
			<xsl:with-param name="internal-link-root" select="'function-letter'" />
			<xsl:with-param name="called-schemas" select="$called-schemas" />
		</xsl:call-template>
	</xsl:if>

	<xsl:if test="$called-schemas//procedure" >
		<br/>
		<A name="procedures"><b>Procedures</b></A>
		<br/>
		<xsl:call-template name="alph-list">
			<xsl:with-param name="items" select="$called-schemas//procedure" />
			<xsl:with-param name="internal-link-root" select="'procedure-letter'" />
			<xsl:with-param name="called-schemas" select="$called-schemas" />
		</xsl:call-template>
	</xsl:if>


</xsl:template>


<xsl:template match="entity" mode="module-index" >
  <xsl:param name="expressg"/>
  <xsl:param name="called-schemas" />
    <xsl:variable name="mod-name" select="translate(substring-before(../@name,'_bom'),$UPPER,$LOWER)"/>
    <xsl:variable name="ent-name" select="@name"/>
    <xsl:variable name="ent-name-spaced" select="concat(' ',@name,' ')"/>
          
    <xsl:variable name="mod-dir" select="concat($STEPMOD_DATA_MODULES,$mod-name)"/>
    <xsl:variable name="ref" select="translate(concat(../@name,'.',@name),$UPPER,$LOWER)"/>
              
    <xsl:apply-templates select="." mode="expressg_icon">
      <xsl:with-param name="target" select="'info'"/>
      <xsl:with-param name="expressg" select="$expressg"/>
    </xsl:apply-templates> 

    <A HREF="{$mod-dir}/sys/4_info_reqs{$FILE_EXT}#{$ref}" TARGET="info">
      <xsl:value-of select="@name"/>
    </A>

    <xsl:variable name="subs" select="$called-schemas//entity[contains(
                                      concat(' ',@supertypes,' '),$ent-name-spaced)]"/>
    <xsl:variable name="used-in-explicit" select="$called-schemas//explicit[typename/@name=$ent-name]"/>
    <xsl:variable name="used-in-select" select="$called-schemas//type[select]
                                                [contains(concat(' ',select/@selectitems,' '),$ent-name-spaced)]"/>

    <xsl:if test="@supertypes or $used-in-explicit or $used-in-select">
      <TABLE>
        <TR>
          <TD><small>&#160;&#160;&#160;</small></TD>
          <TD ALIGN="LEFT" >
            <small>
              <xsl:if test="@supertypes" >
                <xsl:variable name="super-list" select="concat(' ',@supertypes,' ')"/>
                <xsl:variable name="supers" select="$called-schemas//entity[contains(
                                                    $super-list,@name)]"/>
                SUPERTYPES:
                <br/>
                <xsl:for-each select="$supers">
                  <xsl:sort select="@name"/>
                  <xsl:variable name="ref-mod" 
                    select="translate(substring-before(../@name,'_bom'),$UPPER,$LOWER)"/>
                  <xsl:variable name="lc-ref" select="translate(@name,$UPPER,$LOWER)"/>
                  &#160;&#160;&#160;
		  <a HREF="{$mod-dir}/sys/4_info_reqs{$FILE_EXT}#{$ref-mod}_bom.{$lc-ref}" TARGET="info">
                    <xsl:value-of select="@name"/>
                  </a>
                  <br/>
                </xsl:for-each>
              </xsl:if>
			
              <xsl:if test="$subs">
                SUBTYPES:
                <br/>
                <xsl:for-each select="$subs">
                  <xsl:sort select="@name"/>
                  <xsl:variable name="ref-mod" 
                    select="translate(substring-before(../@name,'_bom'),$UPPER,$LOWER)"/>
                  <xsl:variable name="lc-ref" select="translate(@name,$UPPER,$LOWER)"/>
                  &#160;&#160;&#160;
		  <a HREF="{$mod-dir}/sys/4_info_reqs{$FILE_EXT}#{$ref-mod}_bom.{$lc-ref}" TARGET="info">
                    <xsl:value-of select="@name"/>
                  </a>
                  <br/>
                </xsl:for-each>
              </xsl:if>
              <xsl:if test="$used-in-explicit">
                USED IN (ATTRIBUTE):
                <br/>
                <xsl:for-each select="$used-in-explicit">
                  <xsl:sort select="../@name"/>
                  <xsl:sort select="@name"/>
                  <xsl:variable name="ref-mod" 
                    select="translate(substring-before(../../@name,'_bom'),$UPPER,$LOWER)"/>
                  <xsl:variable name="lc-ref" select="translate(../@name,$UPPER,$LOWER)"/>
                  &#160;&#160;&#160;
                  <a HREF="{$mod-dir}/sys/4_info_reqs{$FILE_EXT}#{$ref-mod}_bom.{$lc-ref}.{@name}" TARGET="info">
                    <xsl:value-of select="concat(../@name,'.',@name)"/>
                  </a>
                  <br/>
                </xsl:for-each>
              </xsl:if>
              <xsl:if test="$used-in-select">
                USED IN (SELECT):
                <br/>
                <xsl:for-each select="$used-in-select">
                  <xsl:sort select="@name"/>
                  <xsl:variable name="ref-mod" 
                    select="translate(substring-before(../@name,'_bom'),$UPPER,$LOWER)"/>
                  <xsl:variable name="lc-ref" select="translate(@name,$UPPER,$LOWER)"/>
                  &#160;&#160;&#160;
                  <a HREF="{$mod-dir}/sys/4_info_reqs{$FILE_EXT}#{$ref-mod}_bom.{$lc-ref}"  TARGET="info">
                    <xsl:value-of select="@name"/>
                  </a>
                  <br/>
                </xsl:for-each>
              </xsl:if>					
            </small>
          </TD>
        </TR>
      </TABLE>
    </xsl:if>
    <br/>
</xsl:template>

<xsl:template match="constant" mode="module-index" >
	<xsl:param name="called-schemas"/>

		<xsl:variable name="mod-name" select="translate(substring-before(../@name,'_bom'),$UPPER,$LOWER)" />

		<xsl:variable name="mod-dir" select="concat($STEPMOD_DATA_MODULES,$mod-name)" />
		<xsl:variable name="ref" select="translate(concat(../@name,'.',@name),$UPPER,$LOWER)" />

		
		<A HREF="{$mod-dir}/sys/4_info_reqs{$FILE_EXT}#{$ref}" TARGET="info" >
		<xsl:value-of select="@name"/></A>
			<br/>
		
</xsl:template>


<xsl:template match="type" mode="module-index">
  <xsl:param name="expressg"/>
  <xsl:param name="called-schemas"/>
  <xsl:variable name="mod-name" select="translate(substring-before(../@name,'_bom'),$UPPER,$LOWER)"/>

  <xsl:variable name="mod-dir" select="concat($STEPMOD_DATA_MODULES,$mod-name)"/>
  <xsl:variable name="ref" select="translate(concat(../@name,'.',@name),$UPPER,$LOWER)"/>

  <xsl:variable name="lf_ref" select="translate(concat($ap_top_module,'_bom_lf.',@name),$UPPER,$LOWER)"/>

  <xsl:variable name="typ-name" select="@name"/>
  <xsl:variable name="typ-name-spaced" select="concat(' ',@name,' ')"/>
  
  <xsl:apply-templates select="." mode="expressg_icon">
    <xsl:with-param name="target" select="'info'"/>
    <xsl:with-param name="expressg" select="$expressg"/>
  </xsl:apply-templates>
  <A HREF="{$mod-dir}/sys/4_info_reqs{$FILE_EXT}#{$ref}" TARGET="info">
    <xsl:value-of select="@name"/>
  </A>

  <xsl:variable name="used-in-explicit" select="$called-schemas//explicit[typename/@name=$typ-name]"/>
  <xsl:variable name="used-in-select" select="$called-schemas//type[select]
                                              [contains(concat(' ',select/@selectitems,' '),$typ-name-spaced)]"/>
  <xsl:if test="$used-in-explicit or $used-in-select">
    <TABLE>
      <TR>
        <TD><small>&#160;&#160;&#160;</small></TD>
        <TD ALIGN="LEFT">
          <small>
            <xsl:if test="$used-in-explicit">
              <xsl:if test="./select[@extensible='YES']">
                SELECT <a HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_arm_lf{$FILE_EXT}#{$lf_ref}" 
                          TARGET="info">population</a><br/>
              </xsl:if>
              USED BY (ATTRIBUTE):
              <br/>
              <xsl:for-each select="$used-in-explicit">
                <xsl:sort select="../@name"/>
                <xsl:sort select="@name"/>
                <xsl:variable name="ref-mod" 
                  select="translate(substring-before(../../@name,'_bom'),$UPPER,$LOWER)"/>
                <xsl:variable name="lc-ref" select="translate(../@name,$UPPER,$LOWER)"/>
                &#160;&#160;&#160;
                <a HREF="{$mod-dir}/sys/4_info_reqs{$FILE_EXT}#{$ref-mod}_bom.{$lc-ref}.{@name}"  TARGET="info">
                  <xsl:value-of select="concat(../@name,'.',@name)"/>
                </a>
                <br/>
              </xsl:for-each>
            </xsl:if>
            
            <xsl:if test="$used-in-select">
              USED IN (SELECT):
              <br/>
              <xsl:for-each select="$used-in-select">
                <xsl:sort select="@name"/>
                <xsl:variable name="ref-mod" 
                  select="translate(substring-before(../@name,'_bom'),$UPPER,$LOWER)"/>
                <xsl:variable name="lc-ref" select="translate(@name,$UPPER,$LOWER)"/>
                &#160;&#160;&#160;
                <a HREF="{$mod-dir}/sys/4_info_reqs{$FILE_EXT}#{$ref-mod}_bom.{$lc-ref}"  TARGET="info">
                  <xsl:value-of select="@name"/>
                </a>
                <br/>
              </xsl:for-each>
            </xsl:if>
          </small>
        </TD>
      </TR>
    </TABLE>
  </xsl:if>
  <br/>
</xsl:template>

<xsl:template match="subtype.constraint" mode="module-index" >
        <xsl:param name="expressg"/>
	<xsl:param name="called-schemas" />
		<xsl:variable name="mod-name" select="translate(substring-before(../@name,'_bom'),$UPPER,$LOWER)" />

		<xsl:variable name="mod-dir" select="concat($STEPMOD_DATA_MODULES,$mod-name)" />
		<xsl:variable name="ref" select="translate(concat(../@name,'.',@name),$UPPER,$LOWER)" />

                  <xsl:apply-templates select="." mode="expressg_icon">
                  <xsl:with-param name="target" select="'info'"/>
                  <xsl:with-param name="expressg" select="$expressg" />
                </xsl:apply-templates> 

		<A HREF="{$mod-dir}/sys/4_info_reqs{$FILE_EXT}#{$ref}" TARGET="info" >
		<xsl:value-of select="@name" /></A>
			<br/>
		
</xsl:template>

<xsl:template match="rule" mode="module-index" >
	<xsl:param name="called-schemas" />
		<xsl:variable name="mod-name" select="translate(substring-before(../@name,'_bom'),$UPPER,$LOWER)" />

		<xsl:variable name="mod-dir" select="concat($STEPMOD_DATA_MODULES,$mod-name)" />
		<xsl:variable name="ref" select="translate(concat(../@name,'.',@name),$UPPER,$LOWER)" />

		
		<A HREF="{$mod-dir}/sys/4_info_reqs{$FILE_EXT}#{$ref}" TARGET="info" >
		<xsl:value-of select="@name" /></A>
			<br/>
		
</xsl:template>



<xsl:template match="function" mode="module-index" >
	<xsl:param name="called-schemas" />

		<xsl:variable name="mod-name" select="translate(substring-before(../@name,'_bom'),$UPPER,$LOWER)" />

		<xsl:variable name="mod-dir" select="concat($STEPMOD_DATA_MODULES,$mod-name)" />
		<xsl:variable name="ref" select="translate(concat(../@name,'.',@name),$UPPER,$LOWER)" />

		
		<A HREF="{$mod-dir}/sys/4_info_reqs{$FILE_EXT}#{$ref}" TARGET="info" >
		<xsl:value-of select="@name" /></A>
			<br/>
		
</xsl:template>

<xsl:template match="procedure" mode="module-index" >
	<xsl:param name="called-schemas" />

		<xsl:variable name="mod-name" select="translate(substring-before(../@name,'_bom'),$UPPER,$LOWER)" />

		<xsl:variable name="mod-dir" select="concat($STEPMOD_DATA_MODULES,$mod-name)" />
		<xsl:variable name="ref" select="translate(concat(../@name,'.',@name),$UPPER,$LOWER)" />

		
		<A HREF="{$mod-dir}/sys/4_info_reqs{$FILE_EXT}#{$ref}" TARGET="info" >
		<xsl:value-of select="@name" /></A>
			<br/>
		
</xsl:template>


<xsl:template match="interface" mode="interface-schemas">
  <xsl:param name="done"/>
  <xsl:variable name="schema" select="concat(' ',@schema,' ')"/>
  <xsl:if test="not(contains($done,$schema))">
    <xsl:value-of select="$schema"/> 
  </xsl:if>
</xsl:template>

<xsl:template name="alph-list" >
	<xsl:param name="items" />
	<xsl:param name="internal-link-root" />
	<xsl:param name="expressg"/>		
	<xsl:param name="called-schemas" />

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
                                  <xsl:with-param name="expressg" select="$expressg"/>
				  <xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' B')" >
				<br/>
				<A NAME="{$internal-link-root}-b"  ><B>B</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='B']" mode="module-index" >
                                  <xsl:with-param name="expressg" select="$expressg"/>
				  <xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' C')" >
				<br/>
				<A NAME="{$internal-link-root}-c"  ><B>C</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='C']" mode="module-index" >
                                  <xsl:with-param name="expressg" select="$expressg"/>
				  <xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' D')" >
				<br/>
				<A NAME="{$internal-link-root}-d"  ><B>D</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='D']" mode="module-index" >
                                  <xsl:with-param name="expressg" select="$expressg"/>
				  <xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' E')" >
				<br/>
				<A NAME="{$internal-link-root}-e"  ><B>E</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='E']" mode="module-index" >
                                  <xsl:with-param name="expressg" select="$expressg"/>
				  <xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' F')" >
				<br/>
				<A NAME="{$internal-link-root}-f"  ><B>F</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='F']" mode="module-index" >
                                  <xsl:with-param name="expressg" select="$expressg"/>
				  <xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' G')" >
				<br/>
				<A NAME="{$internal-link-root}-g"  ><B>G</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='G']" mode="module-index" >
                                  <xsl:with-param name="expressg" select="$expressg"/>
				  <xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' H')" >
				<br/>
				<A NAME="{$internal-link-root}-h"  ><B>H</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='H']" mode="module-index" >
                                  <xsl:with-param name="expressg" select="$expressg"/>
				  <xsl:with-param name="called-schemas" select="$called-schemas" />
				  <xsl:sort select="@name" />
</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' I')" >
				<br/>
				<A NAME="{$internal-link-root}-i"  ><B>I</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='I']" mode="module-index" >
                                  <xsl:with-param name="expressg" select="$expressg"/>
				  <xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' J')" >
				<br/>
				<A NAME="{$internal-link-root}-j"  ><B>J</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='J']" mode="module-index" >
                                  <xsl:with-param name="expressg" select="$expressg"/>
				  <xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' K')" >
				<br/>
				<A NAME="{$internal-link-root}-k"  ><B>K</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='K']" mode="module-index" >
                                  <xsl:with-param name="expressg" select="$expressg"/>
				  <xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' L')" >
				<br/>
				<A NAME="{$internal-link-root}-l"  ><B>L</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='L']" mode="module-index" >
                                  <xsl:with-param name="expressg" select="$expressg"/>
				  <xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' M')" >
				<br/>
				<A NAME="{$internal-link-root}-m"  ><B>M</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='M']" mode="module-index" >
                                  <xsl:with-param name="expressg" select="$expressg"/>
				  <xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' N')" >
				<br/>
				<A NAME="{$internal-link-root}-n"  ><B>N</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='N']" mode="module-index" >
                                  <xsl:with-param name="expressg" select="$expressg"/>
				  <xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' O')" >
				<br/>
				<A NAME="{$internal-link-root}-o"  ><B>O</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='O']" mode="module-index" >
                                  <xsl:with-param name="expressg" select="$expressg"/>
				  <xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' P')" >
				<br/>
				<A NAME="{$internal-link-root}-p"  ><B>P</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='P']" mode="module-index" >
                                  <xsl:with-param name="expressg" select="$expressg"/>
				  <xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' Q')" >
				<br/>
				<A NAME="{$internal-link-root}-q"  ><B>Q</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='Q']" mode="module-index" >
                                  <xsl:with-param name="expressg" select="$expressg"/>
				  <xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' R')" >
				<br/>
				<A NAME="{$internal-link-root}-r"  ><B>R</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='R']" mode="module-index" >
                                  <xsl:with-param name="expressg" select="$expressg"/>
				  <xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' S')" >
				<br/>
				<A NAME="{$internal-link-root}-s"  ><B>S</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='S']" mode="module-index" >
                                  <xsl:with-param name="expressg" select="$expressg"/>
				  <xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' T')" >
				<br/>
				<A NAME="{$internal-link-root}-t"  ><B>T</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='T']" mode="module-index" >
                                  <xsl:with-param name="expressg" select="$expressg"/>
				  <xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' U')" >
				<br/>
				<A NAME="{$internal-link-root}-u"  ><B>U</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='U']" mode="module-index" >
                                  <xsl:with-param name="expressg" select="$expressg"/>
				  <xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' V')" >
			
				<br/>
				<A NAME="{$internal-link-root}-v"  ><B>V</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='V']" mode="module-index" >
                                  <xsl:with-param name="expressg" select="$expressg"/>
				  <xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' W')" >
				<br/>
				<A NAME="{$internal-link-root}-w"  ><B>W</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='W']" mode="module-index" >
                                  <xsl:with-param name="expressg" select="$expressg"/>
				  <xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' X')" >
				<br/>
				<A NAME="{$internal-link-root}-x"  ><B>X</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='X']" mode="module-index" >
                                  <xsl:with-param name="expressg" select="$expressg"/>
				  <xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' Y')" >
				<br/>
				<A NAME="{$internal-link-root}-y"  ><B>Y</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='Y']" mode="module-index" >
                                  <xsl:with-param name="expressg" select="$expressg"/>
				  <xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' Z')" >
				<br/>
				<A NAME="{$internal-link-root}-z"  ><B>Z</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='Z']" mode="module-index" >
                                  <xsl:with-param name="expressg" select="$expressg"/>
				  <xsl:with-param name="called-schemas" select="$called-schemas" />
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
</xsl:template>


</xsl:stylesheet>
