<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="./document_xsl.xsl" ?>

<!--
$Id: sect_5_mapping_check.xsl,v 1.14 2003/10/28 06:37:19 robbod Exp $
  Author:  Rob Bodington, Nigel Shaw Eurostep Limited
  Owner:   Developed by Eurostep in conjunction with PLCS Inc
  Purpose:
     
-->
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:saxon="http://icl.com/saxon"
  extension-element-prefixes="msxsl saxon"
  exclude-result-prefixes="msxsl saxon"
  version="1.0">

  <!-- the SAXON and MSXML proprietary extensions are for node-set -->

  <!-- checks all the ARM entities are mapped -->
<xsl:template match="mapping_table" mode="check_all_arm_mapped">
  <xsl:variable name="module_dir">
    <xsl:call-template name="module_directory">
      <xsl:with-param name="module" select="/module/@name"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="ae_nodes" select="./ae"/>
  <xsl:variable name="aa_nodes" select="./ae//aa"/>

  <xsl:for-each
    select="document(concat($module_dir,'/arm.xml'))/express/schema/entity">
    <xsl:variable name="entity" select="@name"/>
    <xsl:variable name="ae_node" select="$ae_nodes[@entity=$entity]"/>
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
  <xsl:variable name="refpath">
    <xsl:variable name="ent" select="../@entity"/>
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
        <xsl:when test="function-available('saxon:node-set')">
          <xsl:value-of select="saxon:node-set($refpath)"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <!--    -{<xsl:value-of select="$refpath_nodes/refpath/NEW"/>}- -->
</xsl:template>


<xsl:template name="parse-refpath">
  <xsl:param name="path"/>
  <xsl:param name="previous"/>
  
  <xsl:choose>
    <xsl:when test="contains($path,' ')">
      <!-- get first word and process -->
      
      <xsl:call-template name="process-word">
        <xsl:with-param name="word" select="substring-before($path,' ')"/>
        <xsl:with-param name="previous" select="$previous"/>
      </xsl:call-template>
      
      
      <!-- recurse using remainder of string -->
      
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
  
</xsl:template>

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
    <xsl:when test="$first-char='*'">
      <xsl:text> * </xsl:text>
    </xsl:when>
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
  <xsl:param name="previous"/>
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


</xsl:stylesheet>

