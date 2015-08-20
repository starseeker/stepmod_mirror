<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_5_mapping_check.xsl,v 1.26 2015/08/13 14:52:06 nigelshaw Exp $
  Author:  Rob Bodington, Nigel Shaw Eurostep Limited
  Owner:   Developed by Eurostep in conjunction with PLCS Inc
  Purpose:
     
-->
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:exslt="http://exslt.org/common"
  extension-element-prefixes="msxsl exslt"
  exclude-result-prefixes="msxsl exslt"
  version="1.0">

  <xsl:import href="express.xsl"/><!-- MWD added --> 
  <xsl:import href="../nav/xsl/mapping_parse.xsl"/><!-- MWD added --> 
  <xsl:import href="../nav/xsl/mim_tree.xsl"/><!-- MWD added --> 
  <xsl:variable name="UPPER" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/><!-- MWD -->
  <xsl:variable name="LOWER" select="'abcdefghijklmnopqrstuvwxyz'"/><!-- MWD -->
  <xsl:variable name="NUMBERS" select="'0123456789'"/><!-- MWD -->
  <xsl:variable name="apos">'</xsl:variable><!-- MWD added --> 
  <xsl:variable name="mod_dir_from_5mvxml" select="//module_clause/@directory"/><!-- MWD added --> 
  <xsl:variable name="mappings-result"><!-- MWD added --> 
    <xsl:call-template name="mapping-full-parse"/><!-- MWD added --> 
  </xsl:variable><!-- MWD added --> 
  <xsl:variable name="mim_file" 
                select="concat('../data/modules/',/module_clause/@directory,'/mim.xml')"/><!-- MWD added --> 
  <xsl:variable name="mim_node" select="document($mim_file)/express"/><!-- MWD added --> 
  <xsl:variable name="mim_schema_name" select="$mim_node//schema/@name"/><!-- MWD added --> 
  <xsl:variable name="arm_file" 
                select="concat('../data/modules/',/module_clause/@directory,'/arm.xml')"/><!-- MWD added --> 
  <xsl:variable name="arm_node" select="document($arm_file)/express"/><!-- MWD added --> 
  <xsl:variable name="schema-name" select="concat($mod_dir_from_5mvxml,'_mim')"/><!--MWD from mapping_view -->
  <xsl:variable name="schemas" ><!-- MWD added --> 
    <xsl:choose><!-- MWD added --> 
      <xsl:when test="$schema-name = translate($mim_schema_name,$UPPER,$LOWER)" ><!-- MWD added --> 
        <xsl:call-template name="depends-on-recurse-mim-x-2"><!-- MWD added --> 
          <xsl:with-param name="todo" select="concat(' ',$schema-name,' ')" /><!-- MWD added --> 
          <xsl:with-param name="done" select="' '" /><!-- MWD added --> 
        </xsl:call-template><!-- MWD added --> 
      </xsl:when><!-- MWD added --> 
      <xsl:otherwise>BAD MIM SCHEMA NAME</xsl:otherwise><!-- MWD added --> 
    </xsl:choose><!-- MWD added --> 
  </xsl:variable><!-- MWD added --> 
  <xsl:variable name="schemas-node-set"><!-- MWD added --> 
    <xsl:choose><!-- MWD added --> 
      <xsl:when test="2 > string-length($schemas)" ><!-- MWD added --> 
      </xsl:when><!-- MWD added --> 
      <xsl:otherwise><!-- MWD added --> 
        <xsl:copy-of select="exslt:node-set($schemas)"/><!-- MWD added --> 
      </xsl:otherwise><!-- MWD added --> 
    </xsl:choose><!-- MWD added --> 
  </xsl:variable><!-- MWD added -->  
  <xsl:variable name="dep-schemas" select="document(exslt:node-set($schemas-node-set)//x)" /><!-- MWD added --> 
  <xsl:variable name="pseudo-schema-name" select="concat(/module_clause/@directory,'_pseudo_long_form_mim')"/><!-- MWD added --> 

  <!-- the SAXON and MSXML proprietary extensions are for node-set -->

  <!-- checks all the ARM entities are mapped -->
<xsl:template match="mapping_table" mode="check_all_arm_mapped"> 
  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="/module/@name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="ae_nodes" select="./ae"/>

  <xsl:for-each
    select="document(concat($module_dir,'/arm.xml'))/express/schema/entity">
    <xsl:variable name="entity" select="@name"/>
    <xsl:variable name="ae_node" select="$ae_nodes[@entity=$entity]"/>
    <xsl:variable name="aa_nodes" select="$ae_node/aa"/>
    <xsl:choose>
      <!-- check mapping for entity exists -->
      <xsl:when test="not($ae_node)">
        <xsl:call-template name="error_message">
          <xsl:with-param 
            name="message" 
            select="concat('Error mc5: the entity ',$entity,' has not been mapped.')"/>
        </xsl:call-template>    
      </xsl:when>
      
      <!-- Do not check if the entity is mapped using a SUBTYPE constraint -->
      <xsl:when test="contains(string($ae_node/aimelt),'/SUBTYPE')"/>

      <xsl:otherwise>
      <!-- check that all the attributes have been mapped -->      
      <xsl:for-each select="./explicit">
        <xsl:choose>
          <xsl:when test="./redeclaration">
            <!-- Not yet implemented redeclaration check 
                 so only check if not redeclared -->            
            <xsl:variable name="arm_attr_self" select="concat('SELF\',./redeclaration/@entity-ref,'.',@name)"/>
            <xsl:variable name="arm_attr" select="@name"/>   
            <xsl:if  test="not($aa_nodes[@attribute=$arm_attr_self]) and not($aa_nodes[@attribute=$arm_attr])">
              <xsl:call-template name="error_message">
                <xsl:with-param 
                  name="message" 
                  select="concat('Error mc6: the attribute ',
                          $entity,'.',$arm_attr,
                          ' has not been mapped.')"/>
              </xsl:call-template> 
            </xsl:if>
          </xsl:when>

          <xsl:otherwise>
            <xsl:variable name="arm_attr" select="@name"/>            
            <xsl:choose>
              <xsl:when test="not($aa_nodes[@attribute=$arm_attr])">
                <xsl:call-template name="error_message">
                  <xsl:with-param 
                    name="message" 
                    select="concat('Error mc6: the attribute ',
                            $entity,'.',$arm_attr,
                            ' has not been mapped.')"/>
                </xsl:call-template> 
              </xsl:when>
              <xsl:otherwise>
                <!-- if the attribute is an extensible select, then you need a
                     mapping to the select -->
                <xsl:variable name="attr"
                  select="$aa_nodes[@attribute=$arm_attr]"/>
                <xsl:variable name="typename" select="./typename/@name"/>
                <!-- attribute is referencing an extensible select so there
                     must be a mapping -->
                <xsl:if test="/express/schema/type[@name=$typename]/select[@extensible='YES']">
                  <xsl:if test="not($aa_nodes[@attribute=$arm_attr and @assertion_to=$typename])">
                    <xsl:call-template name="error_message">
                      <xsl:with-param 
                        name="message" 
                        select="concat('Error mc7: the attribute ',
                                $entity,'.',$arm_attr,
                                ' has not been mapped to the extended select ',$typename )"/>
                    </xsl:call-template> 
                  </xsl:if>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:otherwise>
  </xsl:choose>
  </xsl:for-each>
</xsl:template>



<xsl:template name="check_entity_exists">
  <xsl:param name="entity"/>
  <xsl:if test="$check_mapping='yes'">
    <xsl:if
      test="not(contains($global_xref_list,concat('.',$entity,'|')))">
      <xsl:call-template name="error_message">
        <xsl:with-param 
          name="message" 
          select="concat('Error mc1: the entity ',$entity,' has not been
                  interfaced from an integrated resource or MIM.')"/>
      </xsl:call-template>    
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- 
     check if the attribute on the entity is valid (ARM level)     
-->
<xsl:template match="aa" mode="check_valid_attribute">
  <xsl:if test="$check_mapping='yes'">
    <xsl:variable name="arm_entity">
      <xsl:choose>
        <!-- inherited_from_module specified then the ARM object is declared in
             another module -->
        <xsl:when test="@inherited_from_module">
          <xsl:value-of select="@inherited_from_entity"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="../@entity"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="arm_attr" select="@attribute"/>
    <xsl:variable name="module_dir">
      <xsl:choose>
        <!-- inherited_from_module specified then the ARM object is declared in
             another module -->
        <xsl:when test="@inherited_from_module">
          <xsl:call-template name="module_directory">
            <xsl:with-param name="module" select="@inherited_from_module"/>
          </xsl:call-template>
        </xsl:when>
        <!-- original_module specified then the ARM object is declared in
             another module -->
        <xsl:when test="../@original_module">
          <xsl:call-template name="module_directory">
            <xsl:with-param name="module" select="../@original_module"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="module_directory">
            <xsl:with-param name="module" select="../../../../module/@name"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="arm_xml" select="concat($module_dir,'/arm.xml')"/>

    <xsl:choose>
      <xsl:when test="contains(@attribute,'(as')">
        <!-- users frequently try to write the assertion explicitly e.g.
             Part_version to Part (as of_product)
             instead of using assertion_to -->
        <xsl:call-template name="error_message">
          <xsl:with-param name="message">
            <xsl:value-of select="concat('Error m2: ', @attribute, ' should
                                  be the name of an ARM entity. Use 
                                  &lt;aa attribute=&#034;&#034; assertion_to=&#034;&#034;&gt; ')"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="contains($arm_attr,'SELF')">
        <!-- must be a redeclared attribute -->
        <xsl:variable name="redec_attr">
          <!-- the attribute may be redeclared i.e. SELF\product.of_product -->
          <xsl:call-template name="get_last_section">
            <xsl:with-param name="path" select="@attribute"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if 
          test="not(document($arm_xml)/express/schema/entity[@name=$arm_entity]/explicit[@name=$redec_attr])">
          <!--  check that the attribute exists in the arm -->
          <xsl:call-template name="error_message">
            <xsl:with-param name="message"
              select="concat('Error m4: The attribute ', ../@entity,'.',@attribute, 
                      ' does not exist in the arm as a redeclared attribute')"/>
          </xsl:call-template>
          <!-- need to check whether the declaration is OK -->
          <!-- not yet implemented  -->
        </xsl:if>
      </xsl:when>

      <!--  check that the attribute exists in the arm -->
      <xsl:when
        test="not(document($arm_xml)/express/schema/entity[@name=$arm_entity]/explicit[@name=$arm_attr])">

        <xsl:choose>
          <xsl:when test="@inherited_from_module">
            <xsl:call-template name="error_message">
              <xsl:with-param name="message"
                select="concat('Error m5: The attribute ', @inherited_from_module,'.',@attribute, 
                        ' specified as @inherited_from_module does not exist in the arm (',$arm_xml,') as an  attribute')"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="error_message">
              <xsl:with-param name="message"
                select="concat('Error m6: The attribute ', ../@entity,'.',@attribute, 
                        ' does not exist in the arm (',$arm_xml,') as an explicit attribute')"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:if>
</xsl:template>



<xsl:template match="refpath|aimelt" mode="check_ref_path_old">
  <xsl:if test="not(string(.)='PATH')">
    <!-- make sure that refpath ends in $ -->
    <xsl:variable name="refpath" 
      select="translate(concat(.,'$'),'&#xA;&#xD;','$')"/>
    <!-- process line at a time -->
    <xsl:call-template name="check_ref_path_line">
      <xsl:with-param name="refpath" select="$refpath"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="refpath|refpath_extend" mode="check_ref_path">
  <xsl:variable name="ent" select="../../@entity"/><!-- MWD path changed and taken out of refpath var --> 
  <xsl:variable name="refpath">
      <refpath >
        <xsl:attribute name="entity" >
          <xsl:value-of select="$ent"/>
        </xsl:attribute>
        <ORIG><xsl:value-of select="."/></ORIG>
        <NEW>
          <xsl:variable name="this-path">
            <xsl:call-template name="space-out-path">
              <xsl:with-param name="path" select="."/>
            </xsl:call-template>		
          </xsl:variable>
          
          <xsl:call-template name="parse-refpath">
            <xsl:with-param name="path" 
              select="normalize-space($this-path)"/>
          </xsl:call-template>
        </NEW>
      </refpath>
    </xsl:variable>
    <xsl:variable name="refpath_nodes">
      <xsl:choose>
        <xsl:when test="function-available('msxsl:node-set')">
          <xsl:value-of select="msxsl:node-set($refpath)"/>
        </xsl:when>
        <xsl:when test="function-available('exslt:node-set')"><!-- MWD nodeset function renamed --> 
          <xsl:value-of select="exslt:node-set($refpath)"/><!-- MWD nodeset function renamed --> 
        </xsl:when>
      </xsl:choose>
    </xsl:variable>  
  
  <xsl:apply-templates select="exslt:node-set($refpath)//word" mode="test" ><!-- MWD added --> 
    <xsl:with-param name="schemas" select="$dep-schemas" /><!-- MWD added -->
  </xsl:apply-templates><!-- MWD added -->
  
  <xsl:apply-templates select="exslt:node-set($refpath)//is-extended-by | exslt:node-set($refpath)//extends" mode="test" ><!-- MWD added -->
    <xsl:with-param name="schemas" select="$dep-schemas" /><!-- MWD added -->
  </xsl:apply-templates><!-- MWD added -->
  
  <xsl:apply-templates select="exslt:node-set($refpath)//equals" mode="test" ><!-- MWD added -->
    <xsl:with-param name="schemas" select="$dep-schemas" /><!-- MWD added -->
  </xsl:apply-templates><!-- MWD added -->
  
  <xsl:apply-templates select="exslt:node-set($refpath)//is-subtype-of | exslt:node-set($refpath)//is-supertype-of" mode="test" ><!-- MWD added -->
    <xsl:with-param name="schemas" select="$dep-schemas" /><!-- MWD added -->
  </xsl:apply-templates><!-- MWD added -->
  
</xsl:template>

  <xsl:template name="parse-refpath">
    <xsl:param name="path"/>
    
    <xsl:variable name="firstWord" select="substring-before($path,' ')"/>
    <xsl:variable name="restOfPath" select="substring-after($path,' ')"/>      
    <xsl:choose>
      <xsl:when test="contains($path,' ')">
        <!-- get first word and process -->
        <xsl:choose>
          <xsl:when test="(starts-with($firstWord,$apos)) and (substring($firstWord,string-length($firstWord))!=$apos)">
            <!--<xsl:variable name="spaceFreeRestOfPath" select="translate($restOfPath, ' ', '')"/>-->
            <!--<xsl:variable name="restOfPathTextEntry" select="substring-before($spaceFreeRestOfPath, $apos)"/>-->
            
            
            <xsl:variable name="restOfTextEntry" select="substring-before($restOfPath, $apos)"/>
            <xsl:variable name="restOfPathAfterTextEntry" select="substring-after($restOfPath, $apos)"/>
            <xsl:variable name="textEntry" select="concat($firstWord, ' ', $restOfTextEntry, $apos)"/>
            <xsl:call-template name="process-word">
              <xsl:with-param name="word" select="$textEntry"/>
              </xsl:call-template>
            
            <xsl:call-template name="parse-refpath">
              <xsl:with-param name="path" select="$restOfPathAfterTextEntry"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="process-word">
              <xsl:with-param name="word" select="$firstWord"/>
            </xsl:call-template>
            <!-- recurse using remainder of string -->
           
            <xsl:call-template name="parse-refpath">
              <xsl:with-param name="path" select="$restOfPath"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>        
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="process-word">
          <xsl:with-param name="word" select="$path"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!--<xsl:template name="parse-refpath">
  <xsl:param name="path"/>
  <xsl:param name="previous"/>
  <xsl:choose>
    <xsl:when test="contains($path,' ')">
      <!-\- get first word and process -\->
      <xsl:call-template name="process-word">
        <xsl:with-param name="word" select="substring-before($path,' ')"/>
        <xsl:with-param name="previous" select="$previous"/>
      </xsl:call-template>
      <!-\- recurse using remainder of string -\->
      <xsl:call-template name="parse-refpath">
        <xsl:with-param name="path" select="substring-after($path,' ')"/>
        <xsl:with-param name="previous" select="substring-before($path,' ')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="process-word">
        <xsl:with-param name="word" select="$path"/>
        <xsl:with-param name="previous" select="$previous"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template> MWD redone to cope with text entries in paths -->

<xsl:template name="space-out-path">
  <xsl:param name="path"/>
  <xsl:param name="last"/>
  <xsl:variable name="first-char" select="substring($path,1,1)"/>
  <xsl:choose>
    <xsl:when test="$first-char='&#x0A;'">
      <xsl:text> \n </xsl:text>
    </xsl:when>
    <xsl:when test="$first-char='{'">
      <xsl:text> { </xsl:text>
    </xsl:when>
    <xsl:when test="$first-char='}'">
      <xsl:text> } </xsl:text>
    </xsl:when>
    <xsl:when test="$first-char='='">
      <xsl:choose>
        <xsl:when test="$last='&lt;'">
          <xsl:text>= </xsl:text>
        </xsl:when>
        <xsl:when test="substring($path,2,1)='&gt;'">
          <xsl:text> =</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text> = </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="$first-char='-'">
			<xsl:choose>
				<xsl:when test="$last='&lt;'">
					<xsl:text>- </xsl:text>
				</xsl:when>
				<xsl:when test="substring($path,2,1)='&gt;'">
					<xsl:text> -</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<!-- not sure this should ever happen! -->
					<xsl:text> - </xsl:text>
				</xsl:otherwise>
			</xsl:choose>
    </xsl:when>
    
    <xsl:when test="$first-char='|'">
      <xsl:text> | </xsl:text>
    </xsl:when>
    
		<xsl:when test="$first-char='&lt;'">
			<xsl:choose>
				<xsl:when test="substring($path,2,1)='-'">
					<xsl:text> &lt;</xsl:text>
				</xsl:when>
				<xsl:when test="substring($path,2,1)='='">
					<xsl:text> &lt;</xsl:text>
				</xsl:when>
				<xsl:when test="substring($path,2,1)='*'">
					<xsl:text> &lt;</xsl:text>
				</xsl:when>

				<xsl:otherwise>
					<!-- not sure this should ever happen! -->
					<xsl:text> &lt; </xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:when test="$first-char='&gt;'">
			<xsl:choose>
				<xsl:when test="$last='-'">
					<xsl:text>&gt; </xsl:text>
				</xsl:when>
				<xsl:when test="$last='='">
					<xsl:text>&gt; </xsl:text>
				</xsl:when>
				<xsl:when test="$last='*'">
					<xsl:text>&gt; </xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<!-- not sure this should ever happen! -->
					<xsl:text> &gt; </xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>

    <xsl:when test="$first-char='('">
      <xsl:text> ( </xsl:text>
    </xsl:when>
    <xsl:when test="$first-char=')'">
      <xsl:text> ) </xsl:text>
    </xsl:when>
    <xsl:when test="$first-char='['">
      <xsl:text> [ </xsl:text>
    </xsl:when>
    <xsl:when test="$first-char=']'">
      <xsl:text> ] </xsl:text>
    </xsl:when>
   
    <xsl:when test="$first-char='*'"><!-- MWD revised to cope with extension symbol -->
      <xsl:choose><!-- MWD revised -->
        <xsl:when test="$last='&lt;'"><!-- MWD revised -->
          <xsl:text>* </xsl:text><!-- MWD revised -->
        </xsl:when><!-- MWD revised -->
        <xsl:when test="substring($path,2,1)='&gt;'"><!-- MWD revised -->
          <xsl:text> *</xsl:text><!-- MWD revised -->
        </xsl:when><!-- MWD revised -->
        <xsl:otherwise><!-- MWD revised -->
          <xsl:text> * </xsl:text><!-- MWD revised -->
        </xsl:otherwise><!-- MWD revised -->
      </xsl:choose><!-- MWD revised -->
    </xsl:when><!-- MWD revised -->
    
    <xsl:when test="$first-char='\'">
      <!-- continuation line, so do nothing -->
    </xsl:when>
    
    <!--		<xsl:when test="$first-char='&amp;apos;'">
         <xsl:choose>
           <xsl:when test="$last='&amp;apos;'">
             <xsl:text>&apos;</xsl:text>
           </xsl:when>
           <xsl:when test="substring($path,2,1)='&amp;apos;'">
             <xsl:text>&apos;</xsl:text>
           </xsl:when>
           <xsl:otherwise>
             <xsl:text> &apos; </xsl:text>
           </xsl:otherwise>
         </xsl:choose>
       </xsl:when>
-->

       <xsl:otherwise>
         <xsl:value-of select="$first-char"/>
       </xsl:otherwise>
     </xsl:choose>
     
     <!-- recurse using remainder of string -->
     <xsl:if test="string-length($path)>1">
       <xsl:call-template name="space-out-path">
         <xsl:with-param name="path" select="substring($path,2)"/>
         <xsl:with-param name="last" select="$first-char"/>
       </xsl:call-template>
       
     </xsl:if>
     
   </xsl:template>
   

<xsl:template name="process-word">
  <xsl:param name="word"/>
  <!--<xsl:param name="previous"/> MWD not used in this template -->
  <xsl:if test="string-length($word)>0">
    <xsl:choose>
      <xsl:when test="$word='\n'">
        <xsl:element name="new-line"/>
      </xsl:when>
      <xsl:when test="$word='{'">
        <xsl:element name="start-constraint"/>
      </xsl:when>
      <xsl:when test="$word='}'">
        <xsl:element name="end-constraint"/>
      </xsl:when>
      <xsl:when test="$word='('">
        <xsl:element name="start-paren"/>
      </xsl:when>
      <xsl:when test="$word=')'">
        <xsl:element name="end-paren"/>
      </xsl:when>
      <xsl:when test="$word='['">
        <xsl:element name="start-bracket"/>
      </xsl:when>
      <xsl:when test="$word=']'">
        <xsl:element name="end-bracket"/>
      </xsl:when>
      <xsl:when test="$word='&lt;-'">
        <xsl:element name="is-pointed-at-by"/>
      </xsl:when>
      <xsl:when test="$word='-&gt;'">
        <xsl:element name="points-to"/>
      </xsl:when>
      <xsl:when test="$word='&lt;='">
        <xsl:element name="is-subtype-of"/>
      </xsl:when>
      <xsl:when test="$word='=&gt;'">
        <xsl:element name="is-supertype-of"/>
      </xsl:when>
      <xsl:when test="$word='*&gt;'"><!-- MWD revised to cope with extension symbol -->
        <xsl:element name="is-extended-by"/><!-- MWD revised to cope with extension symbol -->
      </xsl:when><!-- MWD revised to cope with extension symbol -->
      <xsl:when test="$word='&lt;*'"><!-- MWD revised to cope with extension symbol -->
        <xsl:element name="extends"/><!-- MWD revised to cope with extension symbol -->
      </xsl:when><!-- MWD revised to cope with extension symbol -->
      <xsl:when test="$word='/MAPPING_OF'"><!-- MWD added to cope with MAPPING_OF construct -->
	      <xsl:element name="mapping-of" /><!-- MWD added to cope with MAPPING_OF construct -->
      </xsl:when><!-- MWD added to cope with MAPPING_OF construct -->
      <xsl:when test="$word='*'">
        <xsl:element name="repeat"/>
      </xsl:when>
      <xsl:when test="$word='='">
        <xsl:element name="equals"/>
      </xsl:when>
      <xsl:when test="starts-with($word,'#') and substring($word,string-length($word))=':'">
        <xsl:element name="label">
          <xsl:value-of select="substring($word,2,string-length($word)-2)"/>
        </xsl:element>
      </xsl:when>
      
      
      <xsl:otherwise>
        <word>
          <xsl:value-of select="$word"/>
        </word>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>


<xsl:template name="mapping-full-parse"><!-- MWD new template added -->
   <xsl:variable name="module_file" 
     select="concat('../data/modules/', $mod_dir_from_5mvxml,'/module.xml')"/>
   <xsl:variable name="module_node" select="document($module_file)/module"/>
	<module>
	<xsl:attribute name="name">
		<xsl:value-of select="$mod_dir_from_5mvxml" />
	</xsl:attribute>
		<xsl:apply-templates select="$module_node//ae" />
		<xsl:apply-templates select="$module_node//aa" />
	</module>
</xsl:template>

  <xsl:template match="word" mode="test"><!-- MWD new template added; amended 2015-08-20 -->
    <xsl:param name="schemas" />
    <xsl:if test="string-length(.) != string-length(translate(.,$UPPER,'')) 
      and not(string(.) ='BOOLEAN' ) 
      and not(starts-with(string(.),'ISO ')) and 
      not(string(.) ='.TRUE.' )  and 
      not(name(preceding-sibling::*[2]) ='subtype-template' or  
      name(preceding-sibling::*[2]) ='supertype-template' or
      name(preceding-sibling::*[2]) ='mapping-of') ">
      !! UPPERCASE Not expected: <xsl:value-of select="." /> !!<br/>
    </xsl:if>    
    <xsl:choose>
      <xsl:when test="string-length(.) != string-length(translate(.,$UPPER,'')) and 
        ( name(preceding-sibling::*[2]) ='subtype-template' or  
        name(preceding-sibling::*[2]) ='supertype-template') " >
        <!-- is a subtype or supertype template so ignore -->
        <!-- could check it is found in ARMs ??? -->
      </xsl:when>
      <xsl:when test="string-length(.) != string-length(translate(.,$UPPER,'')) and 
        ( name(preceding-sibling::*[2]) ='mapping-of' ) " >
        <!-- is a MAPPING_OF so ignore -->
        <!-- could check it is found in ARMs ??? -->
      </xsl:when>
      <xsl:when test="string-length(.) = 1 and not (contains($NUMBERS,.))" >
        <xsl:choose>
          <xsl:when test="name(preceding-sibling::*[1]) ='start-bracket' and 
            name(following-sibling::*[1]) ='end-bracket' ">
          </xsl:when>
          <xsl:when test=".='/' and name(preceding-sibling::*[1]) ='end-paren' and 
            contains('ABCDEFGHIJKLMNOPQRSTUVWXYZ', substring(preceding-sibling::*[2],1,1))" >
            <!-- matches preceding SUPERTYPE() or SUBTYPE template -->
          </xsl:when>
          <xsl:when test="name(preceding-sibling::*[1]) ='start-paren' and 
            following-sibling::*[1]='MAPPING_OF'">
            <!-- matches (/MAPPING_OF  -->
          </xsl:when>
          <xsl:when test="name(preceding-sibling::*[1]) ='end-paren' and 
            name(preceding-sibling::*[3]) ='MAPPING_OF'">
            <!-- matches MAPPING_OF(State_definition)/  -->
            <xsl:message>MAPPING_OF(State_definition)/</xsl:message>
          </xsl:when>
          <xsl:when test=".='!'"/><!-- MWD -->
          <xsl:when test=".='|'"/>
          <xsl:otherwise>
            <!-- ?? Possible syntax ERROR: <xsl:value-of select="." /> !! -->
            <xsl:call-template name="error_message">
              <xsl:with-param name="inline" select="'yes'"/>
              <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
	      <xsl:with-param name="message" select="concat('Error Map17: Possible syntax ERROR: ',name(preceding-sibling::*[1]),' ',.,' ',name(following-sibling::*[1]))"/>
            </xsl:call-template>    
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="string-length(.) != string-length(translate(.,'&gt;&lt;-',''))" >
	      <!--        <xsl:copy-of select="."/> -->
        <!-- ?? Possible syntax ERROR: <xsl:value-of select="." /> !! -->
        <xsl:call-template name="error_message">
          <xsl:with-param name="inline" select="'yes'"/>
          <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
          <xsl:with-param 
            name="message" 
            select="concat('Error Map24: Possible syntax ERROR: ',.)"/>
        </xsl:call-template>    
      </xsl:when>
      <xsl:when test="contains($LOWER,substring(.,1,1)) and contains(.,'.')" >
        <!-- most likely an attribute reference so check for existence 
          Could check for preceding and following symbols   ???? to do ????-->
        <xsl:variable name="find-ent" select="substring-before(normalize-space(.),'.')" />
        <xsl:variable name="find-attr" select="substring-after(normalize-space(.),'.')" />
        <xsl:variable name="found-ent" select="exslt:node-set($schemas)//entity[@name=$find-ent][explicit/@name=$find-attr]" />
        <xsl:choose>
          <xsl:when test="$found-ent" >
            <!--<xsl:value-of select="." /> found in schema 
	    <xsl:value-of select="$found-ent/ancestor::schema/@name" />
            <br/>-->
          </xsl:when>
          <xsl:otherwise>            
            <!-- check for derived attribute -->
            <xsl:variable name="found-derived" select="$schemas//entity[@name=$find-ent][derived/@name=$find-attr]" />
            <xsl:choose>
              <xsl:when test="$found-derived" >
                <!--<xsl:value-of select="." /> found as derived attribute in relevant schemas <xsl:value-of select="$found-derived/ancestor::schema/@name" />
                <br/> MWD -->
              </xsl:when>
              <xsl:otherwise>
                <!-- check for inverse attribute -->
                <xsl:variable name="found-inverse" select="$schemas//entity[@name=$find-ent][inverse/@name=$find-attr]" />
                <xsl:choose>
                  <xsl:when test="$found-inverse" >
                    <!--<xsl:value-of select="." /> found as inverse attribute in relevant schemas <xsl:value-of select="$found-inverse/ancestor::schema/@name" />
                    <br/> MWD-->
                  </xsl:when>
                  <xsl:otherwise>
                    <!--	!!! <xsl:value-of select="." /> not found in relevant schemas !!! -->
                    <xsl:call-template name="error_message">
                      <xsl:with-param name="inline" select="'yes'"/>
                      <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
                      <xsl:with-param name="message" select="concat('Error Map25B: ',., ' not found in relevant schemas')"/>
                    </xsl:call-template>
                    <!--<xsl:value-of select="$schemas"/>-->
                    <!--<xsl:copy-of select="exslt:node-set($schemas)"/>-->
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when
        test="name(./preceding-sibling::*[1])='start-paren' and  ./preceding-sibling::*[2]='MAPPING_OF'">
        !! Check that <xsl:value-of select="."/> is in the ARM and in the extended select !!
      </xsl:when>
      <xsl:when test="not(preceding-sibling::word) or
        (not(contains(.,'.'))) and string-length(translate(.,'1234567890. ',''))>0 " >
        <!-- most likely an entity reference so check for existence -->
        <xsl:variable name="find-ent" select="normalize-space(.)" />
        <xsl:variable name="found-ent" select="$schemas//*[@name=$find-ent][contains('entity type',name())]" />
        <!--<br/>-->
        <xsl:choose>
          <xsl:when test="$found-ent" >
            <!--<xsl:value-of select="concat(.,' ',name($found-ent),' ')" /> found in schema 
            <xsl:value-of select="$found-ent/ancestor::schema/@name" />
            <br/>-->
          </xsl:when>
          <xsl:when test=".='MAPPING_OF'">
            <xsl:variable name="mapped_to_ARM_entity_name" select="./following-sibling::*[2]"/>
            <xsl:choose>
              <xsl:when
                test="$arm_node//entity[@name=$mapped_to_ARM_entity_name] 
                | $arm_node//typename[@name=$mapped_to_ARM_entity_name] 
                | $arm_node//type/select[contains(concat(' ',@selectitems,' '),concat(' ',$mapped_to_ARM_entity_name,' '))]
                ">
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="error_message">
                  <xsl:with-param name="inline" select="'yes'"/>
                  <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
                  <xsl:with-param 
                    name="message" 
                    select="concat('Error MappingOf01:
                    ',$mapped_to_ARM_entity_name,' is not an ARM ENTITY type or referenced within the arm ')"/>
                </xsl:call-template>    
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <!--<xsl:when test="(substring(., 1, 1) = $apos) and (substring(., string-length()) = $apos)">-->
          <xsl:when test="substring(., 1, 1) = $apos">
            <!-- it's a string so don't look for it in the MIMs -->
          </xsl:when>
	  <xsl:when test="string(.) = 'BOOLEAN'">
            <!-- Can be mapped to a BOOLEAN -->
          </xsl:when>
 
          <xsl:otherwise>
            <!--			!!! <xsl:value-of select="." /> not found in relevant schemas !!! -->
            <xsl:call-template name="error_message">
              <xsl:with-param name="inline" select="'yes'"/>
              <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
              <xsl:with-param 
                name="message" 
                select="concat('Error Map26: ',.,' not found in relevant schemas')"/>
            </xsl:call-template>    
            </xsl:otherwise>  
        </xsl:choose>
        
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="is-extended-by" mode="test"><!-- MWD new template added -->
    <xsl:param name="schemas" />	
    <!-- test that types are properly related -->  
    <xsl:variable name="based-on-type" select="string(preceding-sibling::*[not(name() ='new-line')][1])" />
    <xsl:variable name="derived-type" select="string(following-sibling::*[not(name() ='new-line')][1])" />
    <!--AAA<xsl:value-of select="$based-on-type"/>BBB<xsl:value-of select="$derived-type"/>CCC MWD -->
    <xsl:choose>
      <xsl:when test="not($based-on-type)" >
        NO type specified at start of reference path !!! <br/>
      </xsl:when>
      <xsl:when test="not($schemas//type[@name=$derived-type][select/@basedon=$based-on-type])" >
        <!--			TYPE <xsl:value-of select="$derived-type"/> not found 
          or not based on <xsl:value-of select="$based-on-type"/> !!! <br/> 
        -->
        <xsl:call-template name="error_message">
          <xsl:with-param name="inline" select="'yes'"/>
          <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
          <xsl:with-param 
            name="message" 
            select="concat('Error Map32: TYPE ',$derived-type,
            ' not found or not based on ',$based-on-type)"/>
        </xsl:call-template>    
      </xsl:when>
      <xsl:otherwise>
        <!-- <br/>
        TYPE <xsl:value-of select="$derived-type"/> found 
        and based on <xsl:value-of select="$based-on-type"/>
        <br/> MWD	-->	
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="extends" mode="test"><!-- MWD new template added -->
    <xsl:param name="schemas" />	
    <!-- test that types are properly related -->
    <xsl:variable name="based-on-type" select="string(following-sibling::*[not(name() ='new-line')][1])" />
    <xsl:variable name="derived-type" select="string(preceding-sibling::*[not(name() ='new-line')][1])" />
    <xsl:choose>
      <xsl:when test="not($derived-type)" >
        NO type specified at start of reference path !!! <br/>
      </xsl:when>
      <xsl:when test="not($schemas//type[@name=$derived-type][select/@basedon=$based-on-type])" >
        <!--			TYPE <xsl:value-of select="$derived-type"/> not found 
          or not based on <xsl:value-of select="$based-on-type"/> !!! <br/> 
        -->
        <xsl:call-template name="error_message">
          <xsl:with-param name="inline" select="'yes'"/>
          <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
          <xsl:with-param 
            name="message" 
            select="concat('Error Map33: TYPE ',$derived-type,
            ' not found or not based on ',$based-on-type)"/>
        </xsl:call-template>    
      </xsl:when>
      <xsl:otherwise>
        <!--<br/>
        TYPE <xsl:value-of select="$derived-type"/> found 
        and based on <xsl:value-of select="$based-on-type"/>
        <br/> MWD -->		
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="is-supertype-of | is-subtype-of" mode="test"><!-- MWD new template added -->
    <xsl:param name="schemas" />	
    <xsl:variable name="first" select="string(preceding-sibling::word[1])" />
    <xsl:variable name="map" select="name(following-sibling::*[3])"/>
    <xsl:variable name="second">
      <xsl:choose>
        <xsl:when test="name(following-sibling::*[not(name() ='new-line')][1])='start-constraint'" >
          <xsl:value-of select="string(following-sibling::word[preceding-sibling::end-constraint][1])" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="string(following-sibling::word[1])" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$map = 'mapping-of'">
        <!-- don't generate error message -->
      </xsl:when>
      <xsl:when test="name()='is-supertype-of'">
        
        <xsl:choose>
          <xsl:when test="name(following-sibling::*[not(name() ='new-line')][1])='subtype-template'">
            <!-- could check to see if valid arm entity 
              but for now do nothing ??? -->
          </xsl:when>
          <xsl:when test="not($schemas//entity[@name=$second]
            [contains(concat(' ',@supertypes,' '),concat(' ',$first,' '))])" >
            <xsl:call-template name="error_message">			
              <xsl:with-param name="inline" select="'yes'"/>
              <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
              <xsl:with-param 
                name="message" 
                select="concat('Error Map34: ERROR in subtyping in PATH: ', $first,
                ' is not a supertype of ',$second)"/>
            </xsl:call-template>    
          </xsl:when>
          <xsl:otherwise>
            <!-- <br/>			
            <xsl:value-of select="concat( $first,
              ' is a supertype of ',$second)" />	-->				
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="name()='is-subtype-of'">
        <xsl:choose>
          <xsl:when test="name(following-sibling::*[not(name() ='new-line')][1])='subtype-template'">
            <!-- could check to see if valid arm entity 
              but for now do nothing ??? -->
          </xsl:when>
          <xsl:when test="not($schemas//entity[@name=$first]
            [contains(concat(' ',@supertypes,' '),concat(' ',$second,' '))])" >
            <xsl:call-template name="error_message">			
              <xsl:with-param name="inline" select="'yes'"/>
              <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
              <xsl:with-param 
                name="message" 
                select="concat('Error Map35: ERROR in subtyping in PATH: ', $first,
                ' is not a subtype of ',$second)"/>
            </xsl:call-template>    				
          </xsl:when>
          <xsl:otherwise>
          <!-- Commented out in response to Comment 8 of bug 5525
		       <br/>			
            <xsl:value-of select="concat($first,
	      ' is a subtype of ',$second)" /> 
           -->					
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="equals" mode="test"><!-- MWD new template added -->
    <xsl:param name="schemas" />	
    <!-- test that types are properly related -->
    <xsl:variable name="first" select="string(preceding-sibling::*[not(name() ='new-line')][1])" />
    <xsl:variable name="second" select="string(following-sibling::*[not(name() ='new-line')][1])" />
    <xsl:choose>
      <xsl:when test="name(following-sibling::*[1])='quote'" > 
        <!-- do nothing - just eliminate the possibility that test is on a quoted string -->
      </xsl:when>
      <xsl:when test="name(following-sibling::*[1])='equals'" >
        <xsl:call-template name="error_message">
          <xsl:with-param name="inline" select="'yes'"/>
          <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
          <xsl:with-param 
            name="message" 
            select="'Error Map55: Syntax error: Repeated = '"/>
        </xsl:call-template>    
      </xsl:when>
      <xsl:when test="name(preceding-sibling::*[1])='end-bracket'" >
        <!-- do nothing - just eliminate the possibility that test is on aggregate member -->
      </xsl:when>
      <xsl:when test="contains(concat($first,$second),'.')" >
        <!-- do nothing - just eliminate the possibility that test is on an attribute -->
      </xsl:when>
      <xsl:when test="string-length(translate($second,'0123456789.','')) = 0 " >
        <!-- do nothing - just eliminate the possibility that test is on a number -->
      </xsl:when>
      <xsl:when test="not($first or $second)" >
        <!-- Probable syntax error!!! <br/> -->
      </xsl:when>
      <xsl:when test="$mim_node//type[@name=$first][select/@basedon]" >
        <!-- check that second is contained in selectitems list -->
        <xsl:choose>
          <xsl:when test="not($mim_node//type[@name=$first]/select[
            contains(concat(' ',@selectitems,' '),
            concat(' ',$second,' '))])" >
            <xsl:call-template name="error_message">
              <xsl:with-param name="inline" select="'yes'"/>
              <xsl:with-param name="warning_gif" select="'../../../../images/warning.gif'"/>
              <xsl:with-param 
                name="message" 
                select="concat('Error Map36: TYPE ',$first,
                ' does not include ',$second,' as select item')"/>
            </xsl:call-template>    
          </xsl:when>
          <xsl:otherwise>
           <!-- <br/>
            TYPE <xsl:value-of select="$first"/> includes 
            <xsl:value-of select="$second"/> as select item 
            <br/> MWD -->
          </xsl:otherwise>
        </xsl:choose>	
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="depends-on-recurse-mim-x-2" ><!-- MWD new template added -->
    <xsl:param name="todo" select="' '"/>
    <xsl:param name="done" />
    <!--
      For each interfaced schema:
      Check if not already done
      Otherwise output and add to todo
    -->
    <xsl:variable name="this-schema" select="substring-before(concat(normalize-space($todo),' '),' ')" />
    <xsl:if test="$this-schema" >
      <!-- open up the relevant schema  - which can be a resource or a mim schema -->
      <xsl:variable name="file_name" >
        <xsl:choose>
          <xsl:when test="function-available('exslt:node-set')" >
            <xsl:choose>
              <xsl:when test="substring-before($this-schema,'_mim')" >
                <xsl:value-of select="concat('../data/modules/',substring-before($this-schema,'_mim'),'/mim.xml')" />
              </xsl:when>
              <xsl:when test="substring-before($this-schema,'_schema')" >
                <xsl:value-of select="concat('../data/resources/',$this-schema,'/',$this-schema,'.xml')" />
              </xsl:when>
              <xsl:when test="starts-with($this-schema,'aic_')" >
                <xsl:value-of select="concat('../data/resources/',$this-schema,'/',$this-schema,'.xml')" />
              </xsl:when>
              <xsl:otherwise>
                BAD SCHEMA name !!! <xsl:value-of select="$this-schema"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test="not(contains($done,concat(' ',$this-schema,' ')))" >
        <x><xsl:value-of select="translate($file_name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
          'abcdefghijklmnopqrstuvwxyz')" /></x>
      </xsl:if>
      <xsl:variable name="mim-node"
        select="document($file_name)/express"/>
      <!-- get the list of schemas for this level that have not already been done -->
      <xsl:variable name="my-kids" >
        <xsl:if test="not(contains($done,concat(' ',$this-schema,' ')))" >
          <xsl:apply-templates select="$mim-node//interface" mode="interface-schemas" >
            <xsl:with-param name="done" select="$done" />
          </xsl:apply-templates>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="after" select="normalize-space(concat(substring-after($todo, $this-schema),$my-kids))" />
      <xsl:if test="$after" >
        <xsl:call-template name="depends-on-recurse-mim-x-2">
          <xsl:with-param name="todo" select="$after" />
          <xsl:with-param name="done" select="concat($done,' ',$this-schema,' ')" />
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>

