<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
	$Id: express_toc.xsl,v 1.2 2002/10/08 10:20:08 mikeward Exp $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="../express_toc.xsl"/>
	<xsl:output method="html"/>
	
	<xsl:template match="express" mode="top_TOC">
	
		<h2>
			<a name="top">SCHEMA declarations</a>
		</h2>
		
		<xsl:variable name="schemacount" select="(count(./schema)+1) div 2"/>
		<blockquote>
			<table width="90%" cellspacing="0" cellpadding="4">
				<tr>
					<td>
						<xsl:apply-templates select="./schema[not(position() > $schemacount) ]" mode="toc-link">
							<xsl:sort select="@name"/>
						</xsl:apply-templates>
					</td>
					<td>
						<font size="-1" >
							<xsl:apply-templates select="./schema[position() > $schemacount]" mode="toc-link">
								<xsl:sort select="@name"/>
							</xsl:apply-templates>
						</font>
					</td>
				</tr>
			</table>
		</blockquote>
	</xsl:template>
	
	<xsl:template match="schema" mode="TOC">
		<xsl:variable name="xref" select="concat('index_',@name)"/>
		<HR/>
		<H2>
			<a name="#{$xref}">
				SCHEMA
				<xsl:value-of select="@name"/>
			</a>
		</H2>
		<xsl:apply-templates select="./description"/>
		<xsl:apply-templates select="." mode="TOC-constants"/>
		<xsl:apply-templates select="." mode="TOC-types"/>
		<xsl:apply-templates select="." mode="TOC-entities"/>
		<hr/>
	</xsl:template>
	
	<xsl:template match="schema" mode="TOC-constants">
		<xsl:if test="./constant">
			<xsl:variable name="schema-ref" select="concat('index_',@name)"/>
			<xsl:variable name="constant_refs" select="concat('constant_declarations.',@name)"/>
			<H2>
				<A NAME="{$constant_refs}">
					CONSTANT Declarations
				</A>
				<font size="1">
					[Schema:
					<A HREF="#{$schema-ref}">
						<xsl:value-of select="@name"/>
					</A>
					]
				</font>
			</H2>
			<xsl:variable name="constantcount" select="(count(./constant)+1) div 2"/>
			<blockquote>
				<table width="90%" cellspacing="0" cellpadding="4">
					<tr>
						<td>
							<font size="-1">
								<xsl:apply-templates select="./constant[not(position() > $constantcount) ]" mode="toc-link">
									<xsl:sort select="@name"/>
								</xsl:apply-templates>
							</font>
						</td>
						<td>
							<font size="-1">
								<xsl:apply-templates select="./constant[(position() > $constantcount) ]" mode="toc-link">
									<xsl:sort select="@name"/>
								</xsl:apply-templates>
							</font>
						</td>
					</tr>
				</table>
			</blockquote>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="schema" mode="TOC-types">
		<xsl:variable name="schema-ref" select="concat('index_',@name)"/>
			<xsl:if test="./type">
				<xsl:variable name="type_refs" select="concat('type_declarations.',@name)"/>
				<H2>
					<A NAME="{$type_refs}">
						TYPE Declarations
					</A>
					<font size="1">
						[Schema:
						<A HREF="#{$schema-ref}" >
							<xsl:value-of select="@name"/>
						</A>
						]
					</font>
				</HD23>
				<xsl:variable name="typecount" select="(count(./type)+1) div 2"/>
				<blockquote>
					<table width="90%" cellspacing="0" cellpadding="4">
						<tr>
							<td>
								<font size="-1">
									<xsl:apply-templates select="./type[not(position() > $typecount) ]" mode="toc-link">
										<xsl:sort select="@name"/>
									</xsl:apply-templates>
								</font>
							</td>
						<td>
            <font size="-1">
              <xsl:apply-templates 
                select="./type[(position() > $typecount) ]" 
                mode="toc-link">
                <xsl:sort select="@name"/>
              </xsl:apply-templates>
            </font>
          </td>
        </tr>
      </table>
    </blockquote>
  </xsl:if>
</xsl:template>

<!-- 
     output a list of linked entities as an index 
-->
<xsl:template match="schema" mode="TOC-entities">
  <xsl:variable 
    name="schema-ref" 
    select="concat('index_',@name)"/>
  <xsl:if test="./entity">
    <xsl:variable name="entity_refs"
      select="concat('entity_declarations.',@name)"/>
    <h3>
      <A NAME="{$entity_refs}">
        ENTITY Declarations  
      </A>
      <font size="1">
        [Schema: 
        <A HREF="#{$schema-ref}" >
          <xsl:value-of select="@name"/>
        </A>
        ]
      </font>
    </h3>
    <xsl:variable name="entcount" select="(count(./entity)+1) div 2"/>
    <blockquote>
      <table width="90%" cellspacing="0" cellpadding="4">
        <tr>
          <td>
            <font size="-1">
              <xsl:apply-templates select="./entity[not(position() > $entcount) ]" mode="toc-link">
                <xsl:sort select="@name"/>
              </xsl:apply-templates>
            </font>
          </td>
          <td>
            <font size="-1" > 
              <xsl:apply-templates select="./entity[position() > $entcount]" mode="toc-link">
                <xsl:sort select="@name"/>
              </xsl:apply-templates>
            </font>
          </td>
        </tr>
      </table>
    </blockquote>
  </xsl:if>
</xsl:template>

<xsl:template match="schema" mode="toc-link">
  <xsl:variable name="xref"
    select="concat('index_',@name)"/>
  <a href="#{$xref}">
    <xsl:value-of select="@name"/>
  </a>
  <br/>
</xsl:template>


<xsl:template match="constant" mode="toc-link">
  <xsl:variable name="xref" >      
    <xsl:value-of select="concat(../@name,'.',@name)"/>
  </xsl:variable>   
  <A HREF="#{$xref}">
    <xsl:value-of select="@name"/>
  </A>
  <br/>
</xsl:template>

<xsl:template match="type" mode="toc-link">
  <xsl:variable name="xref" >      
    <xsl:value-of select="concat(../@name,'.',@name)"/>
  </xsl:variable>   
  <A HREF="#{$xref}">
    <xsl:value-of select="@name" />
    </A>
   <br/>
</xsl:template>

<xsl:template match="entity" mode="toc-link">
  <xsl:variable name="xref"      
    select="concat(../@name,'.',@name)" /> 
  <A HREF="#{$xref}">
    <xsl:value-of select="@name" /> 
  </A>
  <br/>
</xsl:template>


</xsl:stylesheet>
