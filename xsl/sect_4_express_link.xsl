<?xml version="1.0"?>
<!--
     $Id: express_link.xsl,v 1.1 2001/10/22 09:34:10 robbod Exp $

  Author: Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep and supplied to NIST under contract.
  Purpose: 
     Used to establish links (URLs) for entities and types that are
     referenced in a schema defined in sect 4 and 5 of a module
-->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>

  <xsl:output method="html"/>


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
                  '/mim',$FILE_EXT)"/>
      </xsl:when>

      <xsl:when test="contains($schema_name_tmp,'_arm;')">
        <xsl:value-of 
          select="concat($data_path,'/modules/',substring-before($schema_name_tmp,'_arm;'),
                  '/arm',$FILE_EXT)"/>
      </xsl:when>

      <xsl:otherwise>
        <xsl:value-of 
          select="concat($data_path,'/resources/',$schema_name,'/',$schema_name,$FILE_EXT)"/>
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

     It is assumed that every module is stored in a directory which is
     given the name of the module.
     It is also assumed that all short form schema end in _mim or _arm
     If they do not then the schema is an IR.
     All IRs 
     If the entity is interfaced to through the schema interface, 
     this function will set up the URL to the interface - not the original
     entity - which may be accessed through a series of interface objects.     
-->
<xsl:template name="express_file_to_ref">
  <xsl:param name="schema_name"/>
  <xsl:variable name="data_path">
    <xsl:value-of select="'../../../../data'"/>
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
                  '/sys/5_mim',$FILE_EXT)"/>
      </xsl:when>

      <xsl:when test="contains($schema_name_tmp,'_arm;')">
        <xsl:value-of 
          select="concat($data_path,'/modules/',substring-before($schema_name_tmp,'_arm;'),
                  '/sys/4_info_reqs',$FILE_EXT)"/>
      </xsl:when>

      <xsl:otherwise>
        <xsl:value-of 
          select="concat($data_path,'/resources/',$schema_name,'/',$schema_name,$FILE_EXT)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$filepath"/>  
</xsl:template>

<!-- 
     Output a HREF for the schema
     Check to see whether the schema is in the current file, 
     If not, then it is assumed that all short form schema end in _mim or
     _arm 
     If they do not then the schema is an IR.
     -->
<xsl:template name="link_schema">
  <xsl:param name="schema_name"/>
  <xsl:variable name="express_file_to_ref">
    <xsl:call-template name="express_file_to_ref">
      <xsl:with-param 
        name="schema_name" 
        select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable 
    name="xref"
    select="concat($express_file_to_ref,'#','index_',$schema_name)"/>
  <A HREF="{$xref}">
    <xsl:value-of select="$schema_name"/>
  </A>

</xsl:template>

<!--
     Output HREF URL for an Express object (either a TYPE or ENTITY)
     The object may be defined within a schema in the current file,
     or through a USE-FROM or REFERENCE interface.
     If it is a USE-FROM or REFERENCE, the schema defined in the interface
     may be defined in this file or externally
     If it is defined externally, then call link_object_xref to resolve.
-->
<xsl:template name="link_object">
  <xsl:param name="object_name"/>
  <!-- the schema in which the object has been used -->
  <xsl:param name="object_used_in_schema_name"/>

  <!-- debug  
  <br/>lo1:<xsl:value-of select="$object_name"/><br/>
    lo2:<xsl:value-of select="$object_used_in_schema_name"/><br/>
  -->

  <xsl:variable name="schema_node" 
    select="//express/schema[@name=$object_used_in_schema_name]"/>

  <xsl:choose>
    <xsl:when
      test="$schema_node/entity[@name=$object_name]|$schema_node/type[@name=$object_name]">
      <!-- the object is defined within the schema it is used, so link to
           this file --> 
      <xsl:variable 
        name="xref"
        select="concat('#',$object_used_in_schema_name,'.',$object_name)"/>

      <A HREF="{$xref}">
        <xsl:value-of select="$object_name"/>
      </A>
    </xsl:when>

    <xsl:otherwise>
      <!-- the object is not defined within the schema it is used, so
           recurse to find where it is defined -->
      <xsl:variable name="object_xref">
        <xsl:call-template name="link_object_xref">
          <xsl:with-param name="object_name" select="$object_name"/>
          <xsl:with-param name="object_used_in_schema_name" 
            select="$object_used_in_schema_name"/>
        </xsl:call-template>
      </xsl:variable>

      <!-- if the URL has been resolved by recursing through the interface
           definitions then output it. Otherwise, just output the name of the
           object. 
           -->
      <xsl:choose>
        <xsl:when test="string-length($object_xref)>0">
          <a href="{$object_xref}">
            <xsl:value-of select="$object_name"/>
          </a>          
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$object_name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
     Called from link_object
     Output HREF URL for an Express object (either a TYPE or ENTITY)
     The object may be defined within a schema in the current file,
     or through a USE-FROM or REFERENCE interface.
     If it is a USE-FROM or REFERENCE, the schema defined in the interface
     may be defined in this file or externally
     If it is defined externally, then call link_object_xref to resolve.

     -->
<xsl:template name="link_object_xref">
  <xsl:param name="object_name"/>
  <!-- the schema in which the object has been used -->
  <xsl:param name="object_used_in_schema_name"/>

  <!-- debug  
  <br/>lor1:<xsl:value-of select="$object_name"/>]<br/>
    lor2:<xsl:value-of select="$object_used_in_schema_name"/><br/>
  -->

  <xsl:variable name="schema_node" 
    select="//express/schema[@name=$object_used_in_schema_name]"/>

  <!--  debug 
       [Z:<xsl:value-of
       select="concat('Z',$object_used_in_schema_name,':',$schema_node/@name)"/>]
  -->

  <xsl:choose>
    <xsl:when
      test="$schema_node/entity[@name=$object_name]|$schema_node/type[@name=$object_name]">
      <!-- the object is defined within the schema it is used, so link to
           this file --> 

      <xsl:variable name="express_file_to_ref">
        <xsl:call-template name="express_file_to_ref">
          <xsl:with-param 
            name="schema_name" 
            select="$object_used_in_schema_name"/>
        </xsl:call-template>
      </xsl:variable>


      <xsl:variable 
        name="xref"
        select="concat($express_file_to_ref,'#',$object_used_in_schema_name,'.',$object_name)"/>

      <!-- debug
           [xxref:<xsl:value-of select="$xref"/>]
        -->
      <!-- return the URL -->
      <xsl:value-of select="$xref"/>
    </xsl:when>

    <xsl:when test="$schema_node/interface/interfaced.item[@name=$object_name]"> 
      <!-- the schema of the object being interfaced has been explicitly
           identified as being interfaced from a schema, now get the file
           that is being interfaced, 
           check that the entity is defined in that file, if not, 
           recurse -->

      <!-- first get the express file for the schema being interfaced to
           -->
      <xsl:variable 
        name="if_schema_name"
        select="$schema_node/interface/interfaced.item[@name=$object_name]/../@schema"/>

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

      <!-- debug 
             [Q2:<xsl:value-of
             select="concat($express_file_to_read,':',$if_schema_name,':',$express_file_ok)"/>]
           -->          
      <!-- check whether the modules or resource has been indexed in
           stepmod/repository_index. If not, then it is assumed that the
           file does not exist and document will fail
           -->
      <xsl:choose>
        <xsl:when test="contains($express_file_ok,'ERROR')">
          <xsl:value-of select="$object_name"/>
          <xsl:call-template name="error">
            <xsl:with-param 
              name="message" 
              select="$express_file_ok"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <!-- check whether the object is in the file -->
          <xsl:for-each
            select="document(string($express_file_to_read))//express/schema[@name=$if_schema_name]">
            <!-- changed focus to the interfaced document - there should only
                 be one. Now recurse-->
            <xsl:call-template name="link_object_xref">
              <xsl:with-param name="object_name" select="$object_name"/>
              <xsl:with-param 
                name="object_used_in_schema_name" 
                select="$if_schema_name"/>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <xsl:otherwise>
      <!-- the object being interfaced has not been explicitly
           identified in an interface so must be defined in one of the
           schemas that have been interfaced, so loop through them -->
      <xsl:for-each select="$schema_node/interface">
        <!-- first get the express file for the schema being interfaced to
           -->
        <xsl:variable 
          name="if_schema_name"
          select="@schema"/>

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
        <!-- debug  
        [PP:<xsl:value-of select="concat($express_file_to_read,':',$if_schema_name)"/>]
             -->
        <!-- check whether the modules or resource has been indexed in
             stepmod/repository_index. If not, then it is assumed that the
             file does not exist and document will fail
             -->
        <xsl:choose>
          <xsl:when test="contains($express_file_ok,'ERROR')">
            <xsl:value-of select="$object_name"/>
            <xsl:call-template name="error">
              <xsl:with-param 
                  name="message" 
                  select="$express_file_ok"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <!-- check whether the object is in the file -->
            <xsl:for-each
              select="document(string($express_file_to_read))//express/schema[@name=$if_schema_name]">
              <!-- changed focus to the interfaced document - there should only
                   be one. Now recurse -->
              <xsl:call-template name="link_object_xref">
                <xsl:with-param name="object_name" select="$object_name"/>
                <xsl:with-param 
                  name="object_used_in_schema_name" 
                  select="$if_schema_name"/>
              </xsl:call-template>
            </xsl:for-each>            
          </xsl:otherwise>
        </xsl:choose>

      </xsl:for-each>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<!-- 
     Recurse through a list of select items and output the list as a set of
     URLS
     prefix and suffix are the prefixes and suffixes to be added to each
     object in the list
-->
<xsl:template name="link_list">
  <xsl:param name="list"/>
  <xsl:param name="object_used_in_schema_name"/>
  <xsl:param name="prefix"/>
  <xsl:param name="suffix"/>

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
      </xsl:call-template>
      
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

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



</xsl:stylesheet>
