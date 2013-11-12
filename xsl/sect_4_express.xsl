<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
     $Id: sect_4_express.xsl,v 1.129 2012/11/06 09:44:14 mikeward Exp $

  Author: Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep and supplied to NIST under contract.
  Purpose: 
     Used to display the commented XML encoded EXPRESS
     in clause 4 and 5 of a module.
-->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
>

  <xsl:import href="express_link.xsl"/> 
  <xsl:import href="express_description.xsl"/> 

  <xsl:import href="projmg/issues.xsl"/> 

  <xsl:output method="html"/>

  <!-- +++++++++++++++++++
         Global variables
       +++++++++++++++++++ -->

  <!-- 
       Global variable used in express_link.xsl by:
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
       build_xref_list is defined in express_link
       -->
  <xsl:variable name="global_xref_list">
    <!-- debug 
    <xsl:message>
      global_xref_list defined in sect_4_express.xsl
    </xsl:message> -->
    <xsl:choose>
      <xsl:when test="/module_clause">
        <xsl:variable name="module_dir">
          <xsl:call-template name="module_directory">
            <xsl:with-param name="module" select="/module_clause/@directory"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="express_xml" select="concat($module_dir,'/arm.xml')"/>
        <xsl:call-template name="build_xref_list">
          <xsl:with-param name="express" select="document($express_xml)/express"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="/module">
        <xsl:variable name="module_dir">
          <xsl:call-template name="module_directory">
            <xsl:with-param name="module" select="/module/@name"/>
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="express_xml" select="concat($module_dir,'/arm.xml')"/>
        <xsl:call-template name="build_xref_list">
          <xsl:with-param name="express" select="document($express_xml)/express"/>
        </xsl:call-template>        
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <!-- A global variable used by the express_file_to_ref template defined
       in express_link.xsl.
       It defines the relative path from the file applying the stylesheet
       to the root of the stepmod repository.
       sect_4_express.xsl stylesheet is normally applied from file in:
         stepmod/data/module/?module?/sys/
       Hence the relative root is: ../../../
       -->
  <xsl:variable 
    name="relative_root"
    select="'../../../../'"/>


  <!-- +++++++++++++++++++
         Templates
       +++++++++++++++++++ -->

<!-- Just display the description of the schema. This is called from
     module.xsl -->
<xsl:template match="schema" mode="description">
  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="./@name"/>
  </xsl:call-template> 
  <!-- output description from express -->
  <p>
    <xsl:if test="string-length(./description)>0">
      <xsl:apply-templates select="./description" mode="exp_description"/>
    </xsl:if>
  </p>
</xsl:template>

<xsl:template match="interface">
  <xsl:variable name="schema_name" select="../@name"/>      
  <xsl:if test="position()=1">
    <xsl:variable name="clause_number">
      <xsl:call-template name="express_clause_number">
        <xsl:with-param name="clause" select="'interface'"/>
        <xsl:with-param name="schema_name" select="$schema_name"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="clause_header">
      <xsl:choose>
        <xsl:when test="contains($schema_name,'_arm')">
          <xsl:choose>
            <xsl:when test="count(../interface)>1">          
              <xsl:value-of select="concat($clause_number, ' Required AM ARMs')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat($clause_number, ' Required AM ARM')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="contains($schema_name,'_mim')">
        </xsl:when>
      </xsl:choose>      
    </xsl:variable>

    <xsl:variable name="clause_intro">
      <xsl:choose>
        <xsl:when test="contains($schema_name,'_arm')">
          <xsl:choose>
            <xsl:when test="count(../interface)>1">          
              The following EXPRESS interface statements specify the elements
              imported from the ARMs of other application modules.
            </xsl:when>
            <xsl:otherwise>
              The following EXPRESS interface statement specifies the elements
              imported from the ARM of another application module.
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="contains($schema_name,'_mim')">
          <!-- no intro for the MIM -->
        </xsl:when>
      </xsl:choose>      
    </xsl:variable>
  
    <h2>
      <A NAME="interfaces">
        <xsl:value-of select="$clause_header"/>
      </A>
    </h2>
    <p><xsl:value-of select="$clause_intro"/></p>
    <xsl:if test="contains($schema_name,'_arm')">
      <p><u>EXPRESS specification:</u></p>
    </xsl:if>

  </xsl:if>
  <p>
  <!-- <blockquote> -->
    <code>
      <xsl:if test="contains($schema_name,'_arm') and position()=1">*)<br/></xsl:if>
      <xsl:choose>
        <xsl:when test="@kind='reference'">
          REFERENCE FROM 
          <xsl:call-template name="link_schema">
            <xsl:with-param 
              name="schema_name" 
              select="@schema"/>
            <xsl:with-param name="clause" select="'section'"/>
          </xsl:call-template>

          <xsl:choose>
            <xsl:when test="./interfaced.item">
              <!-- if interface items then output source tail comment now -->
              &#160;&#160;&#160;--&#160;
              <xsl:apply-templates select="." mode="source"/>
              <xsl:apply-templates select="./interfaced.item"/>;
              <xsl:if test="position()=last()"><br/>(*</xsl:if>
              <br/><br/>          
            </xsl:when>
            <xsl:otherwise>;
              &#160;&#160;&#160;--&#160;              
              <xsl:apply-templates select="." mode="source"/>
              <xsl:if test="position()=last()"><br/>(*</xsl:if>
              <br/><br/>
            </xsl:otherwise>
          </xsl:choose> 

        </xsl:when>
        <xsl:when test="@kind='use'">
          USE FROM
          <xsl:call-template name="link_schema">
            <!-- defined in sect_4_express_link.xsl -->
            <xsl:with-param 
              name="schema_name" 
              select="@schema"/>
            <xsl:with-param name="clause" select="'section'"/>
          </xsl:call-template>

          <xsl:choose>
            <xsl:when test="./interfaced.item">
              <!-- if interface items then out put source tail comment now -->
              &#160;&#160;&#160;--&#160;
              <xsl:apply-templates select="." mode="source"/>
              <xsl:apply-templates select="./interfaced.item"/>;
              <xsl:if test="position()=last()"><br/>(*</xsl:if>
              <br/><br/>          
            </xsl:when>
            <xsl:otherwise>;
              &#160;&#160;&#160;--&#160;
              <xsl:apply-templates select="." mode="source"/>
              <xsl:if test="position()=last()"><br/>(*</xsl:if>
              <br/><br/>
            </xsl:otherwise>
          </xsl:choose> 

      </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message" 
              select="concat('Error e1: Interface in schema ', 
                      $schema_name, 
                      ' is incorrectly specified')"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </code>
  <!-- </blockquote> -->
  </p>
  <xsl:if test="position()=last()">
    <xsl:call-template name="interface_notes">
      <xsl:with-param name="schema_node" select=".."/>
    </xsl:call-template>
    <xsl:if test="..//constant[contains(@name,'deprecated_interface')]">
      <xsl:call-template name="deprecated_interface_notes">
              <xsl:with-param name="schema_node" select=".."/>
            </xsl:call-template>
          </xsl:if>
        </xsl:if>
</xsl:template>

<!-- output the trailing comment that shows where the express came from -->
<xsl:template match="interface" mode="source">
  <xsl:variable name="module" select="string(@schema)"/> 
  <xsl:choose>
    <xsl:when 
      test="contains($module,'_arm') or contains($module,'_mim')">
      <!-- must be a module -->
      <xsl:variable name="module_ok">
        <xsl:call-template name="check_module_exists">
          <xsl:with-param name="module" select="$module"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$module_ok='true'">
          <xsl:variable name="mod_dir">
            <xsl:call-template name="module_directory">
              <xsl:with-param name="module" select="$module"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="part">
            <xsl:value-of
              select="document(concat($mod_dir,'/module.xml'))/module/@part"/>
          </xsl:variable>
          <xsl:variable name="status">
            <xsl:value-of
              select="document(concat($mod_dir,'/module.xml'))/module/@status"/>
          </xsl:variable>
          <xsl:value-of select="concat('ISO/',$status,'&#160;10303-',$part)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="error_message">
            <xsl:with-param name="message">
              <xsl:value-of 
                select="concat('Error IF-1: The module ',
                        $module,' cannot be found in repository_index.xml ')"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <xsl:otherwise>
      <!-- must be an integrated resource -->
      <xsl:variable name="resource_ok">
        <xsl:call-template name="check_resource_exists">
          <xsl:with-param name="schema" select="$module"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="$resource_ok='true'">
          <!-- found integrated resource schema, so get IR title -->
          <xsl:variable name="reference">
            <xsl:value-of
              select="document(concat('../data/resources/',$module,'/',$module,'.xml'))/express/@reference"/>
          </xsl:variable>

          <xsl:choose>
            <xsl:when test="string-length($reference)>0">
              <xsl:if test="not(starts-with($reference,'ISO 10303-')) and
                            not(starts-with($reference,'ISO 13584-')) and
                            not(starts-with($reference,'ISO 15926-'))">
                <xsl:call-template name="error_message">
                  <xsl:with-param name="message">
                    <xsl:value-of select="concat('Error IF-3a: The reference parameter for ',
                                          $module,' is incorrectly specified. It should
                                          be of the form ISO 10303-***. Change @reference in
                                          data/resources/',$module,'/',$module,'.xml.')"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:if>
              <xsl:value-of select="$reference"/>              
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="error_message">
                <xsl:with-param name="message">
                  <xsl:value-of 
                    select="concat('Error IF-3: The reference parameter for ',
                            $module,' has not been specified. Add
                            @reference (e.g. ISO 10303-***) to
                            data/resources/',$module,'/',$module,'.xml.')"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="error_message">
            <xsl:with-param name="message" 
              select="concat('Error IF-2: ',$resource_ok)"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>

    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- output a note detailing the interface -->
<xsl:template name="interface_notes">
  <xsl:param name="schema_node"/>
    <p class="note">
      <small>
        NOTE&#160;1&#160;&#160;
        The schemas referenced above are specified in the following 
        part of ISO 10303:
      </small>
    </p>
    <blockquote>
        <table>  
        <xsl:for-each select="$schema_node/interface">
          <xsl:variable name="schema_name" select="./@schema"/>      
          <tr>
            <td width="266">
              <b>
                <small>
                  <xsl:value-of select="$schema_name"/>
                </small>
              </b>
            </td>
            <td width="127">
              <small>
                <xsl:apply-templates select="." mode="source"/>
              </small>
            </td>
          </tr>
        </xsl:for-each>
      </table>
  </blockquote>
    <p class="note">
      <small>
        NOTE&#160;2&#160;&#160;
        <xsl:variable name="module_dir">
          <xsl:call-template name="module_directory">
            <xsl:with-param name="module" select="$schema_node/@name"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="module_file"
          select="concat($module_dir,'/module.xml')"/>

        <xsl:choose>
          <xsl:when test="contains($schema_node/@name,'_arm')">
            <xsl:variable name="penultimate"
              select="count(document($module_file)/module/arm/express-g/imgfile)-1"/>
            See Annex <a href="c_arm_expg{$FILE_EXT}">C</a>, 
            <xsl:choose>
              <xsl:when
                test="count(document($module_file)/module/arm/express-g/imgfile)=1">
                Figure
              </xsl:when>
              <xsl:otherwise>
                Figures
              </xsl:otherwise>
            </xsl:choose>
            
            <xsl:for-each select="document($module_file)/module/arm/express-g/imgfile">
              <xsl:variable name="imgfile">
                <xsl:call-template name="set_file_ext">
                  <xsl:with-param name="filename" select="concat('../',@file)"/>   
                </xsl:call-template>
              </xsl:variable>
              <a href="{$imgfile}">
                <xsl:value-of select="concat('C.',position())"/>
              </a>
              <xsl:if test="position()!=last()">
                <xsl:choose>
                  <xsl:when test="position()!=$penultimate">, </xsl:when>
                  <xsl:otherwise>and </xsl:otherwise>
                </xsl:choose>
              </xsl:if>
            </xsl:for-each>
            for a graphical representation of this schema.
          </xsl:when>

          <xsl:otherwise>
            <xsl:variable name="penultimate"
              select="count(document($module_file)/module/mim/express-g/imgfile)-1"/>
            See Annex <a href="d_mim_expg{$FILE_EXT}">D</a>, 
            <xsl:choose>
              <xsl:when
                test="count(document($module_file)/module/mim/express-g/imgfile)=1">
                Figure
              </xsl:when>
              <xsl:otherwise>
                Figures
              </xsl:otherwise>
            </xsl:choose>
            
            <xsl:for-each select="document($module_file)/module/mim/express-g/imgfile">
              <xsl:variable name="imgfile">
                <xsl:call-template name="set_file_ext">
                  <xsl:with-param name="filename" select="concat('../',@file)"/>   
                </xsl:call-template>
              </xsl:variable>
              <a href="{$imgfile}">
                <xsl:value-of select="concat('D.',position())"/>
              </a>
              <xsl:if test="position()!=last()">
                <xsl:choose>
                  <xsl:when test="position()!=$penultimate">, </xsl:when>
                  <xsl:otherwise>and </xsl:otherwise>
                </xsl:choose>
              </xsl:if>
            </xsl:for-each>
            for a graphical representation of this schema.            
          </xsl:otherwise>
        </xsl:choose>
      </small>
    </p>

</xsl:template>

<!-- output a list of  deprecated types, if any -->
<xsl:template name="deprecated_types_note">
  <xsl:param name="schema_node"/>
    <p class="note">
      <small>
        NOTE&#160;&#160;
        In order to ensure upward compatability, this schema includes definitions for the following deprecated types:
      </small>
    </p>
    <blockquote>
        <table>  
        <xsl:variable name="deprecated_expressions">
          <xsl:for-each select="$schema_node/constant[contains(@name,'deprecated_constructed')]">
            :<xsl:value-of select="@expression"/>:
          </xsl:for-each>
        </xsl:variable>
<!-- THX this is the only way I could get it to accept an apostrophe as a match char -->
      <xsl:variable name="apostrophe">'</xsl:variable>
      <xsl:variable name="special" select="concat($apostrophe,'&#x2C;&#x5B;&#x5D; ')"/>
      <xsl:variable name="separator" select="':::::'"/>
        <xsl:variable name="deprecated"
        select="translate($deprecated_expressions,$special,$separator)"/>
        <xsl:for-each select="$schema_node/type">
          <xsl:if test="contains($deprecated,concat(':',./@name,':'))">
            <xsl:variable name="item_name" select="./@name"/>      
          <tr>
            <td width="266">
              <b>
                <small>
                  <xsl:value-of select="$item_name"/>
                </small>
              </b>
            </td>
          </tr>
        </xsl:if>
        </xsl:for-each>
      </table>
    </blockquote>
  </xsl:template>
<!-- output a note for a deprecated type  -->
<xsl:template name="deprecated_type_note">
  <xsl:param name="type"/>
  <xsl:variable name="deprecated_expressions">
    <xsl:for-each select="$type/../constant[contains(@name,'deprecated_constructed')]">
      :<xsl:value-of select="@expression"/>:
    </xsl:for-each>
  </xsl:variable>
<!-- THX this is the only way I could get it to accept an apostrophe as a match char -->
<xsl:variable name="apostrophe">'</xsl:variable>
<xsl:variable name="special" select="concat($apostrophe,'&#x2C;&#x5B;&#x5D; ')"/>
<xsl:variable name="separator" select="':::::'"/>
<xsl:variable name="deprecated"
  select="translate($deprecated_expressions,$special,$separator)"/>
<xsl:if test="contains($deprecated,concat(':',$type/@name,':'))">
  <xsl:variable name="item_name" select="$type/@name"/>      
  <p class="note">
    <small>
      NOTE&#160;&#160;
      The <b><xsl:value-of select="$item_name" /></b>  select type is kept in this edition in order to ensure upward compatability.  Its usage is deprecated.
    </small>
  </p>    
</xsl:if>
</xsl:template>

<!-- output a note for a deprecated entity  -->
<xsl:template name="deprecated_entity_note">
  <xsl:param name="type"/>
  <xsl:variable name="deprecated_expressions">
    <xsl:for-each select="$type/../constant[contains(@name,'deprecated_entity')]">
      :<xsl:value-of select="@expression"/>:
    </xsl:for-each>
  </xsl:variable>
<!-- THX this is the only way I could get it to accept an apostrophe as a match char -->
<xsl:variable name="apostrophe">'</xsl:variable>
<xsl:variable name="special" select="concat($apostrophe,'&#x2C;&#x5B;&#x5D; ')"/>
<xsl:variable name="separator" select="':::::'"/>
<xsl:variable name="deprecated"
  select="translate($deprecated_expressions,$special,$separator)"/>
<xsl:if test="contains($deprecated,concat(':',$type/@name,':'))">
  <xsl:variable name="item_name" select="$type/@name"/>      
  <p class="note">
    <small>
      NOTE&#160;&#160;
      The <b><xsl:value-of select="$item_name" /></b>  entiy data type is kept in this edition in order to ensure upward compatability.  Its usage is deprecated.
    </small>
  </p>    
</xsl:if>
</xsl:template>



<!-- output a list of all  deprecated entities, if any -->
<xsl:template name="deprecated_entities_note">
  <xsl:param name="schema_node"/>
    <p class="note">
      <small>
        NOTE&#160;&#160;
        In order to ensure upward compatability, this schema includes definitions for the following deprecated entities:
      </small>
    </p>
    <blockquote>
        <table>  
        <xsl:variable name="deprecated_expressions">
          <xsl:for-each select="$schema_node/constant[contains(@name,'deprecated_entity')]">
            :<xsl:value-of select="@expression"/>:
          </xsl:for-each>
        </xsl:variable>
<!-- THX this is the only way I could get it to accept an apostrophe as a match char -->
      <xsl:variable name="apostrophe">'</xsl:variable>
      <xsl:variable name="special" select="concat($apostrophe,'&#x2C;&#x5B;&#x5D; ')"/>
      <xsl:variable name="separator" select="':::::'"/>
        <xsl:variable name="deprecated"
        select="translate($deprecated_expressions,$special,$separator)"/>
        <xsl:for-each select="$schema_node/entity">
          <xsl:if test="contains($deprecated,concat(':',./@name,':'))">
            <xsl:variable name="item_name" select="./@name"/>      
          <tr>
            <td width="266">
              <b>
                <small>
                  <xsl:value-of select="$item_name"/>
                </small>
              </b>
            </td>
          </tr>
        </xsl:if>
        </xsl:for-each>
      </table>
    </blockquote>
    
</xsl:template>



<!-- output a note for deprecated interfaced constructs, if any -->
<xsl:template name="deprecated_interface_notes">
  <xsl:param name="schema_node"/>
    <p class="note">
      <small>
        NOTE&#160;3&#160;&#160;
        In order to insure upward compatability, explicit interfaces are made to the following deprecated data types:
      </small>
    </p>
    <blockquote>
        <table>  
        <xsl:variable name="deprecated_expressions">
          <xsl:for-each select="$schema_node/constant[contains(@name,'deprecated')]">
            :<xsl:value-of select="@expression"/>:
          </xsl:for-each>
        </xsl:variable>
<!-- THX this is the only way I could get it to accept an apostrophe as a match char -->
      <xsl:variable name="apostrophe">'</xsl:variable>
      <xsl:variable name="special" select="concat($apostrophe,'&#x2C;&#x5B;&#x5D; ')"/>
      <xsl:variable name="separator" select="':::::'"/>
        <xsl:variable name="deprecated"
        select="translate($deprecated_expressions,$special,$separator)"/>
        <xsl:for-each select="$schema_node/interface/interfaced.item">
          <xsl:if test="contains($deprecated,concat(':',./@name,':'))">
            
          <xsl:variable name="item_name" select="./@name"/>      
          <tr>
            <td width="266">
              <b>
                <small>
                  <xsl:value-of select="$item_name"/>
                </small>
              </b>
            </td>
            <td width="127">
              <small>
                <xsl:apply-templates select="." mode="source"/>
              </small>
            </td>
          </tr>
        </xsl:if>
        </xsl:for-each>
      </table>
    </blockquote>
    
</xsl:template>


<xsl:template match="interfaced.item">
  <xsl:choose>
    <xsl:when test="position()=1">
      <br/><xsl:text>&#160;&#160;(</xsl:text>
    </xsl:when>
    <xsl:otherwise>
        &#160;&#160;
    </xsl:otherwise>
  </xsl:choose>

  <xsl:call-template name="link_object">
    <xsl:with-param name="object_name" select="@name"/>
    <xsl:with-param name="object_used_in_schema_name" 
      select="../../@name"/>
    <xsl:with-param name="clause" select="'section'"/>
  </xsl:call-template>

  <xsl:if test="position()!=last()">,


<br/></xsl:if>

<xsl:if test="position()=last()">)<xsl:text/>
<!-- THX added to print out deprecated note  --> 
  <xsl:variable name="this" select="@name"/>
  <xsl:if test="../described.item[@item = $this]">
              &#160;&#160;&#160;--&#160;
    <xsl:value-of select="../described.item[@item=$this]/description"/>
  </xsl:if>


</xsl:if>

  

  <!-- THX added to print out deprecated note 
This probably wont work because notes need to be numbered, etc. Probably need a list at the end 
  <xsl:variable name="this" select="@name"/>
  <xsl:if test="../described.item[@item = $this]">
    <xsl:value-of select="@name"/>
    <xsl:apply-templates select="../described.item[@item=$this]/description"/>
  </xsl:if>
-->


  <!-- end THX added -->


</xsl:template>

<xsl:template match="constant">
  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      

  <xsl:variable 
    name="graphics" 
    select="''"/>

  <xsl:variable name="clause_number">
    <xsl:call-template name="express_clause_number">
      <xsl:with-param name="clause" select="'constant'"/>
      <xsl:with-param name="schema_name" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="position()=1">
    <xsl:variable name="clause_header">
      <xsl:choose>
        <xsl:when test="contains($schema_name,'_arm')">
          <xsl:choose>
            <xsl:when test="count(../constant)>1">
              <xsl:value-of select="concat($clause_number, ' ARM constant definitions')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat($clause_number, ' ARM constant definition')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="contains($schema_name,'_mim')">
          <xsl:choose>
            <xsl:when test="count(../constant)>1">
              <xsl:value-of select="concat($clause_number, ' MIM constant definitions')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat($clause_number, ' MIM constant definition')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>      
    </xsl:variable>

    <xsl:variable name="clause_intro">
      <xsl:choose>
        <xsl:when test="contains($schema_name,'_arm')">
          <xsl:choose>
            <xsl:when test="count(../constant)>1">
              This subclause specifies the ARM constants for 
              this module. The ARM constants and definitions are
              specified below.
            </xsl:when>
            <xsl:otherwise>
              This subclause specifies the ARM constant for 
              this module. The ARM constant and definition is
              specified below.
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="contains($schema_name,'_mim')">
          <xsl:choose>
            <xsl:when test="count(../constant)>1">
              This subclause specifies the MIM constants for 
              this module. The MIM constants and definitions are
              specified below.
            </xsl:when>
            <xsl:otherwise>
              This subclause specifies the MIM constant for 
              this module. The MIM constant and definition is
              specified below.
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>      
    </xsl:variable>

    <h2>
      <A NAME="constants">
        <xsl:value-of select="$clause_header"/>
      </A>
    </h2>
    <p><xsl:value-of select="$clause_intro"/></p>
  </xsl:if>

  <xsl:if test="position()=1">
    <p><u>EXPRESS specification:</u></p>
    <p>
    <!-- <blockquote> -->
      <code>
        *)<br/>CONSTANT<br/>(*
      </code>
    <!-- </blockquote> -->
  </p>
  </xsl:if>
  
  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>    
  <h2>
    <!-- only number section if more than one constant
    <xsl:choose>
      <xsl:when test="count(../constant) > 1 ">
        <a name="{$aname}">
          <xsl:value-of select="concat($clause_number,'.',position(),' ',@name)"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <a name="{$aname}">
          <xsl:value-of select="@name"/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
-->
     <a name="{$aname}">
          <xsl:value-of select="concat($clause_number,'.',position(),' ',@name)"/>
        </a>
   
  </h2>

  <!-- output description from express --> 
  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="./@name"/>
  </xsl:call-template> 
  <!-- output description from express -->
  <p>
    <xsl:choose>
      <xsl:when test="string-length(./description)>0">
        <xsl:apply-templates select="./description" mode="exp_description"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="external_description">
          <xsl:call-template name="check_external_description">
            <xsl:with-param name="schema" select="../@name"/>
            <xsl:with-param name="entity" select="./@name"/>
          </xsl:call-template>        
        </xsl:variable>
        <xsl:if test="$external_description='false'">
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message" 
              select="concat('Error e2: No description provided for ',$aname)"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </p>
  <!-- output any issue against constant   -->
  <xsl:call-template name="output_express_issue">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="./@name"/>
  </xsl:call-template> 


    <!-- output EXPRESS -->
    <p><u>EXPRESS specification:</u></p>
    <p>
    <!-- <blockquote> -->
      <code>
        *)<br/>
        &#160;&#160;<xsl:value-of select="@name"/> : 

      <!-- THX modified to support aggregates  -->
          <xsl:apply-templates select="./*" mode="code"/> 
          <xsl:apply-templates select="./*" mode="underlying"/>


          := 
<xsl:choose>
    
    <xsl:when test="./aggregate and contains(@expression,',')"><br/>
      &#160;&#160;&#160;<xsl:value-of select="concat(substring-before(@expression,','),',')"/>
      <xsl:call-template name="output_constant_expression">
        <xsl:with-param name="expression" select="substring-after(@expression,',')"/>
      </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@expression"/>;
      </xsl:otherwise>
  </xsl:choose>

      <br/>(*
      </code>
    <!-- </blockquote> -->
    </p>
    
    <xsl:if test="position()=last()">
      <br/>
      <p>
      <!-- <blockquote> -->
        <code>
          *)<br/>
          END_CONSTANT;
          <br/>(*
        </code>
      <!-- </blockquote> -->
    </p>
    </xsl:if>

</xsl:template>
<!-- THX added to support constants that are aggregates -->


<xsl:template name="output_constant_expression">
  <xsl:param name="expression"/>
  <!--  <xsl:value-of select="','" /> -->
    <br/>
    &#160;&#160;&#160;&#160;<xsl:value-of select="substring-before($expression,',')"/>
    
    <xsl:choose>
      <xsl:when test="contains($expression,',')">,
        <xsl:call-template name="output_constant_expression">
          <xsl:with-param name="expression" select="substring-after($expression,',')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$expression"/>;
      </xsl:otherwise>
    </xsl:choose>


</xsl:template>

<xsl:template match="type" >

  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      

  <xsl:variable 
    name="graphics" 
    select="''"/>

  <xsl:variable name="clause_number">
    <xsl:call-template name="express_clause_number">
      <xsl:with-param name="clause" select="'type'"/>
      <xsl:with-param name="schema_name" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="clause_header">
    <xsl:choose>
      <xsl:when test="contains($schema_name,'_arm')">
          <xsl:choose>
            <xsl:when test="count(../type)>1">
              <xsl:value-of select="concat($clause_number, ' ARM type definitions')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat($clause_number, ' ARM type definition')"/>
            </xsl:otherwise>
          </xsl:choose>
      </xsl:when>
      <xsl:when test="contains($schema_name,'_mim')">
          <xsl:choose>
            <xsl:when test="count(../type)>1">
              <xsl:value-of select="concat($clause_number, ' MIM type definitions')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat($clause_number, ' MIM type definition')"/>
            </xsl:otherwise>
          </xsl:choose>
      </xsl:when>
    </xsl:choose>      
  </xsl:variable>

  <xsl:variable name="clause_intro">
    <xsl:choose>
      <xsl:when test="contains($schema_name,'_arm')">
        <xsl:choose>
          <xsl:when test="count(../type)>1">
            This subclause specifies the ARM types
            for this application module. The ARM types and 
            definitions are specified below.         
          </xsl:when>
          <xsl:otherwise>
            This subclause specifies the ARM type
            for this application module. The ARM type and
            definition is specified below. 
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="contains($schema_name,'_mim')">
        <xsl:choose>
          <xsl:when test="count(../type)>1">
            This subclause specifies the MIM types
            for this application module. The MIM types and 
            definitions are specified below.         
          </xsl:when>
          <xsl:otherwise>
            This subclause specifies the MIM type
            for this application module. The MIM type and
            definition is specified below. 
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>      
  </xsl:variable>

  <xsl:if test="position()=1">
    <!-- first entity so output the intro -->
    <h2>
      <a name="types">
        <xsl:value-of select="$clause_header"/>
      </a>
    </h2>
    <p><xsl:value-of select="$clause_intro"/></p>
      <xsl:if test="..//constant[contains(@name,'deprecated_constructed')]">
        <xsl:call-template name="deprecated_types_note">
          <xsl:with-param name="schema_node" select=".."/>
        </xsl:call-template>
      </xsl:if>

  </xsl:if>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>   


  <!-- only number section if more than one type
  <xsl:choose>
    <xsl:when test="count(../type) > 1 ">
      <h2>
        <a name="{$aname}">
          <xsl:value-of select="concat($clause_number, '.', position(), ' ', @name)"/>
        </a>
        <xsl:apply-templates select="." mode="expressg_icon"/>
      </h2>      
    </xsl:when>
    <xsl:otherwise>
      <h2>
        <a name="{$aname}">
          <xsl:value-of select="@name"/>
        </a>
        <xsl:apply-templates select="." mode="expressg_icon"/>
      </h2>      
    </xsl:otherwise>
  </xsl:choose>
-->
      <h2>
        <a name="{$aname}">
          <xsl:value-of select="concat($clause_number, '.', position(), ' ', @name)"/>
        </a>
        <xsl:apply-templates select="." mode="expressg_icon"/>
      </h2>      

  <xsl:call-template name="check_type_name">
    <xsl:with-param name="type_name" select="@name"/>
  </xsl:call-template>


  <xsl:apply-templates select="./select" mode="description"/>

  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="./@name"/>
    <xsl:with-param name="type" select="./@name"/>
  </xsl:call-template> 
  <!-- output description from express -->


    <xsl:choose>
      <xsl:when test="string-length(./description)>0">
        <!-- only output <p> if description starts with text, otherwise
             assume that the description sarts with <p> -->
        <xsl:choose>          
          <xsl:when test="string-length(normalize-space(./description/text()))=0">
            <xsl:apply-templates select="./description" mode="exp_description"/>
          </xsl:when>
          <xsl:otherwise>
            <p>
              <xsl:apply-templates select="./description" mode="exp_description"/>
            </p>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <p>
          <!-- 
               disable error checking for selects as boiler plate
               should output text -->
          <xsl:if test="not(./select)">
            <xsl:variable name="external_description">
              <xsl:call-template name="check_external_description">
                <xsl:with-param name="schema" select="../@name"/>
                <xsl:with-param name="entity" select="@name"/>
                <xsl:with-param name="type" select="@name"/>
              </xsl:call-template>        
            </xsl:variable>
            <xsl:if test="$external_description='false'">
              <xsl:call-template name="error_message">
                <xsl:with-param 
                  name="message" 
                  select="concat('Error e3: No description provided for ',$aname)"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:if>
        </p>
      </xsl:otherwise>
    </xsl:choose>

  <!-- output any issue against type -->
  <xsl:call-template name="output_express_issue">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="./@name"/>
  </xsl:call-template> 

  <p><u>EXPRESS specification:</u></p>
  <p>
  <!-- <blockquote> -->
    <code>
      *)<br/>
      TYPE 
      <xsl:value-of select="@name" /> =
        <xsl:apply-templates select="./aggregate" mode="code"/>        
        <xsl:choose>
          <xsl:when test="./where">
            <xsl:apply-templates select="./*" mode="underlying"/>;<br/>
            <xsl:apply-templates select="./where" mode="code"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="./*" mode="underlying"/>;<br/>
          </xsl:otherwise>
        </xsl:choose>
        END_TYPE; <br/>
        (*
    </code>
  <!-- </blockquote> -->
</p>
  <xsl:apply-templates select="enumeration" mode="describe_enums"/>
  <xsl:call-template name="output_where_formal"/>
  <xsl:call-template name="output_where_informal"/>
</xsl:template>

<!-- empty template to prevent the description element being out put along
     with the code -->
<xsl:template match="description" mode="underlying"/>  

<xsl:template match="typename" mode="underlying">
  <xsl:call-template name="link_object">
    <xsl:with-param name="object_name" select="@name"/>
    <xsl:with-param name="object_used_in_schema_name" 
      select="../../../@name"/>
    <xsl:with-param name="clause" select="'section'"/>
  </xsl:call-template>
</xsl:template>


<xsl:template match="builtintype" mode="underlying">
  <xsl:choose>
    <xsl:when test="@type='GENERICENTITY'">GENERIC_ENTITY</xsl:when>
    <xsl:otherwise>  
      <xsl:value-of select="@type"/>
    </xsl:otherwise>
  </xsl:choose> 
  <xsl:variable name="type_label" select="@typelabel"/>
  <xsl:if test="$type_label">
    <xsl:value-of select="concat( ' : ', $type_label)"/>
  </xsl:if>
</xsl:template>


<xsl:template match="select" mode="underlying">
  <xsl:if test="@extensible='YES' or @extensible='yes'">
    EXTENSIBLE
  </xsl:if>

  <xsl:if test="@genericentity='YES' or @genericentity='yes'">
    GENERIC_ENTITY
  </xsl:if>

  SELECT<xsl:if test="@basedon">
    BASED_ON 
      <xsl:call-template name="link_object">
        <xsl:with-param name="object_name" select="@basedon"/>
        <xsl:with-param name="object_used_in_schema_name" 
          select="../../@name"/>
        <xsl:with-param name="clause" select="'section'"/>
      </xsl:call-template>  
  </xsl:if>
  <xsl:if test="@selectitems and 
                (string-length(@selectitems)!=0)">
    <xsl:if test="@basedon">
      WITH 
    </xsl:if><br/>
    &#160;&#160;&#160;(<xsl:call-template name="link_list">
    <xsl:with-param name="linebreak" select="'yes'"/>
    <xsl:with-param name="suffix" select="', '"/>
    <xsl:with-param name="prefix" select="'&#160;&#160;&#160;&#160;'"/>
    <xsl:with-param name="first_prefix" select="'no'"/>
    <xsl:with-param name="list" select="@selectitems"/>
    <xsl:with-param name="object_used_in_schema_name"
      select="../../@name"/>
    <xsl:with-param name="clause" select="'section'"/>
  </xsl:call-template>)</xsl:if></xsl:template>


<xsl:template match="enumeration" mode="underlying">
  <xsl:if test="@extensible='YES' or @extensible='yes'">
    EXTENSIBLE
  </xsl:if>
  ENUMERATION
  <xsl:if test="@basedon">
    BASED_ON 
    <xsl:call-template name="link_object">
      <xsl:with-param name="object_name" select="@basedon"/>
      <xsl:with-param name="object_used_in_schema_name" 
        select="../../@name"/>
      <xsl:with-param name="clause" select="'section'"/>
    </xsl:call-template>  
  </xsl:if>

  <xsl:if test="@items and (string-length(@items)!=0)">
    <xsl:choose>
      <xsl:when test="@basedon">
        WITH 
      </xsl:when>
      <xsl:otherwise>
        OF
      </xsl:otherwise>
    </xsl:choose>
    <br/>
    &#160;&#160; 
    <xsl:variable name="enum"
      select="concat('(',translate(normalize-space(@items),' ',','),')')"/>
    <xsl:call-template name="output_line_breaks">
      <xsl:with-param name="str" select="$enum"/>
      <xsl:with-param name="break_char" select="','"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="enumeration" mode="describe_enums">
  <xsl:if test="string-length(normalize-space(@items))>0">
    <p><u>Enumerated item definitions:</u></p>
    <xsl:call-template name="output_enums">
      <xsl:with-param name="str" select="normalize-space(@items)"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


<xsl:template name="output_enums">
  <xsl:param name="str"/>
  <xsl:variable name="break_char" select="' '"/>
  <xsl:choose>
    <xsl:when test="contains($str,$break_char)">
      <xsl:variable name="substr" 
        select="substring-before($str,$break_char)"/>
      <xsl:call-template name="output_enum_description">
        <xsl:with-param name="enum_value" select="$substr"/>
      </xsl:call-template> 
      
      <xsl:variable name="rest" select="substring-after($str,$break_char)"/>
      <xsl:call-template name="output_enums">
        <xsl:with-param name="str" select="$rest"/>
      </xsl:call-template> 
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="output_enum_description">
        <xsl:with-param name="enum_value" select="$str"/>
      </xsl:call-template> 
    </xsl:otherwise>        
  </xsl:choose>
</xsl:template>

<xsl:template name="output_enum_description">
  <xsl:param name="enum_value"/>
  <xsl:variable name="schema" select="../../@name"/>
  <xsl:variable name="enum_type" select="../@name"/>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema"/>
      <xsl:with-param name="section2" select="$enum_type"/>
      <xsl:with-param name="section3" select="$enum_value"/>
    </xsl:call-template>
  </xsl:variable>
  <!-- removed an now implemented in express_descriptions
       template match="p" mode="first_paragraph_attribute"
       template match="ext_description" mode="output_attr_descr   
  <p class="expressdescription">
    <b>
      <a name="{$aname}">
        <xsl:value-of select="$enum_value"/>:
      </a>
    </b> -->
    
    <!-- get description from external file -->
    <xsl:call-template name="output_external_description">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="entity" select="$enum_type"/>
      <xsl:with-param name="attribute" select="$enum_value"/>
      <xsl:with-param name="inline_aname" select="$aname"/>
      <xsl:with-param name="inline_name" select="$enum_value"/>
    </xsl:call-template>

    <xsl:variable name="external_description">
      <xsl:call-template name="check_external_description">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="entity" select="$enum_type"/>
      <xsl:with-param name="attribute" select="$enum_value"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$external_description='false'">
      <xsl:call-template name="error_message">
        <xsl:with-param 
          name="message" 
          select="concat('Error e15: No description provided for ',$enum_value)"/>
      </xsl:call-template>
    </xsl:if>
</xsl:template>


<xsl:template match="entity">
  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      
  <xsl:variable name="clause_number">
    <xsl:call-template name="express_clause_number">
      <xsl:with-param name="clause" select="'entity'"/>
      <xsl:with-param name="schema_name" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <!--  I decided to put them in-line with the code. These are left here as examples  
  <xsl:if test="count(.//explicit[contains(@name,'relating' )]/preceding-sibling::explicit[contains(@name,'related')]) > 0" >
   <xsl:call-template name="error_message">
        <xsl:with-param 
          name="message" 
          select="concat('Error a1:   ','&quot;relating&quot;','  attribute must precede ','&quot;related&quot;',' attribute')"/>
      </xsl:call-template>
    </xsl:if>

<xsl:if test="count(.//explicit[@name='name']/preceding-sibling::explicit[@name='description'])> 0">
   <xsl:call-template name="error_message">
        <xsl:with-param 
          name="message" 
          select="concat('Error',' a1:   ','&quot;name&quot;','  attribute must precede ','&quot;description&quot;',' attribute')"/>
      </xsl:call-template>
    </xsl:if>

<xsl:if test="count(.//explicit[@name='name']/preceding-sibling::explicit[contains(@name,'related')]) > 0">
   <xsl:call-template name="error_message">
        <xsl:with-param 
          name="message" 
          select="concat('Error a1:   ','&quot;description&quot;','  attribute must precede ','&quot;relating&quot;',' attribute')"/>
      </xsl:call-template>
    </xsl:if>
-->

  <xsl:if test="position()=1">
    <!-- first entity so output the intro -->    
    <xsl:variable name="clause_header">
      <xsl:choose>
        <xsl:when test="contains($schema_name,'_arm')">
          <xsl:choose>
            <xsl:when test="count(../entity)>1">
              <xsl:value-of select="concat($clause_number, ' ARM entity definitions')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat($clause_number, ' ARM entity definition')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="contains($schema_name,'_mim')">
          <xsl:choose>
            <xsl:when test="count(../entity)>1">
              <xsl:value-of select="concat($clause_number, ' MIM entity definitions')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat($clause_number, ' MIM entity definition')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>      
    </xsl:variable>

    <xsl:variable name="clause_intro">
      <xsl:choose>
        <xsl:when 
          test="substring($schema_name, string-length($schema_name)-3)='_arm'">
          <xsl:choose>
            <xsl:when test="count(../entity)>1">
              This subclause specifies the ARM entities for this
              module. Each ARM application entity is an atomic element that
              embodies a unique application concept and contains attributes
              specifying the data elements of the entity. The ARM
              entities and definitions are specified below. 
            </xsl:when>
            <xsl:otherwise>
              This subclause specifies the ARM entity for this
              module. The ARM entity is an atomic element that
              embodies a unique application concept and contains attributes
              specifying the data elements of the entity. The ARM
              entity and definition is specified below. 
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="contains($schema_name,'_mim')">
          <xsl:choose>
            <xsl:when test="count(../entity)>1">
              This subclause specifies the MIM entities for this
              module. The MIM entities and definitions are specified below. 
            </xsl:when>
            <xsl:otherwise>
              This subclause specifies the MIM entity for this
              module. The MIM entity and definition is specified below. 
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>      
    </xsl:variable>

    <h2>
      <a name="entities">
        <xsl:value-of select="$clause_header"/>
      </a>
    </h2>

    <p><xsl:value-of select="$clause_intro"/></p>
      <xsl:if test="..//constant[contains(@name,'deprecated_entity')]">
        <xsl:call-template name="deprecated_entities_note">
          <xsl:with-param name="schema_node" select=".."/>
        </xsl:call-template>
      </xsl:if>
  </xsl:if>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <h2>
    <!-- only number section if more than one entity
    <xsl:choose>
      <xsl:when test="count(../entity) > 1 ">
        <a name="{$aname}">
          <xsl:value-of select="concat($clause_number,'.',position(),' ',@name)"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <a name="{$aname}">
          <xsl:value-of select="@name"/>
        </a>        
      </xsl:otherwise>
    </xsl:choose>
-->
     <a name="{$aname}">
          <xsl:value-of select="concat($clause_number,'.',position(),' ',@name)"/>
        </a>
   
    <xsl:apply-templates select="." mode="expressg_icon"/>
    <xsl:if test="substring($schema_name, string-length($schema_name)-3)='_arm'">

      <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>
      <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
      <xsl:variable name="ae_map_aname"
        select="translate(concat('aeentity',@name),$UPPER,$LOWER)"/>

      <xsl:variable name="maphref" 
        select="concat('./5_mapping',$FILE_EXT,'#',$ae_map_aname)"/>
      <a href="{$maphref}">
        <img align="middle" border="0" 
          alt="Mapping table" src="../../../../images/mapping.gif"/>
      </a>
    </xsl:if>
  </h2>

  <xsl:choose>
    <xsl:when 
      test="substring($schema_name, string-length($schema_name)-3)= '_arm'">
      <xsl:call-template name="check_arm_entity_name">
        <xsl:with-param name="entity_name" select="@name"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="check_mim_entity_name">
        <xsl:with-param name="entity_name" select="@name"/>
      </xsl:call-template>        
    </xsl:otherwise>
  </xsl:choose>

  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="@name"/>
    <xsl:with-param name="supertypes" select="@supertypes"/>
  </xsl:call-template> 
  <!-- output description from express -->
  <xsl:choose>
      <xsl:when test="string-length(./description)>0">
        <!-- only output <p> if description starts with text, otherwise
             assume that the description sarts with <p> -->
        <xsl:choose>
          <xsl:when test="string-length(normalize-space(./description/text()))=0">
            <xsl:apply-templates select="./description" mode="exp_description"/>
          </xsl:when>
          <xsl:otherwise>
            <p>
              <xsl:apply-templates select="./description" mode="exp_description"/>
            </p>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <p>
          <xsl:variable name="external_description">
            <xsl:call-template name="check_external_description">
              <xsl:with-param name="schema" select="../@name"/>
              <xsl:with-param name="entity" select="@name"/>
            </xsl:call-template>        
          </xsl:variable>
          <xsl:if test="$external_description='false'">
            <xsl:call-template name="error_message">
              <xsl:with-param 
                name="message" 
                select="concat('Error e4: No description provided for ',@name)"/>
            </xsl:call-template>
          </xsl:if>
        </p>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="deprecated_entity_note">     
    <xsl:with-param name="type" select="."/>
    </xsl:call-template>

  <!-- output any issue against entity   -->
  <xsl:call-template name="output_express_issue">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="./@name"/>
  </xsl:call-template> 

  <p><u>EXPRESS specification:</u></p>
  <p>
  <!-- <blockquote> -->
    <code>
      *)<br/>
      ENTITY <xsl:value-of select="@name"/>
      <xsl:call-template name="abstract.entity"/>
      <xsl:call-template name="super.expression-code"/>
      <xsl:call-template name="supertypes-code"/><xsl:text>;</xsl:text>
      <br/>
      <xsl:apply-templates select="./explicit" mode="code"/>
      <xsl:apply-templates select="./derived" mode="code"/>
      <xsl:apply-templates select="./inverse" mode="code"/>
      <xsl:apply-templates select="./unique" mode="code"/>
      <xsl:apply-templates select="./where[@expression]" mode="code"/>
      END_ENTITY;<br/>(*
    </code>
  <!-- </blockquote> -->
  </p>
  <xsl:apply-templates select="./explicit" mode="description"/>    
  <xsl:apply-templates select="./derived" mode="description"/>    
  <xsl:apply-templates select="./inverse" mode="description"/>  
  <xsl:apply-templates select="./unique" mode="description"/>
  <xsl:call-template name="output_where_formal"/>
  <xsl:call-template name="output_where_informal"/>
</xsl:template>


<xsl:template name="abstract.entity">
  <xsl:if test="@abstract.entity='YES' or @abstract.entity='yes'">
    ABSTRACT</xsl:if>
</xsl:template>

<xsl:template name="super.expression-code">
  <!-- Always enclose the expression in parentheses -->
  <xsl:variable name="sup_expr"
    select="concat('(',@super.expression,')')"/>

  <xsl:choose>
    <xsl:when test="@abstract.supertype='YES' or @abstract.supertype='yes'">
      <br/>
      &#160;&#160;ABSTRACT SUPERTYPE
      <xsl:if test="@super.expression">
        OF&#160;<xsl:call-template name="link_super_expression_list">
          <xsl:with-param name="list" select="$sup_expr"/>
          <xsl:with-param name="object_used_in_schema_name" select="../@name"/>
          <xsl:with-param name="clause" select="'section'"/>
          <xsl:with-param name="indent" select="25"/>
        </xsl:call-template>

      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="@super.expression">
      <br/>
&#160;&#160;SUPERTYPE OF&#160;<xsl:call-template name="link_super_expression_list">
        <xsl:with-param name="list" select="$sup_expr"/>
        <xsl:with-param name="object_used_in_schema_name" select="../@name"/>
        <xsl:with-param name="clause" select="'section'"/>
        <xsl:with-param name="indent" select="16"/>
      </xsl:call-template>

    </xsl:if>      
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<xsl:template name="supertypes-code">
  <xsl:if test="@supertypes">
<br/>
    &#160;&#160;SUBTYPE OF (<xsl:call-template name="link_list">
      <xsl:with-param name="list" select="@supertypes"/>
        <xsl:with-param name="suffix" select="', '"/>
      <xsl:with-param name="object_used_in_schema_name" select="../@name"/>
      <xsl:with-param name="clause" select="'section'"/>
    </xsl:call-template><xsl:text>)</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="explicit" mode="code">
<!--  comment out express attribute tests for now. TT
  <xsl:if test="@name='id' or @name='identifier' or substring-after(@name,'_')='id'" >

    <xsl:if test="not(preceding-sibling::explicit[@name='id'] or preceding-sibling::explicit[substring-after(@name,'_')='id']) and preceding-sibling::explicit">
   <xsl:call-template name="error_message">
        <xsl:with-param 
          name="message" 
          select="concat('Error a1:   ','identifier',' must be first attribute')"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>

  <xsl:if test="contains(@name,'relating' ) and ./preceding-sibling::explicit[contains(@name,'related')]" >
   <xsl:call-template name="error_message">
        <xsl:with-param 
          name="message" 
          select="concat('Error a2:   ','&quot;relating&quot;','  attribute must precede ','&quot;related&quot;',' attribute')"/>
      </xsl:call-template>
    </xsl:if>

<xsl:if test="@name='name' and ./preceding-sibling::explicit[@name='description']">
   <xsl:call-template name="error_message">
        <xsl:with-param 
          name="message" 
          select="concat('Error',' a3:   ','&quot;name&quot;','  attribute must precede ','&quot;description&quot;',' attribute')"/>
      </xsl:call-template>
    </xsl:if>

<xsl:if test="@name='name' and ./preceding-sibling::explicit[@name!='id' and @name!='identifier' and substring-after(@name,'_')!='id']">
   <xsl:call-template name="error_message">
        <xsl:with-param 
          name="message" 
          select="concat('Error',' a4:   ','&quot;name&quot;','  attribute must precede any attribute except an identifier attribute')"/>
      </xsl:call-template>
    </xsl:if>



<xsl:if test="@name='description' and ./preceding-sibling::explicit[contains(@name,'related')]">
   <xsl:call-template name="error_message">
        <xsl:with-param 
          name="message" 
          select="concat('Error a5:   ','&quot;description&quot;','  attribute must precede ','&quot;relating&quot;',' attribute')"/>
      </xsl:call-template>
    </xsl:if>
-->


&#160;&#160;<xsl:apply-templates select="./redeclaration" mode="code"/>
  <xsl:value-of select="concat(@name, ' : ')"/>
  <xsl:if test="@optional='YES' or @optional='yes'">
    OPTIONAL 
  </xsl:if>
  <xsl:apply-templates select="./aggregate" mode="code"/>
  <xsl:apply-templates select="./*" mode="underlying"/>;<br/>
</xsl:template>

<xsl:template match="redeclaration" mode="code">SELF\<xsl:call-template name="link_object">
      <xsl:with-param name="object_name" select="@entity-ref"/>
      <xsl:with-param name="object_used_in_schema_name" 
        select="../../@name"/>
      <xsl:with-param name="clause" select="'section'"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="@old_name">
        <xsl:value-of select="concat('.',@old_name,' RENAMED ')"/>        
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>.</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="derived" mode="code">
  <xsl:if test="position()=1">DERIVE<br/>
  </xsl:if>
  &#160;&#160;<xsl:apply-templates select="./redeclaration" mode="code"/>
  <!-- need to clarify the XML for derive --> 
  <xsl:value-of select="concat(@name, ' : ')"/>
  <xsl:apply-templates select="./aggregate" mode="code"/>
  <xsl:apply-templates select="./*" mode="underlying"/>
  <xsl:value-of select="concat(' := ',@expression,';')"/><br/>
</xsl:template>

<xsl:template match="inverse" mode="code">
  <xsl:if test="position()=1">INVERSE<br/>
  </xsl:if>
  &#160;&#160;<xsl:apply-templates select="./redeclaration" mode="code"/>
  <xsl:value-of select="concat(@name, ' : ')"/>
  <xsl:apply-templates select="./inverse.aggregate" mode="code"/>
  <xsl:call-template name="link_object">
    <xsl:with-param name="object_name" select="@entity"/>
    <xsl:with-param name="object_used_in_schema_name" 
      select="../../@name"/>
    <xsl:with-param name="clause" select="'section'"/>
  </xsl:call-template>  
  <xsl:value-of select="concat(' FOR ', @attribute)"/>;<br/>
</xsl:template>

<xsl:template match="inverse.aggregate" mode="code">
  <xsl:choose>
    <xsl:when test="@lower">
      <xsl:value-of select="concat(@type, '[', @lower, ':', @upper, '] OF ')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat(@type, ' OF ')"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="unique" mode="code">
  <xsl:if test="position()=1">UNIQUE<br/>
  </xsl:if>
  &#160;&#160;<xsl:value-of select="concat(@label, ': ')"/>
  <xsl:apply-templates select="./unique.attribute" mode="code"/>
  <br/>
</xsl:template>


<xsl:template match="unique.attribute" mode="code">
  <xsl:variable name="suffix">
    <xsl:choose>
      <xsl:when test="position()!=last()">
        <xsl:value-of select="', '"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="';'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="@entity-ref">
      SELF\<xsl:call-template name="link_object">
      <xsl:with-param name="object_name" select="@entity-ref"/>
      <xsl:with-param name="object_used_in_schema_name" 
        select="../../@name"/>
      <xsl:with-param name="clause" select="'section'"/>
    </xsl:call-template><xsl:value-of select="concat('.',@attribute,$suffix)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat(@attribute,$suffix)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="aggregate" mode="code">
  <xsl:choose>
    <xsl:when test="@lower">
      <xsl:value-of select="concat(@type, '[', @lower, ':', @upper, '] OF ')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat(@type, ' OF ')"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="@optional='YES'">
    OPTIONAL
  </xsl:if>
  <xsl:if test="@unique='YES'">
    UNIQUE
  </xsl:if>
</xsl:template>

<xsl:template match="where" mode="code">
  <xsl:if test="position()=1">WHERE<br/></xsl:if> 
  &#160;&#160;<xsl:value-of select="concat(@label, ': ', @expression, ';')"/>
  <br/>
</xsl:template>

<xsl:template match="graphic.element" mode="code">
</xsl:template>


<xsl:template match="explicit" mode="description">
  <xsl:if test="position()=1">
    <p><u>Attribute definitions:</u></p>
  </xsl:if>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="../../@name"/>
      <xsl:with-param name="section2" select="../@name"/>
      <xsl:with-param name="section3" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- removed an now implemented in express_descriptions
       template match="p" mode="first_paragraph_attribute"
       template match="ext_description" mode="output_attr_descr
    <p class="expressdescription">
    <b>
      <a name="{$aname}">
        <xsl:value-of select="@name"/>:
      </a>
    </b> -->

  <!-- get description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../../@name"/>
    <xsl:with-param name="entity" select="../@name"/>
    <xsl:with-param name="attribute" select="@name"/>
    <xsl:with-param name="optional" select="@optional"/>
    <xsl:with-param name="inline_aname" select="$aname"/>
    <xsl:with-param name="inline_name" select="@name"/>
  </xsl:call-template>
  
  <!-- output description from express -->
  <xsl:choose>
    <xsl:when test="string-length(./description)>0">
      <xsl:apply-templates select="./description" mode="exp_description">
        <xsl:with-param name="inline_aname" select="$aname"/>
        <xsl:with-param name="inline_name" select="@name"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>      
      <xsl:variable name="external_description">
        <xsl:call-template name="check_external_description">
          <xsl:with-param name="schema" select="../../@name"/>
          <xsl:with-param name="entity" select="../@name"/>
          <xsl:with-param name="attribute" select="@name"/>
        </xsl:call-template>        
      </xsl:variable>
      <xsl:if test="$external_description='false'">
        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Error e5: No description provided for ',$aname)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>

  <!-- output any issue against attribute  -->
  <xsl:call-template name="output_express_issue">
    <xsl:with-param name="schema" select="../../@name"/>
    <xsl:with-param name="entity" select="../@name"/>
    <xsl:with-param name="attribute" select="@name"/>
  </xsl:call-template> 

</xsl:template>

<xsl:template match="derived" mode="description">
  <!-- check that this is the first derived attribute and that the
       there are no explicit attribute - if there were then Attribute
       definitions" would have already been output -->
  <xsl:if test="position()=1 and not(../explicit)">
    <p><u>Attribute definitions:</u></p>
  </xsl:if>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="../../@name"/>
      <xsl:with-param name="section2" select="../@name"/>
      <xsl:with-param name="section3" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- removed an now implemented in express_descriptions
       template match="p" mode="first_paragraph_attribute"
       template match="ext_description" mode="output_attr_descr
    <p class="expressdescription">
    <b>
      <a name="{$aname}">
        <xsl:value-of select="@name"/>:
      </a>
    </b> -->
  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../../@name"/>
    <xsl:with-param name="entity" select="../@name"/>
    <xsl:with-param name="attribute" select="@name"/>
    <xsl:with-param name="optional" select="@optional"/>
    <xsl:with-param name="inline_aname" select="$aname"/>
    <xsl:with-param name="inline_name" select="@name"/>
  </xsl:call-template>
  <!-- output description from express -->
    <xsl:choose>
      <xsl:when test="string-length(./description)>0">
        <xsl:apply-templates select="./description" mode="exp_description">
          <xsl:with-param name="inline_aname" select="$aname"/>
          <xsl:with-param name="inline_name" select="@name"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="external_description">
          <xsl:call-template name="check_external_description">
            <xsl:with-param name="schema" select="../../@name"/>
            <xsl:with-param name="entity" select="../@name"/>
            <xsl:with-param name="attribute" select="@name"/>
          </xsl:call-template>        
        </xsl:variable>
        <xsl:if test="$external_description='false'">
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message" 
              select="concat('Error e6: No description provided for ',$aname)"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  <!-- output any issues against derived attributes -->
  <xsl:call-template name="output_express_issue">
    <xsl:with-param name="schema" select="../../@name"/>
    <xsl:with-param name="entity" select="../@name"/>
    <xsl:with-param name="attribute" select="@name"/>
  </xsl:call-template>

</xsl:template>

<xsl:template match="inverse" mode="description">

  <xsl:if test="position()=1 and not(../explicit | ../derived)">
    <p><u>Attribute definitions:</u></p>
  </xsl:if>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="../../@name"/>
      <xsl:with-param name="section2" select="../@name"/>
      <xsl:with-param name="section3" select="@name"/>
    </xsl:call-template>
  </xsl:variable>
  
  <!-- removed an now implemented in express_descriptions
       template match="p" mode="first_paragraph_attribute"
       template match="ext_description" mode="output_attr_descr
    <p class="expressdescription">
    <b>
      <a name="{$aname}">
        <xsl:value-of select="@name"/>:
      </a>
    </b> -->

  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../../@name"/>
    <xsl:with-param name="entity" select="../@name"/>
    <xsl:with-param name="attribute" select="@name"/>
    <xsl:with-param name="inline_aname" select="$aname"/>
    <xsl:with-param name="inline_name" select="@name"/>
  </xsl:call-template>
  <!-- output description from express -->
    <xsl:choose>
      <xsl:when test="string-length(./description)>0">
        <xsl:apply-templates select="./description" mode="exp_description">
          <xsl:with-param name="inline_aname" select="$aname"/>
          <xsl:with-param name="inline_name" select="@name"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="external_description">
          <xsl:call-template name="check_external_description">
            <xsl:with-param name="schema" select="../../@name"/>
            <xsl:with-param name="entity" select="../@name"/>
            <xsl:with-param name="attribute" select="@name"/>
          </xsl:call-template>        
        </xsl:variable>
        <xsl:if test="$external_description='false'">
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message" 
              select="concat('Error e7: No description provided for ',$aname)"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  <!-- output any issues against inverse attribute -->
  <xsl:call-template name="output_express_issue">
    <xsl:with-param name="schema" select="../../@name"/>
    <xsl:with-param name="entity" select="../@name"/>
    <xsl:with-param name="attribute" select="@name"/>
  </xsl:call-template>

</xsl:template>



<xsl:template match="unique" mode="description">
  <xsl:if test="position()=1">
    <p><u>Formal propositions:</u></p>
  </xsl:if>  

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="../../@name"/>
      <xsl:with-param name="section2" select="../@name"/>
      <xsl:with-param name="section3" select="@label"/>
      <xsl:with-param name="section3separator" select="'.ur:'"/>
    </xsl:call-template>
  </xsl:variable>
  <!-- removed an now implemented in express_descriptions
       template match="p" mode="first_paragraph_attribute"
       template match="ext_description" mode="output_attr_descr
    <p class="expressdescription">
    <b>
      <a name="{$aname}">
        <xsl:value-of select="concat(@label,' : ')"/>
      </a>
    </b> -->
    <!-- output description from external file -->
    <xsl:call-template name="output_external_description">
      <xsl:with-param name="schema" select="../../@name"/>
      <xsl:with-param name="entity" select="../@name"/>
      <xsl:with-param name="unique" select="./@label"/>
      <xsl:with-param name="inline_aname" select="$aname"/>
      <xsl:with-param name="inline_name" select="@label"/>
    </xsl:call-template>
    <!-- output description from express -->
    
    <xsl:choose>
      <xsl:when test="string-length(./description)>0">
        <xsl:apply-templates select="./description" mode="exp_description">
          <xsl:with-param name="inline_aname" select="$aname"/>
          <xsl:with-param name="inline_name" select="@label"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="external_description">
          <xsl:call-template name="check_external_description">
            <xsl:with-param name="schema" select="../../@name"/>
            <xsl:with-param name="entity" select="../@name"/>
            <xsl:with-param name="unique" select="./@label"/>
          </xsl:call-template>        
        </xsl:variable>
        <xsl:if test="$external_description='false'">
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message" 
              select="concat('Error e8: No description provided for ',$aname)"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>

    <!-- output issues against unique rule -->
    <xsl:call-template name="output_express_issue">
      <xsl:with-param name="schema" select="../../@name"/>
      <xsl:with-param name="entity" select="../@name"/>
      <xsl:with-param name="unique" select="./@label"/>
    </xsl:call-template>

</xsl:template>

<xsl:template name="output_where_formal">
  <xsl:if test="./where[@expression] and not(./unique)">
    <p><u>Formal propositions:</u></p>
  </xsl:if>
  <xsl:apply-templates select="./where[@expression]" mode="description"/>
</xsl:template>

<xsl:template name="output_where_informal">
  <xsl:if test="./where[not(@expression)]">
    <p><u>Informal propositions:</u></p>
  </xsl:if>
  <xsl:apply-templates select="./where[not(@expression)]" mode="description"/>
</xsl:template>


<xsl:template match="where" mode="description">

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="../../@name"/>
      <xsl:with-param name="section2" select="../@name"/>
      <xsl:with-param name="section3" select="@label"/>
      <xsl:with-param name="section3separator" select="'.wr:'"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- removed an now implemented in express_descriptions
       template match="p" mode="first_paragraph_attribute"
       template match="ext_description" mode="output_attr_descr
    <p class="expressdescription">
    <b>
      <a name="{$aname}">
        <xsl:value-of select="concat(@label,' : ')"/>
      </a>
    </b> -->

  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../../@name"/>
    <xsl:with-param name="entity" select="../@name"/>
    <xsl:with-param name="where" select="@label"/>
    <xsl:with-param name="inline_aname" select="$aname"/>
    <xsl:with-param name="inline_name" select="@label"/>
  </xsl:call-template>
  <!-- output description from express -->

    <xsl:choose>
      <xsl:when test="string-length(./description)>0">
        <xsl:apply-templates select="./description" mode="exp_description">
          <xsl:with-param name="inline_aname" select="$aname"/>
          <xsl:with-param name="inline_name" select="@label"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="external_description">
          <xsl:call-template name="check_external_description">
            <xsl:with-param name="schema" select="../../@name"/>
            <xsl:with-param name="entity" select="../@name"/>
            <xsl:with-param name="where" select="@label"/>
          </xsl:call-template>        
        </xsl:variable>
        <xsl:if test="$external_description='false'">
          <xsl:call-template name="error_message">
            <xsl:with-param 
              name="message" 
              select="concat('Error e9: No description provided for ',$aname)"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>

  <!-- output issue against entity -->
  <xsl:call-template name="output_express_issue">
    <xsl:with-param name="schema" select="../../@name"/>
    <xsl:with-param name="entity" select="../@name"/>
    <xsl:with-param name="where" select="@label"/>
  </xsl:call-template>

</xsl:template>


<xsl:template match="subtype.constraint">
  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      
  <xsl:variable name="clause_number">
    <xsl:call-template name="express_clause_number">
      <xsl:with-param name="clause" select="'subtype.constraint'"/>
      <xsl:with-param name="schema_name" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="position()=1">
    <!-- first entity so output the intro -->
    <xsl:variable name="clause_header">
      <xsl:choose>
        <xsl:when test="contains($schema_name,'_arm')">
          <xsl:choose>
            <xsl:when test="count(../subtype.constraint)>1">
              <xsl:value-of select="concat($clause_number, ' ARM subtype constraint definitions')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat($clause_number, ' ARM subtype constraint definition')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="contains($schema_name,'_mim')">
          <xsl:choose>
            <xsl:when test="count(../subtype.constraint)>1">
              <xsl:value-of select="concat($clause_number, ' MIM subtype constraint definitions')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat($clause_number, ' MIM subtype constraint definition')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>      
    </xsl:variable>

    <xsl:variable name="clause_intro">
      <xsl:choose>
        <xsl:when test="contains($schema_name,'_arm')">
          <xsl:choose>
            <xsl:when test="count(../subtype.constraint)>1">
              This subclause specifies the ARM
              subtype constraints for 
              this module. Each subtype constraint places constraints on the
              possible super-type / subtype instantiations.
              The ARM subtype constraints and definitions are
              specified below.
            </xsl:when>
            <xsl:otherwise>
              This subclause specifies the ARM subtype constraint for
              this module. The subtype constraint places a constraint on the
              possible super-type / subtype instantiations.
              The ARM subtype constraint and definition is
              specified below.
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="contains($schema_name,'_mim')">
          <xsl:choose>
            <xsl:when test="count(../subtype.constraint)>1">
              This subclause specifies the MIM
              subtype constraints for 
              this module. Each subtype constraint places constraints on the
              possible super-type / subtype instantiations.
              The MIM subtype constraints and definitions are
              specified below.
            </xsl:when>
            <xsl:otherwise>
              This subclause specifies the MIM subtype constraint for
              this module. The subtype constraint places a constraint on the
              possible super-type / subtype instantiations.
              The MIM subtype constraint and definition is
              specified below.
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>      
    </xsl:variable>

    <h2>
      <a name="subtype_constraints">
        <xsl:value-of select="$clause_header"/>
      </a>
    </h2>
    <p><xsl:value-of select="$clause_intro"/></p>
  </xsl:if>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <h2>
  <!-- only number section if more than one sub type constraint
  <xsl:choose>
    <xsl:when test="count(../subtype.constraint) > 1 ">      
      <A NAME="{$aname}">
        <xsl:value-of select="concat($clause_number,'.',position(),' ',@name)"/>
      </A>
    </xsl:when>
    <xsl:otherwise>
      <A NAME="{$aname}">
        <xsl:value-of select="@name"/>
      </A>
    </xsl:otherwise>
  </xsl:choose>
-->
      <A NAME="{$aname}">
        <xsl:value-of select="concat($clause_number,'.',position(),' ',@name)"/>
      </A>

  <xsl:apply-templates select="." mode="expressg_icon"/>

    <xsl:if test="substring($schema_name, string-length($schema_name)-3)='_arm'">
      <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz_'"/>
      <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
      <xsl:variable name="sc_map_aname"
        select="translate(concat('scconstraint',@name),$UPPER,$LOWER)"/>

      <xsl:variable name="maphref" 
        select="concat('./5_mapping',$FILE_EXT,'#',$sc_map_aname)"/>
      <a href="{$maphref}"><img align="middle" border="0" 
          alt="Mapping table" src="../../../../images/mapping.gif"/></a>
    </xsl:if>
  </h2>

  <xsl:apply-templates select="." mode="description"/>

  <!-- output express issues against supertype constraint -->
  <xsl:call-template name="output_express_issue">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="@name"/>
  </xsl:call-template>


  <!-- output the EXPRESS -->
  <p><u>EXPRESS specification:</u></p>
  
  <p>
    <code>
  *)<br/>
  <A NAME="{$aname}">SUBTYPE_CONSTRAINT <xsl:value-of select="@name"/></A>
  <xsl:text> FOR </xsl:text>
  <xsl:call-template name="link_object">
    <xsl:with-param name="object_name" select="@entity"/>
    <xsl:with-param name="object_used_in_schema_name" 
      select="../@name"/>
    <xsl:with-param name="clause" select="'section'"/>
  </xsl:call-template>;<br/>

  <xsl:if test="@abstract.supertype='YES' or @abstract.supertype='yes'">
      &#160;&#160;ABSTRACT SUPERTYPE;<br/>
  </xsl:if>

  <xsl:if test="@totalover and 
                (string-length(@totalover)!=0)">
    &#160;&#160;TOTAL_OVER&#160;(<xsl:call-template name="link_list">
    <xsl:with-param name="list" select="@totalover"/>
    <xsl:with-param name="linebreak" select="'yes'"/>
    <xsl:with-param name="prefix" select="'&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;'"/>
    <xsl:with-param name="first_prefix" select="'no'"/>
    <xsl:with-param name="suffix" select="', '"/>
    <xsl:with-param name="object_used_in_schema_name" select="../@name"/>
    <xsl:with-param name="clause" select="'section'"/>
  </xsl:call-template>);<br/>
  </xsl:if>

  
  <xsl:variable name="sup_expr" select="@super.expression"/>
  <xsl:if test="@super.expression">
    &#160;&#160;<xsl:call-template name="link_super_expression_list">
        <xsl:with-param name="list" select="$sup_expr"/>
        <xsl:with-param name="object_used_in_schema_name" select="../@name"/>
        <xsl:with-param name="clause" select="'section'"/>
        <xsl:with-param name="indent" select="3"/>
      </xsl:call-template>;<br/>
    </xsl:if>      
  END_SUBTYPE_CONSTRAINT;<br/>(*
  </code></p>
</xsl:template>

<xsl:template match="subtype.constraint" mode="description">
  <!--  output the boilerplate select descriptions for selects. -->
  <xsl:variable name="description_file"
    select="/express/@description.file"/>
  <xsl:variable name="sc_description">
    <xsl:choose>
      <xsl:when test="$description_file">
        <xsl:value-of select="document($description_file)/ext_descriptions/@describe.subtype_constraints"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'NO'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="one_of"
    select="substring-before(normalize-space(@super.expression),'(')"/>
  <xsl:variable name="sc_list" 
    select="normalize-space( translate( substring-after(@super.expression,'('),',)',' '))"/>

  <xsl:if test="$sc_description='YES'">
    <xsl:choose>
      <!-- an ABSTRACT ONEOF -->
      <xsl:when test="(./@abstract.supertype='YES') and ($one_of = 'ONEOF')">
        <p>
          The
          <b>
            <xsl:value-of select="@name"/>
          </b> 
          constraint specifies that 
          <b>
            <xsl:call-template name="link_object">
              <xsl:with-param name="object_name" select="@entity"/>
              <xsl:with-param name="object_used_in_schema_name" 
                select="../@name"/>
              <xsl:with-param name="clause" select="'section'"/>
            </xsl:call-template>
          </b>
          is an abstract supertype and that instances of subtypes of
          <b>
            <xsl:call-template name="link_object">
              <xsl:with-param name="object_name" select="@entity"/>
              <xsl:with-param name="object_used_in_schema_name" 
                select="../@name"/>
              <xsl:with-param name="clause" select="'section'"/>
            </xsl:call-template>
          </b>
          shall not be simultaneously of type 
          <xsl:call-template name="link_list">
            <xsl:with-param name="list" select="$sc_list"/>
            <xsl:with-param name="suffix" select="', '"/>
            <xsl:with-param name="object_used_in_schema_name" select="../@name"/>
            <xsl:with-param name="clause" select="'section'"/>
            <xsl:with-param name="and_for_last_pair" select="'yes'"/>
          </xsl:call-template>.
        </p>
      </xsl:when>
      
      <xsl:when test="($one_of = 'ONEOF')">
        <p>
          The
          <b>
            <xsl:value-of select="@name"/>
          </b> 
          constraint specifies that instances of subtypes of
          <b>
            <xsl:call-template name="link_object">
              <xsl:with-param name="object_name" select="@entity"/>
              <xsl:with-param name="object_used_in_schema_name" 
                select="../@name"/>
              <xsl:with-param name="clause" select="'section'"/>
            </xsl:call-template>
          </b>
          shall not be simultaneously of type 
          <xsl:call-template name="link_list">
            <xsl:with-param name="list" select="$sc_list"/>
            <xsl:with-param name="suffix" select="', '"/>
            <xsl:with-param name="object_used_in_schema_name" select="../@name"/>
            <xsl:with-param name="clause" select="'section'"/>
            <xsl:with-param name="and_for_last_pair" select="'yes'"/>
          </xsl:call-template>.
        </p>
      </xsl:when>

      <!-- an ABSTRACT EXPRESSION -->
      <xsl:when test="(./@abstract.supertype='YES') and ./@super.expression">
        <p>
          The
          <b>
            <xsl:value-of select="@name"/>
          </b> 
          constraint specifies that 
          <b>
            <xsl:call-template name="link_object">
              <xsl:with-param name="object_name" select="@entity"/>
              <xsl:with-param name="object_used_in_schema_name" 
                select="../@name"/>
              <xsl:with-param name="clause" select="'section'"/>
            </xsl:call-template>
          </b>
          is an abstract supertype and that defines 
          a constraint that applies to instances of subtypes of
          <b>
            <xsl:call-template name="link_object">
              <xsl:with-param name="object_name" select="@entity"/>
              <xsl:with-param name="object_used_in_schema_name" 
                select="../@name"/>
              <xsl:with-param name="clause" select="'section'"/>
            </xsl:call-template>
          </b>.
        </p>
      </xsl:when>

      <!-- an subtype expression -->
      <xsl:when test="./@super.expression">
        <p>
          The
          <b>
            <xsl:value-of select="@name"/>
          </b> 
          constraint specifies a constraint that applies to instances of subtypes of
          <b>
            <xsl:call-template name="link_object">
              <xsl:with-param name="object_name" select="@entity"/>
              <xsl:with-param name="object_used_in_schema_name" 
                select="../@name"/>
              <xsl:with-param name="clause" select="'section'"/>
            </xsl:call-template>
          </b>.
        </p>
      </xsl:when>

      <!-- an ABSTRACT supertype -->
      <xsl:when test="./@abstract.supertype='YES'">
          The
          <b>
            <xsl:value-of select="@name"/>
          </b> 
          constraint specifies that 
          <b>
            <xsl:call-template name="link_object">
              <xsl:with-param name="object_name" select="@entity"/>
              <xsl:with-param name="object_used_in_schema_name" 
                select="../@name"/>
              <xsl:with-param name="clause" select="'section'"/>
            </xsl:call-template>
          </b>
          is an abstract supertype.
      </xsl:when>
    </xsl:choose>

  </xsl:if>

  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="@name"/>
    <xsl:with-param name="type" select="@name"/>
   </xsl:call-template>
  <!-- output description from express -->
  <xsl:choose>
    <xsl:when test="string-length(./description)>0">
      <xsl:apply-templates select="./description" mode="exp_description"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="external_description">
        <xsl:call-template name="check_external_description">
          <xsl:with-param name="schema" select="../@name"/>
          <xsl:with-param name="entity" select="@name"/>
        </xsl:call-template>        
      </xsl:variable>
      <xsl:if test="$external_description='false' and $sc_description!='YES'">
        <xsl:variable name="aname">
          <xsl:call-template name="express_a_name">
            <xsl:with-param name="section1" select="../@name"/>
            <xsl:with-param name="section2" select="@name"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Error e10: No description provided for ',$aname)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="function">
  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      
  <xsl:variable name="clause_number">
    <xsl:call-template name="express_clause_number">
      <xsl:with-param name="clause" select="'function'"/>
      <xsl:with-param name="schema_name" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="position()=1">
    <!-- first entity so output the intro -->
    <xsl:variable name="clause_header">
      <xsl:choose>
        <xsl:when test="contains($schema_name,'_arm')">
          <xsl:choose>
            <xsl:when test="count(../function)>1">
              <xsl:value-of select="concat($clause_number, ' ARM function definitions')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat($clause_number, ' ARM function definition')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="contains($schema_name,'_mim')">
          <xsl:choose>
            <xsl:when test="count(../function)>1">
              <xsl:value-of select="concat($clause_number, ' MIM function definitions')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat($clause_number, ' MIM function definition')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>      
    </xsl:variable>

    <xsl:variable name="clause_intro">
      <xsl:choose>
        <xsl:when test="contains($schema_name,'_arm')">
          <xsl:choose>
            <xsl:when test="count(../function)>1">
              This subclause specifies the ARM functions for 
              this module. The ARM functions and definitions are
              specified below.
            </xsl:when>
            <xsl:otherwise>
              This subclause specifies the ARM function for 
              this module. The ARM function and definition is
              specified below.
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="contains($schema_name,'_mim')">
          <xsl:choose>
            <xsl:when test="count(../function)>1">
              This subclause specifies the MIM functions for 
              this module. The MIM functions and definitions are
              specified below.
            </xsl:when>
            <xsl:otherwise>
              This subclause specifies the MIM function for 
              this module. The MIM function and definition is
              specified below.
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>      
    </xsl:variable>

    <h2>
      <a name="functions">
        <xsl:value-of select="$clause_header"/>
      </a>
    </h2>
    <p><xsl:value-of select="$clause_intro"/></p>
  </xsl:if>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>
             
  <h2>
    <A NAME="{$aname}">
      <xsl:value-of select="concat($clause_number,'.',position(),' ',@name)"/>
    </A>
  </h2>
  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="@name"/>
    <xsl:with-param name="type" select="@name"/>
    <xsl:with-param name="function" select="@name"/>
  </xsl:call-template>
  <!-- output description from express -->
  <xsl:choose>
    <xsl:when test="string-length(./description)>0">
      <xsl:apply-templates select="./description" mode="exp_description"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="external_description">
        <xsl:call-template name="check_external_description">
          <xsl:with-param name="schema" select="../@name"/>
          <xsl:with-param name="entity" select="@name"/>
        </xsl:call-template>        
      </xsl:variable>
      <xsl:if test="$external_description='false'">
        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Error e11: No description provided for ',$aname)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>

  <!-- output issues against function -->
  <xsl:call-template name="output_express_issue">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="@name"/>
  </xsl:call-template>

  <!-- output the EXPRESS -->
  <p><u>EXPRESS specification:</u></p>

  <!-- <blockquote> -->
    <code>
      *)<br/>
      FUNCTION <xsl:value-of select="@name"/>
      <xsl:apply-templates select="./parameter" mode="code"/><xsl:text> : </xsl:text>
      <xsl:apply-templates select="./aggregate" mode="code"/>
      <xsl:apply-templates select="./*" mode="underlying"/>;
    </code>
      <xsl:apply-templates select="./algorithm" mode="code"/>
      <code>
      END_FUNCTION;
      <br/>(*
    </code>
  <!-- </blockquote> -->

  <xsl:apply-templates select="./parameter" mode="description"/>
</xsl:template>

<xsl:template match="procedure">  
  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      
  <xsl:variable name="clause_number">
    <xsl:call-template name="express_clause_number">
      <xsl:with-param name="clause" select="'procedure'"/>
      <xsl:with-param name="schema_name" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="position()=1">
    <!-- first entity so output the intro -->
    <xsl:variable name="clause_header">
      <xsl:choose>
        <xsl:when test="contains($schema_name,'_arm')">
          <xsl:choose>
            <xsl:when test="count(../procedure)>1">
              <xsl:value-of select="concat($clause_number, ' ARM procedure definitions')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat($clause_number, ' ARM procedure definition')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="contains($schema_name,'_mim')">
          <xsl:choose>
            <xsl:when test="count(../procedure)>1">
              <xsl:value-of select="concat($clause_number, ' MIM procedure definitions')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat($clause_number, ' MIM procedure definition')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>      
    </xsl:variable>

    <xsl:variable name="clause_intro">
      <xsl:choose>
        <xsl:when test="contains($schema_name,'_arm')">
          <xsl:choose>
            <xsl:when test="count(../procedure)>1">
              This subclause specifies the ARM procedures for 
              this module. The ARM procedures and definitions are
              specified below.
            </xsl:when>
            <xsl:otherwise>
              This subclause specifies the ARM procedure for 
              this module. The ARM procedure and definition is
              specified below.
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="contains($schema_name,'_mim')">
          <xsl:choose>
            <xsl:when test="count(../procedure)>1">
              This subclause specifies the MIM procedures for 
              this module. The MIM procedures and definitions are
              specified below.
            </xsl:when>
            <xsl:otherwise>
              This subclause specifies the MIM procedure for 
              this module. The MIM procedure and definition is
              specified below.
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>      
    </xsl:variable>

    <h2>
      <a name="procedures">
        <xsl:value-of 
          select="$clause_header"/>
      </a>
      </h2> 
      <p><xsl:value-of select="$clause_intro"/></p>
  </xsl:if>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <h2>
    <A NAME="{$aname}">
      <xsl:value-of select="concat($clause_number,'.',position(),' ',@name)"/>
    </A>
  </h2>
  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="@name"/>
    <xsl:with-param name="type" select="@name"/>
    </xsl:call-template>
  <!-- output description from express -->
  <xsl:choose>
    <xsl:when test="string-length(./description)>0">
      <xsl:apply-templates select="./description" mode="exp_description"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="external_description">
        <xsl:call-template name="check_external_description">
          <xsl:with-param name="schema" select="../@name"/>
          <xsl:with-param name="entity" select="@name"/>
        </xsl:call-template>        
      </xsl:variable>
      <xsl:if test="$external_description='false'">
        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Error e12: No description provided for ',$aname)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
  <!-- output any issue against procedure -->
  <xsl:call-template name="output_express_issue">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="./@name"/>
  </xsl:call-template> 
  
  <!-- output the EXPRESS -->
  <p><u>EXPRESS specification:</u></p>
  <!-- <blockquote> -->
    <code>
      *)<br/>     
      PROCEDURE <xsl:value-of select="@name"/>
    <xsl:apply-templates select="./parameter" mode="code"/><xsl:text> : </xsl:text>
    <xsl:apply-templates select="./aggregate" mode="code"/>
    <xsl:apply-templates select="./*" mode="underlying"/>;
  </code>
    <xsl:apply-templates select="./algorithm" mode="code"/><br/>
    <code>
    END_PROCEDURE;
    <br/>(*
    </code>
  <!-- </blockquote> -->
  <xsl:apply-templates select="./explicit" mode="description"/>
</xsl:template>

<!-- empty template to prevent the algorithm element being out put along
     with the code -->
<xsl:template match="parameter" mode="underlying"/>


<xsl:template match="parameter" mode="code">
  <xsl:if test="position()=1">&#160;(</xsl:if>
  <xsl:value-of select="@name"/><xsl:text> : </xsl:text>
  <xsl:apply-templates select="./aggregate" mode="code"/>
  <xsl:apply-templates select="./*" mode="underlying"/>
  <xsl:choose>
    <xsl:when test="position()!=last()">
      <xsl:text>; </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>)</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="parameter" mode="description">
  <xsl:if test="position()=1">
    <p><u>Argument definitions:</u></p>
  </xsl:if>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="../../@name"/>
      <xsl:with-param name="section2" select="../@name"/>
      <xsl:with-param name="section3" select="@name"/>
    </xsl:call-template>
  </xsl:variable>
  <!-- removed an now implemented in express_descriptions
       template match="p" mode="first_paragraph_attribute"
       template match="ext_description" mode="output_attr_descr
  <p class="expressdescription">
    <b>
      <a name="{$aname}">
        <xsl:value-of select="@name"/>:
      </a>
    </b> -->
  <!-- get description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../../@name"/>
    <xsl:with-param name="entity" select="../@name"/>
    <xsl:with-param name="attribute" select="@name"/>
    <xsl:with-param name="inline_aname" select="$aname"/>
    <xsl:with-param name="inline_name" select="@name"/>
  </xsl:call-template>
  
  <!-- output description from express -->
  <xsl:choose>
    <xsl:when test="string-length(./description)>0">
      <xsl:apply-templates select="./description" mode="exp_description">
        <xsl:with-param name="inline_aname" select="$aname"/>
        <xsl:with-param name="inline_name" select="@name"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="external_description">
        <xsl:call-template name="check_external_description">
          <xsl:with-param name="schema" select="../../@name"/>
          <xsl:with-param name="entity" select="../@name"/>
          <xsl:with-param name="attribute" select="@name"/>
        </xsl:call-template>        
      </xsl:variable>
      <xsl:if test="$external_description='false'">
        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Error e13: No description provided for ',$aname)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>

  <!-- output issues against parameter -->
  <xsl:call-template name="output_express_issue">
    <xsl:with-param name="schema" select="../../@name"/>
    <xsl:with-param name="entity" select="../@name"/>
    <xsl:with-param name="attribute" select="@name"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="algorithm" mode="code">
  <!-- empty algorithms are sometimes output so ignore -->
  <xsl:if test="string-length(normalize-space(.))>0">
    <pre>
      <xsl:value-of select="."/>
    </pre>
  </xsl:if>
</xsl:template>

<!-- empty template to prevent the algorithm element being out put along
     with the code -->
<xsl:template match="algorithm" mode="underlying"/>


<xsl:template match="rule">  
  <xsl:variable 
    name="schema_name" 
    select="../@name"/>      
  <xsl:variable name="clause_number">
    <xsl:call-template name="express_clause_number">
      <xsl:with-param name="clause" select="'rule'"/>
      <xsl:with-param name="schema_name" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="position()=1">
    <!-- first entity so output the intro -->
    <xsl:variable name="clause_header">
      <xsl:choose>
        <xsl:when test="contains($schema_name,'_arm')">
          <xsl:choose>
            <xsl:when test="count(../rule)>1">
              <xsl:value-of select="concat($clause_number, ' ARM rule definitions')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat($clause_number, ' ARM rule definition')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="contains($schema_name,'_mim')">
          <xsl:choose>
            <xsl:when test="count(../rule)>1">
              <xsl:value-of select="concat($clause_number, ' MIM rule definitions')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat($clause_number, ' MIM rule definition')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>      
    </xsl:variable>

    <xsl:variable name="clause_intro">
      <xsl:choose>
        <xsl:when test="contains($schema_name,'_arm')">
          <xsl:choose>
            <xsl:when test="count(../rule)>1">
              This subclause specifies the ARM rules for 
              this module. The ARM rules and definitions are
              specified below.
            </xsl:when>
            <xsl:otherwise>
              This subclause specifies the ARM rule for 
              this module. The ARM rule and definition is
              specified below.
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="contains($schema_name,'_mim')">
          <xsl:choose>
            <xsl:when test="count(../rule)>1">
              This subclause specifies the MIM rules for 
              this module. The MIM rules and definitions are
              specified below.
            </xsl:when>
            <xsl:otherwise>
              This subclause specifies the MIM rule for 
              this module. The MIM rule and definition is
              specified below.
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>      
    </xsl:variable>
    <h2>
      <a name="rules">
        <xsl:value-of select="$clause_header"/>
      </a>
    </h2>
    <p><xsl:value-of select="$clause_intro"/></p>
  </xsl:if>

  <xsl:variable name="aname">
    <xsl:call-template name="express_a_name">
      <xsl:with-param name="section1" select="$schema_name"/>
      <xsl:with-param name="section2" select="@name"/>
    </xsl:call-template>
  </xsl:variable>

  <h2>
    <A NAME="{$aname}">
      <xsl:value-of select="concat($clause_number,'.',position(),' ',@name)"/>
    </A>
  </h2>

  <!-- output description from external file -->
  <xsl:call-template name="output_external_description">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="@name"/>
    <xsl:with-param name="type" select="@name"/>
    <xsl:with-param name="rule" select="@name"/>
   </xsl:call-template>
  <!-- output description from express -->
  <xsl:choose>
    <xsl:when test="string-length(./description)>0">
      <xsl:apply-templates select="./description" mode="exp_description"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="external_description">
        <xsl:call-template name="check_external_description">
          <xsl:with-param name="schema" select="../@name"/>
          <xsl:with-param name="entity" select="@name"/>
        </xsl:call-template>        
      </xsl:variable>
      <xsl:if test="$external_description='false'">
        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Error e14: No description provided for ',$aname)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>

  <!-- output any issue against algorithm -->
  <xsl:call-template name="output_express_issue">
    <xsl:with-param name="schema" select="../@name"/>
    <xsl:with-param name="entity" select="./@name"/>
  </xsl:call-template> 
  
  <!-- output the EXPRESS -->
  <p><u>EXPRESS specification:</u></p>
  <!-- <blockquote> -->
    <code>
      *)<br/>
      RULE <xsl:value-of select="@name"/> FOR
    <br/>
        
        (<xsl:call-template name="process_FOR_arguments">
            <xsl:with-param name="args" select="@appliesto"/>
        </xsl:call-template>);<br/>
  </code>
    <xsl:apply-templates select="./algorithm" mode="code"/>
    <code>
    <xsl:apply-templates select="./where" mode="code"/>
      END_RULE;
    <br/>(*
    </code>
  <!-- </blockquote> -->

  <p><u>Argument definitions:</u></p>
  <xsl:call-template name="process_rule_arguments">
    <xsl:with-param name="args" select="@appliesto"/>
  </xsl:call-template>

  <xsl:call-template name="output_where_formal"/>
  <xsl:call-template name="output_where_informal"/>
</xsl:template>
    
    <!-- mikeward added -->
    <xsl:template name="process_FOR_arguments">
        <xsl:param name="args"/>
        <xsl:choose>
            <!-- single argument -->
            <xsl:when test="not(contains($args,' '))">
                <xsl:call-template name="output_FOR_argument">
                    <xsl:with-param name="arg" select="$args"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="arg1" select="substring-before($args,' ')"/>
                <xsl:variable name="rest" select="substring-after($args,' ')"/>
                <xsl:call-template name="output_FOR_argument">
                    <xsl:with-param name="arg" select="$arg1"/>
                </xsl:call-template>
                <xsl:if test="$rest">
                    <xsl:value-of select="string(', ')"/>
                    <xsl:call-template name="process_FOR_arguments">
                        <xsl:with-param name="args" select="$rest"/>
                    </xsl:call-template>
                </xsl:if>      
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- mikeward added -->
    <xsl:template name="output_FOR_argument">
        <xsl:param name="arg"/>
           <xsl:call-template name="link_object">
                <xsl:with-param name="object_name" select="$arg"/>
                <xsl:with-param name="object_used_in_schema_name" select="../../@name"/>
                <xsl:with-param name="clause" select="'section'"/>
            </xsl:call-template>
    </xsl:template>
    
<xsl:template name="process_rule_arguments">
  <xsl:param name="args"/>
  <xsl:choose>
    <!-- single argument -->
    <xsl:when test="not(contains($args,' '))">
      <xsl:call-template name="output_rule_argument">
        <xsl:with-param name="arg" select="$args"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="arg1" select="substring-before($args,' ')"/>
      <xsl:variable name="rest" select="substring-after($args,' ')"/>
      <xsl:call-template name="output_rule_argument">
        <xsl:with-param name="arg" select="$arg1"/>
      </xsl:call-template>
      <xsl:if test="$rest">
        <xsl:call-template name="process_rule_arguments">
          <xsl:with-param name="args" select="$rest"/>
        </xsl:call-template>
      </xsl:if>      
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="output_rule_argument">
  <xsl:param name="arg"/>
  <p class="expressdescription">
    <b>
      <xsl:value-of select="concat($arg,' : ')"/>
    </b>
    <!-- output the default description -->
    the set of all instances of 
    <xsl:call-template name="link_object">
      <xsl:with-param name="object_name" select="$arg"/>
      <xsl:with-param name="object_used_in_schema_name" 
        select="../../@name"/>
      <xsl:with-param name="clause" select="'section'"/>
    </xsl:call-template>.</p>
</xsl:template>


<!-- 
     Express is displayed in clauses: 
     Interfaces
     Constants
     Imported Constants
     Types
     Imported Types
     Entities
     Imported Entities
		 Subtype_constraints
     Functions
     Imported Functions
     Rules
     Imported Rules
     Procedures
     Imported Procedures
     Template checks to see whether a particular clause is present in the
     schema. 
     If it is the clause number is returned. If not 0 is returned.
     The clause argument is: 
     interface constant type entity function rule procedure
     imported_constant imported_type imported_entity 
     imported_function imported_rule imported_procedure
-->
<xsl:template name="express_clause_present">
  <xsl:param name="clause"/>
  <xsl:param name="schema_name"/>

  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="xml_file">
    <xsl:choose>
      <xsl:when test="contains($schema_name,'_arm')">
        <xsl:value-of select="concat($module_dir,'/arm.xml')"/>
      </xsl:when>
      <xsl:when test="contains($schema_name,'_mim')">
        <xsl:value-of select="concat($module_dir,'/mim.xml')"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- should never get here -->
        1000
      </xsl:otherwise>
    </xsl:choose>      
  </xsl:variable>

  <xsl:variable name="clause_present">
    <xsl:choose>
      <xsl:when test="$clause='interface'">
        <xsl:choose>
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string -->
          <xsl:when
            test="document(string($xml_file))/express/schema/interface">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="clause" select="'interface'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='constant'">
        <xsl:choose>          
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string -->
          <xsl:when
            test="document(string($xml_file))/express/schema/constant">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="clause" select="'constant'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='type'">
        <xsl:choose>          
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string -->
          <xsl:when
            test="document(string($xml_file))/express/schema/type">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="clause" select="'type'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='entity'">
        <xsl:choose>          
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string -->
          <xsl:when
            test="document(string($xml_file))/express/schema/entity">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="clause" select="'entity'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='subtype.constraint'">
        <xsl:choose>
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string -->
          <xsl:when
            test="document(string($xml_file))/express/schema/subtype.constraint">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="clause" select="'subtype.constraint'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>


      <xsl:when test="$clause='function'">
        <xsl:choose>
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string -->
          <xsl:when
            test="document(string($xml_file))/express/schema/function">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="clause" select="'function'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='rule'">
        <xsl:choose>
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string -->
          <xsl:when
            test="document(string($xml_file))/express/schema/rule">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="clause" select="'rule'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='procedure'">
        <xsl:choose>
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string -->
          <xsl:when
            test="document(string($xml_file))/express/schema/procedure">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="clause" select="'procedure'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      
      <xsl:when test="$clause='imported_constant'">
        <xsl:choose>          
        <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string --> 
          <xsl:when
            test="document(string($xml_file))/express/schema/interface/described.item[@kind='CONSTANT']">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="clause" select="'imported_constant'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='imported_type'">
        <xsl:choose>          
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string --> 
          <xsl:when
            test="document(string($xml_file))/express/schema/interface/described.item[@kind='TYPE']">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="clause" select="'imported_type'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='imported_entity'">
        <xsl:choose>          
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string --> 
          <xsl:when
            test="document(string($xml_file))/express/schema/interface/described.item[@kind='ENTITY']">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="clause" select="'imported_entity'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='imported_function'">
        <xsl:choose>          
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string --> 
          <xsl:when
            test="document(string($xml_file))/express/schema/interface/described.item[@kind='FUNCTION']">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="clause" select="'imported_function'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='imported_rule'">
        <xsl:choose>          
          <!-- There seems to be a bug in MXSL3. 
               Should not need to convert $xml_file to a string --> 
          <xsl:when
            test="document(string($xml_file))/express/schema/interface/described.item[@kind='RULE']">
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="clause" select="'imported_rule'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$clause='imported_procedure'">
        <xsl:choose>          
        <!-- There seems to be a bug in MXSL3. 
             Should not need to convert $xml_file to a string --> 
        <xsl:when
            test="document(string($xml_file))/express/schema/interface/described.item[@kind='PROCEDURE']"> 
            <xsl:call-template name="express_clause_number">
              <xsl:with-param name="clause" select="'imported_procedure'"/>
              <xsl:with-param name="schema_name" select="$schema_name"/>
            </xsl:call-template>              
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$clause_present"/>
</xsl:template>






<!--
     The order of the clauses describing the express is:
     Interfaces
     Constants
     Imported Constants
     Types
     Imported Types
     Entities
     Imported Entities
		 Subtype_constraints
     Functions
     Imported Functions
     Rules
     Imported Rules
     Procedures
     Imported Procedures
     Each set of constructs is in a separate clause. The clauses are
     numbered consecutively.
     If the express does not contain a particular set of express
     constructs, then the clause is not output. This will obviously affect
     the numbering of the clauses.
          
     This template will return the number of the clause according to
     whether any of the previous express clauses are required.
     the clause argument is: 
     interface 
     constant type entity function rule procedure
     imported_constant imported_type imported_entity 
     imported_function imported_rule imported_procedure
-->
<xsl:template name="express_clause_number">
  <xsl:param name="clause"/>
  <xsl:param name="schema_name"/>

  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="xml_file">
    <xsl:choose>
      <xsl:when test="contains($schema_name,'_arm')">
        <xsl:value-of select="concat($module_dir,'/arm.xml')"/>
      </xsl:when>
      <xsl:when test="contains($schema_name,'_mim')">
        <xsl:value-of select="concat($module_dir,'/mim.xml')"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- should never get here -->
        1000
      </xsl:otherwise>
    </xsl:choose>      
  </xsl:variable>


  <!-- create a variable for each clause then assign 1 to it if the clause
       exists in the express. Then add them together to give the number       
       -->
  <xsl:variable name="interface_clause">
    <xsl:choose>
      <!-- Only clause 4 (ARM) puts USE/REFERENCE FROMs in a separate
           clause -->
      <xsl:when test="contains($schema_name,'_arm')">
        <xsl:choose>
          <xsl:when test="document(string($xml_file))/express/schema/interface">
            1
          </xsl:when>
          <xsl:otherwise>
            0
          </xsl:otherwise>
        </xsl:choose>        
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="constant_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/constant">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="imported_constant_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/interface/described.item[@kind='CONSTANT']">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="type_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/type">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="imported_type_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/interface/described.item[@kind='TYPE']">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


  <xsl:variable name="entity_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/entity">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="imported_entity_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/interface/described.item[@kind='ENTITY' or @kind='ATTRIBUTE']">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="subtype_constraint_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/subtype.constraint">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="function_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/function">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="imported_function_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/interface/described.item[@kind='FUNCTION']">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="rule_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/rule">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="imported_rule_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/interface/described.item[@kind='RULE']">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="procedure_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/procedure">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="imported_procedure_clause">
    <xsl:choose>
      <xsl:when
        test="document(string($xml_file))/express/schema/interface/described.item[@kind='PROCEDURE']">
        1
      </xsl:when>
      <xsl:otherwise>
        0
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


  <!-- now add the clause variables together according to which clause
       number is required -->
  <xsl:variable name="clause_number">
    <xsl:choose>
      <xsl:when test="$clause='interface'">
        <xsl:value-of select="number($interface_clause)"/>
      </xsl:when>

      <xsl:when test="$clause='constant'">
        <xsl:value-of select="$interface_clause + $constant_clause"/>
      </xsl:when>
      <xsl:when test="$clause='imported_constant'">
        <xsl:value-of select="$interface_clause + 
                              $constant_clause + $imported_constant_clause"/>
      </xsl:when>

      <xsl:when test="$clause='type'">
        <xsl:value-of select="$interface_clause + 
                              $constant_clause + $imported_constant_clause + 
                              $type_clause"/>
      </xsl:when>
      <xsl:when test="$clause='imported_type'">
        <xsl:value-of select="$interface_clause + 
                              $constant_clause + $imported_constant_clause + 
                              $type_clause + $imported_type_clause"/>
      </xsl:when>

      <xsl:when test="$clause='entity'">
        <xsl:value-of select="$interface_clause + 
                              $constant_clause + $imported_constant_clause +
                              $type_clause + $imported_type_clause +
                              $entity_clause"/>
      </xsl:when>
      <xsl:when test="$clause='imported_entity'">
        <xsl:value-of select="$interface_clause + 
                              $constant_clause + $imported_constant_clause +
                              $type_clause + $imported_type_clause + 
                              $entity_clause + $imported_entity_clause"/>
      </xsl:when>

      <xsl:when test="$clause='subtype.constraint'">
        <xsl:value-of select="$interface_clause + 
                              $constant_clause + $imported_constant_clause +
                              $type_clause + $imported_type_clause + 
                              $entity_clause + $imported_entity_clause + 
                              $subtype_constraint_clause"/>
      </xsl:when>

      <xsl:when test="$clause='function'">
        <xsl:value-of select="$interface_clause + 
                              $constant_clause + $imported_constant_clause +
                              $type_clause + $imported_type_clause + 
                              $entity_clause + $imported_entity_clause +
															$subtype_constraint_clause + 
                              $function_clause"/>
      </xsl:when>
      <xsl:when test="$clause='imported_function'">
        <xsl:value-of select="$interface_clause + 
                              $constant_clause + $imported_constant_clause +
                              $type_clause + $imported_type_clause + 
                              $entity_clause + $imported_entity_clause + 
															$subtype_constraint_clause + 
                              $function_clause + $imported_function_clause"/>
      </xsl:when>

      <xsl:when test="$clause='rule'">
        <xsl:value-of select="$interface_clause + 
                              $constant_clause + $imported_constant_clause +
                              $type_clause + $imported_type_clause + 
                              $entity_clause + $imported_entity_clause + 
															$subtype_constraint_clause + 
                              $function_clause + $imported_function_clause +
                              $rule_clause"/>
      </xsl:when>
      <xsl:when test="$clause='imported_rule'">
        <xsl:value-of select="$interface_clause + 
                              $constant_clause + $imported_constant_clause +
                              $type_clause + $imported_type_clause + 
                              $entity_clause + $imported_entity_clause + 
															$subtype_constraint_clause + 
                              $function_clause + $imported_function_clause +
                              $rule_clause + $imported_rule_clause"/>
      </xsl:when>

      <xsl:when test="$clause='procedure'">
        <xsl:value-of select="$interface_clause + 
                              $constant_clause + $imported_constant_clause +
                              $type_clause + $imported_type_clause +
                              $entity_clause + $imported_entity_clause + 
															$subtype_constraint_clause + 
                              $function_clause + $imported_function_clause +
                              $rule_clause + $imported_rule_clause +
                              $procedure_clause"/>
      </xsl:when>
      <xsl:when test="$clause='imported_procedure'">
        <xsl:value-of select="$interface_clause + 
                              $constant_clause + $imported_constant_clause +
                              $type_clause + $imported_type_clause + 
                              $entity_clause + $imported_entity_clause + 
															$subtype_constraint_clause + 
                              $function_clause + $imported_function_clause +
                              $rule_clause + $imported_rule_clause +
                              $procedure_clause + $imported_procedure_clause"/>
      </xsl:when>

    </xsl:choose>    
  </xsl:variable>

  <!-- if the schema ends in _arm then it is clause 4
       if it ends in _mim then it is clause 5.2
       -->
  <xsl:variable name="main_clause">
    <xsl:choose>
      <xsl:when test="contains($schema_name,'_arm')">
        <xsl:value-of select="concat('4.',$clause_number)"/>
      </xsl:when>
      <xsl:when test="contains($schema_name,'_mim')">
        <xsl:value-of select="concat('5.2.',$clause_number)"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- should never get here -->
        1000
      </xsl:otherwise>
    </xsl:choose>      
  </xsl:variable>

  <xsl:value-of select="$main_clause"/>

</xsl:template>



<xsl:template name="imported_constructs">
  <xsl:param name="desc_item"/>
  <xsl:if test="$desc_item">
    <xsl:variable name="kind" select="$desc_item/@kind"/>
    <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
    <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
    <xsl:variable name="lkind" select="translate($kind,$UPPER, $LOWER)"/>

    <xsl:variable name="imported_kind" select="concat('imported_',$lkind)"/>
    <xsl:variable name="schema_name" select="$desc_item/../../@name"/>
        <xsl:variable name="clause_number">
          <xsl:call-template name="express_clause_number">
            <xsl:with-param name="clause" select="$imported_kind"/>
            <xsl:with-param name="schema_name" select="$schema_name"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="clause_header">
          <xsl:choose>
            <xsl:when test="contains($schema_name,'_arm')">
              <xsl:value-of select="concat($clause_number, 
                                    ' ARM EXPRESS imported ',
                                    $lkind,' modifications')"/>
            </xsl:when>
            <xsl:when test="contains($schema_name,'_mim')">
              <xsl:value-of select="concat($clause_number, 
                                    ' MIM  EXPRESS imported '
                                    ,$lkind,' modifications')"/>
            </xsl:when>
          </xsl:choose>      
        </xsl:variable>

        <xsl:variable name="aname" select="concat('imported_',$lkind)"/>
        <h2>
          <A NAME="{$aname}">
            <xsl:value-of select="$clause_header"/>
          </A>
        </h2>
        <xsl:apply-templates select="$desc_item"/>                    
      </xsl:if>
</xsl:template>

<xsl:template match="described.item">
  <xsl:variable name="UPPER">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="LOWER">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="lkind" select="translate(@kind,$UPPER, $LOWER)"/>
  <xsl:variable name="imported_kind" select="concat('imported_',$lkind)"/>

  <xsl:variable name="schema_name" select="../../@name"/>
  <xsl:variable name="clause_number">
    <xsl:call-template name="express_clause_number">
      <xsl:with-param name="clause" select="$imported_kind"/>
      <xsl:with-param name="schema_name" select="$schema_name"/>
    </xsl:call-template>
  </xsl:variable>
  
  <h4>
    <xsl:value-of select="concat($clause_number,'.',position(),' ',@item )"/>
  </h4>
  <!-- get information about the module from which the construct is being
       imported -->
  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="../@schema"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="module_no"
    select="document(concat($module_dir,'/module.xml'))/module/@part"/>
  <xsl:variable name="module_name">
    <xsl:call-template name="module_name">
      <xsl:with-param name="module" select="../@schema"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="module_href"
    select="concat('../../',$module_name,'/sys/1_scope',$FILE_EXT)"/>
  
  The base definition of the 
  <xsl:call-template name="link_object">
    <xsl:with-param name="object_name" select="@item"/>
    <xsl:with-param name="object_used_in_schema_name" 
      select="../../@name"/>
    <xsl:with-param name="clause" select="'section'"/>
  </xsl:call-template>
  <xsl:value-of select="concat(' ',$lkind)"/>
  is specified in 
  <a href="{$module_href}">
    <xsl:value-of select="concat('ISO 10303-',$module_no)"/>
  </a>
  The following modifications apply to this part of ISO 10303.
  <p>
    The definition of 
    <xsl:call-template name="link_object">
      <xsl:with-param name="object_name" select="@item"/>
      <xsl:with-param name="object_used_in_schema_name" 
        select="../../@name"/>
      <xsl:with-param name="clause" select="'section'"/>
    </xsl:call-template>
    is modified as follows:
  </p>
  <ul>
    <li>
      <xsl:apply-templates/>
    </li>
  </ul>
</xsl:template>


<xsl:template match="select" mode="description">
  <!--  output the boilerplate select descriptions for selects. -->
  <xsl:variable name="description_file"
    select="/express/@description.file"/>
  <xsl:variable name="select_description">
    <xsl:choose>
      <xsl:when test="$description_file">
        <xsl:value-of select="document($description_file)/ext_descriptions/@describe.selects"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'NO'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="typename" select="../@name"/>

  <xsl:variable name="ext_notes">
    <xsl:call-template name="notes_in_external_description">
      <xsl:with-param name="schema" select="../../@name"/>
      <xsl:with-param name="entity" select="../@name"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="$select_description='YES'">    
    <xsl:choose>
      <xsl:when test="@basedon and @extensible='YES'">
        <!-- an extended and extensible SELECT type -->
        <p>
          The <b><xsl:value-of select="$typename"/></b> type is an extension
          of the 
          <b>
            <xsl:call-template name="link_object">
              <xsl:with-param name="object_name" select="@basedon"/>
              <xsl:with-param name="object_used_in_schema_name" 
                select="../../@name"/>
              <xsl:with-param name="clause" select="'section'"/>
            </xsl:call-template>  
          </b> type. 
          <xsl:if test="@selectitems and (string-length(@selectitems)!=0)">
            It adds the data 
            <xsl:choose>
              <!-- if the list has a space there must be more than one item -->
              <xsl:when test="contains(normalize-space(@selectitems),' ')">
                types
              </xsl:when>
              <xsl:otherwise>
                type
              </xsl:otherwise>
            </xsl:choose>
            <xsl:call-template name="link_list">
              <xsl:with-param name="suffix" select="', '"/>
              <xsl:with-param name="bold" select="'yes'"/>
              <xsl:with-param name="list" select="@selectitems"/>
              <xsl:with-param name="object_used_in_schema_name"
                select="../../@name"/>
              <xsl:with-param name="clause" select="'section'"/>
              <xsl:with-param name="and_for_last_pair" select="'yes'"/>
            </xsl:call-template>
            to the list of alternate data types.
          </xsl:if>
        </p>
        <p class="note">
          <small>
            <xsl:choose>
              <xsl:when test="./note">
                NOTE&#160;1&#160;&#160;The list of entity data types may be
                extended in application modules that use the constructs of
                this module.
              </xsl:when>
              <xsl:when test="string-length($ext_notes)>0">
                NOTE&#160;1&#160;&#160;The list of entity data types may be
                extended in application modules that use the constructs of
                this module.
              </xsl:when>
              <xsl:otherwise>
                NOTE&#160;&#160;The list of entity data types may be
                extended in application modules that use the constructs of
                this module.
              </xsl:otherwise>
            </xsl:choose>
          </small>
        </p>
                </xsl:when>

      <xsl:when test="(@basedon and @extensible='NO') or @basedon">
        <!-- an extended not extensible SELECT type  -->
        <p>
        The <b><xsl:value-of select="$typename"/></b> type is an extension
        of the 
        <b>
          <xsl:call-template name="link_object">
            <xsl:with-param name="object_name" select="@basedon"/>
            <xsl:with-param name="object_used_in_schema_name" 
              select="../../@name"/>
            <xsl:with-param name="clause" select="'section'"/>
          </xsl:call-template>  
        </b> type. 
        <xsl:if test="@selectitems and (string-length(@selectitems)!=0)">
          It adds the data 
          <xsl:choose>
            <!-- if the list has a space there must be more than one item -->
            <xsl:when test="contains(normalize-space(@selectitems),' ')">
              types
            </xsl:when>
            <xsl:otherwise>
              type
            </xsl:otherwise>
          </xsl:choose>
          <xsl:call-template name="link_list">
            <xsl:with-param name="suffix" select="', '"/>
            <xsl:with-param name="bold" select="'yes'"/>
            <xsl:with-param name="list" select="@selectitems"/>
            <xsl:with-param name="object_used_in_schema_name"
              select="../../@name"/>
            <xsl:with-param name="clause" select="'section'"/>
            <xsl:with-param name="and_for_last_pair" select="'yes'"/>
          </xsl:call-template>
          to the list of alternate data types.
        </xsl:if>
      </p>
      </xsl:when>

      <xsl:when test="@extensible='YES'">
        <!-- extensible SELECT type -->
        <xsl:choose>

          <xsl:when test="@selectitems">
            <!-- an extensible non-empty SELECT type -->
            <p>
              The <b><xsl:value-of select="$typename"/></b> type is an
              extensible list of alternate data types
              that allows for the designation of the data 
              <xsl:choose>
                <!-- if the list has a space there must be more than one item -->
                <xsl:when test="contains(normalize-space(@selectitems),' ')">
                  types
                </xsl:when>
                <xsl:otherwise>
                  type
                </xsl:otherwise>
              </xsl:choose>              
              <xsl:call-template name="link_list">
                <xsl:with-param name="suffix" select="', '"/>
                <xsl:with-param name="bold" select="'yes'"/>
                <xsl:with-param name="list" select="@selectitems"/>
                <xsl:with-param name="object_used_in_schema_name"
                  select="../../@name"/>
                <xsl:with-param name="clause" select="'section'"/>
                <xsl:with-param name="and_for_last_pair" select="'yes'"/>
              </xsl:call-template>.
          <!--
              The data types that may be chosen are specified in the 
              <b><xsl:value-of select="$typename"/></b>
              type and in select data types that extend the 
              <b><xsl:value-of select="$typename"/></b> 
              type.
-->
            </p>
            <p class="note">
              <small>
                <xsl:choose>
                  <xsl:when test="./note">
                    NOTE&#160;1&#160;&#160;
                  </xsl:when>
                  <xsl:when test="string-length($ext_notes)>0">
                    NOTE&#160;1&#160;&#160;
                  </xsl:when>
                  <xsl:otherwise>
                    NOTE&#160;&#160;
                  </xsl:otherwise>
                </xsl:choose>The list of entity data types may be
                extended in application modules that use the constructs of
                this module.                 
              </small>
              </p>
          </xsl:when>

          <xsl:otherwise>
            <!-- an extensible empty SELECT type -->
            <p> 
              The <b><xsl:value-of select="$typename"/></b> type is an
              extensible list of alternate data types. 
              Additional alternate data types are specified in select data
              types that extend the 
              <b><xsl:value-of select="$typename"/></b> type. 
            </p>

            <p class="note">
              <small>
                <xsl:choose>
                  <xsl:when test="./note">
                    NOTE&#160;1&#160;&#160;
                  </xsl:when>
                  <xsl:when test="string-length($ext_notes)>0">
                    NOTE&#160;1&#160;&#160;
                  </xsl:when>
                  <xsl:otherwise>
                    NOTE&#160;&#160;
                  </xsl:otherwise>
                </xsl:choose>This empty extensible select requires
                extension in a further module to ensure that entities that refer to it have
                at least one valid instantiation.
              </small>
            </p>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!-- a non extensible SELECT type -->
        <xsl:choose>
          <xsl:when test="string-length(@selectitems)&gt;0">
            <!-- an extensible non-empty SELECT type -->
            <p>
              The <b><xsl:value-of select="$typename"/></b> type allows for the designation of the data 
              <xsl:choose>
                <!-- if the list has a space there must be more than one item -->
                <xsl:when test="contains(normalize-space(@selectitems),' ')">
                  types
                </xsl:when>
                <xsl:otherwise>
                  type
                </xsl:otherwise>
              </xsl:choose>              
              <xsl:call-template name="link_list">
                <xsl:with-param name="suffix" select="', '"/>
                <xsl:with-param name="bold" select="'yes'"/>
                <xsl:with-param name="list" select="@selectitems"/>
                <xsl:with-param name="object_used_in_schema_name"
                  select="../../@name"/>
                <xsl:with-param name="clause" select="'section'"/>
                <xsl:with-param name="and_for_last_pair" select="'yes'"/>
              </xsl:call-template>.
            </p>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="error_message">
              <xsl:with-param 
                name="message" 
                select="concat('Error se1: ', 
                        $typename, 
                        ' is an empty select')"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="deprecated_type_note">     
    <xsl:with-param name="type" select=".."/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>
</xsl:stylesheet>
