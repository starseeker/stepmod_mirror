<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="../../xsl/document_xsl.xsl" ?>
<!--
$Id: arm_long_form.xsl,v 1.5 2003/07/07 10:09:35 robbod Exp $
  Author:  Nigel Shaw, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: 
  	1) To present a long form ARM schema for a module 
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		xmlns:exslt="http://exslt.org/common"
		version="1.0">


  <xsl:import href="select_view.xsl"/>



  <xsl:output method="html"/>

  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>

  <!--
  <xsl:variable name="mod_file" 
	    select="concat('../../data/modules/',/stylesheet_application[1]/@directory,'/module.xml')"/>
	    
  <xsl:variable name="module_node"
	    select="document($mod_file)"/>
  -->

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

			<xsl:call-template name="long-form-output" >
                          <xsl:with-param name="this-schema" select="$arm_node"/>
                          <xsl:with-param name="called-schemas" select="$dep-schemas" />
			</xsl:call-template>
                        
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

<!-- output all the TYPES in as a long form -->
<xsl:template name="long-form-output">
  <xsl:param name="this-schema"/>
  <xsl:param name="called-schemas"/>
  <xsl:for-each select="$this-schema//type | $called-schemas//type">
    <xsl:sort select="@name"/>
    <xsl:choose>
      <xsl:when test="./select/@basedon">
        <xsl:variable name="this_select" select="@name"/>
        <xsl:variable name="this_base" select="select/@basedon"/>
        <br/>    
        TYPE <b><xsl:value-of select="@name"/></b> = SELECT
          
        <xsl:variable name="based-on-down">
          <xsl:apply-templates select="$this-schema//type[@name=$this_base] 
                                       | $called-schemas//type[@name=$this_base]"
            mode="basedon-down">
            <xsl:with-param name="this-schema" select="$this-schema"/>
            <xsl:with-param name="called-schemas" select="$called-schemas"/>
            <xsl:with-param name="done" select="concat(' ',$this_select,' ')"/>
          </xsl:apply-templates>
        </xsl:variable>
        <!-- check if select items overlaps with already included types from lower selects -->
        <!-- should also check against subtypes of previous items ??? -->
    
        <xsl:variable name="overlap">
          <xsl:call-template name="filter-word-list" >
            <xsl:with-param name="allowed-list" select="select/@selectitems"/>
            <xsl:with-param name="word-list" select="based-on-down"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:if test="string-length($overlap) > 2" >
          <xsl:call-template name="error_message">
            <xsl:with-param name="inline" select="'yes'"/>
            <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
            <xsl:with-param name="message" 
              select="concat('Warning Sel9: Select items ', $overlap,
                      ' have already been included in a lower SELECT type.')"/>
          </xsl:call-template>               
        </xsl:if>
        
        <xsl:variable name="select-items1">
          <xsl:choose>
            <xsl:when test="select/@selectitems">
              <xsl:value-of select="concat(select/@selectitems,' ',$based-on-down)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$based-on-down"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="select-items2">
          <xsl:call-template name="remove_duplicates">
            <xsl:with-param name="list" select="$select-items1"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="select-items3">
          <xsl:call-template name="sort_list">
            <xsl:with-param name="list" select="normalize-space($select-items2)"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="select-items">
          <xsl:call-template name="output_comma_separated_list">
            <xsl:with-param name="string" select="normalize-space($select-items3)"/>
          </xsl:call-template>
        </xsl:variable>
        
        <br/>
        &#160;&#160;&#160;&#160;(<xsl:call-template name="output_line_breaks">
           <xsl:with-param name="str" select="$select-items"/>
           <xsl:with-param name="break_char" select="','"/>
         </xsl:call-template>);
         <br/>
         END_TYPE;
         <br/>
       </xsl:when>

       <xsl:when test="./select[@extensible='YES' and not(@basedon)]">
        <br/>
        TYPE <b><xsl:value-of select="@name"/></b> = SELECT
      
        <xsl:variable name="sel-items">
          <xsl:apply-templates select="." mode="basedon">
            <xsl:with-param name="this-schema" select="$this-schema"/>
            <xsl:with-param name="called-schemas" select="$called-schemas"/>
            <xsl:with-param name="done" select="' '"/>
          </xsl:apply-templates>
        </xsl:variable>
      
        <xsl:variable name="sel-items-unique">
          <xsl:call-template name="filter-word-list-unique" >
            <xsl:with-param name="word-list" select="$sel-items"/>
          </xsl:call-template>
        </xsl:variable>
          
        <xsl:variable name="select-items4">
          <xsl:call-template name="sort_list">
            <xsl:with-param name="list" select="normalize-space($sel-items-unique)"/>
          </xsl:call-template>
        </xsl:variable>
      
        <xsl:variable name="select-items5">
          <xsl:call-template name="output_comma_separated_list">
            <xsl:with-param name="string" select="normalize-space($select-items4)"/>
          </xsl:call-template>
        </xsl:variable>
      
        <br/>
        &#160;&#160;&#160;&#160;(<xsl:call-template name="output_line_breaks">
            <xsl:with-param name="str" select="$select-items5"/>
            <xsl:with-param name="break_char" select="','"/>
          </xsl:call-template>);
        <br/>
        END_TYPE;
        <br/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="code"/>
      </xsl:otherwise>

     </xsl:choose>
   </xsl:for-each>
</xsl:template>



</xsl:stylesheet>
