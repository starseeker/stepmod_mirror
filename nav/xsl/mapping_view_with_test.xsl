<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="../../xsl/document_xsl.xsl" ?>
<!--
$Id: mapping_view_with_test.xsl,v 1.14 2013/10/25 15:46:44 thomasrthurman Exp $
  Author:  Nigel Shaw, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: Check the syntax and content of mappings
  This version uses a list of schemas compiled by recursively descending the mim files by schema. 
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		xmlns:exslt="http://exslt.org/common"
                exclude-result-prefixes="msxsl exslt"
                version="1.0">

  <xsl:import href="../../xsl/express.xsl"/> 

  <xsl:import href="mapping_parse.xsl"/>
  <xsl:import href="mim_tree.xsl"/>


<!--  <xsl:import href="../../xsl/common.xsl"/>
-->


  <xsl:output method="html"/>

  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="NUMBERS" select="'0123456789'"/>


  <xsl:variable name="mappings-result">
              <xsl:call-template name="mapping-full-parse"/>
  </xsl:variable>

<!-- need to check that the schema-name is x_mim - to prevent missing file message -->

  <xsl:variable name="mim_file" 
                select="concat('../../data/modules/',/stylesheet_application[1]/@directory,'/mim.xml')"/>

  <xsl:variable name="mim_node" select="document($mim_file)/express"/>

  <xsl:variable name="mim_schema_name" select="$mim_node//schema/@name"/>

  <xsl:variable name="arm_file" 
                select="concat('../../data/modules/',/stylesheet_application[1]/@directory,'/arm.xml')"/>

  <xsl:variable name="arm_node" select="document($arm_file)/express"/>

  <xsl:variable name="schema-name" select="concat(/stylesheet_application[1]/@directory,'_mim')"/>

  <xsl:variable name="pseudo-schema-name" select="concat(/stylesheet_application[1]/@directory,'_pseudo_long_form_mim')"/>


  <xsl:variable name="schemas" >
	<xsl:choose>
		<xsl:when test="$schema-name = translate($mim_schema_name,$UPPER,$LOWER)" >
	  		<xsl:call-template name="depends-on-recurse-mim-x">
				<xsl:with-param name="todo" select="concat(' ',$schema-name,' ')" />
<!--				<xsl:with-param name="done" select="concat(' ',$schema-name,' ')" />
-->
				<xsl:with-param name="done" select="' '" />
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>BAD MIM SCHEMA NAME</xsl:otherwise>
	</xsl:choose>
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
	<xsl:when test="$schemas='BAD MIM SCHEMA NAME'" >
		<xsl:call-template name="error_message">
			  <xsl:with-param name="inline" select="'yes'"/>
			  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
		          <xsl:with-param 
		            name="message" 
		            select="concat('Error Map19: MIM schema name (',$mim_schema_name,') not correct. Should be ',
			    			$schema-name)"/>
		</xsl:call-template>    	
	</xsl:when>

	<xsl:when test="function-available('msxsl:node-set')">

        	<xsl:variable name="schemas-node-set" select="msxsl:node-set($schemas)" />

		<xsl:variable name="dep-schemas3">
			<xsl:for-each select="$schemas-node-set//x" >
				<xsl:copy-of select="document(.)" />
			</xsl:for-each>
		</xsl:variable>

		<xsl:variable name="dep-schemas" 
			  	select="msxsl:node-set($dep-schemas3)" />

		  <xsl:apply-templates select="msxsl:node-set($mappings-result)/module/mapping" mode="output-list">
			<xsl:with-param name="schemas" select="$dep-schemas" />
			<xsl:sort select="@entity" />
			<xsl:sort select="@attribute" />
		  </xsl:apply-templates>

		<xsl:call-template name="mim-schema-list" >
			<xsl:with-param name="schemas" select="$dep-schemas" />			
		</xsl:call-template>

		<xsl:call-template name="mim-lf-construct1" >
			<xsl:with-param name="schemas"  select="$dep-schemas" />			
			<xsl:with-param name="mappings"  select="msxsl:node-set($mappings-result)/module/mapping" />			
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



		<xsl:apply-templates select="exslt:node-set($mappings-result)/module/mapping" mode="output-list">
			<xsl:with-param name="schemas" select="$dep-schemas" />
			<xsl:sort select="@entity" />
			<xsl:sort select="@attribute" />
		  </xsl:apply-templates>

		<xsl:call-template name="mim-schema-list" >
			<xsl:with-param name="schemas" select="$dep-schemas" />			
		</xsl:call-template>

		<xsl:call-template name="mim-lf-construct1" >
			<xsl:with-param name="schemas"  select="$dep-schemas" />			
			<xsl:with-param name="mappings"  select="exslt:node-set($mappings-result)/module/mapping" />			
		</xsl:call-template>


	  </xsl:when>

	<xsl:otherwise>
		<br/>
		STYLESHEET set up to work with msxsl: and exslt:. Neither is available.
		<br/>
	</xsl:otherwise>


      </xsl:choose>	


  </body>
</HTML>
</xsl:template>

<xsl:template name="mapping-full-parse">


  <xsl:variable name="module_file" 
                select="concat('../../data/modules/',/stylesheet_application/@directory,'/module.xml')"/>


  <xsl:variable name="module_node" select="document($module_file)/module"/>

	
	<module>
	<xsl:attribute name="name">
		<xsl:value-of select="/stylesheet_application/@directory" />
	</xsl:attribute>

		<xsl:apply-templates select="$module_node//ae" />

		<xsl:apply-templates select="$module_node//aa" />

	</module>


</xsl:template>


<!--
<xsl:template match="module" mode="output-list" >
	<xsl:param name="schemas" />	
	<xsl:apply-templates select="mapping" mode="output-list">
		<xsl:sort select="@entity" />
		<xsl:sort select="@attribute" />
	</xsl:apply-templates>

</xsl:template>
-->

<xsl:template match="mapping" mode="output-list" >
	<xsl:param name="schemas" />	

	<H3>
		<xsl:value-of select="@entity" />
		<xsl:if test="@attribute" >.<xsl:value-of select="@attribute" />
		</xsl:if>
		<xsl:if test="@assertion_to" > Assertion to: <xsl:value-of select="@assertion_to" />
		</xsl:if>
	</H3>
	<blockquote>

		<xsl:variable name="the-ent" select="@entity" />
		<xsl:variable name="the-attr" select="@attribute" />
	
		<xsl:if test="not(@original_module) and not(@attribute)" >
			<xsl:if test="not($arm_node//entity[@name=$the-ent])" >
				<xsl:call-template name="error_message">
				  <xsl:with-param name="inline" select="'yes'"/>
				  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
			          <xsl:with-param 
			            name="message" 
			            select="concat('Error Map22: ',$the-ent,' is not an ARM ENTITY type')"/>
				</xsl:call-template>    
			
			</xsl:if>
		</xsl:if>

		<xsl:if test="@assertion_to" >
		<xsl:choose>
			<xsl:when test="@assertion_to = translate(@assertion_to,$UPPER,'')" >
				<xsl:value-of select="@assertion_to" /> as reference by "Assertion to" must be an ARM SELECT type
				<br/>

				<xsl:variable name="this_sel" select="@assertion_to" />
				<xsl:variable name="this_sel_space" select="concat(' ',@assertion_to,' ')" />
				
				<xsl:if test="not($arm_node//type[@name=$this_sel][select]
				        | $arm_node//typename[@name=$this_sel]
					| $arm_node//type/select[contains(concat(' ',@selectitems,' '), $this_sel_space)])" >
					<xsl:call-template name="error_message">
					  <xsl:with-param name="inline" select="'yes'"/>
					  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
				          <xsl:with-param 
				            name="message" 
				            select="concat('Error Map27: ',$this_sel,' is not an ARM SELECT type')"/>
					</xsl:call-template>    
				
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>

				<xsl:variable name="this_ent" select="@assertion_to" />

				<xsl:choose>
				<xsl:when test="$arm_node//entity[@name=$this_ent] | $arm_node//typename[@name=$this_ent] 
				 | $arm_node//type/select[contains(concat(' ',@selectitems,' '),concat(' ',$this_ent,' '))]
				 " >
				 	<xsl:value-of select="$this_ent" /> referenced within the arm
					<br/>
					<br/>
				</xsl:when>
				<xsl:otherwise>
				 	!! <xsl:value-of select="$this_ent" /> NOT referenced within the arm !!
					<br/>
					<br/>
				</xsl:otherwise>
				</xsl:choose>

			</xsl:otherwise>
		</xsl:choose>
		</xsl:if>



		<xsl:choose>
		<xsl:when test="@original_module" >
			Original entity mapping defined in module: 
			<xsl:value-of select="@original_module" />
			<hr/>

		</xsl:when>
		<xsl:otherwise>
			MIM element: <xsl:apply-templates select="aimelt" />
			<br/>
		<xsl:if test="string-length(aimelt) > 2" >

			<xsl:choose>
				<xsl:when test="normalize-space(aimelt) = 'PATH'" >
				<!-- do nothing - except check that a refpath exists -->
					<xsl:if test="not( refpath/word | alt-map/refpath/word )" >
						<xsl:call-template name="error_message">
							  <xsl:with-param name="inline" select="'yes'"/>
							  <xsl:with-param name="warning_gif" 
							    select="'../../../../images/warning.gif'"/>
						          <xsl:with-param 
						            name="message" 
						            select="'Error Map20: MIM element specified as PATH but no path given'"/>
						</xsl:call-template>    
					</xsl:if>
				</xsl:when>			
				<xsl:when test="normalize-space(aimelt) = 'IDENTICAL MAPPING'" >
				<!-- do nothing - except check that a refpath exists ???? to do ????-->
				</xsl:when>	
				<xsl:when test="normalize-space(aimelt) = 'NO MAPPING EXTENSION PROVIDED'" >
					<!-- do nothing - except check that a refpath exists ???? to do ????-->
				</xsl:when>
				<xsl:when test="contains(aimelt,'&#x0A;')" >
				<!-- multi-line mapping case ???? to do ????-->
				
				</xsl:when>
				<xsl:when test="contains(aimelt,'.')" >
				<!-- attribute mapping case -->
					<xsl:variable name="find-ent" 
						select="substring-before(normalize-space(aimelt),'.')" />
					<xsl:variable name="find-attr" 
						select="substring-after(normalize-space(aimelt),'.')" />
					<xsl:variable name="found-ent" 
						select="$schemas//entity[@name=$find-ent][explicit/@name=$find-attr]" />
					<blockquote>
					<xsl:choose>
						<xsl:when test="$found-ent" >
							MIM element found in schema 
							<xsl:value-of select="$found-ent/ancestor::schema/@name" />
							<br/>
						</xsl:when>
						<xsl:otherwise>
						<!-- could be derived -->
							<xsl:variable name="found-der" 
								select="$schemas//entity[@name=$find-ent][derived/@name=$find-attr]" />
							<xsl:choose>
								<xsl:when test="$found-der">
									MIM element found as DERIVE in schema 
									<xsl:value-of select="$found-ent/ancestor::schema/@name" />
									<br/>						
								</xsl:when>
								<xsl:otherwise>
									<!-- check for inverse attribute -->
									<xsl:variable name="found-inverse" 
							select="$schemas//entity[@name=$find-ent][inverse/@name=$find-attr]" />

			
									<xsl:choose>
									<xsl:when test="$found-inverse" >
									<xsl:value-of select="." /> found as inverse attribute in relevant schemas 
									<xsl:value-of select="$found-inverse/ancestor::schema/@name" />
									<br/>
									</xsl:when>
								<xsl:otherwise>
				<!--	!!! <xsl:value-of select="." /> not found in relevant schemas !!! -->

		<xsl:call-template name="error_message">
			
		  <xsl:with-param name="inline" select="'yes'"/>
		  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
		  <xsl:with-param 
		       	    name="message" 
		            select="concat('Error Map25: ',.,' not found in relevant schemas')"/>
		</xsl:call-template>    


								</xsl:otherwise>
							</xsl:choose>



							</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
					</blockquote>
				
				</xsl:when>
				<xsl:otherwise>
				<!--  should be a single entity name but may be delimited by || -->

					<xsl:choose>

						<xsl:when test="contains(aimelt,'|')" >
							<xsl:variable name="this-aimelt" 
								select="substring-before(substring-after(aimelt,'|'),'|')" />
								<xsl:if test="not($this-aimelt)" >

									<!-- !! MISMATCH in || !! -->
		<xsl:call-template name="error_message">
			  <xsl:with-param name="inline" select="'yes'"/>
			  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
		          <xsl:with-param 
		            name="message" 
		            select="'Error Map23: MISMATCH in | in MIM element '"/>
		</xsl:call-template>    
		
								
								</xsl:if>
						
							<xsl:variable name="found-ent" select="$schemas//entity[@name=$this-aimelt]" />
							<blockquote>
							<xsl:choose>
								<xsl:when test="$found-ent" >
									MIM element found in schema 
									<xsl:value-of select="$found-ent/ancestor::schema/@name" />
									<br/>
								</xsl:when>
								<xsl:otherwise>
									!!! MIM element not found in relevant schemas !!! 
									<br/>
								</xsl:otherwise>
							</xsl:choose>
							</blockquote>
						</xsl:when>
					
						<xsl:when test="contains(aimelt,'(')" >
							<xsl:variable name="this-aimelt" 
								select="substring-before(substring-after(aimelt,'('),')')" />
								<xsl:if test="not($this-aimelt)" >

									<!-- !! MISMATCH in () !! -->
		<xsl:call-template name="error_message">
			  <xsl:with-param name="inline" select="'yes'"/>
			  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
		          <xsl:with-param 
		            name="message" 
		            select="'Error Map29: MISMATCH in parentheses in MIM element '"/>
		</xsl:call-template>    
		
								
								</xsl:if>
						
							<xsl:variable name="found-ent" select="$schemas//entity[@name=$this-aimelt]" />
							<blockquote>
							<xsl:choose>
								<xsl:when test="$found-ent" >
									MIM element found in schema 
									<xsl:value-of select="$found-ent/ancestor::schema/@name" />
									<br/>
								</xsl:when>
								<xsl:otherwise>
									!!! MIM element not found in relevant schemas !!! 
									<br/>
								</xsl:otherwise>
							</xsl:choose>
							</blockquote>
						</xsl:when>


					<xsl:otherwise>
						<xsl:variable name="found-ent" select="$schemas//entity[@name=current()/aimelt]" />
						<blockquote>
						<xsl:choose>
							<xsl:when test="$found-ent" >
								MIM element found in schema 
								<xsl:value-of select="$found-ent/ancestor::schema/@name" />
								<br/>
							</xsl:when>
							<xsl:otherwise>
								!!! MIM element not found in relevant schemas !!! 
								<br/>
							</xsl:otherwise>
						</xsl:choose>
						</blockquote>
						</xsl:otherwise>

					</xsl:choose>

				</xsl:otherwise>
			</xsl:choose>

		</xsl:if>

			Source: <xsl:apply-templates select="source" />
		
			<hr/>

		</xsl:otherwise>
		</xsl:choose>

		<xsl:choose>
			<xsl:when test="alt-map" >
				<xsl:apply-templates select="alt-map" >
					<xsl:with-param name="schemas" select="$schemas" />
		  		</xsl:apply-templates>
				
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="refpath" />
				<hr/>

				<xsl:apply-templates select="refpath" mode="test" >
					<xsl:with-param name="schemas" select="$schemas" />
		  		</xsl:apply-templates>

			</xsl:otherwise>
		
		</xsl:choose>


	</blockquote>
	<hr/>

</xsl:template>



<xsl:template match="alt-map" >
	<xsl:param name="schemas" />	

	<h4> Alternative #<xsl:value-of select="@id" /></h4>
	<p><xsl:value-of select="description" /></p>
	<blockquote>
	
		MIM element: <xsl:apply-templates select="aimelt" />

		<xsl:if test="string-length(aimelt) > 2" >

			<xsl:choose>
				<xsl:when test="normalize-space(aimelt) = 'PATH'" >
				<!-- do nothing - except check that a refpath exists ???? to do ????-->
				</xsl:when>			
				<xsl:when test="normalize-space(aimelt) = 'IDENTICAL MAPPING'" >
				<!-- do nothing -->
				</xsl:when>			
				<xsl:when test="normalize-space(aimelt) = 'NO MAPPING EXTENSION PROVIDED'" >
					<!-- do nothing -->
				</xsl:when>
				<xsl:when test="contains(aimelt,'&#x0A;')" >
				<!-- multi-line mapping case ???? to do ????-->
				</xsl:when>
				<xsl:when test="contains(aimelt,'.')" >
				<!-- attribute mapping case -->
					<xsl:variable name="this_aimelt" select="translate(aimelt,'|()[]','')" />
					<xsl:variable name="find-ent" 
						select="substring-before(normalize-space($this_aimelt),'.')" />
					<xsl:variable name="find-attr" 
						select="substring-after(normalize-space($this_aimelt),'.')" />
					<xsl:variable name="found-ent" 
						select="$schemas//entity[@name=$find-ent][explicit/@name=$find-attr]" />
					<blockquote>
					<xsl:choose>
						<xsl:when test="$found-ent" >
							MIM element found in schema 
							<xsl:value-of select="$found-ent/ancestor::schema/@name" />
							<br/>
						</xsl:when>
						<xsl:otherwise>
							!!! MIM element not found in relevant schemas !!! 
							<br/>
						</xsl:otherwise>
					</xsl:choose>
					</blockquote>
				
				</xsl:when>
				<xsl:otherwise>
				<!--  should be a single entity name but may be delimited by || -->

					<xsl:choose>

						<xsl:when test="contains(aimelt,'|')" >
							<xsl:variable name="this-aimelt" 
								select="substring-before(substring-after(aimelt,'|'),'|')" />
								<xsl:if test="not($this-aimelt)" >

									<!-- !! MISMATCH in || !! -->
		<xsl:call-template name="error_message">
			  <xsl:with-param name="inline" select="'yes'"/>
			  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
		          <xsl:with-param 
		            name="message" 
		            select="'Error Map23: MISMATCH in | in MIM element '"/>
		</xsl:call-template>    
		
								
								</xsl:if>
						
							<xsl:variable name="found-ent" select="$schemas//entity[@name=$this-aimelt]" />
							<blockquote>
							<xsl:choose>
								<xsl:when test="$found-ent" >
									MIM element found in schema 
									<xsl:value-of select="$found-ent/ancestor::schema/@name" />
									<br/>
								</xsl:when>
								<xsl:otherwise>
									!!! MIM element not found in relevant schemas !!! 
									<br/>
								</xsl:otherwise>
							</xsl:choose>
							</blockquote>
						</xsl:when>
						<xsl:when test="contains(aimelt,'(')" >
							<xsl:variable name="this-aimelt" 
								select="substring-before(substring-after(aimelt,'('),')')" />
								<xsl:if test="not($this-aimelt)" >

									<!-- !! MISMATCH in () !! -->
		<xsl:call-template name="error_message">
			  <xsl:with-param name="inline" select="'yes'"/>
			  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
		          <xsl:with-param 
		            name="message" 
		            select="'Error Map29: MISMATCH in parentheses in MIM element '"/>
		</xsl:call-template>    
		
								
								</xsl:if>
						
							<xsl:variable name="found-ent" select="$schemas//entity[@name=$this-aimelt]" />
							<blockquote>
							<xsl:choose>
								<xsl:when test="$found-ent" >
									MIM element found in schema 
									<xsl:value-of select="$found-ent/ancestor::schema/@name" />
									<br/>
								</xsl:when>
								<xsl:otherwise>
									!!! MIM element not found in relevant schemas !!! 
									<br/>
								</xsl:otherwise>
							</xsl:choose>
							</blockquote>
						</xsl:when>
					
					<xsl:otherwise>
						<xsl:variable name="found-ent" select="$schemas//entity[@name=current()/aimelt]" />
						<blockquote>
						<xsl:choose>
							<xsl:when test="$found-ent" >
								MIM element found in schema 
								<xsl:value-of select="$found-ent/ancestor::schema/@name" />
								<br/>
							</xsl:when>
							<xsl:otherwise>
								!!! MIM element not found in relevant schemas !!! 
								<br/>
							</xsl:otherwise>
						</xsl:choose>
						</blockquote>
						</xsl:otherwise>

					</xsl:choose>

				</xsl:otherwise>
			</xsl:choose>

		</xsl:if>

		
		<br/>
		Source: <xsl:apply-templates select="source" />
		<hr/>
		<xsl:apply-templates select="refpath" />
		<hr/>
		<xsl:apply-templates select="refpath" mode="test" >
			<xsl:with-param name="schemas" select="$schemas" />
  		</xsl:apply-templates>
		<hr/>
	</blockquote>
	

</xsl:template>


<xsl:template match="refpath" >
	<B>Reference Path:</B>
		<blockquote>
			<xsl:apply-templates select="./*" />	
		</blockquote>
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

<xsl:template match="quote" >
	<xsl:choose>
		<xsl:when test="@match='GOOD'" >
<!--			Z<xsl:value-of select="@length" />Z -->
				<xsl:text> '</xsl:text>
				<xsl:value-of select="."/>
				<xsl:text>' </xsl:text>
<!--			V<xsl:value-of select="@rest" />V -->
		</xsl:when>
		<xsl:otherwise>
				<xsl:text> '</xsl:text>
				<xsl:value-of select="."/>
				<xsl:call-template name="error_message">
					  <xsl:with-param name="inline" select="'yes'"/>
					  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
				          <xsl:with-param 
				            name="message" 
				            select="'Error Map21: End-Quote missing'"/>
				</xsl:call-template>    

		</xsl:otherwise>
	
	</xsl:choose>
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
		<!-- more than one MIM element - separate by <br/>  -->
				<xsl:call-template name="linespaced-text" >
					<xsl:with-param name="text" select="." />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="." />
			</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template  name="linespaced-text" >
	<xsl:param name="text" />

	<xsl:value-of select="substring-before($text,'&#x0A;')" />
	<br/>
	<xsl:variable name="rest" select="substring-after($text,'&#x0A;')" />
	<xsl:choose>
		<xsl:when test="contains($rest, '&#x0A;')" >
			<xsl:call-template name="linespaced-text" >
				<xsl:with-param name="text" select="$rest" />
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$rest" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>



<xsl:template match="word" >
	<xsl:value-of select="." />
	<xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="refpath" mode="test">
	<xsl:param name="schemas" />	

	<B>Reference Path analysis:</B>
	<blockquote>
	
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
		            select="'Error Map4: MISMATCH in {} '"/>
		</xsl:call-template>    
	</xsl:if>

	<xsl:if test="count(./start-bracket) != count(./end-bracket)" >
		<!-- !! MISMATCH in [] !! -->
		<xsl:call-template name="error_message">
			  <xsl:with-param name="inline" select="'yes'"/>
			  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
		          <xsl:with-param 
		            name="message" 
		            select="'Error Map5: MISMATCH in [] '"/>
		</xsl:call-template>    
	</xsl:if>

<!--	<xsl:if test="is-supertype-of[name(following-sibling::*[1]) !='new-line']" > -->
		<!-- !! Newline missing following =&gt; !! -->
<!--		<xsl:call-template name="error_message">
			  <xsl:with-param name="inline" select="'yes'"/>
			  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
		          <xsl:with-param 
		            name="message" 
		            select="'Error Map6: Newline missing following =&gt;'"/>
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
		            select="'Error Map7: Newline missing following &lt;='"/>
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
		            select="'Error Map8: Newline missing following -&gt;'"/>
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
		            select="'Error Map9: Newline missing following &lt;-'"/>
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
		            select="'Warning Map10: Possible wrong item preceding &lt;-'"/>
		</xsl:call-template>    
	</xsl:if>

	<xsl:if test="is-pointed-at-by[contains(preceding-sibling::*[1],'.')]" >
		<!-- !! Entity.Attribute should not precede &lt;- !! -->
		<xsl:call-template name="error_message">
			  <xsl:with-param name="inline" select="'yes'"/>
			  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
		          <xsl:with-param 
		            name="message" 
		            select="'Error Map11: !! Entity.Attribute should not precede &lt;-'"/>
		</xsl:call-template>    
	</xsl:if>

	<xsl:if test="is-subtype-of[contains(preceding-sibling::*[1],'.')]" >
		<!-- !! Entity.Attribute should not precede &lt;= !! -->
		<xsl:call-template name="error_message">
			  <xsl:with-param name="inline" select="'yes'"/>
			  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
		          <xsl:with-param 
		            name="message" 
		            select="'Error Map12: !! Entity.Attribute should not precede &lt;='"/>
		</xsl:call-template>    
	</xsl:if>


	<xsl:if test="repeat[name(preceding-sibling::*[1]) !='end-paren']" >
		<!-- !! Repeat "*" not preceded by ")" !! -->
		<xsl:call-template name="error_message">
			  <xsl:with-param name="inline" select="'yes'"/>
			  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
		          <xsl:with-param 
		            name="message" 
		            select="'Error Map13: Repeat * not preceded by ) '"/>
		</xsl:call-template>    
	</xsl:if>

	<xsl:if test="string-length(../@entity) - string-length(translate(../@entity,$UPPER,'')) > 1" >
		<!-- !! Only 1 Uppercase character expected in "Entity" name !! -->
		<xsl:call-template name="error_message">
			  <xsl:with-param name="inline" select="'yes'"/>
			  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
		          <xsl:with-param 
		            name="message" 
		            select="concat('Error Map14: Only 1 Uppercase character expected in Entity name: ',../@entity)"/>
		</xsl:call-template>    
	</xsl:if>

	<xsl:if test="contains(../@attribute,' ')" >
		<!-- !! Spaces not expected in "attribute" name  !! -->
		<xsl:call-template name="error_message">
			  <xsl:with-param name="inline" select="'yes'"/>
			  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
		          <xsl:with-param 
		            name="message" 
		            select="concat('Error Map15: Spaces not expected in attribute name: [',../@attribute,']')"/>
		</xsl:call-template>    
	</xsl:if>

	<xsl:if test="string-length(../@attribute) != string-length(translate(../@attribute,$UPPER,''))
			and not(contains(../@attribute,'SELF'))" >
		<!-- !! Uppercase characters not expected in "attribute" name !! -->
		<xsl:call-template name="error_message">
			  <xsl:with-param name="inline" select="'yes'"/>
			  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
		          <xsl:with-param 
		            name="message" 
		            select="concat('Error Map16: Uppercase characters not expected in attribute name: ',
			    		../@attribute)"/>
		</xsl:call-template>    
	</xsl:if>

        <xsl:if test="contains(quote, '-') or contains(quote, '_')">
          <xsl:value-of select="quote"/>
          <!-- !! Uppercase characters not expected in "attribute" name !! -->
          <xsl:call-template name="error_message">
            <xsl:with-param name="inline" select="'yes'"/>
            <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
            <xsl:with-param 
              name="message" 
              select="concat('Warning Map17: Constraint strings should use white space, not - _: ',
                      quote, '#Except if an attribute or entity is being referenced')"/>
          </xsl:call-template>
        </xsl:if>

	<xsl:apply-templates select="word" mode="test" >
		<xsl:with-param name="schemas" select="$schemas" />
	</xsl:apply-templates>

	</blockquote>

</xsl:template>

<xsl:template match="word" mode="test">
	<xsl:param name="schemas" />	



	<xsl:if test="string-length(.) != string-length(translate(.,$UPPER,'')) and 
		not(name(preceding-sibling::*[2]) ='subtype-template' or  
		name(preceding-sibling::*[2]) ='supertype-template') ">
		!! UPPERCASE Not expected: <xsl:value-of select="." /> !!<br/>
	</xsl:if>
	
	<xsl:choose>
		<xsl:when test="string-length(.) != string-length(translate(.,$UPPER,'')) and 
		( name(preceding-sibling::*[2]) ='subtype-template' or  
		name(preceding-sibling::*[2]) ='supertype-template') " >
			<!-- is a subtype or supertype template so ignore -->
			<!-- could check it is found in ARMs ??? -->
		</xsl:when>

		<xsl:when test="string-length(.) = 1 and not (contains($NUMBERS,.))" >
			<xsl:choose>
				<xsl:when test="name(preceding-sibling::*[1]) ='start-bracket' and 
					name(following-sibling::*[1]) ='end-bracket' ">
				</xsl:when>
				<xsl:when test=".='/' and name(preceding-sibling::*[1]) ='end-paren' and 
					contains('ABCDEFGHIJKLMNOPQRSTUVWXYZ', substring(preceding-sibling::*[2],1,1))" >
					<!-- matches preceding SUPERTYPE() or SUBTYPE template -->
				</xsl:when>
				<xsl:otherwise>
				<!-- ?? Possible syntax ERROR: <xsl:value-of select="." /> !! -->
					<xsl:call-template name="error_message">
			
					  <xsl:with-param name="inline" select="'yes'"/>
					  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
				          <xsl:with-param 
			        	    name="message" 
				            select="concat('Error Map17: Possible syntax ERROR: ',.)"/>
					</xsl:call-template>    
				</xsl:otherwise>
			</xsl:choose>
	
		</xsl:when>

		<xsl:when test="string-length(.) != string-length(translate(.,'&gt;&lt;',''))" ><!-- MWD hyphen removed -->
				<!-- ?? Possible syntax ERROR: <xsl:value-of select="." /> !! -->
					<xsl:call-template name="error_message">
			
					  <xsl:with-param name="inline" select="'yes'"/>
					  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
				          <xsl:with-param 
			        	    name="message" 
				            select="concat('Error Map24: Possible syntax ERROR: ',.)"/>
					</xsl:call-template>    
	
		</xsl:when>


		<xsl:when test="contains($LOWER,substring(.,1,1)) and contains(.,'.')" >

	<!-- most likely an attribute reference so check for existence 
	Could check for preceding and following symbols   ???? to do ????-->

		<xsl:variable name="find-ent" 
			select="substring-before(normalize-space(.),'.')" />
		<xsl:variable name="find-attr" 
			select="substring-after(normalize-space(.),'.')" />
		<xsl:variable name="found-ent" 
			select="$schemas//entity[@name=$find-ent][explicit/@name=$find-attr]" />
		<xsl:choose>
			<xsl:when test="$found-ent" >
				<xsl:value-of select="." /> found in schema 
				<xsl:value-of select="$found-ent/ancestor::schema/@name" />
				<br/>
			</xsl:when>
			<xsl:otherwise>

			<!-- check for derived attribute -->

				<xsl:variable name="found-derived" 
				select="$schemas//entity[@name=$find-ent][derived/@name=$find-attr]" />

			
				<xsl:choose>
					<xsl:when test="$found-derived" >
					<xsl:value-of select="." /> found as derived attribute in relevant schemas
					<xsl:value-of select="$found-derived/ancestor::schema/@name" />
					<br/>
					</xsl:when>
					<xsl:otherwise>

						<!-- check for inverse attribute -->
						<xsl:variable name="found-inverse" 
						select="$schemas//entity[@name=$find-ent][inverse/@name=$find-attr]" />

			
						<xsl:choose>
							<xsl:when test="$found-inverse" >
							<xsl:value-of select="." /> found as inverse attribute in relevant schemas 
							<xsl:value-of select="$found-inverse/ancestor::schema/@name" />
							<br/>
							</xsl:when>
							<xsl:otherwise>
						<!--	!!! <xsl:value-of select="." /> not found in relevant schemas !!! -->

		<xsl:call-template name="error_message">
			
		  <xsl:with-param name="inline" select="'yes'"/>
		  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
		  <xsl:with-param 
		       	    name="message" 
		            select="concat('Error Map25: ',.,' not found in relevant schemas')"/>
		</xsl:call-template>    


							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>

		</xsl:when>

<!--		<xsl:when test="not(preceding-sibling::word) or
				(not(contains(.,'.'))) and (
							name(./preceding-sibling::*[name()!='newline'][1])='is-supertype-of' or
							name(./following-sibling::*[1])='is-subtype-of' or
							name(./preceding-sibling::*[name()!='newline'][1])='is-subtype-of' or
							name(./following-sibling::*[1])='is-supertype-of'
							)" >
-->
		<xsl:when test="not(preceding-sibling::word) or
				(not(contains(.,'.'))) and string-length(translate(.,'1234567890. ',''))>0 " >

		<!-- most likely an entity reference so check for existence -->

		<xsl:variable name="find-ent" 
			select="normalize-space(.)" />
		<xsl:variable name="found-ent" 
			select="$schemas//*[@name=$find-ent][contains('entity type',name())]" />
		<br/>
		<xsl:choose>
			<xsl:when test="$found-ent" >
				<xsl:value-of select="concat(.,' ',name($found-ent),' ')" /> found in schema 
				<xsl:value-of select="$found-ent/ancestor::schema/@name" />
				<br/>
			</xsl:when>
			<xsl:otherwise>
<!--			!!! <xsl:value-of select="." /> not found in relevant schemas !!! -->
					<xsl:call-template name="error_message">
			
					  <xsl:with-param name="inline" select="'yes'"/>
					  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
				          <xsl:with-param 
			        	    name="message" 
				            select="concat('Error Map26: ',.,' not found in relevant schemas')"/>
					</xsl:call-template>    
			</xsl:otherwise>
		</xsl:choose>

		</xsl:when>

	</xsl:choose>


</xsl:template>


<xsl:template name="mim-schema-list" >
	<xsl:param name="schemas" />

	<h2>Schemas on which the MIM depends are:</h2>
	
	<p>Note: This is the list of schemas which are referenced. 
	In many cases, USE and REFERENCE statements call out specific entities and not the complete schema.
	</p>

	<blockquote>
		<xsl:apply-templates select="$schemas//schema" mode="name-only">
			<xsl:sort select="@name" />
		</xsl:apply-templates>
	</blockquote>

</xsl:template>


<xsl:template match="schema | entity | type " mode="name-only" >
	<br/><xsl:value-of select="@name" />
</xsl:template>

<xsl:template match="schema | entity | type " mode="schema-name" >
	<br/><xsl:value-of select="translate(concat('  ',../@name,'.',@name,' '),$UPPER,$LOWER)" />
</xsl:template>


<xsl:template name="mim-lf-construct1" >
	<xsl:param name="schemas" />
	<xsl:param name="mappings" />

	<hr/>
	<h2> list of lf form constructs for <xsl:value-of select="$schema-name"/> </h2>
	
	<p> PASS 1 - list of definitive entities and types
	</p>
	<!-- collect result in a variable and normalize the space to get a todo list 
	for completing the implicitly referenced entities and types -->

	<xsl:variable name="direct-items" >
		<xsl:call-template name="mim-lf-recurse-pass1" >
			<xsl:with-param name="schemas" select="$schemas"/>
			<xsl:with-param name="todo" select="concat(' ',$schema-name,' ')"/>
		</xsl:call-template>
	</xsl:variable>

	<blockquote>
<!--		<xsl:call-template name="mim-lf-recurse-pass1" >
			<xsl:with-param name="schemas" select="$schemas"/>
			<xsl:with-param name="todo" select="concat(' ',$schema-name,' ')"/>
		</xsl:call-template>
-->
		<xsl:value-of select="$direct-items" />
	</blockquote>


	PASS 2 - further entities and types
	<br/>

	<xsl:variable name="indirect-items" >
	<xsl:call-template name="mim-lf-recurse-pass2" >
			<xsl:with-param name="schemas" select="$schemas"/>
			<xsl:with-param name="todo" select="concat(' ',normalize-space($direct-items),' ')"/>
			<xsl:with-param name="output" select="concat(' ',normalize-space($direct-items),' ')"/>
		</xsl:call-template> 
	</xsl:variable>

	<blockquote>
<!--	<xsl:call-template name="mim-lf-recurse-pass2" >
		<xsl:with-param name="schemas" select="$schemas"/>
		<xsl:with-param name="todo" select="concat(' ',normalize-space($direct-items),' ')"/>
		<xsl:with-param name="output" select="concat(' ',normalize-space($direct-items),' ')"/>
	</xsl:call-template>
-->
		<xsl:value-of select="$indirect-items" />

	</blockquote>
	


	<br/>

	<hr/>
	<h3>Test mappings against long form contents list</h3>		

	<xsl:if test="string-length($direct-items) > 2" >
		<p>
		Note: 
		if no messages appear before the next horizontal line then all names were found to be in the long form MIM.
		</p>
	</xsl:if>

	<xsl:variable name="mim_list_complete" select="concat(' ',normalize-space($direct-items),' ',
						normalize-space($indirect-items),' ')" />
	
	<blockquote>
		<xsl:for-each select="$mappings//word" >

			<xsl:choose>
				<xsl:when test="string-length(.) = 1" >
				</xsl:when>
				<xsl:when test="string-length(.) != string-length(translate(.,'&gt;&lt;-',''))" >
				</xsl:when>
				<xsl:when test="string-length(.) != string-length(translate(.,$UPPER,''))" >
					<!-- contains upper case - so probably from template call -->
				</xsl:when>
				<xsl:when test="contains(.,'.')" >
					<xsl:if test="not( contains($mim_list_complete,concat('.',
							substring-before(.,'.'),' ')) )" >
                                          <!-- RBN now output error -->
                                          <xsl:variable name="warn1"
                                            select="concat(.,' ENTITY NOT FOUND in mapping of ', ./ancestor::mapping/@entity)"/>
                                          <xsl:variable name="warn2">
                                            <xsl:if test="./ancestor::mapping/@attribute">
                                              <xsl:value-of
                                                select="concat('.',./ancestor::mapping/@attribute)"/>
                                            </xsl:if>
                                          </xsl:variable>
                                          
                                          <xsl:variable name="warn3">
                                            <xsl:if test="./ancestor::mapping/@assertion_to">
                                              <xsl:value-of 
                                                select="concat(' Assertion to: ',./ancestor::mapping/@assertion_to)"/>
                                            </xsl:if>
                                          </xsl:variable>
                                          <xsl:call-template name="error_message">
                                            <xsl:with-param name="inline" select="'yes'"/>
                                            <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
                                            <xsl:with-param 
                                              name="message" 
                                              select="concat('Warning Map1: ',$warn1, $warn2, $warn3)"/>
                                          </xsl:call-template>

<!--                                          <xsl:value-of select="concat($warn1, $warn2, $warn3)"/>
                                          <br/>
-->
                                           <!--
						<xsl:value-of select="." />
						ENTITY NOT FOUND in mapping of
						<xsl:value-of select="./ancestor::mapping/@entity" />
						<xsl:if test="./ancestor::mapping/@attribute" 
						>.<xsl:value-of select="./ancestor::mapping/@attribute" />
						</xsl:if>
						<xsl:if test="./ancestor::mapping/@assertion_to" > 
							Assertion to: 
							<xsl:value-of select="./ancestor::mapping/@assertion_to" />
						</xsl:if>
						<br/>
                                                -->
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="not( contains($mim_list_complete,concat('.',.,' ')) )" >
                                          <!-- ####### make error -->
                                          <!-- RBN now output error -->
                                          <xsl:variable name="warn1"
                                            select="concat(.,
                                                    ' NOT FOUND in mapping of ',
                                                    ./ancestor::mapping/@entity)"/>
                                          <xsl:variable name="warn2">
                                            <xsl:if test="./ancestor::mapping/@attribute">
                                              <xsl:value-of select="concat('.',./ancestor::mapping/@attribute)"/>
                                            </xsl:if>
                                          </xsl:variable>

                                          <xsl:variable name="warn3">
                                              <xsl:value-of
                                                select="concat(' Assertion to: ',
                                                        ./ancestor::mapping/@assertion_to)"/> 
                                          </xsl:variable>
                                          <xsl:call-template name="error_message">
                                            <xsl:with-param name="inline" select="'yes'"/>
                                            <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
                                            <xsl:with-param 
                                              name="message" 
                                              select="concat('Warning Map1: ',$warn1, $warn2, $warn3)"/>
                                          </xsl:call-template>
<!--
                                          <xsl:value-of select="concat($warn1, $warn2, $warn3)"/>
                                          <br/> 
-->
                                          <!--
						<xsl:value-of select="." />
						NOT FOUND in mapping of
						<xsl:value-of select="./ancestor::mapping/@entity" />
						<xsl:if test="./ancestor::mapping/@attribute" 
						>.<xsl:value-of select="./ancestor::mapping/@attribute" />
						</xsl:if>
						<xsl:if test="./ancestor::mapping/@assertion_to" > 
							Assertion to: 
							<xsl:value-of select="./ancestor::mapping/@assertion_to" />
						</xsl:if>						
						<br/>
                                                -->
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		
		</xsl:for-each>
	</blockquote>
	<hr/>
	<br/>
	SCHEMA <xsl:value-of select="$pseudo-schema-name" />;
	<br/>
	<p>(* This schema has been derived from the MIM short form schema. It is in-development and has no official status!!!
	<br/>
	It does not contain:
	<ul>
		<li>Functions or procedures
		</li>
		<li>Pruned enumeration types
		</li>
		<li>Pruned supertypeof clauses
			<br/>
			Entities with subtype constraints are:
			<br/>
			<xsl:apply-templates 
			select="$schemas//entity[@super.expression][contains($direct-items, concat('.',@name,' '))]" 
				mode="name-only" />
			<xsl:apply-templates 
			select="$schemas//entity[@super.expression][contains($indirect-items, concat('.',@name,' '))]" 
				mode="name-only" />


		</li>
	</ul>
	*)
	</p>
	<br/>
	<xsl:apply-templates select="$schemas//type[contains($direct-items, concat('.',@name,' '))]" mode="code" >
		<xsl:with-param name="ref-list" select="concat($direct-items, $indirect-items)" />
		<xsl:with-param name="schemas" select="$schemas" />
	</xsl:apply-templates>

	<xsl:apply-templates select="$schemas//entity[contains($direct-items, concat('.',@name,' '))]" mode="code" />

	<xsl:apply-templates select="$schemas//type[contains($indirect-items, concat('.',@name,' '))]"  mode="code" >
		<xsl:with-param name="ref-list" select="concat($direct-items, $indirect-items)" />
		<xsl:with-param name="schemas" select="$schemas" />
	</xsl:apply-templates>

	<xsl:apply-templates select="$schemas//entity[contains($indirect-items, concat('.',@name,' '))]"  mode="code" />
	
	<br/>
	<br/>
	END_SCHEMA;

</xsl:template>


<xsl:template name="mim-lf-recurse-pass1" >
	<xsl:param name="schemas" />
	<xsl:param name="todo" select="' '"/>
	<xsl:param name="done" select="' '"/>
	<xsl:param name="output" select="' '"/>

	<xsl:variable name="current-schema" 
		select="translate(substring-before(concat(normalize-space($todo),' '),' '),$UPPER,$LOWER)"  />
	<xsl:variable name="still-todo" select="substring-after(normalize-space($todo),' ')"  />

<!--	YY<xsl:value-of select="$current-schema"/>VV	
	CC<xsl:value-of select="$todo"/>VV	
-->
	<xsl:if test="$current-schema" >

		<xsl:if test="not(contains($done,concat(' ',$current-schema,' ')))" >
			<xsl:apply-templates 
				select="$schemas//schema[translate(@name,$UPPER,$LOWER)=$current-schema]/type" 
				mode="schema-name"/>
			<xsl:apply-templates 
				select="$schemas//schema[translate(@name,$UPPER,$LOWER)=$current-schema]/entity" 
				mode="schema-name"/>
			<br/>
		</xsl:if>

<!-- deal with USE and references that list entities -->

		<xsl:if test="not(contains($done,concat(' ',$current-schema,' ')))" >
			<xsl:apply-templates 
				select="$schemas//schema[translate(@name,$UPPER,$LOWER)=
				$current-schema]/interface[interfaced.item]" 
				mode="used-items" >
				<xsl:with-param name="done" select="$output" />
			</xsl:apply-templates>
		</xsl:if>


	<xsl:variable name="used-entities" >
		<xsl:if test="not(contains($done,concat(' ',$current-schema,' ')))" >
			<xsl:apply-templates 
				select="$schemas//schema[translate(@name,$UPPER,$LOWER)=
				$current-schema]/interface[interfaced.item]" 
				mode="used-items" >
				<xsl:with-param name="done" select="$output" />
			</xsl:apply-templates>
		</xsl:if>
	</xsl:variable>


<!-- deal with schemas that are used or referenced complete -->

	<xsl:variable name="used-schemas" >
		<xsl:if test="not(contains($done,concat(' ',$current-schema,' ')))" >
			<xsl:apply-templates 
				select="$schemas//schema[translate(@name,$UPPER,$LOWER)=
				$current-schema]/interface[not(interfaced.item)]" 
				mode="no-used-items" >
				<xsl:with-param name="done" select="$done" />
			</xsl:apply-templates>
		</xsl:if>
	</xsl:variable>

<!-- now recurse -->

	<xsl:call-template name="mim-lf-recurse-pass1" >
		<xsl:with-param name="schemas" select="$schemas"/>
		<xsl:with-param name="todo" select="concat(' ',$used-schemas, $still-todo)"/>
		<xsl:with-param name="done" select="concat($done,' ',$current-schema,' ')"/>
		<xsl:with-param name="output" select="concat($output,' ',$used-entities,' ')"/>
	</xsl:call-template>

	</xsl:if>

</xsl:template>

<xsl:template match="interface" mode="used-items" >
	<xsl:param name="done" select="' '"/>
	<xsl:apply-templates select="interfaced.item" mode="used-items" >
		<xsl:with-param name="done" select="$done" />
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="interfaced.item" mode="used-items" >
	<xsl:param name="done" select="' '"/>

	<xsl:if test="not(contains($done, concat(' ',translate(../@schema,$UPPER,$LOWER),'.',@name,' ')))" >
		<br/><xsl:value-of select="concat(' ',translate(../@schema,$UPPER,$LOWER),'.',@name,' ')" />
	</xsl:if>
	
</xsl:template>

<xsl:template match="interface" mode="no-used-items" >
	<xsl:param name="done" select="' '"/>

	<xsl:if test="not(contains($done, concat(' ',@schema,' ')))" >
		<xsl:value-of select="concat(' ',@schema,' ')" />
	</xsl:if>
</xsl:template>

<xsl:template name="mim-lf-recurse-pass2" >
	<xsl:param name="schemas" />
	<xsl:param name="todo" select="' '"/>
	<xsl:param name="done" select="' '"/>
	<xsl:param name="output" select="' '"/>

	<xsl:variable name="current-item" 
		select="translate(substring-before(concat(normalize-space($todo),' '),' '),$UPPER,$LOWER)"  />
	<xsl:variable name="still-todo" select="substring-after(normalize-space($todo),' ')"  />

<!--	VV<xsl:value-of select="$current-item"/>VV	
	<br/>
	CC<xsl:value-of select="$still-todo"/>CC
	<br/>

	YY<xsl:value-of select="$output"/>YY
	<br/>
-->
	<xsl:if test="$current-item" >

		<xsl:choose>
		<xsl:when test="not(contains($done,concat(' ',$current-item,' ')))" >	

			<xsl:variable name="current-item-schema" select="substring-before($current-item,'.')" />

			<xsl:variable name="current-item-thing" select="substring-after($current-item,'.')" />
		
			<xsl:variable name="current-item-type" 
				select="name($schemas//schema[translate(@name,$UPPER,$LOWER)=
					$current-item-schema]/*[@name=$current-item-thing])" />

			<xsl:if test="not(contains($output, concat(' ',$current-item,' ')))" >
				<br/><xsl:value-of select="concat(' ',$current-item,' ')" />
			</xsl:if>

<!-- add any dependent items that are not in done list to the todo list-->

			<xsl:variable name="current-item-depends" >
				<xsl:if test="not(contains($done, concat(' ',$current-item,' ')))" >
					<xsl:apply-templates 
						select="$schemas//schema[translate(@name,$UPPER,$LOWER)=
						$current-item-schema]/type[@name=$current-item-thing]" 
						mode="dependent-items-restricted" >
						<xsl:with-param name="schemas" select="$schemas"/>
						<xsl:with-param name="done-list" select="$output"/>
					</xsl:apply-templates>
					<xsl:apply-templates 
						select="$schemas//schema[translate(@name,$UPPER,$LOWER)=
						$current-item-schema]/entity[@name=$current-item-thing]" 
						mode="dependent-items-restricted" >
						<xsl:with-param name="schemas" select="$schemas"/>
						<xsl:with-param name="done-list" select="$output"/>
					</xsl:apply-templates>
					<xsl:apply-templates 
						select="$schemas//schema[translate(@name,$UPPER,$LOWER)=
						$current-item-schema]/function[@name=$current-item-thing]" 
						mode="dependent-items-restricted" >
						<xsl:with-param name="schemas" select="$schemas"/>
						<xsl:with-param name="done-list" select="$output"/>
					</xsl:apply-templates>
				</xsl:if>
			</xsl:variable>				

<!--	AA<xsl:value-of select="$current-item-depends"/>BB -->



			<xsl:call-template name="mim-lf-recurse-pass2" >
				<xsl:with-param name="schemas" select="$schemas"/>
				<xsl:with-param name="todo" select="concat(' ',$still-todo, $current-item-depends)"/>
				<xsl:with-param name="done" select="concat($done,' ',$current-item,' ')"/>
				<xsl:with-param name="output" select="concat($output,' ',$current-item,' ')"/>
			</xsl:call-template>


		</xsl:when>
		<xsl:otherwise>

			<xsl:call-template name="mim-lf-recurse-pass2" >
				<xsl:with-param name="schemas" select="$schemas"/>
				<xsl:with-param name="todo" select="concat(' ',$still-todo)"/>
				<xsl:with-param name="done" select="concat($done,' ',$current-item,' ')"/>
				<xsl:with-param name="output" select="$output"/>
			</xsl:call-template>

		</xsl:otherwise>
		</xsl:choose>

	</xsl:if>

</xsl:template>

<xsl:template match="entity" mode="dependent-items" >
	<xsl:param name="schemas" />

<!-- list any supertypes -->

	<xsl:if test="@supertypes" >
		<xsl:variable name="supers" select="concat(' ',@supertypes,' ')" />
		<xsl:apply-templates 
			select="$schemas//schema/entity[contains($supers,concat(' ',@name,' '))]" 
			mode="schema-name"/>
	</xsl:if>
	

<!-- list any types used by attributes -->

	<xsl:for-each select="explicit/typename | derived/typename" >
		<xsl:variable name="typename" select="@name" />

		<xsl:apply-templates 
			select="$schemas//schema/*[@name=$typename][name()='entity' or name()='type']" 
			mode="schema-name"/>
	</xsl:for-each>

</xsl:template>

<xsl:template match="type" mode="dependent-items" >
	<xsl:param name="schemas" />

	<xsl:choose>
		<xsl:when test="select" >
			<!-- do nothing as deal with select types later -->
			<!-- ??? what about selects that are included as members in another select??? -->
			<xsl:apply-templates select="." mode="dependent-items-select" >
				<xsl:with-param name="schemas" select="$schemas"/>
			</xsl:apply-templates>

		</xsl:when>
		<xsl:when test="typename" >
			<xsl:variable name="this-type" select="typename/@name" />
			<xsl:apply-templates 
				select="$schemas//schema/*[@name=$this-type][name()='entity' or name()='type']" 
				mode="schema-name"/>
		</xsl:when>
		<xsl:when test="enumeration" >
			<!-- do nothing as deal with enumeration types later ??? -->
		</xsl:when>

	</xsl:choose>
</xsl:template>

<xsl:template match="type" mode="dependent-items-select" >
	<xsl:param name="schemas" />

	<xsl:choose>
		<xsl:when test="select/@basedon" >
			<!-- do nothing -->
		</xsl:when>
		<xsl:when test="select/@extensible='YES'" >
			<!-- do nothing -->
		</xsl:when>
		<xsl:when test="select/@selectitems" >
			<!-- filter out any item that is another select or a defined type and add to list -->
			<xsl:variable name="this-items" select="concat(' ',select/@selectitems,' ')" />
			<xsl:apply-templates 
				select="$schemas//schema/type[contains($this-items,concat(' ',@name,' '))]" 
				mode="schema-name"/>
<!-- This should work but does not!
			<xsl:apply-templates 
				select="$schemas//schema/type[contains($this-items,concat(' ',@name,' '))]
						[not(select/@basedon | select/@extensible)]" 
				mode="schema-name"/>
-->
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="type" mode="dependent-items-select-restricted" >
	<xsl:param name="schemas" />
	<xsl:param name="done-list" />

	<xsl:choose>
		<xsl:when test="select/@basedon" >
			<!-- do nothing -->
		</xsl:when>
		<xsl:when test="select/@extensible='YES'" >
			<!-- do nothing -->
		</xsl:when>
		<xsl:when test="select/@selectitems" >
			<!-- filter out any item that is another select or a defined type and add to list -->
			<xsl:variable name="this-items" select="concat(' ',select/@selectitems,' ')" />
			<xsl:for-each select="$schemas//schema/type[contains($this-items,concat(' ',@name,' '))]" >
				<xsl:if test="not(contains($done-list,concat(' ',../@name,'.',@name,' ')))" >
					<xsl:apply-templates select="." mode="schema-name"/>
				</xsl:if>
				
			</xsl:for-each>
<!-- This should work but does not!
			<xsl:apply-templates 
				select="$schemas//schema/type[contains($this-items,concat(' ',@name,' '))]
						[not(select/@basedon | select/@extensible)]" 
				mode="schema-name"/>
-->
		</xsl:when>
	</xsl:choose>
</xsl:template>


<xsl:template match="function" mode="dependent-items-restricted" >
	<xsl:param name="schemas" />
	<xsl:param name="done-list" />

	<xsl:for-each select="typename | parameter/typename" >
		<xsl:variable name="typename" select="@name" />

		<xsl:for-each select="$schemas//schema/*[@name=$typename][name()='entity' or name()='type']" >
			<xsl:if test="not(contains($done-list,concat(' ',../@name,'.',@name,' ')))" >
				<xsl:apply-templates select="." mode="schema-name"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:for-each>

</xsl:template>


<xsl:template match="entity" mode="dependent-items-restricted" >
	<xsl:param name="schemas" />
	<xsl:param name="done-list" />

<!-- list any supertypes -->

	<xsl:if test="@supertypes" >
		<xsl:variable name="supers" select="concat(' ',@supertypes,' ')" />
		<xsl:for-each select="$schemas//schema/entity[contains($supers,concat(' ',@name,' '))]" >
			<xsl:if test="not(contains($done-list,concat(' ',../@name,'.',@name,' ')))" >
				<xsl:apply-templates select="." mode="schema-name"/>
			</xsl:if>
				
		</xsl:for-each>
	</xsl:if>
	

<!-- list any types used by attributes -->

	<xsl:for-each select="explicit/typename | derived/typename" >
		<xsl:variable name="typename" select="@name" />

		<xsl:for-each select="$schemas//schema/*[@name=$typename][name()='entity' or name()='type']" >
			<xsl:if test="not(contains($done-list,concat(' ',../@name,'.',@name,' ')))" >
				<xsl:apply-templates select="." mode="schema-name"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:for-each>

</xsl:template>

<xsl:template match="type" mode="dependent-items-restricted" >
	<xsl:param name="schemas" />
	<xsl:param name="done-list" />

	<xsl:choose>
		<xsl:when test="select" >
			<!-- do nothing as deal with select types later -->
			<!-- ??? what about selects that are included as members in another select??? -->
			<xsl:apply-templates select="." mode="dependent-items-select-restricted" >
				<xsl:with-param name="schemas" select="$schemas"/>
				<xsl:with-param name="done-list" select="$done-list"/>
			</xsl:apply-templates>

		</xsl:when>
		<xsl:when test="typename" >
			<xsl:variable name="this-type" select="typename/@name" />
			<xsl:for-each select="$schemas//schema/*[@name=$this-type][name()='entity' or name()='type']" >
				<xsl:if test="not(contains($done-list,concat(' ',../@name,'.',@name,' ')))" >
					<xsl:apply-templates select="." mode="schema-name"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:when>
		<xsl:when test="enumeration" >
			<!-- do nothing as deal with enumeration types later ??? -->
		</xsl:when>

	</xsl:choose>
</xsl:template>


<xsl:template match="type" mode="code">
	<xsl:param name="ref-list" />
	<xsl:param name="schemas" />
  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      

  <xsl:variable 
    name="this_type_name" 
    select="@name"/>      


  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>    

  <br/>
  <xsl:choose>
  <xsl:when test="./select" >

<!-- approach: 
1) check if type is based on. If so output a defined type = to the based_on type.

2) create a variable that is the result of going through the select items and check if they are in scope
check whether the variable exists.
-->

	<xsl:choose>
<!--	<xsl:when test="select/@basedon and not(
					$schemas//*[typename/@name=$this_type_name])" >
	
	<p>
		(*
		TYPE <xsl:value-of select="@name" /> Not referenced in long form !!!
		*)
	</p>


	</xsl:when>	
-->
	<xsl:when test="select/@basedon" >
		<br/>
		<xsl:if test="not( $schemas//*[typename/@name=$this_type_name])" >
			(*
			Warning TYPE <xsl:value-of select="@name" /> not referenced in long form !!!
			*)
			<br/>
			<br/>
		</xsl:if>	

		<A NAME="{$aname}">TYPE </A><b><xsl:value-of select="@name"/></b> =
		      <xsl:call-template name="link_object">
		        <xsl:with-param name="object_name" select="select/@basedon"/>
		        <xsl:with-param name="object_used_in_schema_name" 
		          select="../../@name"/>
		        <xsl:with-param name="clause" select="'annexe'"/>
		      </xsl:call-template>;
		
<!-- TODO: 
need to add ability to constrain out values for the select that are not in this branch of the select extension tree.
Do this by comparing the result of recursing down the tree from this type collecting members versus going to the base of
the tree and recursing up. Need to add wr to constrain out any types found in the second case that are not in the first
- provided they are in the overall scope of the mim.
-->
		<xsl:variable name="base-select" >
			<xsl:apply-templates select="." mode="basedon-lowest" >
				<xsl:with-param name="schemas" select="$schemas" />
			</xsl:apply-templates>
		</xsl:variable>

		<xsl:if test="contains($base-select,'CIRCULAR SELECT ERROR' )" >
			<xsl:call-template name="error_message">
				  <xsl:with-param name="inline" select="'yes'"/>
				  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
			          <xsl:with-param 
			            name="message" 
			            select="'Error Map18: CIRCULAR SELECT based on tree '"/>
			</xsl:call-template>
		</xsl:if>

		<xsl:if test="contains($base-select,'TYPE COUNT ERROR1' )" >
			<xsl:call-template name="error_message">
				  <xsl:with-param name="inline" select="'yes'"/>
				  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
			          <xsl:with-param 
			            name="message" 
			            select="'Error Map31: SELECT based on tree branches downwards'"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="contains($base-select,'TYPE COUNT ERROR2' )" >
			<xsl:call-template name="error_message">
				  <xsl:with-param name="inline" select="'yes'"/>
				  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
			          <xsl:with-param 
			            name="message" 
			            select="concat('Error Map30: SELECT Type based on not found for ',./@name)"/>
			</xsl:call-template>
		</xsl:if>
		<br/>
		(* Ultimate base: <xsl:value-of select="$base-select" /> *)
		<br/>


		<xsl:variable name="list-from-base" >
			<xsl:apply-templates select="$schemas//type[select]
					[@name=substring-after(normalize-space($base-select),'.')]" 
					mode="select-tree-up" >
				<xsl:with-param name="schemas" select="$schemas" />
			</xsl:apply-templates>
		</xsl:variable>

		<xsl:variable name="list-from-base-filtered" >
			<xsl:call-template name="filter-select-items" >
				<xsl:with-param name="allowed-list" select="$ref-list" />
				<xsl:with-param name="item-list" select="$list-from-base" />
			</xsl:call-template>
		</xsl:variable>

		(* Ultimate base members: <xsl:value-of select="$list-from-base-filtered" /> *)
		<br/>

		<xsl:variable name="list-from-top" >
			<xsl:apply-templates select="." 
					mode="select-tree-down" >
				<xsl:with-param name="schemas" select="$schemas" />
			</xsl:apply-templates>
		</xsl:variable>

		<xsl:variable name="list-from-top-filtered" >
			<xsl:call-template name="filter-select-items" >
				<xsl:with-param name="allowed-list" select="$ref-list" />
				<xsl:with-param name="item-list" select="$list-from-top" />
			</xsl:call-template>
		</xsl:variable>


		(* Descending members: <xsl:value-of select="$list-from-top-filtered" /> *)

		<xsl:variable name="excess-types" >
			<xsl:call-template name="filter-word-list-negated" >
				<xsl:with-param name="allowed-list" select="$list-from-top-filtered" />
				<xsl:with-param name="word-list" select="$list-from-base-filtered" />
			</xsl:call-template>
		</xsl:variable>

		<br/>
		(* Excess members: <xsl:value-of select="$excess-types" /> *)

		<xsl:if test="string-length($excess-types) > 3" >
			<br/>
			WHERE
			<br/>
			<xsl:call-template name="excess-where-rule" >
				<xsl:with-param name="excess-list" select="$excess-types"/>
				<xsl:with-param name="the-schema" 
					select="translate( $pseudo-schema-name, $LOWER,$UPPER)"/>
			</xsl:call-template>
		</xsl:if>

			<br/>
		    END_TYPE; 
		</xsl:when>

		<xsl:when test="select[@extensible='YES' or @extensible='yes']" >
			<br/>
			<A NAME="{$aname}">TYPE </A><b><xsl:value-of select="@name"/></b> = SELECT
			<br/>

			<!-- find list going up and then filter -->

			<xsl:variable name="list-from-base" >
				<xsl:apply-templates select="." 
						mode="select-tree-up" >
					<xsl:with-param name="schemas" select="$schemas" />
				</xsl:apply-templates>
			</xsl:variable>

			<xsl:variable name="list-from-base-filtered" >
				<xsl:call-template name="filter-select-items" >
					<xsl:with-param name="allowed-list" select="$ref-list" />
					<xsl:with-param name="item-list" select="$list-from-base" />
				</xsl:call-template>
			</xsl:variable>


		      <xsl:choose>
		        <xsl:when test="string-length($list-from-base-filtered) > 0 ">
			    &#160;&#160;&#160;(<xsl:call-template name="link_list">
			    <xsl:with-param name="linebreak" select="'yes'"/>
			    <xsl:with-param name="suffix" select="', '"/>
			    <xsl:with-param name="prefix" select="'&#160;&#160;&#160;&#160;'"/>
			    <xsl:with-param name="first_prefix" select="'no'"/>
			    <xsl:with-param name="list" select="$list-from-base-filtered"/>
			    <xsl:with-param name="object_used_in_schema_name"
			      select="../../@name"/>
			    <xsl:with-param name="clause" select="'annexe'"/>
			  </xsl:call-template>);
			
		        </xsl:when>
		        <xsl:otherwise>
				( );<br/>
				(* NON-INSTANCIABLE SELECT *)
		        </xsl:otherwise>
		      </xsl:choose>


		        <br/>  
		    	END_TYPE; 
		</xsl:when>


		<xsl:otherwise>
<!-- select type that is not basedon another  and not extensible 
Therefore only need to prune the list of members
--> 
			<br/>
			  <A NAME="{$aname}">TYPE </A><b><xsl:value-of select="@name"/></b> = SELECT 
			<br/>

			<xsl:variable name="selectitems-filtered" >
				<xsl:call-template name="filter-select-items" >
					<xsl:with-param name="allowed-list" select="$ref-list" />
					<xsl:with-param name="item-list" select="select/@selectitems" />
				</xsl:call-template>
			</xsl:variable>
			
		      <xsl:choose>
		        <xsl:when test="string-length($selectitems-filtered) > 0 ">
			    &#160;&#160;&#160;(<xsl:call-template name="link_list">
			    <xsl:with-param name="linebreak" select="'yes'"/>
			    <xsl:with-param name="suffix" select="', '"/>
			    <xsl:with-param name="prefix" select="'&#160;&#160;&#160;&#160;'"/>
			    <xsl:with-param name="first_prefix" select="'no'"/>
			    <xsl:with-param name="list" select="$selectitems-filtered"/>
			    <xsl:with-param name="object_used_in_schema_name"
			      select="../../@name"/>
			    <xsl:with-param name="clause" select="'annexe'"/>
			  </xsl:call-template>);
			
		        </xsl:when>
		        <xsl:otherwise>
				( );<br/>
				(* NON-INSTANCIABLE SELECT *)
		        </xsl:otherwise>
		      </xsl:choose>
		  
		   	<br/>  
		    END_TYPE; 
		
		</xsl:otherwise>
	</xsl:choose>
  
  </xsl:when>
  <xsl:otherwise>
  <A NAME="{$aname}">TYPE </A><b><xsl:value-of select="@name"/></b> =
      <xsl:apply-templates select="./aggregate" mode="code"/>        
      <xsl:choose>
        <xsl:when test="./where">
          <xsl:apply-templates select="./*" mode="underlying" />;<br/>
          <xsl:apply-templates select="./where" mode="code"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="./*" mode="underlying"/>;<br/>
        </xsl:otherwise>
      </xsl:choose>
    END_TYPE; 
  </xsl:otherwise>
  </xsl:choose>
  <br/>
</xsl:template>

<xsl:template match="select" mode="underlying-prune">
	<xsl:param name="ref-list" />

  SELECT
  <!-- need to check for NULL as some XML outputs attribute as null of not
       known -->
  <xsl:if test="@selectitems and 
                (string-length(@selectitems)!=0)">
    <xsl:if test="@basedon">
      WITH 
    </xsl:if><br/>
    &#160;&#160;&#160;(<xsl:call-template name="link_list">
    <xsl:with-param name="linebreak" select="'yes'"/>
    <xsl:with-param name="suffix" select="', '"/>
    <xsl:with-param name="prefix" select="'&#160;&#160;&#160;&#160;'"/>
    <xsl:with-param name="first_prefix" select="'no'"/>
    <xsl:with-param name="list" select="@selectitems"/>
    <xsl:with-param name="object_used_in_schema_name"
      select="../../@name"/>
    <xsl:with-param name="clause" select="'annexe'"/>
  </xsl:call-template>)
  </xsl:if>

  <xsl:if test="@genericentity='YES' or @genericentity='yes'">
  <br/>  (* derived from GENERIC_ENTITY SELECT type. *)
  </xsl:if>

  <xsl:if test="@extensible='YES' or @extensible='yes'">
   <br/> (* derived from EXTENSIBLE SELECT type. *)
  </xsl:if>

	<xsl:if test="@basedon">
	<br/> (* was BASED_ON
      <xsl:call-template name="link_object">
        <xsl:with-param name="object_name" select="@basedon"/>
        <xsl:with-param name="object_used_in_schema_name" 
          select="../../@name"/>
        <xsl:with-param name="clause" select="'annexe'"/>
      </xsl:call-template>  
      *)
  </xsl:if>

</xsl:template>


<xsl:template match="type" mode="basedon-lowest">
	<xsl:param name="schemas" />
	<xsl:param name="done" select="' '" />

	<xsl:choose>
		<xsl:when test="contains($done,concat(' ',../@name,'.',@name,' '))" >
		CIRCULAR SELECT ERROR <xsl:value-of select="@name" />
		</xsl:when>
		<xsl:when test="not(select/@basedon)" >
			<xsl:value-of select="concat(' ',../@name,'.',@name,' ')" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="next_select" select="select/@basedon" />
			<xsl:variable name="type-count" select="count($schemas//type[./select][@name=$next_select])" />

			<xsl:choose>
			<xsl:when test="$type-count = 0" >
				TYPE COUNT ERROR2 <xsl:value-of select="@name" />
				looking for <xsl:value-of select="$next_select" />
			</xsl:when>
			<xsl:when test="$type-count > 1" >
				TYPE COUNT ERROR1 <xsl:value-of select="@name" /> 
				looking for <xsl:value-of select="$next_select" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="$schemas//type[select][@name=$next_select]" 
							mode="basedon-lowest">
					<xsl:with-param name="schemas" select="$schemas"/>
					<xsl:with-param name="done" select="concat($done,' ',../@name,'.',@name,' ')" />
				</xsl:apply-templates>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>

</xsl:template>

<xsl:template match="type" mode="select-tree-up">
	<xsl:param name="schemas" />
	<xsl:param name="done" select="' '" />

	<xsl:variable name="this_select" select="@name" />

	<xsl:if test="not(contains($done, concat(' ',../@name,'.',@name,' ')))" >
	
		<xsl:if test="select/@selectitems" >
			<xsl:value-of select="concat(' ',select/@selectitems,' ')" /> 
		</xsl:if>

		<xsl:apply-templates select="$schemas//type[select/@basedon=$this_select]" 
						mode="select-tree-up">
			<xsl:with-param name="schemas" select="$schemas" />
			<xsl:with-param name="done" select="concat($done,' ',../@name,'.',$this_select,' ')" />
		</xsl:apply-templates>

	</xsl:if>

</xsl:template>

<xsl:template match="type" mode="select-tree-down">
	<xsl:param name="schemas" />
	<xsl:param name="done" select="' '" />


	<xsl:if test="not(contains($done, concat(' ',../@name,'.',@name,' ')))" >

		<xsl:variable name="next_select" select="select/@basedon" />

		<xsl:if test="select/@selectitems" >
			<xsl:value-of select="concat(' ',select/@selectitems,' ')" /> 
		</xsl:if>

		<xsl:apply-templates select="$schemas//type[select][@name=$next_select]" 
						mode="select-tree-down">
			<xsl:with-param name="schemas" select="$schemas" />
			<xsl:with-param name="done" select="concat($done,' ',../@name,'.',@name,' ')" />
		</xsl:apply-templates>

	</xsl:if>

</xsl:template>


<xsl:template name="filter-select-items" >
	<xsl:param name="allowed-list" />
	<xsl:param name="item-list" />

	<!-- get first item in list -->

	<xsl:variable name="first" select="substring-before(concat(normalize-space($item-list),' '),' ')" />

	<xsl:if test="$first" >

		<xsl:if test="contains($allowed-list,concat('.',$first,' '))" >
			<xsl:value-of select="concat(' ',$first,' ')" /> 
		</xsl:if>

		<xsl:call-template name="filter-select-items">
			<xsl:with-param name="allowed-list" select="$allowed-list" />
			<xsl:with-param name="item-list" select="substring-after($item-list,$first)" />
		</xsl:call-template>

	</xsl:if>

</xsl:template>


<xsl:template name="filter-word-list" >
	<xsl:param name="allowed-list" />
	<xsl:param name="word-list" />

	<!-- outputs all words from word-list that are in allowed-list -->

	<!-- get first item in list -->

	<xsl:variable name="first" select="substring-before(concat(normalize-space($word-list),' '),' ')" />

	<xsl:if test="$first" >

		<xsl:if test="contains(concat(' ',$allowed-list,' '),concat(' ',$first,' '))" >
			<xsl:value-of select="concat(' ',$first,' ')" /> 
		</xsl:if>

		<xsl:call-template name="filter-select-items">
			<xsl:with-param name="allowed-list" select="$allowed-list" />
			<xsl:with-param name="word-list" select="substring-after($word-list,$first)" />
		</xsl:call-template>

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

<!--		<xsl:call-template name="filter-select-items"> -->
		<xsl:call-template name="filter-word-list-negated">
			<xsl:with-param name="allowed-list" select="$allowed-list" />
			<xsl:with-param name="word-list" select="substring-after($word-list,$first)" />
		</xsl:call-template>

	</xsl:if>

</xsl:template>

<xsl:template name="excess-where-rule" >
	<xsl:param name="excess-list" />
	<xsl:param name="the-schema" />
	<xsl:param name="count" select="1" />
	

	<!-- get first item in list -->

	<xsl:variable name="first" select="substring-before(concat(normalize-space($excess-list),' '),' ')" />

	<xsl:if test="$first" >


		WR<xsl:value-of select="$count" />: NOT(
		<xsl:value-of select='concat(" &#x27;",$the-schema,".",translate($first,$LOWER,$UPPER),"&#x27; ")' />
		IN TYPEOF(SELF));
		<br/>

		<xsl:call-template name="excess-where-rule">
			<xsl:with-param name="the-schema" select="$the-schema" />
			<xsl:with-param name="excess-list" select="substring-after($excess-list,$first)" />
			<xsl:with-param name="count" select="$count + 1" />
		</xsl:call-template>

	</xsl:if>

</xsl:template>


</xsl:stylesheet>
