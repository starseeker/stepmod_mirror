<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>
<!--
$Id: sect_annex_shortnames.xsl,v 1.16 2005/03/02 10:47:35 robbod Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep and supplied to NIST, PDES Inc under contract.
  Purpose:     
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		xmlns:exslt="http://exslt.org/common"
                exclude-result-prefixes="msxsl exslt"
                version="1.0">


  <xsl:import href="application_protocol.xsl"/>
  <xsl:import href="application_protocol_clause.xsl"/>
  <xsl:import href="../../xsl/common.xsl"/>
  
  <xsl:output method="html"/>


  <xsl:variable name="selected_ap" select="/application_protocol_clause/@directory"/>

  <xsl:variable name="ap_file" 
	    select="concat('../../data/application_protocols/',$selected_ap,'/application_protocol.xml')"/>
	    

  <xsl:variable name="ap_node"
	    select="document($ap_file)"/>

  <xsl:variable name="ap_top_module"
	    select="$ap_node/application_protocol/@module_name"/>

  <xsl:template match="application_protocol">

    <xsl:call-template name="annex_header">
      <xsl:with-param name="annex_no" select="'B'"/>
      <xsl:with-param name="heading" select="'MIM short names'"/>
      <xsl:with-param name="aname" select="'annexb'"/>
      <xsl:with-param name="informative" select="'normative'"/>
    </xsl:call-template>
    
    <xsl:variable name="top_module_file" 
      select="concat('../../data/modules/',$ap_top_module,'/mim.xml')"/>
    
    <xsl:variable name="top_module_node"
      select="document($top_module_file)/express"/>
    
    <xsl:variable name="schema-name"
      select="$top_module_node//schema/@name"/>

    <xsl:variable name="mim_lf_file"
      select="concat('../../data/modules/',$ap_top_module,'/mim_lf.xml')"/>

    <xsl:variable name="mim_lf" select="document($mim_lf_file)"/>
    <xsl:variable name="mim_entity_names">
      <xsl:for-each select="$mim_lf/express/schema/entity">
        <xsl:element name="entity">
          <xsl:attribute name="name">
            <xsl:value-of 
              select="translate(@name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
          </xsl:attribute>
        </xsl:element>
      </xsl:for-each>
    </xsl:variable>


    <xsl:variable name="mim_schemas">
      <xsl:call-template name="depends-on-recurse-mim-x">
        <xsl:with-param name="todo" select="concat(' ',$schema-name,' ')"/>
        <xsl:with-param name="done" select="' '"/>
      </xsl:call-template>
    </xsl:variable>
 
    <xsl:choose>
     <xsl:when test="function-available('msxsl:node-set')">
       <xsl:variable name="schemas-node-set" select="msxsl:node-set($mim_schemas)"/>
       <xsl:variable name="mim_entity_nodes" select="msxsl:node-set($mim_entity_names)"/>

        <xsl:variable name="short-names3">
          <xsl:for-each select="$schemas-node-set//x">
            <xsl:sort/>

            <!-- RBN do not understand why the path is ../../.. -->
            <xsl:variable name="module" 
              select="substring-after(substring-before(.,'/mim'),'../../../modules/')"/>
            <xsl:variable name="module_path"
              select="concat('../../data/modules/',$module,'/module.xml')"/>

            <xsl:variable name="module_ok">
              <xsl:call-template name="check_module_exists">
                <xsl:with-param name="module" select="$module"/>
              </xsl:call-template>
            </xsl:variable>

            <mod>
              <xsl:choose>
                <xsl:when test="$module">
                  <xsl:choose>
                    <xsl:when test="$module_ok='true'">
                      <xsl:apply-templates select="document($module_path)/module/mim/shortnames/shortname"
                        mode="copy_shortnames">
                        <xsl:with-param name="module" select="$module"/>
                      </xsl:apply-templates>
                    </xsl:when>
                    <xsl:otherwise>
                      <error>
                        <xsl:value-of select="$module"/>
                      </error>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:variable name="resource"
                    select="substring-before(substring-after(.,'resources/') ,'/')"/>
                  <xsl:variable name="resource_ok">
                    <xsl:call-template name="check_resource_exists">
                      <xsl:with-param name="schema" select="$resource"/>
                    </xsl:call-template>
                  </xsl:variable>
                  <xsl:choose>
                    <xsl:when test="$resource_ok='true'">
                      <xsl:call-template name="get_resource_shortnames">
                        <xsl:with-param name="resource" select="$resource"/>
                        <xsl:with-param name="mim_entity_nodes" select="$mim_entity_names"/>
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                      <error>
                        <xsl:value-of select="$resource"/>
                      </error>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </mod>
          </xsl:for-each>
        </xsl:variable>

        <xsl:variable name="short-names" select="msxsl:node-set($short-names3)"/>

        <xsl:call-template name="short_name_table">
          <xsl:with-param name="short-names" select="$short-names"/>
        </xsl:call-template>
    </xsl:when>

    
    <xsl:when test="function-available('exslt:node-set')">
       <xsl:variable name="schemas-node-set" select="exslt:node-set($mim_schemas)"/>
       <xsl:variable name="mim_entity_nodes" select="exslt:node-set($mim_entity_names)"/>
        <xsl:variable name="short-names3">
          <xsl:for-each select="$schemas-node-set//x">
            <xsl:sort/>
            <xsl:variable name="module" 
              select="substring-after(substring-before(.,'/mim'),'modules/')"/>
            <xsl:variable name="module_path"
              select="concat('../../data/modules/',$module,'/module.xml')"/>
            <xsl:variable name="module_ok">
              <xsl:call-template name="check_module_exists">
                <xsl:with-param name="module" select="$module"/>
              </xsl:call-template>
            </xsl:variable>

            <mod>
              <xsl:choose>
                <xsl:when test="$module">
                  <xsl:choose>
                    <xsl:when test="$module_ok='true'">
                      <xsl:apply-templates select="document($module_path)/module/mim/shortnames/shortname"
                        mode="copy_shortnames">
                        <xsl:with-param name="module" select="$module"/>
                      </xsl:apply-templates>
                    </xsl:when>
                    <xsl:otherwise>
                      <error>
                        <xsl:value-of select="$module"/>
                      </error>
                    </xsl:otherwise>
                  </xsl:choose>                  
                </xsl:when>
                <xsl:otherwise>
                  <xsl:variable name="resource"
                    select="substring-before(substring-after(.,'resources/') ,'/')"/>
                  <xsl:variable name="resource_ok">
                    <xsl:call-template name="check_resource_exists">
                      <xsl:with-param name="schema" select="$resource"/>
                    </xsl:call-template>
                  </xsl:variable>
                  <xsl:choose>
                    <xsl:when test="$resource_ok='true'">
                      <xsl:call-template name="get_resource_shortnames">
                        <xsl:with-param name="resource" select="$resource"/>
                        <xsl:with-param name="mim_entity_nodes" select="$mim_entity_nodes"/>
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                      <error>
                        <xsl:value-of select="$resource"/>
                      </error>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </mod>
          </xsl:for-each>
        </xsl:variable>

        <xsl:variable name="short-names" select="exslt:node-set($short-names3)"/>

        <xsl:call-template name="short_name_table">
          <xsl:with-param name="short-names" select="$short-names"/>
        </xsl:call-template>
    </xsl:when>
  </xsl:choose>

  </xsl:template> 


<xsl:template match="shortname" mode="copy_shortnames">
  <xsl:param name="module"/>

  <xsl:element name="shortname">
    <xsl:attribute name="name">
      <xsl:value-of select="@name"/>
    </xsl:attribute>
    <xsl:attribute name="entity" >
      <xsl:value-of select="@entity"/>
    </xsl:attribute>
    <xsl:attribute name="module_name" >
      <xsl:value-of select="$module"/>
    </xsl:attribute>
    <xsl:attribute name="module_part_no" >
      <xsl:value-of select="concat('ISO/',/module/@status,'&#160;10303-',/module/@part)"/>
    </xsl:attribute>

  </xsl:element>
</xsl:template>


<xsl:template match="shortname" mode="output_shortnames_error">
  <xsl:call-template name="error_message">
    <xsl:with-param name="message">
      <xsl:value-of select="concat('Error APsn1: Module ',@module,' not found')"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="shortname" mode="output_shortnames">
  <xsl:variable name="module" select="@module_name"/>
  <tr>
    <td align="left"><xsl:value-of select="@entity"/></td>
    <td align="left">
      <!--  <a
href="../../../../data/modules/{$module}/sys/a_short_names{$FILE_EXT}"> -->
      <xsl:value-of select="@name"/>
    </td>
    <td align="left"><xsl:value-of select="@module_part_no"/></td>
  </tr>
</xsl:template>



<xsl:template name="short_name_table">
  <xsl:param name="short-names"/>
        <xsl:apply-templates select="$short-names//mod/error"
          mode="output_shortnames_error">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
        <p>
          <!--
          Table B.1 provides the short names of entities defined in the MIMs of
          modules used in this part of ISO 10303. 
          Requirements on the use of the short names are found in the
          implementation methods included in ISO 10303.
               -->
          Table B.1 provides the short names of entities used in the MIM
          EXPRESS expanded listing for in this part of ISO 10303. 
          Requirements on the use of the short names are found in the
          implementation methods included in ISO 10303.          
        </p>
        <p class="note">
          <small>
            NOTE&#160;&#160;The EXPRESS entity names are available from
            Internet:<br/>  
          </small>
        </p>
        <p align="center">
          <small>
	    <xsl:variable name="names_url"
		    select="'http://standards.iso.org/iso/10303/tech/short_names/short_names.txt'"/>
            <a href="{$names_url}" target="_blank">
              <xsl:value-of select="$names_url"/>
            </a>
          </small>
        </p>
        <p align="center">
          <b>
            <a name="table_b1">
              Table B.1&#8212; MIM short names of entities 
            </a>
          </b>
        </p>

	
        <div align="center">
          <table border="1" cellspacing="0" cellpadding="7" width="90%">
            <tr>
              <td>
                <b>Entity data types name</b>
              </td>
              <td>
                <b>Short name</b>
              </td>
              <td>
                <b>Module/Resource</b>
              </td>
            </tr>
            <xsl:apply-templates select="$short-names//mod/shortname"
              mode="output_shortnames">
              <xsl:sort select="@entity"/>
              <!-- <xsl:sort select="@name"/> -->
            </xsl:apply-templates>              
          </table>
        </div>
</xsl:template>





<xsl:template name="depends-on-recurse-mim-x">
  <xsl:param name="todo" select="' '"/>
  <xsl:param name="done" />
    <!--
         For each interfaced schema:
         Check if not already done
         Otherwise output and add to todo
         -->
    <xsl:variable name="this-schema" 
	    select="substring-before(concat(normalize-space($todo),' '),' ')"/>



    <xsl:if test="$this-schema">
        <xsl:variable name="prefix">
          <xsl:call-template name="get_last_section">
            <xsl:with-param name="path" select="$this-schema"/>
            <xsl:with-param name="divider" select="'_'"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="module">
          <xsl:call-template name="get_string_before">
            <xsl:with-param name="str" select="$this-schema"/>
            <xsl:with-param name="char" select="'_'"/>
          </xsl:call-template>
        </xsl:variable>

      <!-- open up the relevant schema  - which can be a resource or a mim schema -->
      <xsl:variable name="file_name">
        <xsl:choose>
          <xsl:when test="function-available('msxsl:node-set')">
            <xsl:choose>
              <xsl:when test="$prefix='mim'">
                <xsl:value-of select="concat('../../../modules/',$module,'/mim.xml')"/>
              </xsl:when>
              <xsl:when test="$prefix='schema'">
                <xsl:value-of select="concat('../../../resources/',$this-schema,'/',$this-schema,'.xml')"/>
              </xsl:when>
              <xsl:when test="starts-with($this-schema,'aic_')">
                <xsl:value-of select="concat('../../../resources/',$this-schema,'/',$this-schema,'.xml')"/>
              </xsl:when>
              <xsl:otherwise>
                BAD SCHEMA name !!! <xsl:value-of select="$this-schema"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="function-available('exslt:node-set')" >
          <xsl:choose>
            <xsl:when test="$prefix='mim'">
              <xsl:value-of select="concat('../../data/modules/',$module,'/mim.xml')"/>
            </xsl:when>
            <xsl:when test="$prefix='schema'">
              <xsl:value-of select="concat('../../data/resources/',$this-schema,'/',$this-schema,'.xml')"/>
            </xsl:when>
            <xsl:when test="starts-with($this-schema,'aic_')">
              <xsl:value-of select="concat('../../data/resources/',$this-schema,'/',$this-schema,'.xml')"/>
            </xsl:when>
            <xsl:otherwise>
              BAD SCHEMA name !!! <xsl:value-of select="$this-schema"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:if test="not(contains($done,concat(' ',$this-schema,' ')))">
    <x><xsl:value-of select="translate($file_name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
    'abcdefghijklmnopqrstuvwxyz')" /></x>
  </xsl:if>
  
  <xsl:variable name="mim-node" select="document($file_name)/express"/>
  
  
  <!-- get the list of schemas for this level that have not already been done -->

  <xsl:variable name="my-kids" >
    <xsl:if test="not(contains($done,concat(' ',$this-schema,' ')))" >
      <xsl:apply-templates select="$mim-node//interface" mode="interface-schemas">
        <xsl:with-param name="done" select="$done" />
        </xsl:apply-templates>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="after" select="normalize-space(concat(substring-after($todo, $this-schema),$my-kids))"/>
                          
    <xsl:if test="$after">
      <xsl:call-template name="depends-on-recurse-mim-x">
        <xsl:with-param name="todo" select="$after"/>
        <xsl:with-param name="done" select="concat($done,' ',$this-schema,' ')"/>
      </xsl:call-template>
    </xsl:if>
    
  </xsl:if>

</xsl:template>

<xsl:template match="interface" mode="interface-schemas">
  <xsl:param name="done"/>
  <xsl:variable name="schema" select="concat(' ',@schema,' ')"/>
  <xsl:if test="not(contains($done,$schema))">
    <xsl:value-of select="$schema"/> 
  </xsl:if>
</xsl:template>


<xsl:template name="get_resource_shortnames">
  <xsl:param name="resource"/>
  <xsl:param name="mim_entity_nodes"/>
  <xsl:variable name="resource_file" 
    select="concat('../../data/resources/',$resource,'/',$resource,'.xml')"/>
  <xsl:variable name="resource_entities" select="document($resource_file)//entity"/>
  <xsl:variable name="resource_reference" select="document($resource_file)/express/@reference"/>

  <xsl:variable name="resource_shortname_file" select="'../../data/basic/ap_doc/shortnames.xml'"/>

  <xsl:variable name="resource_shortnames" 
    select="document($resource_shortname_file)/shortnames"/>

  <xsl:for-each select="$resource_entities">

    <xsl:variable name="resource_entity" 
      select="translate(@name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>

    <xsl:variable name="resource_shortname" 
      select="$resource_shortnames/shortname[translate(@entity,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')=$resource_entity]"/>
      <xsl:if test="$mim_entity_nodes/entity[@name=$resource_entity]">
        <!-- the resource entity is used in the mim lf -->
        <xsl:if test="$resource_shortname">
          <!-- the resource entity has a shortname -->
          <shortname>
            <xsl:attribute name="name">
              <xsl:value-of select="$resource_shortname/@shortname"/>
            </xsl:attribute>
            <xsl:attribute name="entity" >
              <xsl:value-of select="@name"/>
            </xsl:attribute>
            <xsl:attribute name="module_part_no" >
              <xsl:value-of select="$resource_reference"/>
            </xsl:attribute>
          </shortname>
        </xsl:if>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>


  
</xsl:stylesheet>

