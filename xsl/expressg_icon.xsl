<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: expressg_icon.xsl,v 1.13 2014/06/13 12:58:59 nigelshaw Exp $
  Author:  Rob Bodington, Eurostep Limited
  Owner:   Developed by Eurostep
  Purpose: Read the are maps in an image and create a node list. This is
     then used to determine the EXPRESSG page on which an entity is drawn.
-->
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:exslt="http://exslt.org/common"
  exclude-result-prefixes="msxsl exslt"
  version="1.0">

  <xsl:import href="common.xsl"/>

  <xsl:output method="html"/>


  <xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz'"/>

  <xsl:template name="make_arm_expressg_node_set">
    <expg_nodes>
      <xsl:choose>
        <xsl:when test="/module_clause">
          <xsl:variable name="module_dir">
            <xsl:call-template name="module_directory">
              <xsl:with-param name="module" select="/module_clause/@directory"/>
            </xsl:call-template>
          </xsl:variable>      
          <xsl:apply-templates 
            select="document(concat($module_dir,'/module.xml'))/module/arm/express-g/imgfile" mode="mk_node"/>
        </xsl:when>
        <xsl:when test="/module">
          <xsl:apply-templates 
            select="/module/arm/express-g/imgfile" mode="mk_node"/>
        </xsl:when>
      </xsl:choose>
    </expg_nodes>    
  </xsl:template>
  
  <!-- BOM -->
  <xsl:template name="make_bom_expressg_node_set">
    
	  <!-- this may be called from an AP (when constructing indexes) or BOM file (for clause 4) -->
    
    <expg_nodes>
	    <xsl:variable name="model_dir">
		<xsl:choose>
			<xsl:when test="/business_object_model_clause" >
				<xsl:value-of select="//business_object_model_clause/@directory"/>
			</xsl:when>
			<xsl:when test="/application_protocol">
				<xsl:value-of select="document(concat('../data/application_protocols/',
					/application_protocol/@directory,'/application_protocol.xml'))/application_protocol/@business_object_model"/>
			</xsl:when>
		</xsl:choose>
        <!--<xsl:call-template name="bom_directory">
          <xsl:with-param name="module" select="/business_object_model_clause/@directory"/>
          </xsl:call-template>-->
      </xsl:variable>
      
      <xsl:choose>
        <xsl:when test="string-length($model_dir) > 1">
          <xsl:apply-templates 
            select="document(concat('../data/business_object_models/', $model_dir,'/business_object_model.xml'))/business_object_model/inforeqt/bom/express-g/imgfile" mode="mk_bom_node"/>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
      
      <!--<xsl:apply-templates 
      select="document(concat('../data/business_object_models/', $model_dir,'/business_object_model.xml'))/business_object_model/inforeqt/bom/express-g/imgfile" mode="mk_bom_node"/>-->
      
    </expg_nodes>
    
  </xsl:template>


  <xsl:template name="make_mim_expressg_node_set">       
    <expg_nodes>
      <xsl:choose>
        <xsl:when test="/module_clause">
          <xsl:variable name="module_dir">
            <xsl:call-template name="module_directory">
              <xsl:with-param name="module" select="/module_clause/@directory"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="module" select="concat($module_dir,'/module.xml')"/>
          <xsl:variable name="module_xml" select="document($module)"/>
          <xsl:apply-templates 
            select="$module_xml/module/mim/express-g/imgfile" mode="mk_node"/>
        </xsl:when>
        <xsl:when test="/module">
          <xsl:apply-templates 
            select="/module/mim/express-g/imgfile" mode="mk_node"/>
        </xsl:when>

      </xsl:choose>
    </expg_nodes>    
  </xsl:template>


  <xsl:template name="get_arm_expressg_file">
    <xsl:param name="object"/>
    <xsl:choose>
      <xsl:when test="function-available('msxsl:node-set')">
        <xsl:variable name="arm_expressg_node_set" select="msxsl:node-set($arm_expressg)"/>
        <xsl:apply-templates
          select="$arm_expressg_node_set/expg_nodes/object[@object=$object]" mode="get_file"/>
      </xsl:when>
      <xsl:when test="function-available('exslt:node-set')">
        <xsl:variable name="arm_expressg_node_set" select="exslt:node-set($arm_expressg)"/>
        <xsl:apply-templates
          select="$arm_expressg_node_set/expg_nodes/object[@object=$object]" mode="get_file"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="get_bom_expressg_file">
    <xsl:param name="object"/>
    <xsl:choose>
      <xsl:when test="function-available('msxsl:node-set')">
        <xsl:variable name="bom_expressg_node_set" select="msxsl:node-set($bom_expressg)"/>
        <xsl:apply-templates
          select="$bom_expressg_node_set/expg_nodes/object[@object=$object]" mode="get_file"/>
      </xsl:when>
      <xsl:when test="function-available('exslt:node-set')">
        <xsl:variable name="bom_expressg_node_set" select="exslt:node-set($bom_expressg)"/>
        <xsl:apply-templates
          select="$bom_expressg_node_set/expg_nodes/object[@object=$object]" mode="get_file"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="get_mim_expressg_file">
    <xsl:param name="object"/>
    <xsl:choose>
      <xsl:when test="function-available('msxsl:node-set')">
        <xsl:variable name="mim_expressg_node_set" select="msxsl:node-set($mim_expressg)"/>
        <xsl:apply-templates
          select="$mim_expressg_node_set/expg_nodes/object[@object=$object]" mode="get_file"/>
      </xsl:when>
      <xsl:when test="function-available('exslt:node-set')">
        <xsl:variable name="mim_expressg_node_set" select="exslt:node-set($mim_expressg)"/>
        <xsl:apply-templates
          select="$mim_expressg_node_set/expg_nodes/object[@object=$object]" mode="get_file"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="get_arm_expressg_href">
    <xsl:param name="object"/>
    <xsl:choose>
      <xsl:when test="function-available('msxsl:node-set')">
        <xsl:variable name="arm_expressg_node_set" select="msxsl:node-set($arm_expressg)"/>
        <xsl:apply-templates
          select="$arm_expressg_node_set/expg_nodes/object[@object=$object]" mode="get_href"/>
      </xsl:when>
      <xsl:when test="function-available('exslt:node-set')">
        <xsl:variable name="arm_expressg_node_set" select="exslt:node-set($arm_expressg)"/>
        <xsl:apply-templates
          select="$arm_expressg_node_set/expg_nodes/object[@object=$object]" mode="get_href"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="get_bom_expressg_href">
    <xsl:param name="object"/>
    
    <xsl:choose>
      <xsl:when test="function-available('msxsl:node-set')">
        <xsl:variable name="bom_expressg_node_set" select="msxsl:node-set($bom_expressg)"/>
        
        <xsl:apply-templates
          select="$bom_expressg_node_set/expg_nodes/object[@object=$object]" mode="get_href"/>
      </xsl:when>
      <xsl:when test="function-available('exslt:node-set')">
        
        <xsl:variable name="bom_expressg_node_set" select="exslt:node-set($bom_expressg)"/>
        
        <xsl:apply-templates
          select="$bom_expressg_node_set/expg_nodes/object[@object=$object]" mode="get_href"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="get_mim_expressg_href">
    <xsl:param name="object"/>
    <xsl:choose>
      <xsl:when test="function-available('msxsl:node-set')">
        <xsl:variable name="mim_expressg_node_set" select="msxsl:node-set($mim_expressg)"/>
        <xsl:apply-templates
          select="$mim_expressg_node_set/expg_nodes/object[@object=$object]" mode="get_href"/>
      </xsl:when>
      <xsl:when test="function-available('exslt:node-set')">
        <xsl:variable name="mim_expressg_node_set" select="exslt:node-set($mim_expressg)"/>
        <xsl:apply-templates
          select="$mim_expressg_node_set/expg_nodes/object[@object=$object]" mode="get_href"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="object" mode="get_href">
    <xsl:value-of select="@href"/>
    
  </xsl:template>

  <xsl:template match="object" mode="get_file">
    <xsl:value-of select="@file"/>
  </xsl:template>

  <!-- build the node set of expressg objects for a BOM -->
  <xsl:template match="imgfile" mode="mk_bom_node">
    <xsl:variable name="img_file"
      select="concat('../data/business_object_models/',/business_object_model/@name,'/',./@file)"/>
   
    <xsl:variable name="img_file_xml" select="document(string($img_file))"/>
    <xsl:variable name="schema" select="concat(//business_object_model/@name,'_bom')"/>
    
    
    <xsl:apply-templates
      select="$img_file_xml/imgfile.content/img/img.area" mode="mk_bom_node">
      <xsl:with-param name="schema" select="$schema"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- build the node set of expressg objects -->
  <xsl:template match="imgfile" mode="mk_node">
    <xsl:variable name="img_file"
      select="concat('../data/modules/',/module/@name,'/',./@file)"/>
    <xsl:variable name="img_file_xml" select="document($img_file)"/>
    <xsl:variable name="schema" select="concat(/module/@name,'_',name(../..))"/>
    <xsl:apply-templates
      select="$img_file_xml/imgfile.content/img/img.area" mode="mk_node">
      <xsl:with-param name="schema" select="$schema"/>
    </xsl:apply-templates>
  </xsl:template>

<!-- BOM -->
  <xsl:template match="img.area" mode="mk_bom_node">
    <xsl:param name="schema"/>
    
    <xsl:variable name="model" select="./../../@business_object_model"/>
    
    <xsl:variable name="uobject"
      select="normalize-space(substring-after(substring-after(@href,'#'),'.'))"/>
    
    <xsl:variable name="object"
      select="translate($uobject,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
   
    <xsl:if test="string-length($object)!=0">
      <!-- the first page should be the schema page so should not have any
        entities on it -->
      <xsl:variable name="schema1"
        select="normalize-space(substring-before(substring-after(@href,'#'),'.'))"/>
      
      <xsl:variable name="lschema"
        select="translate($schema1,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
      
      <xsl:if test="$schema = $lschema">
        <!-- only need to identify the hrefs to objects defined in this
          schema --> 
        <xsl:variable name="file">
          <xsl:call-template name="set_file_ext">
            <xsl:with-param name="filename" select="/imgfile.content/@file"/>
          </xsl:call-template>
        </xsl:variable>
        
        <!--<xsl:variable name="model" select="//business_object_model/@name"/>-->
        
       
        
        <xsl:element name="object">
          <xsl:attribute name="file">
            <xsl:value-of select="$file"/>
          </xsl:attribute>
          <xsl:attribute name="object">
            <xsl:value-of select="$object"/>
          </xsl:attribute>
          <xsl:attribute name="href">
		  <xsl:value-of select="concat('../../../business_object_models/',$model,'/',$file)"/>
          </xsl:attribute>
        </xsl:element>
      </xsl:if>
    </xsl:if>
    
  </xsl:template>


  <xsl:template match="img.area" mode="mk_node">
    <xsl:param name="schema"/>

    <xsl:variable name="uobject"
      select="normalize-space(substring-after(substring-after(@href,'#'),'.'))"/>
    <xsl:variable name="object"
        select="translate($uobject,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>

    <xsl:if test="string-length($object)!=0">
      <!-- the first page should be the schema page so should not have any
           entities on it -->
      <xsl:variable name="schema1"
        select="normalize-space(substring-before(substring-after(@href,'#'),'.'))"/>

      <xsl:variable name="lschema"
        select="translate($schema1,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>

      <xsl:if test="$schema = $lschema">
        <!-- only need to identify the hrefs to objects defined in this
             schema --> 
        <xsl:variable name="file">
          <xsl:call-template name="set_file_ext">
            <xsl:with-param name="filename" select="/imgfile.content/@file"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="module">
          <xsl:call-template name="module_name">
            <xsl:with-param name="module" select="$lschema"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:element name="object">
          <xsl:attribute name="file">
            <xsl:value-of select="$file"/>
          </xsl:attribute>
          <xsl:attribute name="object">
            <xsl:value-of select="$object"/>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="concat('../../',$module,'/',$file)"/>
          </xsl:attribute>
        </xsl:element>
      </xsl:if>
    </xsl:if>

  </xsl:template>
  
    <xsl:variable name="bom_expressg">
    <xsl:call-template name="make_bom_expressg_node_set"/>
  </xsl:variable>
  
  
  <xsl:template name="expressg_icon">
    <xsl:param name="schema"/>
    <xsl:param name="entity"/>
    <xsl:param name="module_root" select="'..'"/>
    <xsl:param name="target" select="'_self'"/>
    <xsl:variable name="module_dir">
      <xsl:call-template name="module_directory">
        <xsl:with-param name="module" select="$schema"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="lentity"
      select="translate(normalize-space($entity),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/> 
    
    <xsl:choose>
      <xsl:when test="$lentity">
        <xsl:choose>

          <!-- ARM expressg -->
          <xsl:when test="substring($schema,string-length($schema)-3)='_arm'">
            <xsl:variable name="href_expg">
              <xsl:call-template name="get_arm_expressg_href">
                <xsl:with-param name="object" select="$lentity"/>
              </xsl:call-template>
            </xsl:variable>

            <xsl:choose>
              <xsl:when test="string-length($href_expg)=0">
                <xsl:variable name="error_msg"
                  select="concat('Error EG1: There is no EXPRESS-G reference for:',$lentity,' - check armexpg files')"/>
                <xsl:call-template name="error_message">
                  <xsl:with-param name="inline" select="'yes'"/>
                  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
                  <xsl:with-param name="message" select="$error_msg"/>
                </xsl:call-template>    
              </xsl:when>
              <xsl:otherwise>
                &#160;&#160;<a href="{$href_expg}"  target="{$target}">
                <img align="middle" border="0" 
                  alt="EXPRESS-G" src="{$module_root}/../../../images/expg.gif"/>
              </a>
            </xsl:otherwise>
          </xsl:choose>
          </xsl:when>
          
          <!-- BOM expressg -->
          <xsl:when test="substring($schema,string-length($schema)-3)='_bom'">
            
            <xsl:variable name="href_expg">
              <xsl:call-template name="get_bom_expressg_href">
                <xsl:with-param name="object" select="$lentity"/>
              </xsl:call-template>
            </xsl:variable>
            
            
            <xsl:choose>
              <xsl:when test="string-length($href_expg)=0">
                <xsl:variable name="error_msg"
			select="concat('Error EG1-BOM: There is no EXPRESS-G reference for:',$lentity,' - check bom expg files GGG',count($bom_expressg/*),'GGG')"/>
                <xsl:call-template name="error_message">
                  <xsl:with-param name="inline" select="'yes'"/>
                  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
                  <xsl:with-param name="message" select="$error_msg"/>
                </xsl:call-template>    
              </xsl:when>
              <xsl:otherwise>
            
                &#160;&#160;<a href="{$href_expg}"  target="{$target}">
                  <img align="middle" border="0" 
                    alt="EXPRESS-G" src="{$module_root}/../../../images/expg.gif"/>
                </a>
              </xsl:otherwise>
              </xsl:choose>
            
          </xsl:when>

        <!-- MIM expressg -->
        <xsl:when test="substring($schema, string-length($schema)-3)='_mim'">
          <xsl:variable name="href_expg">
            <xsl:call-template name="get_mim_expressg_href">
              <xsl:with-param name="object" select="$lentity"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="string-length($href_expg)=0">
              <xsl:variable name="error_msg"
                select="concat('Error EG1: There is no EXPRESS-G reference for:',$lentity,' - check mimexpg files')"/>
              <xsl:call-template name="error_message">
                <xsl:with-param name="inline" select="'yes'"/>
                <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
                <xsl:with-param name="message" select="$error_msg"/>
              </xsl:call-template>    
            </xsl:when>
            <xsl:otherwise>
              &#160;&#160;<a href="{$href_expg}">
              <img align="middle" border="0" 
                alt="EXPRESS-G" src="{$module_root}/../../../images/expg.gif"/></a>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="href_expg">
        <xsl:choose>
          <xsl:when test="substring($schema, string-length($schema)-3)='_arm'">
            <xsl:value-of select="concat($module_root,'/armexpg1',$FILE_EXT)"/>
          </xsl:when>
          <xsl:when test="substring($schema, string-length($schema)-3)='_mim'">
            <xsl:value-of select="concat($module_root,'/mimexpg1',$FILE_EXT)"/>
          </xsl:when>
        </xsl:choose>        
      </xsl:variable>
      &#160;&#160;<a href="{$href_expg}"  target="{$target}">
      <img align="middle" border="0" 
        alt="EXPRESS-G" src="{$module_root}/../../../images/expg.gif"/>
       </a>
     </xsl:otherwise>
   </xsl:choose>
 </xsl:template>


  <!-- display the expressg Icon for an express construct -->
  <xsl:template match="entity|type|schema|constant|subtype.constraint" mode="expressg_icon">
    <!-- the entity may be being referenced from another module
         in which case the schema needs to be explicit.
         This only happens in the mapping tables when and ARM object is
         being remapped from another module. -->
    <xsl:param name="original_schema"/>
    <xsl:param name="target"/>
    <xsl:param name="module_root" select="'..'"/>
    
    <xsl:variable name="schema">
      <xsl:choose>
        <!-- original_module specified then the ARM object is declared in
             another module -->
        <xsl:when test="$original_schema">
          <xsl:value-of select="$original_schema"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="../@name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
   
    <xsl:variable name="entity" select="@name"/>

    <xsl:call-template name="expressg_icon">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="entity" select="$entity"/>
      <xsl:with-param name="target" select="$target"/>
      <xsl:with-param name="module_root" select="$module_root"/>
    </xsl:call-template>

  </xsl:template>

</xsl:stylesheet>
