<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="../../xsl/document_xsl.xsl" ?>
<!--
$Id: mapping_view.xsl,v 1.22 2013/10/25 15:46:45 thomasrthurman Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep Limited
  Purpose: A set of imported templates to set up a list of modules
     The importing file will define the modules template which
     displays the list of modules
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
  <!-- MWD "module_file" and "module_node" variables made global -->
  <xsl:variable name="module_file" 
                select="concat('../../data/modules/',/stylesheet_application[1]/@directory,'/module.xml')"/>
  <xsl:variable name="module_node" select="document($module_file)/module"/>
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
   <!-- MWD "module_file" and "module_node" variable removed (made global) -->
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
			<xsl:when test="@assertion_to = '*'" >
				<!-- Do nothing -->
			</xsl:when>

			<xsl:when test="@assertion_to = translate(@assertion_to,$UPPER,'')" >
				<xsl:value-of select="@assertion_to" /> as referenced by "Assertion to" must be an ARM SELECT type
				<br/>

				<xsl:variable name="this_sel" select="@assertion_to" />
				<xsl:variable name="this_sel_space" select="concat(' ',@assertion_to,' ')" />
                                <xsl:choose>
                                  <xsl:when test="$this_sel='*'"/>
                                  <xsl:when test="not($arm_node//type[@name=$this_sel][select]
				        | $arm_node//typename[@name=$this_sel]
					| $arm_node//type/select[contains(concat(' ',@selectitems,' '), $this_sel_space)])">
					<xsl:call-template name="error_message">
					  <xsl:with-param name="inline" select="'yes'"/>
					  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
				          <xsl:with-param 
				            name="message" 
				            select="concat('Error Map27: ',$this_sel,' is not an ARM SELECT type')"/>
					</xsl:call-template>    
                                      </xsl:when>
                                    </xsl:choose>
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
		            select="concat('Error Map25A: ',aimelt,' not found in relevant schemas')"/><!-- MWD "Map25" renamed "Map25A"
-->		</xsl:call-template>    


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
				<!-- do nothing -->
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

<xsl:template match="mapping-of" ><!-- MWD this template added -->
	<xsl:text> /MAPPING_OF </xsl:text>
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
	
	<xsl:if test="@extension='TRUE'" >
		Mapping extends previous mapping to include <xsl:value-of select="@assertion_to" />
		<br/>		
	</xsl:if>

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


	<xsl:apply-templates select="word" mode="test" >
		<xsl:with-param name="schemas" select="$schemas" />
	</xsl:apply-templates>

	<xsl:apply-templates select="is-extended-by | extends" mode="test" ><!-- MWD name changed from "is-extension-from | is-extension-of" to "is-extended-by | extends" -->
		<xsl:with-param name="schemas" select="$schemas" />
	</xsl:apply-templates>
	
	<xsl:apply-templates select="equals" mode="test" >
		<xsl:with-param name="schemas" select="$schemas" />
	</xsl:apply-templates>

	<xsl:apply-templates select="is-subtype-of | is-supertype-of" mode="test" >
		<xsl:with-param name="schemas" select="$schemas" />
	</xsl:apply-templates>

	</blockquote>

</xsl:template>

<xsl:template match="equals" mode="test">
	<xsl:param name="schemas" />	
	<!-- test that types are properly related -->

	<xsl:variable name="first" select="string(preceding-sibling::*[not(name() ='new-line')][1])" />
	<xsl:variable name="second" select="string(following-sibling::*[not(name() ='new-line')][1])" />

	<xsl:choose>
		<xsl:when test="name(following-sibling::*[1])='quote'" >

			<!-- do nothing - just eliminate the possibility that test is on a quoted string -->

		</xsl:when>
		<xsl:when test="name(following-sibling::*[1])='equals'" >

					<xsl:call-template name="error_message">
					  <xsl:with-param name="inline" select="'yes'"/>
					  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
				          <xsl:with-param 
				            name="message" 
					    select="'Error Map55: Syntax error: Repeated = '"/>
					</xsl:call-template>    


		</xsl:when>
		<xsl:when test="name(preceding-sibling::*[1])='end-bracket'" >

			<!-- do nothing - just eliminate the possibility that test is on aggregate member -->

		</xsl:when>
		<xsl:when test="contains(concat($first,$second),'.')" >

			<!-- do nothing - just eliminate the possibility that test is on an attribute -->

		</xsl:when>
		<xsl:when test="string-length(translate($second,'0123456789.','')) = 0 " >

			<!-- do nothing - just eliminate the possibility that test is on a number -->

		</xsl:when>
		<xsl:when test="not($first or $second)" >

			<!-- Probable syntax error!!! <br/> -->
		
		</xsl:when>
		<xsl:when test="$mim_node//type[@name=$first][select/@basedon]" >

			<!-- check that second is contained in selectitems list -->
			
			<xsl:choose>
				<xsl:when test="not($mim_node//type[@name=$first]/select[
					contains(concat(' ',@selectitems,' '),
					concat(' ',$second,' '))])" >

					<xsl:call-template name="error_message">
					  <xsl:with-param name="inline" select="'yes'"/>
					  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
				          <xsl:with-param 
				            name="message" 
				            select="concat('Error Map36: TYPE ',$first,
					    ' does not include ',$second,' as select item')"/><!-- MWD name changed from "Map31" to "Map36" -->
					</xsl:call-template>    
				</xsl:when>
				<xsl:otherwise>
					<br/>
					TYPE <xsl:value-of select="$first"/> includes 
					<xsl:value-of select="$second"/> as select item 
					<br/>
				</xsl:otherwise>
			</xsl:choose>	
		</xsl:when>
		<xsl:otherwise>
		</xsl:otherwise>
	</xsl:choose>
	
</xsl:template>

	<xsl:template match="is-extended-by" mode="test"><!-- MWD name changed from "is-extension-from" to "is-extended-by" -->
	<xsl:param name="schemas" />	
	<!-- test that types are properly related -->

	<xsl:variable name="based-on-type" select="string(preceding-sibling::*[not(name() ='new-line')][1])" />
	<xsl:variable name="derived-type" select="string(following-sibling::*[not(name() ='new-line')][1])" />

	<xsl:choose>
		<xsl:when test="not($based-on-type)" >

			NO type specified at start of reference path !!! <br/>
		
		</xsl:when>
		<xsl:when test="not($schemas//type[@name=$derived-type][select/@basedon=$based-on-type])" >

<!--			TYPE <xsl:value-of select="$derived-type"/> not found 
			or not based on <xsl:value-of select="$based-on-type"/> !!! <br/> 
-->
					<xsl:call-template name="error_message">
					  <xsl:with-param name="inline" select="'yes'"/>
					  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
				          <xsl:with-param 
				            name="message" 
				            select="concat('Error Map32: TYPE ',$derived-type,
					    ' not found or not based on ',$based-on-type)"/>
					</xsl:call-template>    
		</xsl:when>
		<xsl:otherwise>
			<br/>
			TYPE <xsl:value-of select="$derived-type"/> found 
			and based on <xsl:value-of select="$based-on-type"/>
			<br/>		
		</xsl:otherwise>
	</xsl:choose>
	
</xsl:template>

<xsl:template match="extends" mode="test"><!-- MWD name changed from "is-extension-of" to "extends" -->
	<xsl:param name="schemas" />	
	<!-- test that types are properly related -->

	<xsl:variable name="based-on-type" select="string(following-sibling::*[not(name() ='new-line')][1])" />
	<xsl:variable name="derived-type" select="string(preceding-sibling::*[not(name() ='new-line')][1])" />

	<xsl:choose>
		<xsl:when test="not($derived-type)" >

			NO type specified at start of reference path !!! <br/>
		
		</xsl:when>
		<xsl:when test="not($schemas//type[@name=$derived-type][select/@basedon=$based-on-type])" >
<!--			TYPE <xsl:value-of select="$derived-type"/> not found 
			or not based on <xsl:value-of select="$based-on-type"/> !!! <br/> 
-->
					<xsl:call-template name="error_message">
					  <xsl:with-param name="inline" select="'yes'"/>
					  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
				          <xsl:with-param 
				            name="message" 
				            select="concat('Error Map33: TYPE ',$derived-type,
					    ' not found or not based on ',$based-on-type)"/>
					</xsl:call-template>    
		</xsl:when>
		<xsl:otherwise>
			<br/>
			TYPE <xsl:value-of select="$derived-type"/> found 
			and based on <xsl:value-of select="$based-on-type"/>
			<br/>		
		</xsl:otherwise>
	</xsl:choose>
	
</xsl:template>


<xsl:template match="word" mode="test">
	<xsl:param name="schemas" />	



	<xsl:if test="string-length(.) != string-length(translate(.,$UPPER,'')) and 
		not(name(preceding-sibling::*[2]) ='subtype-template' or  
		name(preceding-sibling::*[2]) ='supertype-template' or
		name(preceding-sibling::*[2]) ='mapping-of') "><!-- MWD: mapping-of line added -->
		!! UPPERCASE Not expected: <xsl:value-of select="." /> !!<br/>
	</xsl:if>
	
	<xsl:choose>
		<xsl:when test="string-length(.) != string-length(translate(.,$UPPER,'')) and 
		( name(preceding-sibling::*[2]) ='subtype-template' or  
		name(preceding-sibling::*[2]) ='supertype-template') " >
			<!-- is a subtype or supertype template so ignore -->
			<!-- could check it is found in ARMs ??? -->
		</xsl:when>

    <!-- MWD: this when clause added -->
		<xsl:when test="string-length(.) != string-length(translate(.,$UPPER,'')) and 
		( name(preceding-sibling::*[2]) ='mapping-of' ) " >
			<!-- is a MAPPING_OF so ignore -->
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
                                <xsl:when test="name(preceding-sibling::*[1]) ='start-paren' and 
					following-sibling::*[1]='MAPPING_OF'">
                                  <!-- matches (/MAPPING_OF  -->
				</xsl:when>
                                <xsl:when test="name(preceding-sibling::*[1]) ='end-paren' and 
					name(preceding-sibling::*[3]) ='MAPPING_OF'">
                                  <!-- matches MAPPING_OF(State_definition)/  -->
                                  <xsl:message>MAPPING_OF(State_definition)/</xsl:message>
				</xsl:when>
                                
				<xsl:otherwise>
				<!-- ?? Possible syntax ERROR: <xsl:value-of select="." /> !! -->
					<xsl:call-template name="error_message">
			
					  <xsl:with-param name="inline" select="'yes'"/>
					  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
				          <xsl:with-param 
			        	    name="message" 
				            select="concat('Error Map17: Possible syntax ERROR: ',name(preceding-sibling::*[1]),.,name(following-sibling::*[1]))"/>
					</xsl:call-template>    
				</xsl:otherwise>
			</xsl:choose>
	
		</xsl:when>

		<xsl:when test="string-length(.) != string-length(translate(.,'&gt;&lt;-',''))" >
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
		            select="concat('Error Map25B: ',.,' not found in relevant schemas')"/><!-- MWD Map25 changed to Map25B -->
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



		<xsl:when
                  test="name(./preceding-sibling::*[1])='start-paren' and  ./preceding-sibling::*[2]='MAPPING_OF'">
                  !! Check that <xsl:value-of select="."/> is in the ARM and in the extended select !!
                </xsl:when>
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
                        <xsl:when test=".='MAPPING_OF'">
                          <xsl:variable name="mapped_to_ARM_entity_name" select="./following-sibling::*[2]"/>
                          <xsl:choose>
                            <xsl:when
                              test="$arm_node//entity[@name=$mapped_to_ARM_entity_name] 
                                    | $arm_node//typename[@name=$mapped_to_ARM_entity_name] 
                                    | $arm_node//type/select[contains(concat(' ',@selectitems,' '),concat(' ',$mapped_to_ARM_entity_name,' '))]
				 ">
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:call-template name="error_message">
                                <xsl:with-param name="inline" select="'yes'"/>
                                <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
                                <xsl:with-param 
                                  name="message" 
                                  select="concat('Error MappingOf01:
',$mapped_to_ARM_entity_name,' is not an ARM ENTITY type or referenced within the arm ')"/>
                              </xsl:call-template>    
                            </xsl:otherwise>
                          </xsl:choose>
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



<xsl:template match="is-supertype-of | is-subtype-of" mode="test">
	<xsl:param name="schemas" />	
	<!-- test that types are properly related -->

<!--	<xsl:variable name="first" select="string(preceding-sibling::*[not(name() ='new-line')][1])" />
	<xsl:variable name="second" select="string(following-sibling::*[not(name() ='new-line')][1])" />  -->
	<xsl:variable name="first" select="string(preceding-sibling::word[1])" />
	<xsl:variable name="second">
		<xsl:choose>
			<xsl:when test="name(following-sibling::*[not(name() ='new-line')][1])='start-constraint'" >
				<xsl:value-of select="string(following-sibling::word[preceding-sibling::end-constraint][1])" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="string(following-sibling::word[1])" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>


<!-- note that this will only test one possible supertype relationship. 
It is possible that two supertypes are declared delineated by [] [] 
-->

	<xsl:choose>
		<xsl:when test="name()='is-supertype-of'">

			<xsl:choose>
				<xsl:when test="name(following-sibling::*[not(name() ='new-line')][1])='subtype-template'">
					<!-- could check to see if valid arm entity 
					 but for now do nothing ??? -->
				</xsl:when>
				<xsl:when test="not($schemas//entity[@name=$second]
					[contains(concat(' ',@supertypes,' '),concat(' ',$first,' '))])" >
					<xsl:call-template name="error_message">			
					  <xsl:with-param name="inline" select="'yes'"/>
					  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
				          <xsl:with-param 
			        	    name="message" 
				            select="concat('Error Map34: ERROR in subtyping in PATH: ', $first,
					' is not a supertype of ',$second)"/>
					</xsl:call-template>    

				</xsl:when>
				<xsl:otherwise>
					<br/>			
					<xsl:value-of select="concat( $first,
					' is a supertype of ',$second)" />					
				</xsl:otherwise>
			</xsl:choose>

		</xsl:when>
		<xsl:when test="name()='is-subtype-of'">
			<xsl:choose>
				<xsl:when test="name(following-sibling::*[not(name() ='new-line')][1])='subtype-template'">
					<!-- could check to see if valid arm entity 
					 but for now do nothing ??? -->
				</xsl:when>
				<xsl:when test="not($schemas//entity[@name=$first]
					[contains(concat(' ',@supertypes,' '),concat(' ',$second,' '))])" >
					<xsl:call-template name="error_message">			
					  <xsl:with-param name="inline" select="'yes'"/>
					  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
				          <xsl:with-param 
			        	    name="message" 
				            select="concat('Error Map35: ERROR in subtyping in PATH: ', $first,
					' is not a subtype of ',$second)"/>
					</xsl:call-template>    				
				</xsl:when>
				<xsl:otherwise>
					<br/>			
					<xsl:value-of select="concat($first,
					' is a subtype of ',$second)" />					
				</xsl:otherwise>
			</xsl:choose>

		</xsl:when>
		<xsl:otherwise>
		</xsl:otherwise>
	</xsl:choose>
	
</xsl:template>








</xsl:stylesheet>
