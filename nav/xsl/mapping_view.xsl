<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="../../xsl/document_xsl.xsl" ?>
<!--
$Id: mapping_view.xsl,v 1.1 2002/10/31 13:01:45 nigelshaw Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: A set of imported templates to set up a list of modules
     The importing file will define the modules template which
     displays the list of modules
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		xmlns:saxon="http://icl.com/saxon"
                version="1.0">

  <xsl:import href="../../xsl/express.xsl"/> 

  <xsl:import href="mapping_parse.xsl"/>


<!--  <xsl:import href="../../xsl/common.xsl"/>
-->


  <xsl:output method="html"/>

  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="NUMBERS" select="'0123456789'"/>



  <xsl:variable name="module_file" 
                select="concat('../../data/modules/',/stylesheet_application[1]/@directory,'/module.xml')"/>

  <xsl:variable name="module_node" select="document($module_file)/module"/>

  <xsl:variable name="mappings-result">
              <xsl:call-template name="mapping-full-parse"/>
  </xsl:variable>



  <xsl:template match="/" >
    <xsl:apply-templates select="./stylesheet_application"/>
  </xsl:template>

  <xsl:template match="stylesheet_application">
    <HTML>
    <head>
      <link rel="stylesheet" type="text/css" 
        href="../../../../nav/css/developer.css"/>
      <title>
        <xsl:value-of select="concat('Mapping analysis for ',@directory)"/>
      </title>

    </head>
  <body>

<H1> Mapping analysis </H1>

      <xsl:choose>
	<xsl:when test="function-available('msxsl:node-set')">
	  <xsl:apply-templates select="msxsl:node-set($mappings-result)/module" mode="output-list"/>

	</xsl:when>
	
	<xsl:when test="function-available('saxon:node-set')">
	  <xsl:apply-templates select="saxon:node-set($mappings-result)/module" mode="output-list"/>
	</xsl:when>

	<xsl:otherwise>
		<br/>
		STYLESHEET set up to work with msxsl: and saxon:. Neither is available.
		<br/>
	</xsl:otherwise>


      </xsl:choose>	

  </body>
</HTML>
</xsl:template>

<xsl:template name="mapping-full-parse">
	
	<module>
	<xsl:attribute name="name">
		<xsl:value-of select="/stylesheet_application/@directory" />
	</xsl:attribute>

		<xsl:apply-templates select="$module_node//ae" />

		<xsl:apply-templates select="$module_node//aa" />

	</module>


</xsl:template>


<xsl:template match="module" mode="output" >
	
	<blockquote>
	<TABLE Width="95%" border="3">
	<TR>
		<TD>Target</TD>
		<TD>AIM element</TD>
		<TD> Source</TD>
		<TD> Reference Path</TD>
	</TR>

	<xsl:apply-templates select="mapping" mode="output">
		<xsl:sort select="@entity" />
		<xsl:sort select="@attribute" />
	</xsl:apply-templates>
	</TABLE>
	</blockquote>



</xsl:template>

<xsl:template match="module" mode="output-list" >
	
	<xsl:apply-templates select="mapping" mode="output-list">
		<xsl:sort select="@entity" />
		<xsl:sort select="@attribute" />
	</xsl:apply-templates>



</xsl:template>


<xsl:template match="mapping" mode="output-list" >

	<H3>
		<xsl:value-of select="@entity" />
		<xsl:if test="@attribute" >.<xsl:value-of select="@attribute" />
		</xsl:if>
		<xsl:if test="@assertion_to" > Assertion to: <xsl:value-of select="@assertion_to" />
		</xsl:if>
	</H3>
	<blockquote>
		<xsl:choose>
		<xsl:when test="@original_module" >
			Original entity mapping defined in module: 
			<xsl:value-of select="@original_module" />
			<hr/>

		</xsl:when>
		<xsl:otherwise>
			MIM element: <xsl:apply-templates select="aimelt" />
			<br/>
			Source: <xsl:apply-templates select="source" />
		
			<hr/>

		</xsl:otherwise>
		</xsl:choose>

		<xsl:choose>
			<xsl:when test="alt-map" >
				<xsl:apply-templates select="alt-map" />
				
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="refpath" />
				<hr/>

				<xsl:apply-templates select="refpath" mode="test"/>

			</xsl:otherwise>
		
		</xsl:choose>

		<xsl:if test="@assertion_to" >
			<xsl:if test="@assertion_to = translate(@assertion_to,$UPPER,'')" >
			!! <xsl:value-of select="@assertion_to" /> must be a SELECT type !!<br/>
			</xsl:if>
		
		</xsl:if>

	</blockquote>
	<hr/>

</xsl:template>


<xsl:template match="mapping" mode="output" >


	<TR>
		<TD>
		<xsl:value-of select="@entity" />
		<xsl:if test="@attribute" >.<br/><xsl:value-of select="@attribute" />
		</xsl:if>
		<xsl:if test="@assertion_to" ><br/>Assertion to: <xsl:value-of select="@assertion_to" />
		</xsl:if>
	
		</TD>
		<TD>
			<xsl:apply-templates select="aimelt" />

		</TD>
		<TD>
			<xsl:apply-templates select="source" />

		</TD>
<!--		<TD>
			<xsl:apply-templates select="refpath" mode="test"/>

		</TD>
-->
		<TD>
			<xsl:apply-templates select="refpath" />

		</TD>
	</TR>
</xsl:template>

<xsl:template match="alt-map" >

	<h4> Alternative #<xsl:value-of select="@id" /></h4>
	<p><xsl:value-of select="description" /></p>
	<blockquote>
	
		MIM element: <xsl:apply-templates select="aimelt" />
		<br/>
		Source: <xsl:apply-templates select="source" />
		<hr/>
		<xsl:apply-templates select="refpath" />
		<hr/>
		<xsl:apply-templates select="refpath" mode="test"/>
		<hr/>
	</blockquote>
	

</xsl:template>


<xsl:template match="refpath" >
	<xsl:apply-templates select="./*" />	
</xsl:template>

<xsl:template match="new-line" >
	<br/>
</xsl:template>

<xsl:template match="start-constraint" >
	{
</xsl:template>

<xsl:template match="end-constraint" >
	}
</xsl:template>

<xsl:template match="start-paren" >
	(
</xsl:template>

<xsl:template match="end-paren" >
	)
</xsl:template>

<xsl:template match="start-bracket" >
	[
</xsl:template>

<xsl:template match="end-bracket" >
	]
</xsl:template>

<xsl:template match="equals" >
	=
</xsl:template>

<xsl:template match="vertical-bar" >
	|
</xsl:template>


<xsl:template match="is-pointed-at-by" >
	<xsl:text> &lt;- </xsl:text>
</xsl:template>

<xsl:template match="points-to" >
	<xsl:text> -&gt; </xsl:text>
</xsl:template>

<xsl:template match="is-subtype-of" >
	<xsl:text> &lt;= </xsl:text>
</xsl:template>

<xsl:template match="is-supertype-of" >
	<xsl:text> =&gt; </xsl:text>
</xsl:template>

<xsl:template match="repeat" >
	<xsl:text>*</xsl:text>
</xsl:template>

<xsl:template match="is-extension-of" >
	<xsl:text> &lt;* </xsl:text>
</xsl:template>

<xsl:template match="is-extension-from" >
	<xsl:text> *&gt; </xsl:text>
</xsl:template>

<xsl:template match="subtype-template" >
	<xsl:text> /SUBTYPE </xsl:text>
</xsl:template>

<xsl:template match="supertype-template" >
	<xsl:text> /SUPERTYPE </xsl:text>
</xsl:template>


<!-- <xsl:template match="SELF" >
	<xsl:text> SELF\</xsl:text>
</xsl:template>
-->

<xsl:template match="aimelt" >
<!--	<xsl:value-of select="." />
	<xsl:if test="contains(.,'&#x0A;')" >ZZ</xsl:if>
-->
	<xsl:choose>
		<xsl:when test="contains(.,'&#x0A;')" >
		<!-- more than one MIM element - separate by <br/>  ???TO-DO??? -->
				<xsl:value-of select="." />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="." />
			</xsl:otherwise>
	</xsl:choose>
</xsl:template>



<xsl:template match="word" >
	<xsl:value-of select="." />
	<xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="refpath" mode="test">

	<xsl:if test="count(./start-paren) != count(./end-paren)" >
		
		<!-- !! MISMATCH in () !! -->
		<xsl:call-template name="error_message">
			  <xsl:with-param name="inline" select="'yes'"/>
			  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
		          <xsl:with-param 
		            name="message" 
		            select="'Error Map3: MISMATCH in () '"/>
		</xsl:call-template>    
	</xsl:if>

	<xsl:if test="count(./start-constraint) != count(./end-constraint)" >
		<!-- !! MISMATCH in {} !! -->
		<xsl:call-template name="error_message">
			  <xsl:with-param name="inline" select="'yes'"/>
			  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
		          <xsl:with-param 
		            name="message" 
		            select="'Error Map3: MISMATCH in {} '"/>
		</xsl:call-template>    
	</xsl:if>

	<xsl:if test="count(./start-bracket) != count(./end-bracket)" >
		<!-- !! MISMATCH in [] !! -->
		<xsl:call-template name="error_message">
			  <xsl:with-param name="inline" select="'yes'"/>
			  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
		          <xsl:with-param 
		            name="message" 
		            select="'Error Map3: MISMATCH in [] '"/>
		</xsl:call-template>    
	</xsl:if>

<!--	<xsl:if test="is-supertype-of[name(following-sibling::*[1]) !='new-line']" > -->
		<!-- !! Newline missing following =&gt; !! -->
<!--		<xsl:call-template name="error_message">
			  <xsl:with-param name="inline" select="'yes'"/>
			  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
		          <xsl:with-param 
		            name="message" 
		            select="'Error Map4: Newline missing following =&gt;'"/>
		</xsl:call-template>    
	</xsl:if>
-->
<!--	<xsl:if test="is-subtype-of[name(following-sibling::*[1]) !='new-line']" > -->
		<!-- !! Newline missing following &lt;= !! -->
<!--		<xsl:call-template name="error_message">
			  <xsl:with-param name="inline" select="'yes'"/>
			  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
		          <xsl:with-param 
		            name="message" 
		            select="'Error Map5: Newline missing following &lt;='"/>
		</xsl:call-template>    
	</xsl:if>
-->
<!--	<xsl:if test="points-to[name(following-sibling::*[1]) !='new-line']" > -->

		<!-- !! Newline missing following -&gt; !! -->
<!--		<xsl:call-template name="error_message">
			  <xsl:with-param name="inline" select="'yes'"/>
			  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
		          <xsl:with-param 
		            name="message" 
		            select="'Error Map6: Newline missing following -&gt;'"/>
		</xsl:call-template>    
	</xsl:if>
-->
<!--
	<xsl:if test="is-pointed-at-by[name(following-sibling::*[1]) !='new-line']" > -->
		<!-- !! Newline missing following &lt;- !! -->
<!--		<xsl:call-template name="error_message">
			  <xsl:with-param name="inline" select="'yes'"/>
			  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
		          <xsl:with-param 
		            name="message" 
		            select="'Error Map7: Newline missing following &lt;-'"/>
		</xsl:call-template>    
	</xsl:if>
-->
	<xsl:if test="is-pointed-at-by[name(preceding-sibling::*[1]) !='word']" >
		<!-- ?? Possible wrong item preceding &lt;- !! -->
		<xsl:call-template name="error_message">
			  <xsl:with-param name="inline" select="'yes'"/>
			  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
		          <xsl:with-param 
		            name="message" 
		            select="'Warning Map8: Possible wrong item preceding &lt;-'"/>
		</xsl:call-template>    
	</xsl:if>

	<xsl:if test="is-pointed-at-by[contains(preceding-sibling::*[1],'.')]" >
		<!-- !! Entity.Attribute should not precede &lt;- !! -->
		<xsl:call-template name="error_message">
			  <xsl:with-param name="inline" select="'yes'"/>
			  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
		          <xsl:with-param 
		            name="message" 
		            select="'Error Map9: !! Entity.Attribute should not precede &lt;-'"/>
		</xsl:call-template>    
	</xsl:if>

	<xsl:if test="is-subtype-of[contains(preceding-sibling::*[1],'.')]" >
		<!-- !! Entity.Attribute should not precede &lt;= !! -->
		<xsl:call-template name="error_message">
			  <xsl:with-param name="inline" select="'yes'"/>
			  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
		          <xsl:with-param 
		            name="message" 
		            select="'Error Map10: !! Entity.Attribute should not precede &lt;='"/>
		</xsl:call-template>    
	</xsl:if>


	<xsl:if test="repeat[name(preceding-sibling::*[1]) !='end-paren']" >
		<!-- !! Repeat "*" not preceded by ")" !! -->
		<xsl:call-template name="error_message">
			  <xsl:with-param name="inline" select="'yes'"/>
			  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
		          <xsl:with-param 
		            name="message" 
		            select="'Error Map11: Repeat * not preceded by ) '"/>
		</xsl:call-template>    
	</xsl:if>

	<xsl:if test="string-length(../@entity) - string-length(translate(../@entity,$UPPER,'')) > 1" >
		<!-- !! Only 1 Uppercase character expected in "Entity" name !! -->
		<xsl:call-template name="error_message">
			  <xsl:with-param name="inline" select="'yes'"/>
			  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
		          <xsl:with-param 
		            name="message" 
		            select="concat('Error Map12: Only 1 Uppercase character expected in Entity name: ',../@entity)"/>
		</xsl:call-template>    
	</xsl:if>

	<xsl:if test="contains(../@attribute,' ')" >
		<!-- !! Spaces not expected in "attribute" name  !! -->
		<xsl:call-template name="error_message">
			  <xsl:with-param name="inline" select="'yes'"/>
			  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
		          <xsl:with-param 
		            name="message" 
		            select="concat('Error Map13: Spaces not expected in attribute name: [',../@attribute,']')"/>
		</xsl:call-template>    
	</xsl:if>

	<xsl:if test="string-length(../@attribute) != string-length(translate(../@attribute,$UPPER,''))" >
		<!-- !! Uppercase characters not expected in "attribute" name !! -->
		<xsl:call-template name="error_message">
			  <xsl:with-param name="inline" select="'yes'"/>
			  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
		          <xsl:with-param 
		            name="message" 
		            select="concat('Error Map14: Uppercase characters not expected in attribute name: ',
			    		../@attribute)"/>
		</xsl:call-template>    
	</xsl:if>


	<xsl:apply-templates select="word" mode="test" />


</xsl:template>

<xsl:template match="word" mode="test">
	<xsl:if test="string-length(.) != string-length(translate(.,$UPPER,''))" >
		!! UPPERCASE Not expected: <xsl:value-of select="." /> !!<br/>
	</xsl:if>
	<xsl:if test="string-length(.) = 1 and not (contains($NUMBERS,.))" >
		<xsl:choose>
			<xsl:when test="name(preceding-sibling::*[1]) ='start-bracket' and 
					name(following-sibling::*[1]) ='end-bracket' ">
			</xsl:when>
			<xsl:when test=".='/'">
			</xsl:when>
			<xsl:otherwise>
				<!-- ?? Possible syntax ERROR: <xsl:value-of select="." /> !! -->
				<xsl:call-template name="error_message">
				  <xsl:with-param name="inline" select="'yes'"/>
				  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
			          <xsl:with-param 
			            name="message" 
			            select="concat('Error Map15: Possible syntax ERROR: ',.)"/>
				</xsl:call-template>    
			</xsl:otherwise>
		</xsl:choose>
	
	</xsl:if>

</xsl:template>



</xsl:stylesheet>
