<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="../../xsl/document_xsl.xsl" ?>

<!--
     $Id: repository_dependencies.xsl,v 1.1 2002/09/10 09:42:40 nigelshaw Exp $

  Author: Nigel Shaw and Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep and supplied to NIST under contract.
  Purpose: 
     Used to display the index of modules and their dependencies.  
-->


<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>

  <xsl:import href="../../xsl/common.xsl"/>

  <xsl:output method="html"/>

	<xsl:variable name="rep-index"
	    select="document('../../repository_index.xml')"/>



<!-- 		establish global variable with list of interface calls 
		List is of form x#y separated by spaces where 
		x is a schema called by schema y 
-->

  <xsl:variable name="calls-list">
  	<xsl:apply-templates select="$rep-index//module" mode="depend" />
  </xsl:variable>

<!-- 		establish global variable with list of interface calls 
		List is of form x#y separated by spaces where 
		y is a schema called by schema x 
-->

  <xsl:variable name="calls-list-down">
  	<xsl:apply-templates select="$rep-index//module" mode="depend2" />
  </xsl:variable>


<xsl:template match="/" >
	<xsl:apply-templates select="$rep-index/repository_index" />
</xsl:template>


<xsl:template match="repository_index" >
  <HTML>
    <HEAD>
      <!-- apply a cascading stylesheet.
           the stylesheet will only be applied if the parameter output_css
           is set in parameter.xsl 
           -->
      <xsl:call-template name="output_css">
        <xsl:with-param name="override_css" select="'stepmod.css'"/>
        <xsl:with-param name="path" select="'./css/'"/>
      </xsl:call-template>
      <TITLE>Module repository dependencies</TITLE>
    </HEAD>
    <BODY>
            <h2>
              <a name="alphatop">
                Modules and their dependencies
              </a>
            </h2>
            <p> Shows which modules use and are used by each module's ARM. 
	    Links in the Depends on and Used by columns take you to the entry in this table for the named module.<br/>
	    Each cell shows the modules used directly above the line and 
	    the full set of dependent/using modules below the line.
            </p>
  
        <table width="80%" border="3" cellspacing="0" cellpadding="4">
	<tr>
		<td>Module
		</td>
		<td>Depends on
		</td>
		<td>Used by
		</td>
	</tr>
              <xsl:apply-templates select="./modules/module" mode="output-full">
                <xsl:sort select="@name"/>
              </xsl:apply-templates>
        </table>
    </BODY>
  </HTML>
</xsl:template>



<xsl:template match="module" mode="output-full">
  <xsl:variable name="xref"
    select="concat('../data/modules/',@name,'/sys/introduction',$FILE_EXT)"/>
  <xsl:variable name="part">
    <xsl:call-template name="get_module_part">
      <xsl:with-param name="module_name" select="@name"/>
    </xsl:call-template>
  </xsl:variable>
	<TR>
	<TD valign="Top">

  <a href="{$xref}">
    <font size="-1">
      <xsl:value-of select="@name"/> <br/>
	(<xsl:value-of select="$part"/>) <br/>
    </font>
  </a>

<!--
  <xsl:variable name="xref4"
    select="concat('../data/modules/',@name,'/sys/4_info_reqs',$FILE_EXT)"/>

  <xsl:variable name="arm_expg"
    select="concat('../data/modules/',@name,'/armexpg1',$FILE_EXT)"/>
  
  <xsl:variable name="xref5"
    select="concat('../data/modules/',@name,'/sys/5_mim',$FILE_EXT)"/>
   
  <xsl:variable name="mim_expg"
    select="concat('../data/modules/',@name,'/mimexpg1',$FILE_EXT)"/>

  <xsl:variable name="mod_directory"
    select="concat('../data/modules/',@name)"/>

  <table cellspacing="0" cellpadding="1">
    <tr>
      <td>&#160;&#160;&#160;&#160;</td>
      <td>
        <font size="-2">
          <a href="{$xref4}">ARM</a>
        </font>
      </td>
      <td>
        <font size="-2">
          <a href="{$arm_expg}">ARM-G</a>
        </font>
      </td>
      <td>
        <font size="-2">
          <a href="{$xref5}">MIM</a>
        </font>
      </td>
      <td>
        <font size="-2">
          <a href="{$mim_expg}">MIM-G</a>
        </font>
      </td>
      <td>
        <font size="-2">
          <a href="{$mod_directory}">
            <img alt="module folder" 
              border="0"
              align="middle"
              src="./images/folder.gif"/>
          </a>
        </font>
      </td>

      </tr>
    </table>

-->
    
    </TD>

    <xsl:call-template name="get_module_details">
      <xsl:with-param name="module_name" select="@name"/>
    </xsl:call-template>


    
    </TR>
</xsl:template>


<xsl:template name="get_module_part">
  <xsl:value-of select="@part"/>
</xsl:template>


<xsl:template name="get_module_details">
	<xsl:param name="module_name"/>

	<xsl:variable name="module_file" 
	    select="concat('../../data/modules/',$module_name,'/module.xml')"/>

	<xsl:variable name="arm_file" 
	    select="concat('../../data/modules/',$module_name,'/arm.xml')"/>

	<xsl:variable name="arm_node"
	    select="document($arm_file)/express"/>

	<xsl:variable name="schema-name"
	    select="$arm_node//schema/@name"/>


	<TD valign="top">
	    <font size="-1">

		<a name="#{$schema-name}"/>
		<xsl:apply-templates select="$arm_node//schema/interface" mode="depends-on" />
	    </font>
	    <hr/>
	    <font size="-1">
		<xsl:call-template name="depend-find-recurse" >
			<xsl:with-param name="call-list" select="$calls-list-down" />
			<xsl:with-param name="to-do" select="$schema-name" />
			<xsl:with-param name="done" select="concat(' ',$schema-name,' ')" />
		</xsl:call-template>
	    </font>
	
	</TD>

	<TD valign="top">
	    <font size="-1">
		<xsl:call-template name="depend-find" >
			<xsl:with-param name="call-list" select="$calls-list" />
			<xsl:with-param name="mod-name" select="$schema-name" />
		</xsl:call-template>
	    </font>
	    <hr/>
	    <font size="-1">
		<xsl:call-template name="depend-find-recurse" >
			<xsl:with-param name="call-list" select="$calls-list" />
			<xsl:with-param name="to-do" select="$schema-name" />
			<xsl:with-param name="done" select="concat(' ',$schema-name,' ')" />
		</xsl:call-template>
	    </font>
	</TD>


</xsl:template>

<xsl:template match="module" mode="depend">
	<xsl:variable name="arm_file" 
	    select="concat('../../data/modules/',@name,'/arm.xml')"/>
	<xsl:variable name="arm_node"
	    select="document($arm_file)/express"/>

		<xsl:apply-templates select="$arm_node//schema/interface" mode="depend" />

</xsl:template>

<xsl:template match="interface" mode="depend">
	<xsl:value-of select="concat(' ',@schema,'#',../@name,' ')" />
</xsl:template>

<xsl:template match="module" mode="depend2">
	<xsl:variable name="arm_file" 
	    select="concat('../../data/modules/',@name,'/arm.xml')"/>
	<xsl:variable name="arm_node"
	    select="document($arm_file)/express"/>

		<xsl:apply-templates select="$arm_node//schema/interface" mode="depend2" />

</xsl:template>

<xsl:template match="interface" mode="depend2">
	<xsl:value-of select="concat(' ',../@name,'#',@schema,' ')" />
</xsl:template>


<xsl:template match="interface" mode="depends-on">
	
	<a href="#{@schema}">
		<xsl:value-of select="concat(' ',@schema,' ')" />
	</a>
	<br/>
</xsl:template>

<xsl:template name="depend-find" >
	<xsl:param name="call-list" />
	<xsl:param name="mod-name" />

	<xsl:variable name="after" select="substring-after($call-list, concat(' ',$mod-name,'#'))" />

		<xsl:if test="$after">
		<!-- get first  -->
			<xsl:variable name="first" select="substring-before($after,' ')" />
		
			<a href="#{$first}" >
			<xsl:value-of select="$first" />
			</a>
			<br/>

		<!-- recurse using remainder of string -->

			<xsl:call-template name="depend-find">
				<xsl:with-param name="call-list" select="substring-after($after,' ')" />
				<xsl:with-param name="mod-name" select="$mod-name" />
			</xsl:call-template>
		
		</xsl:if>

</xsl:template>

<xsl:template name="depend-find-string" >
	<xsl:param name="call-list" />
	<xsl:param name="mod-name" />
	<xsl:param name="done" />

	<xsl:variable name="after" select="substring-after($call-list, concat(' ',$mod-name,'#'))" />

		<xsl:if test="$after">
		<!-- get first  -->
			<xsl:variable name="first" select="concat(' ',substring-before($after,' '),' ')" />
		<xsl:if test="not(contains($done, $first))" >
			<xsl:value-of select="concat(' ',$first,' ')" />
		</xsl:if>

		<!-- recurse using remainder of string -->

			<xsl:call-template name="depend-find-string">
				<xsl:with-param name="call-list" select="substring-after($after,' ')" />
				<xsl:with-param name="mod-name" select="$mod-name" />
				<xsl:with-param name="done" select="concat($done,$first)" />
			</xsl:call-template>
		
		</xsl:if>

</xsl:template>


<xsl:template name="depend-find-recurse" >
	<xsl:param name="call-list" />
	<xsl:param name="to-do" />
	<xsl:param name="done" />
	<xsl:param name="level"  select="1"/>


	<xsl:variable name="this-schema" select="substring-before(concat(normalize-space($to-do),' '),' ')" />

		<xsl:if test="$this-schema" >

			<xsl:if test="not(contains($done,$this-schema))" >
				<a href="#{$this-schema}" >
				<xsl:value-of select="$this-schema" /> 
				</a> 
				<br/>
			</xsl:if>

<!-- get the list of schemas for this level that have not already been done -->

			<xsl:variable name="my-kids" >
				<xsl:call-template name="depend-find-string">
					<xsl:with-param name="call-list" select="$call-list" />
					<xsl:with-param name="mod-name" select="$this-schema" />
					<xsl:with-param name="done" select="concat($done,' ',$this-schema,' ')" />
				</xsl:call-template>
			</xsl:variable>

			<xsl:variable name="after" select="normalize-space(concat(substring-after($to-do, $this-schema),$my-kids))" />

<!-- 
<hr/>
XXX<xsl:value-of select="$to-do" />XXX<br/>
<xsl:value-of select="$done" />XXX
<hr/>
-->
			<xsl:if test="$after" >
				<xsl:call-template name="depend-find-recurse">
					<xsl:with-param name="call-list" select="$call-list" />
					<xsl:with-param name="to-do" select="$after" />
					<xsl:with-param name="done" select="concat($done,' ',$this-schema,' ')" />
					<xsl:with-param name="level" select="$level + 1" />
				</xsl:call-template>

	
			</xsl:if>

		</xsl:if>

</xsl:template>


</xsl:stylesheet>
