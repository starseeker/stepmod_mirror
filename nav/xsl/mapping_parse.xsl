<?xml version="1.0" ?>
<!--
     Stylesheet to produce check mapping table syntax
	Nigel Shaw 
-->

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
  >

  <xsl:variable name="rep_index"
    select="document('../repository_index.xml')"/>


<xsl:output method="xml" indent="yes" />

<xsl:template match="/" >

	<xsl:text disable-output-escaping="yes">&#60;&#63;xml-stylesheet type="text/xsl" href="map_test_display.xsl" &#63;&#62;</xsl:text>

	<modules>

              <xsl:apply-templates select="$rep_index//modules/module" mode="mapping-full">
                <xsl:sort select="@name"/>
              </xsl:apply-templates>
	      
	</modules>
	      

</xsl:template>




<xsl:template match="module" mode="mapping-full">

	<xsl:variable name="module_file" 
	    select="concat('../../data/modules/',@name,'/module.xml')"/>

	<xsl:variable name="module_node"
	    select="document($module_file)/module"/>


	<module>
	<xsl:attribute name="name">
		<xsl:value-of select="@name" />
	</xsl:attribute>

		<xsl:apply-templates select="$module_node//ae" />

		<xsl:apply-templates select="$module_node//aa" />

	</module>


</xsl:template>

<xsl:template match="ae">

   <mapping>
	<xsl:attribute name="entity" >
		<xsl:value-of select="@entity" />
	</xsl:attribute>

	<xsl:element name="aimelt" >
		<xsl:value-of select="aimelt" />
	</xsl:element>

	<xsl:element name="source" >
		<xsl:value-of select="../source" />
	</xsl:element>

	<xsl:apply-templates select="refpath" />
		
   </mapping>
   
</xsl:template>



<xsl:template match="refpath">

<!--
	<ORIG><xsl:value-of select="." /></ORIG> 
-->
	<refpath>
		<xsl:variable name="this-path" >
			<xsl:call-template name="space-out-path" >
				<xsl:with-param name="path" select="." />
			</xsl:call-template>		
		</xsl:variable>
		
		<xsl:call-template name="parse-refpath" >
			<xsl:with-param name="path" select="normalize-space($this-path)" />
		</xsl:call-template>

	</refpath>
		   
</xsl:template>

<xsl:template match="aa">

   <mapping>
	<xsl:attribute name="entity" >
		<xsl:value-of select="../@entity" />
	</xsl:attribute>
	<xsl:attribute name="attribute" >
		<xsl:value-of select="@attribute" />
	</xsl:attribute>
	<xsl:if test="@assertion_to" >
		<xsl:attribute name="assertion_to" >
			<xsl:value-of select="@assertion_to" />
		</xsl:attribute>
	</xsl:if>

	<xsl:element name="aimelt" >
		<xsl:value-of select="aimelt" />
	</xsl:element>

	<xsl:element name="source" >
		<xsl:value-of select="../source" />
	</xsl:element>

	<xsl:apply-templates select="refpath" />

   </mapping>
   
</xsl:template>



<xsl:template name="parse-refpath" >
	<xsl:param name="path" />
	<xsl:param name="previous" />

	<xsl:choose>
		<xsl:when test="contains($path,' ')">
		<!-- get first word and process -->

			<xsl:call-template name="process-word" >
				<xsl:with-param name="word" select="substring-before($path,' ')" />
				<xsl:with-param name="previous" select="$previous" />
			</xsl:call-template>


		<!-- recurse using remainder of string -->

			<xsl:call-template name="parse-refpath">
				<xsl:with-param name="path" select="substring-after($path,' ')" />
				<xsl:with-param name="previous" select="substring-before($path,' ')" />
			</xsl:call-template>
		
		</xsl:when>
		<xsl:otherwise>

			<xsl:call-template name="process-word" >
				<xsl:with-param name="word" select="$path" />
				<xsl:with-param name="previous" select="$previous" />
			</xsl:call-template>
			
		</xsl:otherwise>
	</xsl:choose>

</xsl:template>

<xsl:template name="space-out-path" >
	<xsl:param name="path" />
	<xsl:param name="last" />
	<xsl:variable name="first-char" select="substring($path,1,1)" />
	<xsl:choose>
		<xsl:when test="$first-char='&#x0A;'">
			<xsl:text> \n </xsl:text>
		</xsl:when>
		<xsl:when test="$first-char='{'">
			<xsl:text> { </xsl:text>
		</xsl:when>
		<xsl:when test="$first-char='}'">
			<xsl:text> } </xsl:text>
		</xsl:when>
		<xsl:when test="$first-char='='">
			<xsl:choose>
				<xsl:when test="$last='&lt;'">
					<xsl:text>= </xsl:text>
				</xsl:when>
				<xsl:when test="substring($path,2,1)='&gt;'">
					<xsl:text> =</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text> = </xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:when test="$first-char='('">
			<xsl:text> ( </xsl:text>
		</xsl:when>
		<xsl:when test="$first-char=')'">
			<xsl:text> ) </xsl:text>
		</xsl:when>
		<xsl:when test="$first-char='['">
			<xsl:text> [ </xsl:text>
		</xsl:when>
		<xsl:when test="$first-char=']'">
			<xsl:text> ] </xsl:text>
		</xsl:when>
		<xsl:when test="$first-char='*'">
			<xsl:text> * </xsl:text>
		</xsl:when>
		<xsl:when test="$first-char='\'">
			<!-- continuation line, so do nothing -->
		</xsl:when>

<!--		<xsl:when test="$first-char='&amp;apos;'">
			<xsl:choose>
				<xsl:when test="$last='&amp;apos;'">
					<xsl:text>&apos;</xsl:text>
				</xsl:when>
				<xsl:when test="substring($path,2,1)='&amp;apos;'">
					<xsl:text>&apos;</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text> &apos; </xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
-->

		<xsl:otherwise>
			<xsl:value-of select="$first-char" />
		</xsl:otherwise>
	</xsl:choose>

		<!-- recurse using remainder of string -->
		<xsl:if test="string-length($path)>1" >
			<xsl:call-template name="space-out-path">
				<xsl:with-param name="path" select="substring($path,2)" />
				<xsl:with-param name="last" select="$first-char" />
			</xsl:call-template>

		</xsl:if>

</xsl:template>


<xsl:template name="process-word" >
	<xsl:param name="word" />
	<xsl:param name="previous" />
	<xsl:if test="string-length($word)>0" >
		<xsl:choose>
			<xsl:when test="$word='\n'">
				<xsl:element name="new-line" />
			</xsl:when>
			<xsl:when test="$word='{'">
				<xsl:element name="start-constraint" />
			</xsl:when>
			<xsl:when test="$word='}'">
				<xsl:element name="end-constraint" />
			</xsl:when>
			<xsl:when test="$word='('">
				<xsl:element name="start-paren" />
			</xsl:when>
			<xsl:when test="$word=')'">
				<xsl:element name="end-paren" />
			</xsl:when>
			<xsl:when test="$word='['">
				<xsl:element name="start-bracket" />
			</xsl:when>
			<xsl:when test="$word=']'">
				<xsl:element name="end-bracket" />
			</xsl:when>
			<xsl:when test="$word='&lt;-'">
				<xsl:element name="is-pointed-at-by" />
			</xsl:when>
			<xsl:when test="$word='-&gt;'">
				<xsl:element name="points-to" />
			</xsl:when>
			<xsl:when test="$word='&lt;='">
				<xsl:element name="is-subtype-of" />
			</xsl:when>
			<xsl:when test="$word='=&gt;'">
				<xsl:element name="is-supertype-of" />
			</xsl:when>
			<xsl:when test="$word='*'">
				<xsl:element name="repeat" />
			</xsl:when>
			<xsl:when test="$word='='">
				<xsl:element name="equals" />
			</xsl:when>

			<xsl:otherwise>
				<word>
					<xsl:value-of select="$word" />
				</word>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
</xsl:template>



</xsl:stylesheet>

