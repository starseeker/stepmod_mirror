<?xml version="1.0"?>
<!--
     $Id: express.xsl,v 1.1 2001/10/05 07:52:22 robbod Exp $

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

<!-- Variable to control in-code hyperlinks - set to ON or OFF -->
<xsl:variable name="inline-links">ON</xsl:variable>


<xsl:key name="express_objects" match="entity|type" use="@name"/>

<xsl:key name="interfaced_objects" match="interfaced.item" use="@name"/>



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

<!--
     Given a schema name return the path to the express file.
     It is assumed that every module is stored in a directory which is
     given the name of the module.
     It is also assumed that all short form schema end in _mim or _arm
     If they do not then the schema is an IR
-->
<xsl:template name="express_file">
  <xsl:param name="schema_name"/>

  <!-- utility var to make it easier to strip out the schema name -->
  <xsl:variable name="schema_name_tmp"
    select="concat($schema_name,';')"/>

  <xsl:variable name="filepath">
    <xsl:choose>
      <xsl:when test="contains($schema_name_tmp,'_mim;')">
        <xsl:value-of 
          select="concat(substring-before($schema_name_tmp,'_mim;'),
                  '/mim',$FILE_EXT)"/>
      </xsl:when>

      <xsl:when test="contains($schema_name_tmp,'_arm;')">
        <xsl:value-of 
          select="concat(substring-before($schema_name_tmp,'_arm;'),
                  '/arm',$FILE_EXT)"/>
      </xsl:when>

      <xsl:otherwise>
        <xsl:value-of 
          select="concat('resources/',$schema_name,$FILE_EXT)"/>
      </xsl:otherwise>

    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$filepath"/>  
</xsl:template>

<!--
     Output up a URL to an Express object (either a TYPE or ENTITY)
     The object may be defined within a schema in the current file,
     or through a USE-FROM or REFERENCE interface.
     If it is a USE-FROM or REFERENCE, the schema defined in the interface
     may be defined in this file or externally
-->
<xsl:template name="link_object">
  <xsl:param name="object_name"/>
  <xsl:variable 
    name="object_in_file"
    select="key('express_objects',$object_name)"/>

  <xsl:variable 
    name="object_in_interface"
    select="key('interfaced_objects',$object_name)"/>

  <xsl:choose>
    <!-- 
         check if there are any entities or types in the current file
         called object_name 
         -->
    <xsl:when test="$object_in_file">
      <xsl:variable 
        name="xref"
        select="concat($object_in_file/../@name,'.',$object_name)"/>
      <A HREF="#{$xref}">
        <xsl:value-of select="$object_name"/>
      </A>
    </xsl:when>

    <xsl:when test="$object_in_interface">
      <!-- 
           check if the object has been explicitly identified through an
           interface. If so then work out the HREF from the schema name
           -->
      <xsl:variable name="express_file">
        <xsl:call-template name="express_file">
          <xsl:with-param 
            name="schema_name" 
            select="$object_in_interface/../@schema"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:variable name="xref"
        select="concat($object_in_interface/../@schema,'.',$object_name)"/>
      
      <A HREF="{$express_file}#{$xref}">
        <xsl:value-of select="$object_name"/>
      </A>
      
    </xsl:when>

    <xsl:otherwise>
      <!--
           the object must be included through one of the interfaces
           importing ALL objects - need to search all the
           ** RMB - need to implement this.
           The idea is to loop through all external schemas using document
           to change the focus of the key
           Note that this may be recursive
           -->
      <A HREF="#ERROR">
        <xsl:value-of select="$object_name"/>
      </A>

    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<!-- Output a linked index of the Schema Entities and  types -->
<xsl:template match="schema" mode="TOC">
  <xsl:variable 
    name="schema-ref" 
    select="concat('#',@name)"/>

  <HR/>
  <H2>
    SCHEMA 
    <xsl:value-of select="@name"/>
  </H2>
  <xsl:apply-templates select="./description"/>

  <!-- output a list of linked constants as an index -->
  <xsl:variable 
    name="constant_refs"
    select="concat('constant_declarations.',@name)"/>
  <H3> 
  <A NAME="{$constant_refs}">
    CONSTANT Declarations
  </A>
  <font size="1">
    [Schema: 
    <A HREF="{$schema-ref}" >
      <xsl:value-of select="@name"/>
    </A>]
  </font>
  </H3>

  <xsl:variable name="constantcount" select="(count(./constant)+1) div 2"/>
  <blockquote>
    <table width="90%" cellspacing="0" cellpadding="4">
      <tr>
        <td>
          <font size="-1"> 
            <xsl:apply-templates 
              select="./constant[not(position() > $constantcount) ]" 
              mode="link">
              <xsl:sort select="@name" />
            </xsl:apply-templates>    
          </font>              
        </td>
        <td> 
          <font size="-1"> 
            <xsl:apply-templates 
              select="./constant[(position() > $constantcount) ]" 
              mode="link">
              <xsl:sort select="@name" />
            </xsl:apply-templates>
          </font>           
        </td>
      </tr>
    </table>
  </blockquote>


  <!-- output a list of linked types as an index -->
  <xsl:variable 
    name="type_refs"
    select="concat('type_declarations.',@name)"/>
  <H3> 
  <A NAME="{$type_refs}">
    TYPE Declarations
  </A>
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
  <xsl:apply-templates select="./constant"/>
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

<xsl:template match="constant" mode="link">
  <xsl:variable name="xref" >      
    <xsl:value-of select="concat(../@name,'.',@name)"/>
  </xsl:variable>   
  <A HREF="#{$xref}">
    <xsl:value-of select="@name" />
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

<xsl:template match="constant">
  <xsl:variable 
    name="schema-name" 
    select="../@name"/>      

  <xsl:variable 
    name="xref"    
    select="concat($schema-name,'.',@name)"/>
    
  <xsl:variable 
    name="graphics" 
    select="''"/>

  <xsl:variable 
    name="schema-ref" 
    select="concat('#',$schema-name)"/>
    
  <hr/>
  <h3>
    <A NAME="{$xref}">
      <xsl:value-of select="@name" />  
    </A>
    <font size="1">
      [Schema: 
      <A HREF="{$schema-ref}" >
        <xsl:value-of select="$schema-name"/>
      </A>
      ]
    </font>
  </h3>
  <blockquote>
    <p>
      <xsl:apply-templates select="./description"/>
    </p>
    *)
    <blockquote>
      <code>
        CONSTANT<br/>
        <xsl:value-of select="@name"/> : <xsl:value-of select="@expression"/><br/>
        END_CONSTANT;
      </code>
    </blockquote>
    (*
  </blockquote>
</xsl:template>

<xsl:template match="type" >
  <xsl:variable 
    name="schema-name" 
    select="../@name"/>      

  <xsl:variable 
    name="xref"    
    select="concat($schema-name,'.',@name)"/>
    
  <xsl:variable 
    name="graphics" 
    select="''"/>

  <xsl:variable 
    name="schema-ref" 
    select="concat('#',$schema-name)"/>
    
  <hr/>
  <h3>
    <A NAME="{$xref}">
      <xsl:value-of select="@name" />  
    </A>
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
    <p>
      <xsl:apply-templates select="./description"/>
    </p>
    *)
    <xsl:apply-templates/>
    (*
  </blockquote>
</xsl:template>


<xsl:template match="typename">
  <blockquote>
    <code>
      TYPE 
      <xsl:value-of select="../@name" />
        = 
      <xsl:value-of select="@name" />; <br/>
      END_TYPE; <br/>
    </code>
  </blockquote>
</xsl:template>


<xsl:template match="builtintype">
  <blockquote>
    <code>
      TYPE 
      <xsl:value-of select="../@name" />
        = 
      <xsl:value-of select="@type" />; <br/>
      END_TYPE; <br/>
    </code>
  </blockquote>
</xsl:template>


<xsl:template match="select">
  <blockquote>
    <code>
      TYPE <xsl:value-of select="../@name" /> = SELECT
      <!-- *RMB* just output the contents for now - will change the DTD -->
      <xsl:value-of 
        select="concat('(',translate(normalize-space(@selectitems),' ', ', '),');')"/>      
      <br/>END_TYPE; <br/>
    </code>
  </blockquote>
  <xsl:variable name="sitem"
    select="substring-before(@selectitems,' ')"/>
  <xsl:call-template name="link_object">
    <xsl:with-param name="object_name" select="$sitem"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="enumeration">
  <blockquote>
    <code>
      TYPE <xsl:value-of select="../@name" /> = ENUMERATION OF <br/>
      &#160; &#160; 
    <xsl:value-of 
        select="concat('(',translate(normalize-space(@items),' ', ', '),');')"/>
      <br/> END_TYPE; <br/>
    </code>
  </blockquote>  
</xsl:template>





</xsl:stylesheet>

