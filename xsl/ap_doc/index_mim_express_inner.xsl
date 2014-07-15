<?xml version="1.0" encoding="utf-8"?>
<!-- <?xml-stylesheet type="text/xsl" href="../../xsl/document_xsl.xsl" ?>
-->
<!--
$Id: index_mim_express_inner.xsl,v 1.16 2004/12/29 14:29:24 robbod Exp $
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


<!--	<xsl:import href="../../xsl/express.xsl"/>
-->

<!--  <xsl:import href="../../xsl/common.xsl"/> 
-->
  <xsl:import href="expressg_icon.xsl"/> 


  <xsl:variable name="selected_ap" select="/application_protocol/@directory"/>

  <xsl:output method="html"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" indent="yes"/> 


  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>

  <xsl:variable name="ap_file" 
	    select="concat('../../data/application_protocols/',$selected_ap,'/application_protocol.xml')"/>
	    
  <xsl:variable name="ap_node"
	    select="document($ap_file)"/>

  <xsl:variable name="ap_top_module"
	    select="$ap_node/application_protocol/@module_name"/>

  <!-- fragment must be lower case -->
	<xsl:variable name="top_module_file" 
          select="concat('../../../stepmod/data/modules/',translate($ap_top_module,$UPPER,$LOWER),'/mim.xml')"/>

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

	<xsl:variable name="mim_lf_file" 
	    select="concat('../../data/modules/',$ap_top_module,'/mim_lf.xml')"/>

	<xsl:variable name="mim_lf_node"
	    select="document($mim_lf_file)/express"/>

	<xsl:variable name="mim_constant_names" >
		<xsl:for-each select="$mim_lf_node//constant" >
			<xsl:value-of select="concat(' ',@name,' ')" />
		</xsl:for-each>
	</xsl:variable>
	
	<xsl:variable name="mim_type_names" >
		<xsl:for-each select="$mim_lf_node//type" >
			<xsl:value-of select="concat(' ',@name,' ')" />
		</xsl:for-each>
	</xsl:variable>

	<xsl:variable name="mim_entity_names" >
		<xsl:for-each select="$mim_lf_node//entity" >
			<xsl:value-of select="concat(' ',@name,' ')" />
		</xsl:for-each>
	</xsl:variable>
		
	<xsl:variable name="mim_rule_names" >
		<xsl:for-each select="$mim_lf_node//rule" >
			<xsl:value-of select="concat(' ',@name,' ')" />
		</xsl:for-each>
	</xsl:variable>

	<xsl:variable name="mim_function_names" >
		<xsl:for-each select="$mim_lf_node//function" >
			<xsl:value-of select="concat(' ',@name,' ')" />
		</xsl:for-each>
	</xsl:variable>

	<xsl:variable name="mim_procedure_names" >
		<xsl:for-each select="$mim_lf_node//procedure" >
			<xsl:value-of select="concat(' ',@name,' ')" />
		</xsl:for-each>
	</xsl:variable>


  <xsl:template match="/" >
    <HTML>
    <head>
<!--      <link rel="stylesheet" type="text/css" 
        href="../../../../nav/css/developer.css"/>
-->
      <xsl:apply-templates select="$ap_node" mode="meta_data"/>
      <title>
        <xsl:value-of select="concat('AP Index for ',$selected_ap)"/>
      </title>

    </head>
  <body>
  	<xsl:apply-templates select="/" mode="mim-express" />
  </body>
</HTML>
</xsl:template>

<xsl:template match="/" mode="mim-express" >
<small>

      <xsl:choose>
	<xsl:when test="function-available('msxsl:node-set')">


		<xsl:variable name="schemas-node-set" select="msxsl:node-set($mim_schemas)" />

		<xsl:variable name="dep-schemas3">
			<xsl:for-each select="$schemas-node-set//x" >
				<xsl:sort /> <!-- added sort here which is not in the saxon version below -->
				<xsl:copy-of select="document(.)" />
			</xsl:for-each> 
		</xsl:variable>

                <!-- collect up all the expressg refs into a node-set -->
                <xsl:variable name="mim_expressg">
                  <expg_nodes>
                    <xsl:for-each select="msxsl:node-set($schemas-node-set)//x">
                      <xsl:variable name="module" 
                        select="substring-after(substring-before(.,'/mim.xml'),'modules')"/>
                      <xsl:variable name="module_xml" 
                        select="concat('../../data/modules',$module,'/module.xml')"/>
                      <xsl:if test="$module_xml!='../../data/modules/module.xml'">
                        <!-- ignore resources as they have no graphics -->
                        <xsl:apply-templates 
                          select="document($module_xml)/module/mim/express-g/imgfile" mode="mk_node"/>
                      </xsl:if>
                    </xsl:for-each> 
                  </expg_nodes>
                </xsl:variable>

		<xsl:variable name="dep-schemas" select="msxsl:node-set($dep-schemas3)" />
                <xsl:variable name="mim_expressg_nodes" select="msxsl:node-set($mim_expressg)"/>

                <xsl:call-template name="index_mim_express_inner" >
                  <xsl:with-param name="this-schema" select="$mim_lf_node"/>
                  <xsl:with-param name="called-schemas" select="$dep-schemas"/>
                  <xsl:with-param name="expressg" select="$mim_expressg_nodes"/>
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

                <!-- collect up all the expressg refs into a node-set -->
                <xsl:variable name="mim_expressg">
                  <expg_nodes>
                    <xsl:for-each select="exslt:node-set($schemas-node-set2)//x">
                      <xsl:variable name="module_xml" 
                        select="concat(substring-before(.,'mim.xml'),'module.xml')"/>
                      <xsl:if test="$module_xml!='module.xml'">
                        <!-- ignore resources as they have no graphics -->
                        <xsl:apply-templates 
                          select="document($module_xml)/module/mim/express-g/imgfile" mode="mk_node"/>
                      </xsl:if>
                    </xsl:for-each>
                  </expg_nodes>
                </xsl:variable>

		<xsl:variable name="dep-schemas" select="document(exslt:node-set($schemas-node-set2)//x)" />
                <xsl:variable name="mim_expressg_nodes" select="exslt:node-set($mim_expressg)"/>

			<xsl:call-template name="index_mim_express_inner" >
				<xsl:with-param name="this-schema" select="$mim_lf_node" />
				<xsl:with-param name="called-schemas" select="$dep-schemas" />
				<xsl:with-param name="expressg" select="$mim_expressg_nodes" />
			</xsl:call-template>



			</xsl:when>

			</xsl:choose>
  
</small>
</xsl:template>



<xsl:template name="index_mim_express_inner" >
	<xsl:param name="this-schema" />
	<xsl:param name="called-schemas" />
	<xsl:param name="expressg"/>	

	<xsl:if test="string-length($mim_constant_names) > 2" >
		<br/>
		<A name="constants"><b>Constants</b></A>
		<br/>
		<xsl:call-template name="alph-list">
			<xsl:with-param name="items" select="$this-schema//constant" />
			<xsl:with-param name="internal-link-root" select="'constant-letter'" />
			<xsl:with-param name="called-schemas" select="$called-schemas" />
                        <xsl:with-param name="expressg" select="$expressg"/>
		</xsl:call-template>
	</xsl:if>

	<xsl:if test="string-length($mim_type_names) > 2" >
		<br/>
		<A name="types"><b>Types</b></A>
		<br/>
		<xsl:call-template name="alph-list">
			<xsl:with-param name="items" select="$this-schema//type" />
			<xsl:with-param name="internal-link-root" select="'type-letter'" />
			<xsl:with-param name="called-schemas" select="$called-schemas" />
                        <xsl:with-param name="expressg" select="$expressg"/>
		</xsl:call-template>
	</xsl:if>

	<xsl:if test="string-length($mim_entity_names) > 2" >
		<br/>
		<A name="entities"><b>Entities</b></A>
		<br/>
		<xsl:call-template name="alph-list">
			<xsl:with-param name="items" select="$this-schema//entity" />
			<xsl:with-param name="internal-link-root" select="'entity-letter'" />
			<xsl:with-param name="called-schemas" select="$called-schemas" />
                        <xsl:with-param name="expressg" select="$expressg"/>
		</xsl:call-template>
	</xsl:if>


	<xsl:if test="string-length($mim_rule_names) > 2" >
		<br/>
		<A name="rules"><b>Rules</b></A>
		<br/>
		<xsl:call-template name="alph-list">
			<xsl:with-param name="items" select="$this-schema//rule" />
			<xsl:with-param name="internal-link-root" select="'rule-letter'" />
			<xsl:with-param name="called-schemas" select="$called-schemas" />
		</xsl:call-template>
	</xsl:if>


	<xsl:if test="string-length($mim_function_names) > 2" >
		<br/>
		<A name="functions"><b>Functions</b></A>
		<br/>
		<xsl:call-template name="alph-list">
			<xsl:with-param name="items" select="$this-schema//function" />
			<xsl:with-param name="internal-link-root" select="'function-letter'" />
			<xsl:with-param name="called-schemas" select="$called-schemas" />
		</xsl:call-template>
	</xsl:if>

	<xsl:if test="string-length($mim_procedure_names) > 2" >
		<br/>
		<A name="procedures"><b>Procedures</b></A>
		<br/>
		<xsl:call-template name="alph-list">
			<xsl:with-param name="items" select="$this-schema//procedure" />
			<xsl:with-param name="internal-link-root" select="'procedure-letter'" />
			<xsl:with-param name="called-schemas" select="$called-schemas" />
		</xsl:call-template>
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

	<xsl:variable name="this-schema"
          select="substring-before(concat(normalize-space($todo),' '),' ')"/>
        
        <xsl:variable name="prefix">
          <xsl:call-template name="get_last_section">
            <xsl:with-param name="path" select="$this-schema"/>
            <xsl:with-param name="divider" select="'_'"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="module">
          <xsl:call-template name="get_string_before">
            <xsl:with-param name="str" select="$this-schema"/>
            <xsl:with-param name="char" select="'_'"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:if test="$this-schema" >

          <!-- open up the relevant schema  - which can be a resource or a mim schema -->
          <xsl:variable name="file_name">
            <xsl:choose>
              <xsl:when test="function-available('msxsl:node-set')" >
                <xsl:choose>
                  <xsl:when test="$prefix='mim'" >
                  	<xsl:value-of select="translate(concat('../../../modules/',$module,'/mim.xml'),$UPPER,$LOWER)"/>
                  </xsl:when>
                  <xsl:when test="$prefix='schema'" >
                    <xsl:value-of select="concat('../../../resources/',$this-schema,'/',$this-schema,'.xml')"/>
                  </xsl:when>
                  <xsl:when test="starts-with($this-schema,'aic_')">
                    <xsl:value-of select="concat('../../../resources/',$this-schema,'/',$this-schema,'.xml')"/>
                  </xsl:when>
                  <xsl:otherwise>
                    BAD SCHEMA name !!! <xsl:value-of select="$this-schema"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="function-available('exslt:node-set')" >
                <xsl:choose>
                  <xsl:when test="$prefix='mim'" >
                  	<xsl:value-of select="translate(concat('../../data/modules/',$module,'/mim.xml'),$UPPER,$LOWER)"/>
                  </xsl:when>
                  <xsl:when test="$prefix='schema'">
                    <xsl:value-of select="concat('../../data/resources/',$this-schema,'/',$this-schema,'.xml')"/>
                  </xsl:when>
                  <xsl:when test="starts-with($this-schema,'aic_')">
                    <xsl:value-of select="concat('../../data/resources/',$this-schema,'/',$this-schema,'.xml')"/>
                  </xsl:when>
                  <xsl:otherwise>
                    BAD SCHEMA name !!! <xsl:value-of select="$this-schema"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
            </xsl:choose>
          </xsl:variable>

			<xsl:if test="not(contains($done,concat(' ',$this-schema,' ')))" >
				<x><xsl:value-of select="translate($file_name,$UPPER,$LOWER)" /></x>
			</xsl:if>



			<xsl:variable name="mim-node"
				select="document(translate($file_name,$UPPER,$LOWER))/express"/>


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
	<xsl:param name="called-schemas" />
	<xsl:param name="expressg"/>	

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
					<xsl:with-param name="called-schemas" select="$called-schemas" />
                                        <xsl:with-param name="expressg" select="$expressg"/>
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' B')" >
				<br/>
				<A NAME="{$internal-link-root}-b"  ><B>B</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='B']" mode="module-index" >
					<xsl:with-param name="called-schemas" select="$called-schemas" />
                                        <xsl:with-param name="expressg" select="$expressg"/>
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' C')" >
				<br/>
				<A NAME="{$internal-link-root}-c"  ><B>C</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='C']" mode="module-index" >
					<xsl:with-param name="called-schemas" select="$called-schemas" />
                                        <xsl:with-param name="expressg" select="$expressg"/>
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' D')" >
				<br/>
				<A NAME="{$internal-link-root}-d"  ><B>D</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='D']" mode="module-index" >
					<xsl:with-param name="called-schemas" select="$called-schemas" />
                                        <xsl:with-param name="expressg" select="$expressg"/>
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' E')" >
				<br/>
				<A NAME="{$internal-link-root}-e"  ><B>E</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='E']" mode="module-index" >
					<xsl:with-param name="called-schemas" select="$called-schemas" />
                                        <xsl:with-param name="expressg" select="$expressg"/>
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' F')" >
				<br/>
				<A NAME="{$internal-link-root}-f"  ><B>F</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='F']" mode="module-index" >
					<xsl:with-param name="called-schemas" select="$called-schemas" />
                                        <xsl:with-param name="expressg" select="$expressg"/>
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' G')" >
				<br/>
				<A NAME="{$internal-link-root}-g"  ><B>G</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='G']" mode="module-index" >
					<xsl:with-param name="called-schemas" select="$called-schemas" />
                                        <xsl:with-param name="expressg" select="$expressg"/>
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' H')" >
				<br/>
				<A NAME="{$internal-link-root}-h"  ><B>H</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='H']" mode="module-index" >
					<xsl:with-param name="called-schemas" select="$called-schemas" />
                                        <xsl:with-param name="expressg" select="$expressg"/>
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' I')" >
				<br/>
				<A NAME="{$internal-link-root}-i"  ><B>I</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='I']" mode="module-index" >
					<xsl:with-param name="called-schemas" select="$called-schemas" />
                                        <xsl:with-param name="expressg" select="$expressg"/>
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' J')" >
				<br/>
				<A NAME="{$internal-link-root}-j"  ><B>J</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='J']" mode="module-index" >
					<xsl:with-param name="called-schemas" select="$called-schemas" />
                                        <xsl:with-param name="expressg" select="$expressg"/>
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' K')" >
				<br/>
				<A NAME="{$internal-link-root}-k"  ><B>K</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='K']" mode="module-index" >
					<xsl:with-param name="called-schemas" select="$called-schemas" />
                                        <xsl:with-param name="expressg" select="$expressg"/>
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' L')" >
				<br/>
				<A NAME="{$internal-link-root}-l"  ><B>L</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='L']" mode="module-index" >
					<xsl:with-param name="called-schemas" select="$called-schemas" />
                                        <xsl:with-param name="expressg" select="$expressg"/>
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' M')" >
				<br/>
				<A NAME="{$internal-link-root}-m"  ><B>M</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='M']" mode="module-index" >
					<xsl:with-param name="called-schemas" select="$called-schemas" />
                                        <xsl:with-param name="expressg" select="$expressg"/>
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' N')" >
				<br/>
				<A NAME="{$internal-link-root}-n"  ><B>N</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='N']" mode="module-index" >
					<xsl:with-param name="called-schemas" select="$called-schemas" />
                                        <xsl:with-param name="expressg" select="$expressg"/>
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' O')" >
				<br/>
				<A NAME="{$internal-link-root}-o"  ><B>O</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='O']" mode="module-index" >
					<xsl:with-param name="called-schemas" select="$called-schemas" />
                                        <xsl:with-param name="expressg" select="$expressg"/>
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' P')" >
				<br/>
				<A NAME="{$internal-link-root}-p"  ><B>P</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='P']" mode="module-index" >
					<xsl:with-param name="called-schemas" select="$called-schemas" />
                                        <xsl:with-param name="expressg" select="$expressg"/>
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' Q')" >
				<br/>
				<A NAME="{$internal-link-root}-q"  ><B>Q</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='Q']" mode="module-index" >
					<xsl:with-param name="called-schemas" select="$called-schemas" />
                                        <xsl:with-param name="expressg" select="$expressg"/>
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' R')" >
				<br/>
				<A NAME="{$internal-link-root}-r"  ><B>R</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='R']" mode="module-index" >
					<xsl:with-param name="called-schemas" select="$called-schemas" />
                                        <xsl:with-param name="expressg" select="$expressg"/>
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' S')" >
				<br/>
				<A NAME="{$internal-link-root}-s"  ><B>S</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='S']" mode="module-index" >
					<xsl:with-param name="called-schemas" select="$called-schemas" />
                                        <xsl:with-param name="expressg" select="$expressg"/>
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' T')" >
				<br/>
				<A NAME="{$internal-link-root}-t"  ><B>T</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='T']" mode="module-index" >
					<xsl:with-param name="called-schemas" select="$called-schemas" />
                                        <xsl:with-param name="expressg" select="$expressg"/>
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' U')" >
				<br/>
				<A NAME="{$internal-link-root}-u"  ><B>U</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='U']" mode="module-index" >
					<xsl:with-param name="called-schemas" select="$called-schemas" />
                                        <xsl:with-param name="expressg" select="$expressg"/>
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' V')" >
			
				<br/>
				<A NAME="{$internal-link-root}-v"  ><B>V</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='V']" mode="module-index" >
					<xsl:with-param name="called-schemas" select="$called-schemas" />
                                        <xsl:with-param name="expressg" select="$expressg"/>
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' W')" >
				<br/>
				<A NAME="{$internal-link-root}-w"  ><B>W</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='W']" mode="module-index" >
					<xsl:with-param name="called-schemas" select="$called-schemas" />
                                        <xsl:with-param name="expressg" select="$expressg"/>
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' X')" >
				<br/>
				<A NAME="{$internal-link-root}-x"  ><B>X</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='X']" mode="module-index" >
					<xsl:with-param name="called-schemas" select="$called-schemas" />
                                        <xsl:with-param name="expressg" select="$expressg"/>
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' Y')" >
				<br/>
				<A NAME="{$internal-link-root}-y"  ><B>Y</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='Y']" mode="module-index" >
					<xsl:with-param name="called-schemas" select="$called-schemas" />
                                        <xsl:with-param name="expressg" select="$expressg"/>
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="contains($name-list,' Z')" >
				<br/>
				<A NAME="{$internal-link-root}-z"  ><B>Z</B></A>
				<br/>
				<xsl:apply-templates select="$items[translate(substring(@name,1,1),$LOWER,$UPPER)='Z']" mode="module-index" >
					<xsl:with-param name="called-schemas" select="$called-schemas" />
                                        <xsl:with-param name="expressg" select="$expressg"/>
					<xsl:sort select="@name" />
				</xsl:apply-templates>
			</xsl:if>
</xsl:template>



<xsl:template match="entity" mode="module-index">
        <xsl:param name="expressg"/>
	<xsl:param name="called-schemas" />

	<xsl:variable name="this-ent-name" select="@name" />
	<xsl:value-of select="@name"/>
	<br/>
	<!-- find original definition -->
	<xsl:variable name="orig" select="$called-schemas//entity[@name=$this-ent-name]" />

	<xsl:variable name="schema-name" select="$orig/ancestor::schema/@name" />
	<xsl:variable name="schema-name-l" select="translate($schema-name, $UPPER,$LOWER)"/>

        <xsl:variable name="def_ref" select="translate(concat($schema-name,'.',@name), $UPPER,$LOWER)"/>
        <xsl:variable name="lf_ref" select="translate(concat(../@name,'.',@name), $UPPER,$LOWER)"/>

        <xsl:variable name="prefix">
          <xsl:call-template name="get_last_section">
            <xsl:with-param name="path" select="$schema-name-l"/>
            <xsl:with-param name="divider" select="'_'"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="module">
          <xsl:call-template name="get_string_before">
            <xsl:with-param name="str" select="$schema-name-l"/>
            <xsl:with-param name="char" select="'_'"/>
          </xsl:call-template>
        </xsl:variable>

	<xsl:choose>
		<xsl:when test="$prefix='mim'" >
    			<xsl:variable name="mod-dir" 
				 select="translate(concat($STEPMOD_DATA_MODULES,$module),$UPPER,$LOWER)" />
                          <xsl:apply-templates select="." mode="expressg_icon">
                            <xsl:with-param name="target" select="'info'"/>
                            <xsl:with-param name="expressg" select="$expressg"/>
                          </xsl:apply-templates> 
                          <!-- <A HREF="{$mod-dir}/sys/5_mim{$FILE_EXT}#{$schema-name-l}.{@name}" TARGET="info" >Definition</A>  -->
			<A HREF="{$mod-dir}/sys/5_mim{$FILE_EXT}#{$def_ref}" TARGET="info" >Definition</A>
			<xsl:text> </xsl:text>
                        <!--
			<A 
			HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{../@name}.{@name}" 
			TARGET="info" >Long-form</A> -->
			<A 
                          HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{$lf_ref}" 
                          TARGET="info" >Long-form</A>
			<br/>
			
		</xsl:when>
		<xsl:when test="$prefix='schema'" >
 	 		<xsl:variable name="res-dir" 
				 select="concat($STEPMOD_DATA_RESOURCES,$schema-name-l)"/>
                        <xsl:text> </xsl:text>
                          &#160;&#160;<img align="middle" border="0" src="../../../../images/expg_spacer.gif" alt="space"/>
                        <!-- <A HREF="{$res-dir}/{$schema-name-l}{$FILE_EXT}#{$schema-name-l}.{@name}" TARGET="info" >Definition</A> -->
                        <A HREF="{$res-dir}/{$schema-name-l}{$FILE_EXT}#{$def_ref}" TARGET="info">Definition</A>
			<xsl:text> </xsl:text>
                        <!-- <A 
			HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{../@name}.{@name}" 
			TARGET="info" >Long-form</A> -->
                        <A 
                          HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{$lf_ref}" 
                          TARGET="info" >Long-form</A>
			<br/>
			</xsl:when>
		<xsl:when test="starts-with($schema-name,'aic_')" >
		    	<xsl:variable name="res-dir" 
				 select="concat($STEPMOD_DATA_RESOURCES,$schema-name-l)" />
                          &#160;&#160;<img align="middle" border="0" src="../../../../images/expg_spacer.gif" alt="space"/>
                        <!-- <A HREF="{$res-dir}/{$schema-name-l}{$FILE_EXT}#{$schema-name-l}.{@name}" TARGET="info" >Definition</A> -->
                        <A HREF="{$res-dir}/{$schema-name-l}{$FILE_EXT}#{$def_ref}" TARGET="info">Definition</A>
			<xsl:text> </xsl:text>
                        <!-- <A 
			HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{../@name}.{@name}" 
			TARGET="info" >Long-form</A> -->
                        <A 
                          HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{$lf_ref}" TARGET="info" >Long-form</A>
			<br/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="error_message">
				  <xsl:with-param name="inline" select="'yes'"/>
				  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
			          <xsl:with-param 
			            name="message" 
			            select="concat('Error APindex6: Unable to locate defining schema  for entity ',
				    @name, ' found in MIM Long Form')"/>
				</xsl:call-template>    	
			</xsl:otherwise>
		</xsl:choose>

		
</xsl:template>

<xsl:template match="constant" mode="module-index" >
	<xsl:param name="called-schemas" />


	<xsl:choose>
		<xsl:when test="@name='schema_name'" >

			<xsl:variable name="mod-name" select="substring-before(../@name,'_mim')" />
	
			<xsl:variable name="mod-dir" select="concat($STEPMOD_DATA_MODULES,$mod-name)" />

		
			<A HREF="{$mod-dir}/sys/5_mim{$FILE_EXT}#{../@name}.{@name}" TARGET="info" >
				<xsl:value-of select="@name" /></A>
			<br/>
	</xsl:when>
	<xsl:otherwise>
		<xsl:variable name="this-const-name" select="translate(@name,$UPPER, $LOWER)" />
		<xsl:value-of select="@name"/>
		<br/>
		<!-- find original definition -->

		<xsl:variable name="orig" 
		select="$called-schemas//constant[translate(@name,$UPPER, $LOWER)=$this-const-name]" />

		<xsl:variable name="schema-name" select="$orig/ancestor::schema/@name" />
                <xsl:variable name="schema-name-l" select="translate($schema-name, $UPPER,$LOWER)"/>

                <xsl:variable name="def_ref" select="translate(concat($schema-name,'.',@name), $UPPER,$LOWER)"/>
                <xsl:variable name="lf_ref" select="translate(concat(../@name,'.',@name), $UPPER,$LOWER)"/>

                  <xsl:variable name="prefix">
                    <xsl:call-template name="get_last_section">
                      <xsl:with-param name="path" select="$schema-name"/>
                      <xsl:with-param name="divider" select="'_'"/>
                    </xsl:call-template>
                  </xsl:variable>
                  
                  <xsl:variable name="module">
                    <xsl:call-template name="get_string_before">
                      <xsl:with-param name="str" select="$schema-name"/>
                        <xsl:with-param name="char" select="'_'"/>
                      </xsl:call-template>
                    </xsl:variable>

		<xsl:choose>
			<xsl:when test="$prefix='mim'" >
    				<xsl:variable name="mod-dir" 
				 select="translate(concat($STEPMOD_DATA_MODULES,
						$module),$UPPER,$LOWER)" />
                          &#160;&#160;<img align="middle" border="0" src="../../../../images/expg_spacer.gif" alt="space"/>
                                <!-- <A HREF="{$mod-dir}/sys/5_mim{$FILE_EXT}#{$schema-name-l}.{@name}" 
					TARGET="info" >Definition</A> -->

                                  <A HREF="{$mod-dir}/sys/5_mim{$FILE_EXT}#{$def_ref}" TARGET="info" >Definition</A>
				<xsl:text> </xsl:text>
                                <!-- <A 
			HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{../@name}.{@name}" 
				TARGET="info" >Long-form</A> -->
                                <A HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{$lf_ref}" 
				TARGET="info" >Long-form</A>
				<br/>
			
			</xsl:when>
			<xsl:when test="$prefix='schema'">
 	 			<xsl:variable name="res-dir" 
				 select="concat($STEPMOD_DATA_RESOURCES,$schema-name)" />
                          &#160;&#160;<img align="middle" border="0" src="../../../../images/expg_spacer.gif" alt="space"/>
                                <!-- <A HREF="{$res-dir}/{$schema-name}{$FILE_EXT}#{$schema-name-l}.{@name}" 
					TARGET="info" >Definition</A> -->

				<A HREF="{$res-dir}/{$schema-name}{$FILE_EXT}#{$def_ref}" TARGET="info">Definition</A>
				<xsl:text> </xsl:text>
                                <!-- <A 
			HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{../@name}.{@name}" 
				TARGET="info" >Long-form</A> -->
                                <A HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{$lf_ref}" 
				TARGET="info" >Long-form</A>
				<br/>
				</xsl:when>
				<xsl:when test="starts-with($schema-name,'aic_')" >
		    			<xsl:variable name="res-dir" 
					 select="concat($STEPMOD_DATA_RESOURCES,$schema-name)" />
                          &#160;&#160;<img align="middle" border="0" src="../../../../images/expg_spacer.gif" alt="space"/>
                                        <!-- <A
                                             HREF="{$res-dir}/{$schema-name}{$FILE_EXT}#{$schema-name-l}.{@name}"
                                             TARGET="info" >Definition</A> -->
			<A HREF="{$res-dir}/{$schema-name}{$FILE_EXT}#{$def_ref}" TARGET="info" >Definition</A>
				<xsl:text> </xsl:text>
                                <!-- <A 
			HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{../@name}.{@name}" 
				TARGET="info" >Long-form</A> -->
                                <A HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{$lf_ref}" TARGET="info">Long-form</A> 
				<br/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="error_message">
					  <xsl:with-param name="inline" select="'yes'"/>
					  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
				          <xsl:with-param 
				            name="message" 
				            select="concat('Error APindex1: Unable to locate defining schema  for constant ',
					    @name, ' found in MIM Long Form')"/>
					</xsl:call-template>    	
				</xsl:otherwise>
			</xsl:choose>
		
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template match="type" mode="module-index" >
        <xsl:param name="expressg"/>
	<xsl:param name="called-schemas" />

	<xsl:variable name="this-type-name" select="translate(@name,$UPPER, $LOWER)" />
	<xsl:value-of select="@name"/>
	<br/>
	<!-- find original definition -->

	<xsl:variable name="orig" select="$called-schemas//type[translate(@name,$UPPER, $LOWER)=$this-type-name]" />

	<xsl:variable name="schema-name" select="$orig/ancestor::schema/@name" />
	<xsl:variable name="schema-name-l" select="translate($schema-name, $UPPER,$LOWER)"/>

        <xsl:variable name="def_ref" select="translate(concat($schema-name,'.',@name), $UPPER,$LOWER)"/>
        <xsl:variable name="lf_ref" select="translate(concat(../@name,'.',@name), $UPPER,$LOWER)"/>

        <xsl:variable name="prefix">
          <xsl:call-template name="get_last_section">
            <xsl:with-param name="path" select="$schema-name"/>
            <xsl:with-param name="divider" select="'_'"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="module">
          <xsl:call-template name="get_string_before">
            <xsl:with-param name="str" select="$schema-name"/>
            <xsl:with-param name="char" select="'_'"/>
          </xsl:call-template>
        </xsl:variable>

	<xsl:choose>
		<xsl:when test="$prefix='mim'">
    			<xsl:variable name="mod-dir" 
				 select="translate(concat($STEPMOD_DATA_MODULES,
						$module),$UPPER,$LOWER)" /><xsl:apply-templates select="." mode="expressg_icon">
                            <xsl:with-param name="target" select="'info'"/>
                            <xsl:with-param name="expressg" select="$expressg"/>
                          </xsl:apply-templates> 
                          <!-- <A
                               HREF="{$mod-dir}/sys/5_mim{$FILE_EXT}#{$schema-name-l}.{@name}"
                               TARGET="info" >Definition</A> -->
                          <A HREF="{$mod-dir}/sys/5_mim{$FILE_EXT}#{$def_ref}" TARGET="info">Definition</A>
			<xsl:text> </xsl:text>
                        <!-- <A 
			HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{../@name}.{@name}" 
			TARGET="info" >Long-form</A> -->
                        <A HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{$lf_ref}" TARGET="info">Long-form</A>
			<br/>			
		</xsl:when>
		<xsl:when test="$prefix='schema'">
 	 		<xsl:variable name="res-dir" 
				 select="concat($STEPMOD_DATA_RESOURCES,$schema-name)" />
                          &#160;&#160;<img align="middle" border="0" src="../../../../images/expg_spacer.gif" alt="space"/>
                        <!-- <A
                             HREF="{$res-dir}/{$schema-name}{$FILE_EXT}#{$schema-name-l}.{@name}"
                             TARGET="info" >Definition</A> -->
			<A HREF="{$res-dir}/{$schema-name}{$FILE_EXT}#{$def_ref}" TARGET="info">Definition</A>
			<xsl:text> </xsl:text>
                        <!-- <A
			HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{../@name}.{@name}" 
			TARGET="info" >Long-form</A> -->
                        <A HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{$lf_ref}" TARGET="info">Long-form</A>
			<br/>
			</xsl:when>
		<xsl:when test="starts-with($schema-name,'aic_')" >
		    	<xsl:variable name="res-dir" 
				 select="concat($STEPMOD_DATA_RESOURCES,$schema-name)" />
                          &#160;&#160;<img align="middle" border="0" src="../../../../images/expg_spacer.gif" alt="space"/>
                        <!-- <A
                             HREF="{$res-dir}/{$schema-name}{$FILE_EXT}#{$schema-name-l}.{@name}"
                             TARGET="info">Definition</A> -->
			<A HREF="{$res-dir}/{$schema-name}{$FILE_EXT}#{$def_ref}" TARGET="info">Definition</A>
			<xsl:text> </xsl:text>
                        <!-- <A 
			HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{../@name}.{@name}" 
			TARGET="info" >Long-form</A> -->
                        <A HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{$lf_ref}" TARGET="info">Long-form</A>
			<br/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="error_message">
				  <xsl:with-param name="inline" select="'yes'"/>
				  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
			          <xsl:with-param 
			            name="message" 
			            select="concat('Error APindex2: Unable to locate defining schema  for type ',
				    @name, ' found in MIM Long Form')"/>
				</xsl:call-template>    	
			</xsl:otherwise>
		</xsl:choose>
		
</xsl:template>


<xsl:template match="subtype.constraint" mode="module-index" >
        <xsl:param name="expressg"/>
	<xsl:param name="called-schemas" />

		<xsl:variable name="mod-name" select="substring-before(../@name,'_mim')" />

		<xsl:variable name="mod-dir" select="concat($STEPMOD_DATA_MODULES,$mod-name)"/>
                <xsl:apply-templates select="." mode="expressg_icon">
                  <xsl:with-param name="target" select="'info'"/>
                  <xsl:with-param name="expressg" select="$expressg"/>
                </xsl:apply-templates> 
		<A HREF="{$mod-dir}/sys/5_mim{$FILE_EXT}#{../@name}.{@name}" TARGET="info" >
		<xsl:value-of select="@name" /></A>
			<br/>
		
</xsl:template>


<xsl:template match="rule" mode="module-index" >
	<xsl:param name="called-schemas" />

	<xsl:variable name="this-rule-name" select="@name" />
	<xsl:value-of select="@name"/>
	<br/>
	<!-- find original definition -->


	<xsl:variable name="orig" select="$called-schemas//rule[@name=$this-rule-name]" />

	<xsl:variable name="schema-name" select="$orig/ancestor::schema/@name" />
	<xsl:variable name="schema-name-l" select="translate($schema-name, $UPPER,$LOWER)" />

        <xsl:variable name="def_ref" select="translate(concat($schema-name,'.',@name), $UPPER,$LOWER)"/>
        <xsl:variable name="lf_ref" select="translate(concat(../@name,'.',@name), $UPPER,$LOWER)"/>

        <xsl:variable name="prefix">
          <xsl:call-template name="get_last_section">
            <xsl:with-param name="path" select="$schema-name"/>
            <xsl:with-param name="divider" select="'_'"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="module">
          <xsl:call-template name="get_string_before">
            <xsl:with-param name="str" select="$schema-name"/>
            <xsl:with-param name="char" select="'_'"/>
          </xsl:call-template>
        </xsl:variable>

	<xsl:choose>
		<xsl:when test="substring-before($schema-name,'_mim')" >
    			<xsl:variable name="mod-dir" 
				 select="translate(concat($STEPMOD_DATA_MODULES,
						substring-before($schema-name,'_mim')),$UPPER,$LOWER)" />
                          &#160;&#160;<img align="middle" border="0" src="../../../../images/expg_spacer.gif" alt="space"/>
                        <!-- <A
                             HREF="{$mod-dir}/sys/5_mim{$FILE_EXT}#{$schema-name-l}.{@name}"
                             TARGET="info" >Definition</A> -->
                        <A HREF="{$mod-dir}/sys/5_mim{$FILE_EXT}#{$def_ref}" TARGET="info">Definition</A>
			<xsl:text> </xsl:text>
                        <!-- <A 
			HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{../@name}.{@name}" 
			TARGET="info" >Long-form</A> -->
                        <A 
                          HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{$lf_ref}" 
                          TARGET="info">Long-form</A>
			<br/>
			
		</xsl:when>
		<xsl:when test="$prefix='schema'" >
 	 		<xsl:variable name="res-dir" 
				 select="concat($STEPMOD_DATA_RESOURCES,$schema-name)" />
                          &#160;&#160;<img align="middle" border="0" src="../../../../images/expg_spacer.gif" alt="space"/>
                        <!-- <A
                             HREF="{$res-dir}/{$schema-name}{$FILE_EXT}#{$schema-name-l}.{@name}"
                             TARGET="info" >Definition</A> -->
                        <A HREF="{$res-dir}/{$schema-name}{$FILE_EXT}#{$def_ref}" TARGET="info">Definition</A>
			<xsl:text> </xsl:text>
                        <!-- <A 
			HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{../@name}.{@name}" 
			TARGET="info" >Long-form</A> -->
                        <A 
                          HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{$lf_ref}" 
                          TARGET="info">Long-form</A>
			<br/>
			</xsl:when>
		<xsl:when test="starts-with($schema-name,'aic_')" >
		    	<xsl:variable name="res-dir" 
				 select="concat($STEPMOD_DATA_RESOURCES,$schema-name)" />
                          &#160;&#160;<img align="middle" border="0" src="../../../../images/expg_spacer.gif" alt="space"/>
                        <!-- <A
                             HREF="{$res-dir}/{$schema-name}{$FILE_EXT}#{$schema-name-l}.{@name}"
                             TARGET="info" >Definition</A> -->
                        <A HREF="{$res-dir}/{$schema-name}{$FILE_EXT}#{$def_ref}" TARGET="info">Definition</A>
			<xsl:text> </xsl:text>
                        <!-- <A 
                             HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{../@name}.{@name}" 
                             TARGET="info" >Long-form</A> -->
			<A 
                          HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{$lf_ref}" 
                          TARGET="info">Long-form</A>

			<br/>
                      </xsl:when>
                        <!-- the rule: validate_dependently_instantiable_entity_data_types
                             and function: dependently_instantiated
                             are generated by SHTOLO and therefore not in
                             any short form schema -->
		<xsl:when test="$this-rule-name='validate_dependently_instantiable_entity_data_types'">
                  &#160;&#160;<A 
			HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{$lf_ref}" 
			TARGET="info">Long-form</A>
			<br/>
                </xsl:when>
                        
			<xsl:otherwise>
				<xsl:call-template name="error_message">
				  <xsl:with-param name="inline" select="'yes'"/>
				  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
			          <xsl:with-param 
			            name="message" 
			            select="concat('Error APindex3: Unable to locate defining schema  for rule ',
				    @name, ' found in MIM Long Form')"/>
				</xsl:call-template>    	
			</xsl:otherwise>
		</xsl:choose>
		
</xsl:template>



<xsl:template match="function" mode="module-index" >
	<xsl:param name="called-schemas" />

	<xsl:variable name="this-function-name" select="@name" />
	<xsl:value-of select="@name"/>
	<br/>
	<!-- find original definition -->

	<xsl:variable name="orig" select="$called-schemas//function[@name=$this-function-name]" />

	<xsl:variable name="schema-name" select="$orig/ancestor::schema/@name" />
	<xsl:variable name="schema-name-l" select="translate($schema-name, $UPPER,$LOWER)" />

        <xsl:variable name="def_ref" select="translate(concat($schema-name,'.',@name), $UPPER,$LOWER)"/>
        <xsl:variable name="lf_ref" select="translate(concat(../@name,'.',@name), $UPPER,$LOWER)"/>

        <xsl:variable name="prefix">
          <xsl:call-template name="get_last_section">
            <xsl:with-param name="path" select="$schema-name"/>
            <xsl:with-param name="divider" select="'_'"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="module">
          <xsl:call-template name="get_string_before">
            <xsl:with-param name="str" select="$schema-name"/>
            <xsl:with-param name="char" select="'_'"/>
          </xsl:call-template>
        </xsl:variable>

	<xsl:choose>
		<xsl:when test="$prefix='mim'">
    			<xsl:variable name="mod-dir" 
				 select="translate(concat($STEPMOD_DATA_MODULES,
						$module),$UPPER,$LOWER)" />
                          &#160;&#160;<img align="middle" border="0" src="../../../../images/expg_spacer.gif" alt="space"/>
                        <!-- <A HREF="{$mod-dir}/sys/5_mim{$FILE_EXT}#{$schema-name-l}.{@name}" TARGET="info" >Definition</A> -->
                        <A HREF="{$mod-dir}/sys/5_mim{$FILE_EXT}#{$def_ref}" TARGET="info">Definition</A>
			<xsl:text> </xsl:text>
                        <!--
			<A 
			HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{../@name}.{@name}" 
			TARGET="info" >Long-form</A> -->
			<A HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{$lf_ref}" TARGET="info">Long-form</A>
			<br/>
			
		</xsl:when>
		<xsl:when test="$prefix='schema'">
 	 		<xsl:variable name="res-dir" 
				 select="concat($STEPMOD_DATA_RESOURCES,$schema-name)" />
                          &#160;&#160;<img align="middle" border="0" src="../../../../images/expg_spacer.gif" alt="space"/>
                        <!-- <A HREF="{$res-dir}/{$schema-name}{$FILE_EXT}#{$schema-name-l}.{@name}" TARGET="info" >Definition</A> -->
			<A HREF="{$res-dir}/{$schema-name}{$FILE_EXT}#{$def_ref}" TARGET="info">Definition</A>
			<xsl:text> </xsl:text>

                        <!-- <A 
			HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{../@name}.{@name}" 
			TARGET="info" >Long-form</A> -->
                        <A HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{$lf_ref}" TARGET="info">Long-form</A>
			<br/>
			</xsl:when>
		<xsl:when test="starts-with($schema-name,'aic_')" >
		    	<xsl:variable name="res-dir" 
				 select="concat($STEPMOD_DATA_RESOURCES,$schema-name)" />
                          &#160;&#160;<img align="middle" border="0" src="../../../../images/expg_spacer.gif" alt="space"/>
			<A HREF="{$res-dir}/{$schema-name}{$FILE_EXT}#{$def_ref}" TARGET="info" >Definition</A>
			<xsl:text> </xsl:text>
			<A HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{$lf_ref}" TARGET="info" >Long-form</A>
			<br/>
			</xsl:when>
                        <!-- the rule: validate_dependently_instantiable_entity_data_types
                             and function: dependently_instantiated
                             are generated by SHTOLO and therefore not in
                             any short form schema -->
		<xsl:when test="$this-function-name='dependently_instantiated'">
                  &#160;&#160;<A 
			HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{$lf_ref}" 
			TARGET="info" >Long-form</A>
			<br/>
                </xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="error_message">
				  <xsl:with-param name="inline" select="'yes'"/>
				  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
			          <xsl:with-param 
			            name="message" 
			            select="concat('Error APindex4: Unable to locate defining schema  for function ',
				    @name, ' found in MIM Long Form')"/>
				</xsl:call-template>    	
			</xsl:otherwise>
		</xsl:choose>
		
</xsl:template>

<xsl:template match="procedure" mode="module-index" >
	<xsl:param name="called-schemas" />

	<xsl:variable name="this-proc-name" select="@name" />
	<xsl:value-of select="@name"/>
	<br/>
	<!-- find original definition -->

	<xsl:variable name="orig" select="$called-schemas//procedure[@name=$this-proc-name]" />

	<xsl:variable name="schema-name" select="$orig/ancestor::schema/@name" />
	<xsl:variable name="schema-name-l" select="translate($schema-name, $UPPER,$LOWER)" />

        <xsl:variable name="def_ref" select="translate(concat($schema-name,'.',@name), $UPPER,$LOWER)"/>
        <xsl:variable name="lf_ref" select="translate(concat(../@name,'.',@name), $UPPER,$LOWER)"/>

        <xsl:variable name="prefix">
          <xsl:call-template name="get_last_section">
            <xsl:with-param name="path" select="$schema-name"/>
            <xsl:with-param name="divider" select="'_'"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="module">
          <xsl:call-template name="get_string_before">
            <xsl:with-param name="str" select="$schema-name"/>
            <xsl:with-param name="char" select="'_'"/>
          </xsl:call-template>
        </xsl:variable>

	<xsl:choose>
		<xsl:when test="$prefix='mim'">
    			<xsl:variable name="mod-dir" 
				 select="translate(concat($STEPMOD_DATA_MODULES,
						$module),$UPPER,$LOWER)" />
                          &#160;&#160;<img align="middle" border="0" src="../../../../images/expg_spacer.gif" alt="space"/>
			<A HREF="{$mod-dir}/sys/5_mim{$FILE_EXT}#{$def_ref}" TARGET="info">Definition</A>
			<xsl:text> </xsl:text>
			<A HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{$lf_ref}"	TARGET="info">Long-form</A>
			<br/>
			
		</xsl:when>
		<xsl:when test="$prefix='schema'">
 	 		<xsl:variable name="res-dir" 
				 select="concat($STEPMOD_DATA_RESOURCES,$schema-name)" />
                          &#160;&#160;<img align="middle" border="0" src="../../../../images/expg_spacer.gif" alt="space"/>
			<A HREF="{$res-dir}/{$schema-name}{$FILE_EXT}#{$def_ref}" TARGET="info">Definition</A>
			<xsl:text> </xsl:text>
			<A 
			HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{$lf_ref}" TARGET="info" >Long-form</A>
			<br/>
			</xsl:when>
		<xsl:when test="starts-with($schema-name,'aic_')" >
		    	<xsl:variable name="res-dir" 
				 select="concat($STEPMOD_DATA_RESOURCES,$schema-name)" />
                          &#160;&#160;<img align="middle" border="0" src="../../../../images/expg_spacer.gif" alt="space"/>
			<A HREF="{$res-dir}/{$schema-name}{$FILE_EXT}#{$def_ref}" TARGET="info">Definition</A>
			<xsl:text> </xsl:text>
			<A 
			HREF="{$STEPMOD_DATA_MODULES}{$ap_top_module}/sys/e_exp_mim_lf{$FILE_EXT}#{$lf_ref}" 
			TARGET="info" >Long-form</A>
			<br/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="error_message">
				  <xsl:with-param name="inline" select="'yes'"/>
				  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
			          <xsl:with-param 
			            name="message" 
			            select="concat('Error APindex5: Unable to locate defining schema  for procedure ',
				    @name, ' found in MIM Long Form')"/>
				</xsl:call-template>    	
			</xsl:otherwise>
		</xsl:choose>
		
</xsl:template>


</xsl:stylesheet>
