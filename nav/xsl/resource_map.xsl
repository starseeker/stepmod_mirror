<?xml version="1.0" ?>
<!--
     Stylesheet to produce check mapping table syntax
	Nigel Shaw 
-->

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:saxon="http://icl.com/saxon"
  version="1.0"
  >

  <xsl:import href="../../xsl/common.xsl"/>
  <xsl:import href="mapping_parse.xsl"/>


  <xsl:variable name="rep_index"
    select="document('../../repository_index.xml')"/>

  <xsl:variable name="DETAILS"
    select="'TRUE'"/>

  <xsl:variable name="this-resource-schema"
    select="/stylesheet_application/@directory"/>

  <xsl:variable name="mappings-result">
              <xsl:apply-templates select="$rep_index//modules/module" mode="mapping-full"/>
  </xsl:variable>


<xsl:output method="html" />

<xsl:template match="/" >

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
      <TITLE>Module repository - mappings for schema <xsl:value-of select="$this-resource-schema" /></TITLE>
        <SCRIPT language="JavaScript"><xsl:comment><![CDATA[
          function swap(ShowDiv, HideDiv) {
            show(ShowDiv) ;
            hide(HideDiv) ;
          }

          function show(DivID) {
            DivID.style.display="block";
          }

          function hide(DivID) {
            DivID.style.display="none";
          }

        ]]></xsl:comment></SCRIPT>
    </HEAD>
    <BODY>

	<H1>Resource Mappings  for schema <xsl:value-of select="$this-resource-schema" /></H1>
	<p>
	The following table that is ordered by entity 
	and shows those Arm elements (and their respective modules) that use each resource entity in the mapping.
	Clicking on a resource schema will take you to the relevant section of the table.
	<br/>
	Where entries appear above the line, the resource entity is directly referenced as an MIM element. 
	<br/>
	Where entries appear below the line, the resource entity is referenced in the reference path.
	<br/>
	Mappings of resource entity attributes can be shown by choosing the "Show Attributes" link on each entity's entry.
	</p>

<!--	<blockquote>
        <table width="95%" border="0" cellspacing="0" cellpadding="4">
              <xsl:apply-templates select="$rep_index//resources/resource" mode="index">
                 <xsl:sort select="@name"/>
              </xsl:apply-templates>
        </table>
	</blockquote>
-->
	<hr/>


      <xsl:choose>
	<xsl:when test="function-available('msxsl:node-set')">

              <xsl:apply-templates select="$rep_index//resources/resource[@name=$this-resource-schema]" mode="map">
		<xsl:with-param name="mappings" select="msxsl:node-set($mappings-result)" />
                <xsl:sort select="@name"/>
              </xsl:apply-templates>
	</xsl:when>
	
	<xsl:when test="function-available('saxon:node-set')">

              <xsl:apply-templates select="$rep_index//resources/resource[@name=$this-resource-schema]" mode="map">
		<xsl:with-param name="mappings" select="saxon:node-set($mappings-result)" />
                <xsl:sort select="@name"/>
              </xsl:apply-templates>
	</xsl:when>

	<xsl:otherwise>
		<br/>
		STYLESHEET set up to work with msxsl: and saxon:. Neither is available.
		<br/>
	</xsl:otherwise>

      </xsl:choose>	

    </BODY>
  </HTML>
</xsl:template>

<xsl:template match="resource" mode="map">
  <xsl:param name="mappings" />

  <xsl:variable name="file" select="concat('../../data/resources/',@name,'/',@name,'.xml')"/>

  <xsl:variable name="res_file"
    select="document($file)"/>

   	<H2><a name="{@name}"><xsl:value-of select="@name" /></a>
	</H2>
	

	<xsl:apply-templates select="$res_file/express/schema/entity" mode="map" >
		<xsl:with-param name="mappings" select="$mappings" />
	</xsl:apply-templates>



</xsl:template>

<xsl:template match="resource" mode="index">
   	<tr>
		<td>
			<b>
				<a href="#{@name}"><xsl:value-of select="@name" /></a>
			</b>
		</td>
	</tr>

</xsl:template>


<xsl:template match="entity" mode="map">
	<xsl:param name="mappings" />

	<xsl:variable name="ent_name" select="@name"/>
	<xsl:variable name="ent_name_bracket" select="concat('[',@name,']')"/>
	<xsl:variable name="schema_name" select="../@name"/>

	<table width="95%" border="3" cellspacing="0" cellpadding="4">

	<TR>
		<TD valign="Top" width="40%">
                  <!-- RB - corrected URL -->
                  <a href="../{$schema_name}/{$schema_name}{$FILE_EXT}#{$schema_name}.{$ent_name}">
				<xsl:value-of select="@name" />
			</a>
			<br/>
                        <!-- RB - corrected URL -->
                        [ <a href="../{$schema_name}/{$schema_name}{$FILE_EXT}">
			<xsl:value-of select="$schema_name" /> </a> ]

			 <xsl:if test="$DETAILS='TRUE' and ./explicit" >
				<DIV id="NoDetails{$ent_name}xxx{$schema_name}" >
					<p align="right" >
					<A href="javascript:swap(Details{$ent_name}xxx{$schema_name},
					NoDetails{$ent_name}xxx{$schema_name});" >Show Attributes</A>
					</p>
				</DIV>
			</xsl:if>

		</TD>	
		<TD>
			<xsl:apply-templates select="$mappings//mapping[descendant::aimelt=$ent_name 
						or contains(descendant::aimelt,$ent_name_bracket)]" mode="map"/>

			<hr/>

			<xsl:apply-templates select="$mappings//mapping[descendant::aimelt!=$ent_name]
								[descendant::refpath/word=$ent_name]
								" mode="map"/>

		</TD>	
	</TR>

	</table>
	
			 <xsl:if test="$DETAILS='TRUE' and ./explicit" >

<!--				<xsl:apply-templates select="." mode="attribute-level-map" >
					<xsl:with-param name="mappings" select="$mappings" />
				</xsl:apply-templates>
-->

				<DIV id="Details{$ent_name}xxx{$schema_name}" STYLE="display:none" >

					<table width="95%" border="3" cellspacing="0" cellpadding="4">

						<TR>
						<TD align="center" colspan="2">
						<A href="javascript:swap(NoDetails{$ent_name}xxx{$schema_name},
				Details{$ent_name}xxx{$schema_name});" >Hide Attributes of <xsl:value-of select="$ent_name"/>
						</A>

						</TD>	
					</TR>

<!--						<xsl:apply-templates select="explicit" mode="map" >
							<xsl:with-param name="mappings" select="$mappings" />
						</xsl:apply-templates>
-->

					<xsl:for-each select="explicit" >

						<xsl:variable name="attr_name" select="concat($ent_name,'.',@name)"/>

	<TR>
		<TD valign="Top" width="40%">
			<a href="../resources/{$schema_name}/{$schema_name}{$FILE_EXT}#{$schema_name}.{$ent_name}">
				<xsl:value-of select="$attr_name" />
			</a>
			<br/>
			[ <a href="../resources/{$schema_name}/{$schema_name}{$FILE_EXT}">
			<xsl:value-of select="$schema_name" /> </a> ]

		</TD>	
		<TD>
			<xsl:apply-templates select="$mappings//mapping[descendant::aimelt=$attr_name]" mode="map"/>

			<hr/>


			<xsl:apply-templates select="$mappings//mapping[descendant::aimelt!=$attr_name]
								[descendant::refpath/word=$attr_name]" mode="map"/>

		</TD>	
	</TR>


						</xsl:for-each>


						</table>

					</DIV>
					
			</xsl:if>



</xsl:template>

<xsl:template match="entity" mode="attribute-level-map">
	<xsl:param name="mappings" />

	<xsl:variable name="ent_name" select="@name"/>
	<xsl:variable name="schema_name" select="../@name"/>


	<DIV id="Details{$ent_name}xxx{$schema_name}" STYLE="display:none" >

	<table width="95%" border="3" cellspacing="0" cellpadding="4">

		<TR>
			<TD align="center" colspan="2">
				<A href="javascript:swap(NoDetails{$ent_name}xxx{$schema_name},
				Details{$ent_name}xxx{$schema_name});" >Hide Attributes of <xsl:value-of select="$ent_name"/>
				</A>

			</TD>	
		</TR>

		<xsl:apply-templates select="explicit" mode="map" >
			<xsl:with-param name="mappings" select="$mappings" />
		</xsl:apply-templates>
	
	</table>

	</DIV>
<!--
	<DIV id="NoDetails{$ent_name}xxx{$schema_name}" >

	<table width="95%" border="3" cellspacing="0" cellpadding="4">

		<TR>
			<TD align="center" colspan="2" width="40%">
				<A href="javascript:swap(Details{$ent_name}xxx{$schema_name},
				NoDetails{$ent_name}xxx{$schema_name});" >Attributes of <xsl:value-of select="$ent_name"/>
				</A>

			</TD>	
		</TR>

	</table>

	</DIV>
-->	
</xsl:template>



<xsl:template match="mapping" mode="map">

	<xsl:variable name="mod_name" select="../@name"/>

	<xsl:choose>
		<xsl:when test="@attribute" >	
			<a href="../../modules/{$mod_name}/sys/5_mapping{$FILE_EXT}#{@entity}.{@attribute}">
			<xsl:value-of select="@entity" />.<xsl:value-of select="@attribute" />
			</a>
		</xsl:when>
		<xsl:otherwise>
			<a href="../../modules/{$mod_name}/sys/5_mapping{$FILE_EXT}#{@entity}">
				<xsl:value-of select="@entity" />
			</a>
		</xsl:otherwise>
	</xsl:choose>
	[<a href="../../modules/{$mod_name}/sys/5_mapping{$FILE_EXT}#mappings">
	 <xsl:value-of select="../@name" />
	 </a>]
	<br/>

</xsl:template>

<xsl:template match="explicit" mode="map">
	<xsl:param name="mappings" />

	<xsl:variable name="ent_name" select="../@name"/>
	<xsl:variable name="schema_name" select="../../@name"/>
	<xsl:variable name="attr_name" select="concat($ent_name,'.',@name)"/>
	
	<TR>
		<TD valign="Top" width="40%">
			<a href="../../resources/{$schema_name}/{$schema_name}{$FILE_EXT}#{$schema_name}.{$ent_name}">
				<xsl:value-of select="$attr_name" />
			</a>
			<br/>
			[ <a href="../../resources/{$schema_name}/{$schema_name}{$FILE_EXT}">
			<xsl:value-of select="$schema_name" /> </a> ]

		</TD>	
		<TD>
			<xsl:apply-templates select="$mappings//mapping[descendant::aimelt=$attr_name]" mode="map"/>

			<hr/>


			<xsl:apply-templates select="$mappings//mapping[descendant::aimelt!=$attr_name]
								[descendant::refpath/word=$attr_name]" mode="map"/>

		</TD>	
	</TR>

</xsl:template>


</xsl:stylesheet>

