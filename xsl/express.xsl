<?xml version="1.0"?>
<!--
     $Id: express.xsl,v 1.35 2001-09-04 14:23:37+01 rob Exp rob $

  Author: Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep and supplied to NIST under contract.
  Purpose: 
     Used to display the commented XML encoded Express generated 
     from GraphicalExpress 
-->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>

  <xsl:import href="common.xsl"/>

  <xsl:output method="html"/>

<xsl:template match="express" >
  <HTML>
    <HEAD>
      <xsl:apply-templates select="./application" mode="meta"/>
      <TITLE></TITLE>
    </HEAD>
    <BODY>
      <xsl:apply-templates select="./application" mode="body"/>
      <xsl:apply-templates select="./schema"/>
    </BODY>
  </HTML>
</xsl:template>

<xsl:template match="description">
</xsl:template>


<!--
     Insert META data about the application that generated the Express XML
-->
<xsl:template match="application" mode="meta">
  <xsl:variable 
    name="name" 
    select="concat(@name,' ',@version)"/>
  <xsl:variable name="source" select="@source"/>

  <xsl:call-template name="meta-elements">
    <xsl:with-param name="name" select="'GENERATOR'"/>
    <xsl:with-param name="content" select="$name"/>
  </xsl:call-template>

  <xsl:call-template name="meta-elements">
    <xsl:with-param name="name" select="'EXPRESS-FILE'"/>
    <xsl:with-param name="content" select="@source"/>
  </xsl:call-template>

</xsl:template>



<xsl:template match="application" mode="body">
  <xsl:variable 
    name="name" 
    select="concat(@name,' ',@version)"/>
  <xsl:variable name="source" select="@source"/>

  <hr/>
  <table>
    <tr>
      <td>Application:</td>
      <td>
        <xsl:value-of select="$name"/>
      </td>
    </tr>
    <tr>
      <td>Express:</td>
      <td>
        <xsl:value-of select="@source"/>
      </td>        
    </tr>
  </table>
  <hr/>
</xsl:template>


<!-- Output a linked index of the Schema Entities and  types -->
<xsl:template match="schema" mode="TOC">
  <HR/>
  <H2>
    SCHEMA 
    <xsl:value-of select="@name"/>
  </H2>
  <xsl:apply-templates select="./description"/>

  <!-- output a list of linked types as an index -->
  <xsl:variable 
    name="type_refs"
    select="concat('type_declarations.',@name)"/>
  <H3> 
  <A NAME="{$type_refs}">
    TYPE Declarations
  </A>
  <xsl:variable 
    name="schema-ref" 
    select="concat('#',@name)"/>
  <font size="1">
    [Schema: 
    <A HREF="{$schema-ref}" >
      <xsl:value-of select="@name"/>
    </A>]
  </font>
  </H3>

  <xsl:variable name="typecount" select="(count(./type)+1) div 2"/>
  <blockquote>
    <table width="90%" cellspacing="0" cellpadding="4">
      <tr>
        <td>
          <font size="-1"> 
            <xsl:apply-templates 
              select="./type[not(position() > $typecount) ]" 
              mode="link">
              <xsl:sort select="@name" />
            </xsl:apply-templates>    
          </font>              
        </td>
        <td> 
          <font size="-1"> 
            <xsl:apply-templates 
              select="./type[(position() > $typecount) ]" 
              mode="link">
              <xsl:sort select="@name" />
            </xsl:apply-templates>
          </font>           
        </td>
      </tr>
    </table>
  </blockquote>

  <!-- output a list of linked types as an index -->
  <xsl:variable name="entity_refs"
    select="concat('entity_declarations.',@name)"/>
  <h3>
    <A NAME="{$entity_refs}">
      ENTITY Declarations  
    </A>
    <!-- for some reason SAXON wants schema-ref redeclared here -->
    <xsl:variable 
      name="schema-ref2" 
      select="concat('#',@name)"/>
    <font size="1">
      [Schema: 
      <A HREF="{$schema-ref2}" >
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
            <xsl:apply-templates select="./entity[not(position() > $entcount) ]" mode="link">
              <xsl:sort select="@Name"/>
            </xsl:apply-templates>
          </font>
        </td>
        <td>
          <font size="-1" > 
            <xsl:apply-templates select="./entity[position() > $entcount]" mode="link">
              <xsl:sort select="@name"/>
            </xsl:apply-templates>
          </font>
        </td>
      </tr>
    </table>
  </blockquote>
  <hr/>
</xsl:template>


<xsl:template match="schema">
  <xsl:apply-templates select="." mode="TOC"/>
  <blockquote>
    *) <br/>
    SCHEMA <xsl:value-of select="@name"/>;<br/>
    (* 
  </blockquote>
  <!-- now output the full documentation -->
  <xsl:apply-templates select="./interface" mode="code"/>
    
  <xsl:apply-templates select="./type"/>
  <xsl:apply-templates select="./entity"/>

  <blockquote>
    *) <br/>
    END_SCHEMA; <br/>
    (* <br/>
  </blockquote>
</xsl:template>

<xsl:template match="schema" mode="link">
  <A HREF="{@name}">
    <xsl:value-of select="./SCHEMA.Name" />  
  </A>
  <br/>
</xsl:template>


<xsl:template match="type" mode="link">
  <xsl:variable name="xref" >      
    <xsl:value-of select="concat(../@name,'.',@name)"/>
  </xsl:variable>   
  <A HREF="#{$xref}">
    <xsl:value-of select="@name" />
    </A>
   <br/>
</xsl:template>

<xsl:template match="entity" mode="link">
  <xsl:variable name="xref"      
    select="concat(../@name,'.',@name)" /> 
  <A HREF="#{$xref}">
    <xsl:value-of select="@name" /> 
  </A>
  <br/>
</xsl:template>


<xsl:template match="type" >
  <hr/>
  <h3>
    <xsl:variable 
      name="schema-name" 
      select="../@name"/>      

    <xsl:variable 
      name="xref"    
      select="concat($schema-name,'.',@name)" />

    <A NAME="{$xref}">
      <xsl:value-of select="@name" />  
    </A>
    <xsl:variable 
      name="graphics" 
      select="concat(
              //GraphicalExpress/GRAPHICS/@base,
              ./TYPE.Graphics/@Loc)" />

    <xsl:variable 
      name="schema-ref" 
      select="concat('#',$schema-name)" />
    <font size="1">
      [Schema: 
      <A HREF="{$schema-ref}" >
        <xsl:value-of select="$schema-name"/>
      </A>
      ]
    </font>
      <xsl:if test="$graphics">
        <xsl:variable 
          name="graphics-url" 
          select="concat($graphics,'.html')" />
      &#160;<A HREF="{$graphics-url}"> <IMG SRC="../../stylesheets/exp_g.gif" ALT="[EXPRESS-G]" target="content" align="absbottom" BORDER="0"/> </A>
      </xsl:if>
  </h3>
	<blockquote>
	<p> <xsl:apply-templates select="./TYPE.Comment" />
	</p>
        <p>
  	<xsl:apply-templates select="." mode="ext_comments" />
        </p>
	*)
	<blockquote><code>
	<xsl:choose>
		<xsl:when test="@Kind='SELECT'">
			<!-- case for SELECT TYPE -->
			TYPE <xsl:value-of select="@Name" /> = SELECT (
			<xsl:for-each select="./TYPE.SelectList/TYPE.SelectItem">
				<xsl:choose>
					<xsl:when test="$inline-links = 'ON'" >
					    <xsl:apply-templates select="." mode="link"/> 
					</xsl:when>
					<xsl:otherwise>
					        <xsl:value-of select="." />
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="not(position()=last())"> , </xsl:if>
			</xsl:for-each>
			); <br/>
			<xsl:apply-templates select="./WHERE" mode="code" />
		</xsl:when>
		<xsl:when test="@Kind='Defined'">
			<!-- case for Defined TYPE -->
			TYPE <xsl:value-of select="@Name" /> = 
			<xsl:for-each select="./TYPE.Aggregate">
			<xsl:sort select="@Level"/>
			<xsl:apply-templates select="." />
			</xsl:for-each>
			<xsl:apply-templates select="./TYPE.Type" />
			; <br/>
			<xsl:apply-templates select="./WHERE" mode="code" />
		</xsl:when>
		<xsl:when test="@Kind='ENUMERATION'">
			<!-- case for Enumerated TYPE -->
                        <!--
			<p> Enumerated type </p>
                        -->
			TYPE <xsl:value-of select="@Name" /> = ENUMERATION OF (
			<xsl:for-each select="./TYPE.EnumList/TYPE.EnumItem">
				<xsl:value-of select="." />
				<xsl:if test="not(position()=last())"> , </xsl:if>
			</xsl:for-each>
			
			); <br/>
			<xsl:apply-templates select="./WHERE" mode="code" />
		</xsl:when>
	</xsl:choose>
	END_TYPE; <br/>
      </code></blockquote>
	(*

	</blockquote>

<!-- provide links for referenced non-base types -->
	<blockquote>

	<xsl:choose>
		<xsl:when test="@Kind='SELECT' and $inline-links !='ON'">
			<!-- case for SELECT TYPE -->
			Referenced types: 
			<xsl:if test="not(./TYPE.SelectList/TYPE.SelectItem)" >
				<B> WARNING: No select items specified. </B> 
			</xsl:if>
			<xsl:for-each select="./TYPE.SelectList/TYPE.SelectItem">
                          <xsl:apply-templates select="." mode="link"/> 
                          <xsl:if test="not(position()=last())"> , </xsl:if>
			</xsl:for-each>
		</xsl:when>
	</xsl:choose>

	<xsl:apply-templates select="." mode="usedbyattrib" />
	<xsl:apply-templates select="." mode="usedasselect" />
	</blockquote>

</xsl:template>




</xsl:stylesheet>