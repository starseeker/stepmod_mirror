<?xml version="1.0"?>
<!--
     $Id: express_link.xsl,v 1.2 2001/11/21 08:11:54 robbod Exp $

  Author: Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep and supplied to NIST under contract.
  Purpose: 
     Used to establish links (URLs) for entities and types that are
     referenced in a schema 
-->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>

  <xsl:import href="common.xsl"/>


  <xsl:output method="html"/>

  
<xsl:template name="build_schema_xref_list">
  <xsl:param name="schema_node"/>
  <xsl:param name="xref_list" select="'|'"/>
  
  <!-- get the entities / objects in the current schema and add them to
       the xref_list variable -->
  <xsl:variable name="l1_xref_list">
    <xsl:call-template name="get_objects_in_schema">
      <xsl:with-param name="xref_list" select="$xref_list"/>
      <xsl:with-param name="object_nodes" select="$schema_node/entity|$schema_node/type"/>
    </xsl:call-template>        
  </xsl:variable>
  <!-- debug 
  <xsl:message>li{<xsl:value-of select="$l1_xref_list"/>}</xsl:message>      
  -->

  <xsl:variable name="l2_xref_list">
    <!-- loop through all the interfaces in a schema -->
    <xsl:call-template name="build_interface_xref_list">
      <xsl:with-param name="interfaces" select="$schema_node/interface"/>
      <xsl:with-param name="xref_list" select="$l1_xref_list"/>
    </xsl:call-template>
  </xsl:variable>
  <!-- debug 
  <xsl:message>l2{<xsl:value-of select="$l2_xref_list"/>}</xsl:message>      
  -->

  <xsl:value-of select="$l2_xref_list"/>
</xsl:template>



<xsl:template name="build_interface_xref_list">
  <!-- the interface nodes to be processed -->
  <xsl:param name="interfaces"/>
  <xsl:param name="indent" select="''"/>
  <xsl:param name="xref_list" select="'|'"/>

  <xsl:choose>
    <xsl:when test="$interfaces">
      <!-- ++++++++++++++++++++++++++++++++++++++++ -->      
      <xsl:variable name="first_interface" 
        select="$interfaces[1]"/>
      <xsl:variable name="remaining_interfaces" 
        select="$interfaces[position()!=1]"/>
      <xsl:variable name="if_schema_name"
        select="$first_interface/@schema"/>
      
      <!-- debug
      <xsl:message>
        <xsl:value-of select="concat($indent,'first:',$if_schema_name)"/>
      </xsl:message> -->

      <!-- check the express file for the schema being interfaced to -->
      <xsl:variable name="express_file_ok">
        <xsl:call-template name="check_express_file_to_read">
          <xsl:with-param 
            name="schema_name" 
            select="$if_schema_name"/>         
        </xsl:call-template>
      </xsl:variable>
      
      <xsl:variable name="express_file_to_read">
        <xsl:call-template name="express_file_to_read">
          <xsl:with-param 
            name="schema_name" 
            select="$if_schema_name"/>
        </xsl:call-template>
      </xsl:variable>
      
      <!-- check whether the modules or resource has been indexed in
           stepmod/repository_index. 
           If not, then it is assumed that the file does not exist and
           document will fail, so ignore.
           If it does - then recurse
           -->
      <xsl:variable name="l1_xref_list">
        <xsl:choose>
          <xsl:when test="contains($express_file_ok,'ERROR')">
            <xsl:call-template name="error_message">
              <xsl:with-param name="message" select="$express_file_ok"/>
              <xsl:with-param name="inline" select="'no'"/>
            </xsl:call-template>
            <!-- express file does not exist, so return the unmodified
                 xref_list -->
            <xsl:value-of select="$xref_list"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- now process the schema being interfaced.
                 Get the entities / objects in the schema that is
                 interfaced and add them to the xref_list variable.
                 Then recurse to the interface -->
            <xsl:variable 
              name="l_schema_node" 
              select="document(string($express_file_to_read))//express/schema"/>
            <xsl:variable name="l2_xref_list">
              <xsl:call-template name="get_objects_in_schema">
                <xsl:with-param name="xref_list" select="$xref_list"/>
                <xsl:with-param name="object_nodes" select="$l_schema_node/entity|$l_schema_node/type"/>
              </xsl:call-template> 
            </xsl:variable>

            <!-- debug  
            <xsl:message>if schema:{<xsl:value-of
select="concat($indent,$l_schema_node/@name)"/>}</xsl:message>      
            <xsl:message>l3<xsl:value-of
            select="concat('|',$l_schema_node/interface/@schema,'.',':',$l2_xref_list)"/>l3</xsl:message> -->

            <!-- only process the schema being interfaced, if:
                 - the schema has interfaces (note the objects have already
                 been added to xref_list) 
                 - and the interfaced schema has not been visited already
                 -->
            <xsl:variable name="if_schema" 
              select="concat('|',$l_schema_node/interface/@schema)"/>
            <xsl:choose>
              <!--<xsl:when test="$l_schema_node/interface">-->
              <xsl:when
                test="$l_schema_node/interface[not(contains($l2_xref_list,$if_schema))]">
                <!-- debug 
                <xsl:message>
                  <xsl:value-of select="concat($if_schema,'-NOT-:',$l2_xref_list)"/>
                </xsl:message> -->
                                
                <xsl:call-template name="build_interface_xref_list">
                  <xsl:with-param 
                    name="interfaces"
                    select="$l_schema_node/interface"/>
                  <xsl:with-param 
                    name="xref_list"
                    select="$l2_xref_list"/>
                  <xsl:with-param 
                    name="indent"
                    select="concat($indent,' ')"/>
                </xsl:call-template>                        
              </xsl:when>
              <xsl:otherwise>
                <!-- debug 
                <xsl:message>
                  <xsl:value-of select="concat($if_schema,'-IN-:',$l2_xref_list)"/>
                </xsl:message> -->
                <xsl:value-of select="$l2_xref_list"/>
              </xsl:otherwise>
            </xsl:choose>

          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable> <!-- l1_xref_list -->
      <!--<xsl:message>l4<xsl:value-of
           select="$l1_xref_list"/>l4</xsl:message>-->

      <xsl:choose>
        <xsl:when test="$remaining_interfaces">
          <!-- ++++++++++++++++++++++++++++++++++++++++ -->      
          <!-- recurse through the rest of the interfaces, adding to the
               xref_list variable -->
          
          <xsl:call-template name="build_interface_xref_list">
            <xsl:with-param 
              name="interfaces"
              select="$remaining_interfaces"/>
            <xsl:with-param 
              name="indent"
              select="concat($indent,' ')"/>
            <xsl:with-param 
              name="xref_list"
              select="$l1_xref_list"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$l1_xref_list"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    
    <xsl:otherwise>
      <!-- no interfaces passed in, so end of recursion -->
      <!--
           <xsl:message>
             <xsl:value-of select="concat('end-if:',@name)"/>
           </xsl:message>
           -->
      <xsl:value-of select="$xref_list"/>
    </xsl:otherwise>
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
<xsl:template name="get_last">
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
      <xsl:message>     
        <xsl:value-of select="concat('xr:{',$object_name,':',$xref,'}')"/>
      </xsl:message>
    </xsl:when>

    <xsl:otherwise>
      <xsl:value-of select="$lobject_name"/>
    </xsl:otherwise>
  </xsl:choose>
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
  <xsl:param name="clause" select="section"/>

  <xsl:variable name="nlist"
    select="translate(normalize-space($list),' ',',')"/>

  <xsl:choose>

    <!-- maybe passed an empty list, e.g. when called from an empty 
         extensible select. In which case, just return -->
    <xsl:when test="string-length($nlist)=0"/>


    <xsl:when test="contains($nlist,',')">
      <xsl:variable name="first"
        select="substring-before($nlist,',')"/>
      <xsl:variable name="rest"
        select="substring-after($nlist,',')"/>


      <xsl:call-template name="output-fix">
        <xsl:with-param name="fix" select="$prefix"/>
      </xsl:call-template>
      <xsl:call-template name="link_object">
        <xsl:with-param name="object_name" select="$first"/>
        <xsl:with-param 
          name="object_used_in_schema_name" 
          select="$object_used_in_schema_name"/>
        <xsl:with-param name="clause" select="$clause"/>
      </xsl:call-template>
      <xsl:call-template name="output-fix">
        <xsl:with-param name="fix" select="$suffix"/>
      </xsl:call-template>

      <xsl:call-template name="link_list">
        <xsl:with-param name="prefix" select="$prefix"/>
        <xsl:with-param name="suffix" select="$suffix"/>
        <xsl:with-param name="list" select="$rest"/>
        <xsl:with-param 
          name="object_used_in_schema_name" 
          select="$object_used_in_schema_name"/>
        <xsl:with-param name="clause" select="$clause"/>
      </xsl:call-template>

    </xsl:when>

    <xsl:otherwise>
      <!-- end of recursion -->
      <xsl:call-template name="output-fix">
        <xsl:with-param name="fix" select="$prefix"/>
      </xsl:call-template>

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
    <xsl:value-of select="'../data'"/>
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

      <xsl:otherwise>
        <xsl:value-of 
          select="concat($data_path,'/resources/',$schema_name,'/',$schema_name,'.xml')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$filepath"/>  
</xsl:template>

<!--
     return ERROR message if the module or resource that is providing the
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

  <xsl:variable name="module_name">
    <xsl:call-template name="module_name">
      <xsl:with-param name="module" select="$schema_name"/>
    </xsl:call-template>  
  </xsl:variable>


  <xsl:variable name="ret_val">
    <xsl:choose>      
      <xsl:when test="contains($schema_name_tmp,'_mim')">
        <xsl:choose>
          <!-- would have been better to use xsl:if != but this does not
               work, hence use of when and otherwise -->
          <xsl:when
            test="document('../repository_index.xml')/repository_index/modules/module[@name=$module_name]"/>
          <xsl:otherwise>
            <xsl:value-of 
              select="concat('ERROR: ', $module_name, 
                      ' does not exist as a module or resource')"/>
          </xsl:otherwise>
        </xsl:choose>     
      </xsl:when>

      <xsl:when test="contains($schema_name_tmp,'_arm')">
        <xsl:choose>
          <!-- would have been better to use xsl:if != but this does not
               work, hence use of when and otherwise -->
          <xsl:when test="document('../repository_index.xml')/repository_index/modules/module[@name=$module_name]"/>
          <xsl:otherwise>
            <xsl:value-of 
              select="concat('ERROR: ', $module_name, 
                      ' does not exist as a module or resource')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:otherwise>
        <xsl:choose>
          <!-- would have been better to use xsl:if != but this does not
               work, hence use of when and otherwise -->
          <xsl:when
            test="document('../repository_index.xml')/repository_index/resources/resource[@name=$schema_name_tmp]"/>
          <xsl:otherwise>
            <xsl:value-of 
              select="concat('ERROR: ', $module_name, 
                      ' does not exist as a module or resource')"/>
          </xsl:otherwise>
        </xsl:choose>        
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
    <xsl:value-of select="'../../../../data'"/>
  </xsl:variable>

  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <!-- utility var to make it easier to strip out the schema name -->
  <xsl:variable name="schema_name_tmp"
    select="concat(translate($schema_name,$UPPER, $LOWER),';')"/>

  <xsl:variable name="mim_file">
    <xsl:choose>
      <xsl:when test="$clause='annexe'">
        <xsl:value-of select="'e_exp_mim'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'5_mim'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="arm_file">
    <xsl:choose>
      <xsl:when test="$clause='annexe'">
        <xsl:value-of select="'e_exp_arm'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'4_info_reqs'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


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
                  '/sys/',$mim_file,$FILE_EXT)"/>
      </xsl:when>

      <xsl:when test="contains($schema_name_tmp,'_arm;')">
        <xsl:value-of 
          select="concat($data_path,'/modules/',substring-before($schema_name_tmp,'_arm;'),
                  '/sys/',$arm_file,$FILE_EXT)"/>
      </xsl:when>

      <xsl:otherwise>
        <xsl:value-of 
          select="concat($data_path,'/resources/',$schema_name,'/',$schema_name,$FILE_EXT)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$filepath"/>  
</xsl:template>



</xsl:stylesheet>