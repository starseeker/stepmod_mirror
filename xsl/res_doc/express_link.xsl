<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
     $Id: express_link.xsl,v 1.8 2009/07/03 12:12:31 robbod Exp $

  Author: Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep and supplied to NIST under contract.
  Purpose: 
     Used to establish links (URLs) for entities and types that are
     referenced in a schema 
-->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">

  <xsl:import href="common.xsl"/>


  <xsl:output method="html"/>


  <!-- +++++++++++++++++++
         Global variables
       +++++++++++++++++++ -->

    <!-- 
         variable name="global_xref_list"
       Global variable used by:
         link_object
         link_list
       Provides a lookup table of all the references for the entities and
       types indexed through all the interface specifications in the
       express.
       Note:  This variable must defined in each XSL that is used for
       formatting express.
         sect_4_info.xsl
         sect_5_mim.xsl
         sect_e_exp_arm.xsl
         sect_e_exp_mim.xsl

       These XSL import express_link.xsl
       -->

  <!-- a list of all the entities and resources defined in the resources.
       Used by link_resource_object to produce a URL
       This variable is overwritten when express_link.xsl is imported
       into another stylesheet.
       -->
    <xsl:variable name="global_xref_list"/>
  
  
<xsl:template name="build_schema_xref_list">
  <xsl:param name="schema_node"/>
  <xsl:param name="xref_list" select="'|'"/>
  
  <!-- get the entities / objects in the current schema and add them to
       the xref_list variable -->
  <xsl:variable name="l1_xref_list">
    <xsl:call-template name="get_objects_in_schema">
      <xsl:with-param name="xref_list" select="$xref_list"/>
      <xsl:with-param name="object_nodes" 
			select="$schema_node/entity|$schema_node/type|$schema_node/subtype.constraint|$schema_node/function|$schema_node/rule|$schema_node/procedure|$schema_node/constant"/>
    </xsl:call-template>        
  </xsl:variable>
    
  <!--<xsl:message>li{<xsl:value-of select="$l1_xref_list"/>}</xsl:message>-->      
  
  <!--<xsl:message>li{<xsl:value-of select="$l1_xref_list"/>}</xsl:message>-->
  
   
 
  

  <xsl:variable name="l2_xref_list">
    <!-- loop through all the interfaces in a schema -->
    <xsl:call-template name="build_interface_xref_list">
      <xsl:with-param name="interfaces" select="$schema_node/interface"/>
      <xsl:with-param name="xref_list" select="$l1_xref_list"/>
    </xsl:call-template>
  </xsl:variable>

    
  <!--<xsl:message>l2{<xsl:value-of select="$l2_xref_list"/>}</xsl:message>-->      
  

  <xsl:value-of select="$l2_xref_list"/>
</xsl:template>



  <xsl:template name="build_interface_xref_list">
    <xsl:param name="interfaces"/>
    <xsl:param name="indent" select="''"/>
    <xsl:param name="xref_list" select="''"/>
    
    <xsl:variable name="parent_schema_name" select="$interfaces/../@name"/>
    
    
    
    <xsl:variable name="interface_xref_list">
      <xsl:call-template name="build_complete_set_of_interface_nodes_and_get_objects">
        <xsl:with-param name="interfaces_param" select="$interfaces"/>
        <xsl:with-param name="list_of_schema_names_param" select="concat('|', $parent_schema_name)"/>
      </xsl:call-template>
    </xsl:variable>
    
    
    
    
    <xsl:value-of select="concat($xref_list, $interface_xref_list)"/>
    
  </xsl:template>
  
  
  <xsl:template name="build_complete_set_of_interface_nodes_and_get_objects">
    <!-- set of interface nodes -->
    <xsl:param name="interfaces_param"/>
    <!-- list of schema names intialized with name of schema providing initial set of interface nodes -->
    <xsl:param name="list_of_schema_names_param"/>
    
    <xsl:choose>
      <xsl:when test="$interfaces_param">
        <!-- get first interface node -->
        <xsl:variable name="first_interface_node" select="$interfaces_param[1]"/>
        
        
        
        <!-- get rest of  interface nodes -->
        <xsl:variable name="remaining_interface_nodes" select="$interfaces_param[not(position()=1)]"/>
        <!-- get name of schema referenced by the interface node -->
        <xsl:variable name="if_schema_name" select="$first_interface_node/@schema"/>
        <!-- get name of express file containing the schema -->
        
        
        
        <xsl:variable name="express_file_to_read">
          <xsl:call-template name="express_file_to_read">
            <xsl:with-param name="schema_name" select="$if_schema_name"/>
          </xsl:call-template>
        </xsl:variable>
        
       
        
        <!-- get schema node contained in express file -->
        <xsl:variable name="if_schema_node"
          select="document(string($express_file_to_read))//express/schema"/>
        
        
        <!-- add separator before name of schema -->
        <xsl:variable name="if_schema_name_list_item" select="concat('|', $if_schema_name)"/>
        
       
        
        <!-- get objects in schema unless the schema has already been visited  -->
        <xsl:variable name="new_xref_list">
          <xsl:choose>
            <xsl:when test="contains($list_of_schema_names_param, $if_schema_name_list_item)"/>
            <xsl:when test="$if_schema_node/entity or $if_schema_node/type or $if_schema_node/subtype.constraint or $if_schema_node/function or $if_schema_node/rule or $if_schema_node/procedure or $if_schema_node/constant">
              <xsl:call-template name="get_objects_in_schema">
                <xsl:with-param name="object_nodes" select="$if_schema_node/entity|$if_schema_node/type|$if_schema_node/subtype.constraint|$if_schema_node/function|$if_schema_node/rule|$if_schema_node/procedure|$if_schema_node/constant"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise/>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:value-of select="substring-after($new_xref_list, '|' )"/>
        <!-- recurse with the union of the remaining schema nodes passed to this template plus the schema nodes identified by the interfaces of the first schema node passed to this template -->
        
        <xsl:variable name="if_schema_node_interface" select="$if_schema_node/interface"></xsl:variable>
        
        <xsl:choose>
          <xsl:when test="$remaining_interface_nodes or $if_schema_node_interface">
            <!-- check whether schema has already been visited and only pass schema node interfaces if appropriate  -->
            <xsl:choose>
              <xsl:when test="contains($list_of_schema_names_param, $if_schema_name_list_item)">
                <xsl:call-template name="build_complete_set_of_interface_nodes_and_get_objects">
                  <xsl:with-param name="interfaces_param" select="$remaining_interface_nodes"/>
                  <xsl:with-param name="list_of_schema_names_param" select="concat($list_of_schema_names_param, $if_schema_name_list_item)"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="build_complete_set_of_interface_nodes_and_get_objects">
                  <xsl:with-param name="interfaces_param" select="$remaining_interface_nodes|$if_schema_node/interface"/>
                  <xsl:with-param name="list_of_schema_names_param" select="concat($list_of_schema_names_param, $if_schema_name_list_item)"/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise/>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:template>



<xsl:template name="build_xref_list">
  <xsl:param name="express"/>
  <!-- the variable used to collect up the entities and types found in
       interfaced schemas -->
  <xsl:param name="xref_list" select="'|'"/>
  

  <!-- there should only be one schema in a module, but loop just in case
       there is more than one. -->
  <xsl:for-each select="$express/schema">
    
    <!-- add all the entities and types in the schema to
         xref_list -->
    
    <!-- loop through all the interfaces in a schema-->
    <xsl:call-template name="build_schema_xref_list">
      <xsl:with-param name="schema_node" select="."/>
      <xsl:with-param name="xref_list" select="$xref_list"/>
    </xsl:call-template>
  </xsl:for-each>
</xsl:template>


<!-- add the names of the types and entities in the set of object nodes to
     the xref_list 
     -->
<xsl:template name="get_objects_in_schema">
  <xsl:param name="object_nodes"/>
  <xsl:param name="xref_list" select="'|'"/>
  <xsl:param name="indent" select="''"/>

  <xsl:variable name="first_object" select="$object_nodes[1]"/>
  <xsl:variable name="remaining_objects" select="$object_nodes[position()!=1]"/>
  <!-- debug
  <xsl:message>
    <xsl:value-of select="concat($indent,'{{')"/>
    <xsl:for-each select="$object_nodes"><xsl:value-of select="@name"/></xsl:for-each>}}
  </xsl:message>      
  -->
  <xsl:choose>
    <xsl:when test="$remaining_objects">
      <xsl:variable name="l1_xref_list">
        <!-- add the first object to the list -->
        <xsl:call-template name="add_objects_to_xref">
          <xsl:with-param name="xref_list" select="$xref_list"/>
          <xsl:with-param name="object" select="$first_object"/>
        </xsl:call-template>
      </xsl:variable>
      <!-- recurse through the rest of the object node set -->
      <xsl:call-template name="get_objects_in_schema">
        <xsl:with-param name="object_nodes" select="$remaining_objects"/>
        <xsl:with-param name="xref_list" select="$l1_xref_list"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <!-- add the first object to the list -->
      <xsl:call-template name="add_objects_to_xref">
        <xsl:with-param name="xref_list" select="$xref_list"/>
        <xsl:with-param name="object" select="$first_object"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- 
     Add an object to the  $global_xref_list
-->
<xsl:template name="add_objects_to_xref">
  <xsl:param name="xref_list"/>
  <xsl:param name="object"/>
  
  <xsl:variable name="schema_name"
    select="$object/../@name"/>


  <xsl:variable 
    name="object_ref"
    select="concat($schema_name,'.',$object/@name)"/>

  <xsl:choose>
    <xsl:when test="contains($xref_list,concat('|',$object_ref,'|'))">
      <xsl:value-of select="$xref_list"/>      
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat($xref_list,$object_ref,'|')"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Given the name of an object, extract the xref from the
     $global_xref_list
-->
<xsl:template name="get_object_xref">
  <xsl:param name="object_name"/>
  <xsl:param name="object_used_in_schema_name"/>
  <xsl:param name="clause" select="section"/>
  
  <xsl:variable 
    name="first"
    select="substring-before($global_xref_list, concat('.',$object_name,'|'))"/>
  <xsl:variable name="schema">
    <xsl:call-template name="get_last">
      <xsl:with-param name="str"
        select="substring-after($first,'|')"/>
      <xsl:with-param name="token" select="'|'"/>
    </xsl:call-template>
  </xsl:variable>
  <!--
  <xsl:message>
    schema:{<xsl:value-of select="$schema"/>}
  </xsl:message>
-->

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param 
        name="section1" 
        select="$schema"/>
      <xsl:with-param 
        name="section2" 
        select="$object_name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="express_file_to_ref">
    <xsl:choose>
      <xsl:when test="$schema!=$object_used_in_schema_name">
        <xsl:call-template name="express_file_to_ref">
          <xsl:with-param name="schema_name" select="$schema"/>
          <xsl:with-param name="clause" select="$clause"/>
        </xsl:call-template>        
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="xref" select="concat($express_file_to_ref,'#',$aname)"/>
  <xsl:value-of select="$xref"/>
</xsl:template>

<!-- called from template name="get_object_xref" -->
<xsl:template name="get_last_orig">
  <xsl:param name="str"/>
  <xsl:param name="token"/>
  <xsl:choose>
    <xsl:when test="contains($str,$token)">
      <xsl:call-template name="get_last">
        <xsl:with-param name="str"
          select="substring-after($str,$token)"/>
        <xsl:with-param name="token" select="$token"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$str"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- rewritten get_last so that minimizes the recursion -->
<xsl:template name="get_last">
  <xsl:param name="str"/>
  <xsl:param name="token"/>
  <xsl:param name="word" select="''"/>
  <xsl:variable name="str_len" select="string-length($str)"/>
  <xsl:variable name="last_char" select="substring($str,$str_len,1)"/>

  <!--
  <xsl:message>
    get_last1:str:{<xsl:value-of select="$str"/>}
    get_last1:word:{<xsl:value-of select="$word"/>}
    get_last1:str_len:{<xsl:value-of select="$str_len"/>}
    get_last1:last_char:{<xsl:value-of select="$last_char"/>}
  </xsl:message>
-->
  <xsl:choose>
    <xsl:when test="not(contains($str,$token))">
      <xsl:value-of select="$str"/>
    </xsl:when>
    <xsl:when test="$last_char = $token">
      <xsl:value-of select="$word"/>
    </xsl:when>
    <xsl:when test="$last_char=''">
      <xsl:value-of select="''"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="get_last">
        <xsl:with-param name="str" select="substring($str, 1, $str_len - 1)"/>
        <xsl:with-param name="token" select="$token"/>
        <xsl:with-param name="word" select="concat($last_char,$word)"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose> 
</xsl:template>




<!-- 
     Output a HREF for the schema.
     The clause parameter can be used to specify what express should be
     linked. either:
      section for referencing ARM and MIM express in section 4 and 5
      annexe for referencing ARM and MIM express in annex E

     Check to see whether the schema is in the current file, 
     If not, then it is assumed that all short form schema end in _mim or
     _arm 
     If they do not then the schema is an IR.
     -->
<xsl:template name="link_schema">
  <xsl:param name="schema_name"/>
  <xsl:param name="clause" select="section"/>

  <!-- check the express file for the schema being referenced -->
  <xsl:variable name="express_file_ok">
    <xsl:call-template name="check_express_file_to_read">
      <xsl:with-param name="schema_name" select="$schema_name"/>         
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:variable name="express_file_to_ref">
    <xsl:call-template name="express_file_to_ref">
      <xsl:with-param name="schema_name" select="$schema_name"/>
      <xsl:with-param name="clause" select="$clause"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="xref">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="contains($express_file_ok,'ERROR')">
      <xsl:call-template name="error_message">
        <xsl:with-param name="message" select="$express_file_ok"/>
        <xsl:with-param name="inline" select="'no'"/>
      </xsl:call-template>
      <!-- express file does not exist, so return the unmodified
           xref_list -->
      <xsl:value-of select="$schema_name"/>
    </xsl:when>
    <xsl:otherwise>
      <A HREF="{$express_file_to_ref}#{$xref}">
        <xsl:value-of select="$schema_name"/>
      </A>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<!-- 
     Output a HREF for the fundamental concepts.
     -->
<xsl:template name="link_fund_cons">
  <xsl:param name="schema_name"/>
  <xsl:param name="clause" select="section"/>

  <!-- check the express file for the schema being referenced -->
  <xsl:variable name="express_file_ok">
    <xsl:call-template name="check_express_file_to_read">
      <xsl:with-param name="schema_name" select="$schema_name"/>         
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:variable name="express_file_to_ref">
    <xsl:call-template name="express_file_to_ref">
      <xsl:with-param name="schema_name" select="$schema_name"/>
      <xsl:with-param name="clause" select="$clause"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="xref">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="'funcon'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="contains($express_file_ok,'ERROR')">
      <xsl:call-template name="error_message">
        <xsl:with-param name="message" select="$express_file_ok"/>
        <xsl:with-param name="inline" select="'no'"/>
      </xsl:call-template>
      <!-- express file does not exist, so return the unmodified
           xref_list -->
      <xsl:value-of select="$schema_name"/>
    </xsl:when>
    <xsl:otherwise>
      <A HREF="{$express_file_to_ref}#{$xref}">
        <xsl:value-of select="$schema_name"/>
      </A>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<!-- 
     Output a HREF for the fundamental concepts.
     -->
<xsl:template name="link_intro">
  <xsl:param name="schema_name"/>
  <xsl:param name="clause" select="section"/>

  <!-- check the express file for the schema being referenced -->
  <xsl:variable name="express_file_ok">
    <xsl:call-template name="check_express_file_to_read">
      <xsl:with-param name="schema_name" select="$schema_name"/>         
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:variable name="express_file_to_ref">
    <xsl:call-template name="express_file_to_ref">
      <xsl:with-param name="schema_name" select="$schema_name"/>
      <xsl:with-param name="clause" select="$clause"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="xref">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="'intro'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="contains($express_file_ok,'ERROR')">
      <xsl:call-template name="error_message">
        <xsl:with-param name="message" select="$express_file_ok"/>
        <xsl:with-param name="inline" select="'no'"/>
      </xsl:call-template>
      <!-- express file does not exist, so return the unmodified
           xref_list -->
      <xsl:value-of select="$schema_name"/>
    </xsl:when>
    <xsl:otherwise>
      <A HREF="{$express_file_to_ref}#{$xref}">
        <xsl:value-of select="$schema_name"/>
      </A>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>



<!--
     Output HREF URL for an Express object (either a TYPE or ENTITY).
     The clause parameter can be used to specify what express should be
     linked. either:
      section for referencing ARM and MIM express in section 4 and 5
      annexe for referencing ARM and MIM express in annex E

     The object may be defined within a schema in the current file,
     or through a USE-FROM or REFERENCE interface.
     If it is a USE-FROM or REFERENCE, the schema defined in the interface
     may be defined in this file or externally
-->
<xsl:template name="link_object">
  <xsl:param name="object_name"/>
  <xsl:param name="clause" select="section"/>
  <!-- the schema in which the object has been used -->
  <xsl:param name="object_used_in_schema_name"/>

  <!-- make sure that the arguments don't have any whitespace -->
  <xsl:variable name="lobject_name" 
    select="normalize-space($object_name)"/>
  
  <xsl:variable name="lobject_used_in_schema_name" 
    select="normalize-space($object_used_in_schema_name)"/>

  <xsl:choose>
    <xsl:when
      test="contains($global_xref_list,concat('.',$lobject_name,'|'))">
      <xsl:variable name="xref">
        <xsl:call-template name="get_object_xref">
          <xsl:with-param name="clause" select="$clause"/>
          <xsl:with-param name="object_name" select="$lobject_name"/>
          <xsl:with-param name="object_used_in_schema_name" select="$lobject_used_in_schema_name"/>
        </xsl:call-template>
      </xsl:variable>
      
      <A HREF="{$xref}">
        <xsl:value-of select="$lobject_name"/>
      </A>
      <!-- debug 
      <xsl:message>     
        <xsl:value-of select="concat('xr:{',$object_name,':',$xref,'}')"/>
      </xsl:message> -->
    </xsl:when>

    <xsl:otherwise>
      <xsl:value-of select="$global_xref_list"/><!-- MWD -->
      <xsl:value-of select="$lobject_name"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template><!-- MWD 2017-10-06 -->

  <!-- Recurse through a list of select items and output the list as a
    sorted  set of  URLS.
    
    The clause parameter can be used to specify what express should be
    referenced. either:
    section for referencing ARM and MIM express in section 4 and 5
    annexe for referencing ARM and MIM express in Annex E
    
    prefix and suffix are the prefixes and suffixes to be added to each
    object in the list
  -->
  <xsl:template name="link_list_sorted">
    <xsl:param name="list"/>
    <xsl:param name="object_used_in_schema_name"/>
    <xsl:param name="prefix"/>
    <xsl:param name="suffix"/>
    <xsl:param name="bold"/>
    <!-- if linebreak = yes then output a line break after the suffix -->
    <xsl:param name="linebreak" select="'no'"/>
    <!-- If yes then output prefix on first object -->
    <xsl:param name="first_prefix" select="'yes'"/>
    <xsl:param name="clause" select="section"/>
    <xsl:param name="and_for_last_pair" select="'no'"/>
    
    <xsl:variable name="sorted_list">
      <xsl:call-template name="sort_list">
        <xsl:with-param name="list" select="$list"/>
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:call-template name="link_list">
      <xsl:with-param name="list" select="$sorted_list"/>
      <xsl:with-param name="object_used_in_schema_name" select="$object_used_in_schema_name"/>
      <xsl:with-param name="prefix" select="$prefix"/>
      <xsl:with-param name="suffix" select="$suffix"/>
      <xsl:with-param name="bold" select="$bold"/>
      <!-- if linebreak = yes then output a line break after the suffix -->
      <xsl:with-param name="linebreak" select="$linebreak"/>
      <!-- If yes then output prefix on first object -->
      <xsl:with-param name="first_prefix" select="$first_prefix"/>
      <xsl:with-param name="clause" select="$clause"/>
      <xsl:with-param name="and_for_last_pair" select="$and_for_last_pair"/>
    </xsl:call-template>  
  </xsl:template>
  
<!-- 
     Recurse through a list of select items and output the list as a set of
     URLS.

     The clause parameter can be used to specify what express should be
     referenced. either:
      section for referencing ARM and MIM express in section 4 and 5
      annexe for referencing ARM and MIM express in annex E

     prefix and suffix are the prefixes and suffixes to be added to each
     object in the list
-->
<xsl:template name="link_list">
  <xsl:param name="list"/>
  <xsl:param name="object_used_in_schema_name"/>
  <xsl:param name="prefix"/>
  <xsl:param name="suffix"/>
  <!-- if linebreak = yes then output a line break after the suffix -->
  <xsl:param name="linebreak" select="'no'"/>
  <!-- If yes then output prefix on first object -->
  <xsl:param name="first_prefix" select="'yes'"/>
  <xsl:param name="clause" select="section"/>
  <xsl:param name="and_for_last_pair" select="'no'"/>
 
  <xsl:variable name="nlist"
    select="translate(normalize-space($list),' ',',')"/>

  <xsl:choose>

    <!-- maybe passed an empty list, e.g. when called from an empty 
         extensible select. In which case, just return -->
    <xsl:when test="string-length($nlist)=0"/>


    <xsl:when test="contains($nlist,',')">
      <xsl:variable name="first"
        select="normalize-space(substring-before($nlist,','))"/>
      <xsl:variable name="rest"
        select="substring-after($nlist,',')"/>
      
      <xsl:if test="$first_prefix='yes'">
        <!-- do not output prefix on first object -->
        <xsl:call-template name="output-fix">
          <xsl:with-param name="fix" select="$prefix"/>
        </xsl:call-template>
      </xsl:if>

      <xsl:call-template name="link_object">
        <xsl:with-param name="object_name" select="$first"/>
        <xsl:with-param 
          name="object_used_in_schema_name" 
          select="$object_used_in_schema_name"/>
        <xsl:with-param name="clause" select="$clause"/>
      </xsl:call-template>

      <xsl:if test="not( $and_for_last_pair='yes' and not
                    (string-length($rest) - string-length(translate($rest,',','')) > 1 ))">

        <xsl:call-template name="output-fix">
          <xsl:with-param name="fix" select="$suffix"/>
        </xsl:call-template>
        <xsl:if test="$linebreak='yes'">
          <br/>
        </xsl:if>        
      </xsl:if>


      <!-- check how many comma separators are left. 
           If less than one, have reached last item in list so check for
           "and_if_last_pair" 
           -->
      
      <xsl:choose>
        <xsl:when test="$and_for_last_pair='yes' and
                        (string-length($rest) - string-length(translate($rest,',','')) = 1 )">
          
          <xsl:call-template name="output-fix">
            <xsl:with-param name="fix" select="$suffix"/>
          </xsl:call-template>
          <xsl:if test="$linebreak='yes'">
            <br/>
          </xsl:if>
          
          <xsl:call-template name="link_object">
            <xsl:with-param name="object_name" 
              select="substring-before($rest,',')"/>
            <xsl:with-param 
              name="object_used_in_schema_name" 
              select="$object_used_in_schema_name"/>
            <xsl:with-param name="clause" select="$clause"/>
          </xsl:call-template>
          
          and
          
          <xsl:call-template name="link_object">
            <xsl:with-param name="object_name" 
              select="substring-after($rest,',')"/>
            <xsl:with-param 
              name="object_used_in_schema_name" 
              select="$object_used_in_schema_name"/>
            <xsl:with-param name="clause" select="$clause"/>
          </xsl:call-template>                    
	</xsl:when>

	<xsl:when test="$and_for_last_pair='yes' and
                        (string-length($rest) - string-length(translate($rest,',','')) = 0 )">
          and
          <xsl:call-template name="link_object">
            <xsl:with-param name="object_name" 
              select="$rest"/>
            <xsl:with-param 
              name="object_used_in_schema_name" 
              select="$object_used_in_schema_name"/>
            <xsl:with-param name="clause" select="$clause"/>
          </xsl:call-template>
        </xsl:when>
        
        <xsl:otherwise>
          <xsl:call-template name="link_list">
            <xsl:with-param name="prefix" select="$prefix"/>
            <xsl:with-param name="suffix" select="$suffix"/>
            <xsl:with-param name="linebreak" select="$linebreak"/>
            <xsl:with-param name="first_prefix" select="'yes'"/>
            <xsl:with-param name="list" select="$rest"/>
            <xsl:with-param 
              name="object_used_in_schema_name" 
              select="$object_used_in_schema_name"/>
            <xsl:with-param name="clause" select="$clause"/>
            <xsl:with-param name="and_for_last_pair" select="$and_for_last_pair"/>
          </xsl:call-template>          
       </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <xsl:otherwise>
      <!-- end of recursion -->
      
      <xsl:if test="$first_prefix='yes'">
        
        <!-- do not output prefix on first object -->
        <xsl:call-template name="output-fix">
          <xsl:with-param name="fix" select="$prefix"/>
        </xsl:call-template>
      </xsl:if>

      <xsl:call-template name="link_object">
        <xsl:with-param name="object_name" select="$nlist"/>
        <xsl:with-param 
          name="object_used_in_schema_name" 
          select="$object_used_in_schema_name"/>
        <xsl:with-param name="clause" select="$clause"/>
      </xsl:call-template>
      
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- called from :template name="link_list" -->
<xsl:template name="output-fix">
  <xsl:param name="fix"/>
  <xsl:choose>
    <xsl:when test="$fix='br'">
      <br/>      
    </xsl:when>
    <xsl:when test="$fix='br'">
      <p/>      
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$fix"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
     Link and format a super.expression
ONEOF(Csg_model, Manifold_solid_brep, Solid_replica, Swept_area_solid,
Swept_face_solid)
NOTE  THIS IS NOT YET IMPLEMENTED
ONEOF(uniform_curve, b_spline_curve_with_knots,
                       quasi_uniform_curve, bezier_curve)
                         ANDOR rational_b_spline_curve
Needs to deal with expressions starting with not ( i.e. ANDOR above
-->

<xsl:template name="link_super_expression_list">
  <xsl:param name="list"/>
  <xsl:param name="object_used_in_schema_name"/>
  <xsl:param name="clause" select="section"/>
  <xsl:param name="indent" select="0"/>
  <xsl:param name="last_indent" select="0"/>
  <xsl:param name="linebreak" select="'NO'"/>
  
  <!-- replace all whitespace -->
  <xsl:variable name="nlist"
    select="normalize-space($list)"/>
  
  <!-- get the first word before , or ( -->
  <xsl:variable name="first">
    <xsl:call-template name="get_word">
      <xsl:with-param name="str" select="$nlist"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="rest1">
    <xsl:call-template name="get_after_word">
      <xsl:with-param name="str" select="$nlist"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="prefix">
    <xsl:variable name="prefixtmp">
      <xsl:call-template name="get_before_word">
        <xsl:with-param name="str" select="$nlist"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="normalize-space($prefixtmp)"/>
  </xsl:variable>

  <xsl:variable name="suffix">
    <xsl:variable name="suffixtmp">
      <xsl:call-template name="get_before_word">
        <xsl:with-param name="str" select="$rest1"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="normalize-space($suffixtmp)"/>
  </xsl:variable>

  <xsl:variable name="next_word">
    <xsl:call-template name="get_word">
      <xsl:with-param name="str" select="$nlist"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="rest" select="substring-after($rest1,$suffix)"/>

  <xsl:choose>

    <!-- maybe passed an empty list, e.g. when called from an empty 
         extensible select. In which case, just return -->
    <xsl:when test="string-length($nlist)=0"/>

    <xsl:when test="string-length($next_word)>0">


      <xsl:variable name="new_indent">
        <xsl:choose>
          <xsl:when test="($first='ONEOF') 
                          or ($first='AND') 
                          or ($first='ANDOR')">
            <xsl:value-of select="($indent - $last_indent)
                                  + string-length($first) 
                                  + string-length($prefix)
                                  + string-length($suffix)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$indent"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="current_indent">
        <xsl:choose>
          <xsl:when test="($first='ONEOF') 
                          or ($first='AND') 
                          or ($first='ANDOR')">
            <xsl:value-of select="($indent - $last_indent)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$indent"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="new_last_indent">
        <xsl:choose>
          <xsl:when test="($first='ONEOF') 
                          or ($first='AND') 
                          or ($first='ANDOR')">
            <xsl:value-of select="string-length($first) 
                                  + string-length($prefix)
                                  + string-length($suffix) + 1"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$last_indent"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:if test="$linebreak='YES'">
        <br/>
        <!-- indent -->
        <xsl:call-template name="string_n_chars">
          <xsl:with-param name="char" select="'&#160;'"/>
          <xsl:with-param name="no_chars" select="$current_indent"/>
        </xsl:call-template>          
      </xsl:if>
      
      <xsl:choose>
        <xsl:when test="($first='ONEOF') 
                        or ($first='AND') 
                        or ($first='ANDOR')">
          <xsl:value-of select="$prefix"/>
          <xsl:value-of select="$first"/>&#160;<xsl:value-of select="$suffix"/>
          <xsl:call-template name="link_super_expression_list">
            <xsl:with-param name="list" select="$rest"/>
            <xsl:with-param 
              name="object_used_in_schema_name" 
              select="$object_used_in_schema_name"/>
            <xsl:with-param name="clause" select="$clause"/>
            <xsl:with-param name="indent" select="$new_indent"/>
            <xsl:with-param name="last_indent" select="$new_last_indent"/>
            <xsl:with-param name="linebreak" select="'NO'"/>
          </xsl:call-template>
        </xsl:when>

        <xsl:otherwise>
          <xsl:value-of select="$prefix"/>
          <xsl:call-template name="link_object">
            <xsl:with-param name="object_name" select="$first"/>
            <xsl:with-param 
              name="object_used_in_schema_name" 
              select="$object_used_in_schema_name"/>
            <xsl:with-param name="clause" select="$clause"/>
          </xsl:call-template>
          <xsl:value-of select="$suffix"/>
          <xsl:variable name="new_linebreak">
            <xsl:choose>
              <xsl:when test="substring($suffix,1,1) = ','">
                <xsl:value-of select="'YES'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'NO'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:call-template name="link_super_expression_list">
            <xsl:with-param name="list" select="$rest"/>
            <xsl:with-param 
              name="object_used_in_schema_name" 
              select="$object_used_in_schema_name"/>
            <xsl:with-param name="clause" select="$clause"/>
            <xsl:with-param name="indent" select="$new_indent"/>
            <xsl:with-param name="last_indent" select="$new_last_indent"/>
            <xsl:with-param name="linebreak" select="'YES'"/>
          </xsl:call-template>

        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <xsl:otherwise>
      <!-- end of recursion so no more words -->
      <xsl:value-of select="$nlist"/>      
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<!--
     Given a schema name return the path to the express file so that it can
     be used in a document function call. The path must be relative to the
     stylesheet. 
     e.g. ../data/modules/schema_name

     It is assumed that every module is stored in a directory which is
     given the name of the module.
     It is also assumed that all short form schema end in _mim or _arm
     If they do not then the schema is an IR.
     All IRs 
     If the entity is interfaced to through the schema interface, 
     this function will set up the URL to the interface - not the original
     entity - which may be accessed through a series of interface objects.    
-->
<xsl:template name="express_file_to_read">
  <xsl:param name="schema_name"/>
  <xsl:variable name="data_path">
    <xsl:value-of select="'../../data'"/>
  </xsl:variable>

  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <!-- utility var to make it easier to strip out the schema name -->
  <xsl:variable name="schema_name_tmp"
    select="concat(translate($schema_name,$UPPER, $LOWER),';')"/>

  <xsl:variable name="filepath">
    <xsl:choose>
      
      <!-- The schema is defined in this file, so return nothing 
           This caters for multiple schemas in a single file
           -->
      <!-- modules only have one schema so commented this out
      <xsl:when test="/express/schema[@name=$schema_name]">
        <xsl:value-of select="''"/>
      </xsl:when>
      -->
      <xsl:when test="contains($schema_name_tmp,'_mim;')">
        <xsl:value-of 
          select="concat($data_path,'/modules/',substring-before($schema_name_tmp,'_mim;'),
                  '/mim.xml')"/>
      </xsl:when>

      <xsl:when test="contains($schema_name_tmp,'_arm;')">
        <xsl:value-of 
          select="concat($data_path,'/modules/',substring-before($schema_name_tmp,'_arm;'),
                  '/arm.xml')"/>
      </xsl:when>
      <!--<xsl:when test="$resdoc_xml">
        
      </xsl:when>-->
      <xsl:otherwise>
        <xsl:value-of 
          select="concat($data_path,'/resources/',$schema_name,'/',$schema_name,'.xml')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$filepath"/>  
</xsl:template>

<!--
     return ERROR message if the module or resource doc that is providing the
     express file has not been identified in stepmod/repository_index.xml. The
     message will start with ERROR
     -->
<xsl:template name="check_express_file_to_read">
  <xsl:param name="schema_name"/>

  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <!-- utility var to make it easier to strip out the schema name -->
  <xsl:variable name="schema_name_tmp"
    select="translate($schema_name,$UPPER, $LOWER)"/>

  <xsl:variable name="ret_val">
    <xsl:choose>
          <xsl:when
            test="document('../../repository_index.xml')/repository_index/resources/resource[@name=$schema_name_tmp]"/>
          <xsl:otherwise>
            <xsl:value-of 
              select="concat('ERROR el3: ', $schema_name_tmp, 
                      ' does not exist as resource document')"/>
          </xsl:otherwise>
     </xsl:choose>        
  </xsl:variable>

  <xsl:value-of select="$ret_val"/>  
</xsl:template>


<!--
     Given a schema name return the path to the express file so that it can
     be used as a URL from the modules xml. The path is relative to the xml
     e.g. for:
        stepmod/data/modules/person_organization/sys/5_mim.xml
     The path would be:
        ../../../../data/modules/schema_name 
     
     The clause parameter can be used to specify what express should be
     referenced. either:
      section for referencing ARM and MIM express in section 4 and 5
      annexe for referencing ARM and MIM express in annex E

     It is assumed that every module is stored in a directory which is
     given the name of the module.
     It is also assumed that all short form schema end in _mim or _arm
     If they do not then the schema is an IR.
     All IRs are stored under stepmod/data/resources
-->
<xsl:template name="express_file_to_ref">
  <xsl:param name="schema_name"/>
  <xsl:param name="clause" select="section"/>

  <xsl:variable name="data_path">
    <xsl:value-of select="concat($relative_root, 'data')"/>
  </xsl:variable>

  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <!-- utility var to make it easier to strip out the schema name -->
  <xsl:variable name="schema_name_tmp"
    select="concat(translate($schema_name,$UPPER, $LOWER),';')"/>


  <xsl:variable name="filepath">
    <xsl:choose>
      
      <!-- The schema is defined in this file, so return nothing 
           This caters for multiple schemas in a single file
           -->
      <!-- modules only have one schema so commented this out
      <xsl:when test="/express/schema[@name=$schema_name]">
        <xsl:value-of select="''"/>
      </xsl:when>
      -->
      <xsl:when test="$resdoc_xml//schema[@name=$schema_name]/@name">
        <xsl:variable name="clauseno">
          <!--        <xsl:apply-templates select="$resdoc_xml//schema[@name=$schema_name]" mode="pos"> -->
<xsl:apply-templates select="$resdoc_xml//schema" mode="pos">
      <xsl:with-param name="schema_name" select="$schema_name"/>         

        </xsl:apply-templates>
      </xsl:variable>
        <xsl:value-of 
          select="concat($data_path,'/resource_docs/',$resdoc_name,'/sys/',$clauseno,'_schema',$FILE_EXT)"/>
        
      </xsl:when>

      <xsl:otherwise>
        <xsl:value-of 
          select="concat($data_path,'/resources/',$schema_name,'/',$schema_name,$FILE_EXT)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$filepath"/>  
</xsl:template>


<!-- return the HREF for an integrated resource object -->
<xsl:template name="xref_resource_object">
  <xsl:param name="object_name"/>
  <!-- make sure that the arguments don't have any whitespace -->
  <xsl:variable name="lobject_name" 
    select="normalize-space($object_name)"/>

  <xsl:call-template name="get_object_xref">
    <xsl:with-param name="clause" select="'annexe'"/>
    <xsl:with-param name="object_name" select="$lobject_name"/>
  </xsl:call-template>
</xsl:template>


<!-- output the object, linked to the integrated resource
-->
<xsl:template name="link_resource_object">
  <xsl:param name="object_name"/>
  <!-- make sure that the arguments don't have any whitespace -->
  <xsl:variable name="lobject_name" 
    select="normalize-space($object_name)"/>

  <xsl:choose>
    <xsl:when
      test="contains($global_xref_list,concat('.',$lobject_name,'|'))">
      <xsl:variable name="xref">
        <xsl:call-template name="get_object_xref">
          <xsl:with-param name="clause" select="'annexe'"/>
          <xsl:with-param name="object_name" select="$lobject_name"/>
        </xsl:call-template>
      </xsl:variable>
      <A HREF="{$xref}">
        <xsl:value-of select="$lobject_name"/>
      </A>
    </xsl:when>

    <xsl:otherwise>
      <xsl:value-of select="$lobject_name"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- build a list of all the entities and types in the integrated resources
     that are referenced in repository_index.xml 
     Normally used to assign the list to global_xref_list
-->
<xsl:template name="build_resource_xref_list">
  <xsl:call-template name="build_resource_xref_list_rec">
    <xsl:with-param name="resources"
      select="document('../repository_index.xml')/repository_index/resources/resource"/>
  </xsl:call-template>
</xsl:template>
<xsl:template name="build_resource_xref_list_rec">
  <xsl:param name="resources"/>
  <xsl:param name="xref_list" select="'|'"/>
  
  <xsl:variable name="first_resource" select="$resources[1]"/>
  <xsl:variable name="remaining_resources" select="$resources[position()!=1]"/>

  <xsl:variable name="express_file" 
    select="concat('../data/resources/',
            $first_resource/@name,'/',$first_resource/@name,'.xml')"/>
  <xsl:variable name="object_nodes"
    select="document($express_file)/express/schema/entity|/express/schema/type|/express/schema/subtype.constraint|/express/schema/function|/express/schema/procedure|/express/schema/rule|/express/schema/constant"/>
  <xsl:choose>
    <xsl:when test="$remaining_resources">
      <xsl:variable name="l_xref_list">
        <xsl:call-template name="get_objects_in_schema">
          <xsl:with-param name="object_nodes" select="$object_nodes"/>
          <xsl:with-param name="xref_list" select="$xref_list"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:call-template name="build_resource_xref_list_rec">
        <xsl:with-param name="resources" select="$remaining_resources"/>
        <xsl:with-param name="xref_list" select="$l_xref_list"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="get_objects_in_schema">
        <xsl:with-param name="object_nodes" select="$object_nodes"/>
        <xsl:with-param name="xref_list" select="$xref_list"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="schema" mode="pos">
      <xsl:param name="schema_name"/>         

  <!--  <xsl:value-of select="position()"/> -->
  <!-- <xsl:variable name="clauseno" select="3+position()"/> -->
  <xsl:if test="@name=$schema_name">
    <xsl:value-of select="3+position()"/>    
  </xsl:if>
</xsl:template>
</xsl:stylesheet>